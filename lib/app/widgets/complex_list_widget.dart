import 'package:flutter/material.dart';

class ComplexListWidget extends StatelessWidget {
  const ComplexListWidget({
    Key? key,
    this.headerLeftText,
    this.headerRightText,
    this.onTap,
    this.leading,
    this.titleText,
    this.subTitleText,
    this.trailing,
    this.footerLeftText,
    this.footerRightText,
  }) : super(key: key);

  final String? headerLeftText;
  final String? headerRightText;
  final void Function()? onTap;
  final Widget? leading;
  final String? titleText;
  final String? subTitleText;
  final Widget? trailing;
  final String? footerLeftText;
  final String? footerRightText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (headerLeftText != null || headerRightText != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(headerLeftText ?? ""),
                      Text(headerRightText ?? ""),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 0),
                ),
              ],
            ),
          ListTile(
            onTap: onTap,
            leading: leading,
            title: Text(titleText ?? ""),
            subtitle: Text(
              subTitleText ?? "",
              overflow: TextOverflow.ellipsis,
            ),
            trailing: trailing,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 0),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(footerLeftText ?? ""),
                Text(footerRightText ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
