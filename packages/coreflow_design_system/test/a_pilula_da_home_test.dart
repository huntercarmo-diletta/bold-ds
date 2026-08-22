import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A PÍLULA DA HOME — e o gate existe porque a divergência dela custou um print.
///
/// O catálogo desenhou a barra ANCORADA do pai no lugar desta por duas versões, e nada falhou: os dois
/// desenhos são válidos, e nenhuma medição perguntava qual deles a home usa. O dono achou olhando:
/// *"você tá usando a navbar da CPF Seguro, não do Bold — no Bold a navbar não deixa a home indicator
/// dentro dela."*
///
/// Então é isso que este arquivo mede: as duas propriedades que separam uma da outra.
void main() {
  Widget naTela(Widget filho, {bool escuro = false}) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: BoldFonts.familyRaw,
          brightness: escuro ? Brightness.dark : Brightness.light,
        ),
        home: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          // `Scaffold` porque a família da fonte chega no texto pelo `DefaultTextStyle`, e quem o
          // fornece é o Material.
          child: Scaffold(backgroundColor: const Color(0x00000000), body: filho),
        ),
      );

  const itens = [
    CoreflowItemDeNav(icone: DilettaIcons.houseLight, rotulo: 'Início'),
    CoreflowItemDeNav(icone: DilettaIcons.cameraLight, rotulo: 'Câmera'),
    CoreflowItemDeNav(icone: DilettaIcons.sparklesLightFull, rotulo: 'Letti'),
  ];

  testWidgets('ela NÃO traz o indicador de home por dentro', (t) async {
    await t.pumpWidget(naTela(
      const CoreflowNavFlutuante(itens: itens, ativo: 0),
    ));
    await t.pump(const Duration(milliseconds: 200));

    // A diferença de aparelho: no `DilettaBottomApp` TODA variante termina no indicador, e por isso a
    // tela que usa a barra do pai não declara o traço. Aqui ele é do sistema, e a tela declara.
    expect(find.byType(DilettaBottomHomeIndicator), findsNothing);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Letti'), findsOneWidget);
  });

  testWidgets('ela ABRAÇA os itens — hug, e não a largura da tela', (t) async {
    await t.pumpWidget(naTela(const Center(
      child: CoreflowNavFlutuante(itens: itens, ativo: 1),
    )));
    await t.pump(const Duration(milliseconds: 200));

    final pilula = t.getSize(find.byType(DilettaGlassSurface));
    final tela = t.getSize(find.byType(Scaffold));
    // Com três itens ela mede bem menos que a tela. O número não é o ponto — o ponto é NÃO ser a
    // largura cheia, que é o desenho da outra barra.
    expect(pilula.width, lessThan(tela.width - 32),
        reason: 'a pílula esticou: virou a barra ancorada do pai');
  });

  testWidgets('o item inativo guarda o espaço do spot — a fila não pula', (t) async {
    // ALTURA, e não a Size inteira: a LARGURA muda de propósito entre os dois estados, porque o rótulo
    // do ativo vai a peso 700 e texto mais gordo mede mais. Foi a primeira volta deste teste, e ela
    // estava medindo a coisa certa pelo eixo errado — o que faz a fila desalinhar é a altura.
    double alturaDoItem() {
      return t.getSize(find.ancestor(
        of: find.text('Câmera'),
        matching: find.byType(DilettaFrame),
      ).first).height;
    }

    await t.pumpWidget(naTela(const CoreflowNavFlutuante(itens: itens, ativo: 0)));
    await t.pump(const Duration(milliseconds: 200));
    final comCameraInativa = alturaDoItem();

    await t.pumpWidget(naTela(const CoreflowNavFlutuante(itens: itens, ativo: 1)));
    await t.pump(const Duration(milliseconds: 200));
    final comCameraAtiva = alturaDoItem();

    expect(comCameraInativa, comCameraAtiva,
        reason: 'o círculo do inativo sumiu em vez de ficar transparente: '
            'o item muda de tamanho ao ser escolhido e a fila desalinha');
  });
}
