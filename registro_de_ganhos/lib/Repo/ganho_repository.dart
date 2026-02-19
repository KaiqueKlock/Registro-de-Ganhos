import 'package:registro_de_ganhos/Models/ganho.dart';

class GanhoRepository {
final List<Ganho> _ganhos = [];

void addGanho(Ganho ganho) {
  _ganhos.add(ganho);
  }

void removeGanho(Ganho ganho) {
  _ganhos.remove(ganho);
  
  }

void editGanho(Ganho newGanho) {
  final index =_ganhos.indexWhere((g) => g.id == newGanho.id);
  if (index >= 0 && index < _ganhos.length) {
    _ganhos[index] = newGanho;
  }
}
List<Ganho> getGanhos(){
  return List.unmodifiable(_ganhos);
  }

}