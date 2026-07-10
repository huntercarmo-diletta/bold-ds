import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_glass.dart';

/// Conta BOLD — Card surface.
///
/// The default container: dark surface, hairline border, 24 radius. Wrap any
/// content. Set [onTap] to make it a tappable block (action cards), [gradient]
/// for hero / featured cards.
///
/// ```dart
/// BoldCard(child: Text('…'));
/// BoldCard(onTap: open, child: Row(children: [...]));
/// ```
class BoldCard extends StatelessWidget {
  const BoldCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.gradient,
    this.color,
    this.borderColor,
    this.radius = BoldRadius.card,
    this.shadow,
    this.glass = false,
    this.highlight = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final List<BoxShadow>? shadow;

  /// Card surface treatment from [BoldCardSurface] (the "no-fundo" look, no
  /// solid fill). Frosted glass is now reserved for the nav bar only — kept
  /// named `glass` so existing callers don't change. Pair with [highlight].
  final bool glass;

  /// Within the [glass] surface: `true` = the brand "destaque" card (pink wash
  /// + pink gradient stroke); `false` = the calm default (sober grey stroke,
  /// no wash). Two tiers, one source.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final br = BorderRadius.circular(radius);

    final inner = onTap == null
        ? Padding(padding: padding, child: child)
        : Material(
            color: Colors.transparent,
            borderRadius: br,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(padding: padding, child: child),
            ),
          );

    // Single source for the card surface (every card shares it): a white
    // translucent fill frosted by the backdrop blur, with a thin stroke on top.
    // Two tiers via the stroke: highlight = pink gradient, default = sober grey.
    if (glass) {
      return ClipRRect(
        borderRadius: br,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: BoldGlass.blurFilter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: gradient == null ? BoldCardSurface.fill(c.isDark) : null,
              gradient: gradient,
              borderRadius: br,
            ),
            child: CustomPaint(
              foregroundPainter: highlight
                  ? BoldCardSurface.strokePainter(radius)
                  : BoldCardSurface.simpleStrokePainter(radius, c.isDark),
              child: inner,
            ),
          ),
        ),
      );
    }

    // Plain solid surface (non-glass callers).
    return DecoratedBox(
      decoration: BoxDecoration(
        color: gradient != null ? null : (color ?? c.surface),
        gradient: gradient,
        borderRadius: br,
        border: Border.all(color: borderColor ?? c.border, width: 1),
        boxShadow: shadow,
      ),
      child: ClipRRect(borderRadius: br, child: inner),
    );
  }
}

/// Single source for the card surface look shared by every [BoldCard].
/// Two tiers, no solid fill: the brand "destaque" (pink wash + pink gradient
/// stroke) and the calm default (a sober grey stroke). Change it here and
/// all cards follow.
class BoldCardSurface {
  /// Fill do card glass @ 26% — theme-aware: dark vinho #4C0202, light rosa
  /// #FFC8DC (mesmo vidro único do [BoldGlass]).
  static Color fill(bool isDark) =>
      (isDark ? BoldColors.glassFill : BoldColors.glassFillLight)
          .withValues(alpha: 0.26);

  /// Thin pink stroke, brighter at the top-left and fading out (destaque).
  static const LinearGradient strokeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xB3FE3976), Color(0x12FE3976)],
    stops: [0.0, 0.58],
  );

  /// Stroke do card glass 1px @ 30% — dark rosa #FF9898, light branco.
  static Color simpleStroke(bool isDark) =>
      (isDark ? BoldColors.glassStroke : BoldColors.white)
          .withValues(alpha: 0.30);

  static CustomPainter strokePainter(double radius) =>
      _CardStrokePainter(radius);

  static CustomPainter simpleStrokePainter(double radius, bool isDark) =>
      _CardStrokePainter(radius, color: simpleStroke(isDark));
}

class _CardStrokePainter extends CustomPainter {
  _CardStrokePainter(this.radius, {this.color});
  final double radius;

  /// Solid stroke colour; when null the pink [BoldCardSurface.strokeGradient]
  /// shader is used instead.
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    if (color != null) {
      paint.color = color!;
    } else {
      paint.shader = BoldCardSurface.strokeGradient.createShader(rect);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(0.5), Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CardStrokePainter o) =>
      o.radius != radius || o.color != color;
}

/// A small rounded icon chip (gradient or tinted) used on action cards/lists.
///
/// ```dart
/// BoldIconChip(Icons.send, gradient: BoldGradients.pix);     // featured
/// BoldIconChip(Icons.qr_code, tint: BoldColors.accent);      // soft tinted
/// BoldIconChip.custom(gradient: BoldGradients.pix, child: SvgPicture...); // SVG / custom glyph
/// ```
class BoldIconChip extends StatelessWidget {
  const BoldIconChip(
    this.icon, {
    super.key,
    this.gradient,
    this.tint,
    this.size = 42,
    this.iconSize = 20,
  }) : child = null;

  /// Custom-content variant: supply any [child] (e.g. an SVG `PIX` mark)
  /// instead of an [IconData]. Background still follows gradient/tint.
  const BoldIconChip.custom({
    super.key,
    required this.child,
    this.gradient,
    this.tint,
    this.size = 42,
    this.iconSize = 20,
  }) : icon = null;

  final IconData? icon;

  /// Custom glyph/widget centered in the chip (overrides [icon]).
  final Widget? child;

  final Gradient? gradient;

  /// Soft tinted background instead of a gradient — pass the base color.
  final Color? tint;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final tinted = tint != null;
    final fg = tinted ? _lift(tint!) : BoldColors.textPrimary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: tinted ? null : gradient,
        color: tinted ? tint!.withValues(alpha: 0.14) : null,
        borderRadius: BorderRadius.circular(size * 0.31),
      ),
      child: Center(
        child: child ??
            Icon(icon, size: iconSize, color: fg),
      ),
    );
  }

  // Tinted chips use a lifted version of the base color for the glyph.
  Color _lift(Color c) => Color.lerp(c, Colors.white, 0.35) ?? c;
}
