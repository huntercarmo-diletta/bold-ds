import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_app_list.dart';
import 'bold_background.dart';
import 'bold_bottom_app.dart';
import 'bold_list.dart' show BoldSpotIcon, BoldSpotTone;
import 'bold_section_header.dart';
import 'bold_top_bar.dart';

/// Linha de detalhe (acessório à esquerda + título/subtítulo) de uma seção do
/// [BoldTransactionSummary].
class BoldSummaryRow {
  const BoldSummaryRow({
    required this.left,
    required this.title,
    required this.subtitle,
  });
  final BoldLeftAccessory left;
  final String title;
  final String subtitle;
}

/// Seção do resumo (rótulo + card com linhas), ex.: "Para", "Detalhes".
class BoldSummarySection {
  const BoldSummarySection({required this.label, required this.rows});
  final String label;
  final List<BoldSummaryRow> rows;
}

/// Item da seção "Ajuda" (menu com chevron), ex.: "Contestar transação".
class BoldSummaryAction {
  const BoldSummaryAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final String icon;
  final String title;
  final VoidCallback onTap;
}

/// Conta BOLD — Resumo de transação (organismo). Layout estilo lista do modelo
/// CPF Seguro: top bar (voltar) + título + spot de status + valor em destaque +
/// subtítulo (data) + seções (Para/De, Detalhes) + Ajuda + CTA inferior.
///
/// Reutilizado pelo comprovante de PIX e pelo detalhe do extrato — o CTA
/// (ex.: "Comprovante") normalmente abre o documento compartilhável.
///
/// **Composição** — [BoldBackground], [BoldTopBar], [BoldSpotIcon],
/// [BoldSectionHeader], [BoldAppList]/[BoldAppListGroup], [BoldBottomApp].
class BoldTransactionSummary extends StatelessWidget {
  const BoldTransactionSummary({
    super.key,
    required this.title,
    required this.amountText,
    required this.subtitle,
    this.amountColor,
    this.statusIcon = 'circle-check-light',
    this.statusTone = BoldSpotTone.success,
    this.showStatus = true,
    this.sections = const [],
    this.helpActions = const [],
    this.onBack,
    this.onPrimary,
    this.primaryLabel = 'Comprovante',
    this.primaryGlyph = 'receipt-light',
  });

  final String title;
  final String amountText;
  final String subtitle;
  final Color? amountColor;

  final String statusIcon;
  final BoldSpotTone statusTone;
  final bool showStatus;

  final List<BoldSummarySection> sections;
  final List<BoldSummaryAction> helpActions;

  final VoidCallback? onBack;
  final VoidCallback? onPrimary;
  final String primaryLabel;
  final String primaryGlyph;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BoldBackground(
        child: Column(children: [
          BoldTopBar.page(
              title: '',
              onBack: onBack ?? () => Navigator.of(context).maybePop()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  BoldSpace.x6, 0, BoldSpace.x6, BoldSpace.x6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(title,
                            style: BoldType.headlineSm
                                .copyWith(color: c.textPrimary)),
                      ),
                      if (showStatus) ...[
                        const SizedBox(width: BoldSpace.x3),
                        BoldSpotIcon(statusIcon,
                            tone: statusTone, filled: true, size: 38),
                      ],
                    ],
                  ),
                  const SizedBox(height: BoldSpace.x4),
                  Text(amountText,
                      style: BoldType.display.copyWith(
                          color: amountColor ?? c.textPrimary,
                          fontSize: 32,
                          letterSpacing: -1)),
                  const SizedBox(height: BoldSpace.x2),
                  Text(subtitle,
                      style:
                          BoldType.bodySmall.copyWith(color: c.textSecondary)),
                  const SizedBox(height: BoldSpace.x6),
                  for (final s in sections) ...[
                    BoldSectionHeader(label: s.label),
                    const SizedBox(height: BoldSpace.x2),
                    BoldAppListGroup(children: [
                      for (final r in s.rows)
                        BoldAppList(
                          left: r.left,
                          middle: BoldMiddleAccessory.titleSubtitle(
                              title: r.title, subtitle: r.subtitle),
                        ),
                    ]),
                    const SizedBox(height: BoldSpace.x6),
                  ],
                  if (helpActions.isNotEmpty) ...[
                    const BoldSectionHeader(label: 'Ajuda'),
                    const SizedBox(height: BoldSpace.x2),
                    BoldAppListGroup(children: [
                      for (final a in helpActions)
                        BoldAppList.menuItem(
                            icon: a.icon, title: a.title, onTap: a.onTap),
                    ]),
                  ],
                ],
              ),
            ),
          ),
          if (onPrimary != null)
            BoldBottomApp.button(
              primary: BoldNavAction(
                label: primaryLabel,
                glyph: primaryGlyph,
                onPressed: onPrimary,
              ),
            ),
        ]),
      ),
    );
  }
}
