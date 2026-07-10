import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';

/// Conta BOLD — EmptyState (molécula). Estado vazio de uma lista (ex.: atividade
/// recente sem eventos): card com spot circular + título + caption, centralizado.
///
/// **Composição** — BoldIcon (átomo) + tokens.
///
/// ```dart
/// BoldEmptyState(title: 'Nada por aqui', caption: 'Suas transações aparecerão aqui.');
/// ```
class BoldEmptyState extends StatelessWidget {
  const BoldEmptyState({
    super.key,
    required this.title,
    required this.caption,
    this.icon = 'arrow-rotate-left-light',
  });

  final String title;
  final String caption;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Fill glassy (regra do DS: fills deixam a foto de fundo passar).
    return BoldCard(
      glass: true,
      radius: BoldRadius.card,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BoldColors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: BoldIcon(icon,
                size: BoldIconSize.sm, color: BoldColors.primary),
          ),
          const SizedBox(height: 10),
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
