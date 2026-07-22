import 'package:flutter/material.dart';

/// Famílias do BOLD Design System (v2), vendorizadas no pubspec.
/// UI = Nunito · dados técnicos = JetBrains Mono. Espelham `BoldType.fontFamily`.
const String _ui = 'Nunito';
const String _mono = 'JetBrains Mono';

abstract final class AppTextStyles {
  // ── Display ───────────────────────────────────────────────────────────────
  static TextStyle get displayXL => const TextStyle(
    fontFamily: _ui,
    fontSize: 40,
    fontWeight: FontWeight.w900,
    letterSpacing: -2.0,
    height: 1.05,
  );

  static TextStyle get displayLg => const TextStyle(
    fontFamily: _ui,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static TextStyle get displayMd => const TextStyle(
    fontFamily: _ui,
    fontSize: 26,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    height: 1.15,
  );

  static TextStyle get displaySm => const TextStyle(
    fontFamily: _ui,
    fontSize: 21,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.8,
    height: 1.2,
  );

  // ── Headings ──────────────────────────────────────────────────────────────
  static TextStyle get h1 => const TextStyle(
    fontFamily: _ui,
    fontSize: 23,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get h2 => const TextStyle(
    fontFamily: _ui,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static TextStyle get h3 => const TextStyle(
    fontFamily: _ui,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.3,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static TextStyle get bodyLg => const TextStyle(
    fontFamily: _ui,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static TextStyle get bodyMd => const TextStyle(
    fontFamily: _ui,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySm => const TextStyle(
    fontFamily: _ui,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  // ── Erro ──────────────────────────────────────────────────────────────────
  static TextStyle get errorText => const TextStyle(
    fontFamily: _ui,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Labels ────────────────────────────────────────────────────────────────
  static TextStyle get labelLg => const TextStyle(
    fontFamily: _ui,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle get labelMd => const TextStyle(
    fontFamily: _ui,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static TextStyle get labelSm => const TextStyle(
    fontFamily: _ui,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: _ui,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ── Financeiro ────────────────────────────────────────────────────────────
  static TextStyle get amount => const TextStyle(
    fontFamily: _ui,
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static TextStyle get amountMd => const TextStyle(
    fontFamily: _ui,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
  );

  static TextStyle get amountSm => const TextStyle(
    fontFamily: _ui,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  // ── Botões ────────────────────────────────────────────────────────────────
  static TextStyle get buttonLg => const TextStyle(
    fontFamily: _ui,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonMd => const TextStyle(
    fontFamily: _ui,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get buttonSm => const TextStyle(
    fontFamily: _ui,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // ── Monospace (JetBrains Mono — dados técnicos: CPF, chaves, códigos) ──────
  static TextStyle get mono => const TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    letterSpacing: 0.8,
    height: 1.4,
  );

  static TextStyle get monoSm => const TextStyle(
    fontFamily: _mono,
    fontSize: 11,
    letterSpacing: 0.5,
    height: 1.4,
  );
}
