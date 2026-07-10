import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';

/// Conta BOLD — MenuTile (molécula). Card GLASS, alinhado à ESQUERDA · ícone
/// (BoldIcon) + rótulo em Label. Duas formas:
/// - **default** — full-width, altura 82 (menu 2×2 da home, 2 por linha).
/// - **compact** — quadrado 80×80 (grid ~3 col, ex.: Área Pix).
///
/// **Composição** — BoldCard glass (molécula) + BoldIcon (átomo) + tokens.
///
/// ```dart
/// BoldMenuTile(icon: 'pix-light', label: 'Fazer um Pix', onTap: openPix);
/// BoldMenuTile(icon: 'qrcode-light', label: 'Ler QR', compact: true, onTap: …);
/// ```
class BoldMenuTile extends StatelessWidget {
  const BoldMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.compact = false,
  });

  /// BoldIcon name (semantic alias ou svg cru).
  final String icon;
  final String label;
  final VoidCallback? onTap;

  /// `true` = tile quadrado 80×80 (grid). `false` (default) = card full-width h82.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final tile = BoldCard(
      glass: true,
      radius: 16,
      padding: EdgeInsets.all(compact ? BoldSpace.x3 : BoldSpace.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BoldIcon(icon, size: 20, color: c.textPrimary),
          SizedBox(height: compact ? BoldSpace.x2 : BoldSpace.x3),
          Text(label,
              maxLines: compact ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: (compact ? BoldType.tileLabel : BoldType.labelMd)
                  .copyWith(color: c.textPrimary)),
        ],
      ),
    );
    return compact
        ? SizedBox(width: 85, height: 80, child: tile)
        : SizedBox(height: 82, child: tile);
  }
}
