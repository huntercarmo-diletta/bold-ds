import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'o_neto.dart';

/// **BOTÃO SEM AÇÃO É DESABILITADO — também fora do `CoreflowRodape`.**
///
/// O conserto de 25/09 (`o_rodape_sem_acao_e_desabilitado_test`) ficou no
/// `CoreflowRodape`. O `CoreflowBotao` — e com ele o `CoreflowAcaoDeRodape`,
/// que passa `onPressed: null` quando `enabled: false` — continuava sem dizer
/// `disabled` ao pai, e o pai só pinta desligado quando ouve isso. Medido no
/// app em 21/10, num S8: "Enviar 0 pagamentos para aprovação" em rosa cheio,
/// sem responder ao toque.
void main() {
  Future<DilettaButton> botao(WidgetTester t, Widget filho) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: Neto.escuro,
        child: Scaffold(body: Center(child: filho)),
      ),
    ));
    await t.pump(const Duration(milliseconds: 50));
    return t.widget<DilettaButton>(find.byType(DilettaButton).first);
  }

  testWidgets('sem onPressed, o botão nasce desabilitado', (t) async {
    final b = await botao(t, const CoreflowBotao('Enviar'));
    expect(b.disabled, isTrue,
        reason: 'botão com a tinta inteira que não faz nada é porta pintada');
  });

  testWidgets('com onPressed, continua habilitado', (t) async {
    final b = await botao(t, CoreflowBotao('Enviar', onPressed: () {}));
    expect(b.disabled, isFalse);
  });

  testWidgets('com onPressedAsync, continua habilitado', (t) async {
    final b =
        await botao(t, CoreflowBotao('Enviar', onPressedAsync: () async {}));
    expect(b.disabled, isFalse);
  });

  testWidgets('carregando NÃO é desabilitado — ocupado é outra coisa',
      (t) async {
    final b = await botao(t, const CoreflowBotao('Enviar', loading: true));
    expect(b.isLoading, isTrue);
    expect(b.disabled, isFalse,
        reason: 'quem desenha a espera é a rodela, não o estado apagado');
  });

  testWidgets('CoreflowAcaoDeRodape(enabled: false) chega desabilitado',
      (t) async {
    final b = await botao(
        t, CoreflowAcaoDeRodape(label: 'Enviar', enabled: false, onTap: () {}));
    expect(b.disabled, isTrue);
  });

  testWidgets('CoreflowAcaoDeRodape habilitado continua habilitado',
      (t) async {
    final b =
        await botao(t, CoreflowAcaoDeRodape(label: 'Enviar', onTap: () {}));
    expect(b.disabled, isFalse);
  });
}
