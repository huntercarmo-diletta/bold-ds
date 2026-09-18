// O GATE QUE LIGA A FOLHA À FONTE.
//
// Sem ele, o CSS vira uma transcrição que ninguém sabe se ainda bate — e a casa já viu esse filme:
// um produto web desta família manteve ~270 tokens copiados à mão do Dart, com zero gates ligando
// os dois, e a pergunta "isto ainda é a nossa cor?" não tinha resposta.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css.dart' show cssDoProdutoComPonte;

void main() {
  test('o CSS emitido é o que está no disco', () {
    final f = File('web/tokens/norte_benk-tokens.css');
    expect(f.existsSync(), isTrue,
        reason: 'o CSS não existe — rode `flutter test test/emite_o_css.dart`');
    expect(
      f.readAsStringSync(),
      cssDoProdutoComPonte(),
      reason: 'o CSS do disco divergiu da fonte. Alguém editou à mão, ou a paleta mudou e ninguém '
          'reemitiu: `flutter test test/emite_o_css.dart`',
    );
  });
}
