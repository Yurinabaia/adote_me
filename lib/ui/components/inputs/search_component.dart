import 'package:adoteme/utils/text_mask.dart';
import 'package:flutter/material.dart';

class SearchComponent extends StatelessWidget {
  final TextInputType keyboardType;
  final String? initTextValue;
  final String labelTextValue;
  final Function? onChanged;
  final TextMask? textMask;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const SearchComponent(
      {Key? key,
      this.initTextValue,
      this.onChanged,
      this.textMask,
      required this.keyboardType,
      required this.labelTextValue,
      this.controller,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initTextValue,
      decoration: InputDecoration(
        labelText: labelTextValue,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        //errorText: 'Error message',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
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
          color: Theme.of(context).primaryColor,
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
      inputFormatters: textMask?.maskTexFormated(),
      validator: validator,
    );
  }
}
