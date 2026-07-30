import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O SELO QUÂNTICO — o componente exclusivo mais usado do produto (9 chamadas).
///
/// Ele é animado e desenhado em `CustomPainter`, então o que se mede aqui é o que dá pra medir
/// sem golden: os três estados renderizam nos dois modos, o ciclo de vida do controlador não
/// vaza, o gancho de conclusão dispara UMA vez, e nenhum dos nove literais de cor voltou.
void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Scaffold(body: Center(child: filho)),
        ),
      );

  testWidgets('os TRÊS estados renderizam, nos DOIS modos', (t) async {
    for (final escuro in [false, true]) {
      for (final estado in BoldSeloEstado.values) {
        await t.pumpWidget(montar(BoldSeloQuantico(estado: estado), escuro: escuro));
        await t.pump(const Duration(milliseconds: 300));
        expect(t.takeException(), isNull,
            reason: 'o estado "${estado.name}" estourou no modo '
                '${escuro ? "escuro" : "claro"}');
      }
    }
    // Deixa o loop parar antes do fim do teste: controlador em `repeat()` com pump pendente é
    // como um teste de animação vira "pending timer".
    await t.pumpWidget(montar(const SizedBox()));
  });

  testWidgets('o gancho de conclusão dispara UMA vez, e só ao terminar', (t) async {
    var vezes = 0;
    await t.pumpWidget(montar(BoldSeloQuantico(
      estado: BoldSeloEstado.autorizado,
      aoConcluir: () => vezes++,
    )));

    await t.pump(const Duration(milliseconds: 500));
    expect(vezes, 0, reason: 'disparou no meio da cena');

    await t.pump(const Duration(seconds: 3));
    expect(vezes, 1);

    // Mais tempo não dispara de novo — era o que o `_disparou` guardava, e é o tipo de coisa que
    // sem teste vira "a tela fechou duas vezes".
    await t.pump(const Duration(seconds: 3));
    expect(vezes, 1);
    await t.pumpWidget(montar(const SizedBox()));
  });

  testWidgets('resolver DEPOIS de proteger toca a conclusão e dispara', (t) async {
    // É o fluxo real: o selo entra em loop enquanto o backend confirma, e resolve quando a
    // resposta chega. O `didUpdateWidget` pula pro meio da cena pra não repetir a montagem.
    var vezes = 0;
    await t.pumpWidget(montar(BoldSeloQuantico(
      estado: BoldSeloEstado.protegendo,
      aoConcluir: () => vezes++,
    )));
    await t.pump(const Duration(milliseconds: 400));
    expect(vezes, 0);

    await t.pumpWidget(montar(BoldSeloQuantico(
      estado: BoldSeloEstado.negado,
      aoConcluir: () => vezes++,
    )));
    await t.pump(const Duration(seconds: 3));
    expect(vezes, 1);
    await t.pumpWidget(montar(const SizedBox()));
  });

  testWidgets('nenhum dos NOVE literais de cor voltou', (t) async {
    // A versão antiga tinha violeta, roxo, laranja claro, verde, vermelho, dois pares de tinta
    // escura e um par de rótulo — nove hexes. Dois eram exatamente a paleta (`#2FD27A` é
    // `success05`, `#FF4D5E` é `error05`) e sete não tinham casa.
    //
    // O que este teste pega são os sete sem casa. Os dois que coincidem com a paleta continuam
    // aparecendo, e devem: agora eles vêm de `success05` e `error05`.
    const semCasa = {
      'violeta': 0xFF7C3AED,
      'roxo': 0xFFA78BFA,
      'laranja claro': 0xFFFF9A52,
      'rótulo de sucesso': 0xFF5BD597,
      'rótulo de falha': 0xFFFF8A92,
      'tinta do chip (falha)': 0xFF2B1517,
      'tinta do chip (repouso)': 0xFF2A1D52,
    };

    for (final estado in BoldSeloEstado.values) {
      await t.pumpWidget(montar(BoldSeloQuantico(estado: estado), escuro: true));
      await t.pump(const Duration(milliseconds: 200));

      final cores = <int>{};
      for (final w in t.allWidgets) {
        for (final prop in w.toDiagnosticsNode().getProperties()) {
          if (prop.value case final Color c) cores.add(c.withValues(alpha: 1).toARGB32());
        }
      }
      final vazam =
          semCasa.entries.where((e) => cores.contains(e.value)).map((e) => e.key);
      expect(vazam, isEmpty, reason: 'literal de volta no estado "${estado.name}": $vazam');
    }
    await t.pumpWidget(montar(const SizedBox()));
  });

  test('o vocabulário é FECHADO: três estados, não quatro combinações', () {
    // A API antiga era `waiting` + `failed`: quatro combinações pra três estados, e a quarta
    // (`waiting: true, failed: true`) não tinha significado — o selo mostrava o loop e ignorava o
    // `failed`. Estado impossível que se disfarça de estado válido é exatamente o que a exigência
    // 7 do contrato de componente existe pra impedir.
    expect(BoldSeloEstado.values, hasLength(3));
  });
}
