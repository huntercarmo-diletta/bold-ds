import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CARD DE CONTEÚDO É VIDRO NESTE PRODUTO, e uma linha da paleta é o que diz isso.
///
/// O defeito chegou por quem olhou o board: *"o fundo nos cards (lista) também é glassy e eles estão
/// solid"*. Estava certo — o `DilettaAppList.carded` do pai cravava `color: s.surface`, e não havia como
/// pedir outro material. Virou pedido, o veredito foi `cardDeVidro` no scheme (`ds v0.32.0`), e aqui a
/// adoção é uma linha em `BoldPalette.bold`.
///
/// O gate mede as duas metades, porque declarar sem render é meia adoção:
///
/// 1. a paleta DECLARA — e é o único lugar onde isso se declara;
/// 2. o card RENDERIZA vidro — `BackdropFilter` na árvore, que é o que vidro é. Cor com alpha passaria no
///    olho e não desfoca nada.
void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Scaffold(body: filho),
        ),
      );

  test('a paleta declara o card de vidro', () {
    expect(BoldPalette.bold.cardDeVidro, isTrue,
        reason: 'sem a declaração, o card do vocabulário volta a ser sólido em silêncio');
    // A receita inteira, que é o que faz o vidro deste produto ser DESTE produto.
    expect(BoldPalette.bold.blurDeVidro, 15);
    expect(BoldPalette.bold.tinteDeVidroClaro, isNotNull);
    expect(BoldPalette.bold.tracoDeVidroClaro, isNotNull);
  });

  testWidgets('a lista em card desenha VIDRO, nos dois modos', (t) async {
    for (final escuro in [false, true]) {
      await t.pumpWidget(montar(
        escuro: escuro,
        DilettaAppList.carded(children: const [
          DilettaAppListRow(middle: DilettaMiddleAccessory.titleSubtitle(title: 'Pix', subtitle: 'Enviar')),
        ]),
      ));
      await t.pump();
      // `BackdropFilter` é o que distingue vidro de cor translúcida: sobre fundo liso a segunda não
      // desfoca nada, e foi esse o argumento que descartou "pintar por cima" quando eu pedi.
      expect(find.byType(BackdropFilter), findsWidgets,
          reason: 'card de lista sem BackdropFilter: é sólido ou é cor com alpha, e nenhum dos dois é vidro');
    }
  });

  testWidgets('e os QUATRO convertidos vêm no mesmo material', (t) async {
    // Eram três na `ds v0.32.0`; o cartão de destaque entrou na `v0.33.0` depois de aparecer sólido no
    // primeiro print do catálogo publicado, ao lado de dois já convertidos. Se um deles voltar a sólido, o
    // produto fica com dois materiais de card na mesma tela — que é pior que os dois sólidos.
    await t.pumpWidget(montar(Column(children: const [
      DilettaEmptyState(title: 'Nada aqui', caption: 'Sem atividade ainda'),
      DilettaQuickAccessCard(icon: DilettaIcons.pixLight, label: 'Pix'),
      DilettaFeatureCard(
        icon: DilettaIcons.piggyBankLight,
        title: 'Conta PJ',
        description: 'Alçadas, operadores e aprovação em duas mãos.',
        brandColor: BoldColors.primary04,
      ),
    ])));
    await t.pump();
    expect(find.byType(BackdropFilter), findsWidgets);
    // Um por um, porque `findsWidgets` no conjunto passaria com três de quatro — que é exatamente o
    // defeito que este teste existe pra pegar.
    for (final tipo in [DilettaEmptyState, DilettaQuickAccessCard, DilettaFeatureCard]) {
      expect(
        find.descendant(of: find.byType(tipo), matching: find.byType(BackdropFilter)),
        findsWidgets,
        reason: '$tipo desenha card sólido enquanto os vizinhos são vidro',
      );
    }
  });

  testWidgets('e o vidro DEIXA A COR DE TRÁS PASSAR — medido em pixel', (t) async {
    // Este teste existe porque dois prints seguidos discutiram material olhando, e olhar não decide: vidro
    // sobre fundo claro parece branco, e branco chapado também. O que distingue é o pixel — se a cor de
    // trás atravessa, é vidro; se não atravessa, é fill.
    const chave = Key('paraLerOsPixels');
    const fundo = Color(0xFF1B6FE0); // azul forte, longe de qualquer cor da paleta

    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: RepaintBoundary(
          key: chave,
          child: Stack(children: [
            Positioned.fill(child: ColoredBox(color: fundo)),
            Center(
              child: SizedBox(
                width: 300,
                child: DilettaAppList.carded(children: const [
                  DilettaAppListRow(
                    middle: DilettaMiddleAccessory.titleSubtitle(title: 'Pix', subtitle: 'Enviar'),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));

    // `runAsync`: fora dele o relógio do teste é falso, e a codificação da imagem — que é assíncrona de
    // verdade — nunca completa. O teste ficava dez minutos pendurado até o timeout.
    late final Uint8List rgba;
    late final ui.Image imagem;
    await t.runAsync(() async {
      final boundary = t.renderObject<RenderRepaintBoundary>(find.byKey(chave));
      imagem = await boundary.toImage();
      final bytes = await imagem.toByteData(format: ui.ImageByteFormat.rawRgba);
      rgba = bytes!.buffer.asUint8List();
    });

    ({int r, int g, int b}) pixel(int x, int y) {
      final i = (y * imagem.width + x) * 4;
      return (r: rgba[i], g: rgba[i + 1], b: rgba[i + 2]);
    }

    // Um ponto no MEIO do card, longe do texto e do ícone: a faixa entre a borda direita do card e o
    // acessório da direita.
    final dentro = pixel(imagem.width ~/ 2 + 100, imagem.height ~/ 2);
    // E um de controle, fora do card.
    final fora = pixel(10, 10);

    expect(fora, (r: 27, g: 111, b: 224), reason: 'o controle não é o fundo declarado');

    // VIDRO: o azul de trás atravessa o tinte branco@50%, então o pixel de dentro puxa azul — o canal B
    // fica bem acima do R. Fill branco daria R≈G≈B.
    expect(dentro.b - dentro.r, greaterThan(20),
        reason: 'o pixel dentro do card é $dentro: sem azul atravessando, isso é FILL e não vidro');
    // E não é o fundo cru: o tinte clareia, então o pixel é mais claro que o azul puro.
    expect(dentro.r, greaterThan(60), reason: 'o card não está tingindo nada — cadê o tinte?');
  });
}
