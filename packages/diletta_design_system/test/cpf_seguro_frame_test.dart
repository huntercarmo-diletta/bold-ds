import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contrato de PRODUÇÃO do DilettaFrame — o primitivo de layout em que a
/// árvore de composição e o código gerado repousam. Precisa ser estável e
/// seguro pra adoção no app real (cpf-seguro-real), então este teste trava o
/// comportamento estrutural de cada modo.
Widget _host(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

void main() {
  group('DilettaFrame — flex', () {
    testWidgets('column: eixo vertical, gap e crossAxisAlignment stretch',
        (tester) async {
      await tester.pumpWidget(_host(const DilettaFrame.column(
        gap: 12,
        children: [SizedBox(key: Key('a')), SizedBox(key: Key('b'))],
      )));

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);
      expect(flex.spacing, 12);
      expect(flex.crossAxisAlignment, CrossAxisAlignment.stretch);
      expect(find.byKey(const Key('a')), findsOneWidget);
      expect(find.byKey(const Key('b')), findsOneWidget);
    });

    testWidgets('row: eixo horizontal, crossAxisAlignment center default',
        (tester) async {
      await tester.pumpWidget(_host(const DilettaFrame.row(
        children: [SizedBox(key: Key('a'))],
      )));

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal);
      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('scrollable: envolve em SingleChildScrollView no eixo, e o '
        'flex vira min/start (sem estourar)', (tester) async {
      await tester.pumpWidget(_host(const DilettaFrame.row(
        scrollable: true,
        children: [SizedBox(width: 4000, height: 40)],
      )));

      final sv = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView));
      expect(sv.scrollDirection, Axis.horizontal);
      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.mainAxisSize, MainAxisSize.min);
      expect(flex.crossAxisAlignment, CrossAxisAlignment.start);
      expect(tester.takeException(), isNull); // não estoura constraints
    });

    testWidgets('padding aplica um Padding em volta', (tester) async {
      await tester.pumpWidget(_host(const DilettaFrame.column(
        padding: EdgeInsets.all(16),
        children: [SizedBox(key: Key('a'))],
      )));
      expect(find.byType(Padding), findsWidgets);
    });
  });

  group('DilettaFrame — stack + pin', () {
    testWidgets('pin numa borda vira Positioned com o offset', (tester) async {
      await tester.pumpWidget(_host(const DilettaFrame.stack(children: [
        SizedBox(key: Key('content')),
        DilettaPinned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(key: Key('bar')),
        ),
      ])));

      expect(find.byType(Stack), findsOneWidget);
      final pos = tester.widget<Positioned>(find.byType(Positioned));
      expect(pos.top, 0);
      expect(pos.left, 0);
      expect(pos.right, 0);
      expect(pos.bottom, isNull);
      expect(find.byKey(const Key('content')), findsOneWidget);
      expect(find.byKey(const Key('bar')), findsOneWidget);
    });

    testWidgets('respectSafeArea envolve o filho pinado num SafeArea',
        (tester) async {
      await tester.pumpWidget(_host(const MediaQuery(
        data: MediaQueryData(padding: EdgeInsets.only(top: 44)),
        child: DilettaFrame.stack(children: [
          SizedBox(key: Key('content')),
          DilettaPinned(
            top: 0,
            left: 0,
            right: 0,
            respectSafeArea: true,
            child: SizedBox(key: Key('bar')),
          ),
        ]),
      )));

      expect(find.byType(SafeArea), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('content é o primeiro filho do Stack (fica embaixo)',
        (tester) async {
      await tester.pumpWidget(_host(const DilettaFrame.stack(children: [
        SizedBox(key: Key('content')),
        DilettaPinned(top: 0, child: SizedBox(key: Key('bar'))),
      ])));

      final stack = tester.widget<Stack>(find.byType(Stack));
      expect(stack.children.length, 2);
      // O primeiro da lista é desenhado por baixo (content), o pinado por cima.
      expect((stack.children.first as SizedBox).key, const Key('content'));
    });
  });
}
