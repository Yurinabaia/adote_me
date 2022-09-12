import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextAreaComponent extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;
  final bool isRequired;
  final String? Function(String?)? validator;

  const TextAreaComponent({
    Key? key,
    required this.controller,
    this.isRequired = true,
    this.maxLength = 255,
    this.validator,
  }) : super(key: key);

  @override
  State<TextAreaComponent> createState() => _TextAreaComponentState();
}

class _TextAreaComponentState extends State<TextAreaComponent> {
  ValueNotifier<GlobalKey<FormState>> formKey =
      ValueNotifier(GlobalKey<FormState>());
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Escreva aqui...',
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
      maxLength: widget.maxLength,
      onChanged: (value) {
        final formKeyProvider = context.read<FormKeyProvider>();
        formKey.value = formKeyProvider.get();
        formKey.value.currentState!.validate();
        setState(() {});
      },
      validator: widget.validator,
    );
  }
}
