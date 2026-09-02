import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CARTÃO COBRE AS TRÊS FORMAS QUE A ESCADA NÃO COBRE — gradiente, raio livre e fio de aresta.
///
/// Os três eixos nasceram medindo o que ainda desenhava nas telas depois que tudo o que tinha peça
/// virou peça: **três gradientes** (tipo de conta escolhido, arte do cartão, vidro da entrada),
/// **dois raios não uniformes** (o balão do trilho, a barra de faixa) e **dois fios de uma aresta
/// só** (cabeçalho da personalização embaixo, barra de seleção em cima).
///
/// Nenhum deles é escada nova: são a mesma escada montada de outro jeito, e o que o eixo compra é a
/// CAIXA ser a peça — com o respiro, a sombra e o toque vindo dela em vez de serem remontados.
void main() {
  Widget naTela(Widget filho) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(
          theme: CoreflowTheme.dark,
          child: Scaffold(body: Center(child: filho)),
        ),
      );

  BoxDecoration decoracao(WidgetTester t) => t
      .widget<DecoratedBox>(find.descendant(
          of: find.byType(CoreflowCartao), matching: find.byType(DecoratedBox)))
      .decoration as BoxDecoration;

  testWidgets('o gradiente vence a cor chapada', (t) async {
    await t.pumpWidget(naTela(const CoreflowCartao(
      color: Color(0xFF00FF00),
      gradiente: LinearGradient(colors: [Color(0xFFFE3976), Color(0xFFFFC800)]),
      child: SizedBox(width: 80, height: 40),
    )));
    final d = decoracao(t);
    expect(d.gradient, isNotNull);
    // Um gradiente e uma cor chapada na mesma superfície é uma das duas sendo ignorada. Melhor por
    // contrato do que por ordem de pintura.
    expect(d.color, isNull);
  });

  testWidgets('a forma livre vence o raio uniforme', (t) async {
    await t.pumpWidget(naTela(const CoreflowCartao(
      radius: 24,
      forma: BorderRadius.only(topRight: Radius.circular(12)),
      semBorda: true,
      child: SizedBox(width: 80, height: 40),
    )));
    final br = decoracao(t).borderRadius! as BorderRadius;
    expect(br.topRight, const Radius.circular(12));
    // O canto que a forma não declara é VIVO — é isso que faz o balão apontar.
    expect(br.topLeft, Radius.zero);
  });

  testWidgets('o fio de aresta substitui a borda de quatro lados', (t) async {
    await t.pumpWidget(naTela(CoreflowCartao(
      fio: const Border(top: BorderSide(color: Color(0xFF333333))),
      child: const SizedBox(width: 80, height: 40),
    )));
    final b = decoracao(t).border! as Border;
    expect(b.top.color, const Color(0xFF333333));
    expect(b.bottom, BorderSide.none);
  });

  testWidgets('e sem nenhum dos três a superfície continua sendo a do PAI', (t) async {
    // O CONTROLE: os três eixos desenham aqui em vez de delegar, e sem ele um erro de condição
    // faria TODO cartão parar de usar o material do pai sem ninguém ver.
    await t.pumpWidget(naTela(const CoreflowCartao(child: SizedBox(width: 80, height: 40))));
    expect(find.byType(DilettaCardSurface), findsOneWidget);
  });
}
