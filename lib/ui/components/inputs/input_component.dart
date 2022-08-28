import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String labelTextValue;
  final bool isActive;
  const InputComponent({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.labelTextValue,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelTextValue,
        labelStyle: TextStyle(
          color: isActive ? Theme.of(context).primaryColor : Colors.black,
        ),
        //errorText: 'Error message',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        // suffixIcon: Icon(
        //   Icons.error,
        // ),
        enabled: isActive,
        filled: true,
        fillColor: isActive ? Colors.white : const Color(0xffdfe5ec),
      ),
      keyboardType: keyboardType,
    );
  }
}
