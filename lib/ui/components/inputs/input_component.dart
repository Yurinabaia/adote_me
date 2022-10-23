import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/utils/text_mask.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class InputComponent extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String labelTextValue;
  final bool isActive;
  final TextMask? textMask;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool isPassword;
  bool iconError;
  ValueNotifier<GlobalKey<FormState>> formKey =
      ValueNotifier(GlobalKey<FormState>());
  InputComponent({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.textMask,
    this.isRequired = true,
    this.iconError = false,
    this.validator,
    required this.labelTextValue,
    this.isActive = true,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[700]!,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: widget.labelTextValue,
        labelStyle: const TextStyle(
          color: Color(0xff334155),
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
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: widget.iconError
            ? const Icon(
                Icons.error,
                color: Colors.red,
              )
            : null,
        enabled: widget.isActive,
        filled: true,
        fillColor: widget.isActive ? Colors.white : Colors.grey[100],
      ),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.textMask?.maskTexFormated(),
      onChanged: (value) {
        final formKeyProvider = context.read<FormKeyProvider>();
        widget.formKey.value = formKeyProvider.get();
        widget.formKey.value.currentState!.validate();
        if (value.isEmpty && widget.isRequired) {
          setState(() {
            widget.iconError = true;
          });
        } else {
          setState(() {
            widget.iconError = false;
          });
        }
      },
      validator: widget.validator,
    );
  }
}
