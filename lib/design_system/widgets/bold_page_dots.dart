import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';

/// Conta BOLD — PageDots (átomo). Indicador de página de um carrossel/onboarding:
/// uma linha de pontos onde o ativo vira uma pílula alongada no tom da marca e
/// os inativos ficam discretos. Theme-aware (sobre a imagem no dark, sobre
/// superfície clara no light). Presentational puro — quem controla a página é o
/// caller (PageController/índice).
///
/// **Composição** — só tokens ([BoldColors], [BoldRadius], [BoldSpace]).
///
/// ```dart
/// BoldPageDots(count: 4, activeIndex: _page);
/// ```
class BoldPageDots extends StatelessWidget {
  const BoldPageDots({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor,
    this.size = 8,
    this.spacing = BoldSpace.x2,
  });

  final int count;
  final int activeIndex;

  /// Cor do ponto ativo (default = marca). Os inativos derivam do tema.
  final Color? activeColor;

  /// Diâmetro do ponto inativo (o ativo mantém a altura e alonga a largura).
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final active = activeColor ?? BoldColors.primary04;
    // Inativo: discreto e adaptado ao fundo (branco translúcido no dark,
    // hairline neutra no light).
    final idle = c.isDark
        ? BoldColors.white.withValues(alpha: 0.30)
        : BoldColors.neutral07;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final selected = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: selected ? size * 2.75 : size,
          height: size,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: selected ? active : idle,
            borderRadius: BoldRadius.pillR,
          ),
        );
      }),
    );
  }
}
