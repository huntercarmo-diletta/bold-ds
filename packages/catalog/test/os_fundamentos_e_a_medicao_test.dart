import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// FUNDAMENTOS é do MOTOR desde a v0.43.0 (prosa que ensina), e o que era meu virou o PAINEL DE MEDIÇÃO
/// na aba de conformidade. Este teste seguiu as duas coisas:
///
/// - a aba de Fundamentos é do pai, e o que eu meço nela é a DECLARAÇÃO: as seções que o plugue entrega
///   (a linguagem dele mais as quatro deste produto);
/// - a de Styles voltou a ser do motor INTEIRA na v0.53.0: o papel semântico virou peça dele, com hex,
///   significado, amostra e contraste medido — e o que era a minha seção agora é DECLARAÇÃO no plugue;
/// - o painel de conformidade continua sendo meu, e sobrou nele o que é conformidade — o relatório de
///   adoção inteiro.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  testWidgets('as SEÇÕES declaradas chegam na aba do pai, e são exatamente estas cinco', (t) async {
    // Terceiro achado da varredura do pai, e este é meu. A asserção iterava `kBoldFundamentos.keys` e cobrava
    // presença em `Ds.fundamentos.keys` — mas o plugue É `{a do pai, ...kBoldFundamentos}`, então os dois
    // lados leem a mesma fonte: **apagar uma seção no DS derruba os dois e o teste fica verde.**
    //
    // Ele pegava metade do erro (tirar do plugue e deixar na fonte) e ficava cego pra outra metade. Os nomes
    // afirmados fecham as duas — e prosa que desaparece de Foundations é a classe que a limpa persegue.
    expect(Ds.fundamentos.keys.toSet(), {
      'A linguagem (do pai)',
      'A paleta do Bold',
      'Os dois gradientes',
      'O vidro',
      'A tipografia substituída',
    }, reason: 'seção de Foundations entrou ou saiu — se foi de propósito, o nome vem no diff');

    // E o cruzamento continua: tudo que a FONTE tem chega no plugue. Agora ele mede a direção que sobrou.
    for (final secao in kBoldFundamentos.keys) {
      expect(Ds.fundamentos.keys, contains(secao), reason: 'a seção "$secao" saiu do plugue');
    }
    // E a prosa NÃO é copiada: a do pai é a string do pacote dele, byte a byte.
    expect(Ds.fundamentos['A linguagem (do pai)'], same(kDilettaLinguagem));
  });

  testWidgets('desenha sem exceção, e é a aba INICIAL', (t) async {
    t.view.physicalSize = const Size(1400, 8000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final cfg = configDoCatalogoDoBold();
    expect(cfg.abaInicial, 'fundamentos',
        reason: 'quem abre o catálogo vê a paleta antes do que ela pinta');

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) =>
              cfg.abas.firstWhere((a) => a.id == 'fundamentos').constroi(ctx),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    FlutterError.onError = anterior;
    t.takeException();
    expect(erros, isEmpty, reason: erros.take(3).join(' | '));
  });

  testWidgets('STYLES desenha o papel semântico DECLARADO, e as famílias do motor', (t) async {
    // A página é do motor inteira desde a v0.53.0, então o que eu meço aqui é a DECLARAÇÃO chegando na
    // tela — não o desenho dela, que é gate do pai.
    //
    // Mede as duas metades juntas, porque cada uma sozinha passa com o defeito de pé: só as famílias
    // passariam com `papeis` vazio (a seção PAPEL simplesmente não apareceria), e só o papel passaria com
    // o inventário quebrado.
    t.view.physicalSize = const Size(1400, 12000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) =>
              configDoCatalogoDoBold().abas.firstWhere((a) => a.id == 'styles').constroi(ctx),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    FlutterError.onError = anterior;
    t.takeException();
    expect(erros, isEmpty, reason: erros.take(3).join(' | '));

    // A METADE DO MOTOR: cada família declarada tem seu cabeçalho.
    final inv = Ds.estilos;
    final familias = {
      if (inv.papeis.isNotEmpty) 'PAPEL SEMÂNTICO',
      if (inv.cores.isNotEmpty) 'COR',
      if (inv.tipos.isNotEmpty) 'TIPOGRAFIA',
      if (inv.raios.isNotEmpty) 'FORMA',
      if (inv.movimentos.isNotEmpty) 'MOVIMENTO',
    };
    for (final f in familias) {
      expect(find.text(f), findsWidgets, reason: 'a família "$f" não está na página');
    }

    // A MINHA METADE: o hex do papel DERIVADO da paleta, nos dois modos. O jeito de esta seção mentir é
    // mostrar um hex que não é o do token, então o teste procura o valor derivado.
    for (final (modo, e) in [
      ('claro', DilettaScheme.light(BoldPalette.bold)),
      ('escuro', DilettaScheme.dark(BoldPalette.bold)),
    ]) {
      for (final cor in [e.primary, e.success, e.surfaceMuted]) {
        final hex = '#${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
        expect(find.textContaining(hex), findsWidgets,
            reason: 'o papel $modo $hex não apareceu em Styles');
      }
    }
  });

  test('todo par abaixo de AA é exceção DECLARADA — e o gate mudou de lado duas vezes', () {
    // Este gate nasceu fixando os QUATRO pares que reprovavam, com o número, pra me obrigar a atualizar o
    // pedido em vez de deixar um número velho lá. Ele fez exatamente isso: subi o `ref` pra v0.22.0 e ele
    // reprovou dizendo "a medição de AA mudou".
    //
    // Agora ele guarda o conserto em vez do defeito, e as duas metades são o que mudou:
    //
    // 1. `primary × onPrimary` passou de 3,46 e 2,73 pra **6,06 e 7,70** — o pai derivou a TINTA em vez do
    //    preenchimento, então o rosa da marca continua sendo a superfície de ação;
    // 2. `success`/`warning`/`error` perderam o `tinta:` porque a medição dele mostrou ZERO consumidor pra
    //    `onSuccess`/`onWarning`/`onError` — eu tinha declarado um par que o DS não pinta.
    final papeis = Ds.estilos.papeis;
    final reprovam = <String, String>{};
    papeis.forEach((nome, papel) {
      if (papel.tinta == null) return;
      final tinta = papeis[papel.tinta]!;
      for (final (modo, fundo, cor) in [
        ('claro', papel.claro, tinta.claro),
        ('escuro', papel.escuro, tinta.escuro),
      ]) {
        final razao = Contraste.razao(cor, fundo);
        if (razao < 4.5) reprovam['$nome ($modo)'] = razao.toStringAsFixed(2);
      }
    });

    // **O gate mudou de lado outra vez em 19/08, e agora ele guarda uma EXCEÇÃO em vez de um número.**
    //
    // O par do claro voltou a 3,46 — de propósito. O dono do produto viu o chip do pai com rótulo
    // escuro ao lado do CTA branco sobre o mesmo rosa e disse que é tudo branco; o pai respondeu com
    // `tintasAssumidas` na `v0.115.0`, e o branco passou a ser honrado no claro.
    //
    // Então "nenhum par reprova" deixou de ser verdade, e a pergunta certa não é mais essa. É esta:
    // **todo par abaixo de AA é uma exceção DECLARADA, com razão e número conferidos?** Um par que
    // reprova sem declaração continua sendo defeito; um par que reprova com declaração é dívida com
    // dono. A diferença é a coisa toda, e é a régua do próprio pai.
    final assumidos = {
      for (final t in BoldPalette.bold.tintasAssumidas)
        for (final modo in excecoesDeTintaAssumida(BoldPalette.bold)
            .where((e) => e.papel == t.papel)
            .expand((e) => e.honradaEm))
          '${familiaDoPapel(t.papel)} ($modo)'
    };
    expect(reprovam.keys.toSet(), assumidos,
        reason: 'par abaixo de AA que NÃO é exceção declarada: '
            '${reprovam.keys.toSet().difference(assumidos)} — ou é conserto, ou o `tinta:` declara '
            'um par que este DS não desenha. E exceção declarada que PASSA em AA: '
            '${assumidos.difference(reprovam.keys.toSet())} — declaração que não tem efeito é '
            'exceção fantasma');

    // E a declaração se sustenta pela auditoria do pai: papel que existe, papel que é tinta, e a
    // medida conferida contra o pior modo. Sem isto, a linha acima aceitaria qualquer número.
    expect(violacoesDaTintaAssumida(BoldPalette.bold), isEmpty);

    // O PAR QUE IMPORTA, com o número: o rótulo do botão primário nos dois modos.
    final primary = papeis['primary']!;
    final onPrimary = papeis[primary.tinta]!;
    expect(Contraste.razao(onPrimary.claro, primary.claro), closeTo(3.46, 0.01),
        reason: 'o claro é o branco assumido — 3,46, declarado e auditado');
    expect(Contraste.razao(onPrimary.escuro, primary.escuro), greaterThan(7.0),
        reason: 'no escuro o pai clareia a marca pro 05 e o branco daria 2,73, abaixo do teto de '
            '3:1 — lá a derivação segue mandando, e é isso que o teto existe pra garantir');

    // E o rosa da marca CONTINUA sendo a superfície de ação — era o meu critério de pronto no pedido.
    expect(primary.claro.toARGB32(), BoldPalette.bold.primary04.toARGB32(),
        reason: 'o conserto mexeu no preenchimento; ele era pra ser só na tinta');
  });

  testWidgets('e a tinta ÓRFÃ acusa — o conserto do pai, medido daqui', (t) async {
    // O anexo do meu pedido: `tinta:` apontando pra papel inexistente virava `null`, e `null` quer dizer
    // "sem medição". Passei dez minutos com três faixas sem contraste e nada falhando. Entrou na v0.56.0.
    //
    // Este gate mede as DUAS direções, porque só uma delas passa com o defeito de pé:
    //
    //   1. a minha declaração de hoje NÃO acusa — nenhum `tinta:` meu está órfão;
    //   2. uma declaração com tinta órfã ACUSA — senão o item 1 é "nada apareceu", que é o que ele diria
    //      também se a acusação não existisse.
    t.view.physicalSize = const Size(1400, 12000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    const frase = 'não é um papel declarado';

    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: BoldFonts.familyRaw),
      home: Scaffold(body: Builder(
        builder: (ctx) =>
            configDoCatalogoDoBold().abas.firstWhere((a) => a.id == 'styles').constroi(ctx),
      )),
    ));
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();
    expect(find.textContaining(frase), findsNothing,
        reason: 'algum `tinta:` deste plugue aponta pra papel que eu não declarei');

    // O CONTROLE: a mesma página com um papel de tinta órfã declarado de propósito.
    final comOrfa = InventarioDeEstilo(
      papeis: {
        'primary': PapelNosDoisModos(
          BoldPalette.bold.primary04,
          BoldPalette.bold.primary04,
          tinta: 'onPrimaryQueNaoExiste',
        ),
      },
    );
    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: BoldFonts.familyRaw),
      home: Scaffold(
        body: SingleChildScrollView(child: Column(children: SecoesDeEstilo.de(comOrfa))),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();
    expect(find.textContaining(frase), findsWidgets,
        reason: 'tinta órfã não acusou — o conserto da v0.56.0 não está de pé');
  });

  testWidgets('o relatório de adoção do PAI aparece inteiro', (t) async {
    // Ele é a parte que não é decorativa: diz quais famílias de token este filho DECLAROU e quais
    // está herdando. Herdado sem conferir é como a estética do pai escorrega pro produto.
    t.view.physicalSize = const Size(1400, 8000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    await t.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) => configDoCatalogoDoBold()
              .abas
              .firstWhere((a) => a.id == 'conformidade')
              .constroi(ctx),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();

    final itens = relatorioDeAdocao(BoldPalette.bold);
    expect(itens, isNotEmpty);
    for (final i in itens) {
      expect(
        find.textContaining(i.familia, findRichText: true),
        findsWidgets,
        reason: 'a família "${i.familia}" do relatório do pai não está na tela',
      );
    }
  });
}
