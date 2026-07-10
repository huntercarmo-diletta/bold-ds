import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — Numeric keypad & PIN entry.

/// A 3-column numeric keypad with a delete key. Pure input — wire [onKey]
/// (digit '0'-'9') and [onDelete] to your own value state.
class BoldKeypad extends StatelessWidget {
  const BoldKeypad({
    super.key,
    required this.onKey,
    required this.onDelete,
    this.compact = false,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onDelete;

  /// Smaller padding/font for tight sheets (PIN dialogs).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: compact ? 1.9 : 1.6,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox.shrink();
        if (k == 'del') {
          return _Key(
            onTap: onDelete,
            background: Colors.transparent,
            child: const Icon(Icons.backspace_outlined,
                color: BoldColors.textSecondary, size: 22),
          );
        }
        return _Key(
          onTap: () => onKey(k),
          background:
              compact ? const Color(0xFF16171F) : BoldColors.field,
          child: Text(k,
              style: BoldType.title.copyWith(
                  fontSize: compact ? 18 : 22, fontWeight: FontWeight.w600)),
        );
      }).toList(),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.onTap, required this.child, required this.background});

  final VoidCallback onTap;
  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: BoldColors.surfacePressed,
        child: Center(child: child),
      ),
    );
  }
}

/// A row of PIN dots; pass how many are [filled] of [length].
class BoldPinDots extends StatelessWidget {
  const BoldPinDots({super.key, required this.length, required this.filled});

  final int length;
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final on = i < filled;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6.5),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: on ? BoldColors.primary : Colors.transparent,
            border: Border.all(
              color: on ? BoldColors.primary : BoldColors.textMuted,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}
