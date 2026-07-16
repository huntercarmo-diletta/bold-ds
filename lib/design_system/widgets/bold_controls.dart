import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';

/// Conta BOLD — Switch.
///
/// On-state color encodes the domain: orange for biometrics/security, violet
/// for profile permissions. Off is a neutral track.
///
/// ```dart
/// BoldSwitch(value: bio, onChanged: (v) => setState(() => bio = v)),
/// BoldSwitch(value: perm, accent: false, onChanged: ...), // violet
/// ```
class BoldSwitch extends StatelessWidget {
  const BoldSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.accent = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// true → orange on-state (biometrics); false → violet (permissions).
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final onColor = accent ? BoldColors.warning : BoldColors.primary;
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? onColor : BoldColors.field,
          borderRadius: BoldRadius.pillR,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Conta BOLD — Segmented control.
///
/// Pill track with 2+ options; the selected segment fills white-on-dark.
///
/// ```dart
/// BoldSegmentedControl(
///   segments: const ['Pessoa Física', 'Pessoa Jurídica'],
///   selectedIndex: idx,
///   onChanged: (i) => setState(() => idx = i),
/// );
/// ```
class BoldSegmentedControl extends StatelessWidget {
  const BoldSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.field,
        borderRadius: BoldRadius.pillR,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(segments.length, (i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BoldRadius.pillR,
              ),
              child: Text(
                segments[i],
                style: BoldType.bodySmall.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF1A1726)
                      : c.textSecondary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
