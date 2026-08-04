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

  /// A DÍVIDA DO AVISO NO CLARO FOI PAGA, e o gate voltou a ser um só.
  ///
  /// Ele nasceu partido em dois: os pares que alcançavam 3:1 e uma asserção que cravava `2,08:1` no claro
  /// — `onWarning` era `palette.white` pra qualquer paleta, e o âmbar desta marca (`#F6A21A`) é claro. O
  /// pedido voltou **ENTRA nos dois lados** (`ds v0.46.0`): os cinco `onX` de status passaram a derivar a
  /// tinta com piso de objeto gráfico, e o gate dele passou a rodar com uma **segunda paleta**.
  ///
  /// A asserção de dívida falhou no dia em que ele consertou, que é a única razão de ela existir: o claro
  /// mediu **5,48:1** (tinta `#3D3939`), exatamente o número que o pedido previu. Aí ela morreu e os
  /// quatro pares voltaram pra um laço só.
  ///
  /// O que a segunda paleta dele achou não era meu — `outline · loading` reprovava em 2,81 e 2,57 na
  /// paleta de exemplo que já morava no repo dele e nunca tinha sido medida. **Uma paleta só não é gate
  /// multiproduto, é gate com uma amostra.**
  test('o par tinta/fundo do spot alcança 3:1 nos dois estados que eu uso', () {
    // `DilettaSpotIcon` nasce `fill`, que é como o resumo o usa: fundo semântico cheio.
    for (final (nome, escuro) in [('claro', false), ('escuro', true)]) {
      final s = (escuro ? BoldTheme.dark : BoldTheme.light).scheme;
      for (final (estado, tinta, fundo) in [
        ('success', s.onSuccess, s.success),
        ('warning', s.onWarning, s.warning),
      ]) {
        final razao = _razao(tinta, fundo);
        expect(razao, greaterThanOrEqualTo(3.0),
            reason: 'spot fill · $estado no $nome mede ${razao.toStringAsFixed(2)}:1 — '
                'piso de objeto gráfico é 3:1 (WCAG 1.4.11)');
      }
    }
  });

  /// E a tinta do aviso no claro não é mais branca — o papel DERIVA.
  ///
  /// Sem esta linha, o gate de 3:1 acima passaria de novo se um dia a derivação voltasse a ser declaração
  /// numa paleta cujo âmbar seja escuro: a razão passaria e a CAUSA teria voltado.
  test('e no claro ela sai do branco, porque o papel deriva', () {
    final s = BoldTheme.light.scheme;
    expect(s.onWarning, isNot(s.palette.white));
    expect(_razao(s.onWarning, s.warning), closeTo(5.48, 0.01));
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
