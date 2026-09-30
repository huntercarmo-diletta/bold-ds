import 'package:coreflow/coreflow.dart';
import 'o_neto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O RODAPÉ DA PÁGINA VAI ATÉ A BORDA DO APARELHO.
///
/// O `CoreflowPagina` embrulhava o `bottomBar` num `SafeArea`. Só que os dois rodapés que as telas
/// passam ali já cuidam do inset sozinhos: o `CoreflowRodape.button` pelo `DilettaBottomHomeIndicator`
/// do pai, que reserva `viewPadding.bottom`, e o `CoreflowAcaoDeRodape` somando `padding.bottom` ao
/// respiro dele.
///
/// O `SafeArea` punha os 34 por fora e, por dentro, descontava o inset do `padding` **e** do
/// `viewPadding` (`MediaQuery.removePadding`). Com `viewPadding.bottom` 0, o indicador do pai entende
/// que está no catálogo e desenha o traço de 134×5. Medido num iPhone, na contestação do Pix: o vidro
/// parava 34 pt acima da borda, com um traço falso dentro dele — "um risco logo abaixo do botão" — e a
/// faixa do fundo da tela embaixo, em toda tela de `CoreflowPagina` com `.button`.
///
/// Por isso o `.button` não mede só onde o vidro termina: o traço falso também mede 34 de altura, e um
/// `removePadding` no slot levaria o vidro até a borda com o traço de volta. O teste cobra que o
/// indicador veja o inset e que nenhum traço de catálogo seja desenhado.
void main() {
  const inset = 34.0;

  Future<void> emAparelho(WidgetTester t, Widget rodape) async {
    t.view.devicePixelRatio = 3;
    t.view.physicalSize = const Size(393 * 3, 852 * 3);
    t.view.padding = const FakeViewPadding(bottom: inset * 3);
    t.view.viewPadding = const FakeViewPadding(bottom: inset * 3);
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DilettaThemeScope(
        theme: Neto.escuro,
        child: CoreflowPagina(
          title: 'Título',
          body: const SizedBox.expand(),
          bottomBar: rodape,
        ),
      ),
    ));
  }

  testWidgets('.button: o vidro encosta na borda de baixo', (t) async {
    await emAparelho(
        t,
        CoreflowRodape.button(
          primary: CoreflowAcaoDeNavegacao(label: 'Entendi', onPressed: () {}),
        ));
    final vidro = t.getRect(find.byType(DilettaGlassSurface).last);
    expect(vidro.bottom, 852,
        reason: 'sem faixa do fundo da tela abaixo do vidro do rodapé');
    final indicador = find.byType(DilettaBottomHomeIndicator);
    expect(t.getSize(indicador).height, inset,
        reason: 'o inset do aparelho é contado uma vez, dentro do vidro');
    expect(MediaQuery.of(t.element(indicador)).viewPadding.bottom, inset,
        reason: 'o indicador vê o inset do aparelho; com 0 ele desenha o traço de catálogo');
    expect(
      find.descendant(
        of: indicador,
        matching: find.byWidgetPredicate((w) =>
            w is Container &&
            w.constraints?.maxWidth == 134 &&
            w.constraints?.maxHeight == 5),
      ),
      findsNothing,
      reason: 'nenhum traço falso: o SO já desenha o dele',
    );
  });

  testWidgets('CoreflowAcaoDeRodape: o botão continua acima do inset', (t) async {
    await emAparelho(t, CoreflowAcaoDeRodape(label: 'Continuar', onTap: () {}));
    final botao = t.getRect(find.byType(CoreflowBotao));
    expect(botao.bottom, 852 - inset - DilettaSpacing.s3,
        reason: 'o rodapé soma o inset ao respiro dele — nem a menos, nem duas vezes');
  });
}
