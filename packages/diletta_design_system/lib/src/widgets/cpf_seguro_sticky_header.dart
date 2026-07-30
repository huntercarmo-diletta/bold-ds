import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';

/// CPF SEGURO — StickyHeader (primitivo de LAYOUT, Bloco B).
///
/// Cabeçalho que ROLA JUNTO com o content e GRUDA no topo disponível ao
/// alcançá-lo (padrão: cabeçalho de seção). Diferente de camada FIXA (top/bottom
/// do [DilettaSurface]), que fica sempre pinada com o content passando por
/// trás — o sticky só gruda depois que a rolagem o alcança.
///
/// É um SLIVER: use dentro de um `CustomScrollView`. O codegen do content monta
/// esse `CustomScrollView` automaticamente quando algum bloco é marcado sticky
/// (os demais viram `SliverToBoxAdapter`).
///
/// Fundo opaco por padrão pra o conteúdo não vazar atrás quando grudado.
class DilettaStickyHeader extends StatelessWidget {
  const DilettaStickyHeader({
    super.key,
    required this.child,
    this.background = DilettaAbsoluteColors.white,
  });

  final Widget child;

  /// Cor de fundo enquanto grudado (evita ver o content por trás).
  final Color background;

  @override
  Widget build(BuildContext context) {
    return PinnedHeaderSliver(
      child: ColoredBox(color: background, child: child),
    );
  }
}
