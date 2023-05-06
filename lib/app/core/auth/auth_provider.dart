import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/navigator/custom_navigator.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_page.dart';
import 'package:todo_list_provider/app/modules/home/home_page.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(
    this._firebaseAuth,
    this._userService,
  );

  final FirebaseAuth _firebaseAuth;

  final UserService _userService;

  Future<void> logout() => _userService.logout();

  User? get user => _firebaseAuth.currentUser;

  void loadListeners() {
    _firebaseAuth.userChanges().listen((_) => notifyListeners());
    _firebaseAuth.idTokenChanges().listen(
          (user) => CustomNavigator.to.pushNamedAndRemoveUntil(
            user != null ? HomePage.routeName : LoginPage.routeName,
            (_) => false,
          ),
        );
  }
}
