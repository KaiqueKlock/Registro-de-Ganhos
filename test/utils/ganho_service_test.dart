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

    test('calculateGanho inclui item no inicio e exclui item no fim', () {
      final ganhos = [
        _g(DateTime(2026, 3, 1, 0, 0, 0), 100, 'inicio'),
        _g(DateTime(2026, 3, 31, 23, 59), 200, 'meio'),
        _g(DateTime(2026, 4, 1, 0, 0, 0), 300, 'fim'),
      ];

      final total = GanhoService.calculateGanho(
        ganhos,
        DateTime(2026, 3, 1, 0, 0, 0),
        DateTime(2026, 4, 1, 0, 0, 0),
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

    test('calculateGanhoDiario usa referencia recebida', () {
      final ganhos = [
        _g(DateTime(2026, 3, 10, 8), 120, '1'),
        _g(DateTime(2026, 3, 10, 20), 80, '2'),
        _g(DateTime(2026, 3, 11, 9), 200, '3'),
      ];

      final totalDia = GanhoService.calculateGanhoDiario(
        ganhos,
        referencia: DateTime(2026, 3, 10, 12),
      );

      expect(totalDia, 200);
    });

    test('calculateGanhoSemanal usa referencia recebida', () {
      final ganhos = [
        _g(DateTime(2026, 3, 9, 10), 100, 'seg'),
        _g(DateTime(2026, 3, 12, 10), 150, 'qui'),
        _g(DateTime(2026, 3, 16, 10), 300, 'prox-seg'),
      ];

      final totalSemana = GanhoService.calculateGanhoSemanal(
        ganhos,
        referencia: DateTime(2026, 3, 12, 11),
      );

      expect(totalSemana, 250);
    });

    test('calculateGanhoMensal usa referencia recebida', () {
      final ganhos = [
        _g(DateTime(2026, 2, 10, 8), 100, '1'),
        _g(DateTime(2026, 3, 10, 8), 250, '2'),
      ];

      final totalMensal = GanhoService.calculateGanhoMensal(
        ganhos,
        referencia: DateTime(2026, 2, 20),
      );

      expect(totalMensal, 100);
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

    test(
      'calculateCrescimentoPorCiclo considera progresso dentro do ciclo',
      () {
        // Ciclo de 25/03 a 24/04 tem 31 dias.
        // Em 10/04: passaram 17 dias.
        // Meta ajustada = 3100 * (17/31) = 1700.
        // Crescimento = (1500-1700)/1700 = -11.76%.
        final resultado = GanhoService.calculateCrescimentoPorCiclo(
          1500,
          3100,
          referencia: DateTime(2026, 4, 10),
          cicloInicio: DateTime(2026, 3, 25),
          cicloFimExclusivo: DateTime(2026, 4, 25),
        );

        expect(resultado, closeTo(-11.76, 0.1));
      },
    );

    test('calculateCrescimentoPorCiclo retorna 0 quando anterior for 0', () {
      final resultado = GanhoService.calculateCrescimentoPorCiclo(
        1000,
        0,
        referencia: DateTime(2026, 4, 10),
        cicloInicio: DateTime(2026, 3, 25),
        cicloFimExclusivo: DateTime(2026, 4, 25),
      );

      expect(resultado, 0);
    });
  });
}
