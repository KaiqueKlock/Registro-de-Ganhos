import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';

final now = DateTime.now();

class GanhoService {
      static double calculateGanho(List<Ganho> ganhos, DateTime inicio, DateTime fim) {
    final filteredGanhos = ganhos.where((ganho) => ganho.data.isAfter(inicio) && ganho.data.isBefore(fim));

    return filteredGanhos.fold(0.0, (total, ganho) => total + ganho.value);
      }

    static double calculateGanhoDiario(List<Ganho> ganhos) {
    
    final inicio = DateTime(now.year, now.month, now.day);
    final fim = inicio.add(const Duration(days: 1));
    
    return calculateGanho(ganhos, inicio, fim);
}

    static double calculateGanhoSemanal(List<Ganho> ganhos) {
  
    final iniciodaSemana = now.subtract(Duration(days: now.weekday - 1)); // Início da semana (segunda-feira)
    final inicio = DateTime(iniciodaSemana.year, iniciodaSemana.month, iniciodaSemana.day);
    final fim = inicio.add(const Duration(days: 7)); // Fim da semana (domingo)

    return calculateGanho(ganhos, inicio, fim);
}
   static double calculateGanhoPorMes(
  List<Ganho> ganhos,
  int year,
  int month,
) {
  final inicio = DateTime(year, month, 1);
  final fim = DateTime(year, month + 1, 1);

  return calculateGanho(ganhos, inicio, fim);
}
    static double calculateGanhoMensal(List<Ganho> ganhos) {
  
    

    return calculateGanhoPorMes(ganhos, now.year, now.month);
}

static double calculateCrescimento(double atual, double anterior) {
  if (anterior == 0) return 0;

  double percentualMesPassado = DateTime.now().day / DateUtils.getDaysInMonth(now.year, now.month);
  double metaAjustada = anterior * percentualMesPassado;

  return ((atual - metaAjustada) / metaAjustada) * 100;
}

}