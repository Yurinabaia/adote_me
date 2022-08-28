import 'package:flutter/material.dart';

class FormKeyProvider extends ChangeNotifier {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FormKeyProvider(this._formKey);

  set(formKey) {
    _formKey = formKey;
  }

  get() {
    return _formKey;
  }
}
