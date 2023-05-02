import 'package:flutter/material.dart';

class UiConfig {
  UiConfig._internal();

  static Color get _primaryColor => const Color(0xFF5C77CE);

  static ThemeData get theme => ThemeData(
        fontFamily: 'Mandali',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24),
        ),
        primaryColor: _primaryColor,
        primaryColorLight: const Color(0xFFABC8F7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
          ),
        ),
      );
}
