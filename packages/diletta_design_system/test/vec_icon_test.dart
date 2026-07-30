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

  /// OS ÍCONES QUE NASCERAM AQUI, e não vieram do export original do Figma.
  ///
  /// Os quatro chegaram por PEDIDO de filho — dois de cada um, e nenhum era vocabulário de produto:
  /// `</>` (inspeção de código, que toda ferramenta da família tem) e o sparkle de assistente de IA.
  /// O teste é o mínimo honesto: o `.vec` compilado do SVG deste repo carrega, desenha, e o token
  /// aponta pro arquivo certo.
  ///
  /// O do sparkle tem uma razão extra pra existir: o SVG veio com um `<clipPath>` que contém um rect
  /// `fill="white"` (resto de export do Figma). Clip não é pintura, então ele não vira geometria
  /// branca — mas "não vira" é afirmação, e afirmação sem medida é o que faz ícone chegar torto.
  for (final nome in [
    DilettaIcons.codeLight,
    DilettaIcons.codeSolid,
    DilettaIcons.sparklesLightFull,
    DilettaIcons.sparklesSolidFull,
  ]) {
    testWidgets('$nome carrega do .vec compilado neste repo', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: DilettaIcon(name: nome, size: 24, color: const Color(0xFF123456)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(VectorGraphic), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(DilettaIcons.all.containsValue(nome), isTrue,
          reason: 'token fora do mapa: o plugue do catálogo resolve ícone por ele');
    });
  }
}
