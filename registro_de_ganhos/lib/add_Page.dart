import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Widgets/user_inputs.dart';




class AddPage extends StatefulWidget {
  final Ganho? ganho;
  const AddPage({super.key, this.ganho});

  @override
  State<AddPage> createState() => _AddPageState();
}


class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {

  late TextEditingController doublecontroller = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
    descriptionController.text = widget.ganho?.description ?? '';
    doublecontroller.text = widget.ganho != null ? widget.ganho!.value.toString() : '';

    return Scaffold(
      
      body: ListView(
            children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Inputs(labelText:'Descrição', date: DateTime.now(), controller: descriptionController, keyboardType: TextInputType.text),
            SizedBox(height: 20,),
            Inputs(labelText:'Valor', hintText: 'R\$ 0.0', value: 40.0, date: DateTime.now(), controller: doublecontroller, keyboardType: TextInputType.number),// campo para add ganho
            IconButton(onPressed: (){
              final ganho = Ganho(value: double.parse(doublecontroller.text), description: descriptionController.text, data: DateTime.now());
              Navigator.pop(context, ganho);
               }, icon: Icon(Icons.save_outlined, size: 50,) ),
      

              ],
            )
            
            ],
      ),
    );
  }
}