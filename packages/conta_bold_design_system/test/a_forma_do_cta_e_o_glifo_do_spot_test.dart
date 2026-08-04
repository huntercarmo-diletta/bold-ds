import 'dart:math' as math;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O QUE A SUBIDA PRO PAI `v0.44.1` MUDA NESTA CASA, medido nos dois lugares em que muda.
///
/// Os dois vereditos de 2026-08-04 chegaram juntos e são de naturezas opostas: um é receita que
/// eu passei a **declarar** (a forma do CTA), o outro é conserto que eu passei a **receber** (a
/// tinta do glifo do spot). Nenhum dos dois tinha gate aqui — o do pai mede a peça dele com a
/// paleta dele, e o que este arquivo mede é a peça dele **com a minha**.
void main() {
  Widget naTela(Widget filho, {bool escuro = false}) => Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Align(alignment: Alignment.topLeft, child: filho),
        ),
      );

  // A FORMA DO CTA — 16, e a pílula do pai é o que ela substitui.

  test('a declaração mora na paleta, e o scheme DERIVA os dois modos', () {
    expect(BoldPalette.bold.raioDeBotao, 16);
    for (final tema in [BoldTheme.light, BoldTheme.dark]) {
      expect(tema.scheme.formaDoBotao, BorderRadius.all(Radius.circular(16)));
    }
  });

  testWidgets('e o CTA RENDERIZA 16 — nenhuma camada dele ficou pill', (t) async {
    for (final escuro in [false, true]) {
      await t.pumpWidget(naTela(
        DilettaButton(label: 'Pagar', onPressed: () {}),
        escuro: escuro,
      ));
      await t.pump(const Duration(milliseconds: 50));

      final raios = t
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((d) => d.decoration)
          .whereType<BoxDecoration>()
          .map((d) => d.borderRadius)
          .whereType<BorderRadius>()
          .toList();

      expect(raios, isNotEmpty, reason: 'o botão precisa pintar pelo menos uma caixa');
      expect(raios, everyElement(BorderRadius.all(Radius.circular(16))));
      // A pílula do `lg` (h56) seria 28 — o número que 55 telas deste produto não aceitam.
      expect(raios, isNot(contains(DilettaRadius.pillAll)));
    }
  });

  // O GLIFO DO SPOT — os dois estados que o resumo da transação renderiza, com a MINHA rampa.

  test('o par tinta/fundo do spot alcança 3:1 — nos três que já alcançam', () {
    // `DilettaSpotIcon` nasce `fill`, que é como o resumo o usa: fundo semântico cheio.
    for (final (nome, escuro) in [('claro', false), ('escuro', true)]) {
      final s = (escuro ? BoldTheme.dark : BoldTheme.light).scheme;
      for (final (estado, tinta, fundo) in [
        ('success', s.onSuccess, s.success),
        if (escuro) ('warning', s.onWarning, s.warning),
      ]) {
        final razao = _razao(tinta, fundo);
        expect(razao, greaterThanOrEqualTo(3.0),
            reason: 'spot fill · $estado no $nome mede ${razao.toStringAsFixed(2)}:1 — '
                'piso de objeto gráfico é 3:1 (WCAG 1.4.11)');
      }
    }
  });

  /// A DÍVIDA DO AVISO NO CLARO — declarada com o número, e não com um comentário.
  ///
  /// `onWarning` é `palette.white` no claro pra QUALQUER paleta (`DilettaScheme.light`, linha 316), e o
  /// âmbar desta marca é claro: 2,08:1, abaixo do piso de 3:1. **Não é regressão da `ds v0.44.1`** — o
  /// glifo era branco cravado antes e é branco por papel agora; o que a subida mudou foi o escuro, que
  /// passou de reprovado a 6,03:1.
  ///
  /// Pedido aberto: `docs/pedidos/2026-08-04-a-tinta-do-aviso-e-branca-no-claro-e-o-ambar-e-do-filho.md`.
  /// O gate do pai não podia ver: ele mede 28 pares com `DilettaPalette.referencia`, cujo âmbar
  /// (`#B0810A`) segura branco em 3,51:1 — o defeito só aparece com a paleta do filho.
  ///
  /// **Esta asserção FALHA no dia em que o pai consertar**, e é pra isso que ela existe: aí o piso sobe
  /// pra 3:1 junto com o resto da família, na mesma subida de `ref:`. Dívida que não avisa quando é paga
  /// é comentário.
  test('e o do CLARO ainda não — 2,08:1, dívida do pai com pedido aberto', () {
    final s = BoldTheme.light.scheme;
    expect(_razao(s.onWarning, s.warning), closeTo(2.08, 0.01));
    expect(s.onWarning, s.palette.white,
        reason: 'a tinta é branca porque o papel é declarado, não derivado');
  });
}

/// Razão de contraste WCAG 2.x. Cor opaca dos dois lados: `fill` não é translúcido.
double _razao(Color a, Color b) {
  final la = _luminancia(a), lb = _luminancia(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

double _luminancia(Color c) {
  double canal(double v) => v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
}
