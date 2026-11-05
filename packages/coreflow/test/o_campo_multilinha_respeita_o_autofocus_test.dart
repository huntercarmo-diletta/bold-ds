import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'o_neto.dart';

/// **O CAMPO MULTILINHA RESPEITA O `autofocus` QUE A TELA DECLAROU.**
///
/// Medido no app em 05/11, na folha «Colar código» do leitor de pagamentos:
/// `CoreflowCampoDeTexto(autofocus: true, maxLines: 4)` abria sem foco e sem teclado. O `build`
/// passava `autofocus && !_multiline` ao pai, com um comentário dizendo que o pai só aceitava a
/// prop na variante de uma linha e que um `_FocoNaAbertura` resolvia o resto por aqui. O
/// `_FocoNaAbertura` nunca foi escrito, e o pai cedeu: o `DilettaInput` repassa `autofocus` nas
/// duas variantes (o caso que o fez ceder é a linha digitável do boleto, 47 dígitos em
/// `maxLines: 2`). A prop era ignorada em silêncio.
///
/// Os dois lados de cada forma de pedir multilinha (`maxLines` e `minLines`), e a linha única
/// como controle: quem decide abrir o teclado é a tela, não o número de linhas.
void main() {
  Future<void> monta(
    WidgetTester t, {
    required bool autofocus,
    int maxLines = 1,
    int? minLines,
  }) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: Neto.claro,
        child: Scaffold(
          body: Center(
            child: CoreflowCampoDeTexto(
              label: 'Código',
              autofocus: autofocus,
              maxLines: maxLines,
              minLines: minLines,
            ),
          ),
        ),
      ),
    ));
    await t.pump();
  }

  bool temFoco(WidgetTester t) =>
      t.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus;

  final formas = <String, ({int maxLines, int? minLines})>{
    'uma linha': (maxLines: 1, minLines: null),
    'maxLines: 4': (maxLines: 4, minLines: null),
    'minLines: 3': (maxLines: 6, minLines: 3),
  };

  for (final MapEntry(key: nome, value: forma) in formas.entries) {
    testWidgets('$nome, autofocus: true → abre com foco e teclado', (t) async {
      await monta(t, autofocus: true, maxLines: forma.maxLines, minLines: forma.minLines);
      expect(temFoco(t), isTrue, reason: 'a tela pediu o foco e o campo ignorou');
      expect(t.testTextInput.isVisible, isTrue, reason: 'com o foco vem o teclado');
    });

    testWidgets('$nome, autofocus: false → abre sem foco', (t) async {
      await monta(t, autofocus: false, maxLines: forma.maxLines, minLines: forma.minLines);
      expect(temFoco(t), isFalse);
      expect(t.testTextInput.isVisible, isFalse);
    });
  }
}
