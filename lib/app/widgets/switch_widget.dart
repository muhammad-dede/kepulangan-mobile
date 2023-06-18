import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  const SwitchWidget({
    Key? key,
    required this.labelText,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String labelText;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Switch(
          value: value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: onChanged,
        )
      ],
    );
  }
}
