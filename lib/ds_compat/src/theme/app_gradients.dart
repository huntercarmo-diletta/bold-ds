import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Conta BOLD — Gradientes
abstract final class AppGradients {
  // ── Brand ─────────────────────────────────────────────────────────────────
  /// Gradiente principal: botões primários, FAB, ícones de destaque.
  /// BOLD DS v2 — "pôr-do-sol" da marca (rosa → coral). Equivale ao
  /// `BoldGradients.primaryButtonShort` (texto branco fica legível).
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFE3976), Color(0xFFFB6A1E)],
  );

  /// Versão vertical para cards/realces.
  static const LinearGradient brandV = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFE3976), Color(0xFFFB6A1E)],
  );

  /// Pôr-do-sol completo (rosa → coral → amarelo) — momentos hero/realce de marca.
  /// BOLD DS v2 `BoldGradients.brand`. Texto sobreposto = sempre branco.
  static const LinearGradient brandSunset = LinearGradient(
    begin: Alignment(-0.8, -1),
    end: Alignment(0.8, 1),
    colors: [Color(0xFFFE3976), Color(0xFFFE7B5E), Color(0xFFFEED35)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Laranja (CTA "Entrar" / botões accent) — BOLD DS accentButton
  static const LinearGradient accentOrange = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFB7A2B), Color(0xFFEE4B12)],
  );

  /// Accent → Brand (botões de ação especial)
  static const LinearGradient accentBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand, AppColors.accent],
  );

  // ── Fundos dark ───────────────────────────────────────────────────────────
  /// Fundo principal das telas dark (home, splash, hubs) — BOLD DS
  static const LinearGradient darkBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0B12), Color(0xFF14151F)],
  );

  /// Overlay escuro para sobreposições
  static const LinearGradient darkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xCC0A0B12), Color(0xB30A0B12)],
  );

  // ── Status ────────────────────────────────────────────────────────────────
  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF2FBF6B), Color(0xFF2FD27A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFEF4757), Color(0xFFFF4D5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Cartão de saldo (hero) — BOLD DS balanceCard ──────────────────────────
  static const LinearGradient card = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1),
    colors: [Color(0xFF1B1430), Color(0xFF100D1E)],
  );
}
