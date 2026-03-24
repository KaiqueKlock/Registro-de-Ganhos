class Validator {
  static String? validateValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira um valor';
    }

    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return 'Número inválido';
    }

    final parsedDigits = double.tryParse(digits);
    if (parsedDigits == null) {
      return 'Número inválido';
    }

    final parsedValue = parsedDigits / 100;

    if (parsedValue <= 0) {
      return 'O valor deve ser maior que zero';
    }
    if (parsedValue > 1000000) {
      return 'Valor máximo permitido é 1.000.000';
    }

    return null;
  }
}
