import 'package:flutter/material.dart' show Tooltip;
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Lado do tooltip relativo ao elemento origem.
enum DilettaTooltipSide { top, right, bottom, left }

/// Tamanho do tooltip.
enum DilettaTooltipSize { big, small, xsmall }

/// Estilo (paleta).
enum DilettaTooltipStyle { dark, light }

/// CPF SEGURO — Tooltip.
///
/// Label flutuante ao lado de um elemento. Node Figma 1541:3154.
///
/// - big:    pad 12/8, radius 8, maxWidth 200 (multi-line)
/// - small:  pad 12/4, radius 8 (single-line)
/// - xsmall: pad 8/2,  radius 6 (menor)
///
/// - dark:  bg neutral-01, texto branco (default)
/// - light: bg neutral-10, texto neutral-01
///
/// Tail (setinha 8×8 rotacionado 45°) opt-in.
class DilettaTooltip extends StatelessWidget {
  const DilettaTooltip({
    super.key,
    required this.label,
    this.side = DilettaTooltipSide.top,
    this.size = DilettaTooltipSize.small,
    this.style = DilettaTooltipStyle.dark,
    this.tail = true,
    this.child,
  });

  final String label;
  final DilettaTooltipSide side;
  final DilettaTooltipSize size;
  final DilettaTooltipStyle style;
  final bool tail;

  /// Quando setado, o tooltip vira INTERATIVO: embrulha [child] no engine do
  /// [Tooltip] da plataforma (overlay por long-press/hover, posicionamento e
  /// dismiss resolvidos), vestido com a estética do chip do DS. Sem [child], é
  /// o chip presentacional (sempre-visível). Decisão: manter a estética do DS,
  /// ganhar o comportamento.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = DilettaTheme.schemeOf(context);
    final s = _sizeSpec(size);
    final v = _styleSpec(style, scheme);

    if (child != null) {
      return Tooltip(
        message: label,
        preferBelow: side == DilettaTooltipSide.bottom,
        padding: EdgeInsets.symmetric(horizontal: s.padX, vertical: s.padY),
        decoration: BoxDecoration(
          color: v.bg,
          borderRadius: BorderRadius.circular(s.radius),
          boxShadow: const [
            BoxShadow(
                color: DilettaAbsoluteColors.blackAlpha20,
                offset: Offset(0, 4),
                blurRadius: 10),
          ],
        ),
        textStyle: DilettaType.caption.copyWith(color: v.color),
        child: child,
      );
    }

    return DilettaDevInfo(
      component: 'DilettaTooltip',
      props: {'label': "'$label'", 'side': side.name, 'style': style.name, 'size': size.name},
      tokens: const ['dark: neutral-01 · light: white+border · tail opcional'],
      child: IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: s.maxWidth ?? double.infinity),
            padding: EdgeInsets.symmetric(horizontal: s.padX, vertical: s.padY),
            decoration: BoxDecoration(
              color: v.bg,
              borderRadius: BorderRadius.circular(s.radius),
              boxShadow: const [
                BoxShadow(color: DilettaAbsoluteColors.blackAlpha20, offset: Offset(0, 4), blurRadius: 10),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              softWrap: s.maxWidth != null,
              overflow: s.maxWidth == null ? TextOverflow.visible : TextOverflow.clip,
              style: DilettaType.caption.copyWith(color: v.color),
            ),
          ),
          if (tail) _Tail(side: side, color: v.bg),
        ],
      ),
    ),
    );
  }
}

class _TooltipSize {
  const _TooltipSize({required this.padX, required this.padY, required this.radius, this.maxWidth});
  final double padX;
  final double padY;
  final double radius;
  final double? maxWidth;
}

_TooltipSize _sizeSpec(DilettaTooltipSize s) => switch (s) {
      DilettaTooltipSize.big => const _TooltipSize(padX: 12, padY: 8, radius: 8, maxWidth: 200),
      DilettaTooltipSize.small => const _TooltipSize(padX: 12, padY: 4, radius: 8),
      DilettaTooltipSize.xsmall => const _TooltipSize(padX: 8, padY: 2, radius: 6),
    };

class _TooltipStyle {
  const _TooltipStyle({required this.bg, required this.color});
  final Color bg;
  final Color color;
}

_TooltipStyle _styleSpec(DilettaTooltipStyle style, DilettaScheme s) => switch (style) {
      // dark = superfície onDark (bg escuro + texto branco). Mantém 1:1 nos 2 modos.
      DilettaTooltipStyle.dark => _TooltipStyle(bg: s.surfaceInverse, color: DilettaAbsoluteColors.white),
      // light: no dark, chip claro vira neutral-02 com texto s.fg (evita claro-no-claro).
      // No light, mantém EXATO (bg neutral-10, texto neutral-01).
      DilettaTooltipStyle.light => _TooltipStyle(
          // `surfaceSubtle` já é neutral-10 no claro e neutral-02 no escuro, e
          // `fg` já inverte: os dois ternários viraram papel.
          bg: s.surfaceSubtle,
          color: s.fg,
        ),
    };

class _Tail extends StatelessWidget {
  const _Tail({required this.side, required this.color});
  final DilettaTooltipSide side;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final rot = Transform.rotate(
      angle: 3.1415926535 / 4,
      child: Container(width: 8, height: 8, color: color),
    );
    return Positioned(
      top: switch (side) { DilettaTooltipSide.bottom => -4, _ => null },
      bottom: switch (side) { DilettaTooltipSide.top => -4, _ => null },
      left: switch (side) { DilettaTooltipSide.right => -4, _ => null },
      right: switch (side) { DilettaTooltipSide.left => -4, _ => null },
      child: rot,
    );
  }
}
