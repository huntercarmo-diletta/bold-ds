import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'o_neto.dart';

/// **A BUSCA NÃO DERRUBA O TECLADO AO ENTRAR OU SAIR DO ERRO — e a borda de erro aparece.**
///
/// Medido no app em 26/10, num Motorola edge 60 neo (Android 16), na busca de chave da Área Pix:
/// tocar no campo abre o teclado; digitar `1` liga o `error` e o teclado fecha no mesmo frame —
/// `HIDE_SOFT_INPUT fromUser false`, foi o app. O `build` devolvia `DilettaSearchInput` na raiz
/// sem erro e `DecoratedBox(child: DilettaSearchInput)` com erro: trocar a raiz recria o campo, o
/// `FocusNode` interno do avô morre no `dispose` e a conexão de texto fecha junto.
///
/// E a borda vermelha nunca apareceu: o `DecoratedBox` pintava atrás, e o campo do avô é opaco.
void main() {
  late StateSetter mudar;
  late bool erro;
  late TextEditingController controle;

  Future<void> monta(WidgetTester t, {required bool comErro}) async {
    erro = comErro;
    controle = TextEditingController();
    addTearDown(controle.dispose);
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: Neto.claro,
        child: Scaffold(
          body: Center(
            child: StatefulBuilder(builder: (context, setState) {
              mudar = setState;
              return CoreflowBusca(controller: controle, error: erro);
            }),
          ),
        ),
      ),
    ));
  }

  EditableText campo(WidgetTester t) => t.widget<EditableText>(find.byType(EditableText));

  State estadoDoCampo(WidgetTester t) => t.state(find.byType(DilettaSearchInput));

  /// Foca, digita e troca o `error`. Devolve o `State` do campo de ANTES da troca.
  Future<State> digitaETroca(WidgetTester t, {required bool de}) async {
    await monta(t, comErro: de);
    await t.tap(find.byType(EditableText));
    await t.pump();
    await t.enterText(find.byType(EditableText), '1');
    await t.pump();
    expect(t.testTextInput.isVisible, isTrue, reason: 'o teclado abriu antes da troca');
    expect(campo(t).focusNode.hasFocus, isTrue);

    final antes = estadoDoCampo(t);
    mudar(() => erro = !de);
    await t.pump();
    return antes;
  }

  for (final de in [false, true]) {
    final troca = de ? 'com erro → sem erro' : 'sem erro → com erro';

    testWidgets('$troca: o teclado fica, o foco fica, o texto fica', (t) async {
      await digitaETroca(t, de: de);
      expect(t.testTextInput.isVisible, isTrue,
          reason: 'o teclado desceu — o campo foi recriado e o foco morreu com ele');
      expect(campo(t).focusNode.hasFocus, isTrue,
          reason: 'o campo perdeu o foco na troca do erro');
      expect(controle.text, '1');
    });

    testWidgets('$troca: o State do campo é o mesmo objeto', (t) async {
      final antes = await digitaETroca(t, de: de);
      expect(identical(estadoDoCampo(t), antes), isTrue,
          reason: 'o State do DilettaSearchInput é outro — a árvore mudou de forma');
    });
  }

  DecoratedBox moldura(WidgetTester t) => t.widget<DecoratedBox>(find.byWidgetPredicate(
      (w) => w is DecoratedBox && w.child is DilettaSearchInput));

  testWidgets('com erro, a borda é danger e vai POR CIMA do campo', (t) async {
    await monta(t, comErro: true);
    final m = moldura(t);
    final esquema = CoreflowScheme.of(t.element(find.byType(CoreflowBusca)));
    expect(m.position, DecorationPosition.foreground,
        reason: 'atrás do campo opaco do avô, o vermelho não aparece');
    final borda = (m.decoration as BoxDecoration).border! as Border;
    expect(borda.top.color, esquema.danger);
    expect(borda.top.width, 1);
    expect((m.decoration as BoxDecoration).borderRadius, esquema.formaDoCampo);
  });

  testWidgets('sem erro, a moldura continua na árvore e não pinta nada', (t) async {
    await monta(t, comErro: false);
    final m = moldura(t);
    expect(m.position, DecorationPosition.foreground);
    final borda = (m.decoration as BoxDecoration).border as Border?;
    expect(borda == null || borda.top.color.a == 0, isTrue,
        reason: 'sem erro, quem desenha a borda é o campo do avô');
  });
}
