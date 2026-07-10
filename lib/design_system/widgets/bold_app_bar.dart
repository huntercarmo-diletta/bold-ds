import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_gradients.dart';
import 'bold_icon.dart';

/// Conta BOLD — top-bar building blocks.
///
/// [BoldAvatar], [BoldAccountPill], [BoldAccountSwitcher] and [BoldCircleButton]
/// são as peças que compõem o topo (dentro do [BoldTopBar]). Todas theme-aware
/// (light/dark) via [BoldColors.of].

/// A round, glassy icon button with an optional notification dot. Mark
/// [active] to tint it with the brand color (e.g. an engaged edit mode).
class BoldCircleButton extends StatelessWidget {
  const BoldCircleButton(
    this.icon, {
    super.key,
    this.onTap,
    this.dot = false,
    this.active = false,
    this.size = 40,
    this.iconSize = BoldIconSize.lg,
  });

  /// BoldIcon name (semantic or raw svg), e.g. 'bell', 'edit', 'gear'.
  final String icon;
  final VoidCallback? onTap;
  final bool dot;
  final bool active;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? BoldColors.primary.withValues(alpha: 0.14)
                : c.surface.withValues(alpha: 0.55),
            shape: BoxShape.circle,
          ),
          child: BoldIcon(icon,
              size: iconSize, color: active ? BoldColors.primary : c.textSecondary),
        ),
        if (dot)
          Positioned(
            right: size * 0.22,
            top: size * 0.22,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                  color: BoldColors.primary, shape: BoxShape.circle),
            ),
          ),
      ]),
    );
  }
}

/// Profile avatar. Shows [image] if given, otherwise gradient [initials].
/// Set [gear] to attach a small settings badge (taps open the profile).
class BoldAvatar extends StatelessWidget {
  const BoldAvatar({
    super.key,
    this.initials,
    this.image,
    this.size = 44,
    this.gear = false,
    this.onTap,
  });

  final String? initials;
  final ImageProvider? image;
  final double size;
  final bool gear;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: image == null ? BoldGradients.brand : null,
        image: image == null
            ? null
            : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: image == null
          ? Text(initials ?? '',
              style: BoldType.button.copyWith(
                  color: BoldColors.onGradient, fontSize: size * 0.32))
          : null,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size + 4,
        height: size + 4,
        child: Stack(clipBehavior: Clip.none, children: [
          avatar,
          if (gear)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: size * 0.40,
                height: size * 0.40,
                decoration: BoxDecoration(
                  color: c.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.background, width: 2),
                ),
                alignment: Alignment.center,
                child: BoldIcon('gear',
                    size: size * 0.24, color: c.textSecondary),
              ),
            ),
        ]),
      ),
    );
  }
}

/// A small colored pill that surfaces the active account (PF/PJ, "conta
/// corrente", etc.). Tapping it can open an account switcher.
class BoldAccountPill extends StatelessWidget {
  const BoldAccountPill({
    super.key,
    required this.label,
    this.color = BoldColors.primary,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Solid fill with white text — reads clearly over the busy header backdrop.
    const fg = Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 3, 8, 3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BoldRadius.pillR,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: BoldType.monoCaption.copyWith(
                  fontFamily: BoldType.fontFamily,
                  fontWeight: FontWeight.w700,
                  color: fg,
                  fontSize: 10.5)),
          if (onTap != null) ...[
            const SizedBox(width: 3),
            BoldIcon('chevron-down', size: 10, color: fg.withValues(alpha: 0.85)),
          ],
        ]),
      ),
    );
  }
}

/// The account name AS the account switcher: a small pill with the name and a
/// chevron-down (dropdown affordance). Tapping opens the account chooser. Pair
/// it with a tiny "Olá," greeting above for the home header.
///
/// ```dart
/// Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
///   Text('Olá,', style: BoldType.bodySmall),
///   BoldAccountSwitcher(name: 'Ana Carolina', onTap: openAccounts),
/// ]);
/// ```
class BoldAccountSwitcher extends StatelessWidget {
  const BoldAccountSwitcher({super.key, required this.name, this.onTap});

  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 3, 7, 3),
        // Pink tint signals "tap me" (brand colour = action).
        decoration: BoxDecoration(
          color: BoldColors.primary.withValues(alpha: 0.14),
          borderRadius: BoldRadius.pillR,
          border: Border.all(color: BoldColors.primary.withValues(alpha: 0.32)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BoldType.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: BoldColors.primary500)),
          ),
          const SizedBox(width: 4),
          const BoldIcon('chevron-down', size: 11, color: BoldColors.primary500),
        ]),
      ),
    );
  }
}
