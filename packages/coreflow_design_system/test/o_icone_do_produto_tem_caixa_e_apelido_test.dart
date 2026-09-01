import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O ÍCONE DESTE PRODUTO — o apelido traduz, e a caixa não estica.
///
/// As duas coisas que o `CoreflowIcone` acrescenta ao glifo do pai são exatamente as duas que
/// quebraram na vida real:
///
/// - **apelido que não traduz desenha NADA.** `DilettaIcon` com nome que o bundle não tem não
///   estoura e não avisa — foi assim que as setas de voltar sumiram do app um dia;
/// - **caixa apertada estica o glifo.** Dentro de um chip de 40 com constraint tight, um ícone de 18
///   virava 40 sem ninguém pedir.
void main() {
  test('o apelido traduz pro nome que o pai conhece', () {
    expect(CoreflowIcone.comoOPaiChama('home'), 'house-light');
    expect(CoreflowIcone.comoOPaiChama('eye-off'), 'eye-slash-light-full');
    // Nome cru passa reto: quem já fala o vocabulário do pai não precisa de apelido.
    expect(CoreflowIcone.comoOPaiChama('gear-solid'), 'gear-solid');
  });

  testWidgets('a caixa é a do `size`, mesmo dentro de um pai apertado', (t) async {
    await t.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DilettaThemeScope(
        theme: CoreflowTheme.dark,
        child: const Scaffold(
          body: Center(
            // O chip de 40 com constraint TIGHT — o caso que esticava.
            child: SizedBox(
              width: 40,
              height: 40,
              child: CoreflowIcone('home', size: 18),
            ),
          ),
        ),
      ),
    ));
    // O pai mede 40 e o glifo mede 18. Sem o `UnconstrainedBox` os dois medem 40.
    expect(t.getSize(find.byType(DilettaIcon)), const Size(18, 18));
  });
}
