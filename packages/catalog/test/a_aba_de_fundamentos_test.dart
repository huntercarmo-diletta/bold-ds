import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ABA DE FUNDAMENTOS — ela existe pra mostrar TOKEN, então o gate mede token, não pixel.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
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
      home: Builder(
        builder: (ctx) =>
            cfg.abas.firstWhere((a) => a.id == 'fundamentos').constroi(ctx),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    FlutterError.onError = anterior;
    t.takeException();
    expect(erros, isEmpty, reason: erros.take(3).join(' | '));
  });

  testWidgets('mostra o HEX da paleta, e ele bate com a paleta', (t) async {
    // O jeito de esta aba mentir é mostrar um hex que não é o do token. Então o teste procura o
    // valor DERIVADO da paleta, não um texto que eu digitei.
    t.view.physicalSize = const Size(1400, 8000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    await t.pumpWidget(MaterialApp(
      home: Builder(
        builder: (ctx) => configDoCatalogoDoBold()
            .abas
            .firstWhere((a) => a.id == 'fundamentos')
            .constroi(ctx),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();

    for (final cor in [BoldPalette.bold.primary04, BoldPalette.bold.success04]) {
      final hex = '#${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
      expect(find.text(hex), findsWidgets, reason: 'o hex $hex não apareceu');
    }
  });

  testWidgets('o relatório de adoção do PAI aparece inteiro', (t) async {
    // Ele é a parte que não é decorativa: diz quais famílias de token este filho DECLAROU e quais
    // está herdando. Herdado sem conferir é como a estética do pai escorrega pro produto.
    t.view.physicalSize = const Size(1400, 8000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    await t.pumpWidget(MaterialApp(
      home: Builder(
        builder: (ctx) => configDoCatalogoDoBold()
            .abas
            .firstWhere((a) => a.id == 'fundamentos')
            .constroi(ctx),
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
