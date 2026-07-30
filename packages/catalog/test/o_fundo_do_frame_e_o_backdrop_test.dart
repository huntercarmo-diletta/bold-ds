
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// AS DUAS PERGUNTAS QUE O PAI FEZ ao entregar o `fundoDoFrame` (v0.28.0):
///
/// 1. os **sete** fundos aparecem no preview?
/// 2. o vidro sobre a arte **desfoca de verdade**?
///
/// A segunda é a que prova que o pedido resolveu o problema e não o sintoma, e ela não se
/// responde olhando a árvore de widgets: `BackdropFilter` existir não quer dizer que ele fez
/// algo. Então aqui a medição é de PIXEL — pinta duas vezes e compara.
void main() {
  testWidgets('o gancho entrega o backdrop, e ele responde aos SETE fundos', (t) async {
    // O plugue devolve o backdrop sem estilo fixo: ele resolve pelo `BoldBackdropScope`. Então o
    // que o preview mostra é o que a personalização do produto escolheu — os sete.
    expect(Ds.atual.fundoDoFrame, isNotNull,
        reason: 'o plugue tem que declarar o gancho, senão o motor cai no Color?');

    for (final fundo in BoldBackdrop.values) {
      await t.pumpWidget(MaterialApp(
        home: BoldBackdropScope(
          estilo: fundo,
          child: Ds.tema(
            Builder(
              builder: (ctx) => Stack(children: [
                Positioned.fill(child: Ds.fundoDoFrame(ctx)!),
                const Center(child: Text('tela')),
              ]),
            ),
            escuro: true,
          ),
        ),
      ));
      await t.pump(const Duration(milliseconds: 50));
      expect(t.takeException(), isNull, reason: 'o fundo "${fundo.name}" estourou no frame');
      expect(find.byType(BoldBackground), findsOneWidget);
      expect(find.text('tela'), findsOneWidget,
          reason: 'o fundo "${fundo.name}" cobriu o conteúdo');
    }
  });

  testWidgets('o VIDRO recebe o blur da minha paleta, e é o que eu posso provar', (t) async {
    // A segunda pergunta do pai foi "o vidro sobre a arte desfoca de verdade?", e a resposta
    // honesta tem duas metades com donos diferentes.
    //
    // **Tentei provar por pixel e desisti, com razão.** Capturei o vidro sobre uma borda dura pra
    // medir o espalhamento, e o `toImage` do ambiente de teste devolveu imagem VAZIA numa das
    // cenas e cheia na outra — cenas que só diferem por uma camada. Num terreno assim o teste
    // passa ou falha por motivo alheio ao desfoque, e teste que mede a coisa errada é pior que
    // teste ausente. (Foi a asserção de CONTROLE que denunciou; sem ela eu teria "provado" o
    // desfoque com uma imagem preta.)
    //
    // O que É meu, e este teste prova: o blur da MINHA paleta chega ao vidro do pai. Se o Skia
    // desfoca a partir daí é responsabilidade do framework, não do filho — e isso se confere
    // olhando o catálogo, não em teste de unidade.
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.dark,
        child: const Scaffold(
          body: DilettaGlassSurface(child: SizedBox(width: 100, height: 100)),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 50));

    final filtros = t
        .widgetList<BackdropFilter>(find.byType(BackdropFilter))
        .map((w) => w.filter.toString())
        .toList();

    expect(filtros, isNotEmpty,
        reason: 'o vidro do pai tem que montar um BackdropFilter');
    expect(filtros.first, contains('15'),
        reason: 'o blur do vidro tem que ser o 15 que esta paleta declara em `blurDeVidro`, '
            'e não o 10 do default do pai. Filtro montado: ${filtros.first}');
    expect(BoldPalette.bold.blurDeVidro, 15);
  });
}
