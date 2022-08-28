import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextMask {
  final String typeDataMask;
  TextMask(this.typeDataMask);

  //Tipos de mascaras:
  final maskCEP = MaskTextInputFormatter(
      mask: '########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final maskTel = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  List<TextInputFormatter>? maskTexFormated() {
    if (typeDataMask == 'CEP') {
      return [maskCEP];
    }
    if (typeDataMask == 'Tel') {
      return [maskTel];
    }
    return null;
  }
}
