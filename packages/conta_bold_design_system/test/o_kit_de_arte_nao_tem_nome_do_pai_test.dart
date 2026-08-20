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

    // As TRÊS exceções declaradas, e as três são declaradas pela mesma razão: estão VIVAS.
    // `internet_off` aparece em 4 telas, `success` em 2, `security_phone` no card da home.
    //
    // Medido em 20/08, olhando as artes lado a lado renderizadas: **as três são o desenho DELE com
    // um blob rosa atrás.** Mesma figura, mesma pose, mesmos objetos — a única diferença de
    // geometria é uma forma orgânica de fundo que a cópia daqui acrescenta (os 26% e 54% que uma
    // comparação de string dava eram ruído de export, não desenho).
    //
    // Por isso elas NÃO saíram junto com `online_payment` e `timer_woman`: aquelas duas tinham as
    // duas condições (duplicada e sem uso), estas têm uma só. Adotar a peça dele aqui apaga o blob
    // em 7 telas vivas — isso é decisão de quem olha a tela, não consequência de inventário.
    expect(colidem, {'internet_off', 'success', 'security_phone'},
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
}
