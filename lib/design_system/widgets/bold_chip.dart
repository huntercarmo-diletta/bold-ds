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

/// A selectable filter chip (multi-select). Active fills violet.
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
    return Material(
      color: Colors.transparent,
      borderRadius: BoldRadius.pillR,
      child: InkWell(
        borderRadius: BoldRadius.pillR,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? BoldColors.primary.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BoldRadius.pillR,
            border: Border.all(
              color: selected
                  ? BoldColors.primary
                  : Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Text(
            label,
            style: BoldType.bodySmall.copyWith(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: selected
                  ? const Color(0xFFC4B5FD)
                  : BoldColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
