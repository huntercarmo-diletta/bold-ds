import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — PageTitle (molécula). Headline + subtítulo opcional. Usar abaixo
/// do [BoldTopBar] em telas de configuração/formulário (não em heros).
///
/// **Composição** — Text (tokens de tipo).
///
/// ```dart
/// BoldPageTitle(title: 'Alterar senha');
/// BoldPageTitle(title: 'Meus dados', subtitle: 'Atualize suas informações.');
/// ```
class BoldPageTitle extends StatelessWidget {
  const BoldPageTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: BoldType.h2.copyWith(color: c.textPrimary)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: BoldType.body.copyWith(color: c.textSecondary)),
          ],
        ],
      ),
    );
  }
}
