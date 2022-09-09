import 'package:flutter/material.dart';

class IdPublicationProvider extends ChangeNotifier {
  String _formKey = '';
  IdPublicationProvider(this._formKey);

  set(formKey) {
    _formKey = formKey;
  }

  get() {
    return _formKey;
  }
}
