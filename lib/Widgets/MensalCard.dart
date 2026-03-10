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
  final String mesAnterior;
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
    required this.mesAnterior,
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
    final bool quedaRelevante = percentualCrescimento <= -50;
    final bool estadoNeutro = percentualCrescimento < 0 && !quedaRelevante;
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
            SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mesAtual.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Meta',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              '${CurrencyFormatter.formatCurrency(totalAtual)} / '
              '${CurrencyFormatter.formatCurrency(meta!)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (totalAtual / meta!).clamp(0, 1)),
            const SizedBox(height: 8),
            if (exibeComparacao)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    estadoNeutro
                        ? Icons.trending_flat
                        : percentualCrescimento >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16,
                    color: estadoNeutro
                        ? Colors.grey
                        : percentualCrescimento >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    estadoNeutro ? 'Em linha' : crescimentoTexto,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: estadoNeutro
                          ? Colors.grey
                          : percentualCrescimento >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('vs $mesAnterior', style: const TextStyle(fontSize: 11)),
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
