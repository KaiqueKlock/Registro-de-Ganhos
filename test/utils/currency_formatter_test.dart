import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('parseCurrency converte string monetaria em double', () {
      final value = CurrencyFormatter.parseCurrency('R\$ 1.234,56');
      expect(value, 1234.56);
    });

    test('formatCurrency formata double para moeda BRL', () {
      final value = CurrencyFormatter.formatCurrency(1234.56);
      expect(value, startsWith('R\$'));
      expect(value, contains('1.234,56'));
    });

    test('formatEditUpdate aplica mascara de moeda', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1234');

      final formatter = CurrencyFormatter();
      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, startsWith('R\$'));
      expect(result.text, contains('12,34'));
      expect(result.selection.baseOffset, result.text.length);
    });
  });
}
