import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Utils/validator.dart';

void main() {
  group('Validator.validateValue', () {
    test('retorna erro para valor vazio', () {
      expect(Validator.validateValue(''), 'Por favor, insira um valor');
    });

    test('retorna erro para zero', () {
      expect(
        Validator.validateValue('R\$ 0,00'),
        'O valor deve ser maior que zero',
      );
    });

    test('retorna erro para valor acima do maximo', () {
      expect(
        Validator.validateValue('R\$ 1000001,00'),
        'Valor máximo permitido é 1.000.000',
      );
    });

    test('retorna erro para entrada sem digitos sem lancar excecao', () {
      expect(() => Validator.validateValue('abc'), returnsNormally);
      expect(Validator.validateValue('abc'), 'Número inválido');
    });

    test('retorna null para valor valido', () {
      expect(Validator.validateValue('R\$ 123,45'), isNull);
    });
  });
}
