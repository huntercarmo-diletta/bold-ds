import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **A COLUNA DE UMA TELA ALINHA À ESQUERDA, e o centro se pede por nome.**
///
/// A regra existe porque a medição no app do primeiro filho achou 50 colunas de
/// tela e **16 delas sem alinhamento declarado nenhum** — o
/// default do `Column` é `center`, então UM TERÇO do produto estava
/// centralizado por omissão. Ver o `///` da [CoreflowColunaDaTela].
void main() {
  Future<void> montar(WidgetTester t, Widget w) =>
      t.pumpWidget(MaterialApp(home: Scaffold(body: w)));

  Column colunaDe(WidgetTester t) => t.widget<Column>(find.descendant(
      of: find.byType(CoreflowColunaDaTela), matching: find.byType(Column)));

  testWidgets('sem pedir nada, alinha à ESQUERDA', (t) async {
    await montar(t, const CoreflowColunaDaTela(filhos: [Text('a')]));
    expect(colunaDe(t).crossAxisAlignment, CrossAxisAlignment.start,
        reason: 'o default do Column é center, e é ele que esta peça existe '
            'para não deixar mais acontecer por omissão');
  });

  testWidgets('estica é a SEGUNDA leitura, e tem nome', (t) async {
    await montar(
        t, const CoreflowColunaDaTela(estica: true, filhos: [Text('a')]));
    expect(colunaDe(t).crossAxisAlignment, CrossAxisAlignment.stretch);
  });

  testWidgets('o gutter é dos DOIS lados, e não se escolhe', (t) async {
    await montar(t, const CoreflowColunaDaTela(filhos: [Text('a')]));
    final p = t
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
        .padding! as EdgeInsets;
    expect(p.left, CoreflowEspaco.gutter);
    expect(p.right, CoreflowEspaco.gutter);
  });

  testWidgets('os respiros default são os NOMEADOS — 24 em cima, 32 embaixo',
      (t) async {
    await montar(t, const CoreflowColunaDaTela(filhos: [Text('a')]));
    final p = t
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
        .padding! as EdgeInsets;
    expect(p.top, CoreflowEspaco.gutter,
        reason: 'a coluna começa à mesma distância da barra e das bordas');
    expect(p.bottom, CoreflowEspaco.respiroDoRodape,
        reason: 'o respiro do rodapé já tinha nome e valia 32; as 50 colunas '
            'medidas tinham 12 valores diferentes, e nenhuma usava este');
    expect(p.bottom, DilettaSpacing.s8);
  });

  testWidgets('quem já vive dentro de um scroll não ganha um segundo',
      (t) async {
    await montar(
        t, const CoreflowColunaDaTela(rola: false, filhos: [Text('a')]));
    expect(find.byType(SingleChildScrollView), findsNothing,
        reason: 'duas rolagens aninhadas no mesmo eixo');
  });

  testWidgets('CoreflowAoCentro centra SEM esticar na vertical', (t) async {
    await montar(t, const CoreflowAoCentro(child: Text('a')));
    final a = t.widget<Align>(find.ancestor(
        of: find.text('a'), matching: find.byType(Align)));
    expect(a.alignment, Alignment.center);
    expect(a.heightFactor, 1,
        reason: 'sem isto o envelope estica na altura e recentraliza o que '
            'estiver dentro — a mesma razão do CoreflowLarguraDeConteudo');
  });
}
