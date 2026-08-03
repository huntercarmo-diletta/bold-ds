import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/telas_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CHROME NÃO SE DECLARA DUAS VEZES — e as cinco telas declaravam.
///
/// O defeito chegou por print de quem estava olhando a aba Telas: **dois relógios de 9:41 empilhados** no
/// topo do aparelho, e o CTA rosa flutuando sobre a arte com o traço de home logo abaixo dele. Nenhum dos
/// dois é erro de layout do motor: é a spec pedindo peça que a casca já traz.
///
/// O que a medição no DS mostrou:
///
/// - `DilettaTopAppBar.defaultVariant` e `.comConteudo` compõem `DilettaStatusBar` por dentro. Então
///   `cascaDeTopo` e `cabecalhoDaHome` JÁ TÊM a barra de status;
/// - **toda** variante de `DilettaBottomApp` termina em `DilettaBottomHomeIndicator` — `.button`, `.nav`,
///   `.keyboard`, as duas de chat. Então `barraDeBaixo` JÁ TEM o indicador;
/// - `DilettaNavigationButton` empilha 1-3 CTAs com gap 12 dentro do vidro da barra. Então CTA de rodapé
///   nunca precisa ser bloco solto — e solto ele perde a superfície de vidro que separa ação de conteúdo.
///
/// Os três blocos continuam no vocabulário: tela SEM casca de topo precisa da barra de status, e tela sem
/// barra de baixo precisa do indicador. O que este gate proíbe é a COEXISTÊNCIA, que é o que duplica.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  /// Os tipos declarados numa região, em profundidade zero — chrome não mora dentro de slot.
  Set<String> tiposDe(List<Block> regiao) => {for (final b in regiao) b.type};

  /// As cascas de topo que trazem a barra de status de dentro.
  const cascasComBarraDeStatus = {'cascaDeTopo', 'cabecalhoDaHome'};

  test('nenhuma tela declara barraDeStatus junto de uma casca que já a traz', () {
    final culpadas = <String>[];
    telasDoBold().forEach((slug, tela) {
      final top = tiposDe(tela.top);
      if (top.contains('barraDeStatus') &&
          top.intersection(cascasComBarraDeStatus).isNotEmpty) {
        culpadas.add(slug);
      }
    });
    expect(culpadas, isEmpty,
        reason: 'dois relógios no mesmo aparelho: a casca do pai já compõe a DilettaStatusBar');
  });

  test('nenhuma tela declara indicadorDeHome junto da barra de baixo', () {
    final culpadas = <String>[];
    telasDoBold().forEach((slug, tela) {
      final bottom = tiposDe(tela.bottom);
      if (bottom.contains('indicadorDeHome') && bottom.contains('barraDeBaixo')) {
        culpadas.add(slug);
      }
    });
    expect(culpadas, isEmpty,
        reason: 'dois traços de home: toda variante de DilettaBottomApp termina no indicador');
  });

  test('o CTA do rodapé mora DENTRO da barra de baixo, e não solto no bottom', () {
    // A regra é do produto e não do motor: neste app não existe botão de base fora da barra. Solto, ele
    // flutua sobre a arte do fundo — foi assim que o defeito apareceu no board, em três telas de fluxo.
    final culpadas = <String>[];
    telasDoBold().forEach((slug, tela) {
      if (tiposDe(tela.bottom).contains('botao')) culpadas.add(slug);
    });
    expect(culpadas, isEmpty,
        reason: 'botão solto no bottom: o CTA é o label da barraDeBaixo (primário e secundário)');
  });

  test('toda tela tem gatilho de saída, e o do fluxo é a barra de baixo', () {
    // O TERCEIRO defeito do mesmo print, e o mais fácil de não ver: as setas do fluxo de Pix diziam
    // "gatilho não documentado" em vermelho. A causa não era a seta — era `gatilhosDeSaida` VAZIO no
    // plugue deste catálogo. Com a lista vazia o motor não consegue ancorar a seta num componente, sai da
    // borda do frame e escreve a falta no rótulo. Degradação honesta dele, falta minha.
    telasDoBold().forEach((slug, tela) {
      expect(gatilhosDe(tela), isNotEmpty, reason: '$slug não tem componente que dispare saída');
    });

    // E o PRINCIPAL de uma tela de fluxo é o CTA da barra: `gatilhoPrincipalDe` procura no rodapé antes
    // do conteúdo, então o rótulo da seta é o texto do botão — "Continuar", "Confirmar".
    final valor = telasDoBold()[kSlugDoValorDoPix]!;
    expect(gatilhoPrincipalDe(valor)?.$2, 'Continuar');
    final revisao = telasDoBold()[kSlugDaRevisaoDoPix]!;
    expect(gatilhoPrincipalDe(revisao)?.$2, 'Confirmar');

    // A HOME é a exceção declarada: ela não tem CTA de fluxo, e a saída é o item "Pix" da lista de
    // atalhos — dentro de um slot, que é onde a busca em profundidade importa.
    final home = telasDoBold()[kSlugDaHome]!;
    expect(gatilhosDe(home).map((g) => g.label), contains(startsWith('Pix')));
  });

  // A PROVA no pixel, e não na spec: contar na árvore é o que fecha a porta. A spec pode parar de
  // declarar o chrome e o desenho continuar duplicado se um dia a casca do pai mudar de forma — e aí é
  // aqui que se descobre, não no print de quem abriu o board.
  for (final slug in [
    kSlugDaHome,
    kSlugDasAutorizacoes,
    kSlugDoValorDoPix,
    kSlugDaRevisaoDoPix,
    kSlugDoPixEnviado,
  ]) {
    testWidgets('$slug desenha UMA barra de status e UM indicador de home', (t) async {
      t.view.physicalSize = const Size(500, 3000);
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);

      await t.pumpWidget(MaterialApp(
        theme: ThemeData(fontFamily: BoldFonts.familyRaw),
        home: Ds.tema(Scaffold(
          body: buildScreenLayout(telasDoBold()[slug]!, leaf: buildBlock),
        )),
      ));
      await t.pump(const Duration(milliseconds: 200));
      t.takeException();

      expect(find.byType(DilettaStatusBar), findsOneWidget,
          reason: 'dois relógios: a casca do topo já traz a barra de status');
      // UM traço, e agora ele é o MESMO widget em toda variante.
      //
      // Este `expect` já foi um contorno: quando a `.nav` desenhava o traço num `_NavHomeIndicator`
      // privado, ele contava `DilettaBottomHomeIndicator` + `DilettaNav`, porque de fora não há como
      // referenciar classe privada de outro pacote. O pedido voltou **ENTRA como deleção** (`ds v0.31.0`,
      // e a medição do pai achou uma segunda cópia que eu não tinha como ver), então o contorno saiu e o
      // gate voltou a medir a peça — que é o que ele queria medir desde o começo.
      expect(find.byType(DilettaBottomHomeIndicator), findsOneWidget,
          reason: 'dois traços de home, ou nenhum: $slug');
    });
  }

  test('e o gate SABE reprovar — controle com as três formas erradas', () {
    // Sem o controle, os três testes acima passam num mapa vazio e ninguém nota.
    Block bloco(String tipo) => Block(id: tipo, type: tipo, props: const {});
    final topErrado = <Block>[bloco('barraDeStatus'), bloco('cascaDeTopo')];
    final bottomErrado = <Block>[
      bloco('botao'),
      bloco('barraDeBaixo'),
      bloco('indicadorDeHome'),
    ];
    expect(tiposDe(topErrado).contains('barraDeStatus'), isTrue);
    expect(tiposDe(topErrado).intersection(cascasComBarraDeStatus), isNotEmpty);
    expect(tiposDe(bottomErrado).contains('botao'), isTrue);
    expect(tiposDe(bottomErrado).containsAll({'indicadorDeHome', 'barraDeBaixo'}), isTrue);
  });
}
