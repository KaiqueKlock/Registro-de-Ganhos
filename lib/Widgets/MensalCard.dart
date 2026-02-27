import 'package:flutter/material.dart';

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
          subtitle: const Text("Você ainda não tem uma meta", style: TextStyle(fontSize: 8),),
          trailing: TextButton(
            onPressed: onDefinirMeta,
            child: const Text("Definir"),
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Meta",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
            const SizedBox(height: 8),
            Text(
              "R\$ ${totalAtual.toStringAsFixed(2)} / "
              "R\$ ${meta!.toStringAsFixed(2)}", style: TextStyle(fontSize: 12),
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