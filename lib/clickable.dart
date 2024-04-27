import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final Function() onTap;

  const ClickableText({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: 'hello',
          ),
          TextSpan(
            text: '\u{200B}', // Zero-width space character
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
