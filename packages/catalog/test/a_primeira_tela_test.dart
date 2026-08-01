import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_catalog/telas_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// AS TELAS DESTE PRODUTO, e elas eram zero até hoje.
///
/// O pai mediu a falta na v0.55.0 do motor — *"um filho tem 124 telas, o outro tem ZERO"* — e a
/// consequência que ele escreveu é a que justifica este arquivo: **todo o pipeline de tela tinha um usuário
/// só**, então defeito daquele caminho era invisível por construção deste lado. Uma tela declarada aqui é o
/// segundo usuário.
///
/// O que este gate mede, e nenhuma das três é decoração:
///
/// 1. a tela é VÁLIDA pela autoria do pai — e ela já me pegou um ícone inventado;
/// 2. o código emitido dela COMPILA (o gate do emitido cobre bloco por bloco; este cobre a tela montada,
///    que é onde slot dentro de slot e a região `bottom` aparecem juntos);
/// 3. a seção CONSOME não está vazia — que é o conserto que o pai acabou de fazer, medido do lado do
///    produtor.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  test('as CINCO telas são válidas pela autoria do PAI, e são exatamente estas', () {
    // Segundo achado da varredura do pai, e este é meu: o nome dizia "as TRÊS telas" com CINCO no mapa, e a
    // asserção era `containsAll([...])` — que não vê tela nova nem tela que sobrou. Mesma classe do
    // movimento: o número que o nome promete não estava na asserção.
    //
    // Afirmar o conjunto INTEIRO faz tela nova cair aqui com o slug dela no diff. É o que eu quero: tela
    // declarada e não gateada é tela que ninguém mediu a 320.
    expect(telasDoBold().keys.toSet(), {
      kSlugDaHome,
      kSlugDoValorDoPix,
      kSlugDaRevisaoDoPix,
      kSlugDoPixEnviado,
      kSlugDasAutorizacoes,
    });
  });

  test('a autoria do PAI valida as cinco', () {
    // `montaDaAutoria` roda dentro de `telasDoBold()`, então chamar já é o gate: prop inexistente, enum
    // fora do vocabulário, slot que não existe e id repetido reprovam com a lista inteira.
    //
    // Ela já rendeu na primeira execução: eu tinha escrito `arrowsLeftRightLight`, que não existe. Terceira
    // vez nesta semana que eu invento nome de ícone, e a primeira em que a peça que acusa é do pai.
    final telas = telasDoBold();

    // A SEGUNDA é a única que usa os três componentes de alçada. Eles tinham uso medido no app e ZERO uso
    // em tela declarada — o caso mais fácil de um componente apodrecer sem ninguém ver.
    final pj = telas[kSlugDasAutorizacoes]!;
    final tiposDaPj = [
      for (final b in [...pj.top, ...pj.blocks, ...pj.bottom]) b.type,
    ];
    expect(tiposDaPj,
        containsAll(['progressoDeAprovacao', 'prazoDaPendencia', 'escadaDeAlcadas']));

    final spec = telas[kSlugDaHome]!;
    expect(spec.scrollableContent, isTrue);
    expect(spec.contentGap, 's5', reason: 'o ritmo é UMA declaração, não bloco de espaço');

    // Nenhum bloco de espaçamento: é a regra do contrato de autoria, com a medição do primeiro filho
    // atrás dela (238 de 1.032 blocos eram só espaço).
    final tipos = [
      for (final b in [...spec.top, ...spec.blocks, ...spec.bottom]) b.type,
    ];
    expect(tipos, isNot(contains('ritmo')),
        reason: 'espaço virou bloco — o ritmo é o contentGap');
  });

  test('a seção CONSOME tem os CINCO campos, e é o conserto do pai medido daqui', () {
    // A v0.55.0 do motor consertou `leContratoDaTela`, que lia só `BoundRef` dentro de `props` e ignorava
    // o mapa `Block.bindings` — a forma que o compositor de verdade escreve. Resultado: CONSOME vazia pra
    // toda tela real, numa página recém-anunciada.
    //
    // Esta tela é escrita na representação do PRODUTOR, então ela é o caso de verdade. O gate fixa os cinco
    // campos: se a seção esvaziar de novo, isto falha aqui — no repo que tem a tela — e não no do pai, que
    // não tem nenhuma.
    final c = leContratoDaTela(telasDoBold()[kSlugDaHome]!);

    expect(c.dados.map((d) => '${d.campo} → ${d.bloco}.${d.prop}').toSet(), {
      'nomeDoTitular → cabecalhoDaHome.nome',
      'rotuloDaConta → cabecalhoDaHome.conta',
      'saldoFormatado → saldo.valor',
      'entradasDoMes → saldo.entradas',
      'saidasDoMes → saldo.saidas',
    });

    // E as quatro notas, uma de cada tipo que o contrato distingue: o que se perde no handoff é caso de
    // borda e acessibilidade, e por isso os dois têm tipo próprio.
    expect(c.notas.keys.toSet(), {'decisao', 'regra', 'borda', 'a11y'});
  });

  testWidgets('a HOME DESENHA, e no aperto de um telefone de 320', (t) async {
    // O sweep dos 56 blocos mede bloco a bloco; uma tela montada é outra pergunta — aqui slot dentro de
    // coleção, duas regiões fixas e o content rolando existem ao mesmo tempo.
    t.view.physicalSize = const Size(320, 3000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);

    await t.pumpWidget(MaterialApp(theme: ThemeData(fontFamily: BoldFonts.familyRaw), 
      home: Ds.tema(Scaffold(
        body: buildScreenLayout(telasDoBold()[kSlugDaHome]!, leaf: buildBlock),
      )),
    ));
    await t.pump(const Duration(milliseconds: 200));

    FlutterError.onError = anterior;
    t.takeException();

    // UM resíduo, e ele é do PLACEHOLDER e não do componente.
    //
    // As props vinculadas aparecem no preview como `{campo}`, e `{entradasDoMes}` + `{saidasDoMes}` são
    // mais largos que qualquer dinheiro real: a fileira de pastilhas vaza 9,4px. Medido com valor de
    // verdade — inclusive `R$ 1.234.567,89`, sete dígitos — o card **não vaza em nenhuma largura**, e o
    // teste abaixo prova as duas metades.
    //
    // Fica declarado em vez de silenciado porque quem abre o board VÊ a listra amarela, e isso é
    // informação sobre a convenção do pai, não sobre este produto.
    expect(erros.length, lessThanOrEqualTo(1),
        reason: 'estouro NOVO além do do placeholder: ${erros.join(' | ')}');

    // O saldo é o que a tela existe pra mostrar. Com binding, o preview usa o PLACEHOLDER do pai
    // (`{saldoFormatado}`) — então o que se prova aqui é que o bloco chegou na árvore, não o valor.
    expect(find.byType(BoldSaldo), findsOneWidget);
  });

  for (final slug in [kSlugDoValorDoPix, kSlugDaRevisaoDoPix, kSlugDoPixEnviado]) {
    testWidgets('$slug desenha no aperto de 320', (t) async {
      // O fluxo inteiro no menor aparelho que o app suporta. A HOME tem o resíduo declarado do placeholder;
      // estas três não têm nenhum, e é por isso que elas cobram ZERO em vez de "no máximo um".
      t.view.physicalSize = const Size(320, 3000);
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);

      final erros = <String>[];
      final anterior = FlutterError.onError;
      FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
      await t.pumpWidget(MaterialApp(
        theme: ThemeData(fontFamily: BoldFonts.familyRaw),
        home: Ds.tema(Scaffold(
          body: buildScreenLayout(telasDoBold()[slug]!, leaf: buildBlock),
        )),
      ));
      await t.pump(const Duration(milliseconds: 200));
      FlutterError.onError = anterior;
      t.takeException();

      expect(erros, isEmpty, reason: erros.take(3).join(' | '));
    });
  }

  testWidgets('a PJ desenha no aperto de 320, com os três blocos de alçada', (t) async {
    // A HOME tem um resíduo conhecido (o placeholder do pai). Esta não tem nenhum, e vale medir separado:
    // ela é a que carrega os três componentes de alçada, que são os mais densos deste registro — escada com
    // degraus, progresso com frase e pastilha de prazo, numa tela de 320.
    t.view.physicalSize = const Size(320, 3000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: BoldFonts.familyRaw),
      home: Ds.tema(Scaffold(
        body: buildScreenLayout(telasDoBold()[kSlugDasAutorizacoes]!, leaf: buildBlock),
      )),
    ));
    await t.pump(const Duration(milliseconds: 200));
    FlutterError.onError = anterior;
    t.takeException();

    expect(erros, isEmpty, reason: erros.take(3).join(' | '));
    expect(find.byType(BoldEscadaDeAlcadas), findsOneWidget);
    expect(find.byType(BoldProgressoDeAprovacao), findsOneWidget);
  });

  testWidgets('e com DADO DE VERDADE ela não vaza em nada', (t) async {
    // A metade que separa "defeito do componente" de "artefato do placeholder". A mesma tela com os
    // valores literais do bloco, e mais o pior caso de dinheiro deste produto (conta PJ, sete dígitos).
    t.view.physicalSize = const Size(320, 3000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final comValor = montaDaAutoria({
      'slug': 'pf1-home-com-valor',
      'name': 'PF1 · Home (dado real)',
      'scrollableContent': true,
      'contentGap': 's5',
      'top': [
        {'type': 'barraDeStatus'},
        {'type': 'cabecalhoDaHome'},
      ],
      'blocks': [
        {
          'type': 'saldo',
          'props': {
            'valor': r'R$ 1.234.567,89',
            'entradas': r'R$ 987.654,32',
            'saidas': r'R$ 123.456,78',
          },
        },
        {'type': 'cartaoDeDestaque'},
      ],
      'bottom': [
        {'type': 'barraDeBaixo'},
        {'type': 'indicadorDeHome'},
      ],
    });

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: BoldFonts.familyRaw),
      home: Ds.tema(Scaffold(body: buildScreenLayout(comValor, leaf: buildBlock))),
    ));
    await t.pump(const Duration(milliseconds: 200));
    FlutterError.onError = anterior;
    t.takeException();

    expect(erros, isEmpty, reason: 'com dado real a tela vaza: ${erros.join(' | ')}');
  });

  testWidgets('a aba TELAS mostra as duas, agrupadas pelo eixo macro', (t) async {
    // Sem esta aba as telas existem no plugue e não aparecem em lugar nenhum do catálogo: quem lê
    // `especificacoes` é o compositor e o board, e eu não tinha board. Declarar e não mostrar é o mesmo
    // meio-caminho que a arte do fundo era.
    t.view.physicalSize = const Size(1400, 1000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final grupos = gruposDeTelasDoBold();
    expect(grupos.map((g) => g.macro).toSet(), {'PF', 'PJ'},
        reason: 'o macro é DERIVADO do prefixo do slug — tela nova entra sozinha');
    expect(grupos.expand((g) => g.screens).length, telasDoBold().length);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: BoldFonts.familyRaw),
      home: Scaffold(body: Builder(
        builder: (ctx) =>
            configDoCatalogoDoBold().abas.firstWhere((a) => a.id == 'telas').constroi(ctx),
      )),
    ));
    await t.pump(const Duration(milliseconds: 400));
    FlutterError.onError = anterior;
    t.takeException();
    expect(erros, isEmpty, reason: erros.take(3).join(' | '));

    expect(find.text('Conta PF'), findsWidgets);
    expect(find.text('Conta PJ'), findsWidgets);
  });

  test('as SETAS do fluxo de Pix dão sentido ao motionDaTransicao', () {
    // Duas telas no mesmo fluxo é o que faz uma seta possível, e a seta é o que faz a declaração de
    // movimento medir alguma coisa. Antes disto eu tinha ligado `push` ao token `slow` com ZERO setas —
    // declaração sobre nada, que é a classe que este repo persegue desde o `tinta:` órfão.
    final g = leGramaticaDeComposicao();

    final push = g.movimentos.firstWhere((m) => m.tipo == TipoConexao.push);
    expect(push.setas, 3,
        reason: 'o fluxo de Pix tem quatro telas e três saltos — sumiu seta do `ligacoesDeclaradas`');
    expect(push.motion?.token, 'DilettaMotion.slow',
        reason: 'a seta existe e o movimento dela não — é o vermelho "usado sem token" do pai');

    // DERIVADA não basta: o board desenha a seta pela ordem das telas quando ninguém editou, e a Gramática
    // lê o que foi DECIDIDO. Com a seta só derivada, este painel mostrava `push: setas=0`.
    expect(Conteudo.ligacoesDeclaradas['pf/conta-pf'], isNotNull,
        reason: 'a seta voltou a ser só derivada, e a medição do movimento morre junto');

    // E a chave do fluxo EXISTE: chave errada não casa, o board cai nas setas derivadas, e nada avisa.
    expect(Conteudo.ligacoesParaFluxoInexistente({'pf/conta-pf', 'pj/conta-pj'}), isEmpty);
  });

  test('cada seta ancora no CTA da tela de origem, e não num bloco qualquer', () {
    // O defeito que o pai descreve e que eu cometi escrevendo estas setas: `bloco` casa com o primeiro id
    // que EXISTIR na tela, e nada avisa. Eu tinha posto `b_1` nas três por analogia com a primeira — e
    // `b_1` nas telas de Pix é bloco de CONTEÚDO. O desenho diria que o valor leva à revisão.
    //
    // O gate deriva o CTA em vez de repetir os ids: o gatilho de uma tela deste produto é o botão da base.
    // Assim ele continua valendo quando um bloco novo renumerar a tela.
    final telas = [kSlugDaHome, kSlugDoValorDoPix, kSlugDaRevisaoDoPix, kSlugDoPixEnviado]
        .map((s) => telasDoBold()[s]!)
        .toList();

    final ligacoes = Conteudo.ligacoesDeclaradas['pf/conta-pf']!;
    expect(ligacoes, hasLength(3), reason: 'o fluxo de Pix tem quatro telas e três saltos');

    for (final l in ligacoes.skip(1)) {
      final origem = telas[l.de];
      final cta = origem.bottom.firstWhere((b) => b.type == 'botao');
      expect(l.bloco, cta.id,
          reason: 'a seta ${l.de}→${l.para} ancora em "${l.bloco}", e o CTA de "${origem.name}" '
              'é "${cta.id}"');
    }

    // A PRIMEIRA é a exceção, e ela é declarada: na home o gatilho não é CTA de base, é a LINHA do Pix
    // dentro do slot da lista. Fixar o id aqui é o que impede que um "conserto" a mova pro rodapé.
    expect(ligacoes.first.bloco, 'b_4');
  });

  test('e a tela está no plugue de conteúdo, em JSON', () {
    // Sem esta linha a tela existe no código e não existe no catálogo: quem lê `Conteudo.especificacoes`
    // são o board, o compositor, a aba de telas e a conformidade. Declarar e não plugar é o mesmo tipo de
    // meio-caminho que a arte do fundo era.
    // O conjunto INTEIRO, e não `containsAll`: o plugue tem que ter as mesmas telas que o mapa, nem mais
    // nem menos. Com `containsAll` uma tela declarada e não plugada passaria — que é o meio-caminho que
    // este teste existe pra pegar.
    expect(Conteudo.especificacoes.keys.toSet(), telasDoBold().keys.toSet());
    expect(Conteudo.especificacoes[kSlugDaHome], contains('cabecalhoDaHome'));
    expect(Conteudo.especificacoes[kSlugDasAutorizacoes], contains('escadaDeAlcadas'));
  });
}
