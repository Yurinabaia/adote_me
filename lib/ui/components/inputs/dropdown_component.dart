import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropDownComponent extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final List<String> items;
  final bool isRequired;
  const DropDownComponent({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isRequired = true,
    required this.items,
  }) : super(key: key);
  @override
  State<DropDownComponent> createState() => _DropDownComponentState();
}

class _DropDownComponentState extends State<DropDownComponent> {
  ValueNotifier<GlobalKey<FormState>> formKey =
      ValueNotifier(GlobalKey<FormState>());
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[700]!,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[700]!,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          //<-- SEE HERE
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          //<-- SEE HERE
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        labelText: widget.labelText,
      ),
      borderRadius: BorderRadius.circular(10),
      dropdownColor: Colors.white,
      onChanged: (String? newValue) {
        final formKeyProvider = context.read<FormKeyProvider>();
        formKey.value = formKeyProvider.get();
        formKey.value.currentState!.validate();
        setState(() {
          widget.controller.text = newValue!;
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
      validator: (value) {
        if (widget.isRequired) {
          return value != null ? null : 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
