import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Widgets/MensalCard.dart';

void main() {
  testWidgets('MetaMensalCard mostra estado sem meta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MetaMensalCard(
            totalAtual: 0,
            meta: null,
            percentualMeta: 0,
            percentualCrescimento: 0,
            mesAtual: 'Março',
            mesAnterior: '09/Fevereiro',
            temMesAnterior: false,
            onDefinirMeta: () {},
            onRemoverMeta: () {},
          ),
        ),
      ),
    );

    expect(find.text('Meta'), findsOneWidget);
    expect(find.text('Definir'), findsOneWidget);
    expect(find.text('Voce ainda nao definiu uma meta'), findsOneWidget);
  });
}
