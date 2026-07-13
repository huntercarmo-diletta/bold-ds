import 'package:flutter/widgets.dart';
import 'bold_colors.dart';

/// Conta BOLD — Gradient tokens.
///
/// v2 — the signature is the brand "sunset" (pink → coral → yellow), from the
/// logo's "O" ring. Use [brand] for hero moments (balance, primary CTA, Pix).
/// Text on it must be [BoldColors.onGradient] (white washes out on the yellow).
class BoldGradients {
  BoldGradients._();

  /// THE brand gradient — pink → coral → yellow.
  static const Gradient brand = LinearGradient(
    begin: Alignment(-0.8, -1),
    end: Alignment(0.8, 1),
    colors: [Color(0xFFFE3976), Color(0xFFFE7B5E), Color(0xFFFEED35)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Primary CTA = the brand sunset.
  static const Gradient primaryButton = brand;

  /// Two-stop CTA for small controls where the full sunset is too busy.
  static const Gradient primaryButtonShort = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFE3976), Color(0xFFFB6A1E)],
  );

  static const Gradient accentButton = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [BoldColors.accentLight, BoldColors.accentDeep],
  );

  // 150deg diagonal used by the shortcut tiles & featured icons.
  static const Alignment _from = Alignment(-0.7, -1);
  static const Alignment _to = Alignment(0.7, 1);

  /// Pix (featured nav circle / Pix area) — the brand sunset.
  static const Gradient pix =
      LinearGradient(begin: _from, end: _to, colors: [Color(0xFFFE3976), Color(0xFFFB6A1E)]);
  static const Gradient pay =
      LinearGradient(begin: _from, end: _to, colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]);
  static const Gradient ted =
      LinearGradient(begin: _from, end: _to, colors: [Color(0xFFF59E0B), Color(0xFFEA6A0C)]);
  static const Gradient statement =
      LinearGradient(begin: _from, end: _to, colors: [Color(0xFF22C55E), Color(0xFF15803D)]);
  static const Gradient receive =
      LinearGradient(begin: _from, end: _to, colors: [Color(0xFF38BDF8), Color(0xFF2563EB)]);
  static const Gradient charge =
      LinearGradient(begin: _from, end: _to, colors: [Color(0xFFA855F7), Color(0xFF6D28F6)]);

  /// Balance hero card background.
  static const Gradient balanceCard = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1),
    colors: [Color(0xFF1B1430), Color(0xFF100D1E)],
  );
}
