import 'dart:math' as math;

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O SPOT DE INFORMAÇÃO PASSA O MESMO PISO QUE OS OUTROS SEIS — 3:1, medido nos dois modos.
///
/// Os seis tons do `CoreflowSpot` viram `DilettaSpotState` e herdam o gate de contraste do pai. O
/// `info` não: **o pai não tem o papel `info`** — as famílias semânticas dele são sucesso, aviso,
/// erro, cofre e parceiro, e o `info` é `papelExtra` deste produto, com 39 usos.
///
/// Pintar aqui significa não herdar o gate de lá. Então o gate vem junto: sem ele, o único tom que
/// este produto pinta sozinho seria também o único sem piso medido — que é exatamente como o disco
/// desenhado à mão na tela de autorizações vivia (`info` a 26 de alfa, escolhido sem medir).
void main() {
  double _lin(double c) =>
      c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  double _lum(Color c) =>
      0.2126 * _lin(c.r) + 0.7152 * _lin(c.g) + 0.0722 * _lin(c.b);
  double contraste(Color a, Color b) {
    final la = _lum(a), lb = _lum(b);
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// O piso de OBJETO GRÁFICO, que é o que um disco com glifo é. Mesmo número que o pai cobra.
  const piso = 3.0;

  for (final escuro in [true, false]) {
    testWidgets('o outline de info passa o piso no ${escuro ? 'escuro' : 'claro'}', (t) async {
      late CoreflowScheme c;
      await t.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          child: Scaffold(
            body: Builder(builder: (ctx) {
              c = CoreflowScheme.of(ctx);
              return const CoreflowSpot('circle-info-light', tone: CoreflowTomDoSpot.info);
            }),
          ),
        ),
      ));
      await t.pump();

      // A mesma conta que a peça faz — se ela mudar, este número muda junto e o gate avisa.
      final superficie = escuro ? c.surface : c.background;
      final tinte = Color.alphaBlend(
          c.info.withValues(alpha: escuro ? 0.18 : 0.12), superficie);
      final tinta = escuro
          ? c.info
          : Color.lerp(c.info, DilettaAbsoluteColors.black, 0.20)!;

      expect(contraste(tinta, tinte), greaterThanOrEqualTo(piso),
          reason: 'o glifo de info não alcança 3:1 sobre o tinte dele no '
              '${escuro ? 'escuro' : 'claro'}');
    });
  }

  testWidgets('e o gate SABE ver — um par ruim reprova', (t) async {
    // Controle: sem ele, um `contraste()` quebrado devolveria número alto e os dois de cima
    // passariam medindo nada. Cinza médio sobre cinza médio é o par que tem que falhar.
    expect(contraste(const Color(0xFF808080), const Color(0xFF8A8A8A)), lessThan(piso));
  });

  testWidgets('o disco de info monta e usa o glifo pedido', (t) async {
    await t.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DilettaThemeScope(
        theme: CoreflowTheme.dark,
        child: const Scaffold(
          body: CoreflowSpot('hourglass-start-light', tone: CoreflowTomDoSpot.info, size: 40),
        ),
      ),
    ));
    await t.pump();
    expect(t.getSize(find.byType(CoreflowSpot)), const Size(40, 40));
    expect(find.byType(CoreflowIcone), findsOneWidget);
  });
}
