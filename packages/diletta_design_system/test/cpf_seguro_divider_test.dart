import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contrato do DilettaDivider: hairline por token (schemeOf cai no cpfLight
/// sem scope), sem cor crua.
Widget _host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    );

void main() {
  testWidgets('horizontal: espessura na altura, preenche largura', (t) async {
    await t.pumpWidget(_host(const SizedBox(
      width: 200,
      child: DilettaDivider(thickness: 2),
    )));
    final box = t.widget<SizedBox>(
        find.descendant(of: find.byType(DilettaDivider), matching: find.byType(SizedBox)));
    expect(box.height, 2);
    expect(find.byType(ColoredBox), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('vertical: espessura na largura', (t) async {
    await t.pumpWidget(_host(const SizedBox(
      height: 100,
      child: DilettaDivider.vertical(thickness: 3),
    )));
    final box = t.widget<SizedBox>(
        find.descendant(of: find.byType(DilettaDivider), matching: find.byType(SizedBox)));
    expect(box.width, 3);
    expect(t.takeException(), isNull);
  });
}
