import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O ESQUEMA NÃO ESCREVE UM HEX — o tradutor entre paleta e papel não decide cor.
///
/// Veio do filho em 08/09 com o `coreflow_scheme.dart`. A causa raiz que ele vira mecanismo: enquanto o
/// esquema pudesse escrever `Color(0x…)`, qualquer conserto de retema seria desfeito pelo próximo
/// papel que alguém cravasse ali — e cravar ali é mais fácil que declarar na paleta. Foi assim que 21
/// valores ficaram presos no primeiro produto até 19/08.
void main() {
  test('e o esquema não escreve UM hex — o tradutor não decide cor', () {
    // A causa raiz, virada mecanismo. Enquanto este arquivo pudesse escrever `Color(0x…)`, qualquer
    // conserto de retema seria desfeito pelo próximo papel que alguém cravasse aqui — e cravar aqui é
    // mais fácil que declarar na paleta, que é o que faz a regra precisar de gate e não de acordo.
    final fonte = const String.fromEnvironment('nao-usado').isEmpty
        ? File('lib/src/coreflow_scheme.dart').readAsStringSync()
        : '';
    final hex = RegExp(r'Color\(0x[0-9A-Fa-f]{6,8}\)').allMatches(fonte).length;
    expect(hex, 0,
        reason: 'o esquema é o TRADUTOR entre paleta e papel. Valor literal aqui é decisão de cor '
            'no único lugar onde nenhuma paleta alcança — foi assim que 21 valores ficaram presos');
  });

}
