import 'package:flutter/material.dart';

class IdPublicationProvider extends ChangeNotifier {
  String? _idPublication;
  IdPublicationProvider(this._idPublication);

  set(idPublication) {
    _idPublication = idPublication;
  }

  get() {
    return _idPublication;
  }
}
