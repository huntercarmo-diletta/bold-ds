import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/telas_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A PRIMEIRA TELA DESTE PRODUTO, e ela era zero até hoje.
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

  test('a HOME é válida pela autoria do PAI', () {
    // `montaDaAutoria` roda dentro de `telasDoBold()`, então chamar já é o gate: prop inexistente, enum
    // fora do vocabulário, slot que não existe e id repetido reprovam com a lista inteira.
    //
    // Ela já rendeu na primeira execução: eu tinha escrito `arrowsLeftRightLight`, que não existe. Terceira
    // vez nesta semana que eu invento nome de ícone, e a primeira em que a peça que acusa é do pai.
    final telas = telasDoBold();
    expect(telas.keys, contains(kSlugDaHome));

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

  test('e a tela está no plugue de conteúdo, em JSON', () {
    // Sem esta linha a tela existe no código e não existe no catálogo: quem lê `Conteudo.especificacoes`
    // são o board, o compositor, a aba de telas e a conformidade. Declarar e não plugar é o mesmo tipo de
    // meio-caminho que a arte do fundo era.
    expect(Conteudo.especificacoes.keys, contains(kSlugDaHome));
    expect(Conteudo.especificacoes[kSlugDaHome], contains('cabecalhoDaHome'));
  });
}
