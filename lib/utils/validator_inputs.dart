class ValidatorInputs {
  static String? validatorText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  static String? validatorUrl(
      {required String value, bool isRequired = false}) {
    if (!isRequired && value.isEmpty) return null;
    if (!Uri.parse(value).isAbsolute) return 'Url inválida';
    return null;
  }

  static String? validatorCellPhone(String value) {
    if (value.length < 15 && value.isNotEmpty) return 'Celular Invalido';
    return null;
  }

  static String? validatorCep(bool isNotAddress, String value) {
    if (!isNotAddress) return null;
    if (isNotAddress || value.length != 8) return 'CEP inválido';
    return null;
  }
}
