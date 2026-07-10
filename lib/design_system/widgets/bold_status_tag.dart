import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Tom semântico da [BoldStatusTag].
enum BoldStatusTone { warning, neutral, primary, success, danger }

/// Data holder pra passar uma tag como prop (ex.: acessório de lista).
class BoldStatusTagData {
  const BoldStatusTagData({required this.label, required this.tone, this.icon});
  final String label;
  final BoldStatusTone tone;
  final String? icon;
}

/// Conta BOLD — StatusTag (molécula). Spec Redesenho v.01 (Figma):
///
/// - pill **h20 · radius 200 · padding start 4 / end 8**;
/// - fill = gradiente linear `branco@37–42% → wash do tom` (o pill fica
///   levemente translúcido no topo e sólido no wash embaixo);
/// - stroke **0.5px inside** no tom · texto/ícone no tom (11/med/ls.5);
/// - ícone opcional 8px.
///
/// Success/danger vêm 1:1 do Figma; os demais tons replicam a receita.
///
/// **Composição** — BoldIcon (átomo) + tokens (escalas semânticas).
///
/// ```dart
/// BoldStatusTag(label: 'R$ 300,00', icon: 'arrow-trend-up-light',
///     tone: BoldStatusTone.success);
/// ```
class BoldStatusTag extends StatelessWidget {
  const BoldStatusTag({
    super.key,
    required this.label,
    this.tone = BoldStatusTone.neutral,
    this.icon,
  });

  final String label;
  final BoldStatusTone tone;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final t = _toneSpec(tone, BoldColors.of(context).isDark);
    return Container(
      height: 20,
      padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.fill,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(
          color: t.stroke,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            BoldIcon(icon!, size: 8, color: t.fg),
            const SizedBox(width: 4),
          ],
          Text(label,
              maxLines: 1,
              softWrap: false,
              style: BoldType.bodySmall.copyWith(
                  fontSize: 11,
                  height: 16 / 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: t.fg)),
        ],
      ),
    );
  }
}

class _ToneSpec {
  const _ToneSpec({required this.fg, required this.fill, required this.stroke});

  /// Texto + ícone.
  final Color fg;

  /// Fill do pill.
  final Color fill;

  /// Stroke (0.5px inside).
  final Color stroke;
}

// Success/danger: vidro branco theme-aware (cor só no texto/ícone). Dark → fill
// branco 15% / stroke 25% / fg 05; light → fill 40% / stroke 74% / fg 04.
// Warning/neutral/primary mantêm o wash sólido do tom.
_ToneSpec _toneSpec(BoldStatusTone t, bool isDark) {
  Color glassFill() =>
      BoldColors.white.withValues(alpha: isDark ? 0.15 : 0.40);
  Color glassStroke() =>
      BoldColors.white.withValues(alpha: isDark ? 0.25 : 0.74);

  return switch (t) {
    BoldStatusTone.success => _ToneSpec(
        fg: isDark ? BoldColors.success05 : BoldColors.success04,
        fill: glassFill(),
        stroke: glassStroke()),
    BoldStatusTone.danger => _ToneSpec(
        fg: isDark ? BoldColors.error05 : BoldColors.error04,
        fill: glassFill(),
        stroke: glassStroke()),
    BoldStatusTone.warning => const _ToneSpec(
        fg: BoldColors.warning03,
        fill: BoldColors.warning07,
        stroke: BoldColors.warning03),
    BoldStatusTone.primary => const _ToneSpec(
        fg: BoldColors.primary04,
        fill: BoldColors.primary08,
        stroke: BoldColors.primary04),
    BoldStatusTone.neutral => const _ToneSpec(
        fg: BoldColors.neutral03,
        fill: BoldColors.neutral10,
        stroke: BoldColors.neutral03),
  };
}
