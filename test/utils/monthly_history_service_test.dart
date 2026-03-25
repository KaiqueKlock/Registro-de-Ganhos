import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/monthly_history_service.dart';

Ganho _g({required String id, required DateTime data, required double value}) {
  return Ganho(id: id, value: value, description: 'mock', data: data);
}

void main() {
  group('MonthlyHistoryService', () {
    test('calcula somente meses passados e agrega valores por mes', () {
      final ganhos = [
        _g(id: 'jan1', data: DateTime(2026, 1, 2), value: 100),
        _g(id: 'jan2', data: DateTime(2026, 1, 12), value: 400),
        _g(id: 'fev1', data: DateTime(2026, 2, 4), value: 900),
        _g(id: 'mar1', data: DateTime(2026, 3, 5), value: 700),
      ];

      final history = MonthlyHistoryService.calculatePastMonthsTotals(
        ganhos,
        referencia: DateTime(2026, 3, 10),
      );

      expect(history.length, 2);
      expect(history[0].month, 2);
      expect(history[0].total, 900);
      expect(history[1].month, 1);
      expect(history[1].total, 500);
    });

    test('serializa e desserializa lista de historico', () {
      final input = [
        const MonthlyHistoryEntry(year: 2026, month: 2, total: 1200.5),
        const MonthlyHistoryEntry(year: 2026, month: 1, total: 800),
      ];

      final serialized = MonthlyHistoryService.serializeHistory(input);
      final restored = MonthlyHistoryService.deserializeHistory(serialized);

      expect(restored.length, 2);
      expect(restored[0].year, 2026);
      expect(restored[0].month, 2);
      expect(restored[0].total, 1200.5);
      expect(restored[1].month, 1);
      expect(restored[1].total, 800);
    });
  });
}
