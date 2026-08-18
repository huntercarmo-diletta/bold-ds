import 'dart:math' as math;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// A RAMPA DE TEXTO DO ESCURO É A DECLARADA — e os dois derivados saem do par.
///
/// Os quatro campos entraram na `v0.109.0` do pai, a pedido deste filho. O que este gate protege
/// não é o valor: é a DECLARAÇÃO chegar. Campo opcional que ninguém liga cai na rampa neutra em
/// silêncio, e a rampa neutra é cinza puro — que é exatamente o defeito que o pedido descreveu.
void main() {
  double _lin(double c) => c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4) as double;

  test('os quatro campos declarados chegam nos sete papéis', () {
    final s = DilettaScheme.dark(BoldPalette.bold);

    // `texto` serve DOIS papéis, e os dois têm que ser o branco declarado.
    expect(s.fg.toARGB32(), BoldColors.textoEscuro.toARGB32());
    expect(s.onSurface.toARGB32(), BoldColors.textoEscuro.toARGB32());

    expect(s.textSecondary.toARGB32(), BoldColors.textoSecundarioEscuro.toARGB32());

    // `mudo` também serve dois — e o `textPlaceholder` era o que ia divergir sozinho se o pai
    // tivesse aberto porta separada pra cada papel.
    expect(s.textMuted.toARGB32(), BoldColors.textoMudoEscuro.toARGB32());
    expect(s.textPlaceholder.toARGB32(), BoldColors.textoMudoEscuro.toARGB32());

    expect(s.border.toARGB32(), BoldColors.bordaEscura.toARGB32());
    expect(s.divider.toARGB32(), BoldColors.bordaEscura.toARGB32());
  });

  test('o terciário e o desabilitado DERIVAM do par, e carregam a temperatura', () {
    final s = DilettaScheme.dark(BoldPalette.bold);

    // A prova de que a derivação transpõe a TEMPERATURA e não só a luminância: cinza puro tem
    // distância zero entre os canais, e esta rampa é azulada.
    int spread(Color c) {
      final r = (c.r * 255).round(), g = (c.g * 255).round(), b = (c.b * 255).round();
      return [r, g, b].reduce(math.max) - [r, g, b].reduce(math.min);
    }

    expect(spread(s.textTertiary), greaterThan(10),
        reason: 'o terciário saiu CINZA: a derivação perdeu a temperatura do par declarado');
    expect(spread(s.textDisabled), greaterThan(10));

    // E ele mora ENTRE os vizinhos, que é a regra que o pai escreveu.
    double lum(Color c) =>
        0.2126 * _lin(c.r) + 0.7152 * _lin(c.g) + 0.0722 * _lin(c.b);
    expect(lum(s.textTertiary), lessThan(lum(s.textSecondary)));
    expect(lum(s.textTertiary), greaterThan(lum(s.textMuted)));
  });

  test('e o CLARO também é declarado — os quatro do espelho, v0.111.0', () {
    final s = DilettaScheme.light(BoldPalette.bold);

    expect(s.fg.toARGB32(), BoldColors.textoClaro.toARGB32());
    expect(s.onSurface.toARGB32(), BoldColors.textoClaro.toARGB32());
    expect(s.textSecondary.toARGB32(), BoldColors.textoSecundarioClaro.toARGB32());
    expect(s.textMuted.toARGB32(), BoldColors.textoMudoClaro.toARGB32());
    expect(s.border.toARGB32(), BoldColors.bordaClara.toARGB32());

    // O DEFEITO QUE ESTE ESPELHO CONSERTOU, cravado como número: o mudo do claro estava em 2,96
    // sobre a superfície — abaixo do piso de texto grande — enquanto eu defendia 3,81 pro mesmo
    // papel no escuro. Se alguém clarear este degrau de novo, esta linha acusa.
    double _l(double c) => c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4) as double;
    double lum(Color c) => 0.2126 * _l(c.r) + 0.7152 * _l(c.g) + 0.0722 * _l(c.b);
    final contraste = (lum(s.surface) + 0.05) / (lum(s.textMuted) + 0.05);
    expect(contraste, greaterThan(3.0), reason: 'o mudo do claro voltou a ficar invisível');
  });
}
