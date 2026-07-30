import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 360, child: child)),
    );

void main() {
  testWidgets('renderiza título/subtítulo e dispara onTap', (t) async {
    var taps = 0;
    await t.pumpWidget(_host(DilettaListTile(
      title: 'Minha conta',
      subtitle: 'Ver saldo',
      leading: const SizedBox(width: 24, height: 24),
      trailing: const SizedBox(width: 16, height: 16),
      onTap: () => taps++,
    )));
    expect(find.text('Minha conta'), findsOneWidget);
    expect(find.text('Ver saldo'), findsOneWidget);
    await t.tap(find.byType(DilettaListTile));
    expect(taps, 1);
  });

  testWidgets('sem subtítulo não renderiza a segunda linha', (t) async {
    await t.pumpWidget(_host(const DilettaListTile(title: 'Só título')));
    expect(find.byType(DilettaText), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('DilettaText.rich renderiza spans', (t) async {
    await t.pumpWidget(_host(const DilettaText.rich([
      TextSpan(text: 'Olá '),
      TextSpan(text: 'mundo', style: TextStyle(fontWeight: FontWeight.bold)),
    ])));
    expect(find.textContaining('mundo', findRichText: true), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
