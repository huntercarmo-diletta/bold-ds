import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Tamanho do [BoldCheckbox].
enum BoldCheckboxSize { sm, md }

/// Variante visual do [BoldCheckbox].
enum BoldCheckboxVariant {
  /// Bg primário (rosa) quando marcado, glyph branco.
  primary,

  /// Outlined escuro (bg branco, border neutral-01), glyph neutral-01.
  neutral,
}

/// Conta BOLD — Checkbox (átomo). Seleção binária com estado `indeterminate`
/// opcional + label/description no mesmo hit-target. Glyphs check/dash
/// desenhados à mão (independentes de asset). Consome só tokens.
///
/// ```dart
/// BoldCheckbox(checked: v, onChanged: (n) => setState(() => v = n));
/// BoldCheckbox(checked: aceito, label: 'Aceito os termos', onChanged: onAceitar);
/// ```
class BoldCheckbox extends StatelessWidget {
  const BoldCheckbox({
    super.key,
    this.checked = false,
    this.indeterminate = false,
    this.disabled = false,
    this.size = BoldCheckboxSize.md,
    this.variant = BoldCheckboxVariant.primary,
    this.label,
    this.description,
    this.onChanged,
  });

  final bool checked;
  final bool indeterminate;
  final bool disabled;
  final BoldCheckboxSize size;
  final BoldCheckboxVariant variant;
  final String? label;
  final String? description;
  final ValueChanged<bool>? onChanged;

  bool get _showGlyph => checked || indeterminate;
  bool get _clickable => !disabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final s = _sizeSpec(size);
    final boxStyle = _resolveBox(_showGlyph, disabled, variant);
    final glyphColor = _resolveGlyphColor(_showGlyph, disabled, variant);

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: s.box,
      height: s.box,
      decoration: BoxDecoration(
        color: boxStyle.bg,
        borderRadius: BorderRadius.circular(s.radius),
        border: Border.all(color: boxStyle.border, width: 1),
      ),
      alignment: Alignment.center,
      child: _showGlyph
          ? CustomPaint(
              size: Size(s.glyph, s.glyph),
              painter: indeterminate
                  ? _DashPainter(glyphColor)
                  : _CheckPainter(glyphColor),
            )
          : null,
    );

    if (label == null && description == null) {
      return Semantics(
        checked: checked,
        mixed: indeterminate,
        enabled: !disabled,
        button: true,
        child: GestureDetector(
          onTap: _clickable ? () => onChanged!(!checked) : null,
          behavior: HitTestBehavior.opaque,
          child: box,
        ),
      );
    }

    return Semantics(
      checked: checked,
      mixed: indeterminate,
      enabled: !disabled,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _clickable ? () => onChanged!(!checked) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.only(top: 2), child: box),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (label != null)
                    Text(label!,
                        style: BoldType.body.copyWith(
                            color: disabled
                                ? BoldColors.neutral05
                                : BoldColors.neutral02)),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(description!,
                        style: BoldType.bodySmall.copyWith(
                            color: disabled
                                ? BoldColors.neutral06
                                : BoldColors.neutral03)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── style resolvers ─────────────────────────────────────────────────────────
class _BoxStyle {
  const _BoxStyle(this.bg, this.border);
  final Color bg;
  final Color border;
}

_BoxStyle _resolveBox(bool checked, bool disabled, BoldCheckboxVariant variant) {
  if (disabled) {
    return const _BoxStyle(BoldColors.neutral10, BoldColors.neutral09);
  }
  if (checked) {
    if (variant == BoldCheckboxVariant.primary) {
      return const _BoxStyle(BoldColors.primary, BoldColors.primary);
    }
    return const _BoxStyle(BoldColors.white, BoldColors.neutral01);
  }
  return const _BoxStyle(BoldColors.white, BoldColors.neutral08);
}

Color _resolveGlyphColor(bool checked, bool disabled, BoldCheckboxVariant variant) {
  if (disabled) return BoldColors.neutral05;
  if (!checked) return BoldColors.transparent;
  return variant == BoldCheckboxVariant.primary
      ? BoldColors.white
      : BoldColors.neutral01;
}

// ── glyphs (check + dash) ────────────────────────────────────────────────────
class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 12;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(2 * scale, 6 * scale)
      ..lineTo(5 * scale, 9 * scale)
      ..lineTo(10 * scale, 3 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.color != color;
}

class _DashPainter extends CustomPainter {
  const _DashPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 12;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(3 * scale, 6 * scale), Offset(9 * scale, 6 * scale), paint);
  }

  @override
  bool shouldRepaint(covariant _DashPainter old) => old.color != color;
}

class _SizeSpec {
  const _SizeSpec(this.box, this.radius, this.glyph);
  final double box;
  final double radius;
  final double glyph;
}

_SizeSpec _sizeSpec(BoldCheckboxSize size) => switch (size) {
      BoldCheckboxSize.md => const _SizeSpec(20, 6, 12),
      BoldCheckboxSize.sm => const _SizeSpec(16, 4, 10),
    };
