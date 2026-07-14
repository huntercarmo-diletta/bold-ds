import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';

/// Conta BOLD — AmountDisplay (molécula). Bloco de valor entre hairlines:
/// valor central grande + timestamp opcional (+ label acima). Telas de
/// valor/resumo/comprovante e header de extrato ("Seu saldo").
///
/// Portado do DS CPF Seguro (adaptado aos tokens Bold*).
///
/// ```dart
/// BoldAmountDisplay(value: 'R$ 560,00', timestamp: '13/10/2023 às 14:25');
/// BoldAmountDisplay(value: 'R$ 2.912,47', label: 'Seu saldo', centered: false);
/// ```
class BoldAmountDisplay extends StatelessWidget {
  const BoldAmountDisplay({
    super.key,
    required this.value,
    this.timestamp,
    this.label,
    this.centered = true,
  });

  /// Valor formatado ("R$ 560,00").
  final String value;

  /// Linha de data/hora ("13/10/2023 às 14:25").
  final String? timestamp;

  /// Label acima do valor ("Seu saldo", "Gasto no mês").
  final String? label;

  /// Centralizado (detalhe/comprovante) ou à esquerda (header de extrato).
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final cross =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final align = centered ? TextAlign.center : TextAlign.left;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: BoldSpace.x4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: c.border, width: 1),
          bottom: BorderSide(color: c.border, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: cross,
        children: [
          if (label != null) ...[
            Text(label!,
                textAlign: align,
                style: BoldType.body.copyWith(color: c.textSecondary)),
            const SizedBox(height: 4),
          ],
          Text(value,
              textAlign: align,
              style: BoldType.h1.copyWith(color: c.textPrimary)),
          if (timestamp != null) ...[
            const SizedBox(height: 2),
            Text(timestamp!,
                textAlign: align,
                style: BoldType.bodySm.copyWith(color: c.textMuted)),
          ],
        ],
      ),
    );
  }
}
