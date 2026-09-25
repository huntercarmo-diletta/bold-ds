import 'package:coreflow/coreflow.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'o_neto.dart';

/// **BOTÃO DE RODAPÉ SEM AÇÃO É DESABILITADO.**
///
/// Até 25/09 não era: `disabled` só olhava a trava do irmão em voo, e a tela
/// que apaga o CTA passando `onPressed: null` — a forma mais comum de dizer
/// "ainda não dá" — ficava com a tinta inteira e o alvo inteiro, sem fazer
/// nada. Medido no primeiro filho: 27 ações de rodapé em 17 telas passam null
/// condicional.
void main() {
  Future<DilettaButton> botao(WidgetTester t, CoreflowRodape rodape) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: Neto.escuro,
        child: Scaffold(bottomNavigationBar: rodape),
      ),
    ));
    await t.pump(const Duration(milliseconds: 50));
    return t.widget<DilettaButton>(find.byType(DilettaButton).first);
  }

  testWidgets('sem onPressed, o botão nasce desabilitado', (t) async {
    final b = await botao(
        t,
        const CoreflowRodape.button(
            primary: CoreflowAcaoDeNavegacao(label: 'Continuar')));
    expect(b.disabled, isTrue,
        reason: 'botão com a tinta inteira que não faz nada é porta pintada');
  });

  testWidgets('com onPressed, continua habilitado', (t) async {
    final b = await botao(
        t,
        CoreflowRodape.button(
            primary: CoreflowAcaoDeNavegacao(
                label: 'Continuar', onPressed: () {})));
    expect(b.disabled, isFalse);
  });

  testWidgets('carregando NÃO é desabilitado — ocupado é outra coisa',
      (t) async {
    final b = await botao(
        t,
        const CoreflowRodape.button(
            primary:
                CoreflowAcaoDeNavegacao(label: 'Continuar', loading: true)));
    expect(b.isLoading, isTrue);
    expect(b.disabled, isFalse,
        reason: 'quem desenha a espera é a rodela, não o estado apagado');
  });
}
