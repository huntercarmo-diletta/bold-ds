import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O DISCO SEGURA QUALQUER COISA — e o anel separa ele do que está atrás.
///
/// A peça nasceu de seis sítios que desenhavam a mesma forma à mão com números diferentes. O gate
/// cobre as duas coisas que os seis pediam e que as outras peças de círculo não davam: **conteúdo
/// que não é glifo** (número, spinner, avatar) e **anel na cor do que está atrás**.
void main() {
  Widget naTela(Widget filho) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(
          theme: CoreflowTheme.dark,
          child: Scaffold(body: Center(child: filho)),
        ),
      );

  BoxDecoration deco(WidgetTester t) => t
      .widget<DecoratedBox>(find.descendant(
          of: find.byType(CoreflowDisco), matching: find.byType(DecoratedBox)))
      .decoration as BoxDecoration;

  testWidgets('ele é redondo, do diâmetro pedido, e centra o filho', (t) async {
    await t.pumpWidget(naTela(const CoreflowDisco(
      tamanho: 24,
      preenchimento: Color(0xFF2FBF6B),
      child: Text('3'),
    )));
    expect(t.getSize(find.byType(CoreflowDisco)), const Size(24, 24));
    expect(deco(t).shape, BoxShape.circle);
    // Texto sem centro explícito assenta na baseline — num disco de 24 isso encosta embaixo.
    expect(find.descendant(of: find.byType(CoreflowDisco), matching: find.byType(Center)),
        findsWidgets);
  });

  testWidgets('sem anel, não desenha borda; com anel, desenha na cor pedida', (t) async {
    await t.pumpWidget(naTela(const CoreflowDisco(tamanho: 18, preenchimento: Color(0xFFFE3976))));
    expect(deco(t).border, isNull);

    await t.pumpWidget(naTela(const CoreflowDisco(
      tamanho: 18,
      preenchimento: Color(0xFFFE3976),
      anel: Color(0xFF14151F),
      larguraDoAnel: 2,
    )));
    final b = deco(t).border! as Border;
    // A cor do anel é a do que está ATRÁS — é o que separa o selo do que ele marca.
    expect(b.top.color, const Color(0xFF14151F));
    expect(b.top.width, 2);
  });

  testWidgets('sem `tamanho` ele dimensiona pelo FILHO', (t) async {
    // O anel do radar envolve o avatar, e quem sabe o tamanho do avatar é o avatar. Exigir o
    // número ali obrigaria a tela a repetir uma medida que não é dela.
    await t.pumpWidget(naTela(const CoreflowDisco(
      anel: Color(0xFF686D7E),
      child: SizedBox(width: 48, height: 48),
    )));
    expect(t.getSize(find.byType(CoreflowDisco)), const Size(48, 48));
  });

  testWidgets('vazado é um estado, não a ausência de um', (t) async {
    // O nó do trilho que ainda não chegou: anel sim, preenchimento não.
    await t.pumpWidget(naTela(const CoreflowDisco(
      tamanho: 26,
      anel: Color(0xFF686D7E),
      larguraDoAnel: 1.5,
      child: Text('2'),
    )));
    expect(deco(t).color, isNull);
    expect(deco(t).border, isNotNull);
    expect(find.text('2'), findsOneWidget);
  });
}
