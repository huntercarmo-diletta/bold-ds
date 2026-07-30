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
/// - o painel de medição continua sendo meu, e o gate dele é o mesmo de antes — hex derivado da paleta e
///   o relatório de adoção inteiro.
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

  testWidgets('o painel mostra o HEX do PAPEL, e ele bate com a paleta', (t) async {
    // O jeito de este painel mentir é mostrar um hex que não é o do token. Então o teste procura o valor
    // DERIVADO da paleta, não um texto que eu digitei.
    //
    // `textContaining` e não `text`: a faixa escreve `claro · #FE3976` — o modo junto do valor, porque
    // papel sem o modo é meia informação.
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

    final claro = DilettaScheme.light(BoldPalette.bold);
    for (final cor in [claro.primary, claro.success, claro.surfaceMuted]) {
      final hex = '#${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
      expect(find.textContaining(hex), findsWidgets, reason: 'o hex $hex não apareceu');
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
