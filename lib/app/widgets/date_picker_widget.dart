import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    super.key,
    this.labelText,
    this.helperText,
    this.controller,
    this.autovalidateMode,
    this.validator,
    this.onTap,
  });

  final String? labelText;
  final String? helperText;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: const Icon(Icons.calendar_month),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        helperText: helperText,
      ),
      readOnly: true,
      controller: controller,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onTap: onTap,
    );
  }
}
