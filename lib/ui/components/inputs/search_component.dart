import 'package:adoteme/utils/text_mask.dart';
import 'package:flutter/material.dart';

class SeachComponent extends StatelessWidget {
  final TextInputType keyboardType;
  final String? initTextValue;
  final String labelTextValue;
  final Function? onChanged;
  final TextMask textMask;
  final bool isError;
  final String errorMessage;
  const SeachComponent(
      {Key? key,
      this.initTextValue,
      this.onChanged,
      required this.textMask,
      required this.keyboardType,
      required this.labelTextValue,
      this.isError = false,
      this.errorMessage = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initTextValue,
      decoration: InputDecoration(
        labelText: labelTextValue,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        //errorText: 'Error message',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          Icons.search,
          size: 30,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      onChanged: (value) => {
        if (onChanged != null)
          {
            onChanged!(value),
          }
      },
      inputFormatters: textMask.maskTexFormated(),
      validator: (value) {
        return isError ? errorMessage : null;
      },
    );
  }
}
