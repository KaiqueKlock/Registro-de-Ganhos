import 'package:hive_flutter/hive_flutter.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';

class GanhoRepository {
final Box<Ganho> box = Hive.box<Ganho>('ganhos');

void addGanho(Ganho ganho) {
  box.add(ganho);
  }

void removeGanho(Ganho ganho) {
  ganho.delete();
  }

 void editGanho(Ganho ganho, double novoValor) {
    ganho.value = novoValor;
    ganho.save();
  }
List<Ganho> getGanhos(){
  return List.unmodifiable(box.values);
  }

}