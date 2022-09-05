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
  final bool isUrl;
  bool iconErro;
  ValueNotifier<GlobalKey<FormState>> formKey =
      ValueNotifier(GlobalKey<FormState>());
  InputComponent({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.textMask,
    this.isRequired = true,
    this.iconErro = false,
    this.isUrl = false,
    required this.labelTextValue,
    this.isActive = true,
  }) : super(key: key);

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
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
        suffixIcon: widget.iconErro
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
      // TODO: Definir onchanges e validadors personalizados
      onChanged: (value) {
        if (widget.isRequired || widget.isUrl) {
          if (value.isEmpty) {
            setState(() {
              widget.iconErro = true;
            });
          } else {
            final formKeyProvider = context.read<FormKeyProvider>();
            widget.formKey.value = formKeyProvider.get();
            widget.formKey.value.currentState!.validate();
            setState(() {
              widget.iconErro = false;
            });
          }
        }
      },
      validator: (value) {
        if ((value == null || value.isEmpty) && widget.isRequired) {
          setState(() {
            widget.iconErro = true;
          });
          return 'Campo obrigatório';
        }
        if (widget.isUrl) {
          if (!Uri.parse(value!).isAbsolute) return 'Url inválida';
        }
        setState(() {
          widget.iconErro = false;
        });
        return null;
      },
    );
  }
}
