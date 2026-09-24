import 'package:coreflow/coreflow.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O recuo lateral do rodapé é o GUTTER da grade — e é UM só.
///
/// Até 23/09 o envelope livre (`CoreflowRodape.child`) recuava com `s5` (20)
/// enquanto `CoreflowEspaco.gutter` e o rodapé do pai (`DilettaBottomApp`,
/// todas as variantes) valem `s6` (24). Medido na revisão do Pix: o card do
/// aviso começava em x=20 e o valor logo acima em x=24 — o rodapé desalinhava
/// 4 pt do corpo em toda tela que usa os dois. Este gate cobra que o número
/// venha da constante, e não de um degrau escolhido à parte.
void main() {
  test('o envelope livre recua pelo gutter da grade, nos dois lados', () {
    const rodape = CoreflowRodape.child(child: SizedBox.shrink());
    final p = rodape.padding.resolve(TextDirection.ltr);
    expect(p.left, CoreflowEspaco.gutter,
        reason: 'esquerda do rodapé fora do gutter do corpo');
    expect(p.right, CoreflowEspaco.gutter,
        reason: 'direita do rodapé fora do gutter do corpo');
  });

  test('e o gutter da grade continua sendo o do chrome da linguagem (24)', () {
    // `coreflow_espaco.dart` explica por quê: o 24 ganhou porque é o gutter do
    // CHROME — barra de topo, rodapé, nav. Mudar este número é decisão de
    // grade, e ela se toma lá, não aqui.
    expect(CoreflowEspaco.gutter, 24.0);
  });
}
