import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O PAINTER NÃO HERDA FONTE — e o selo quântico provou isso do jeito caro.
///
/// `DilettaType` não carrega família de propósito: ela chega pelo
/// `ThemeData.fontFamily` que o app consumidor declara, e é assim que a mesma
/// escada tipográfica serve dois produtos. Só que `TextPainter` dentro de
/// `CustomPainter` **não vê tema nenhum** — ele recebe o `TextStyle` pronto e
/// desenha. Estilo sem família ali cai na fonte do SISTEMA.
///
/// Foi o que aconteceu com `BoldSeloQuantico`: `Autorização Quântica` era o
/// único texto do produto fora do Inter, no meio da cerimônia que assina
/// dinheiro. Ninguém viu porque teste de widget não mede fonte de painter, e o
/// olho não distingue SF Pro de Inter num rótulo de 14px.
///
/// A régua: **estilo que vai para um painter declara a família.** O nome do
/// parâmetro é o sinal — `estilo*` é como este pacote entrega estilo pronto.
void main() {
  test('todo estilo entregue a painter declara a família da marca', () {
    final ofensores = <String>[];

    for (final arquivo in Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final linhas = arquivo.readAsStringSync().split('\n');
      for (var i = 0; i < linhas.length; i++) {
        final l = linhas[i];
        if (l.trimLeft().startsWith('//')) continue;
        // `estiloX: DilettaType.algo` — a entrega de estilo pronto. A família
        // pode estar na mesma linha ou na continuação (`.copyWith` quebrado).
        if (!RegExp(r'\bestilo\w*:\s*DilettaType\.').hasMatch(l)) continue;
        final trecho = linhas.sublist(i, (i + 3).clamp(0, linhas.length)).join();
        if (trecho.contains('fontFamily')) continue;
        ofensores.add('${arquivo.path.split('/').last}:${i + 1}  ${l.trim()}');
      }
    }

    expect(ofensores, isEmpty,
        reason: 'estilo sem família entregue a um painter sai na fonte do '
            'sistema, não na da marca. Some `fontFamily: BoldFonts.family` '
            'no `copyWith`:\n${ofensores.join('\n')}');
  });
}
