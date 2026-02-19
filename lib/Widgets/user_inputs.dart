import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ignore: must_be_immutable
class Inputs extends StatelessWidget {
  String? description;
  TextInputFormatter? inputFormatter;
  double? value;
  DateTime? date;
  String? hintText;
  String? labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  
Inputs({super.key, this.description, this.value, this.date, this.hintText, this.labelText, required this.controller, this.inputFormatter, this.keyboardType, this.validator});

@override
Widget build(BuildContext context) {
  
  return TextFormField(
    inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
    validator: validator,
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

