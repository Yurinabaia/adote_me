import 'package:flutter/material.dart';

class TermDescriptionComponent extends StatelessWidget {
  final String term;
  final String description;

  const TermDescriptionComponent({
    Key? key,
    required this.term,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "$term: ",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff334155),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xff64748B),
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
