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

  test('o primary parte da cor de AÇÃO; o accent vive na rampa de laranja', () {
    // O primary começa em `primary04` porque é o gradiente que representa a marca — se ele não
    // parte da cor de ação, ele deixa de acompanhar a identidade. O accent não: ele é o laranja
    // inteiro, então as duas paradas dele são da mesma rampa.
    expect(BoldGradients.primary.colors.first, BoldPalette.bold.primary04);
    expect(BoldGradients.accent.colors,
        everyElement(isIn([BoldPalette.bold.warning03, BoldPalette.bold.warning02])));
  });

  test('os dois são de DUAS paradas, e as quatro saem de rampa', () {
    // Duas paradas por modulação, não por gosto: a terceira (o amarelo do logo) era o que
    // tornava o gradiente ilegível e o que obrigava a ter literal de marca neste arquivo.
    const p = BoldPalette.bold;
    expect(BoldGradients.primary.colors, [p.primary04, p.warning03]);
    expect(BoldGradients.accent.colors, [p.warning03, p.warning02]);
  });

  test('ZERO literal de cor: as quatro paradas são degraus da paleta', () {
    // É o ganho principal da modulação. Enquanto o coral e o amarelo estavam no gradiente, três
    // valores de marca moravam fora da paleta — e valor fora da paleta é valor que o rebrand
    // não alcança.
    final degraus = {
      BoldPalette.bold.primary04,
      BoldPalette.bold.warning03,
      BoldPalette.bold.warning02,
    };
    for (final g in BoldGradients.todos.entries) {
      for (final c in g.value.colors) {
        expect(degraus, contains(c),
            reason: 'o gradiente "${g.key}" tem uma parada que não é degrau da paleta');
      }
    }
  });

  test('o BRANCO passa AA-grande em toda parada, e ganha do ink no pior caso', () {
    // A modulação existe por causa deste teste. Na versão de três paradas, branco chegava a
    // 1.21:1 no amarelo — invisível — e nenhuma tinta servia no gradiente inteiro.
    //
    // Agora: branco em toda parada acima de 3.0 (AA-grande), o que autoriza glifo e rótulo
    // grande. O piso NÃO é 4.5, e é por isso que a regra escrita no token diz "rótulo de botão
    // a 15px usa o sólido, não o gradiente" — o número decide o uso, não o contrário.
    double contraste(Color a, Color b) {
      final la = a.computeLuminance(), lb = b.computeLuminance();
      final (hi, lo) = la > lb ? (la, lb) : (lb, la);
      return (hi + 0.05) / (lo + 0.05);
    }

    expect(BoldGradients.onGradient, BoldPalette.bold.white);

    for (final g in BoldGradients.todos.entries) {
      for (final parada in g.value.colors) {
        final branco = contraste(BoldPalette.bold.white, parada);
        expect(branco, greaterThanOrEqualTo(3.0),
            reason: 'branco reprova em AA-grande numa parada de "${g.key}": '
                '${branco.toStringAsFixed(2)}:1');
      }
    }

    // A comparação que decide `onGradient` é o PIOR caso, não parada a parada: escolhe-se UMA
    // tinta pro gradiente inteiro, e ela é julgada onde ela é mais fraca.
    //
    // Escrevi antes que o branco ganhava "em todas as paradas", e o gate me pegou: no
    // `warning03` o ink dá 3.38 contra 3.37 do branco — empate técnico de 0.01. O que sustenta
    // a escolha é o outro extremo, onde o ink desaba: `warning02` dá 1.74 pro ink e 6.54 pro
    // branco.
    double pior(Color tinta) => BoldGradients.todos.values
        .expand((g) => g.colors)
        .map((p) => contraste(tinta, p))
        .reduce((a, b) => a < b ? a : b);

    expect(pior(BoldPalette.bold.white), greaterThan(pior(BoldPalette.bold.neutral01)),
        reason: 'no pior caso o branco tem que ler melhor que o ink, senão `onGradient` muda');
  });
}
