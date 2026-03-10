import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/Utils/currency_formatter.dart';
import 'package:registro_de_ganhos/Utils/validator.dart';
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

    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    if (widget.ganho != null) {
      doublecontroller = TextEditingController(
        text: format.format(widget.ganho!.value),
      );

      descriptionController = TextEditingController(
        text: widget.ganho!.description,
      );
    } else {
      doublecontroller = TextEditingController();
      descriptionController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    void validate(BuildContext context) {
      if (formKey.currentState!.validate()) {
        final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
        final parsedValue = format.parse(doublecontroller.text).toDouble();

        if (widget.ganho == null) {
          final novoGanho = Ganho(
            id: widget.uuid.v4(),
            value: parsedValue,
            description: descriptionController.text,
            data: DateTime.now(),
          );
          Hive.box<Ganho>('ganhos').add(novoGanho);
        } else {
          widget.ganho!
            ..value = parsedValue
            ..description = descriptionController.text
            ..data = DateTime.now();
          widget.ganho!.save();
        }

        Navigator.pop(context);
      }
    }

    return AlertDialog(
      title: Text(widget.ganho == null ? 'Adicionar ganho' : 'Editar ganho'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Descrição',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length > 12) {
                  return 'A descrição deve conter no maximo 12 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: doublecontroller,
              inputFormatters: [CurrencyFormatter()],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'R\$ 0,00'),
              validator: Validator.validateValue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => validate(context),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
