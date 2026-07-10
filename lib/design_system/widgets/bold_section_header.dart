import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — SectionHeader (molécula). Um rótulo (uppercase, muted) + um slot
/// opcional à direita (tipicamente [BoldSeeAllLink]).
///
/// **Composição** — Text (token de tipo) + trailing opcional.
///
/// ```dart
/// BoldSectionHeader(label: 'Menu', trailing: BoldSeeAllLink(onPressed: abrir));
/// ```
class BoldSectionHeader extends StatelessWidget {
  const BoldSectionHeader({
    super.key,
    required this.label,
    this.trailing,
    this.padding = const EdgeInsets.only(bottom: 8),
  });

  final String label;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Spec Redesenho v.01: título em Label/medium na cor de texto (branco na
    // tela sobre imagem), sem uppercase.
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: BoldType.labelMd.copyWith(color: c.textPrimary)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Link "Ver todos" para o [BoldSectionHeader.trailing] (cor primária).
class BoldSeeAllLink extends StatelessWidget {
  const BoldSeeAllLink({super.key, this.onPressed, this.label = 'Ver todos'});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Spec Redesenho: "Ver tudo" em Label/large na mesma cor do título.
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Text(label,
          style: BoldType.labelMd.copyWith(color: c.textPrimary)),
    );
  }
}
