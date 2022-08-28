import 'package:flutter/material.dart';

class BodyTextComponent extends StatelessWidget {
  final String text;
  final bool selectedText;
  const BodyTextComponent({
    Key? key,
    required this.text,
    this.selectedText = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: selectedText ? Colors.white : const Color(0xff334155),
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
