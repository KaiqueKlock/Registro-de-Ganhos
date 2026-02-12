import 'package:flutter/material.dart';


// ignore: must_be_immutable
class Inputs extends StatelessWidget {
  String? description;
  double? value;
  DateTime? date;
  String? hintText;
  String? labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  
Inputs({super.key, this.description, this.value, this.date, this.hintText, this.labelText, required this.controller, this.keyboardType});

@override
Widget build(BuildContext context) {
  
  return TextFormField(
    
    controller: controller,
    keyboardType: keyboardType,
    onChanged: (text){
    description = text;
    },
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(10),
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.black,
      ),
      border: OutlineInputBorder(),
    ),
  );
}
}

