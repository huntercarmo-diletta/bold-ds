import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CARTÃO TRANSICIONA QUANDO MUDA — e só quando lhe pedem.
///
/// Três superfícies de escolha do app eram `AnimatedContainer` à mão: tipo de conta, ladrilho do
/// editor de menu, passo da selfie do KYC. As três animam a mesma coisa — fundo e borda mudando
/// quando a pessoa escolhe.
///
/// O gate mede os dois lados, porque cada um sozinho é um defeito diferente: sem transição a
/// superfície LÊ como redesenho e a pessoa perde o vínculo entre o toque e o que mudou; com
/// transição por padrão, os ~90 cartões que nunca mudam ganham um `AnimatedContainer` de graça.
void main() {
  Widget naTela(Widget filho) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(
          theme: CoreflowTheme.dark,
          child: Scaffold(body: Center(child: filho)),
        ),
      );

  testWidgets('sem `transicao` não há AnimatedContainer', (t) async {
    await t.pumpWidget(naTela(const CoreflowCartao(child: SizedBox(width: 60, height: 30))));
    expect(
        find.descendant(
            of: find.byType(CoreflowCartao), matching: find.byType(AnimatedContainer)),
        findsNothing);
  });

  testWidgets('com `transicao` a superfície anima, e a borda vai junto', (t) async {
    await t.pumpWidget(naTela(const CoreflowCartao(
      transicao: Duration(milliseconds: 200),
      borderColor: Color(0xFFFE3976),
      bordaReforcada: true,
      child: SizedBox(width: 60, height: 30),
    )));
    final a = t.widget<AnimatedContainer>(find.descendant(
        of: find.byType(CoreflowCartao), matching: find.byType(AnimatedContainer)));
    expect(a.duration, const Duration(milliseconds: 200));

    // A borda entra na decoração animada — sem isso, o fundo transiciona e o contorno pula, que é
    // pior que não animar nada.
    final d = t
        .widget<Container>(find.descendant(
            of: find.byType(AnimatedContainer), matching: find.byType(Container)))
        .decoration as BoxDecoration?;
    final borda = (d?.border as Border?)?.top;
    // 1,5: desde 02/09 o produto tem DUAS espessuras de fio e as duas moram no cartão. O que este
    // teste guarda é que a borda entra na decoração ANIMADA, não qual número ela tem.
    expect(borda?.width, 1.5);
    expect(borda?.color, const Color(0xFFFE3976));
  });
}
