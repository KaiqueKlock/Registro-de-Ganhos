class Validator {

  static String? validateValue(String? value) {
                if (value == null || value.trim().isEmpty) {
                return 'Por favor, insira um valor';
              }
              final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

              final cleanedValue = value.replaceAll(',', '.').trim();
              final parsedValue = double.parse(digits) / 100;
         

              if ('.'.allMatches(cleanedValue).length > 3) {
              return 'Número inválido';
              }
              if (parsedValue <= 0) {
                return 'O valor deve ser maior que zero';
              }
              if (parsedValue > 1000000) {
                return 'Valor máximo permitido é 1.000.000';
              }
              return null;
              }
}