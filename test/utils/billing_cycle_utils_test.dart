import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Utils/billing_cycle_utils.dart';

void main() {
  group('BillingCycleUtils', () {
    test('fechamento 24 gera ciclo 25->24', () {
      final cycle = BillingCycleUtils.cycleForDate(DateTime(2026, 4, 10), 24);

      expect(cycle.start, DateTime(2026, 3, 25));
      expect(cycle.endInclusive, DateTime(2026, 4, 24));
      expect(cycle.endExclusive, DateTime(2026, 4, 25));
    });

    test('fechamento 15 gera ciclo 16->15', () {
      final cycle = BillingCycleUtils.cycleForDate(DateTime(2026, 4, 20), 15);

      expect(cycle.start, DateTime(2026, 4, 16));
      expect(cycle.endInclusive, DateTime(2026, 5, 15));
    });

    test('fechamento 31 respeita ultimo dia em meses curtos', () {
      final cycle = BillingCycleUtils.cycleForDate(DateTime(2026, 2, 10), 31);

      expect(cycle.start, DateTime(2026, 2, 1));
      expect(cycle.endInclusive, DateTime(2026, 2, 28));
    });

    test('informa corretamente o proximo inicio de ciclo', () {
      final nextStart = BillingCycleUtils.nextCycleStart(
        DateTime(2026, 4, 10),
        24,
      );
      expect(nextStart, DateTime(2026, 4, 25));
    });

    test(
      'ao alterar fechamento para o dia anterior ao atual, ciclo vira no mesmo dia',
      () {
        final cicloAtualizado = BillingCycleUtils.cycleForDate(
          DateTime(2026, 4, 24),
          23,
        );
        final cicloAnterior = BillingCycleUtils.previousCycle(
          DateTime(2026, 4, 24),
          23,
        );

        expect(cicloAtualizado.start, DateTime(2026, 4, 24));
        expect(cicloAtualizado.endInclusive, DateTime(2026, 5, 23));
        expect(cicloAnterior.start, DateTime(2026, 3, 24));
        expect(cicloAnterior.endInclusive, DateTime(2026, 4, 23));
      },
    );

    test('em fevereiro, fechamento no dia 1 gera ciclo 02/02 a 01/03', () {
      final cycle = BillingCycleUtils.cycleForDate(DateTime(2026, 2, 20), 1);

      expect(cycle.start, DateTime(2026, 2, 2));
      expect(cycle.endInclusive, DateTime(2026, 3, 1));
    });

    test('em fevereiro, fechamento no dia 3 gera ciclo 04/02 a 03/03', () {
      final cycle = BillingCycleUtils.cycleForDate(DateTime(2026, 2, 20), 3);

      expect(cycle.start, DateTime(2026, 2, 4));
      expect(cycle.endInclusive, DateTime(2026, 3, 3));
    });
  });
}
