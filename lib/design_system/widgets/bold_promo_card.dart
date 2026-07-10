import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Conta BOLD — PromoCard (organismo). Card de atenção/promoção do carrossel da
/// home (spec Redesenho v.01 — "Habilite sua biometria"). Mesma estrutura do
/// [BoldPromoBanner], porém:
///
/// - título Headline/small branco + subtítulo Body/small branco, 4px entre eles;
/// - ilustração 100×100 ao lado dos textos (placeholder se [illustration] null);
/// - X (tertiary, glyph branco 16) a 10px do topo/direita;
/// - fill gradiente [BoldColors.primary02] → [BoldColors.primary05] a 69°,
///   radius 16, padding 16. SEM botões.
///
/// **Composição** — BoldIcon (átomo) + tokens.
///
/// ```dart
/// BoldPromoCard(
///   title: 'Habilite sua biometria',
///   subtitle: 'Com o pix você tem o melhor de dois mundos',
///   onClose: fechar,
/// );
/// ```
class BoldPromoCard extends StatelessWidget {
  const BoldPromoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.illustration,
    this.onClose,
    this.onTap,
  });

  final String title;
  final String? subtitle;

  /// Ilustração 100×100 à direita (placeholder se null).
  final Widget? illustration;

  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          transform: GradientRotation((69 - 90) * math.pi / 180),
          colors: [BoldColors.primary02, BoldColors.primary05],
        ),
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(BoldSpace.x4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: BoldType.headlineSm
                          .copyWith(color: BoldColors.white)),
                  if (subtitle != null) ...[
                    const SizedBox(height: BoldSpace.x1),
                    Text(subtitle!,
                        style:
                            BoldType.bodySm.copyWith(color: BoldColors.white)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: BoldSpace.x3),
            SizedBox(
              width: 100,
              height: 100,
              child: illustration ?? const _IllustrationPlaceholder(),
            ),
          ]),
        ),
        if (onClose != null)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child:
                        BoldIcon('close', size: 16, color: BoldColors.white),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
    if (onTap == null) return content;
    return GestureDetector(
        onTap: onTap, behavior: HitTestBehavior.opaque, child: content);
  }
}

/// Placeholder 100×100 pra ilustração ausente.
class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BoldColors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: BoldIcon('image-light', size: 34, color: BoldColors.white),
      ),
    );
  }
}
