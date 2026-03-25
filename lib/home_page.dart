import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:registro_de_ganhos/GanhoFormPage.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/GanhoService.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';
import 'package:registro_de_ganhos/Utils/goalUtils.dart';
import 'package:registro_de_ganhos/Utils/monthly_history_service.dart';
import 'package:registro_de_ganhos/Widgets/MensalCard.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(Color) changeColor;

  const MyHomePage({
    super.key,
    required this.title,
    required this.toggleTheme,
    required this.changeColor,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void abrirDialogMeta() {
    final box = Hive.box('settings');
    final now = DateTime.now();
    final key = Goalutils.goalKey(now);
    final double? metaAtual = box.get(key);

    final metaController = TextEditingController(
      text: metaAtual != null
          ? CurrencyFormatter.formatCurrency(metaAtual)
          : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            metaAtual == null ? 'Definir Meta Mensal' : 'Editar Meta Mensal',
          ),
          content: TextFormField(
            inputFormatters: [CurrencyFormatter()],
            controller: metaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'R\$ 0,0'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final metaDigitada = CurrencyFormatter.parseCurrency(
                  metaController.text,
                );

                if (metaDigitada <= 0) {
                  box.delete(key);
                } else {
                  box.put(key, metaDigitada);
                }

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _colorTile(Color color, String label) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color),
      title: Text(label),
      onTap: () {
        widget.changeColor(color);
        Navigator.pop(context);
      },
    );
  }

  void _openMonthRecordsDialog(MonthlyHistoryEntry entry, List<Ganho> ganhos) {
    final records = MonthlyHistoryService.monthRecords(
      ganhos,
      year: entry.year,
      month: entry.month,
    );
    final monthName = DateFormat(
      'MMMM',
      'pt_BR',
    ).format(DateTime(entry.year, entry.month));
    final monthLabel = monthName[0].toUpperCase() + monthName.substring(1);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registros de $monthLabel/${entry.year}'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: records.isEmpty
                ? const Center(
                    child: Text('Nenhum registro encontrado para este mês'),
                  )
                : ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final ganho = records[index];
                      final description = ganho.description.trim().isEmpty
                          ? 'Sem descrição'
                          : ganho.description;

                      return ListTile(
                        dense: true,
                        title: Text(description),
                        subtitle: Text(ganho.formatedDate),
                        trailing: Text(
                          ganho.formatedValue,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildPastMonthsTiles(
    List<MonthlyHistoryEntry> history,
    List<Ganho> ganhos,
  ) {
    if (history.isEmpty) {
      return const [
        ListTile(
          title: Text('Meses anteriores'),
          subtitle: Text('Nenhum mês encerrado ainda'),
        ),
      ];
    }

    return [
      const ListTile(title: Text('Meses anteriores')),
      ...history.map(
        (entry) => ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(entry.formattedLine),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openMonthRecordsDialog(entry, ganhos),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Ganho>('ganhos').listenable(),
            builder: (context, Box<Ganho> ganhosBox, _) {
              return ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (context, Box settingsBox, _) {
                  final drawerGanhos = ganhosBox.values.toList();
                  final history = MonthlyHistoryService.syncAndLoadHistory(
                    settingsBox,
                    drawerGanhos,
                    referencia: DateTime.now(),
                  );

                  return ListView(
                    children: [
                      const ListTile(title: Text('Configurações')),
                      ListTile(
                        leading: Icon(
                          isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                        ),
                        onTap: () {
                          widget.toggleTheme();
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(),
                      ExpansionTile(
                        leading: const Icon(Icons.palette),
                        title: const Text('Seleção de Cor'),
                        children: [
                          _colorTile(
                            const Color.fromARGB(255, 69, 4, 80),
                            'Roxo',
                          ),
                          _colorTile(
                            const Color.fromARGB(255, 219, 16, 1),
                            'Vermelho',
                          ),
                          _colorTile(
                            const Color.fromARGB(242, 238, 10, 151),
                            'Pink',
                          ),
                          _colorTile(
                            const Color.fromARGB(255, 233, 189, 123),
                            'Laranja',
                          ),
                          _colorTile(
                            const Color.fromARGB(255, 78, 224, 83),
                            'Verde',
                          ),
                          _colorTile(
                            const Color.fromARGB(255, 43, 142, 255),
                            'Azul',
                          ),
                          _colorTile(
                            const Color.fromARGB(255, 18, 238, 227),
                            'Ciano',
                          ),
                        ],
                      ),
                      const Divider(),
                      ..._buildPastMonthsTiles(history, drawerGanhos),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Ganho>('ganhos').listenable(),
        builder: (context, Box<Ganho> ganhosBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box('settings').listenable(),
            builder: (context, Box settingsBox, _) {
              final ganhos = ganhosBox.values.toList();
              final now = DateTime.now();
              final mes = DateFormat('MMMM', 'pt_BR').format(now);
              final mesCapital = mes[0].toUpperCase() + mes.substring(1);
              final mesAnteriorData = DateTime(now.year, now.month - 1);
              final mesAnteriorNome = DateFormat(
                'MMMM',
                'pt_BR',
              ).format(mesAnteriorData);
              final mesAnteriorCapital =
                  mesAnteriorNome[0].toUpperCase() +
                  mesAnteriorNome.substring(1);
              final diaMaxMesAnterior = DateUtils.getDaysInMonth(
                mesAnteriorData.year,
                mesAnteriorData.month,
              );
              final diaReferencia = now.day > diaMaxMesAnterior
                  ? diaMaxMesAnterior
                  : now.day;
              final referenciaMesAnterior =
                  '${diaReferencia.toString().padLeft(2, '0')}/$mesAnteriorCapital';

              final key = Goalutils.goalKey(now);
              final meta = settingsBox.get(key);

              final totalMes = GanhoService.calculateGanhoPorMes(
                ganhos,
                now.year,
                now.month,
              );

              final totalAnterior = GanhoService.calculateGanhoPorMes(
                ganhos,
                mesAnteriorData.year,
                mesAnteriorData.month,
              );

              final crescimentoMensal = GanhoService.calculateCrescimento(
                totalMes,
                totalAnterior,
              );

              final percentualMeta = (meta != null && meta > 0)
                  ? (totalMes / meta)
                  : 0.0;

              return Column(
                children: [
                  const SizedBox(height: 5),
                  if (meta == null)
                    Card.outlined(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  CurrencyFormatter.format(totalMes),
                                  style: const TextStyle(fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                Text(mesCapital, textAlign: TextAlign.center),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: abrirDialogMeta,
                                child: const Text('Definir meta'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    MetaMensalCard(
                      percentualMeta: percentualMeta,
                      percentualCrescimento: crescimentoMensal,
                      totalAtual: totalMes,
                      mesAtual: mesCapital,
                      mesAnterior: referenciaMesAnterior,
                      temMesAnterior: totalAnterior > 0,
                      meta: meta,
                      onDefinirMeta: abrirDialogMeta,
                      onRemoverMeta: () {
                        settingsBox.delete(key);
                      },
                    ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 96),
                      itemCount: ganhos.length,
                      itemBuilder: (context, index) {
                        final ganho = ganhos[index];

                        return Card.outlined(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(ganho.description),
                                  const SizedBox(height: 10),
                                  Text(ganho.formatedDate),
                                  const SizedBox(height: 20),
                                ],
                              ),
                              const SizedBox(width: 5),
                              Text(
                                ganho.formatedValue,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return Ganhoformpage(ganho: ganho);
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => ganho.delete(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) {
              return Ganhoformpage();
            },
          );
        },
        tooltip: 'Adicionar Ganho',
        child: const Icon(Icons.add),
      ),
    );
  }
}
