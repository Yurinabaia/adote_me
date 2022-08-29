import 'package:flutter/material.dart';

class TitleThreeComponent extends StatelessWidget {
  final String text;

  const TitleThreeComponent({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Color(0xff334155),
      ),
      textAlign: TextAlign.center,
    );
  }
}
