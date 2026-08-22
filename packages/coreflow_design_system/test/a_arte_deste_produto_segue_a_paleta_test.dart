import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ARTE DESTE PRODUTO SEGUE A PALETA — e até 20/08 ela era a última coisa que não seguia.
///
/// O gate `o_neto_troca_a_paleta_e_pronto` mede 35 papéis de cor viajando com dívida ZERO, e ele
/// está certo — sobre COR. As ilustrações ficaram fora da conta porque moravam no app como SVG
/// cru, com o rosa cozido dentro, carregadas por caminho montado à mão. Um neto que trocasse a
/// paleta receberia um app inteiro na cor dele **com centenas de pinturas rosa espalhadas pelos vazios**.
///
/// Aqui a prova é em pixel e em duas paletas: a mesma arte, o mesmo arquivo, dois donos.
void main() {
  /// O neto: a paleta de referência do pai, que é verde (`primary04` = `#0E7C5F`).
  final neto = DilettaPalette.referencia;

  Future<Uint8List> pintar(WidgetTester t, DilettaPalette paleta, {bool escuro = false}) async {
    const chave = Key('arte');
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: DilettaTheme.resolve(
          palette: paleta,
          brand: CoreflowTheme.marca,
          brightness: escuro ? Brightness.dark : Brightness.light,
        ),
        child: Center(
          child: RepaintBoundary(
            key: chave,
            child: const ColoredBox(
              color: Color(0xFF808080),
              child: CoreflowIlustracao(CoreflowArte.sucessoAlternativo, tamanho: 300),
            ),
          ),
        ),
      ),
    ));
    await t.pumpAndSettle();
    late Uint8List rgba;
    await t.runAsync(() async {
      final b = t.renderObject<RenderRepaintBoundary>(find.byKey(chave));
      final img = await b.toImage();
      rgba = (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    });
    return rgba;
  }

  /// Quantos pixels da imagem batem EXATO com uma cor.
  int quantos(Uint8List rgba, Color cor) {
    // ignore: deprecated_member_use
    final r = cor.red, g = cor.green, b = cor.blue;
    var n = 0;
    for (var i = 0; i < rgba.length; i += 4) {
      if (rgba[i] == r && rgba[i + 1] == g && rgba[i + 2] == b) n++;
    }
    return n;
  }

  testWidgets('a mesma arte sai ROSA aqui e VERDE no neto — medido em pixel', (t) async {
    final nossa = await pintar(t, BoldPalette.bold);
    final doNeto = await pintar(t, neto);

    final rosaNaNossa = quantos(nossa, BoldColors.primary04);
    final verdeNaNossa = quantos(nossa, neto.primary04);
    final rosaNoNeto = quantos(doNeto, BoldColors.primary04);
    final verdeNoNeto = quantos(doNeto, neto.primary04);

    expect(rosaNaNossa, greaterThan(500),
        reason: 'a arte tem 4 pinturas no `primary04` — se não aparece rosa aqui, a medição está '
            'olhando pro lugar errado antes de julgar o neto');
    expect(verdeNoNeto, greaterThan(500),
        reason: 'o neto trocou a paleta e a ilustração continuou na cor do pai dele '
            '(rosa=$rosaNoNeto verde=$verdeNoNeto)');
    expect(rosaNoNeto, 0, reason: 'sobrou rosa do Conta BOLD dentro da arte do neto');
    expect(verdeNaNossa, 0, reason: 'a arte daqui não pode ter verde da referência');
  });

  testWidgets('e o escuro também — é outro arquivo, e ele tem os mesmos degraus', (t) async {
    final doNeto = await pintar(t, neto, escuro: true);
    // O degrau medido aqui é o 06, e não é escolha de gosto: é o que ESTA arte pinta mais (51 das
    // 105 pinturas do `_dark`). Escolher o degrau pelo que o desenho usa, em vez de pelo que soa
    // certo, é o que impede o gate de passar por não ter o que medir — foi o que aconteceu na
    // primeira versão, que pedia o 05 num arquivo que não tem 05 nenhum.
    expect(quantos(doNeto, neto.primary06), greaterThan(500),
        reason: 'o `_dark` não recolore: o mapper é montado no build e o arquivo muda com o tema');
    expect(quantos(doNeto, BoldColors.primary06), 0, reason: 'rosa do Conta BOLD no escuro do neto');
  });

  testWidgets('os 8 nomes têm arquivo nos dois temas — nome sem arte é caixa vazia', (t) async {
    for (final arte in CoreflowArte.values) {
      for (final escuro in [false, true]) {
        await t.pumpWidget(MaterialApp(
          home: DilettaThemeScope(
            theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
            child: Center(child: CoreflowIlustracao(arte, tamanho: 100)),
          ),
        ));
        await t.pumpAndSettle();
        expect(tester_semErro(t), isTrue, reason: '${arte.base} (${escuro ? 'dark' : 'light'})');
      }
    }
  });
}

/// `SvgPicture.asset` não lança quando o asset falta: ele desenha vazio e loga. O que dá pra
/// afirmar sem falso verde é que nenhuma exceção subiu no pump.
bool tester_semErro(WidgetTester t) => t.takeException() == null;
