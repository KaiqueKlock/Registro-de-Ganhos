import 'package:registro_de_ganhos/Models/ganho.dart';

class GanhoRepository {
final List<Ganho> _ganhos = [];

void addGanho(Ganho ganho) {
  _ganhos.add(ganho);
  }

void removeGanho(Ganho ganho) {
  _ganhos.remove(ganho);
  
  }


List<Ganho> get getGanhos => List.unmodifiable(_ganhos);

}