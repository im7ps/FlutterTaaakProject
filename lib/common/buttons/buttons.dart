import 'package:flutter/material.dart';


class ButtonBaseText extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const ButtonBaseText(
      {
        required this.onPressed,
        required this.buttonText,
        super.key,
      }
    );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Text(buttonText),
    );
  }
}