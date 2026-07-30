import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    );

void main() {
  testWidgets('aplica cor, raio e borda por token na decoration', (t) async {
    await t.pumpWidget(_host(DilettaBox(
      color: DilettaPalette.referencia.neutral10,
      radius: DilettaRadius.all16,
      borderColor: DilettaPalette.referencia.neutral08,
      child: const SizedBox(width: 40, height: 40),
    )));
    final box = t.widget<Container>(find.byType(Container));
    final dec = box.decoration! as BoxDecoration;
    expect(dec.color, DilettaPalette.referencia.neutral10);
    expect(dec.borderRadius, DilettaRadius.all16);
    expect(dec.border, isNotNull);
    expect(t.takeException(), isNull);
  });

  testWidgets('gradient tem prioridade sobre color (color vira null)', (t) async {
    const g = LinearGradient(colors: [Color(0xFF000000), Color(0xFFFFFFFF)]);
    await t.pumpWidget(_host(const DilettaBox(
      color: Color(0xFFFF0000),
      gradient: g,
      child: SizedBox(width: 40, height: 40),
    )));
    final dec =
        t.widget<Container>(find.byType(Container)).decoration! as BoxDecoration;
    expect(dec.gradient, g);
    expect(dec.color, isNull);
  });
}
