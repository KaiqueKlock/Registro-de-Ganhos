import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/GanhoService.dart';

Ganho _g(DateTime data, double value, String id) {
  return Ganho(id: id, value: value, description: 'item$id', data: data);
}

void main() {
  group('GanhoService', () {
    test('calculateGanho soma somente intervalo informado', () {
      final ganhos = [
        _g(DateTime(2026, 3, 1, 10), 100, '1'),
        _g(DateTime(2026, 3, 15, 10), 200, '2'),
        _g(DateTime(2026, 4, 1, 10), 300, '3'),
      ];

      final total = GanhoService.calculateGanho(
        ganhos,
        DateTime(2026, 3, 1),
        DateTime(2026, 4, 1),
      );

      expect(total, 300);
    });

    test('calculateGanhoPorMes retorna apenas do mes solicitado', () {
      final ganhos = [
        _g(DateTime(2026, 2, 10, 8), 100, '1'),
        _g(DateTime(2026, 3, 10, 8), 250, '2'),
        _g(DateTime(2026, 3, 20, 8), 50, '3'),
      ];

      final totalMarco = GanhoService.calculateGanhoPorMes(ganhos, 2026, 3);
      expect(totalMarco, 300);
    });

    test('calculateCrescimento retorna 0 quando anterior for 0', () {
      expect(GanhoService.calculateCrescimento(100, 0), 0);
    });

    test('calculateCrescimento segue formula de meta ajustada por dia', () {
      const atual = 500.0;
      const anterior = 1000.0;
      final now = DateTime.now();
      final percentualMesPassado =
          now.day / DateUtils.getDaysInMonth(now.year, now.month);
      final metaAjustada = anterior * percentualMesPassado;
      final esperado = ((atual - metaAjustada) / metaAjustada) * 100;

      final resultado = GanhoService.calculateCrescimento(atual, anterior);
      expect(resultado, closeTo(esperado, 0.0001));
    });

    test(
      'calculateCrescimentoComReferencia simula 01/03 com resultado positivo',
      () {
        // Exemplo: no dia 01/03 com fevereiro = 3000 e atual = 150.
        // Meta ajustada = 3000 * (1/31) = 96.77, crescimento ~ +55%.
        final resultado = GanhoService.calculateCrescimentoComReferencia(
          150,
          3000,
          referencia: DateTime(2026, 3, 1),
        );

        expect(resultado, closeTo(55.0, 0.5));
      },
    );

    test(
      'calculateCrescimentoComReferencia simula 01/03 com resultado negativo',
      () {
        // Exemplo: no dia 01/03 com fevereiro = 6000 e atual = 150.
        // Meta ajustada = 6000 * (1/31) = 193.55, crescimento ~ -22.5%.
        final resultado = GanhoService.calculateCrescimentoComReferencia(
          150,
          6000,
          referencia: DateTime(2026, 3, 1),
        );

        expect(resultado, closeTo(-22.5, 0.5));
      },
    );
  });
}
