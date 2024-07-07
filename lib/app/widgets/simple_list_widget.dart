import 'package:flutter/material.dart';

class SimpleListWidget extends StatelessWidget {
  const SimpleListWidget({
    super.key,
    this.onTap,
    this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final void Function()? onTap;
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: Text(title ?? ""),
        subtitle: Text(
          subtitle ?? "",
          overflow: TextOverflow.ellipsis,
        ),
        trailing: trailing,
      ),
    );
  }
}
