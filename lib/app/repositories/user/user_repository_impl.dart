import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exceptions/exceptions.dart';

import 'package:todo_list_provider/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e, st) {
      log('UserRepositoryImpl.register error', error: e, stackTrace: st);
      if (e.code == 'email-already-in-use') {
        final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(
          email,
        );
        final message = loginTypes.contains('password')
            ? 'E-mail já utilizado'
            : 'Você já se cadastrou com o Google';
        throw AuthException(message: message);
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on PlatformException catch (e, st) {
      log(
        'UserRepositoryImpl.login platform exception',
        error: e,
        stackTrace: st,
      );
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (e, st) {
      log('UserRepositoryImpl.login auth error', error: e, stackTrace: st);
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw AuthException(message: 'Login ou senha inválidos');
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(message: 'Cadastro realizado com Google');
      }
    } on PlatformException catch (e, st) {
      log(
        'UserRepositoryImpl.forgotPassword platform error',
        error: e,
        stackTrace: st,
      );
      throw AuthException(message: 'Erro ao resetar senhar');
    } on FirebaseAuthException catch (e, st) {
      log('UserRepositoryImpl.login auth error', error: e, stackTrace: st);
      if (e.code == 'auth/user-not-found') return;
      throw AuthException(message: 'Email inválido');
    }
  }

  @override
  Future<User?> googleLogin() async {
    var loginMethods = <String>[];
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
          googleUser.email,
        );
        if (loginMethods.contains('password')) {
          throw AuthException(message: 'Conta já cadastrada com e-mail');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final userCredential = await _firebaseAuth.signInWithCredential(
            firebaseCredential,
          );
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, st) {
      log(
        'UserRepositoryImpl.googleLogin firebase auth exception',
        error: e,
        stackTrace: st,
      );
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
          message: loginMethods.isEmpty
              ? 'Você já se registrou utilizando outro serviço'
              : 'Você já se registrou com os seguintes serviços:\n'
                  '${loginMethods.join(', ')}',
        );
      } else {
        throw AuthException(message: 'Erro ao registrar com Google');
      }
    }
    return null;
  }

  @override
  Future<void> googleLogout() async => Future.wait([
        GoogleSignIn().signOut(),
        _firebaseAuth.signOut(),
      ]);
}
