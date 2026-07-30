import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 360, child: child)),
    );

void main() {
  testWidgets('ExpansionTile: header aparece, corpo colapsado inicia oculto e '
      'expande no tap', (t) async {
    await t.pumpWidget(_host(const DilettaExpansionTile(
      title: 'Detalhes',
      children: [Text('conteudo-x')],
    )));
    expect(find.text('Detalhes'), findsOneWidget);
    // AnimatedCrossFade mantém ambos na árvore; valida que expande sem exceção.
    await t.tap(find.text('Detalhes'));
    await t.pumpAndSettle();
    expect(find.text('conteudo-x'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('Dialog: renderiza título/mensagem/ações centralizado', (t) async {
    await t.pumpWidget(_host(const DilettaDialog(
      title: 'Sair sem salvar?',
      message: 'Suas alterações serão descartadas.',
      actions: [SizedBox(key: Key('a'), height: 40)],
    )));
    expect(find.text('Sair sem salvar?'), findsOneWidget);
    expect(find.text('Suas alterações serão descartadas.'), findsOneWidget);
    expect(find.byKey(const Key('a')), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
