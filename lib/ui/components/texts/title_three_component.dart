import 'package:flutter/material.dart';

class TitleThreeComponent extends StatelessWidget {
  final String text;

  const TitleThreeComponent({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xff334155),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
