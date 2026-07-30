import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O TECLADO SEGUE O TEMA — reportado pelo usuário com print.
///
/// Bug: o fundo do numpad era `neutral08` cravado, e as teclas usavam
/// `s.surface`. No dark as teclas escureciam e a placa continuava cinza claro:
/// tecla escura sobre placa clara, "mal formado".
///
/// A regra do DS é a de sempre — componente consome role, nunca cor crua. Este
/// teste guarda o caso porque ele passou por todo mundo justamente por ser
/// PARCIAL: metade do componente já era temática.
void main() {
  Future<Color?> fundoDoNumpad(WidgetTester t, DilettaTheme tema) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: tema,
        child: Scaffold(
          body: DilettaKeyboard(onKey: (_) {}, onBackspace: () {}),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));
    for (final c in t.widgetList<Container>(find.byType(Container))) {
      if (c.color == tema.scheme.surfaceMuted) return c.color;
    }
    return null;
  }

  testWidgets('a placa do numpad vem do scheme (light e dark)', (t) async {
    expect(await fundoDoNumpad(t, DilettaTheme.referenciaLight),
        DilettaTheme.referenciaLight.scheme.surfaceMuted);
    expect(await fundoDoNumpad(t, DilettaTheme.referenciaDark),
        DilettaTheme.referenciaDark.scheme.surfaceMuted,
        reason: 'no dark a placa continuou clara — o bug do print voltou');
  });

  testWidgets('placa e tecla NÃO são a mesma cor (a tecla precisa aparecer)',
      (t) async {
    for (final tema in [DilettaTheme.referenciaLight, DilettaTheme.referenciaDark]) {
      expect(tema.scheme.surfaceMuted, isNot(tema.scheme.surface),
          reason: 'placa e tecla iguais fazem o teclado desaparecer');
    }
  });
}
