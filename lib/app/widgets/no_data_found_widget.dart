import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({
    Key? key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final String? text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/empty.json',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(text ?? ""),
            ),
          if (onPressed != null)
            IconButton(
              onPressed: onPressed,
              icon: const CircleAvatar(
                child: Icon(Icons.refresh, size: 30),
              ),
            ),
        ],
      ),
    );
  }
}
