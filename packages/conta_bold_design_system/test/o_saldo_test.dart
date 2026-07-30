import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CARD DE SALDO — composição, e a regra que ele tem que ele mesmo não escolhe.
void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Scaffold(body: filho),
        ),
      );

  testWidgets('renderiza nos dois modos, com e sem os totais', (t) async {
    for (final escuro in [false, true]) {
      for (final comTotais in [false, true]) {
        await t.pumpWidget(montar(
          BoldSaldo(
            valor: r'R$ 2.912,47',
            aoAbrirExtrato: () {},
            entradas: comTotais ? r'R$ 300,00' : null,
            saidas: comTotais ? r'R$ 120,00' : null,
          ),
          escuro: escuro,
        ));
        await t.pump(const Duration(milliseconds: 50));
        expect(t.takeException(), isNull);
        expect(find.text('Seu saldo'), findsOneWidget);
      }
    }
  });

  testWidgets('OCULTAR cobre o valor E os totais', (t) async {
    // Decisão de produto, não detalhe: esconder o saldo e deixar as entradas visíveis não esconde
    // nada — quem vê "entrou R$ 300" já sabe a ordem de grandeza.
    await t.pumpWidget(montar(BoldSaldo(
      valor: r'R$ 2.912,47',
      oculto: true,
      entradas: r'R$ 300,00',
      saidas: r'R$ 120,00',
    )));
    await t.pump(const Duration(milliseconds: 50));

    expect(find.text(r'R$ 2.912,47'), findsNothing);
    expect(find.text(r'R$ 300,00'), findsNothing);
    expect(find.text(r'R$ 120,00'), findsNothing);
    expect(find.text(r'R$ ••••••'), findsOneWidget);
    expect(find.text(r'R$ ••••'), findsNWidgets(2));
  });

  testWidgets('a largura NÃO muda ao ocultar — a tela não pula', (t) async {
    // Era o motivo do `Stack` de opacidade na versão antiga. Trocado por medição de texto, e este
    // teste é o que garante que a troca preservou a garantia.
    Future<double> largura({required bool oculto}) async {
      await t.pumpWidget(montar(Align(
        alignment: Alignment.topLeft,
        child: BoldSaldo(valor: r'R$ 2.912,47', oculto: oculto),
      )));
      await t.pump(const Duration(milliseconds: 50));
      return t.getSize(find.byType(BoldSaldo)).width;
    }

    expect(await largura(oculto: false), await largura(oculto: true));
  });

  testWidgets('o botão de extrato só existe quando há o que abrir', (t) async {
    await t.pumpWidget(montar(const BoldSaldo(valor: r'R$ 10,00')));
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('Extrato'), findsNothing);

    var abriu = 0;
    await t.pumpWidget(montar(
      BoldSaldo(valor: r'R$ 10,00', aoAbrirExtrato: () => abriu++),
    ));
    await t.pump(const Duration(milliseconds: 50));
    await t.tap(find.text('Extrato'));
    expect(abriu, 1);
  });

  testWidgets('carregando troca por skeleton, sem pop-in dos selos', (t) async {
    await t.pumpWidget(montar(const BoldSaldo(
      valor: r'R$ 2.912,47',
      carregandoValor: true,
      carregandoTotais: true,
      entradas: r'R$ 300,00',
    )));
    await t.pump(const Duration(milliseconds: 50));

    expect(find.text(r'R$ 2.912,47'), findsNothing);
    expect(find.text(r'R$ 300,00'), findsNothing,
        reason: 'o selo não pode aparecer antes do skeleton dele sair');
    expect(find.byType(DilettaSkeleton), findsNWidgets(3));
  });
}
