import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/monthly_history_service.dart';

Ganho _ganho({
  required String id,
  required DateTime data,
  required double value,
}) {
  return Ganho(id: id, value: value, description: 'mock', data: data);
}

void main() {
  group('Cenarios de meses anteriores por ciclo', () {
    test(
      'ao entrar em 26/04 com fechamento 24, ciclo 25/03-24/04 vai para historico',
      () {
        final ganhos = [
          _ganho(id: 'c1', data: DateTime(2026, 3, 26), value: 2500),
          _ganho(id: 'c2', data: DateTime(2026, 4, 24), value: 3000),
          _ganho(id: 'novo', data: DateTime(2026, 4, 26), value: 400),
        ];

        final history = MonthlyHistoryService.calculatePastMonthsTotals(
          ganhos,
          referencia: DateTime(2026, 4, 26),
        );

        expect(history.length, 1);
        expect(history.first.periodLabel, '25/03 - 24/04');
        expect(history.first.total, 5500);
      },
    );

    test('ciclo atual nao entra em meses anteriores antes do fechamento', () {
      final ganhos = [
        _ganho(id: 'a', data: DateTime(2026, 4, 25), value: 400),
        _ganho(id: 'b', data: DateTime(2026, 5, 1), value: 600),
      ];

      final history = MonthlyHistoryService.calculatePastMonthsTotals(
        ganhos,
        referencia: DateTime(2026, 5, 10),
      );

      expect(history, isEmpty);
    });

    test('fechamento personalizado 15 cria historico no ciclo correto', () {
      final ganhos = [
        _ganho(id: 'a', data: DateTime(2026, 4, 16), value: 1000),
        _ganho(id: 'b', data: DateTime(2026, 5, 15), value: 1200),
        _ganho(id: 'c', data: DateTime(2026, 5, 16), value: 300),
      ];

      final history = MonthlyHistoryService.calculatePastMonthsTotals(
        ganhos,
        referencia: DateTime(2026, 5, 20),
        closingDay: 15,
      );

      expect(history.length, 1);
      expect(history.first.periodLabel, '16/04 - 15/05');
      expect(history.first.total, 2200);
    });

    test(
      'ao entrar no 13o ciclo, historico mantem apenas os 12 ciclos mais recentes',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'm1', data: DateTime(2025, 3, 26), value: 100),
          _ganho(id: 'm2', data: DateTime(2025, 4, 26), value: 200),
          _ganho(id: 'm3', data: DateTime(2025, 5, 26), value: 300),
          _ganho(id: 'm4', data: DateTime(2025, 6, 26), value: 400),
          _ganho(id: 'm5', data: DateTime(2025, 7, 26), value: 500),
          _ganho(id: 'm6', data: DateTime(2025, 8, 26), value: 600),
          _ganho(id: 'm7', data: DateTime(2025, 9, 26), value: 700),
          _ganho(id: 'm8', data: DateTime(2025, 10, 26), value: 800),
          _ganho(id: 'm9', data: DateTime(2025, 11, 26), value: 900),
          _ganho(id: 'm10', data: DateTime(2025, 12, 26), value: 1000),
          _ganho(id: 'm11', data: DateTime(2026, 1, 26), value: 1100),
          _ganho(id: 'm12', data: DateTime(2026, 2, 26), value: 1200),
          _ganho(id: 'm13', data: DateTime(2026, 3, 26), value: 1300),
          _ganho(id: 'atual', data: DateTime(2026, 4, 26), value: 50),
        ];

        final history = MonthlyHistoryService.calculatePastMonthsTotals(
          ganhos,
          referencia: DateTime(2026, 4, 26),
        );

        expect(history.length, 12);
        expect(history.first.total, 1300);
        expect(history.last.total, 200);
        expect(history.any((entry) => entry.total == 100), isFalse);
      },
    );
  });
}
