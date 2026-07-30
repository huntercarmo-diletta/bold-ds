import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// DOIS GRADIENTES, E SÓ.
///
/// Regra do dono do produto (2026-07-30): no máximo dois — `primary` e `accent` — e o resto se
/// modula neles. Este teste é a regra virada mecanismo: o terceiro gradiente não passa em code
/// review, falha no gate.
///
/// Vale porque foi exatamente assim que dez apareceram. Nenhum deles chegou por decisão de
/// desenho: chegaram um por vez, cada um resolvendo uma tela, e sete terminaram com ZERO uso —
/// azul, âmbar, verde, azul claro e roxo, uma cor por tipo de transação, numa marca rosa.
/// Convenção não segura isso; contagem segura.
void main() {
  test('a marca tem exatamente DOIS gradientes', () {
    expect(BoldGradients.todos.keys, ['primary', 'accent'],
        reason: 'a regra é dois. Se um terceiro caso apareceu, ele se modula nos dois — e se '
            'não se modula, é pedido ao pai ou decisão de desenho, não token novo aqui');
  });

  test('os dois PARTEM da paleta, senão o gradiente congela a identidade', () {
    // A cor de partida sai de `primary04`. É o que faz o gradiente acompanhar a marca em vez
    // de virar um par de hexes que ninguém troca — a mesma razão pela qual o pai converteu os
    // gradientes dele em função da paleta.
    for (final g in BoldGradients.todos.entries) {
      expect(g.value.colors.first, BoldPalette.bold.primary04,
          reason: 'o gradiente "${g.key}" não começa na cor de ação da paleta');
    }
  });

  test('primary é o pôr do sol de três paradas; accent é o corte de duas', () {
    expect(BoldGradients.primary.colors, hasLength(3));
    expect(BoldGradients.primary.stops, [0.0, 0.5, 1.0]);
    expect(BoldGradients.accent.colors, hasLength(2));
  });

  test('o conteúdo sobre gradiente é o INK, e o branco seria ilegível', () {
    // Medido, branco sobre as três paradas do primary: 3.46 · 2.56 · 1.21. Nenhuma passa AA de
    // texto, e o amarelo é invisível. O produto antigo tinha `onGradient = white` com um
    // comentário no mesmo arquivo admitindo que o branco lava no amarelo.
    //
    // Este teste fixa a escolha e mede a razão dela, pra ninguém "consertar" de volta pro
    // branco olhando só o rosa — que é o único lugar onde o branco quase funciona.
    expect(BoldGradients.onGradient, BoldPalette.bold.neutral01);

    double contraste(Color a, Color b) {
      final la = a.computeLuminance(), lb = b.computeLuminance();
      final (hi, lo) = la > lb ? (la, lb) : (lb, la);
      return (hi + 0.05) / (lo + 0.05);
    }

    final paradas = BoldGradients.primary.colors;
    // O ink ganha do branco na parada onde a diferença importa: a mais clara.
    final maisClara = paradas.reduce(
        (a, b) => a.computeLuminance() > b.computeLuminance() ? a : b);
    expect(contraste(BoldGradients.onGradient, maisClara),
        greaterThan(contraste(BoldPalette.bold.white, maisClara)),
        reason: 'na parada mais clara o ink tem que ler melhor que o branco');
    expect(contraste(BoldPalette.bold.white, maisClara), lessThan(1.5),
        reason: 'se isto subiu, a parada clara mudou — e a regra de conteúdo muda com ela');
  });
}
