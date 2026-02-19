import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

  final NumberFormat _formatter =
  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
class CurrencyFormatter extends TextInputFormatter {
    
  

   

    @override
    TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
        String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
        if (newText.isEmpty) {
        return newValue.copyWith(text: '');
        }
        double value = double.parse(newText) / 100;
        String formatted = _formatter.format(value);
        return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
        );
    
    
    
    }   

   static String format(double value) {
    return _formatter.format(value);
  }
  
}