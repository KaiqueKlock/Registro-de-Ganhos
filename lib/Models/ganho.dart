import 'package:registro_de_ganhos/Utils/currency_formatter.dart';

class Ganho {
final DateTime data;
final double value;
final String description;
final String id;

Ganho({required this.value, required this.description, required this.data, required this.id});

int get integerValue => value.round();
String get formatedValue =>  CurrencyFormatter.format(value);

String get formatedDate => '${data.day}/${data.month}/${data.year}';

bool get isNow{
  final now = DateTime.now();
  return data.day == now.day && data.month == now.month && data.year == now.year;
}}