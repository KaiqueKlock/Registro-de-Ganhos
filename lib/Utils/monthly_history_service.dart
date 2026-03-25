import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/billing_cycle_utils.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';

class MonthlyHistoryEntry {
  final DateTime start;
  final DateTime endInclusive;
  final double total;

  const MonthlyHistoryEntry({
    required this.start,
    required this.endInclusive,
    required this.total,
  });

  int get year => endInclusive.year;
  int get month => endInclusive.month;

  String get periodLabel {
    final format = DateFormat('dd/MM');
    return '${format.format(start)} - ${format.format(endInclusive)}';
  }

  String get formattedLine {
    final monthName = DateFormat('MMMM', 'pt_BR').format(endInclusive);
    final monthLabel = monthName[0].toUpperCase() + monthName.substring(1);
    return '$monthLabel - ${CurrencyFormatter.format(total)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.toIso8601String(),
      'end': endInclusive.toIso8601String(),
      'total': total,
    };
  }

  factory MonthlyHistoryEntry.fromMap(Map<dynamic, dynamic> map) {
    // backward compatibility with old payload format (year/month/total)
    if (map.containsKey('year') && map.containsKey('month')) {
      final year = map['year'] as int;
      final month = map['month'] as int;
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 0);
      return MonthlyHistoryEntry(
        start: start,
        endInclusive: end,
        total: (map['total'] as num).toDouble(),
      );
    }

    return MonthlyHistoryEntry(
      start: DateTime.parse(map['start'] as String),
      endInclusive: DateTime.parse(map['end'] as String),
      total: (map['total'] as num).toDouble(),
    );
  }
}

class MonthlyHistoryService {
  static const String historyKey = 'meses_anteriores';
  static const int maxHistoryMonths = 12;

  static List<MonthlyHistoryEntry> calculatePastMonthsTotals(
    List<Ganho> ganhos, {
    DateTime? referencia,
    int closingDay = 24,
  }) {
    final now = referencia ?? DateTime.now();
    final currentCycle = BillingCycleUtils.cycleForDate(now, closingDay);
    final totalsByCycle = <String, double>{};
    final periodByCycle = <String, BillingCyclePeriod>{};

    for (final ganho in ganhos) {
      final cycle = BillingCycleUtils.cycleForDate(ganho.data, closingDay);
      if (!cycle.start.isBefore(currentCycle.start)) {
        continue;
      }

      final key = BillingCycleUtils.cycleKey(cycle);
      totalsByCycle[key] = (totalsByCycle[key] ?? 0) + ganho.value;
      periodByCycle[key] = cycle;
    }

    final history = totalsByCycle.entries.map((entry) {
      final period = periodByCycle[entry.key]!;
      return MonthlyHistoryEntry(
        start: period.start,
        endInclusive: period.endInclusive,
        total: entry.value,
      );
    }).toList();

    history.sort((a, b) => b.endInclusive.compareTo(a.endInclusive));

    if (history.length <= maxHistoryMonths) {
      return history;
    }
    return history.take(maxHistoryMonths).toList();
  }

  static List<MonthlyHistoryEntry> deserializeHistory(dynamic raw) {
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map((entry) => MonthlyHistoryEntry.fromMap(entry))
        .toList();
  }

  static List<Map<String, dynamic>> serializeHistory(
    List<MonthlyHistoryEntry> history,
  ) {
    return history.map((entry) => entry.toMap()).toList();
  }

  static List<MonthlyHistoryEntry> syncAndLoadHistory(
    Box settingsBox,
    List<Ganho> ganhos, {
    DateTime? referencia,
    int closingDay = 24,
  }) {
    final calculated = calculatePastMonthsTotals(
      ganhos,
      referencia: referencia,
      closingDay: closingDay,
    );
    final serializedCalculated = serializeHistory(calculated);
    final serializedCurrent = serializeHistory(
      deserializeHistory(settingsBox.get(historyKey)),
    );

    if (!_sameSerializedHistory(serializedCurrent, serializedCalculated)) {
      settingsBox.put(historyKey, serializedCalculated);
    }

    return calculated;
  }

  static List<Ganho> monthRecordsByEntry(
    List<Ganho> ganhos,
    MonthlyHistoryEntry entry,
  ) {
    final endExclusive = entry.endInclusive.add(const Duration(days: 1));
    final records = ganhos.where((ganho) {
      return !ganho.data.isBefore(entry.start) &&
          ganho.data.isBefore(endExclusive);
    }).toList();

    records.sort((a, b) => b.data.compareTo(a.data));
    return records;
  }

  static List<Ganho> monthRecords(
    List<Ganho> ganhos, {
    required int year,
    required int month,
  }) {
    final records = ganhos.where((ganho) {
      return ganho.data.year == year && ganho.data.month == month;
    }).toList();

    records.sort((a, b) => b.data.compareTo(a.data));
    return records;
  }

  static bool _sameSerializedHistory(
    List<Map<String, dynamic>> current,
    List<Map<String, dynamic>> next,
  ) {
    if (current.length != next.length) return false;

    for (var i = 0; i < current.length; i++) {
      final currentEntry = current[i];
      final nextEntry = next[i];

      if (currentEntry['start'] != nextEntry['start']) return false;
      if (currentEntry['end'] != nextEntry['end']) return false;
      if ((currentEntry['total'] as num).toDouble() !=
          (nextEntry['total'] as num).toDouble()) {
        return false;
      }
    }

    return true;
  }
}
