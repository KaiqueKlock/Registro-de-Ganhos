import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';
import 'package:registro_de_ganhos/Utils/validator.dart';
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

    final formKey = GlobalKey<FormState>();

  @override
void initState() {
  super.initState();

  doublecontroller = TextEditingController(
    text: widget.ganho?.value.toString() ?? '',
  );

  descriptionController = TextEditingController(
    text: widget.ganho?.description ?? '',
  );
}


  @override
  Widget build(BuildContext context) {



    void validate(context) {
      
          if (formKey.currentState!.validate()) {
       final digits = doublecontroller.text.replaceAll(RegExp(r'[^0-9]'), '');
        final parsedValue = double.parse(digits) / 100;

        final ganho = widget.ganho == null
            ? Ganho(
                id: widget.uuid.v4(),
                value: parsedValue,
                description: descriptionController.text,
                data: DateTime.now(),
              )
            : Ganho(
                id: widget.ganho!.id,
                value: parsedValue,
                description: descriptionController.text,
                data: widget.ganho!.data,
              );

        Navigator.pop(context, ganho);
      }
    }



    return Scaffold(
      body: ListView(
            children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Inputs(labelText:'Descrição', date: DateTime.now(), controller: descriptionController, keyboardType: TextInputType.text), // campo para add descrição
              SizedBox(height: 20,),
              Inputs(labelText:'Valor', hintText: 'R\$ 0.0', value: 40.0, date: DateTime.now(), controller: doublecontroller, inputFormatter: CurrencyFormatter(), keyboardType: TextInputType.number, validator: Validator.validateValue ), // campo para add valor
              IconButton(
                icon: Icon(Icons.save_outlined, size: 50),
             onPressed: () => validate(context),

              ),
                ],
              ),
            )
            
            ],
      ),
    );
  }
}