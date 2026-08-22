import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// OS DOIS SELETORES — segmentos (troca um parâmetro) e pontos de página (diz onde você está).
void main() {
  /// O harness espelha o app hospedeiro, e a FONTE é parte disso.
  ///
  /// Sem `ThemeData(fontFamily:)` o texto sai na fonte quadrada do `flutter_test`, que é 76% mais larga que
  /// o Inter — e foi assim que eu reportei ao pai um estouro de 22px que na fonte real é outro número.
  Widget naTela(Widget filho, {bool escuro = false}) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: BoldFonts.familyRaw),
        home: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          // `Scaffold` não é enfeite: a família da fonte chega no texto pelo `DefaultTextStyle`, e quem o
          // fornece é o Material. Sem ele o `ThemeData(fontFamily:)` não alcança nada, e o teste mede na
          // fonte quadrada com o tema declarado do lado — verde, e medindo outra coisa.
          child: Scaffold(
            backgroundColor: const Color(0x00000000),
            body: Align(alignment: Alignment.topLeft, child: filho),
          ),
        ),
      );

  group('segmentos', () {
    testWidgets('mostra as opções e troca no toque', (t) async {
      var escolhido = -1;
      await t.pumpWidget(naTela(CoreflowSegmentos(
        segmentos: const ['Claro', 'Escuro', 'Sistema'],
        indiceSelecionado: 0,
        aoTrocar: (i) => escolhido = i,
      )));
      await t.pump(const Duration(milliseconds: 200));

      expect(find.text('Claro'), findsOneWidget);
      expect(find.text('Sistema'), findsOneWidget);
      await t.tap(find.text('Escuro'));
      expect(escolhido, 1);
    });

    testWidgets('só o SELECIONADO tem pastilha, e ela é do tema', (t) async {
      // Era `Colors.white` cravado: no escuro, uma pastilha de branco puro dentro de um trilho escuro.
      for (final escuro in [false, true]) {
        await t.pumpWidget(naTela(
          CoreflowSegmentos(
            segmentos: const ['A', 'B', 'C'],
            indiceSelecionado: 1,
            aoTrocar: (_) {},
          ),
          escuro: escuro,
        ));
        await t.pump(const Duration(milliseconds: 200));

        final s = escuro
            ? DilettaScheme.dark(BoldPalette.bold)
            : DilettaScheme.light(BoldPalette.bold);
        final pastilhas = t
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .map((c) => (c.decoration as BoxDecoration?)?.color?.toARGB32())
            .toList();
        expect(pastilhas.where((c) => c != null), hasLength(1),
            reason: 'mais de uma pastilha pintada: a seleção deixou de ser única');
        expect(pastilhas[1], s.surface.toARGB32());
        if (escuro) {
          expect(pastilhas, isNot(contains(0xFFFFFFFF)),
              reason: 'branco puro voltou pra pastilha no escuro');
        }
      }
    });

    testWidgets('o texto ativo NÃO é tinta literal — segue o tema', (t) async {
      // Era `Color(0xFF1A1726)`: no escuro, preto sobre escuro.
      await t.pumpWidget(naTela(
        CoreflowSegmentos(
          segmentos: const ['A', 'B'],
          indiceSelecionado: 0,
          aoTrocar: (_) {},
        ),
        escuro: true,
      ));
      await t.pump(const Duration(milliseconds: 200));

      final s = DilettaScheme.dark(BoldPalette.bold);
      final cores = t
          .widgetList<DilettaText>(find.byType(DilettaText))
          .map((w) => w.style?.color?.toARGB32())
          .toSet();
      expect(cores, contains(s.fg.toARGB32()));
      expect(cores, isNot(contains(0xFF1A1726)),
          reason: 'a tinta cravada voltou');
    });

    testWidgets('cada segmento anuncia se está SELECIONADO', (t) async {
      // A única informação que o componente carrega. Sem isto, três botões idênticos.
      await t.pumpWidget(naTela(CoreflowSegmentos(
        segmentos: const ['15 dias', '30 dias'],
        indiceSelecionado: 1,
        aoTrocar: (_) {},
      )));
      await t.pump(const Duration(milliseconds: 200));

      final selecionados = t
          .widgetList<Semantics>(find.byType(Semantics))
          .where((w) => w.properties.selected == true)
          .map((w) => w.properties.label)
          .toList();
      expect(selecionados, ['30 dias']);
    });

    // A LARGURA — e o gate agora mede o caso que EXISTE.
    //
    // A primeira versão media os rótulos do app (`Claro, Escuro, Sistema`) a 312 e 358 e reprovava sem o
    // `FittedBox`. Com a fonte do produto carregada, **ela passa nas duas larguras** — o estouro de 22px
    // que eu reportei ao pai era da fonte quadrada do `flutter_test`, 76% mais larga que o Inter.
    //
    // O caso que existe é conjunto de rótulo mais LONGO: `Aprovados · Rejeitados · Em análise` vaza 65px a
    // 280 e 33px a 312. É esse que o gate mede, porque é esse que o componente tem que aguentar — e ele é
    // um filtro plausível numa tela de autorizações deste produto.
    //
    // Mede as duas coisas juntas, porque uma sem a outra passa com o defeito de pé: **não vazar** e **não
    // perder palavra**. Só "não vazar" passaria com `ellipsis`, que corta `Rejeitados` em `Rejeita…`.
    const rotulosLongos = ['Aprovados', 'Rejeitados', 'Em análise'];
    for (final largura in [280.0, 312.0]) {
      testWidgets('rótulo longo cabe em $largura sem vazar e sem perder palavra', (t) async {
        final erros = <String>[];
        final anterior = FlutterError.onError;
        FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);

        await t.pumpWidget(naTela(SizedBox(
          width: largura,
          child: CoreflowSegmentos(
            segmentos: rotulosLongos,
            indiceSelecionado: 0,
            aoTrocar: (_) {},
          ),
        )));
        await t.pump(const Duration(milliseconds: 200));

        FlutterError.onError = anterior;
        t.takeException();
        expect(erros, isEmpty, reason: erros.join(' | '));

        // Palavra inteira: o `RenderParagraph` não elidiu nenhum dos três.
        for (final rotulo in rotulosLongos) {
          final p = t.renderObject<RenderParagraph>(find.text(rotulo));
          expect(p.didExceedMaxLines, isFalse, reason: '"$rotulo" está cortado em $largura');
        }
      });
    }

    testWidgets('e o gate SABE ver estouro — controle que vaza de propósito', (t) async {
      // Sem este controle, o teste acima é "nenhum erro aconteceu", que é o que ele diria também se
      // ninguém estivesse escutando. Esta Row vaza 60px, o mesmo número do defeito real.
      final erros = <String>[];
      final anterior = FlutterError.onError;
      FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);

      await t.pumpWidget(naTela(SizedBox(
        width: 312,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.filled(3, const SizedBox(width: 124, height: 36)),
        ),
      )));
      await t.pump();

      FlutterError.onError = anterior;
      t.takeException();
      expect(erros.join(), contains('overflowed by 60 pixels'));
    });

    testWidgets('lista vazia não desenha trilho vazio', (t) async {
      await t.pumpWidget(naTela(
          CoreflowSegmentos(segmentos: const [], indiceSelecionado: 0, aoTrocar: (_) {})));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.byType(DilettaBox), findsNothing);
    });
  });

  group('pontos de página', () {
    testWidgets('o ativo ALONGA, e não só muda de cor', (t) async {
      // Redundância deliberada: indicador que muda só de matiz não é lido por quem não distingue
      // matiz. Mesma decisão do sublinhado das abas.
      await t.pumpWidget(naTela(
          const CoreflowPontosDePagina(total: 4, indiceAtivo: 2, tamanho: 8)));
      await t.pump(const Duration(milliseconds: 300));

      final larguras = t
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .map((c) => c.constraints?.maxWidth)
          .toList();
      expect(larguras, hasLength(4));
      // Os quatro números, e não "o ativo é maior": `greaterThan` aqui passava com 8,1 e passava com
      // 22, então o FATOR do alongamento (2,75×, que é a decisão) não estava medido por ninguém — a
      // asserção concordava com qualquer alongamento, inclusive um invisível.
      expect(larguras, [8.0, 8.0, 8 * 2.75, 8.0],
          reason: 'o ativo alonga 2,75× e os inativos ficam no tamanho: 8 · 8 · 22 · 8');
    });

    testWidgets('as cores saem de PAPEL, nos dois modos', (t) async {
      // Era `primary04` cravado no ativo e conta de alpha por modo no inativo
      // (`white@30%` / `neutral07`).
      for (final escuro in [false, true]) {
        await t.pumpWidget(naTela(
            const CoreflowPontosDePagina(total: 3, indiceAtivo: 0), escuro: escuro));
        await t.pump(const Duration(milliseconds: 300));

        final s = escuro
            ? DilettaScheme.dark(BoldPalette.bold)
            : DilettaScheme.light(BoldPalette.bold);
        final cores = t
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .map((c) => (c.decoration as BoxDecoration).color?.toARGB32())
            .toSet();
        expect(cores, {s.primary.toARGB32(), s.borderSubtle.toARGB32()});
      }
    });

    testWidgets('uma página só NÃO desenha indicador', (t) async {
      // Um ponto sozinho não indica nada — é adorno que ocupa espaço vertical.
      await t.pumpWidget(naTela(const CoreflowPontosDePagina(total: 1, indiceAtivo: 0)));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.byType(AnimatedContainer), findsNothing);
    });

    testWidgets('o leitor de tela ouve "Página 3 de 4", não quatro caixas', (t) async {
      await t.pumpWidget(naTela(const CoreflowPontosDePagina(total: 4, indiceAtivo: 2)));
      await t.pump(const Duration(milliseconds: 50));
      expect(
        find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == 'Página 3 de 4'),
        findsOneWidget,
      );
    });
  });
}
