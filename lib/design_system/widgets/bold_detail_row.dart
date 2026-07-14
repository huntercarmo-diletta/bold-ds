import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';
import 'bold_list.dart' show BoldSpotIcon;

/// Conta BOLD — DetailRow (molécula). Row de detalhe título/descrição com
/// hairline inferior — telas de Detalhe de transação, dados do cartão, etc.
/// Spot à esquerda e chevron à direita opcionais.
///
/// Portado do DS CPF Seguro (adaptado aos tokens Bold*).
///
/// ```dart
/// BoldDetailRow(title: 'Para', description: 'Ana Silva');
/// BoldDetailRow(title: 'Ajuda', icon: 'headset-light', chevron: true, onTap: …);
/// ```
class BoldDetailRow extends StatelessWidget {
  const BoldDetailRow({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.chevron = false,
    this.hairline = true,
    this.onTap,
  });

  final String title;
  final String? description;

  /// SpotIcon à esquerda (opcional).
  final String? icon;

  /// Chevron à direita (row de navegação).
  final bool chevron;

  /// Hairline no rodapé da row.
  final bool hairline;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    Widget row = Container(
      padding: const EdgeInsets.symmetric(vertical: BoldSpace.x4),
      decoration: BoxDecoration(
        border: hairline
            ? Border(bottom: BorderSide(color: c.border, width: 1))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            BoldSpotIcon(icon!),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: BoldType.titleMd.copyWith(color: c.textPrimary)),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(description!,
                      style: BoldType.bodySm.copyWith(color: c.textMuted)),
                ],
              ],
            ),
          ),
          if (chevron)
            BoldIcon('chevron-right', size: 16, color: c.textSecondary),
        ],
      ),
    );

    if (onTap != null) {
      row = GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: onTap, child: row);
    }
    return row;
  }
}
