import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_catalog/styles_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// FUNDAMENTOS é do MOTOR desde a v0.43.0 (prosa que ensina), e o que era meu virou o PAINEL DE MEDIÇÃO
/// na aba de conformidade. Este teste seguiu as duas coisas:
///
/// - a aba de Fundamentos é do pai, e o que eu meço nela é a DECLARAÇÃO: as seções que o plugue entrega
///   (a linguagem dele mais as quatro deste produto);
/// - a de Styles é COMPOSTA desde a v0.48.0 (`SecoesDeEstilo.de()`): as famílias do motor mais a minha
///   seção de papel semântico, que estava escondida na aba de conformidade;
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

  testWidgets('STYLES é COMPOSTA: a minha família e as do motor na MESMA página', (t) async {
    // A v0.48.0 trouxe `SecoesDeEstilo.de()`, e com ela o papel semântico nos dois modos saiu da aba de
    // conformidade e voltou pra onde se procura valor de token.
    //
    // Este gate mede as DUAS metades juntas, porque cada uma sozinha passa com o defeito de pé: só a
    // minha seção passaria com a composição quebrada (as famílias do motor sumindo), e só as do motor
    // passariam com o meu jeito antigo (`AbaDeStyles` puro, e o papel escondido noutra aba).
    t.view.physicalSize = const Size(1400, 8000);
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

    // A METADE DO MOTOR: cada família declarada no inventário tem seu cabeçalho na página.
    final inv = Ds.estilos;
    final familias = {
      if (inv.cores.isNotEmpty) 'COR',
      if (inv.tipos.isNotEmpty) 'TIPOGRAFIA',
      if (inv.raios.isNotEmpty) 'FORMA',
      if (inv.sombras.isNotEmpty) 'SOMBRA',
      if (inv.gradientes.isNotEmpty) 'DEGRADÊ',
      if (inv.movimentos.isNotEmpty) 'MOVIMENTO',
    };
    expect(familias, isNotEmpty, reason: 'o inventário deste filho está vazio — o gate mediria nada');
    for (final f in familias) {
      expect(find.text(f), findsWidgets, reason: 'a família "$f" do motor não está na página composta');
    }

    // A MINHA METADE: o hex DERIVADO da paleta, nos dois modos. O jeito de esta seção mentir é mostrar
    // um hex que não é o do token, então o teste procura o valor derivado e não um texto que eu digitei.
    //
    // `textContaining` e não `text`: a faixa escreve `claro · #FE3976` — o modo junto do valor, porque
    // papel sem o modo é meia informação.
    final claro = DilettaScheme.light(BoldPalette.bold);
    final escuro = DilettaScheme.dark(BoldPalette.bold);
    for (final (modo, s) in [('claro', claro), ('escuro', escuro)]) {
      for (final cor in [s.primary, s.success, s.surfaceMuted]) {
        final hex = '#${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
        expect(find.textContaining('$modo · $hex'), findsWidgets,
            reason: 'o papel $modo $hex não apareceu em Styles');
      }
    }
  });

  testWidgets('e o papel NÃO ficou duplicado na aba de conformidade', (t) async {
    // Mover é tirar de um lugar E pôr no outro. Sem esta metade, "está em Styles" passa com a página
    // antiga intacta, e o catálogo fica com duas verdades sobre a mesma coisa — que é a classe de
    // defeito que a limpa persegue, um nível acima do doc.
    t.view.physicalSize = const Size(1400, 8000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    await t.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) =>
              configDoCatalogoDoBold().abas.firstWhere((a) => a.id == 'conformidade').constroi(ctx),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();

    expect(find.byType(SecaoDePapeis), findsNothing,
        reason: 'a seção de papéis voltou pra conformidade — ela mora em Styles');
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
