import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:registro_de_ganhos/GanhoFormPage.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/GanhoService.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registro_de_ganhos/Utils/goalUtils.dart';
import 'package:registro_de_ganhos/Widgets/MensalCard.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(Color) changeColor;
  const MyHomePage({super.key, required this.title, required this.toggleTheme, required this.changeColor}); 
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

final TextEditingController _metaController =
    TextEditingController(
      text: metaAtual != null
          ? CurrencyFormatter.formatCurrency(metaAtual)
          : "",
    );
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          metaAtual == null
              ? "Definir Meta Mensal"
              : "Editar Meta Mensal",
        ),
        content: TextFormField(
          inputFormatters: [CurrencyFormatter()],
          controller: _metaController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "R\$ 00,00",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final metaDigitada =
                  CurrencyFormatter.parseCurrency(_metaController.text);

                box.put(key, metaDigitada);
              

              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      );
    },
  );
}




Widget _colorTile(Color color) { //helper para cores tiles
  return ListTile(
    leading: CircleAvatar(backgroundColor: color),
    onTap: () {
      widget.changeColor(color);
      Navigator.pop(context);
    },
  );
}




  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        actions: [
  IconButton(
    icon: Icon(Icons.dark_mode),
    onPressed: widget.toggleTheme,
  ),
  IconButton(
    icon: Icon(Icons.palette),
    onPressed: () {
      showDialog( //verificar se ficou melhor do que showModal
        context: context,
        builder: (_) {
          return AlertDialog(
            
            actions: [
              _colorTile(Colors.green),
              _colorTile(Colors.blue),
              _colorTile(Colors.purple),
              _colorTile(Colors.orange),
              _colorTile( Color.fromARGB(255, 243, 22, 7)),
            ],
          );
        },
      );
    },
  ),
],
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

        final key = Goalutils.goalKey(now);
        final meta = settingsBox.get(key);

        final totalDia =
            GanhoService.calculateGanhoDiario(ganhos);

        final totalSemana =
            GanhoService.calculateGanhoSemanal(ganhos);

        final totalMes =
            GanhoService.calculateGanhoPorMes(
              ganhos,
              now.year,
              now.month,
            );

        final mesAnterior =
            DateTime(now.year, now.month - 1);

        final totalAnterior =
            GanhoService.calculateGanhoPorMes(
              ganhos,
              mesAnterior.year,
              mesAnterior.month,
            );

        final crescimentoMensal =
            GanhoService.calculateCrescimento(
              totalMes,
              totalAnterior,
            );
           
        return Column(
          children: [
            SizedBox(height: 20),

            Card.outlined(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            CurrencyFormatter.format(totalMes),
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            now.month.toRadixString(2), //verificar como ficou "Este Mes"
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                "${crescimentoMensal.toStringAsFixed(1)}%",
                                style: TextStyle(fontSize: 24),
                              ),
                              subtitle: Text('Valorização'),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: MetaMensalCard(
                          
                          totalAtual: totalMes,
                          meta: meta,
                          onDefinirMeta: abrirDialogMeta,
                          onRemoverMeta: () {
                            settingsBox.delete(key);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: ganhos.length,
                itemBuilder: (context, index) {
                  final ganho = ganhos[index];

                  return Card.outlined(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 20),
                            Text(ganho.description),
                            SizedBox(height: 10),
                            Text(ganho.formatedDate),
                            SizedBox(height: 20),
                          ],
                        ),

                        Text(
                          ganho.formatedValue,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      Ganhoformpage(
                                        ganho: ganho,
                                      ),
                                );
                              },
                            ),
                                                        IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  ganho.delete(),
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
        return AlertDialog(content: Ganhoformpage(),);

        });

   },
  tooltip: 'Adicionar Ganho',
  child: Icon(Icons.add),
),


    );
  }
}
