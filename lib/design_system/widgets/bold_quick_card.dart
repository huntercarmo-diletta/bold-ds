import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';

/// Porte do [BoldMenuTile].
/// - `compact` — quadrado 85×80 (grid ~3 col, ex.: Área Pix).
/// - `wide` — full-width, altura 82 (menu 2×2 da home).
/// - `large` — full-width, altura 100 · padding 16/12 · gap 8 (quick actions
///   do login recorrente).
enum BoldMenuTileSize { compact, wide, large }

/// Conta BOLD — MenuTile (molécula). Card GLASS, alinhado à ESQUERDA · ícone
/// (BoldIcon) + rótulo em Label. Três portes via [BoldMenuTileSize].
///
/// **Composição** — BoldCard glass (molécula) + BoldIcon (átomo) + tokens.
///
/// ```dart
/// BoldMenuTile(icon: 'pix-light', label: 'Fazer um Pix', onTap: openPix);
/// BoldMenuTile(icon: 'qrcode-light', label: 'Ler QR',
///     size: BoldMenuTileSize.compact, onTap: …);
/// ```
class BoldMenuTile extends StatelessWidget {
  const BoldMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.size = BoldMenuTileSize.wide,
  });

  /// BoldIcon name (semantic alias ou svg cru).
  final String icon;
  final String label;
  final VoidCallback? onTap;
  final BoldMenuTileSize size;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final compact = size == BoldMenuTileSize.compact;

    final padding = switch (size) {
      BoldMenuTileSize.compact => const EdgeInsets.all(BoldSpace.x3), // 12
      BoldMenuTileSize.wide => const EdgeInsets.all(BoldSpace.x4), // 16
      BoldMenuTileSize.large => const EdgeInsets.symmetric(
          horizontal: BoldSpace.x4, vertical: BoldSpace.x3), // 16 / 12
    };
    final gap = size == BoldMenuTileSize.wide ? BoldSpace.x3 : BoldSpace.x2;

    // large = card alto (h100): conteúdo centralizado na vertical, à esquerda.
    final centerV = size == BoldMenuTileSize.large;

    final tile = BoldCard(
      glass: true,
      radius: 16,
      padding: padding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            centerV ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          BoldIcon(icon, size: 20, color: c.textPrimary),
          SizedBox(height: gap),
          Text(label,
              maxLines: compact ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: (compact ? BoldType.tileLabel : BoldType.labelMd)
                  .copyWith(color: c.textPrimary)),
        ],
      ),
    );

    return switch (size) {
      BoldMenuTileSize.compact => SizedBox(width: 85, height: 80, child: tile),
      BoldMenuTileSize.wide => SizedBox(height: 82, child: tile),
      BoldMenuTileSize.large => SizedBox(height: 100, child: tile),
    };
  }
}
