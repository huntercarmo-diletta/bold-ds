import 'package:flutter/widgets.dart';
import 'cpf_seguro_wallet_card.dart';

/// CPF SEGURO — WalletCardStack.
///
/// Pilha de cartões da Carteira home — cartão do parceiro atrás com só o
/// topo aparecendo ([peek] px), cartão CPF SEGURO na frente. Figma 1152:21383.
class DilettaWalletCardStack extends StatelessWidget {
  const DilettaWalletCardStack({
    super.key,
    required this.back,
    required this.front,
    this.peek = 50,
  });

  final Widget back;
  final Widget front;

  /// Quanto do cartão de trás fica visível acima do da frente.
  final double peek;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DilettaWalletCard.height + peek,
      child: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: back),
          Positioned(top: peek, left: 0, right: 0, child: front),
        ],
      ),
    );
  }
}
