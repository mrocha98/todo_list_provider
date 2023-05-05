import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list_provider/app/core/ui/custom_icons_icons.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    required this.label,
    super.key,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.autofocus = false,
    this.inputFormatters,
    this.enabled,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.textInputAction,
    this.focusNode,
  }) : assert(
          (obscureText && suffixIcon == null) || !obscureText,
          'cannot have a suffixIcon and obscure text at same time',
        );

  final String label;

  final TextInputType? keyboardType;

  final Icon? suffixIcon;

  final bool obscureText;

  final TextEditingController? controller;

  final FormFieldValidator<String>? validator;

  final bool autofocus;

  final List<TextInputFormatter>? inputFormatters;

  final bool? enabled;

  final void Function(String)? onChanged;

  final VoidCallback? onEditingComplete;

  final void Function(String)? onFieldSubmitted;

  final bool readOnly;

  final TextInputAction? textInputAction;

  final FocusNode? focusNode;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final ValueNotifier<bool> _obscureTextVN;

  @override
  void initState() {
    super.initState();
    _obscureTextVN = ValueNotifier(widget.obscureText);
  }

  @override
  void dispose() {
    _obscureTextVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureTextVN,
      builder: (_, obscureTextValue, child) => TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red),
          ),
          isDense: true,
          suffixIcon: widget.suffixIcon ??
              (widget.obscureText
                  ? ExcludeFocus(
                      child: IconButton(
                        onPressed: () =>
                            _obscureTextVN.value = !obscureTextValue,
                        icon: obscureTextValue
                            ? const Icon(CustomIcons.eye)
                            : const Icon(CustomIcons.eyeSlash),
                      ),
                    )
                  : null),
        ),
        obscureText: obscureTextValue,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        validator: widget.validator,
        autofocus: widget.autofocus,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
      ),
    );
  }
}
