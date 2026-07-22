import 'package:flutter/material.dart';

/// Conta BOLD — Raios de borda (BorderRadius)
///
/// Uso:
///   Container(
///     decoration: BoxDecoration(
///       borderRadius: AppRadius.card,
///       color: Colors.white,
///     ),
///   )
abstract final class AppRadius {
  static const double _xsValue = 4;
  static const double _smValue = 8;
  static const double _mdValue = 12;
  static const double _lgValue = 16;
  static const double _xlValue = 20;
  static const double _xxlValue = 24;
  static const double _fullValue = 999;

  /// Extra small: 4px
  static const BorderRadius xs = BorderRadius.all(Radius.circular(_xsValue));
  static const BorderRadius cardXs = xs;

  /// Small: 8px
  static const BorderRadius sm = BorderRadius.all(Radius.circular(_smValue));
  static const BorderRadius cardSm = sm;

  /// Medium: 12px
  static const BorderRadius md = BorderRadius.all(Radius.circular(_mdValue));
  static const BorderRadius cardMd = md;
  static const BorderRadius inputMd = md;

  /// Large: 16px
  static const BorderRadius lg = BorderRadius.all(Radius.circular(_lgValue));
  // BOLD DS v2 — cards são mais arredondados (DS BoldRadius.card = 24).
  // Subimos os tokens de card de 16 → 20 (sem mexer no `lg`, usado em inputs).
  static const BorderRadius card = xl;
  static const BorderRadius cardLg = xl;

  /// Extra large: 20px
  static const BorderRadius xl = BorderRadius.all(Radius.circular(_xlValue));
  static const BorderRadius cardXl = xl;

  /// Extra extra large: 24px
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(_xxlValue));
  static const BorderRadius cardXxl = xxl;

  /// Full/pill radius
  static const BorderRadius pill = BorderRadius.all(Radius.circular(_fullValue));

  /// BottomSheet: 24px (top only)
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(_xxlValue),
    topRight: Radius.circular(_xxlValue),
  );

  /// Dialog: 12px
  static const BorderRadius dialog = md;
}
