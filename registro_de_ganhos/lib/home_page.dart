import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/GanhoFormPage.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Repo/ganho_repository.dart';
import 'package:registro_de_ganhos/Widgets/user_inputs.dart';

class MyHomePage extends StatefulWidget {
 const MyHomePage({super.key, required this.title}); 
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
List<Ganho> ganhos = [];
final GanhoRepository ganhoRepository = GanhoRepository();
void deleteGanhos(int index){
  ganhoRepository.removeGanho(ganhos[index]);
  setState(() {
    ganhos = ganhoRepository.getGanhos();
  });
}
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      
      body: Column(
        children:[
        SizedBox(height: 20,),
        Card.outlined(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ganho Diário', style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)),),
                )),
                SizedBox(width: 10,),
                Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('R\$ 0.00', style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)),),
                )), //Trocar para variavel do calculo feito
                ],),
              SizedBox(height: 20,),
               Row(children: [
                Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ganho Mensal:', style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)),),
                )),
                SizedBox(width: 8,),
                Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('R\$ 0.00', style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 3, 3, 3)),),
                )), //Trocar para variavel do calculo mensal feito
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
                              onPressed: () => deleteGanhos(index), ),
                              IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => Ganhoformpage(ganho: ganhos[index])));
                             if (result != null && result is Ganho) {
                              ganhoRepository.editGanho(result);
                             setState(() {
                            ganhos = ganhoRepository.getGanhos();
                      });
                       }
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
      ),
        floatingActionButton: FloatingActionButton.extended(
  onPressed: () async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null && result is Ganho) {
        ganhoRepository.addGanho(result);
      setState(() {
        ganhos = ganhoRepository.getGanhos();
      });
    }
  },
  icon: Icon(Icons.add),
  label: Text('Adicionar'),
),


    );
  }
}
