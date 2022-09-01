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
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        
      ),
      textAlign: TextAlign.start,
      maxLength: maxLength,
    );
  }
}
