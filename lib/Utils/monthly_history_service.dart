import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';

class MonthlyHistoryEntry {
  final int year;
  final int month;
  final double total;

  const MonthlyHistoryEntry({
    required this.year,
    required this.month,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {'year': year, 'month': month, 'total': total};
  }

  factory MonthlyHistoryEntry.fromMap(Map<dynamic, dynamic> map) {
    return MonthlyHistoryEntry(
      year: map['year'] as int,
      month: map['month'] as int,
      total: (map['total'] as num).toDouble(),
    );
  }

  String get formattedLine {
    final monthName = DateFormat('MMMM', 'pt_BR').format(DateTime(year, month));
    final monthLabel = monthName[0].toUpperCase() + monthName.substring(1);
    return '$monthLabel - ${CurrencyFormatter.format(total)}';
  }
}

class MonthlyHistoryService {
  static const String historyKey = 'meses_anteriores';
  static const int maxHistoryMonths = 12;

  static List<MonthlyHistoryEntry> calculatePastMonthsTotals(
    List<Ganho> ganhos, {
    DateTime? referencia,
  }) {
    final now = referencia ?? DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final totalsByMonth = <String, double>{};

    for (final ganho in ganhos) {
      final ganhoMonthStart = DateTime(ganho.data.year, ganho.data.month, 1);
      if (!ganhoMonthStart.isBefore(currentMonthStart)) {
        continue;
      }

      final key = '${ganho.data.year}-${ganho.data.month}';
      totalsByMonth[key] = (totalsByMonth[key] ?? 0) + ganho.value;
    }

    final history = totalsByMonth.entries.map((entry) {
      final parts = entry.key.split('-');
      return MonthlyHistoryEntry(
        year: int.parse(parts[0]),
        month: int.parse(parts[1]),
        total: entry.value,
      );
    }).toList();

    history.sort((a, b) {
      if (a.year != b.year) {
        return b.year.compareTo(a.year);
      }
      return b.month.compareTo(a.month);
    });

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
  }) {
    final calculated = calculatePastMonthsTotals(
      ganhos,
      referencia: referencia,
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

      if (currentEntry['year'] != nextEntry['year']) return false;
      if (currentEntry['month'] != nextEntry['month']) return false;
      if ((currentEntry['total'] as num).toDouble() !=
          (nextEntry['total'] as num).toDouble()) {
        return false;
      }
    }

    return true;
  }
}
