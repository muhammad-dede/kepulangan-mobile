import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorExceptionWidget extends StatelessWidget {
  const ErrorExceptionWidget({
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
            'assets/lotties/error.json',
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
