import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';

/// Conta BOLD — GlassSurface (átomo). A superfície "vidro" ÚNICA do DS
/// (spec Redesenho v.01): fill branco 26% + stroke 1px branco 30% + blur
/// uniforme 15. Glass é característica de CONTAINER (top bar, bottom app,
/// toast) — nunca de elemento. A spec exata vive no token [BoldGlass].
///
/// ```dart
/// BoldGlassSurface(child: myBar);
/// ```
class BoldGlassSurface extends StatelessWidget {
  const BoldGlassSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final tinted = DecoratedBox(
      decoration: BoxDecoration(
        color: BoldGlass.fill(c),
        border: Border(
          bottom: BorderSide(
              color: BoldGlass.border(c), width: BoldGlass.borderWidth),
        ),
      ),
      child: child,
    );
    if (!BoldGlass.frosted) return tinted;
    return ClipRect(
      clipBehavior: BoldGlass.clip,
      child: BackdropFilter(filter: BoldGlass.blurFilter, child: tinted),
    );
  }
}
