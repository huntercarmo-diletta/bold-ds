import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O SWEEP DOS 56 BLOCOS — o gate que ficou meu mesmo depois de a aba virar do pai.
///
/// A aba de componentes é do motor desde a v0.44.0. Este teste NÃO foi apagado com ela, e a razão é a
/// frase que o pai escreveu no veredito: **cobertura por varredura acha o que a navegação esconde.** A aba
/// dele mostra um componente por vez; este teste percorre os 56 no contexto do preview, e foi assim que a
/// folha (`Positioned` sem `Stack`) apareceu.
///
/// Ele mede o preview do PAI agora (`previaDeComponente`), não o meu card — então virou o gate que prova o
/// conserto dele contra os meus 56 blocos, que é o único lugar onde os dois lados existem juntos.
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
      // O PREVIEW DO PAI, e não mais o meu card: `previaDeComponente` envolve no gancho `tema` e dá
      // `AspectRatio` + `Stack` pro bloco de tela cheia — as duas coisas que o meu card fazia e que a
      // aba dele não fazia até a v0.44.0.
      //
      // `Scaffold` porque é o que a casca dele monta, e o Material vem de lá. Harness que não espelha a
      // casca mede um app que não existe — eu já "consertei" um defeito que não existia por isso.
      await t.pumpWidget(MaterialApp(theme: ThemeData(fontFamily: BoldFonts.familyRaw), 
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [previaDeComponente(def.type, props: def.defaults())]),
          ),
        ),
      ));
      await t.pump(const Duration(milliseconds: 100));

      FlutterError.onError = anterior;
      t.takeException();
      if (erros.isNotEmpty) quebrados.add('${def.type}: ${erros.first}');
    }

    // ZERO resíduo. Havia UM, e ele fechou na v0.46.1 do motor:
    //
    // `previaDeComponente` fazia `Stack(children: [previa])` com `previa` vindo de `buildBlock`, que
    // embrulha todo bloco num `MetaData` (a etiqueta do id) — então o `Positioned.fill` da folha não era
    // filho DIRETO do `Stack`, e `ParentDataWidget` exige isso. Eu isolei lado a lado (o mesmo
    // `AspectRatio` + `Stack` com `def.build` direto passava), o pai mediu que quem lê a etiqueta são os
    // dois hit-tests do canvas, e a prévia passou a jogá-la fora com `unwrapBlockTag`.
    //
    // A exceção pro `folha` SAIU junto com o conserto. Baseline que sobrevive ao conserto é a coisa que
    // o teste anti-fantasma existe pra cobrar, e aqui ela era uma linha de código.
    expect(quebrados, isEmpty, reason: quebrados.join(' | '));
  });

  testWidgets('TODO bloco sobrevive à largura de TELEFONE, e não só à de mesa', (t) async {
    // O SEGUNDO sweep, e ele nasceu de um vermelho que a v0.47.0 do motor acendeu.
    //
    // A unha do chip renderiza o componente numa caixa de ~312, e ali o `segmentos` vazou 68px. O sweep
    // de cima roda a 900 e passava: **a largura da mesa não exercita o requisito do produto**, que é um
    // app de telefone. Era a mesma classe de fixture fraca que os pais catalogaram sete vezes — o
    // harness não carregava a restrição do caso.
    //
    // 320 porque é o menor aparelho que o app suporta, e porque é a largura em que a unha do catálogo
    // mediu. Bloco de tela cheia continua em 9/16 pelo `previaDeComponente`, então ele também é medido
    // no aperto real e não numa caixa larga.
    t.view.physicalSize = const Size(320, 3000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final quebrados = <String>[];
    for (final def in Ds.blocos.values) {
      final erros = <String>[];
      final anterior = FlutterError.onError;
      FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
      await t.pumpWidget(MaterialApp(theme: ThemeData(fontFamily: BoldFonts.familyRaw), 
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [previaDeComponente(def.type, props: def.defaults())]),
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

  testWidgets('a aba do PAI desenha, e com a cor DESTE produto', (t) async {
    // O gate de identidade, agora apontando pra a aba dele — é esta medição que fecha o pedido do tema.
    // Antes da v0.44.0 ela desenhava com `#0E7C5F`, a paleta de REFERÊNCIA: nem o rosa do Bold, nem o
    // azul do primeiro filho. Uma terceira identidade, em silêncio.
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(MaterialApp(
        theme: ThemeData(fontFamily: BoldFonts.familyRaw),
        home: const Scaffold(body: AbaDeComponentes())));
    await t.pump(const Duration(milliseconds: 400));
    FlutterError.onError = anterior;
    t.takeException();
    expect(erros, isEmpty, reason: erros.take(3).join(' | '));

    // A IDENTIDADE se mede no preview ISOLADO, e não na seleção inicial da aba: o componente que abre
    // por padrão pode não ter rosa nenhum, e aí a asserção estaria medindo a ordem do índice em vez do
    // tema. Minha primeira versão deste gate falhou exatamente assim — e o defeito era meu, não do pai.
    await t.pumpWidget(MaterialApp(theme: ThemeData(fontFamily: BoldFonts.familyRaw), 
      home: Scaffold(
        body: previaDeComponente('botao', props: Ds.blocos['botao']!.defaults()),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    final cores = <int>{};
    for (final w in t.allWidgets) {
      for (final p in w.toDiagnosticsNode().getProperties()) {
        switch (p.value) {
          case Color c:
            cores.add(c.toARGB32());
          case TextStyle s when s.color != null:
            cores.add(s.color!.toARGB32());
          case BoxDecoration d when d.color != null:
            cores.add(d.color!.toARGB32());
        }
      }
    }
    expect(cores, contains(BoldPalette.bold.primary04.toARGB32()),
        reason: 'o preview do pai não está desenhando com a paleta do Bold');
    expect(cores, isNot(contains(0xFF0E7C5F)),
        reason: 'voltou a paleta de REFERÊNCIA — o preview saiu do gancho `tema`');
  });
}
