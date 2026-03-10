import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Utils/goalUtils.dart';

void main() {
  test('Goalutils.goalKey gera chave por ano e mes', () {
    final key = Goalutils.goalKey(DateTime(2026, 3, 9));
    expect(key, 'goal_2026_3');
  });
}
