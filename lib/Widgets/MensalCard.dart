import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';

class MetaMensalCard extends StatelessWidget {
  final double totalAtual;
  final double? meta;
  final VoidCallback onDefinirMeta;
  final VoidCallback onRemoverMeta;

  const MetaMensalCard({
    super.key,
    required this.totalAtual,
    required this.meta,
    required this.onDefinirMeta,
    required this.onRemoverMeta,
  });

  @override
  Widget build(BuildContext context) {
    if (meta == null) {
      return Card(
        child: ListTile(
          title: const Text("Meta"),
          subtitle: const Text("Você ainda não definiu uma meta", style: TextStyle(fontSize: 10),),
          trailing: TextButton(
            onPressed: onDefinirMeta,
            child: const Text("Definir"),
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Meta",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
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
              "${CurrencyFormatter.formatCurrency(totalAtual)} / "
              "${CurrencyFormatter.formatCurrency(meta!)}", style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (totalAtual / meta!).clamp(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}