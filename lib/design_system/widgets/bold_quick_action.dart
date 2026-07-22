import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_card.dart';
import 'bold_icon.dart';

/// Conta BOLD — a compact quick-action: a rounded frame holding an icon AND its
/// label (label lives INSIDE the frame). Set [highlighted] to make it the
/// primary action (pink tint + pink icon/label). Used in the balance card row
/// (Pix / Scanear / Pagar / Depositar) but reusable anywhere.
///
/// Wrap in [Expanded] inside a [Row] for equal widths.
class BoldQuickAction extends StatelessWidget {
  const BoldQuickAction({
    super.key,
    required this.icon,
    required this.label,
    this.highlighted = false,
    this.framed = true,
    this.onTap,
  });

  /// BoldIcon name (semantic or raw svg).
  final String icon;
  final String label;
  final bool highlighted;

  /// false → no surrounding frame, just icon + label (loose look).
  final bool framed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final fg = highlighted ? BoldColors.primary : c.textSecondary;
    final content = Column(mainAxisSize: MainAxisSize.min, children: [
      BoldIcon(icon, size: BoldIconSize.lg, color: fg),
      const SizedBox(height: 7),
      Text(label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: BoldType.bodySmall
              .copyWith(fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
    ]);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: framed
          ? Container(
              padding: const EdgeInsets.fromLTRB(4, 11, 4, 9),
              // No fill (matches the "no-fundo" cards) + a SOLID, uniform stroke
              // for every action (no gradient): pink for the highlighted one,
              // sober grey for the rest — same grey as the simple card.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: highlighted
                      ? BoldColors.primary
                      : BoldCardSurface.simpleStroke(c.isDark),
                  width: 1,
                ),
              ),
              child: content,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4), child: content),
    );
  }
}
