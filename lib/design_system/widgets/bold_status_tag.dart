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
/// [dot] mostra um ponto sólido no tom (●) antes do label — usado nas tags de
/// status (Ativa/Pendente/Rejeitada/Cancelada). Tem precedência sobre [icon].
///
/// **Composição** — BoldIcon (átomo) + tokens (escalas semânticas).
///
/// ```dart
/// BoldStatusTag(label: 'R$ 300,00', icon: 'arrow-trend-up-light',
///     tone: BoldStatusTone.success);
/// BoldStatusTag(label: 'Ativa', dot: true, tone: BoldStatusTone.success);
/// ```
class BoldStatusTag extends StatelessWidget {
  const BoldStatusTag({
    super.key,
    required this.label,
    this.tone = BoldStatusTone.neutral,
    this.icon,
    this.dot = false,
  });

  final String label;
  final BoldStatusTone tone;
  final String? icon;

  /// Ponto sólido no tom antes do label (●). Precede [icon].
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final t = _toneSpec(tone, BoldColors.of(context));
    return Container(
      height: 20,
      padding: EdgeInsetsDirectional.only(start: dot ? 8 : 4, end: 8),
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
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: t.fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ] else if (icon != null) ...[
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

// Todas as escalas são theme-aware.
// - Success/danger: vidro branco (cor só no texto/ícone). Dark → fill branco
//   15% / stroke 25% / fg 05; light → fill 40% / stroke 74% / fg 04.
// - Warning/primary/neutral (tons tintados): LIGHT mantém o wash claro do Figma
//   (07/08/10) + fg escuro; DARK usa tinta sutil do tom sobre a surface
//   (alphaBlend 16%) + fg claro (05) — senão o wash claro vira um pill quase
//   branco no dark.
_ToneSpec _toneSpec(BoldStatusTone t, BoldScheme s) {
  final isDark = s.isDark;
  Color glassFill() =>
      BoldColors.white.withValues(alpha: isDark ? 0.15 : 0.40);
  Color glassStroke() =>
      BoldColors.white.withValues(alpha: isDark ? 0.25 : 0.74);

  _ToneSpec tinted({
    required Color base, // matiz do fill (dark) + stroke
    required Color washLight, // fill claro do Figma (light)
    required Color fgLight,
    required Color fgDark,
  }) {
    if (isDark) {
      return _ToneSpec(
        fg: fgDark,
        fill: Color.alphaBlend(base.withValues(alpha: 0.16), s.surface),
        stroke: base.withValues(alpha: 0.45),
      );
    }
    return _ToneSpec(fg: fgLight, fill: washLight, stroke: fgLight);
  }

  return switch (t) {
    BoldStatusTone.success => _ToneSpec(
        fg: isDark ? BoldColors.success05 : BoldColors.success04,
        fill: glassFill(),
        stroke: glassStroke()),
    BoldStatusTone.danger => _ToneSpec(
        fg: isDark ? BoldColors.error05 : BoldColors.error04,
        fill: glassFill(),
        stroke: glassStroke()),
    BoldStatusTone.warning => tinted(
        base: BoldColors.warning04,
        washLight: BoldColors.warning07,
        fgLight: BoldColors.warning03,
        fgDark: BoldColors.warning05),
    BoldStatusTone.primary => tinted(
        base: BoldColors.primary04,
        washLight: BoldColors.primary08,
        fgLight: BoldColors.primary04,
        fgDark: BoldColors.primary05),
    BoldStatusTone.neutral => tinted(
        base: BoldColors.neutral05,
        washLight: BoldColors.neutral10,
        fgLight: BoldColors.neutral03,
        fgDark: BoldColors.neutral05),
  };
}
