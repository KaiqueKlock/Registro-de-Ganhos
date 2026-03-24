import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/GanhoService.dart';

Ganho _ganho({
  required String id,
  required DateTime data,
  required double value,
  String description = 'mock',
}) {
  return Ganho(id: id, value: value, description: description, data: data);
}

List<Ganho> _recorrentesNoMes({
  required int year,
  required int month,
  required int dias,
  required double valorPorDia,
  required String prefixoId,
}) {
  return List.generate(dias, (index) {
    final dia = index + 1;
    return _ganho(
      id: '$prefixoId-$dia',
      data: DateTime(year, month, dia, 9),
      value: valorPorDia,
      description: 'recorrente',
    );
  });
}

void main() {
  group('Cenarios com dados mockados', () {
    test(
      'usuario com historico de mais de 3 meses calcula totais corretamente',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'jan1', data: DateTime(2026, 1, 5, 10), value: 100),
          _ganho(id: 'jan2', data: DateTime(2026, 1, 20, 10), value: 300),
          _ganho(id: 'fev1', data: DateTime(2026, 2, 10, 10), value: 500),
          _ganho(id: 'fev2', data: DateTime(2026, 2, 15, 10), value: 100),
          _ganho(id: 'mar1', data: DateTime(2026, 3, 2, 10), value: 700),
          _ganho(id: 'abr1', data: DateTime(2026, 4, 8, 10), value: 200),
        ];

        expect(GanhoService.calculateGanhoPorMes(ganhos, 2026, 1), 400);
        expect(GanhoService.calculateGanhoPorMes(ganhos, 2026, 2), 600);
        expect(GanhoService.calculateGanhoPorMes(ganhos, 2026, 3), 700);
        expect(GanhoService.calculateGanhoPorMes(ganhos, 2026, 4), 200);
      },
    );

    test(
      'usuario com historico de mais de 3 meses no inicio de abril mostra crescimento esperado',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'mar1', data: DateTime(2026, 3, 5, 10), value: 1000),
          _ganho(id: 'mar2', data: DateTime(2026, 3, 15, 10), value: 500),
          _ganho(id: 'abr1', data: DateTime(2026, 4, 1, 10), value: 200),
        ];

        final totalAbril = GanhoService.calculateGanhoPorMes(ganhos, 2026, 4);
        final totalMarco = GanhoService.calculateGanhoPorMes(ganhos, 2026, 3);

        final crescimento = GanhoService.calculateCrescimentoComReferencia(
          totalAbril,
          totalMarco,
          referencia: DateTime(2026, 4, 1),
        );

        final esperado = ((200 - (1500 * (1 / 30))) / (1500 * (1 / 30))) * 100;
        expect(crescimento, closeTo(esperado, 0.0001));
        expect(crescimento, greaterThan(0));
      },
    );

    test(
      'usuario com ganhos recorrentes por 2 meses no dia 01 do novo mes fica positivo com 150',
      () {
        final ganhos = <Ganho>[
          ..._recorrentesNoMes(
            year: 2026,
            month: 1,
            dias: 20,
            valorPorDia: 100,
            prefixoId: 'jan',
          ),
          ..._recorrentesNoMes(
            year: 2026,
            month: 2,
            dias: 20,
            valorPorDia: 100,
            prefixoId: 'fev',
          ),
          _ganho(id: 'mar1', data: DateTime(2026, 3, 1, 10), value: 150),
        ];

        final totalMar = GanhoService.calculateGanhoPorMes(ganhos, 2026, 3);
        final totalFev = GanhoService.calculateGanhoPorMes(ganhos, 2026, 2);

        final crescimento = GanhoService.calculateCrescimentoComReferencia(
          totalMar,
          totalFev,
          referencia: DateTime(2026, 3, 1),
        );

        expect(totalFev, 2000);
        expect(totalMar, 150);
        expect(crescimento, closeTo(132.5, 0.5));
        expect(crescimento, greaterThan(0));
      },
    );

    test(
      'usuario com recorrencia de 2 meses no dia 01 sem ganho no novo mes fica em -100%',
      () {
        final ganhos = <Ganho>[
          ..._recorrentesNoMes(
            year: 2026,
            month: 1,
            dias: 20,
            valorPorDia: 100,
            prefixoId: 'jan',
          ),
          ..._recorrentesNoMes(
            year: 2026,
            month: 2,
            dias: 20,
            valorPorDia: 100,
            prefixoId: 'fev',
          ),
        ];

        final totalMar = GanhoService.calculateGanhoPorMes(ganhos, 2026, 3);
        final totalFev = GanhoService.calculateGanhoPorMes(ganhos, 2026, 2);

        final crescimento = GanhoService.calculateCrescimentoComReferencia(
          totalMar,
          totalFev,
          referencia: DateTime(2026, 3, 1),
        );

        expect(totalMar, 0);
        expect(totalFev, 2000);
        expect(crescimento, closeTo(-100, 0.0001));
      },
    );

    test(
      'primeiro uso do app: sem mes anterior deve retornar crescimento 0',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'primeiro', data: DateTime(2026, 3, 1, 10), value: 150),
        ];

        final totalMar = GanhoService.calculateGanhoPorMes(ganhos, 2026, 3);
        final totalFev = GanhoService.calculateGanhoPorMes(ganhos, 2026, 2);
        final crescimento = GanhoService.calculateCrescimentoComReferencia(
          totalMar,
          totalFev,
          referencia: DateTime(2026, 3, 1),
        );

        expect(totalMar, 150);
        expect(totalFev, 0);
        expect(crescimento, 0);
      },
    );

    test(
      'um unico ganho no dia 20 do mes passado e novos ganhos no mes atual calcula comparacao corretamente',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'fev20', data: DateTime(2026, 2, 20, 10), value: 500),
          _ganho(id: 'mar05', data: DateTime(2026, 3, 5, 10), value: 100),
          _ganho(id: 'mar09', data: DateTime(2026, 3, 9, 10), value: 200),
        ];

        final totalAtual = GanhoService.calculateGanhoPorMes(ganhos, 2026, 3);
        final totalAnterior = GanhoService.calculateGanhoPorMes(
          ganhos,
          2026,
          2,
        );
        final crescimento = GanhoService.calculateCrescimentoComReferencia(
          totalAtual,
          totalAnterior,
          referencia: DateTime(2026, 3, 10),
        );

        final esperado = ((300 - (500 * (10 / 31))) / (500 * (10 / 31))) * 100;

        expect(totalAtual, 300);
        expect(totalAnterior, 500);
        expect(crescimento, closeTo(esperado, 0.0001));
        expect(crescimento, greaterThan(0));
      },
    );
  });
}
