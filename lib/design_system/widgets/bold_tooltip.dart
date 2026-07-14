import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Lado do tooltip relativo ao elemento origem.
enum BoldTooltipSide { top, right, bottom, left }

/// Tamanho do tooltip.
enum BoldTooltipSize { big, small, xsmall }

/// Estilo (paleta).
enum BoldTooltipStyle { dark, light }

/// Conta BOLD — Tooltip. Label flutuante ao lado de um elemento, com tail
/// (setinha) opcional. Peça visual — o posicionamento sobre a origem é do
/// caller (ex.: via [Overlay]/[CompositedTransformFollower]).
///
/// Portado do DS CPF Seguro (adaptado aos tokens Bold*).
///
/// - big: pad 12/8, radius 8, maxWidth 200 (multi-line)
/// - small: pad 12/4, radius 8 (single-line)
/// - xsmall: pad 8/2, radius 6
class BoldTooltip extends StatelessWidget {
  const BoldTooltip({
    super.key,
    required this.label,
    this.side = BoldTooltipSide.top,
    this.size = BoldTooltipSize.small,
    this.style = BoldTooltipStyle.dark,
    this.tail = true,
  });

  final String label;
  final BoldTooltipSide side;
  final BoldTooltipSize size;
  final BoldTooltipStyle style;
  final bool tail;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final sz = _sizeSpec(size);
    final v = _styleSpec(style, c);

    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            constraints:
                BoxConstraints(maxWidth: sz.maxWidth ?? double.infinity),
            padding:
                EdgeInsets.symmetric(horizontal: sz.padX, vertical: sz.padY),
            decoration: BoxDecoration(
              color: v.bg,
              borderRadius: BorderRadius.circular(sz.radius),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 4),
                    blurRadius: 10),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              softWrap: sz.maxWidth != null,
              overflow: sz.maxWidth == null
                  ? TextOverflow.visible
                  : TextOverflow.clip,
              style: BoldType.bodySm.copyWith(color: v.color),
            ),
          ),
          if (tail) _Tail(side: side, color: v.bg),
        ],
      ),
    );
  }
}

class _TooltipSize {
  const _TooltipSize(
      {required this.padX,
      required this.padY,
      required this.radius,
      this.maxWidth});
  final double padX;
  final double padY;
  final double radius;
  final double? maxWidth;
}

_TooltipSize _sizeSpec(BoldTooltipSize s) => switch (s) {
      BoldTooltipSize.big =>
        const _TooltipSize(padX: 12, padY: 8, radius: 8, maxWidth: 200),
      BoldTooltipSize.small => const _TooltipSize(padX: 12, padY: 4, radius: 8),
      BoldTooltipSize.xsmall => const _TooltipSize(padX: 8, padY: 2, radius: 6),
    };

class _TooltipStyle {
  const _TooltipStyle({required this.bg, required this.color});
  final Color bg;
  final Color color;
}

_TooltipStyle _styleSpec(BoldTooltipStyle style, BoldScheme c) =>
    switch (style) {
      // dark = chip escuro + texto branco (mantém nos 2 modos).
      BoldTooltipStyle.dark =>
        const _TooltipStyle(bg: Color(0xFF1F1F1F), color: BoldColors.white),
      // light = superfície do tema + texto primário.
      BoldTooltipStyle.light =>
        _TooltipStyle(bg: c.surface, color: c.textPrimary),
    };

class _Tail extends StatelessWidget {
  const _Tail({required this.side, required this.color});
  final BoldTooltipSide side;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final rot = Transform.rotate(
      angle: 3.1415926535 / 4,
      child: Container(width: 8, height: 8, color: color),
    );
    return Positioned(
      top: switch (side) { BoldTooltipSide.bottom => -4, _ => null },
      bottom: switch (side) { BoldTooltipSide.top => -4, _ => null },
      left: switch (side) { BoldTooltipSide.right => -4, _ => null },
      right: switch (side) { BoldTooltipSide.left => -4, _ => null },
      child: rot,
    );
  }
}
