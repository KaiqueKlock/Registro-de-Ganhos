import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';

class MetaMensalCard extends StatelessWidget {
  final double totalAtual;
  final double? meta;
  final VoidCallback onDefinirMeta;
  final VoidCallback onRemoverMeta;
  final double percentualMeta;
  final double percentualCrescimento;
  final String mesAtual;
  final bool temMesAnterior;

  const MetaMensalCard({
    super.key,
    required this.totalAtual,
    required this.meta,
    required this.onDefinirMeta,
    required this.onRemoverMeta,
    required this.percentualMeta,
    required this.percentualCrescimento,
    required this.mesAtual,
    required this.temMesAnterior,
  });

  @override
  Widget build(BuildContext context) {
    if (meta == null) {
      return Card(
        child: ListTile(
          title: const Text('Meta'),
          subtitle: const Text(
            'Voce ainda nao definiu uma meta',
            style: TextStyle(fontSize: 10),
          ),
          trailing: TextButton(
            onPressed: onDefinirMeta,
            child: const Text('Definir'),
          ),
        ),
      );
    }

    final bool exibeComparacao = totalAtual > 0 && temMesAnterior;
    final String crescimentoTexto;
    if (totalAtual == 0) {
      crescimentoTexto = 'Sem registros';
    } else if (!temMesAnterior) {
      crescimentoTexto = 'Primeiro mes';
    } else {
      crescimentoTexto = '${percentualCrescimento.toStringAsFixed(1)}%';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onDefinirMeta,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: onRemoverMeta,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${CurrencyFormatter.formatCurrency(totalAtual)} / '
              '${CurrencyFormatter.formatCurrency(meta!)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (totalAtual / meta!).clamp(0, 1)),
            const SizedBox(height: 8),
            if (exibeComparacao)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    crescimentoTexto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('vs mes anterior', style: TextStyle(fontSize: 11)),
                ],
              )
            else
              Text(
                crescimentoTexto,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
