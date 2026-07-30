import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ABA DE COMPONENTES DESENHA — o gate que faltava, e a razão dele é uma medição.
///
/// Existia um teste chamado `todo bloco desenha com os próprios defaults`, e ele passava com 29 blocos
/// enquanto a aba publicada mostrava **19 exceções de layout**. O motivo é o que a auditoria de
/// arquitetura chama de presença ≠ comportamento: aquele teste chamava `def.build(...)`, que só CONSTRÓI
/// o widget. Ninguém media o `pump` — ou seja, ninguém media o layout, que é onde componente quebra.
///
/// Os dois defeitos que ele achou eram do CARD, não dos componentes:
///
/// 1. **`campo` morria com "No Material widget found"** — o input do pai usa tinta (`InkWell`), e tinta
///    exige um `Material` acima. Numa tela de verdade quem fornece é o `Scaffold`; o card documenta
///    componente fora de tela, e não fornecia;
/// 2. **`visorDeCodigo` estourava com altura infinita** e chegava a pintar com `NaN`. Ele é bloco de
///    TELA CHEIA — quer o frame inteiro, por contrato — e o card o punha numa coluna de scroll, que é
///    altura sem limite. Quem sabe quais blocos são assim é o plugue (`tiposDeTelaCheia`).
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  testWidgets('TODO bloco sobrevive ao LAYOUT do card, não só ao build', (t) async {
    t.view.physicalSize = const Size(900, 2000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final quebrados = <String>[];
    for (final def in Ds.blocos.values) {
      final erros = <String>[];
      final anterior = FlutterError.onError;
      FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);

      // O MESMO contexto do card: coluna sem altura, dentro de scroll, com o tema do produto.
      // `Scaffold` porque é o que a CASCA DO PAI monta, e Material vem dele. Sem isto o teste
      // acusava "No Material widget found" e eu tratei como defeito do card — não era. Harness que
      // não espelha a casca mede um app que não existe.
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              Ds.tema(Builder(
                builder: (ctx) => ColoredBox(
                  color: DilettaTheme.schemeOf(ctx).bg,
                  child: Ds.atual.ehTelaCheia(def.type)
                      ? AspectRatio(aspectRatio: 9 / 16, child: def.build(def.defaults()))
                      : def.build(def.defaults()),
                ),
              )),
            ]),
          ),
        ),
      ));
      await t.pump(const Duration(milliseconds: 100));

      FlutterError.onError = anterior;
      t.takeException();
      if (erros.isNotEmpty) quebrados.add('${def.type}: ${erros.first}');
    }

    expect(quebrados, isEmpty, reason: quebrados.join(' | '));
  });

  testWidgets('a aba INTEIRA desenha sem uma exceção', (t) async {
    // O teste acima mede bloco por bloco; este mede a aba montada, que é o que a pessoa abre. Um
    // estouro aqui e não lá seria interação entre blocos — e é justamente o que ninguém prevê.
    t.view.physicalSize = const Size(1400, 6000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);

    // Por ID e não por POSIÇÃO. Este teste usava `abas.first` e passou a medir a aba errada no dia em
    // que Fundamentos entrou na frente — falhou acusando "o bloco barraDeStatus não aparece", que era
    // verdade e não era o defeito. `first` é lugar; `id` é contrato (ele está na URL).
    final aba = configDoCatalogoDoBold().abas.firstWhere((a) => a.id == 'componentes');
    await t.pumpWidget(MaterialApp(
      home: Scaffold(body: Builder(builder: (ctx) => aba.constroi(ctx))),
    ));
    await t.pump(const Duration(milliseconds: 300));

    FlutterError.onError = anterior;
    t.takeException();
    expect(erros, isEmpty, reason: '${erros.length} exceção(ões): ${erros.take(5).join(' | ')}');

    // E o outro lado: a aba mostra o vocabulário INTEIRO, não uma parte que caiba na tela.
    //
    // MAIÚSCULA porque o cabeçalho do motor (v0.36.0) desenha `nome.toUpperCase()` — a aba deixou de
    // escrever o próprio título, e o teste seguiu a casca em vez de fixar a minha formatação antiga.
    for (final def in Ds.blocos.values) {
      expect(find.text(def.label.toUpperCase()), findsWidgets,
          reason: 'o bloco "${def.type}" não aparece na aba de componentes');
    }
  });
}
