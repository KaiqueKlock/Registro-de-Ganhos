import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/monthly_history_service.dart';

Ganho _g({required String id, required DateTime data, required double value}) {
  return Ganho(id: id, value: value, description: 'mock', data: data);
}

void main() {
  group('MonthlyHistoryService', () {
    test('calcula ciclos passados com fechamento padrao 24', () {
      final ganhos = [
        _g(id: 'a', data: DateTime(2026, 3, 26), value: 100),
        _g(id: 'b', data: DateTime(2026, 4, 24), value: 400),
        _g(id: 'c', data: DateTime(2026, 4, 25), value: 900),
      ];

      final history = MonthlyHistoryService.calculatePastMonthsTotals(
        ganhos,
        referencia: DateTime(2026, 4, 26),
      );

      expect(history.length, 1);
      expect(history.first.total, 500);
      expect(history.first.periodLabel, '25/03 - 24/04');
    });

    test('calcula ciclos passados com fechamento customizado', () {
      final ganhos = [
        _g(id: 'a', data: DateTime(2026, 4, 16), value: 200),
        _g(id: 'b', data: DateTime(2026, 5, 15), value: 300),
        _g(id: 'c', data: DateTime(2026, 5, 16), value: 700),
      ];

      final history = MonthlyHistoryService.calculatePastMonthsTotals(
        ganhos,
        referencia: DateTime(2026, 5, 20),
        closingDay: 15,
      );

      expect(history.length, 1);
      expect(history.first.total, 500);
      expect(history.first.periodLabel, '16/04 - 15/05');
    });

    test('serializa e desserializa lista de historico por ciclo', () {
      final input = [
        MonthlyHistoryEntry(
          start: DateTime(2026, 3, 25),
          endInclusive: DateTime(2026, 4, 24),
          total: 1200.5,
        ),
      ];

      final serialized = MonthlyHistoryService.serializeHistory(input);
      final restored = MonthlyHistoryService.deserializeHistory(serialized);

      expect(restored.length, 1);
      expect(restored.first.start, DateTime(2026, 3, 25));
      expect(restored.first.endInclusive, DateTime(2026, 4, 24));
      expect(restored.first.total, 1200.5);
    });

    test('retorna registros do ciclo solicitado em ordem decrescente', () {
      final ganhos = [
        _g(id: 'a', data: DateTime(2026, 3, 26, 8), value: 100),
        _g(id: 'b', data: DateTime(2026, 4, 24, 8), value: 200),
        _g(id: 'c', data: DateTime(2026, 4, 25, 8), value: 300),
      ];

      final entry = MonthlyHistoryEntry(
        start: DateTime(2026, 3, 25),
        endInclusive: DateTime(2026, 4, 24),
        total: 300,
      );

      final records = MonthlyHistoryService.monthRecordsByEntry(ganhos, entry);

      expect(records.length, 2);
      expect(records[0].id, 'b');
      expect(records[1].id, 'a');
    });

    test(
      'registros do ciclo incluem inicio e fim e excluem o primeiro dia do proximo ciclo',
      () {
        final ganhos = [
          _g(id: 'inicio', data: DateTime(2026, 3, 25, 8), value: 100),
          _g(id: 'fim', data: DateTime(2026, 4, 24, 20), value: 200),
          _g(id: 'fora', data: DateTime(2026, 4, 25, 8), value: 300),
        ];

        final entry = MonthlyHistoryEntry(
          start: DateTime(2026, 3, 25),
          endInclusive: DateTime(2026, 4, 24),
          total: 300,
        );

        final records = MonthlyHistoryService.monthRecordsByEntry(
          ganhos,
          entry,
        );

        expect(records.length, 2);
        expect(records.any((item) => item.id == 'inicio'), isTrue);
        expect(records.any((item) => item.id == 'fim'), isTrue);
        expect(records.any((item) => item.id == 'fora'), isFalse);
      },
    );
  });
}
