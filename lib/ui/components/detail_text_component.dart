import 'package:flutter/material.dart';

class DetailTextComponent extends StatelessWidget {
  final String text;
  const DetailTextComponent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xff334155),
      ),
    );
  }
}
