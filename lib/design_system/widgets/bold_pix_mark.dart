import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';

/// Conta BOLD — Official Pix mark (Banco Central pinwheel).
///
/// Thin wrapper over the **18×18 FontAwesome `pix` glyph** so the Pix mark sits
/// on the exact same icon grid as every other icon (no off-standard sizes).
///
/// In new code prefer `BoldIcon('pix')` (outline) / `BoldIcon('pix-solid')`
/// directly. This component stays for the documented Pix brand entry points
/// (BCB UX rules): Pix tab, "Pix" shortcut, Pix area header. Do NOT use a
/// generic QR icon for Pix — `BoldIcon('qr')` is only for QR-scanning actions.
class BoldPixMark extends StatelessWidget {
  const BoldPixMark({
    super.key,
    this.size = BoldIconSize.lg,
    this.color,
    this.solid = true,
  });

  final double size;

  /// Defaults to the brand pink. On gradient/dark fills pass
  /// [BoldColors.onGradient] or [BoldColors.textPrimary].
  final Color? color;

  /// Filled mark (default) vs. the light outline variant.
  final bool solid;

  @override
  Widget build(BuildContext context) => BoldIcon(
        solid ? 'pix-solid' : 'pix',
        size: size,
        color: color ?? BoldColors.primary,
      );
}
