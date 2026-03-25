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
  group('Cenarios de meses anteriores', () {
    test('ao entrar em abril, marco aparece na lista de meses anteriores', () {
      final ganhos = [
        _ganho(id: 'mar1', data: DateTime(2026, 3, 3), value: 2500),
        _ganho(id: 'mar2', data: DateTime(2026, 3, 20), value: 3000),
        _ganho(id: 'abr1', data: DateTime(2026, 4, 2), value: 400),
      ];

      final history = MonthlyHistoryService.calculatePastMonthsTotals(
        ganhos,
        referencia: DateTime(2026, 4, 5),
      );

      expect(history.length, 1);
      expect(history.first.year, 2026);
      expect(history.first.month, 3);
      expect(history.first.total, 5500);
    });

    test(
      'mes atual nao entra em meses anteriores enquanto o mes nao fechar',
      () {
        final ganhos = [
          _ganho(id: 'abr1', data: DateTime(2026, 4, 2), value: 400),
          _ganho(id: 'abr2', data: DateTime(2026, 4, 15), value: 600),
        ];

        final history = MonthlyHistoryService.calculatePastMonthsTotals(
          ganhos,
          referencia: DateTime(2026, 4, 20),
        );

        expect(history, isEmpty);
      },
    );

    test(
      'usuario com 12 meses fechados ao entrar no novo mes exibe 12 itens ordenados',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'm1', data: DateTime(2025, 3, 10), value: 100),
          _ganho(id: 'm2', data: DateTime(2025, 4, 10), value: 200),
          _ganho(id: 'm3', data: DateTime(2025, 5, 10), value: 300),
          _ganho(id: 'm4', data: DateTime(2025, 6, 10), value: 400),
          _ganho(id: 'm5', data: DateTime(2025, 7, 10), value: 500),
          _ganho(id: 'm6', data: DateTime(2025, 8, 10), value: 600),
          _ganho(id: 'm7', data: DateTime(2025, 9, 10), value: 700),
          _ganho(id: 'm8', data: DateTime(2025, 10, 10), value: 800),
          _ganho(id: 'm9', data: DateTime(2025, 11, 10), value: 900),
          _ganho(id: 'm10', data: DateTime(2025, 12, 10), value: 1000),
          _ganho(id: 'm11', data: DateTime(2026, 1, 10), value: 1100),
          _ganho(id: 'm12', data: DateTime(2026, 2, 10), value: 1200),
          _ganho(id: 'atual', data: DateTime(2026, 3, 5), value: 50),
        ];

        final history = MonthlyHistoryService.calculatePastMonthsTotals(
          ganhos,
          referencia: DateTime(2026, 3, 6),
        );

        expect(history.length, 12);
        expect(history.first.year, 2026);
        expect(history.first.month, 2);
        expect(history.first.total, 1200);
        expect(history.last.year, 2025);
        expect(history.last.month, 3);
        expect(history.last.total, 100);
        expect(
          history.any((entry) => entry.year == 2026 && entry.month == 3),
          isFalse,
        );
      },
    );

    test(
      'ao entrar no 13o mes, historico mantem apenas os 12 meses mais recentes',
      () {
        final ganhos = <Ganho>[
          _ganho(id: 'm1', data: DateTime(2025, 3, 10), value: 100),
          _ganho(id: 'm2', data: DateTime(2025, 4, 10), value: 200),
          _ganho(id: 'm3', data: DateTime(2025, 5, 10), value: 300),
          _ganho(id: 'm4', data: DateTime(2025, 6, 10), value: 400),
          _ganho(id: 'm5', data: DateTime(2025, 7, 10), value: 500),
          _ganho(id: 'm6', data: DateTime(2025, 8, 10), value: 600),
          _ganho(id: 'm7', data: DateTime(2025, 9, 10), value: 700),
          _ganho(id: 'm8', data: DateTime(2025, 10, 10), value: 800),
          _ganho(id: 'm9', data: DateTime(2025, 11, 10), value: 900),
          _ganho(id: 'm10', data: DateTime(2025, 12, 10), value: 1000),
          _ganho(id: 'm11', data: DateTime(2026, 1, 10), value: 1100),
          _ganho(id: 'm12', data: DateTime(2026, 2, 10), value: 1200),
          _ganho(id: 'm13', data: DateTime(2026, 3, 10), value: 1300),
          _ganho(id: 'atual', data: DateTime(2026, 4, 5), value: 50),
        ];

        final history = MonthlyHistoryService.calculatePastMonthsTotals(
          ganhos,
          referencia: DateTime(2026, 4, 6),
        );

        expect(history.length, 12);
        expect(history.first.year, 2026);
        expect(history.first.month, 3);
        expect(history.first.total, 1300);
        expect(history.last.year, 2025);
        expect(history.last.month, 4);
        expect(history.last.total, 200);
        expect(
          history.any((entry) => entry.year == 2025 && entry.month == 3),
          isFalse,
        );
      },
    );
  });
}
