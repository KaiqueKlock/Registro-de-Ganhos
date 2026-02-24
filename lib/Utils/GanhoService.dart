import 'package:registro_de_ganhos/Models/ganho.dart';

class GanhoService {
      static double calculateGanho(List<Ganho> ganhos, DateTime inicio, DateTime fim) {
    final filteredGanhos = ganhos.where((ganho) => ganho.data.isAfter(inicio) && ganho.data.isBefore(fim));

    return filteredGanhos.fold(0.0, (total, ganho) => total + ganho.value);
      }

    static double calculateGanhoDiario(List<Ganho> ganhos) {
    final now = DateTime.now();
    final inicio = DateTime(now.year, now.month, now.day);
    final fim = inicio.add(const Duration(days: 1));
    
    return calculateGanho(ganhos, inicio, fim);
}

    static double calculateGanhoSemanal(List<Ganho> ganhos) {
    final now = DateTime.now();
    final iniciodaSemana = now.subtract(Duration(days: now.weekday - 1)); // Início da semana (segunda-feira)
    final inicio = DateTime(iniciodaSemana.year, iniciodaSemana.month, iniciodaSemana.day);
    final fim = inicio.add(const Duration(days: 7)); // Fim da semana (domingo)

    return calculateGanho(ganhos, inicio, fim);
}

    static double calculateGanhoMensal(List<Ganho> ganhos) {
    final now = DateTime.now();
    final inicio = DateTime(now.year, now.month, 1);
    final fim = DateTime(now.year, now.month + 1, 1);
    
    return calculateGanho(ganhos, inicio, fim);
}
}