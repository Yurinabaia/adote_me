import 'package:flutter/material.dart';

class TextareaComponent extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  const TextareaComponent(
      {Key? key, required this.controller, 
      required this.hint, 
      this.maxLength = 255,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textAlign: TextAlign.start,
      maxLength: maxLength,
    );
  }
}
