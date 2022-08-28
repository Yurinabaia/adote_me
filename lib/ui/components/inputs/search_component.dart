import 'package:flutter/material.dart';

class SeachComponent extends StatelessWidget {
  final TextInputType keyboardType;
  final String? initTextValue;
  final String labelTextValue;
  const SeachComponent({
    Key? key,
    this.initTextValue,
    required this.keyboardType,
    required this.labelTextValue,
  }) : super(key: key);

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
        suffixIcon: Icon(
          Icons.search,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.text,
    );
  }
}
