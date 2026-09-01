import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O ACERVO DO PAI, NO TAMANHO DESTE PRODUTO — e o caminho cru que sumiu com ele.
///
/// Acrescentado em 01/09. O `CoreflowIlustracao.doPai` existe porque o acessório do pai dimensiona
/// por degrau canônico (100/200/300/400) e este produto pede 88, 150 e 200.
///
/// O que ele fecha vale mais que a conversão: a casca do app que fazia isso tinha um **caminho de
/// asset cru** como último recurso, e dois fluxos de chave Pix passavam por ele pedindo um arquivo
/// que saiu do repo em 20/08. Com dois construtores de enum não sobra caminho pra passar.
void main() {
  testWidgets('a arte do pai sai no tamanho pedido, e não no degrau dele', (t) async {
    await t.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DilettaThemeScope(
        theme: CoreflowTheme.dark,
        child: const Scaffold(
          body: Center(
            child: CoreflowIlustracao.doPai(DilettaIllustration.timerWoman, tamanho: 88),
          ),
        ),
      ),
    ));
    // 88 é a ilustração do cartão promocional da home. O degrau mais próximo do pai é 100.
    expect(t.getSize(find.byType(CoreflowIlustracao)), const Size(88, 88));
  });
}
