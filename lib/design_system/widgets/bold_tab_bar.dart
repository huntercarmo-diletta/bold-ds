import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_glass.dart';

/// One tab. Pass [icon] for a Material glyph, or [iconBuilder] for a custom
/// widget that receives the resolved color (e.g. the official Pix mark).
class BoldTabItem<T> {
  const BoldTabItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconBuilder,
  });

  final T value;
  final String label;
  final IconData? icon;
  final Widget Function(Color color)? iconBuilder;
}

/// Conta BOLD — flat floating tab bar (glass). Each tab shows icon + label
/// always; the active one tints to the brand pink with a soft chip behind it.
/// (Alternative to [BoldBottomNav], which expands the active item into a pill.)
class BoldTabBar<T> extends StatelessWidget {
  const BoldTabBar({
    super.key,
    required this.items,
    required this.current,
    required this.onTap,
  });

  final List<BoldTabItem<T>> items;
  final T current;
  final ValueChanged<T> onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final radius = BorderRadius.circular(26);
    // Surface from the single BoldGlass token (solid by default; flip
    // BoldGlass.frosted for a glass web build → wraps in a BackdropFilter).
    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: BoldGlass.fill(c),
        borderRadius: radius,
        border: Border.all(color: BoldGlass.border(c)),
      ),
      child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((t) {
                final active = t.value == current;
                final col = active ? BoldColors.primary : c.textMuted;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(t.value),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: active
                              ? BoldColors.primary.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: t.iconBuilder != null
                            ? t.iconBuilder!(col)
                            : Icon(t.icon, size: 21, color: col),
                      ),
                      const SizedBox(height: 3),
                      Text(t.label,
                          style: BoldType.monoCaption.copyWith(
                              fontFamily: BoldType.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: col)),
                    ],
                  ),
                );
              }).toList(),
              ),
            ),
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration:
          BoxDecoration(borderRadius: radius, boxShadow: BoldGlass.shadow(c)),
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: BoldGlass.frosted ? BoldGlass.clip : Clip.antiAlias,
        child: BoldGlass.frosted
            ? BackdropFilter(filter: BoldGlass.blurFilter, child: bar)
            : bar,
      ),
    );
  }
}
