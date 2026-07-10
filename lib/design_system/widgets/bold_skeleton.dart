import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';

/// Conta BOLD — Skeleton (átomo). Placeholder de carregamento com shimmer —
/// uma caixa arredondada translúcida com uma banda de brilho que desliza.
/// Sobre o fundo escurecido do app, usa branco em alpha baixo.
///
/// Trocar o conteúdo real por [BoldSkeleton] de mesmo tamanho enquanto o dado
/// carrega evita o "pop-in" (o item surgir do nada depois).
///
/// ```dart
/// BoldSkeleton(width: 190, height: 34, radius: 10);   // linha do valor
/// BoldSkeleton(width: 84, height: 20, radius: 200);   // pill
/// BoldSkeleton.circle(40);                            // avatar
/// ```
class BoldSkeleton extends StatefulWidget {
  const BoldSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  /// Círculo (avatar/spot) de diâmetro [size].
  factory BoldSkeleton.circle(double size, {Key? key}) =>
      BoldSkeleton(key: key, width: size, height: size, radius: size / 2);

  final double? width;
  final double height;
  final double radius;

  @override
  State<BoldSkeleton> createState() => _BoldSkeletonState();
}

class _BoldSkeletonState extends State<BoldSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(widget.radius);
    return ClipRRect(
      borderRadius: br,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          // Banda de brilho desliza de -1 a 1 na largura.
          final dx = _ctrl.value * 2 - 1;
          return DecoratedBox(
            // Base translúcida clara + banda de brilho bem mais forte,
            // deslizando — shimmer visível sobre o fundo escuro.
            decoration: BoxDecoration(
              color: BoldColors.white.withValues(alpha: 0.18),
            ),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                // Banda de brilho no PRIMARY claro (primary-07) — combina com a
                // marca; base branca translúcida guia o resto.
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    BoldColors.primary07.withValues(alpha: 0.0),
                    BoldColors.primary07.withValues(alpha: 0.72),
                    BoldColors.primary07.withValues(alpha: 0.0),
                  ],
                  stops: const [0.25, 0.5, 0.75],
                  transform: _SlideTransform(dx),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Translada o gradiente horizontalmente (banda deslizante do shimmer).
class _SlideTransform extends GradientTransform {
  const _SlideTransform(this.dx);
  final double dx;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * dx, 0, 0);
}
