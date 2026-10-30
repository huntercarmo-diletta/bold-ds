import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'o_neto.dart';

/// **O CAMPO DIZ O QUE É AO PREENCHIMENTO AUTOMÁTICO.**
///
/// Pedido de 26/10 ao avô: 12 campos de senha no app, em 9 arquivos, e nenhuma
/// dica. O `DilettaInput` ganhou `autofillHints` na `v3.26.0`, e o veredito pediu
/// o repasse aqui. A medida é no `TextField` de dentro: é ele que o sistema lê
/// para oferecer a senha salva ou sugerir uma nova.
void main() {
  Future<TextField> campo(WidgetTester t, Widget filho) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: Neto.escuro,
        child: Scaffold(body: Center(child: filho)),
      ),
    ));
    await t.pump(const Duration(milliseconds: 50));
    return t.widget<TextField>(find.byType(TextField).first);
  }

  testWidgets('sem dica, o campo não se declara — como hoje', (t) async {
    final c = await campo(t, const CoreflowCampoDeTexto(label: 'Apelido'));
    expect(c.autofillHints, isEmpty,
        reason: 'dica errada é pior que nenhuma: o sistema oferece a senha no campo de apelido');
  });

  testWidgets('a senha do login chega ao campo nativo', (t) async {
    final c = await campo(
        t,
        const CoreflowCampoDeTexto(
          label: 'Senha',
          obscureText: true,
          autofillHints: [AutofillHints.password],
        ));
    expect(c.autofillHints, [AutofillHints.password]);
  });

  testWidgets('a senha nova chega ao campo nativo', (t) async {
    final c = await campo(
        t,
        const CoreflowCampoDeTexto(
          label: 'Nova senha',
          obscureText: true,
          autofillHints: [AutofillHints.newPassword],
        ));
    expect(c.autofillHints, [AutofillHints.newPassword]);
  });

  testWidgets('o campo de uma linha também repassa', (t) async {
    final c = await campo(
        t,
        const CoreflowCampoDeTexto(
          label: 'CPF',
          autofillHints: [AutofillHints.username],
        ));
    expect(c.autofillHints, [AutofillHints.username]);
  });
}
