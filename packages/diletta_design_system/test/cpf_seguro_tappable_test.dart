import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    );

void main() {
  testWidgets('onTap dispara e usa hit area opaca', (t) async {
    var taps = 0;
    await t.pumpWidget(_host(DilettaTappable(
      onTap: () => taps++,
      child: const SizedBox(width: 80, height: 40),
    )));
    await t.tap(find.byType(DilettaTappable));
    expect(taps, 1);
    final gd = t.widget<GestureDetector>(find.byType(GestureDetector));
    expect(gd.behavior, HitTestBehavior.opaque);
  });

  testWidgets('desabilitado não dispara e não monta GestureDetector', (t) async {
    var taps = 0;
    await t.pumpWidget(_host(DilettaTappable(
      disabled: true,
      onTap: () => taps++,
      child: const SizedBox(width: 80, height: 40),
    )));
    await t.tap(find.byType(DilettaTappable), warnIfMissed: false);
    expect(taps, 0);
    expect(find.byType(GestureDetector), findsNothing);
  });

  testWidgets('modo builder expõe o estado pressed', (t) async {
    bool? seen;
    await t.pumpWidget(_host(DilettaTappable(
      onTap: () {},
      builder: (ctx, pressed) {
        seen = pressed;
        return const SizedBox(width: 80, height: 40);
      },
    )));
    expect(seen, isFalse);
    final g = await t.startGesture(t.getCenter(find.byType(DilettaTappable)));
    await t.pump();
    expect(seen, isTrue);
    await g.up();
    await t.pump();
    expect(seen, isFalse);
  });

  testWidgets('sem onTap: só renderiza o filho (sem gesto)', (t) async {
    await t.pumpWidget(_host(const DilettaTappable(
      child: SizedBox(width: 80, height: 40),
    )));
    expect(find.byType(GestureDetector), findsNothing);
    expect(t.takeException(), isNull);
  });
}
