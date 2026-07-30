import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Linha label/valor do comprovante ("Valor · R$ 300,67").
class DilettaReceiptRow {
  const DilettaReceiptRow({required this.label, required this.value});
  final String label;
  final String value;
}

/// Seção do comprovante com header (ícone + título) e hairline —
/// ex: "Destino", "Origem", "Estabelecimento", "Cartão".
class DilettaReceiptSection {
  const DilettaReceiptSection({
    required this.icon,
    required this.title,
    required this.rows,
  });
  final String icon;
  final String title;
  final List<DilettaReceiptRow> rows;
}

/// CPF SEGURO — Receipt (organismo).
///
/// Corpo do comprovante (Figma 11168:57881): spot com ícone de status +
/// título headline + timestamp + rows label/valor + seções (Destino/Origem
/// ou Estabelecimento/Cartão) + card de rodapé com dados institucionais,
/// ID da transação e o logo.
///
/// A tela dona coloca top bar (close + share) por cima — o Receipt é só o
/// conteúdo scrollável.
///
/// **Composição** — Icon, Logo (átomos) + tokens.
class DilettaReceipt extends StatelessWidget {
  const DilettaReceipt({
    super.key,
    required this.title,
    required this.timestamp,
    this.icon = 'circle-check-light',
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

  /// Rows soltas do topo (Valor, Tipo de pagamento, ...).
  final List<DilettaReceiptRow> rows;

  /// Seções com header ("Destino", "Estabelecimento"...).
  final List<DilettaReceiptSection> sections;

  /// Linhas institucionais do rodapé ("CPF Seguro - Instituição de
  /// pagamento", "CNPJ: ...").
  final List<String> footerLines;

  /// ID da transação no rodapé.
  final String? transactionId;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaReceipt',
      props: {'title': "'$title'", 'icon': icon, 'rows': '${rows.length}', 'sections': '${sections.length}'},
      tokens: const ['spot status 34 · title · rows label/valor caption', 'footer neutral-10 + ID + logo'],
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Spot de status 34 (outline neutral).
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: s.bg,
            shape: BoxShape.circle,
          ),
          child: DilettaIconAccessory(icon: icon, padding: 0, size: 16, color: s.fg),
        ),
        const SizedBox(height: 12),
        Text(title, style: DilettaType.title.copyWith(color: s.fg)),
        const SizedBox(height: 4),
        Text(timestamp, style: DilettaType.caption.copyWith(color: s.textMuted)),
        const SizedBox(height: 24),
        for (final row in rows) _row(row, s),
        for (final section in sections) ...[
          const SizedBox(height: 16),
          Row(children: [
            DilettaIconAccessory(icon: section.icon, padding: 0, size: 14, color: s.textSecondary),
            const SizedBox(width: 6),
            Text(
              section.title,
              style: DilettaType.label.copyWith(color: s.textSecondary),
            ),
          ]),
          const SizedBox(height: 4),
          Container(height: 1, color: s.divider),
          const SizedBox(height: 8),
          for (final row in section.rows) _row(row, s),
        ],
        if (footerLines.isNotEmpty || transactionId != null) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DilettaSpacing.s4),
            decoration: BoxDecoration(
              color: s.bg,
              borderRadius: DilettaRadius.all8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final line in footerLines)
                  Text(line, style: DilettaType.caption.copyWith(color: s.textTertiary)),
                if (transactionId != null) ...[
                  const SizedBox(height: 12),
                  Text('ID da transação', style: DilettaType.caption.copyWith(color: s.textTertiary)),
                  Text(
                    transactionId!,
                    style: DilettaType.caption.copyWith(color: s.textTertiary),
                  ),
                ],
                const SizedBox(height: 16),
                const Center(
                  child: DilettaLogo(size: 40),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
    );
  }

  Widget _row(DilettaReceiptRow row, DilettaScheme s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: DilettaType.caption.copyWith(color: s.textTertiary)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              row.value,
              textAlign: TextAlign.right,
              style: DilettaType.caption.copyWith(color: s.fg),
            ),
          ),
        ],
      ),
    );
  }
}
