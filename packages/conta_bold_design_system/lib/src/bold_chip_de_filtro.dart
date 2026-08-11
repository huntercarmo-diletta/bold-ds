/// CONTA BOLD — o CHIP DE FILTRO: casca de uma linha sobre a variante do pai.
///
/// Ele nasceu aqui em 11/08 porque a família de chips da linguagem não tinha o SELECIONÁVEL — o
/// `filled` do `DilettaInputChip` fica no mesmo tom nos dois estados, porque marca *um filtro
/// aplicado* numa fila de vários; este marca *A escolha* numa fila mutuamente exclusiva.
///
/// O pedido entrou no mesmo dia (`ds v0.67.0`), e o pai achou uma coisa que eu não tinha como ver:
/// **o desenho já tinha a variante há dois dias.** O `Input chips` do Figma declara
/// `State: … Selected` desde 09/08; o código não tinha, e o mapa que liga os dois não perguntava.
///
/// ## E ele me corrigiu num número, o que muda o que a coisa É
///
/// Eu citei **2.5.5** pros 44 do alvo de toque. **2.5.5 é AAA.** O mínimo AA é o **2.5.8** da WCAG
/// 2.2, que pede **24×24** — e a pílula do `filled` tem exatamente 24. Ou seja: o chip que já
/// existia **não falhava**; ele estava em cima do piso com margem zero, que nesta casa é a segunda
/// pergunta do crivo e não é reprovar. Foi por isso que ele não mexeu naquele.
///
/// A variante nova entrega 44 com a pílula em 26, e o respiro FORA do desenho.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// A pílula de filtro. O desenho é do pai; o que sobrou aqui é o nome do produto.
class BoldChipDeFiltro extends StatelessWidget {
  const BoldChipDeFiltro(
    this.rotulo, {
    super.key,
    required this.escolhido,
    required this.aoTocar,
  });

  final String rotulo;
  final bool escolhido;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) => DilettaInputChip.selecionavel(
        label: rotulo,
        selecionado: escolhido,
        onTap: aoTocar,
      );
}
