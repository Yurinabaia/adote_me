import 'package:flutter/material.dart';

class LabelTextComponent extends StatelessWidget {
  final String text;
  const LabelTextComponent({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xff94a3b8),
      ),
    );
  }
}
