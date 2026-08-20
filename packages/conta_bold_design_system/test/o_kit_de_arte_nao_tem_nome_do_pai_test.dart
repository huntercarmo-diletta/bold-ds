import 'dart:io';

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// O KIT DAQUI NÃO REPETE ARTE QUE JÁ É DELE — e a regra tem as DUAS condições.
///
/// O acervo saiu de 77 arquivos pra 22 em dois dias, e não foi faxina: cada saída teve razão
/// medida. `key_word` e `no_data` tinham o NOME dele com desenho diferente (33% e 57% da geometria)
/// e viraram a peça dele. `online_payment` e `timer_woman` eram o desenho DELE com um blob rosa por
/// trás, e ninguém chamava — duplicada **e** não usada.
///
/// O que este gate impede é a volta silenciosa: uma arte com nome do pai reaparecendo aqui ganha do
/// mapa de roteamento do app, e o produto volta a desenhar cópia sem ninguém saber.
void main() {
  /// Os nomes que o pai declara no registry dele. Lidos DELE, não copiados.
  final doPai = DilettaIllustration.all.map((i) => i.base).toSet();

  test('nenhum arquivo daqui tem nome de arte do pai — exceto o que ele não desenha', () {
    final meus = Directory('assets/illustrations')
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last.replaceAll('.svg', ''))
        .map((n) => n.replaceAll(RegExp(r'_(light|dark)$'), ''))
        .toSet();

    final colidem = meus.intersection(doPai);

    // ZERO exceções, e a lista fechou em 20/08.
    //
    // Cinco artes daqui eram o desenho DELE com um blob rosa atrás. Duas não tinham uso e saíram
    // pela regra (duplicada **e** não usada). As outras três estavam vivas em 7 telas, e aí a regra
    // não decide — apagar o blob de uma tela em uso é decisão de quem olha a tela. O dono olhou as
    // seis renderizadas lado a lado e escolheu a peça dele nas três.
    //
    // O que fechou o argumento não estava na pergunta: o `internet_off_dark` DAQUI abria com um
    // retângulo preto de canto a canto, e o dele não. Varri as 59 artes do pai — **nenhuma** pinta
    // a própria página. A cópia carregava um defeito que o original nunca teve.
    expect(colidem, isEmpty,
        reason: 'arte com nome do pai voltou pro kit daqui — ela ganha do roteamento e vira cópia '
            'silenciosa. Se for de propósito, a exceção entra nesta lista com a razão');
  });

  test('e todo nome do enum tem os dois arquivos', () {
    for (final arte in BoldArte.values) {
      for (final tema in ['light', 'dark']) {
        expect(File('assets/illustrations/${arte.base}_$tema.svg').existsSync(), isTrue,
            reason: '${arte.base}_$tema.svg não existe — `SvgPicture.asset` desenha VAZIO e não '
                'lança, então isto não aparece em teste de widget');
      }
    }
    // Controle: nenhum arquivo órfão, sem nome no enum.
    final noEnum = BoldArte.values.map((a) => a.base).toSet();
    final emDisco = Directory('assets/illustrations')
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last.replaceAll(RegExp(r'_(light|dark)\.svg$'), ''))
        .toSet();
    expect(emDisco.difference(noEnum), isEmpty,
        reason: 'arte no disco sem nome no enum é peso de bundle que ninguém alcança');
  });

  test('e nenhuma arte pinta a PRÓPRIA página', () {
    // Achado olhando, e só olhando: `internet_off_dark` abria com
    // `<rect width="300" height="300" fill="black"/>` — o fundo da prancheta do Figma, exportado
    // junto. Na página escura do app isso é um QUADRADO PRETO atrás da ilustração, com a emenda
    // aparecendo nos quatro cantos, em 4 telas vivas. Nenhum gate podia ver: o arquivo existe, o
    // recolor roda, os pixels mudam, e o teste de paleta passa igual.
    //
    // Fundo é da TELA. Ilustração que pinta o próprio fundo trava o tema num valor.
    final culpadas = <String>[];
    for (final f in Directory('assets/illustrations').listSync().whereType<File>()) {
      var svg = f.readAsStringSync();
      final vb = RegExp(r'viewBox="0 0 ([\d.]+) ([\d.]+)"').firstMatch(svg);
      if (vb == null) continue;
      final w = double.parse(vb.group(1)!), h = double.parse(vb.group(2)!);

      // `clipPath` e `mask` também carregam um rect do tamanho da arte, e ali ele é a REGIÃO, não
      // tinta: `success_alt` tem um `<rect width="300" height="300" fill="white"/>` dentro do
      // clip, e apagá-lo deixa o arquivo em branco (tentei, e o PNG saiu vazio).
      svg = svg
          .replaceAll(RegExp(r'<clipPath[\s\S]*?</clipPath>'), '')
          .replaceAll(RegExp(r'<mask[\s\S]*?</mask>'), '');

      for (final m in RegExp(r'<rect([^>]*)/>').allMatches(svg)) {
        final attrs = m.group(1)!;
        final mw = RegExp(r'\swidth="([\d.]+)"').firstMatch(attrs);
        final mh = RegExp(r'\sheight="([\d.]+)"').firstMatch(attrs);
        final mf = RegExp(r'\sfill="([^"]+)"').firstMatch(attrs);
        if (mw == null || mh == null || mf == null) continue;
        if (mf.group(1) == 'none') continue;
        // 95%, e o número tem história: a primeira versão deste gate exigiu `>= w` e ficou VERDE
        // com o defeito na frente dela. O `viewBox` do `internet_off` é 302×302 e o rect preto é
        // 300×300 — dois pixels de folga bastaram pro gate não ver o quadrado que eu tinha acabado
        // de ver com o olho.
        if (double.parse(mw.group(1)!) >= w * 0.95 && double.parse(mh.group(1)!) >= h * 0.95) {
          culpadas.add('${f.uri.pathSegments.last}: rect ${mw.group(1)}x${mh.group(1)} '
              'fill=${mf.group(1)} sobre viewBox ${w.toInt()}x${h.toInt()}');
        }
      }
    }
    expect(culpadas, isEmpty, reason: 'arte pintando a própria página:\n${culpadas.join("\n")}');
  });

}
