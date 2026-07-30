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

  test('o violeta é o ÚNICO valor fora da paleta, e está isolado', () {
    // O componente antigo tinha quatro literais de cor. Três eram rampa (rosa, coral, amarelo) e
    // foram modulados; o violeta não pertence a rampa nenhuma deste produto.
    //
    // Este teste existe pra a dívida ser UMA e ter nome. Se um segundo valor aparecer aqui, ou
    // ele é rampa e se modula, ou a decisão de marca sobre cor fria precisa ser tomada.
    expect(BoldBackdropTints.violeta, const Color(0xFF7B3FF2));
    final rampas = {
      BoldPalette.bold.primary04,
      BoldPalette.bold.warning03,
      BoldPalette.bold.warning04,
      BoldPalette.bold.primary08,
    };
    expect(rampas, isNot(contains(BoldBackdropTints.violeta)),
        reason: 'se o violeta virou degrau de rampa, ele sai daqui');
  });
}
