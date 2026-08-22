import 'package:coreflow_design_system/coreflow_design_system.dart';
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
    expect(CoreflowGradients.bold.todos.keys, ['primary', 'accent'],
        reason: 'a regra é dois. Se um terceiro caso apareceu, ele se modula nos dois — e se '
            'não se modula, é pedido ao pai ou decisão de desenho, não token novo aqui');
  });

  test('o primary parte da cor de AÇÃO; o accent vive na rampa de laranja', () {
    // O primary começa em `primary04` porque é o gradiente que representa a marca — se ele não
    // parte da cor de ação, ele deixa de acompanhar a identidade. O accent não: ele é o laranja
    // inteiro, então as duas paradas dele são da mesma rampa.
    expect(CoreflowGradients.bold.primary.colors.first, BoldPalette.bold.primary04);
    expect(CoreflowGradients.bold.accent.colors,
        everyElement(isIn([BoldPalette.bold.warning03, BoldPalette.bold.warning02])));
  });

  test('o primary é o LOCKUP de OITO paradas, com os offsets do arquivo', () {
    // Reaberto em 19/08 pelo dono do produto. A terceira parada (o amarelo do símbolo) tinha caído
    // em 30/07 por tornar o gradiente ilegível — e o que a reabertura mostrou é que o ilegível era
    // o BRANCO, não o gradiente: com a tinta escura o pior caso é 5,69 contra os 3,37 de antes.
    const p = BoldPalette.bold;
    // **As OITO paradas do arquivo, com os offsets dele.** Eram três até 20/08, escolhidas como
    // amostra da curva — e declaradas SEM offset, o que fez o Flutter distribuí-las igualmente e
    // jogar o coral pra 0,5 quando no símbolo ele está em 0,60. A UI e o logo tinham curvas
    // diferentes no mesmo dia em que eu disse que o gradiente era o do lockup.
    expect(CoreflowGradients.bold.primary.colors, [
      BoldColors.lockup01, BoldColors.lockup02, BoldColors.lockup03, BoldColors.lockup04,
      BoldColors.lockup05, BoldColors.lockup06, BoldColors.lockup07, BoldColors.lockup08,
    ]);
    expect(CoreflowGradients.bold.primary.stops, BoldColors.lockupStops,
        reason: 'sem os offsets do arquivo o Flutter distribui igual, e a curva da UI deixa de ser '
            'a curva do símbolo — foi exatamente o defeito de 19/08');
    expect(CoreflowGradients.bold.accent.colors, [p.warning03, p.warning02]);
  });

  test('ZERO literal SOLTO: toda parada é degrau de rampa ou cor de marca DECLARADA', () {
    // O argumento de 30/07 que sobreviveu à reabertura. O coral e o amarelo do lockup não são
    // degraus e não fingem ser — mas eles não podem morar dentro do arquivo de gradiente, porque
    // valor de marca fora da paleta é valor que o rebrand não alcança. Eles são
    // `BoldColors.lockupCoral` e `lockupAmarelo`, ao lado do vinho.
    //
    // O gate mede a POSSE, não a contagem: mudar o gradiente é livre, esconder um hex nele não é.
    final permitidos = {
      BoldPalette.bold.warning03,
      BoldPalette.bold.warning02,
      // As oito paradas do lockup, declaradas na paleta. `lockup01` É o `primary04`.
      BoldColors.lockup01, BoldColors.lockup02, BoldColors.lockup03, BoldColors.lockup04,
      BoldColors.lockup05, BoldColors.lockup06, BoldColors.lockup07, BoldColors.lockup08,
    };
    for (final g in CoreflowGradients.bold.todos.entries) {
      for (final c in g.value.colors) {
        expect(permitidos, contains(c),
            reason: 'o gradiente "${g.key}" tem uma parada que não é degrau da paleta nem cor de '
                'marca declarada — hex solto em arquivo de gradiente é o que o rebrand não acha');
      }
    }
  });

  test('a TINTA do gradiente é julgada no pior caso, e ela ganhou de branco e de preto', () {
    // **Este teste mudou de resposta em 19/08 sem mudar de pergunta**, e é o que a reabertura
    // ensinou: por dois meses a pergunta foi *"qual gradiente sobrevive ao branco?"* quando ela era
    // *"qual tinta sobrevive ao gradiente da marca?"*. Medir uma tinta em duas opções escolhe a
    // opção; medir duas tintas em duas opções escolhe as duas coisas.
    double contraste(Color a, Color b) {
      final la = a.computeLuminance(), lb = b.computeLuminance();
      final (hi, lo) = la > lb ? (la, lb) : (lb, la);
      return (hi + 0.05) / (lo + 0.05);
    }
    double pior(Color tinta, LinearGradient g) =>
        g.colors.map((p) => contraste(tinta, p)).reduce((a, b) => a < b ? a : b);

    expect(CoreflowGradients.bold.onGradient, BoldVinho.ink);

    // 1 · No gradiente da marca, a tinta escolhida passa AA de TEXTO — o que o par anterior
    //     (branco sobre duas paradas, pior 3,37) não fazia.
    final piorNoPrimary = pior(CoreflowGradients.bold.onGradient, CoreflowGradients.bold.primary);
    expect(piorNoPrimary, greaterThanOrEqualTo(4.5),
        reason: 'a tinta sobre o gradiente da marca tem que ler como TEXTO, senão a regra de uso '
            'volta a ser "só glifo e título grande" — e foi isso que o lockup comprou');
    expect(piorNoPrimary, closeTo(5.69, 0.02));

    // 2 · E ela ganha do branco, que era a tinta anterior. Sem esta linha, trocar a tinta de volta
    //     pra branco passaria calado e deixaria 1,21 no amarelo.
    expect(piorNoPrimary, greaterThan(pior(BoldPalette.bold.white, CoreflowGradients.bold.primary)));
    expect(pior(BoldPalette.bold.white, CoreflowGradients.bold.primary), closeTo(1.21, 0.02),
        reason: 'o número que mata o branco, escrito aqui pra ninguém precisar remedir pra saber '
            'por que a tinta não é ela');

    // 3 · O `accent` é outro caso e continua com a regra antiga: as duas paradas dele são âmbar
    //     escuro, então a tinta da marca ali é fraca e o branco é que lê. Ele NÃO usa `onGradient`.
    expect(pior(BoldPalette.bold.white, CoreflowGradients.bold.accent), greaterThanOrEqualTo(3.0));
  });
}
