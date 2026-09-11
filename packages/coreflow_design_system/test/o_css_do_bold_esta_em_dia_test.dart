// O GATE QUE O IB NÃO TINHA.
//
// O Internet Banking mantém 195 tokens de cor transcritos à mão a partir do Dart deste repo, e zero
// gates ligando a transcrição à fonte — então a pergunta "isto ainda é a nossa cor?" não tem resposta
// lá. Este arquivo existe pra que ela tenha resposta aqui, todo dia, de graça.
//
// Ele não mede hex: mede que o arquivo no disco é BYTE A BYTE o que a fonte emite hoje. Papel novo no
// avô, degrau trocado na rampa do Bold, derivação alterada um andar acima — tudo cai aqui.
import 'dart:io';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('o CSS emitido é o que está no disco', () {
    final f = File('../coreflow_design_system_web/tokens/bold-papeis.css');
    expect(f.existsSync(), isTrue,
        reason: 'bold-papeis.css não existe — rode `flutter test test/emite_o_css_do_bold.dart`');
    expect(
      f.readAsStringSync(),
      coreflowPapeisCss(BoldPalette.bold, produto: 'Conta BOLD'),
      reason: 'o CSS do disco divergiu da fonte. Alguém editou à mão, ou a tinta mudou e ninguém '
          'reemitiu: `flutter test test/emite_o_css_do_bold.dart`',
    );
  });

  test('a folha do Bold cobre os mesmos papéis que a do avô', () {
    final nossos = RegExp(r'--cps-([A-Za-z0-9]+)\s*:')
        .allMatches(coreflowPapeisCss(BoldPalette.bold, produto: 'Conta BOLD'))
        .map((m) => m.group(1)!)
        .toSet();
    final semTinta = dilettaNomesDePapelGen.where((p) => !nossos.contains(p)).toList();

    // Os dois sem tinta são do avô e declarados por ele (`glassStroke`, `skeletonShimmer`): papel que
    // não é cor não vira variável. O que este gate proíbe é um TERCEIRO aparecer sem ninguém ver — é
    // assim que um produto ganha um papel que a web não sabe pintar.
    expect(semTinta.length, lessThanOrEqualTo(2),
        reason: 'papéis sem tinta na folha do Bold: $semTinta');
  });
}
