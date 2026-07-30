import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O BACKDROP — primeiro componente que nasce neste filho.
///
/// Ele é o componente mais usado do produto (114 chamadas, contra 9 do segundo), e é o que faz o
/// vidro do Bold parecer vidro: sem nada atrás, `BackdropFilter` desfoca o vazio.
///
/// Nasce aqui, e não sobe pro pai, por dois motivos do próprio contrato: fundo com arte e sete
/// moods de personalização é arranjo de UM produto, e um filho pedindo é gosto local até prova em
/// contrário. Se um segundo filho medir a mesma necessidade, sobe sem rediscussão.
///
/// Os testes abaixo cobrem as exigências do contrato de componente que dão pra medir sem golden:
/// os dois modos renderizam (4), cor sai de papel ou da instância (1), o vocabulário é fechado e
/// o `switch` exaustivo (7), e a degradação é visível em vez de quebrada.
void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Scaffold(body: filho),
        ),
      );

  testWidgets('os SETE fundos renderizam, nos DOIS modos', (t) async {
    // 14 combinações. O `switch` do componente é exaustivo sem `_ =>`, então um valor novo no
    // enum nem compila — mas render é outra coisa: o `gradeTech` pinta num `CustomPainter`, e o
    // `imagem` sem arte cai noutro caminho.
    for (final escuro in [false, true]) {
      for (final fundo in BoldBackdrop.values) {
        await t.pumpWidget(montar(
          BoldBackground(estilo: fundo, child: const Text('conteúdo')),
          escuro: escuro,
        ));
        await t.pump(const Duration(milliseconds: 50));
        expect(t.takeException(), isNull,
            reason: 'o fundo "${fundo.name}" estourou no modo '
                '${escuro ? "escuro" : "claro"}');
        expect(find.text('conteúdo'), findsOneWidget,
            reason: 'o fundo "${fundo.name}" engoliu o conteúdo da tela');
      }
    }
  });

  testWidgets('sem arte declarada, o fundo de imagem DEGRADA — não quebra', (t) async {
    // A versão antiga cravava o caminho do asset do app dentro do widget, então fora do app ela
    // mostrava um retângulo vazio. É o mesmo desenho do pai pra marca ausente: o que precisaria
    // de arquivo simplesmente não desenha, e o resto funciona.
    await t.pumpWidget(montar(
      const BoldBackground(estilo: BoldBackdrop.imagem, child: Text('conteúdo')),
    ));
    await t.pump(const Duration(milliseconds: 50));

    expect(t.takeException(), isNull);
    expect(find.byType(Image), findsNothing,
        reason: 'sem arte no scope não deve existir Image na árvore');
    expect(find.text('conteúdo'), findsOneWidget);
  });

  testWidgets('com arte no scope, ela É pintada, e o scope manda no estilo', (t) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: BoldBackdropScope(
          estilo: BoldBackdrop.imagem,
          arteClara: const AssetImage('assets/fonts/OFL.txt'), // qualquer provider serve
          child: const Scaffold(body: BoldBackground(child: Text('conteúdo'))),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 50));

    // O `errorBuilder` do componente cobre asset inválido, então o que se mede aqui é a
    // ESCOLHA do caminho: existe um Image na árvore porque o scope declarou arte.
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('a cor do fundo vem da PALETA e do papel, nunca de literal', (t) async {
    // Exigência 1 do contrato. No sólido escuro o fundo é `bgEscuro` — o campo que este filho
    // declarou na v0.1.9 do pai; antes dele, o escuro saía navy do primeiro filho.
    await t.pumpWidget(montar(
      const BoldBackground(estilo: BoldBackdrop.solido, child: SizedBox()),
      escuro: true,
    ));
    await t.pump(const Duration(milliseconds: 50));

    final caixas = t
        .widgetList<ColoredBox>(find.byType(ColoredBox))
        .map((c) => c.color.toARGB32())
        .toSet();
    expect(caixas, contains(BoldPalette.bold.bgEscuro!.toARGB32()),
        reason: 'o sólido escuro tem que ser o bgEscuro declarado na paleta');
    expect(caixas, isNot(contains(0xFF0B1020)),
        reason: 'navy do primeiro filho no fundo do Bold');
  });

  testWidgets('ZERO valor de cor solto: os fundos frios são VINHO, não violeta', (t) async {
    // O componente antigo tinha quatro literais de cor. Três eram rampa (rosa, coral, amarelo) e
    // foram modulados na adoção; o quarto era um violeta `#7B3FF2` que não pertencia a rampa
    // nenhuma deste produto — e era o último valor solto no componente mais usado do app.
    //
    // O dono do produto resolveu com o vinho, que faz o mesmo trabalho (polo frio e profundo
    // contra o rosa) com cor que é da marca. Este teste é o que impede o violeta de voltar.
    for (final fundo in [BoldBackdrop.vidroFrio, BoldBackdrop.aurora]) {
      await t.pumpWidget(montar(
        BoldBackground(estilo: fundo, child: const SizedBox()),
        escuro: true,
      ));
      await t.pump(const Duration(milliseconds: 50));

      final matizes = <int>{};
      for (final w in t.allWidgets) {
        for (final prop in w.toDiagnosticsNode().getProperties()) {
          if (prop.value case final BoxDecoration d) {
            if (d.gradient case final RadialGradient g) {
              for (final c in g.colors) {
                if (c.a > 0) matizes.add(c.withValues(alpha: 1).toARGB32());
              }
            }
          }
        }
      }
      expect(matizes, isNot(contains(0xFF7B3FF2)),
          reason: 'o violeta voltou no fundo "${fundo.name}"');
      expect(matizes, contains(BoldVinho.marca.toARGB32()),
          reason: 'o fundo frio "${fundo.name}" precisa do polo vinho');
    }
  });

  test('o vinho tem NOME, e a paleta empresta dele em vez de repetir o hex', () {
    // O vinho aparecia em quatro lugares do produto antigo com quatro nomes (`brandPrincipal`,
    // `glassFill`, `secondaryFlow` e o violeta dos fundos). Agora tem casa: o slot de parceiro e
    // o tinte de vidro escuro leem de lá, então trocar o parceiro um dia não move o vidro.
    expect(BoldPalette.bold.partnerPrimary, BoldVinho.marca);
    expect(BoldPalette.bold.partnerSurface, BoldVinho.ink);
    expect(BoldPalette.bold.tinteDeVidroEscuro!.withValues(alpha: 1).toARGB32(),
        BoldVinho.ink.toARGB32(),
        reason: 'o tinte de vidro escuro é o vinho-tinta a 50%');
  });
}
