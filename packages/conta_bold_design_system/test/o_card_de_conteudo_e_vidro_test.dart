import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
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

  testWidgets('e o estado vazio e o cartão de acesso vêm no mesmo material', (t) async {
    // Os três que o veredito converteu. Se um deles voltar a sólido, o produto fica com dois materiais
    // de card na mesma tela — que é pior que os dois sólidos.
    await t.pumpWidget(montar(Column(children: const [
      DilettaEmptyState(title: 'Nada aqui', caption: 'Sem atividade ainda'),
      DilettaQuickAccessCard(icon: DilettaIcons.pixLight, label: 'Pix'),
    ])));
    await t.pump();
    expect(find.byType(BackdropFilter), findsWidgets);
  });
}
