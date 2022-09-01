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

  final maskIdadeAnimal = MaskTextInputFormatter(
      mask: '###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final maskCell = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  List<TextInputFormatter>? maskTexFormated() {
    switch (typeDataMask) {
      case 'CEP':
        return [maskCEP];
      case 'CELL':
        return [maskCell];
      case 'IDADE_ANIMAL':
        return [maskIdadeAnimal];
      default:
        return null;
    }
  }
}
