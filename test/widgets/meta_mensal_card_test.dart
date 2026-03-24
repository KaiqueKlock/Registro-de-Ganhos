import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_de_ganhos/Widgets/MensalCard.dart';

void main() {
  testWidgets('MetaMensalCard nao quebra com meta zerada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MetaMensalCard(
            totalAtual: 0,
            meta: 0,
            percentualMeta: 0,
            percentualCrescimento: 0,
            mesAtual: 'Marco',
            mesAnterior: '09/Fevereiro',
            temMesAnterior: false,
            onDefinirMeta: () {},
            onRemoverMeta: () {},
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('MetaMensalCard mostra comparacao quando ha mes anterior', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MetaMensalCard(
            totalAtual: 500,
            meta: 1000,
            percentualMeta: 0.5,
            percentualCrescimento: 20.5,
            mesAtual: 'Marco',
            mesAnterior: '09/Fevereiro',
            temMesAnterior: true,
            onDefinirMeta: () {},
            onRemoverMeta: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('20.5%'), findsOneWidget);
    expect(find.text('vs 09/Fevereiro'), findsOneWidget);
    expect(find.byIcon(Icons.trending_up), findsOneWidget);
  });
}
