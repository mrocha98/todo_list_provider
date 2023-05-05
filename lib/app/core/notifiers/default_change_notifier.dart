import 'package:flutter/material.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  String? error;

  bool get hasError => error != null;

  bool _success = false;

  bool get isSuccess => _success;

  void showLoading() => _loading = true;

  void hideLoading() => _loading = false;

  void success() => _success = true;

  void resetState() {
    _success = false;
    error = null;
  }

  void showLoadingAndResetState() {
    resetState();
    showLoading();
  }
}
