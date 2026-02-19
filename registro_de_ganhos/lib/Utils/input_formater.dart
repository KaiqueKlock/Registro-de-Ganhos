import "package:flutter/services.dart";


class GanhoInputFormater extends TextInputFormatter {
  final int decimalRange;
  GanhoInputFormater({required this.decimalRange}) : assert(decimalRange >= 0);


  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }
    if (text == "," || text == ".") {
      text = "0,";
    }

    if(text == " " || text == "-") {
      return oldValue;
    }

    text = text.replaceAll(",", ".");
 
    if(text.contains(".")) {
    final parts = text.split(".");
    if(parts.length > 1 && parts[1].length > decimalRange) {
      return oldValue;
    }
  }

    return TextEditingValue(
      text: text,
      selection: newValue.selection,
    );
  }
}