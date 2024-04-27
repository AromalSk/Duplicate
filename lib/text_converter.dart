import 'package:flutter/material.dart';
import 'package:sample_fitpage/clickable.dart';

class TextCoverter extends StatelessWidget {
  const TextCoverter({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    String replace;
    replace = textconverter();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GestureDetector(onTap: () {}, child: Text(text)),
          ClickableText(
            text: replace,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  textconverter() {
    List<int> values = [2, 1, 3, 5];

    String replacedText = text.replaceAllMapped(
      RegExp(r'\$1'),
      (match) => '(${values[3]})', // Replace $1 with values from the list
    );

    return replacedText;
  }
}
