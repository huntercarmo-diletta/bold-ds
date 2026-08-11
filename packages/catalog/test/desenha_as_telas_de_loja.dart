@Tags(['ferramenta'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/telas_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// FERRAMENTA: desenha cada tela num PNG pra alguém OLHAR.
///
/// A suíte inteira passar não é a mesma coisa que a tela estar certa — o divisor invisível do
/// extrato passou por todos os gates deste repo e foi achado num print. Este arquivo existe pra que
/// o passo "abrir o artefato" custe um comando em vez de um deploy.
/// A tela SEM os bindings, e essa é a diferença entre um board e um screenshot.
///
/// O board desenha `{saldoFormatado}` no lugar do valor de propósito: ele documenta o CONTRATO, e
/// ver o nome do campo é o ponto. Uma imagem de loja documenta o PRODUTO — e nela o nome do campo é
/// exatamente o que não pode aparecer.
///
/// As props literais já estão na spec (o compositor guarda as duas coisas), então limpar o mapa de
/// bindings devolve a tela com os valores de exemplo. Nada aqui muda a fonte: é uma cópia.
ScreenSpec _semBindings(ScreenSpec tela) {
  Block limpo(Block b) => Block(
        id: b.id,
        type: b.type,
        props: b.props,
        slots: {
          for (final e in b.slots.entries) e.key: e.value.map(limpo).toList(),
        },
        fill: b.fill,
        fixedMain: b.fixedMain,
        sticky: b.sticky,
        crossAlign: b.crossAlign,
      );
  return ScreenSpec(
    name: tela.name,
    form: tela.form,
    blocks: tela.blocks.map(limpo).toList(),
    top: tela.top.map(limpo).toList(),
    bottom: tela.bottom.map(limpo).toList(),
    contentGap: tela.contentGap,
    scrollableContent: tela.scrollableContent,
  );
}

void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  final saida = Directory('build/telas_de_loja')..createSync(recursive: true);

  for (final escuro in [false, true]) {
    for (final slug in [
      kSlugDaHome,
      kSlugDoHubDePix,
      kSlugDaConta,
      kSlugDoExtrato,
      kSlugDaAprovacao,
    ]) {
      testWidgets('$slug ${escuro ? "escuro" : "claro"}', (t) async {
        // 393×852 é o frame do produto. O `devicePixelRatio` 2 dá um PNG legível em tela cheia.
        t.view.physicalSize = const Size(393 * 2, 852 * 2);
        t.view.devicePixelRatio = 2.0;
        addTearDown(t.view.reset);

        final chave = GlobalKey();
        await t.pumpWidget(RepaintBoundary(
          key: chave,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: BoldFonts.familyRaw),
            // `Scaffold` porque o campo de busca é `TextField`, e ele exige um ancestral Material.
            // O frame do board já dá um; aqui a árvore é montada à mão.
            home: Scaffold(
              backgroundColor: const Color(0x00000000),
              body: DilettaThemeScope(
              theme: escuro ? BoldTheme.dark : BoldTheme.light,
              child: Builder(builder: (ctx) {
                final s = DilettaTheme.schemeOf(ctx);
                return ColoredBox(
                  color: s.bg,
                  child: Stack(children: [
                    // O gancho devolve `Widget?` (nem todo DS tem fundo); aqui ele sempre tem.
                    Positioned.fill(
                        child: Ds.fundoDoFrame(ctx) ?? const SizedBox()),
                    buildScreenLayout(_semBindings(telasDoBold()[slug]!),
                        leaf: buildBlock),
                  ]),
                );
              }),
              ),
            ),
          ),
        ));
        await t.pump(const Duration(milliseconds: 600));

        await t.runAsync(() async {
          final limite = chave.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
          final imagem = await limite.toImage(pixelRatio: 2);
          final bytes = await imagem.toByteData(format: ui.ImageByteFormat.png);
          File('${saida.path}/$slug-${escuro ? "escuro" : "claro"}.png')
              .writeAsBytesSync(bytes!.buffer.asUint8List());
        });
      });
    }
  }
}
