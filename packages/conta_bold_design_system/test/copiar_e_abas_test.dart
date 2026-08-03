import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Scaffold(body: filho),
        ),
      );

  group('copiar', () {
    // Por CHAVE, e não por tipo: o selo de status monta o próprio `AnimatedOpacity` por dentro, e
    // o finder por tipo pegava o de dentro — que é 1.0 sempre. O teste "passava" medindo a peça
    // errada até eu tracejar a opacidade no tempo e ver 1.0 antes do toque.
    Finder meuAviso() => find.byKey(const ValueKey('avisoDeCopiado'));
    Finder meuToque() => find
        .descendant(of: find.byType(BoldCopiar), matching: find.byType(DilettaTappable))
        .first;

    setUp(() {
      // O canal de clipboard não existe no ambiente de teste: sem esse espião, `Clipboard.setData`
      // lança e o toque nunca chega ao `setState`.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
    });

    testWidgets('copia pro clipboard e mostra o aviso, que SOME depois', (t) async {
      var copiou = 0;
      await t.pumpWidget(montar(BoldCopiar(
        texto: 'chave-pix-123',
        rotuloDeAcessibilidade: 'Copiar chave',
        aoCopiar: () => copiou++,
      )));

      expect(find.text('Copiado'), findsOneWidget,
          reason: 'o aviso existe na árvore com opacidade 0 — é o que faz a animação ter de onde '
              'sair, então o teste mede a OPACIDADE, não a presença');
      expect(t.widget<AnimatedOpacity>(meuAviso()).opacity, 0);

      await t.tap(meuToque());
      await t.pump();
      expect(copiou, 1);
      expect(t.widget<AnimatedOpacity>(meuAviso()).opacity, 1);

      // Dois pumps: o primeiro avança o relógio e faz o timer disparar o `setState`; o segundo
      // constrói o frame que já reflete o estado novo. Num pump só, o `expect` lê a árvore
      // anterior ao rebuild.
      await t.pump(const Duration(milliseconds: 1900));
      await t.pump();
      expect(t.widget<AnimatedOpacity>(meuAviso()).opacity, 0);
    });

    testWidgets('o toque VIBRA, e é a única chamada tátil do produto', (t) async {
      // A adaptação tinha deixado o haptic cair em silêncio — nada na tela muda quando ele falta,
      // então só o dedo percebe. Este teste é o dedo.
      final chamadas = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (c) async {
        chamadas.add(c.method);
        return null;
      });
      addTearDown(() => TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null));

      await t.pumpWidget(montar(const BoldCopiar(
        texto: 'chave-pix-123',
        rotuloDeAcessibilidade: 'Copiar chave',
      )));
      await t.tap(meuToque());
      await t.pump();

      expect(chamadas, contains('HapticFeedback.vibrate'));
    });

    testWidgets('dois toques rápidos NÃO cortam o segundo aviso', (t) async {
      // O bug da versão antiga: cada toque criava um `Timer` sem cancelar o anterior, então o
      // primeiro apagava o aviso do segundo ~1.8s antes da hora.
      await t.pumpWidget(montar(const BoldCopiar(
        texto: 'x',
        rotuloDeAcessibilidade: 'Copiar',
      )));

      await t.tap(meuToque());
      await t.pump(const Duration(milliseconds: 1500));
      await t.tap(meuToque());
      await t.pump();

      // 500ms depois do segundo toque: o timer do PRIMEIRO já venceu. Sem o cancelamento, o aviso
      // estaria apagado aqui.
      await t.pump(const Duration(milliseconds: 500));
      expect(t.widget<AnimatedOpacity>(meuAviso()).opacity, 1,
          reason: 'o timer do primeiro toque apagou o aviso do segundo');
    });

    testWidgets('tem rótulo de acessibilidade, porque ícone sem rótulo é botão mudo', (t) async {
      await t.pumpWidget(montar(const BoldCopiar(
        texto: 'x',
        rotuloDeAcessibilidade: 'Copiar chave Pix',
      )));
      expect(find.bySemanticsLabel('Copiar chave Pix'), findsOneWidget);
    });
  });

  group('abas', () {
    testWidgets('marca a ativa por COR e por espessura, nos dois modos', (t) async {
      // Espessura junto com cor porque seleção só por matiz não é seleção pra quem não distingue
      // matiz.
      for (final escuro in [false, true]) {
        await t.pumpWidget(montar(
          BoldAbas(abas: const ['Tudo', 'Entradas', 'Saídas'],
              indiceSelecionado: 1, aoTrocar: (_) {}),
          escuro: escuro,
        ));
        await t.pump(const Duration(milliseconds: 50));

        final bordas = t
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .map((c) => (c.decoration! as BoxDecoration).border!.bottom)
            .toList();
        expect(bordas[1].width, greaterThan(bordas[0].width));
        expect(bordas[1].color, isNot(bordas[0].color));
      }
    });

    testWidgets('o toque pega a ABA inteira, não só o texto', (t) async {
      // Exigência 10: área de toque é a de toque. Antes o padding ficava fora do tappable, então
      // a faixa acima e abaixo do rótulo não respondia.
      var trocou = -1;
      await t.pumpWidget(montar(BoldAbas(
        abas: const ['A', 'B'],
        indiceSelecionado: 0,
        aoTrocar: (i) => trocou = i,
      )));

      final aba = t.getRect(find.byType(DilettaTappable).last);
      // Toca a 2px do topo da aba — fora do texto, dentro da aba.
      await t.tapAt(Offset(aba.center.dx, aba.top + 2));
      expect(trocou, 1);
    });

    testWidgets('rótulo longo encurta em vez de estourar', (t) async {
      await t.pumpWidget(montar(SizedBox(
        width: 200,
        child: BoldAbas(
          abas: const ['Um rótulo bem longo que não cabe', 'B'],
          indiceSelecionado: 0,
          aoTrocar: (_) {},
        ),
      )));
      await t.pump(const Duration(milliseconds: 50));
      expect(t.takeException(), isNull);
    });
  });
}
