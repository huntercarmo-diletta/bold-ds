import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// O BRILHO DO ESQUELETO É DA MARCA, e uma linha da paleta é o que diz isso.
///
/// O relato: *"o skeleton tem um shimmer rosinha, agora só é o frame cinza"* — dito olhando o app depois
/// de a adoção trocar o `BoldSkeleton` (forma + animação numa peça só) pelo par do pai
/// (`DilettaSkeleton` + `DilettaShimmer`). A forma veio, a animação ficou pra trás, e o brilho — quando
/// voltou — era **neutro**, porque a cor dele estava cravada no componente.
///
/// O veredito (`ds v0.34.0`) trouxe `brilhoDoEsqueleto` com nulo mantendo o neutro. Aqui se mede a
/// declaração **e** o pixel: a cor tem que aparecer na varredura, senão a linha da paleta é enfeite.
void main() {
  test('a paleta declara o brilho, e ele é o rosa da marca', () {
    expect(BoldPalette.bold.brilhoDoEsqueleto, BoldColors.primary07,
        reason: 'sem a declaração o brilho volta a ser neutro — e ninguém falha, só some a marca');
  });

  testWidgets('e a varredura pinta ROSA — medido em pixel', (t) async {
    const chave = Key('paraLerOsPixels');

    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: RepaintBoundary(
          key: chave,
          child: ColoredBox(
            // Fundo neutro escuro: o rosa da banda tem que aparecer contra ele.
            color: const Color(0xFF101014),
            child: Center(
              child: SizedBox(
                width: 300,
                height: 80,
                child: DilettaShimmer(child: DilettaSkeleton.box(height: 80)),
              ),
            ),
          ),
        ),
      ),
    ));
    // Meio da varredura: o `ShaderMask` anima, então a banda passa pelo centro no meio do ciclo.
    await t.pump(const Duration(milliseconds: 600));

    late final Uint8List rgba;
    late final ui.Image imagem;
    await t.runAsync(() async {
      final boundary = t.renderObject<RenderRepaintBoundary>(find.byKey(chave));
      imagem = await boundary.toImage();
      rgba = (await imagem.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    });

    // Varre a faixa horizontal do meio do esqueleto e guarda o pixel MAIS rosa (maior R−G).
    var maiorRosa = -255;
    final y = imagem.height ~/ 2;
    for (var x = imagem.width ~/ 2 - 140; x < imagem.width ~/ 2 + 140; x++) {
      final i = (y * imagem.width + x) * 4;
      final rosa = rgba[i] - rgba[i + 1];
      if (rosa > maiorRosa) maiorRosa = rosa;
    }

    // Neutro daria R≈G. O rosa da marca (`primary07`) puxa o vermelho — é o que distingue "brilha" de
    // "brilha com a cor de alguém".
    expect(maiorRosa, greaterThan(12),
        reason: 'a banda mais rosa da varredura tem R−G = $maiorRosa: isso é brilho NEUTRO');

    // E o CONTROLE, que é o que faz a asserção acima valer alguma coisa: o mesmo esqueleto SEM shimmer
    // tem que sair cinza puro. Sem esta metade, um `surfaceLoading` levemente quente passaria o teste e
    // eu concluiria que o brilho pinta quando ele não pinta nada.
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: RepaintBoundary(
          key: const Key('semBrilho'),
          child: ColoredBox(
            color: const Color(0xFF101014),
            child: Center(
              child: SizedBox(width: 300, height: 80, child: DilettaSkeleton.box(height: 80)),
            ),
          ),
        ),
      ),
    ));
    await t.pump();

    late final Uint8List cru;
    late final ui.Image imagemCrua;
    await t.runAsync(() async {
      final b = t.renderObject<RenderRepaintBoundary>(find.byKey(const Key('semBrilho')));
      imagemCrua = await b.toImage();
      cru = (await imagemCrua.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    });
    final iMeio = ((imagemCrua.height ~/ 2) * imagemCrua.width + imagemCrua.width ~/ 2) * 4;
    expect(cru[iMeio] - cru[iMeio + 1], lessThan(4),
        reason: 'o esqueleto SEM shimmer já sai avermelhado (R−G = ${cru[iMeio] - cru[iMeio + 1]}), '
            'então a medição de cima não distingue brilho de superfície');
  });
}
