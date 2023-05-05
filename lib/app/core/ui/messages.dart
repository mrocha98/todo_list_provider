import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';

class Messages {
  Messages._internal(this.context);

  factory Messages.of(BuildContext context) => Messages._internal(context);

  final BuildContext context;

  void _show(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void showError(String message) => _show(message, Colors.red);

  void showInfo(String message) => _show(message, context.primaryColor);
}
