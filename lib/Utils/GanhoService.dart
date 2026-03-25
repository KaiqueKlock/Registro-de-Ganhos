import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';

class GanhoService {
  static double calculateGanho(
    List<Ganho> ganhos,
    DateTime inicio,
    DateTime fim,
  ) {
    final filteredGanhos = ganhos.where(
      (ganho) => !ganho.data.isBefore(inicio) && ganho.data.isBefore(fim),
    );

    return filteredGanhos.fold(0.0, (total, ganho) => total + ganho.value);
  }

  static double calculateGanhoDiario(
    List<Ganho> ganhos, {
    DateTime? referencia,
  }) {
    final now = referencia ?? DateTime.now();
    final inicio = DateTime(now.year, now.month, now.day);
    final fim = inicio.add(const Duration(days: 1));

    return calculateGanho(ganhos, inicio, fim);
  }

  static double calculateGanhoSemanal(
    List<Ganho> ganhos, {
    DateTime? referencia,
  }) {
    final now = referencia ?? DateTime.now();
    final iniciodaSemana = now.subtract(
      Duration(days: now.weekday - 1),
    ); // Início da semana (segunda-feira)
    final inicio = DateTime(
      iniciodaSemana.year,
      iniciodaSemana.month,
      iniciodaSemana.day,
    );
    final fim = inicio.add(const Duration(days: 7)); // Fim da semana (domingo)

    return calculateGanho(ganhos, inicio, fim);
  }

  static double calculateGanhoPorMes(List<Ganho> ganhos, int year, int month) {
    final inicio = DateTime(year, month, 1);
    final fim = DateTime(year, month + 1, 1);

    return calculateGanho(ganhos, inicio, fim);
  }

  static double calculateGanhoMensal(
    List<Ganho> ganhos, {
    DateTime? referencia,
  }) {
    final now = referencia ?? DateTime.now();
    return calculateGanhoPorMes(ganhos, now.year, now.month);
  }

  static double calculateCrescimento(double atual, double anterior) {
    return calculateCrescimentoComReferencia(
      atual,
      anterior,
      referencia: DateTime.now(),
    );
  }

  static double calculateCrescimentoComReferencia(
    double atual,
    double anterior, {
    required DateTime referencia,
  }) {
    if (anterior == 0) return 0;

    final percentualMesPassado =
        referencia.day /
        DateUtils.getDaysInMonth(referencia.year, referencia.month);
    final metaAjustada = anterior * percentualMesPassado;

    return ((atual - metaAjustada) / metaAjustada) * 100;
  }

  static double calculateCrescimentoPorCiclo(
    double atual,
    double anterior, {
    required DateTime referencia,
    required DateTime cicloInicio,
    required DateTime cicloFimExclusivo,
  }) {
    if (anterior == 0) return 0;

    final totalDias = cicloFimExclusivo.difference(cicloInicio).inDays;
    if (totalDias <= 0) return 0;

    final referenciaDia = DateTime(
      referencia.year,
      referencia.month,
      referencia.day,
    );
    final diasDecorridos =
        referenciaDia.difference(cicloInicio).inDays.clamp(0, totalDias - 1) +
        1;
    final percentualDecorrido = diasDecorridos / totalDias;
    final metaAjustada = anterior * percentualDecorrido;

    if (metaAjustada == 0) return 0;
    return ((atual - metaAjustada) / metaAjustada) * 100;
  }
}
