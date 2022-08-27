import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  final String? initTextValue;
  final String labelTextValue;
  final bool isActive;
  const InputComponent({
    Key? key,
    this.initTextValue,
    required this.labelTextValue,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initTextValue,
      decoration: InputDecoration(
        labelText: labelTextValue,
        labelStyle: const TextStyle(
          color: Color(0xff334155),
        ),
        //errorText: 'Error message',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        // suffixIcon: Icon(
        //   Icons.error,
        // ),
        enabled: isActive,
        filled: true,
        fillColor: isActive ? Colors.white : Colors.grey[100],
      ),
    );
  }
}
