import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Conta BOLD — PromoCard (organismo). Card de atenção/promoção do carrossel da
/// home. Superfície **glass** (mesma spec única do [BoldGlass]), theme-aware:
///
/// - título Headline/small + subtítulo Body/small no ink de ALTO CONTRASTE do
///   tema ([BoldScheme.textPrimary] / [BoldScheme.textSecondary]), 4px entre eles;
/// - imagem/ilustração 100×100 ao lado dos textos (placeholder se [illustration]
///   for null);
/// - X (glyph textSecondary 16) a 10px do topo/direita;
/// - fill + stroke 1px + backdrop blur do vidro, radius 16, padding 16. SEM botões.
///
/// **Composição** — BoldGlass (superfície) + BoldIcon (átomo) + tokens.
///
/// ```dart
/// BoldPromoCard(
///   title: 'Habilite sua biometria',
///   subtitle: 'Com o pix você tem o melhor de dois mundos',
///   illustration: Image.asset('assets/promo.png'), // imagem 100×100
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

  /// Imagem/ilustração 100×100 à direita (placeholder se null).
  final Widget? illustration;

  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final r = BorderRadius.circular(16);
    final content = ClipRRect(
      borderRadius: r,
      clipBehavior: BoldGlass.clip,
      child: BackdropFilter(
        filter: BoldGlass.blurFilter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: BoldGlass.fill(c),
            borderRadius: r,
            border: Border.all(
                color: BoldGlass.border(c), width: BoldGlass.borderWidth),
          ),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(BoldSpace.x4),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: BoldType.headlineSm
                              .copyWith(color: c.textPrimary)),
                      if (subtitle != null) ...[
                        const SizedBox(height: BoldSpace.x1),
                        Text(subtitle!,
                            style: BoldType.bodySm
                                .copyWith(color: c.textSecondary)),
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
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: BoldIcon('close',
                            size: 16, color: c.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
    if (onTap == null) return content;
    return GestureDetector(
        onTap: onTap, behavior: HitTestBehavior.opaque, child: content);
  }
}

/// Placeholder 100×100 pra imagem ausente — moldura tonal do tema + ícone.
class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.isDark
            ? BoldColors.white.withValues(alpha: 0.08)
            : BoldColors.neutral10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Center(
        child: BoldIcon('image-light', size: 34, color: c.textMuted),
      ),
    );
  }
}
