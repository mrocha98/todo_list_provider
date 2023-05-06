import 'package:flutter/material.dart';

class CustomNavigator {
  CustomNavigator._internal();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get to => navigatorKey.currentState!;
}
