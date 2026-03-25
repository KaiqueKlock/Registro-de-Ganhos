import 'package:hive/hive.dart';
import 'package:registro_de_ganhos/Utils/billing_cycle_utils.dart';

class Goalutils {
  static const String closingDayKey = 'closing_day';
  static const int defaultClosingDay = 24;

  static String goalKey(DateTime date) {
    return 'goal_${date.year}_${date.month}';
  }

  static int readClosingDay(Box settingsBox) {
    final raw = settingsBox.get(closingDayKey);
    if (raw is int) {
      return BillingCycleUtils.normalizeClosingDay(raw);
    }
    return defaultClosingDay;
  }

  static void saveClosingDay(Box settingsBox, int day) {
    settingsBox.put(closingDayKey, BillingCycleUtils.normalizeClosingDay(day));
  }

  static String goalKeyForCycle(BillingCyclePeriod period) {
    final end = period.endInclusive;
    return 'goal_${end.year}_${end.month}_${end.day}';
  }
}
