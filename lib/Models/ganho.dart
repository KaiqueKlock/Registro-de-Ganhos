import 'package:intl/intl.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';
import 'package:hive/hive.dart';
part 'ganho.g.dart';

@HiveType(typeId: 0)
class Ganho extends HiveObject{

@HiveField(0)
DateTime data;
@HiveField(1)
double value;
@HiveField(2)
String description;
@HiveField(3)
String id;



Ganho({required this.value, required this.description, required this.data, required this.id});

int get integerValue => value.round();
String get formatedValue =>  CurrencyFormatter.format(value);

String get formatedDate => DateFormat('dd/MM', 'pt_BR').format(data); // verificar como ficou

bool get isNow{
  final now = DateTime.now();
  return data.day == now.day && data.month == now.month && data.year == now.year;
}}