import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_card.dart';
import 'bold_icon.dart';
import 'bold_list.dart' show BoldSpotIcon, BoldSpotTone;
import 'bold_logo.dart';

/// Linha label/valor do comprovante ("Valor · R$ 300,67").
class BoldReceiptRow {
  const BoldReceiptRow({required this.label, required this.value});
  final String label;
  final String value;
}

/// Seção do comprovante com header (ícone + título) e hairline —
/// ex.: "Destino", "Origem", "Cartão".
class BoldReceiptSection {
  const BoldReceiptSection({
    required this.icon,
    required this.title,
    required this.rows,
  });
  final String icon;
  final String title;
  final List<BoldReceiptRow> rows;
}

/// Conta BOLD — Receipt (organismo). Corpo do comprovante: spot de status +
/// título + timestamp + rows label/valor + seções + card de rodapé com dados
/// institucionais, ID da transação e logo. A tela dona põe a top bar por cima.
///
/// Portado do DS CPF Seguro (adaptado aos tokens Bold*).
class BoldReceipt extends StatelessWidget {
  const BoldReceipt({
    super.key,
    required this.title,
    required this.timestamp,
    this.icon = 'circle-check-light',
    this.statusTone = BoldSpotTone.success,
    this.rows = const [],
    this.sections = const [],
    this.footerLines = const [],
    this.transactionId,
  });

  /// "Comprovante de pagamento", "Comprovante de compra"...
  final String title;

  /// "24 Out 2022 - 11:34:32".
  final String timestamp;

  /// Ícone do spot de status (check = pago, clock = processando,
  /// calendar = agendado).
  final String icon;
  final BoldSpotTone statusTone;

  /// Rows soltas do topo (Valor, Tipo de pagamento, ...).
  final List<BoldReceiptRow> rows;

  /// Seções com header ("Destino", "Estabelecimento"...).
  final List<BoldReceiptSection> sections;

  /// Linhas institucionais do rodapé.
  final List<String> footerLines;

  /// ID da transação no rodapé.
  final String? transactionId;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BoldSpotIcon(icon, tone: statusTone),
        const SizedBox(height: 12),
        Text(title, style: BoldType.h2.copyWith(color: c.textPrimary)),
        const SizedBox(height: 4),
        Text(timestamp, style: BoldType.bodySm.copyWith(color: c.textMuted)),
        const SizedBox(height: 24),
        for (final row in rows) _row(row, c),
        for (final section in sections) ...[
          const SizedBox(height: 16),
          Row(children: [
            BoldIcon(section.icon, size: 14, color: c.textSecondary),
            const SizedBox(width: 6),
            Text(section.title,
                style: BoldType.labelSm.copyWith(color: c.textSecondary)),
          ]),
          const SizedBox(height: 4),
          Container(height: 1, color: c.border),
          const SizedBox(height: 8),
          for (final row in section.rows) _row(row, c),
        ],
        if (footerLines.isNotEmpty || transactionId != null) ...[
          const SizedBox(height: 24),
          BoldCard(
            glass: true,
            radius: 8,
            padding: const EdgeInsets.all(BoldSpace.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final line in footerLines)
                  Text(line,
                      style: BoldType.bodySm.copyWith(color: c.textMuted)),
                if (transactionId != null) ...[
                  const SizedBox(height: 12),
                  Text('ID da transação',
                      style: BoldType.bodySm.copyWith(color: c.textMuted)),
                  Text(transactionId!,
                      style: BoldType.bodySm.copyWith(color: c.textMuted)),
                ],
                const SizedBox(height: 16),
                const Center(child: BoldLogo(width: 40)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _row(BoldReceiptRow row, BoldScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BoldSpace.x1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: BoldType.bodySm.copyWith(color: c.textMuted)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(row.value,
                textAlign: TextAlign.right,
                style: BoldType.bodySm.copyWith(color: c.textPrimary)),
          ),
        ],
      ),
    );
  }
}
