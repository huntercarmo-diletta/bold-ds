import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';

/// Conta BOLD — Chips, tags & status badges.

/// A status badge tinted by intent. Pass an optional [icon] (e.g. a check on
/// "Chave validada").
class BoldStatusBadge extends StatelessWidget {
  const BoldStatusBadge(
    this.label, {
    super.key,
    this.color = BoldColors.success,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = Color.lerp(color, Colors.white, 0.35);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BoldRadius.pillR,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: BoldType.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip de filtro selecionável (Todos / Entradas / Saídas…). Theme-aware e
/// acessível:
/// - **selecionado** = fill `primary` sólido + ink `onPrimary` (contraste AA,
///   mesma lógica do BoldButton primário);
/// - **não-selecionado** = outline neutro do tema (`border` + `textSecondary`);
/// - alvo de toque mínimo 44px e `Semantics(selected)` pra leitores de tela.
class BoldFilterChip extends StatelessWidget {
  const BoldFilterChip(
    this.label, {
    super.key,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: BoldColors.transparent,
        borderRadius: BoldRadius.pillR,
        child: InkWell(
          borderRadius: BoldRadius.pillR,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            // vertical 13 + texto ~18 ≈ alvo de toque 44px (sem `alignment`,
            // que num Wrap de largura ilimitada quebra com "infinite size").
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              color: selected ? c.primary : BoldColors.transparent,
              borderRadius: BoldRadius.pillR,
              border: Border.all(color: selected ? c.primary : c.border),
            ),
            child: Text(
              label,
              style: BoldType.bodySmall.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: selected ? c.onPrimary : c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
