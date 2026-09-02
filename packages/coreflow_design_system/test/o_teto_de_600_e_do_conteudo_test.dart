import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O TETO É DO CONTEÚDO, E A ARTE SANGRA — as duas metades da mesma regra.
///
/// O teto de 600 foi escrito pelo time do app entre 27/08 e 01/09, numa casca que **sombreava** o
/// `CoreflowBackground` deste pacote: o barril de lá escondia a peça daqui e exportava a de lá, e os
/// ~130 sítios ganhavam o teto sem mudar uma linha. O `///` da casca já dizia que ela morria no dia
/// em que o pai aceitasse um `limitarConteudo`.
///
/// Este gate cobra as duas metades, porque cada uma sozinha é um defeito diferente: sem o teto, o
/// texto atravessa um tablet inteiro; sem o sangramento, o produto vira uma coluna estreita entre
/// duas faixas vazias.
void main() {
  /// A JANELA DO TESTE, e não um `SizedBox` — foi a primeira tentativa e ela mediu errado.
  ///
  /// Embrulhar num `SizedBox(width: 760)` dentro do `MaterialApp` não estreita nada: o `home` já
  /// preenche a janela de 800 do harness, e o que se mede volta 800. Uma regra que depende da
  /// LARGURA DA TELA se testa mudando a tela.
  void janela(WidgetTester t, double largura) {
    t.view.physicalSize = Size(largura * t.view.devicePixelRatio, 800 * t.view.devicePixelRatio);
    addTearDown(t.view.resetPhysicalSize);
  }

  Widget naTela(Widget filho) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(theme: CoreflowTheme.dark, child: filho),
      );

  testWidgets('numa tela larga o conteúdo para em 600', (t) async {
    janela(t, 900);
    const alvo = Key('conteudo');
    await t.pumpWidget(naTela(const CoreflowBackground(
        estilo: CoreflowBackdrop.solido,
        child: SizedBox.expand(child: ColoredBox(color: Color(0xFF00FF00), key: alvo)))));
    await t.pump();
    expect(t.getSize(find.byKey(alvo)).width, CoreflowLargura.teto);
  });

  testWidgets('e com `limitarConteudo: false` ele usa a largura cheia', (t) async {
    janela(t, 900);
    const alvo = Key('conteudo');
    await t.pumpWidget(naTela(const CoreflowBackground(
        estilo: CoreflowBackdrop.solido,
        limitarConteudo: false,
        child: SizedBox.expand(child: ColoredBox(color: Color(0xFF00FF00), key: alvo)))));
    await t.pump();
    expect(t.getSize(find.byKey(alvo)).width, 900);
  });

  testWidgets('num telefone o teto não aperta nada', (t) async {
    janela(t, 390);
    const alvo = Key('conteudo');
    await t.pumpWidget(naTela(const CoreflowBackground(
        estilo: CoreflowBackdrop.solido,
        child: SizedBox.expand(child: ColoredBox(color: Color(0xFF00FF00), key: alvo)))));
    await t.pump();
    // O `math.min` é o que garante isto: teto é limite, não largura fixa.
    expect(t.getSize(find.byKey(alvo)).width, 390);
  });

  testWidgets('a sobra lateral é o que um overlay precisa saber', (t) async {
    janela(t, 900);
    late double sobra;
    await t.pumpWidget(naTela(Builder(builder: (c) {
      sobra = coreflowSobraLateral(c);
      return const SizedBox();
    })));
    // (900 − 600) / 2. Sem isto, um overlay posicionado por coordenada absoluta cola na borda da
    // TELA em vez da borda do conteúdo.
    expect(sobra, 150);
  });
}
