import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.enabled,
    required this.readOnly,
    this.controller,
    required this.obscureText,
    this.keyboardType,
    this.autovalidateMode,
    this.validator,
    this.onTap,
    this.onChanged,
  });

  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final bool? enabled;
  final bool readOnly;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        helperText: helperText,
      ),
      enabled: enabled,
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
