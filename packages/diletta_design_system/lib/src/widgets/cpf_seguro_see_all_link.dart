import 'package:flutter/widgets.dart';
import 'cpf_seguro_text_link.dart';

/// CPF SEGURO — SeeAllLink.
///
/// Link "Ver todos" — típico no `trailing` do [DilettaSectionHeader], mas
/// componente independente (usável em qualquer cabeçalho/linha). É o
/// [DilettaTextLink] com tone `cpf`: o estilo do link mora num só lugar.
class DilettaSeeAllLink extends StatelessWidget {
  const DilettaSeeAllLink({super.key, this.onPressed, this.label = 'Ver todos'});
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DilettaTextLink(label: label, onPressed: onPressed);
  }
}
