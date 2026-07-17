import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';
import 'bold_illustration.dart';

/// Conta BOLD — EmptyState (molécula). Estado vazio de uma lista (ex.: atividade
/// recente sem eventos): card com spot circular (ou uma [BoldIllustration]) +
/// título + caption, centralizado.
///
/// **Composição** — BoldIcon/BoldIllustration (átomo) + tokens.
///
/// ```dart
/// BoldEmptyState(title: 'Nada por aqui', caption: 'Suas transações aparecerão aqui.');
/// BoldEmptyState(illustration: 'no_data', title: '...', caption: '...');
/// ```
class BoldEmptyState extends StatelessWidget {
  const BoldEmptyState({
    super.key,
    required this.title,
    required this.caption,
    this.icon = 'arrow-rotate-left-light',
    this.illustration,
  });

  final String title;
  final String caption;
  final String icon;

  /// Nome-base de uma ilustração ([BoldIllustration]) — ex.: 'no_data'. Quando
  /// setado, mostra a ilustração (variante do tema) no lugar do spot circular.
  final String? illustration;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final art = illustration;
    // Fill glassy (regra do DS: fills deixam a foto de fundo passar).
    return BoldCard(
      glass: true,
      radius: BoldRadius.card,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (art != null)
            BoldIllustration(
                'illustrations/${art}_${c.isDark ? 'dark' : 'light'}.svg',
                size: 150)
          else
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BoldColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: BoldIcon(icon,
                  size: BoldIconSize.sm, color: BoldColors.primary),
            ),
          const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  BoldType.title.copyWith(fontSize: 15, color: c.textPrimary)),
          const SizedBox(height: 2),
          Text(caption,
              textAlign: TextAlign.center,
              style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
        ],
      ),
    );
  }
}
