import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Tamanho do Checkbox (mirror Figma DS).
enum DilettaCheckboxSize { sm, md }

/// Variante visual.
enum DilettaCheckboxVariant {
  /// Bg primary-04 quando checked, glyph branco.
  primary,

  /// Outlined escuro (bg branco, border neutral-01), glyph neutral-01.
  neutral,
}

/// CPF SEGURO — Checkbox.
///
/// Seleção binária, com estado `indeterminate` opcional. Suporta label +
/// description no mesmo hit-target quando fornecidos.
///
/// - md (default) → box 20×20, radius 6.
/// - sm            → box 16×16, radius 4.
///
/// ```dart
/// DilettaCheckbox(checked: v, onChanged: (n) => setState(() => v = n)),
/// DilettaCheckbox(
///   checked: aceito,
///   label: 'Aceito os termos',
///   description: 'Você pode revogar depois.',
///   onChanged: onAcceptTerms,
/// ),
/// DilettaCheckbox(indeterminate: true, variant: DilettaCheckboxVariant.neutral),
/// ```
class DilettaCheckbox extends StatelessWidget {
  const DilettaCheckbox({
    super.key,
    this.checked = false,
    this.indeterminate = false,
    this.disabled = false,
    this.size = DilettaCheckboxSize.md,
    this.variant = DilettaCheckboxVariant.primary,
    this.label,
    this.description,
    this.onChanged,
  });

  final bool checked;
  final bool indeterminate;
  final bool disabled;
  final DilettaCheckboxSize size;
  final DilettaCheckboxVariant variant;
  final String? label;
  final String? description;
  final ValueChanged<bool>? onChanged;

  bool get _showGlyph => checked || indeterminate;
  bool get _clickable => !disabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final s = _sizeSpec(size);
    final scheme = DilettaTheme.schemeOf(context);
    final boxStyle = _resolveBox(
      checked: _showGlyph,
      disabled: disabled,
      variant: variant,
      scheme: scheme,
    );
    final glyphColor = _resolveGlyphColor(
      checked: _showGlyph,
      disabled: disabled,
      variant: variant,
      scheme: scheme,
    );

    Widget box = AnimatedContainer(
      duration: DilettaMotion.micro,
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
                  ? _DashPainter(color: glyphColor)
                  : _CheckPainter(color: glyphColor),
            )
          : null,
    );

    if (label == null && description == null) {
      return DilettaDevInfo(
      component: 'DilettaCheckbox',
      props: {'checked': '$checked', 'variant': variant.name, 'size': size.name, if (indeterminate) 'indeterminate': 'true', if (disabled) 'disabled': 'true'},
      tokens: const ['box radius sm/md · checked bg primary-04 · glyph white'],
      child: Semantics(
        checked: checked,
        mixed: indeterminate,
        enabled: !disabled,
        button: true,
        child: MouseRegion(
          cursor: _clickable ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          child: DilettaTappable(pressedOpacity: 1.0, 
            onTap: _clickable ? () => onChanged!(!checked) : null,
            behavior: HitTestBehavior.opaque,
            child: box,
          ),
        ),
      ),
    );
    }

    return DilettaDevInfo(
      component: 'DilettaCheckbox',
      props: {'checked': '$checked', 'variant': variant.name, 'size': size.name, if (indeterminate) 'indeterminate': 'true', if (disabled) 'disabled': 'true'},
      tokens: const ['box radius sm/md · checked bg primary-04 · glyph white'],
      child: Semantics(
      checked: checked,
      mixed: indeterminate,
      enabled: !disabled,
      button: true,
      label: label,
      child: MouseRegion(
        cursor: _clickable ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: DilettaTappable(pressedOpacity: 1.0, 
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
                      Text(
                        label!,
                        style: DilettaType.bodyMd.copyWith(
                          color: disabled ? scheme.palette.neutral05 : scheme.textSecondary,
                        ),
                      ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description!,
                        style: DilettaType.caption.copyWith(
                          color: disabled ? scheme.palette.neutral06 : scheme.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

// ============================================================================
// Style resolvers
// ============================================================================

class _BoxStyle {
  const _BoxStyle({required this.bg, required this.border});
  final Color bg;
  final Color border;
}

_BoxStyle _resolveBox({
  required bool checked,
  required bool disabled,
  required DilettaCheckboxVariant variant,
  required DilettaScheme scheme,
}) {
  if (disabled) {
    // Disabled mantém a paleta neutra do legado.
    return _BoxStyle(bg: scheme.palette.neutral10, border: scheme.palette.neutral09);
  }
  if (checked) {
    if (variant == DilettaCheckboxVariant.primary) {
      return _BoxStyle(bg: scheme.primary, border: scheme.primary);
    }
    return _BoxStyle(bg: scheme.surface, border: scheme.fg);
  }
  return _BoxStyle(bg: scheme.surface, border: scheme.border);
}

Color _resolveGlyphColor({
  required bool checked,
  required bool disabled,
  required DilettaCheckboxVariant variant,
  required DilettaScheme scheme,
}) {
  if (disabled) return scheme.palette.neutral05;
  if (!checked) return DilettaAbsoluteColors.transparent;
  // primary = glyph branco sobre box da marca (onPrimary, não inverte).
  return variant == DilettaCheckboxVariant.primary ? scheme.palette.white : scheme.fg;
}

// ============================================================================
// Glyphs (check + dash) — desenhados a mão pra ficar independente de asset
// ============================================================================

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.color});
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
  const _DashPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 12;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(3 * scale, 6 * scale), Offset(9 * scale, 6 * scale), paint);
  }

  @override
  bool shouldRepaint(covariant _DashPainter old) => old.color != color;
}

class _SizeSpec {
  const _SizeSpec({required this.box, required this.radius, required this.glyph});
  final double box;
  final double radius;
  final double glyph;
}

_SizeSpec _sizeSpec(DilettaCheckboxSize size) => switch (size) {
      DilettaCheckboxSize.md => const _SizeSpec(box: 20, radius: 6, glyph: 12),
      DilettaCheckboxSize.sm => const _SizeSpec(box: 16, radius: 4, glyph: 10),
    };
