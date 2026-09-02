import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O PONTO É REDONDO E TEM O DIÂMETRO PEDIDO — as duas coisas que ele promete.
///
/// Parece pouco pra um teste, e é justamente por isso que ele existe: os quinze sítios que a peça
/// substitui eram `Container(width: 6, height: 6, decoration: BoxDecoration(shape: circle))` escrito
/// à mão, e a forma de errar isso é escrever `width` sem `height` — sai um oval, e ninguém vê num
/// sinal de 6 pixels.
void main() {
  testWidgets('o ponto é um círculo, e o diâmetro é o pedido', (t) async {
    await t.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(child: CoreflowPonto(cor: Color(0xFF00FF00), tamanho: 6)),
      ),
    ));
    expect(t.getSize(find.byType(CoreflowPonto)), const Size(6, 6));

    final caixa = t.widget<Container>(find.descendant(
        of: find.byType(CoreflowPonto), matching: find.byType(Container)));
    expect((caixa.decoration! as BoxDecoration).shape, BoxShape.circle);
  });

  testWidgets('o default é 8 — o valor mais comum dos seis medidos', (t) async {
    // A peça nasceu com uma escada de três degraus que eu declarei ANTES de contar. A contagem
    // veio 3 · 6 · 7 · 7 · 8 · 10, e a escada saiu: seis valores num produto só é ausência de
    // padrão, não linguagem sem degrau. O que ficou é o default, e ele é medido.
    await t.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: CoreflowPonto(cor: Color(0xFF00FF00)))),
    ));
    expect(t.getSize(find.byType(CoreflowPonto)), const Size(8, 8));
  });
}
