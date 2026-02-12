class Ganho {
final DateTime data;
final double value;
final String description;


Ganho({required this.value, required this.description, required this.data});

int get integerValue => value.round();
String get formatedValue =>  'R\$ ${value.toStringAsFixed(2)}';

String get formatedDate => '${data.day}/${data.month}/${data.year}';

bool get isNow{
  final now = DateTime.now();
  return data.day == now.day && data.month == now.month && data.year == now.year;
}}