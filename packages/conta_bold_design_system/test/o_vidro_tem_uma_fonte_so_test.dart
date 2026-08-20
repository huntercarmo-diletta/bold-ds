import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O VIDRO tem UMA fonte, e este gate é o que sobrou de duas.
///
/// A receita mora na paleta desde a `v0.4.0` do pai — *"o pai sabe COMO se constrói vidro; o filho
/// diz de que material ele é"*. E mesmo assim o app declarava a mesma receita outra vez, pelos
/// mesmos cinco valores por outro caminho. Duas fontes sem gate entre elas é drift esperando a
/// primeira mudança.
///
/// Os cinco valores estão PINADOS aqui de propósito. Eles não são cópia da paleta pra o teste
/// concordar consigo mesmo: são a medição feita antes de apagar a segunda fonte, e é ela que diz se
/// a mudança de casa mexeu num pixel.
void main() {
  // A paleta subiu pro escopo do arquivo em 20/08: os helpers do vidro passaram a RECEBER a paleta
  // em vez de ler `BoldPalette.bold` por dentro, e agora todo teste daqui precisa dela.
  final p = BoldPalette.bold;

  test('o vidro do app lê a receita da paleta, e ela não é nula', () {
    expect(p.blurDeVidro, isNotNull);
    expect(p.tinteDeVidroClaro, isNotNull);
    expect(p.tinteDeVidroEscuro, isNotNull);
    expect(p.tracoDeVidroClaro, isNotNull);
    expect(p.tracoDeVidroEscuro, isNotNull);

    expect(BoldVidro.blur(p), p.blurDeVidro);
    expect(BoldVidro.tinte(p, escuro: false), p.tinteDeVidroClaro);
    expect(BoldVidro.tinte(p, escuro: true), p.tinteDeVidroEscuro);
    expect(BoldVidro.traco(p, escuro: false), p.tracoDeVidroClaro);
    expect(BoldVidro.traco(p, escuro: true), p.tracoDeVidroEscuro);
  });

  test('e os cinco valores são os que o app desenhava — medidos em 19/08', () {
    expect(BoldVidro.blur(p), 15);
    expect(BoldVidro.tinte(p, escuro: true).toARGB32(), 0x8016060A); // vinho-tinta a 50%
    expect(BoldVidro.tinte(p, escuro: false).toARGB32(), 0x80FFFFFF); // branco a 50%
    expect(BoldVidro.traco(p, escuro: true).toARGB32(), 0x4DFF9898); // rosa claro a 30%
    expect(BoldVidro.traco(p, escuro: false), BoldColors.primary08);
    expect(BoldVidro.espessuraDoTraco, 1);
    expect(BoldVidro.sombra, isEmpty);
  });

  test('o tinte escuro é o vinho-tinta a 50%, e isso é conta e não coincidência', () {
    // O `///` da paleta afirma que `tinteDeVidroEscuro` é `BoldVinho.ink` a 50%. Afirmação em prosa
    // que ninguém mede é afirmação que envelhece: aqui ela é aritmética.
    final tinte = BoldVidro.tinte(p, escuro: true);
    expect(tinte.toARGB32() & 0x00FFFFFF, BoldVinho.ink.toARGB32() & 0x00FFFFFF);
    // 0x80 e não 0x7F: "50%" escrito em hex é 128/255 = 50,2%, e é esse o valor que viaja.
    expect((tinte.toARGB32() >> 24) & 0xFF, 0x80);
  });

  test('o vidro de ENTRADA é outro material, e não vira variante do primeiro', () {
    // Blur diferente (5 contra 15), gradiente em vez de fill chapado, e base própria. Se um dia os
    // dois convergirem, o certo é apagar um — não é este teste passar por acidente.
    expect(BoldVidroDeEntrada.blur, isNot(BoldVidro.blur));
    expect(BoldVidroDeEntrada.base(p, escuro: true), BoldVinho.lavagem);
    expect(BoldVidroDeEntrada.base(p, escuro: false), BoldColors.primary09);
    expect(BoldVidroDeEntrada.opacidade(escuro: true), 0.60);
    expect(BoldVidroDeEntrada.opacidade(escuro: false), 0.70);
    expect(BoldVidroDeEntrada.sombra, isEmpty);

    // O gradiente sobe: opaco embaixo, transparente no topo. É o que deixa a cidade aparecer.
    final g = BoldVidroDeEntrada.gradiente(p, escuro: true);
    expect(g.begin, Alignment.bottomCenter);
    expect(g.end, Alignment.topCenter);
    expect(g.colors.first.a, greaterThan(g.colors.last.a));
    expect(g.stops, [0, 0.53, 1]);
  });
}
