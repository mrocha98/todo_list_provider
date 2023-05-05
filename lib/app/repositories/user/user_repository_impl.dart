import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
}
