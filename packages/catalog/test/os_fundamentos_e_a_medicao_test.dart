import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
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

  testWidgets('as SEÇÕES declaradas chegam na aba do pai', (t) async {
    // O que é meu nesta aba é a declaração. A prosa do pai vem do pacote dele, e as quatro deste produto
    // vêm do `kBoldFundamentos` — se alguma sumir do plugue, este gate cai.
    expect(Ds.fundamentos.keys, contains('A linguagem (do pai)'));
    for (final secao in kBoldFundamentos.keys) {
      expect(Ds.fundamentos.keys, contains(secao),
          reason: 'a seção "$secao" saiu do plugue');
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

  test('os PARES que reprovam em AA são exatamente os quatro medidos', () {
    // Este gate não protege o catálogo, protege a MEDIÇÃO: ele fixa os quatro pares que reprovam hoje,
    // com o número. Se um conserto do pai subir o `primary` de 3,46:1, este teste falha e me obriga a
    // atualizar o pedido — que é o oposto de um pedido que envelhece dizendo um número velho.
    //
    // Só o modo CLARO, que é onde o app vive e onde os quatro estão juntos.
    final papeis = Ds.estilos.papeis;
    final reprovam = <String, String>{};
    papeis.forEach((nome, papel) {
      if (papel.tinta == null) return;
      final tinta = papeis[papel.tinta]!;
      final razao = Contraste.razao(tinta.claro, papel.claro);
      if (razao < 4.5) reprovam[nome] = razao.toStringAsFixed(2);
    });

    expect(reprovam, {
      'primary': '3.46',
      'success': '4.04',
      'warning': '2.08',
      'error': '3.68',
    }, reason: 'a medição de AA mudou — atualize o pedido ao pai do DS com os números novos');

    // E a metade que PASSA, porque foi conserto meu de ontem: os pares `onXSubtle`.
    for (final nome in ['primarySubtle', 'successSubtle']) {
      final papel = papeis[nome]!;
      final razao = Contraste.razao(papeis[papel.tinta]!.claro, papel.claro);
      expect(razao, greaterThanOrEqualTo(4.5),
          reason: '$nome caiu abaixo de AA — era 7,13:1 e 5,19:1');
    }
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
