import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Widgets/user_inputs.dart';
import 'package:uuid/uuid.dart';




class Ganhoformpage extends StatefulWidget {
  final Ganho? ganho;
  final uuid = Uuid();
 Ganhoformpage({super.key, this.ganho});
  
  @override
  State<Ganhoformpage> createState() => _AddPageState();
}


class _AddPageState extends State<Ganhoformpage> {
  late TextEditingController doublecontroller = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

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
            IconButton(
  onPressed: () {
    final ganho = widget.ganho == null
        ? Ganho(
            id: widget.uuid.v4(), // gera novo só no ADD
            value: double.parse(doublecontroller.text),
            description: descriptionController.text,
            data: DateTime.now(),
          )
        : Ganho(
            id: widget.ganho!.id, // mantém o mesmo ID no EDIT
            value: double.parse(doublecontroller.text),
            description: descriptionController.text,
            data: widget.ganho!.data,
          );
    print('${ganho.description} - ${ganho.value} - ${ganho.data} - ${ganho.id}');
    Navigator.pop(context, ganho);
  },
  icon: Icon(Icons.save_outlined, size: 50),
),
              ],
            )
            
            ],
      ),
    );
  }
}