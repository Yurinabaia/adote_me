import 'package:flutter/material.dart';

class BodyTextComponent extends StatelessWidget {
  final String text;
  final bool selectedText;
  final FontWeight fontWeight;
  const BodyTextComponent({
    Key? key,
    required this.text,
    this.selectedText = false,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: selectedText ? Colors.white : const Color(0xff334155),
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.start,
    );
  }
}
