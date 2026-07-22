import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';

/// Conta BOLD — NoticeRow (molécula). Linha-aviso da home (spec Redesenho
/// v.01 — "Autorizações"): card GLASS preenchendo a largura, padding 12 nos
/// 4 lados, com:
///
/// - ícone-tile 34×34 (fill brandPrincipal, radius 8, glyph branco 18);
/// - título em Label/medium branco + subtítulo em Body/small neutral-09;
/// - badge de contagem opcional (bg brandPrincipal, texto branco).
///
/// **Composição** — BoldCard glass (molécula) + BoldIcon (átomo) + tokens.
///
/// ```dart
/// BoldNoticeRow(
///   icon: 'paper-plane-light',
///   title: 'Autorizações',
///   subtitle: 'Veja o que está esperando você.',
///   count: 8,
///   onTap: openAutorizacoes,
/// );
/// ```
class BoldNoticeRow extends StatelessWidget {
  const BoldNoticeRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.count,
    this.onTap,
    this.subtitleMaxLines = 2,
  });

  /// BoldIcon name (semantic alias ou svg cru) — glyph branco no tile.
  final String icon;
  final String title;
  final String? subtitle;

  /// Linhas do subtítulo — default 2 (evita truncar textos como "Aponte para
  /// QR, boleto ou código de autorização"). Passe 1 pra forçar linha única.
  final int subtitleMaxLines;

  /// Contagem no badge à direita (some se null ou 0).
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return BoldCard(
      glass: true,
      radius: 16,
      padding: const EdgeInsets.all(BoldSpace.x3),
      onTap: onTap,
      child: Row(children: [
        // Ícone-tile quadrado (fill brandPrincipal).
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: BoldColors.brandPrincipal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: BoldIcon(icon, size: 18, color: BoldColors.white),
        ),
        const SizedBox(width: BoldSpace.x3),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BoldType.labelMd.copyWith(color: c.textPrimary)),
              if (subtitle != null)
                Text(subtitle!,
                    maxLines: subtitleMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style:
                        BoldType.bodySm.copyWith(color: c.textSecondary)),
            ],
          ),
        ),
        if (count != null && count! > 0) ...[
          const SizedBox(width: BoldSpace.x2),
          _CountBadge(count!),
        ],
      ]),
    );
  }
}

/// Badge de contagem — bg brandPrincipal, texto branco (Label/medium).
class _CountBadge extends StatelessWidget {
  const _CountBadge(this.count);
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: BoldColors.brandPrincipal,
        shape: BoxShape.circle,
      ),
      child: Text('$count',
          style: BoldType.labelMd.copyWith(
              color: BoldColors.white, fontWeight: FontWeight.w600)),
    );
  }
}
