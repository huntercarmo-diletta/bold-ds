import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// OS TRÊS CONTAINERS QUE PASSARAM A COMPOR — e antes recebiam o filho como dado de runtime.
///
/// `folha`, `dialogo` e `expansivel` emitiam `child: conteudoDaFolha`, `actions: acoesDoDialogo` e
/// `children: conteudoDoExpansivel`: campos que a tela gerada tem que fornecer. Dava pra integrar e **não
/// dava pra montar** — no compositor ninguém conseguia pôr blocos dentro deles, e era essa a causa da
/// gramática rasa que eu reportei ao pai (54 de 56 blocos "sem pai").
///
/// O gate mede as DUAS pontas de cada um, porque uma sozinha passa com a outra quebrada: o **preview**
/// (`slotsBuild`) e o **código** (`slotsCodegen`). Um container que desenha o filho e emite `const []`
/// parece certo na tela e entrega uma casca vazia pra quem colar o código.
void main() {
  /// O filho de teste é o `botao` — é o único bloco que os três aceitam (o `dialogo` só aceita ele).
  Block filho() => Block(id: 'f', type: 'botao', props: Ds.blocos['botao']!.defaults());

  Block container(String tipo, String slot) => Block(
        id: 'c',
        type: tipo,
        props: Ds.blocos[tipo]!.defaults(),
        slots: {slot: [filho()]},
      );

  for (final (tipo, slot, marca) in [
    ('folha', 'conteudo', 'ds.DilettaSheetOverlay'),
    ('dialogo', 'acoes', 'ds.DilettaDialog'),
    ('expansivel', 'conteudo', 'ds.DilettaExpansionTile'),
  ]) {
    test('$tipo EMITE o filho dentro de si, e não um campo de runtime', () {
      final codigo = codigoDoBloco(container(tipo, slot));

      expect(codigo, startsWith(marca));
      expect(codigo, contains('ds.DilettaButton'),
          reason: 'o filho do slot não entrou no código emitido');

      // E o campo de runtime SAIU: se ele voltar, o código volta a pedir um dado que o compositor não
      // consegue declarar, e o slot passa a ser enfeite.
      for (final campo in ['conteudoDaFolha', 'acoesDoDialogo', 'conteudoDoExpansivel']) {
        expect(codigo, isNot(contains(campo)),
            reason: 'voltou o campo de runtime `$campo` — o slot deixou de ser a fonte');
      }
    });

    testWidgets('$tipo DESENHA o filho do slot', (t) async {
      t.view.physicalSize = const Size(390, 900);
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);

      await t.pumpWidget(MaterialApp(
        theme: ThemeData(fontFamily: BoldFonts.familyRaw),
        home: Ds.tema(Scaffold(
          body: Stack(children: [unwrapBlockTag(buildBlock(container(tipo, slot)))]),
        )),
      ));
      await t.pump(const Duration(milliseconds: 200));
      t.takeException();

      expect(find.text('Continuar'), findsOneWidget,
          reason: 'o preview de $tipo não desenhou o filho do slot `$slot`');
    });
  }

  testWidgets('e o EXEMPLO só aparece com o slot vazio', (t) async {
    // Folha vazia é um retângulo cinza, e quem arrasta o bloco pela primeira vez não descobre o que ele é.
    // Mas exemplo que sobrevive ao filho é pior: a folha mostraria "Confirmar envio" mais o que a pessoa
    // acabou de pôr dentro, e ela concluiria que o bloco está com defeito.
    t.view.physicalSize = const Size(390, 900);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    Future<void> monta(Block b) async {
      await t.pumpWidget(MaterialApp(
        theme: ThemeData(fontFamily: BoldFonts.familyRaw),
        home: Ds.tema(Scaffold(body: Stack(children: [unwrapBlockTag(buildBlock(b))]))),
      ));
      await t.pump(const Duration(milliseconds: 200));
      t.takeException();
    }

    await monta(Block(id: 'v', type: 'folha', props: Ds.blocos['folha']!.defaults()));
    expect(find.text('Confirmar envio'), findsOneWidget, reason: 'a folha vazia perdeu o exemplo');

    await monta(container('folha', 'conteudo'));
    expect(find.text('Confirmar envio'), findsNothing,
        reason: 'o exemplo sobreviveu ao filho — a folha mostra os dois');
  });
}
