import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A MOLDURA DE CAPTURA — a palavra que faltava, medida em cinco telas.
///
/// Cinco telas do primeiro filho desenhavam a mesma moldura à mão (documento 260×168, rosto 200
/// redondo, código 240 com cantos), com os mesmos papéis de cor e nenhum estado de erro coerente. No
/// board as cinco viravam BLOCO CRU, porque código à mão não é componente.
void main() {
  Widget emTela(Widget filho) => WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (_, __) => DilettaThemeScope(
          theme: DilettaTheme.resolve(
              palette: DilettaPalette.referencia, brightness: Brightness.light),
          child: Center(child: filho),
        ),
      );

  testWidgets('cada forma tem a MEDIDA e o ícone dela — o ícone não é parâmetro', (t) async {
    // Quem captura documento não escolhe o ícone: a moldura de documento tem cara de documento, e é
    // isso que faz a pessoa entender o que fazer antes de ler a instrução.
    for (final caso in [
      (DilettaCaptureForma.documento, const Size(260, 168)),
      (DilettaCaptureForma.rosto, const Size(200, 200)),
      (DilettaCaptureForma.codigo, const Size(240, 240)),
    ]) {
      await t.pumpWidget(emTela(DilettaCaptureFrame(forma: caso.$1)));
      await t.pump();
      expect(t.getSize(find.byType(DilettaCaptureFrame)), caso.$2);
      expect(find.byType(DilettaIcon), findsWidgets);
    }
  });

  testWidgets('o CÓDIGO usa cantos de mira, e não borda contínua', (t) async {
    // Borda inteira competiria com os cantos e a moldura ficaria pesada.
    await t.pumpWidget(emTela(
        const DilettaCaptureFrame(forma: DilettaCaptureForma.codigo)));
    await t.pump();
    final caixa = t.widget<DecoratedBox>(find.descendant(
      of: find.byType(DilettaCaptureFrame),
      matching: find.byType(DecoratedBox),
    ).first);
    expect((caixa.decoration as BoxDecoration).border, isNull);
    // Quatro cantos.
    expect(
        find.descendant(
            of: find.byType(DilettaCaptureFrame), matching: find.byType(Container)),
        findsNWidgets(4));
  });

  testWidgets('o ERRO troca o papel de cor e põe o selo NO CANTO', (t) async {
    // Na tela de documento ilegível, o alerta empilhado no meio deixava a moldura ilegível também.
    await t.pumpWidget(emTela(const DilettaCaptureFrame(
        forma: DilettaCaptureForma.documento,
        estado: DilettaCaptureEstado.erro)));
    await t.pump();
    final icones = t.widgetList<DilettaIcon>(find.byType(DilettaIcon)).toList();
    expect(icones.length, 2, reason: 'o do enquadramento e o selo de estado');
    final s = DilettaTheme.resolve(palette: DilettaPalette.referencia).scheme;
    expect(icones.every((i) => i.color == s.error), isTrue,
        reason: 'a cor é papel, e o papel muda com o estado');
  });

  testWidgets('aguardando é a cor de AÇÃO, porque é um convite', (t) async {
    await t.pumpWidget(emTela(const DilettaCaptureFrame()));
    await t.pump();
    final s = DilettaTheme.resolve(palette: DilettaPalette.referencia).scheme;
    expect(t.widget<DilettaIcon>(find.byType(DilettaIcon)).color, s.primary);
  });
}
