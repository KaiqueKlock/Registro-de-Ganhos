import 'package:intl/intl.dart';

class BillingCyclePeriod {
  final DateTime start;
  final DateTime endExclusive;

  const BillingCyclePeriod({required this.start, required this.endExclusive});

  DateTime get endInclusive => endExclusive.subtract(const Duration(days: 1));
}

class BillingCycleUtils {
  static int normalizeClosingDay(int closingDay) {
    return closingDay.clamp(1, 31).toInt();
  }

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static int _effectiveClosingDay(int year, int month, int closingDay) {
    final normalized = normalizeClosingDay(closingDay);
    return normalized.clamp(1, _daysInMonth(year, month));
  }

  static BillingCyclePeriod cycleForDate(DateTime referencia, int closingDay) {
    final referenceDate = DateTime(
      referencia.year,
      referencia.month,
      referencia.day,
    );

    final thisMonthClosing = _effectiveClosingDay(
      referenceDate.year,
      referenceDate.month,
      closingDay,
    );

    late final DateTime cycleEnd;
    if (referenceDate.day <= thisMonthClosing) {
      cycleEnd = DateTime(
        referenceDate.year,
        referenceDate.month,
        thisMonthClosing,
      );
    } else {
      final nextMonth = DateTime(
        referenceDate.year,
        referenceDate.month + 1,
        1,
      );
      final nextMonthClosing = _effectiveClosingDay(
        nextMonth.year,
        nextMonth.month,
        closingDay,
      );
      cycleEnd = DateTime(nextMonth.year, nextMonth.month, nextMonthClosing);
    }

    final previousMonth = DateTime(cycleEnd.year, cycleEnd.month - 1, 1);
    final previousMonthClosing = _effectiveClosingDay(
      previousMonth.year,
      previousMonth.month,
      closingDay,
    );
    final cycleStart = DateTime(
      previousMonth.year,
      previousMonth.month,
      previousMonthClosing,
    ).add(const Duration(days: 1));

    return BillingCyclePeriod(
      start: cycleStart,
      endExclusive: cycleEnd.add(const Duration(days: 1)),
    );
  }

  static BillingCyclePeriod previousCycle(DateTime referencia, int closingDay) {
    final current = cycleForDate(referencia, closingDay);
    final previousReference = current.start.subtract(const Duration(days: 1));
    return cycleForDate(previousReference, closingDay);
  }

  static DateTime nextCycleStart(DateTime referencia, int closingDay) {
    final current = cycleForDate(referencia, closingDay);
    return current.endExclusive;
  }

  static String periodLabel(BillingCyclePeriod period) {
    final format = DateFormat('dd/MM');
    return '${format.format(period.start)} - ${format.format(period.endInclusive)}';
  }

  static String cycleKey(BillingCyclePeriod period) {
    return '${period.start.year}-${period.start.month}-${period.start.day}_'
        '${period.endInclusive.year}-${period.endInclusive.month}-${period.endInclusive.day}';
  }
}
