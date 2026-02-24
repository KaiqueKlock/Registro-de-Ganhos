import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:registro_de_ganhos/GanhoFormPage.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/GanhoService.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title}); 
  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Ganho>('ganhos').listenable(),
        builder: (context, Box<Ganho> box, _) {

          final ganhos = box.values.toList();

          final totalDia = GanhoService.calculateGanhoDiario(ganhos);
          final totalSemana = GanhoService.calculateGanhoSemanal(ganhos);
          final totalMes = GanhoService.calculateGanhoMensal(ganhos); 
   
      
       return Column(
        children:[
        SizedBox(height: 20),
        Card.outlined(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(CurrencyFormatter.format(totalMes), style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)), textAlign: TextAlign.center,),
                      subtitle: Text('Este Mês', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 3, 3, 3)), textAlign: TextAlign.center,),
                    ),
                  ),
                ],),

                Row(children: [                    
                Expanded(
                  child: Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(CurrencyFormatter.format(totalDia), style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)),),
                      subtitle: Text('Hoje', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 3, 3, 3)),)),
                  )),
                ),

                  Expanded(
                    child: Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(CurrencyFormatter.format(totalSemana), style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)),),
                      subtitle:Text('Esta Semana', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 3, 3, 3)),),
                      ),
                                    )),
                  ),
                ],),
            ],
          ),
        ),      
        SizedBox(height: 10,),
              Expanded(
              child: ListView.builder(
                itemCount: ganhos.length,
                itemBuilder: (context, index) {
                  final ganho = ganhos[index];

                  return Card.outlined(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    child: Column(
                     
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                children: [
                                SizedBox(height: 20),
                               Text(ganho.description, style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 3, 3, 3)),),
                                SizedBox(height: 10),
                                Text(ganho.formatedDate, style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 3, 3, 3)),),
                                SizedBox(height: 20),
                              ],
                            ),
                        
                            Text(ganho.formatedValue, style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 3, 3, 3), fontWeight: FontWeight.bold),),
                             
                            Row(
                              children: [
                                IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => ganho.delete(), ),
                              IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => Ganhoformpage(ganho: ganho,)));
                       },
                                                        ),
                              ],
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
      }, ),
        floatingActionButton: FloatingActionButton(
         
  onPressed: () async {
    await Navigator.pushNamed(context, '/add');
   },
  tooltip: 'Adicionar Ganho',
  child: Icon(Icons.add),
),


    );
  }
}
