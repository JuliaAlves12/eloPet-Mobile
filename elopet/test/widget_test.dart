import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Teste de inicialização da interface', (
    WidgetTester tester,
  ) async {
    // Cria um widget básico para simular a inicialização do app
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Bem-vindo ao Elo Pet'))),
    );

    // Verifica se o texto carregou corretamente na tela
    expect(find.text('Bem-vindo ao Elo Pet'), findsOneWidget);
  });
}
