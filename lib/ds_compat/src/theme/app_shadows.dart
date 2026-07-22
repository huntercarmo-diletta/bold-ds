import 'package:flutter/material.dart';

/// Conta BOLD — Sombras
abstract final class AppShadows {
  // ── Cards ─────────────────────────────────────────────────────────────────
  static const List<BoxShadow> cardSm = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardLight = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> cardLg = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
  ];

  // ── Brand glow — botões e elementos em destaque ───────────────────────────
  static const List<BoxShadow> brandGlow = [
    BoxShadow(
      color: Color(0x40FE3976), // BOLD DS v2 — glow rosa da marca
      blurRadius: 20,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> brandGlowSm = [
    BoxShadow(
      color: Color(0x33FE3976), // BOLD DS v2 — glow rosa da marca
      blurRadius: 12,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  // ── Accent glow ───────────────────────────────────────────────────────────
  static const List<BoxShadow> accentGlow = [
    BoxShadow(
      color: Color(0x40FF6B00),
      blurRadius: 16,
      spreadRadius: -4,
      offset: Offset(0, 6),
    ),
  ];

  // ── Bottom sheet / modal ──────────────────────────────────────────────────
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 40,
      offset: Offset(0, -8),
    ),
  ];

  // ── FAB ───────────────────────────────────────────────────────────────────
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x66FE3976), // BOLD DS v2 — glow rosa da marca
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
