import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:diletta_design_system/diletta_design_system.dart';

void main() {
  testWidgets('DilettaIcon renderiza via .vec precompilado sem excecao',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaIcon(
          name: DilettaIcons.bellLight,
          size: 24,
          color: Color(0xFF003BE0),
        ),
      ),
    );
    // Deixa o AssetBytesLoader resolver o binario.
    await tester.pumpAndSettle();

    expect(find.byType(VectorGraphic), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('multicolor (pix-mark) tambem carrega via .vec', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaIcon(name: DilettaIcons.pixMark, size: 32),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VectorGraphic), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('arrow-right (derivado do arrow-left por rotacao 180) carrega',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [
          DilettaIcon(name: DilettaIcons.arrowRightLight, size: 24),
          DilettaIcon(name: DilettaIcons.arrowRightSolid, size: 24),
        ]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VectorGraphic), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
