import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CARTÃO SABE FICAR SEM BORDA — e este teste existe por causa de um defeito que eu escrevi.
///
/// Em 01/09 uma varredura converteu 49 `BoxDecoration` das telas do app em `CoreflowCartao`.
/// Metade — as `borderRadius + color` sem `border:` — não tinha borda nenhuma, e a conversão
/// omitia `borderColor`. O default preencheu. **Vinte e cinco telas ganharam um fio que ninguém
/// pediu, com 848 testes verdes**, porque nenhum teste olha pixel.
///
/// O `semBorda` conserta a API; este gate conserta a confiança. Ele mede os dois lados: com o
/// default a borda existe, com o eixo ela não existe.
Widget _naTela(Widget filho) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DilettaThemeScope(
        theme: CoreflowTheme.dark,
        child: Scaffold(body: Center(child: filho)),
      ),
    );

BoxBorder? _bordaDe(WidgetTester t) {
  final d = t
      .widgetList<Container>(find.descendant(
          of: find.byType(DilettaCardSurface), matching: find.byType(Container)))
      .map((c) => c.decoration)
      .whereType<BoxDecoration>()
      .toList();
  return d.isEmpty ? null : d.first.border;
}

void main() {
  testWidgets('por default o cartão TEM hairline', (t) async {
    await t.pumpWidget(_naTela(const CoreflowCartao(child: Text('a'))));
    expect(_bordaDe(t), isNotNull,
        reason: 'o cartão deste produto tem borda — tirá-la é uma decisão, não um esquecimento');
  });

  testWidgets('e com `semBorda` ela some', (t) async {
    await t.pumpWidget(_naTela(const CoreflowCartao(semBorda: true, child: Text('a'))));
    expect(_bordaDe(t), isNull,
        reason: 'uma caixa que era `BoxDecoration(color, borderRadius)` não pode ganhar fio');
  });
}
