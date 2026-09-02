import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAbsoluteColors;
import 'package:flutter/widgets.dart';

import 'bold_scheme.dart' show CoreflowScheme;

/// **O ESCOLHIDO quando o conteúdo É a superfície** — o outro jeito, e o último.
///
/// `CoreflowCartao(selecionado:)` diz escolhido tingindo o miolo, e é a resposta da casa. Ela não
/// serve quando o miolo é **o que a pessoa está escolhendo**: um retrato de fundo, uma foto de
/// avatar. Tingir ali é pintar por cima da escolha.
///
/// Então aqui a escolha é um ANEL, e ele tem três coisas que não são enfeite:
///
/// - **2,5 de espessura.** É o dobro largo do fio de cartão porque ele compete com uma imagem
///   embaixo, e não com uma cor chapada;
/// - **transparente quando não escolhido**, e não ausente — sem isso a peça pula 5 pixels ao ser
///   escolhida, e a fileira inteira se reorganiza a cada toque;
/// - **por cima** (`foregroundDecoration`), seguindo o mesmo raio do recorte. Borda e
///   `clipBehavior` no mesmo `Container` deixam o canto quadrado.
///
/// Nasceu de contar: em 02/09 a varredura dos jeitos de dizer *"escolhido"* achou seis, e este anel
/// era dois deles — um no `CoreflowAmostraDeFundo` deste pacote e um no seletor de avatar do Letti,
/// desenhado na tela. A mesma forma, escrita duas vezes, com um `Colors.transparent` de um lado e o
/// token do outro.
class CoreflowAnelDeEscolha extends StatelessWidget {
  const CoreflowAnelDeEscolha({
    super.key,
    required this.escolhido,
    required this.raio,
    required this.child,
    this.transicao,
  });

  final bool escolhido;
  final double raio;
  final Widget child;

  /// Quando a escolha MUDA debaixo do dedo. `null` não anima, que é o caso de uma lista onde a
  /// escolha chega pronta.
  final Duration? transicao;

  static const double espessura = 2.5;

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    final forma = BorderRadius.circular(raio);
    final anel = BoxDecoration(
      borderRadius: forma,
      border: Border.all(
        color: escolhido ? c.primary : DilettaAbsoluteColors.transparent,
        width: espessura,
      ),
    );
    if (transicao == null) {
      return Container(
        foregroundDecoration: anel,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: forma),
        child: child,
      );
    }
    return AnimatedContainer(
      duration: transicao!,
      foregroundDecoration: anel,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: forma),
      child: child,
    );
  }
}
