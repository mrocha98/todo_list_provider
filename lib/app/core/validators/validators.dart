import 'package:flutter/material.dart';

class Validators {
  Validators._internal();

  static FormFieldValidator<String> compare(
    TextEditingController? valueEC,
    String message,
  ) =>
      (value) {
        if (value == null) return message;
        final valueCompare = valueEC?.text ?? '';
        if (value != valueCompare) return message;
        return null;
      };
}
