import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_gradients.dart';

/// Conta BOLD — Floating bottom navigation.
///
/// A pill bar; the active item expands into a violet "comprimido" with its
/// label. Mark one item `featured: true` to render it as a prominent gradient
/// circle (FAB-style) — e.g. the central Pix action.
///
/// ```dart
/// BoldBottomNav(
///   currentIndex: idx,
///   onTap: (i) => setState(() => idx = i),
///   items: const [
///     BoldNavItem(icon: Icons.home_outlined, label: 'Home'),
///     BoldNavItem(icon: Icons.receipt_long_outlined, label: 'Extrato'),
///     BoldNavItem(icon: Icons.pix, label: 'Pix', featured: true),
///     BoldNavItem(icon: Icons.person_outline, label: 'Perfil'),
///   ],
/// );
/// ```
///
/// NOTE: `BoldNavItem` is a STABLE public name — safe to reference long-term.
class BoldNavItem {
  const BoldNavItem({
    required this.icon,
    required this.label,
    this.featured = false,
    this.gradient,
  });
  final IconData icon;
  final String label;

  /// Render as a standout gradient circle that ignores the expand/label
  /// behavior. Tapping still fires [BoldBottomNav.onTap] with its index.
  final bool featured;

  /// Gradient for a [featured] circle. Defaults to [BoldGradients.pix].
  final Gradient? gradient;
}

class BoldBottomNav extends StatelessWidget {
  const BoldBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BoldNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: c.surface.withValues(alpha: c.isDark ? 0.92 : 0.86),
          borderRadius: BoldRadius.pillR,
          border: Border.all(color: c.border),
          boxShadow: BoldElevation.raised,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (i) {
            final active = i == currentIndex;
            final item = items[i];
            final spacing =
                EdgeInsets.only(right: i == items.length - 1 ? 0 : 6);

            // Featured item: standout gradient circle (FAB-style). When it is
            // the current tab it gains a white ring + stronger glow.
            if (item.featured) {
              return Padding(
                padding: spacing,
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: item.gradient ?? BoldGradients.pix,
                      shape: BoxShape.circle,
                      border: active
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.85), width: 2)
                          : null,
                      boxShadow: BoldElevation.glow(
                        BoldColors.primary,
                        opacity: active ? 0.65 : 0.5,
                      ),
                    ),
                    child: Icon(item.icon,
                        size: 23, color: BoldColors.textPrimary),
                  ),
                ),
              );
            }

            return Padding(
              padding: spacing,
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: active
                        ? BoldColors.primary.withValues(alpha: 0.9)
                        : Colors.transparent,
                    borderRadius: BoldRadius.pillR,
                    boxShadow: active
                        ? BoldElevation.glow(BoldColors.primary, opacity: 0.45)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon,
                          size: 21,
                          color: active ? Colors.white : c.textSecondary),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        child: active
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(item.label,
                                    style: BoldType.bodySmall.copyWith(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: BoldColors.textPrimary)),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
