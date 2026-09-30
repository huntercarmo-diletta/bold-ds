import 'package:coreflow/coreflow.dart';
import 'o_neto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O RODAPÉ DA PÁGINA VAI ATÉ A BORDA DO APARELHO.
///
/// O `CoreflowPagina` embrulhava o `bottomBar` num `SafeArea`. Só que os dois rodapés que as telas
/// passam ali já cuidam do inset sozinhos: o `CoreflowRodape.button` pelo `DilettaBottomHomeIndicator`
/// do pai, que reserva `viewPadding.bottom` — e o `SafeArea` zera o `padding`, não o `viewPadding` —,
/// e o `CoreflowAcaoDeRodape` somando `padding.bottom` ao respiro dele.
///
/// O preço foi medido num iPhone, na contestação do Pix: o vidro do rodapé parava 34 pt acima da
/// borda, o indicador de home contado duas vezes, e embaixo dele uma faixa com a cor do fundo da tela
/// — "um risco logo abaixo do botão", em toda tela de `CoreflowPagina` com `.button`.
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
    expect(t.getSize(find.byType(DilettaBottomHomeIndicator)).height, inset,
        reason: 'o inset do aparelho é contado uma vez, dentro do vidro');
  });

  testWidgets('CoreflowAcaoDeRodape: o botão continua acima do inset', (t) async {
    await emAparelho(t, CoreflowAcaoDeRodape(label: 'Continuar', onTap: () {}));
    final botao = t.getRect(find.byType(CoreflowBotao));
    expect(botao.bottom, 852 - inset - DilettaSpacing.s3,
        reason: 'o rodapé soma o inset ao respiro dele — nem a menos, nem duas vezes');
  });
}
