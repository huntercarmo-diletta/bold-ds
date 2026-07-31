import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A SEÇÃO "COMO ELA SE MONTA" CONTRA O QUE O FRAME PINTA — o item 2 do RELEASE v0.48.0.
///
/// O pai pediu: *"abrir o modal de doc de uma tela COMPOSTA e conferir se a montagem descreve o que você
/// vê no frame. Se a seção disser algo diferente do desenho, é defeito meu e eu quero a tela."*
///
/// Conferir de olho responde uma vez. Este teste responde a cada `pub get`, e a diferença importa porque
/// a seção é DERIVADA: ela e o desenho saem da mesma spec por dois caminhos diferentes
/// (`leContratoDaTela` e `buildScreenLayout`), e caminho duplo é exatamente onde os dois divergem sem
/// ninguém notar.
///
/// **O que ele NÃO é**: comparar a seção com a spec seria tautologia — os dois lados leem a mesma lista.
/// O que ele compara é a seção com a **geometria na tela**: a ordem de leitura que a doc promete contra o
/// `dy` real de cada bloco pintado, e o encaixe do slot contra as bordas do pai que o contém.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  /// Uma tela COMPOSTA de verdade: as três regiões ocupadas, um bloco com slot de lista, e o content
  /// rolando. É a forma da home deste produto, que é a tela mais montada que ele tem.
  ScreenSpec telaComposta() {
    Block bloco(String id, String tipo, [Map<String, List<Block>>? filhos]) => Block(
          id: id,
          type: tipo,
          props: Ds.blocos[tipo]!.defaults(),
          slots: filhos ?? const {},
        );

    return ScreenSpec(
      name: 'composta',
      scrollableContent: true,
      contentGap: 's4',
      top: [bloco('t1', 'cascaDeTopo')],
      blocks: [
        bloco('c1', 'saldo'),
        bloco('c2', 'lista', {
          'itens': [bloco('c2a', 'linha'), bloco('c2b', 'linha')],
        }),
        bloco('c3', 'botao'),
      ],
      bottom: [bloco('b1', 'barraDeNavegacao')],
    );
  }

  test('as três regiões saem na ordem de leitura, e o slot entra com o nome do slot', () {
    // SEM `tiposDeEscape`, e isso é a declaração certa: este registro não tem bloco de código cru.
    //
    // A primeira versão deste teste passava `{'visorDeCodigo'}`, e era um fato falso meu — o visor é um
    // COMPONENTE que mostra código, não um escape que injeta código. Marcá-lo como escape faria toda tela
    // que o usa dizer "meu contrato está incompleto", que é o oposto do que ele é.
    final c = leContratoDaTela(telaComposta());

    expect(c.regioes.map((r) => r.nome).toList(), ['topo', 'conteúdo', 'base'],
        reason: 'a ordem das regiões É a ordem de leitura da tela');

    final conteudo = c.regioes.firstWhere((r) => r.nome == 'conteúdo');
    expect(conteudo.rola, isTrue);
    expect(conteudo.ritmo, 's4');
    expect(c.regioes.where((r) => r.fixa).map((r) => r.nome).toList(), ['topo', 'base'],
        reason: 'topo e base não rolam com o conteúdo — é metade do "onde ficam as coisas"');

    // O ENCAIXE, que era o que o mapa de contagem perdia: as duas linhas não são blocos soltos do
    // content, elas estão dentro do slot `itens` da lista.
    final dentroDoSlot = conteudo.itens.where((i) => i.profundidade > 0).toList();
    expect(dentroDoSlot.map((i) => (i.tipo, i.slot, i.ordem)).toList(),
        [('linha', 'itens', 1), ('linha', 'itens', 2)]);

    // E a contagem continua contando quem está dentro do slot — as duas coisas convivem.
    expect(c.componentes['linha'], 2);
  });

  testWidgets('a ordem da doc é a ordem que o frame PINTA', (t) async {
    t.view.physicalSize = const Size(390, 1200);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final spec = telaComposta();
    final c = leContratoDaTela(spec);

    await t.pumpWidget(MaterialApp(
      home: Ds.tema(Scaffold(body: buildScreenLayout(spec, leaf: buildBlock))),
    ));
    await t.pump(const Duration(milliseconds: 200));

    /// O `dy` do topo de um bloco pintado, achado pela etiqueta que o canvas põe em todo bloco.
    double dyDe(String id) {
      final f = find.byWidgetPredicate(
          (w) => w is MetaData && w.metaData is BlockTag && (w.metaData as BlockTag).id == id);
      expect(f, findsOneWidget, reason: 'o bloco "$id" não foi pintado');
      return t.getTopLeft(f).dy;
    }

    // A promessa da doc, achatada na ordem de leitura que ela desenha.
    final ordemDaDoc = [
      for (final r in c.regioes)
        for (final i in r.itens) i,
    ];
    expect(ordemDaDoc.length, 7,
        reason: 'sete itens: 1 topo + 3 raízes do content + 2 dentro do slot + 1 base');

    // A tela é de telefone e as regiões empilham, então "ordem de leitura" É `dy` crescente. Os ids
    // saem na mesma ordem em que a doc os numera, porque doc e spec compartilham a lista — o que se
    // mede aqui é se o DESENHO concorda com essa ordem.
    final ids = ['t1', 'c1', 'c2', 'c2a', 'c2b', 'c3', 'b1'];
    final dys = [for (final id in ids) dyDe(id)];
    for (var i = 1; i < dys.length; i++) {
      expect(dys[i], greaterThanOrEqualTo(dys[i - 1]),
          reason: 'a doc põe "${ids[i]}" depois de "${ids[i - 1]}", e o frame pinta antes');
    }

    // A BASE é fixa: ela fica no fim da tela, e não no fim do conteúdo.
    expect(dyDe('b1'), greaterThan(dyDe('c3')));

    // E o slot está DENTRO do pai, não ao lado dele — é o "encaixado em quê" da seção, medido em pixels.
    final listaRect = t.getRect(find.byWidgetPredicate(
        (w) => w is MetaData && w.metaData is BlockTag && (w.metaData as BlockTag).id == 'c2'));
    for (final filho in ['c2a', 'c2b']) {
      final r = t.getRect(find.byWidgetPredicate((w) =>
          w is MetaData && w.metaData is BlockTag && (w.metaData as BlockTag).id == filho));
      expect(listaRect.contains(r.topLeft) && listaRect.contains(r.bottomRight - const Offset(1, 1)),
          isTrue,
          reason: 'a doc diz que "$filho" está no slot `itens` de "c2", e o frame pinta fora dele');
    }
  });

  testWidgets('e o gate SABE ver ordem trocada — controle com a spec ao contrário', (t) async {
    // Sem este controle, o teste acima é "os dy vieram crescentes", que é o que ele diria também se
    // `dyDe` estivesse lendo sempre o mesmo bloco.
    t.view.physicalSize = const Size(390, 1200);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final invertida = ScreenSpec(
      name: 'invertida',
      blocks: [
        Block(id: 'c3', type: 'botao', props: Ds.blocos['botao']!.defaults()),
        Block(id: 'c1', type: 'saldo', props: Ds.blocos['saldo']!.defaults()),
      ],
    );

    await t.pumpWidget(MaterialApp(
      home: Ds.tema(Scaffold(body: buildScreenLayout(invertida, leaf: buildBlock))),
    ));
    await t.pump(const Duration(milliseconds: 200));

    double dyDe(String id) => t.getTopLeft(find.byWidgetPredicate(
        (w) => w is MetaData && w.metaData is BlockTag && (w.metaData as BlockTag).id == id)).dy;

    // A doc desta spec diz botão-depois-saldo, e o frame concorda. A asserção do teste de cima,
    // aplicada à ordem ERRADA, reprovaria — que é o que faz ela medir algo.
    expect(dyDe('c1'), greaterThan(dyDe('c3')));
  });
}
