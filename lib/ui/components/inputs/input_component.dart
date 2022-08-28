import 'package:adoteme/utils/text_mask.dart';
import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String labelTextValue;
  final bool isActive;
  final TextMask textMask;
  final bool isRequired;
  const InputComponent({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.textMask,
    this.isRequired = true,
    required this.labelTextValue,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
      keyboardType: keyboardType,
      inputFormatters: textMask.maskTexFormated(),
      validator: (value) {
        if ((value == null || value.isEmpty) && isRequired) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
