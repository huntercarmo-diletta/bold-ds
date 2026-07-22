import 'package:flutter/material.dart';

/// Conta BOLD — Espaçamentos e dimensões
///
/// Escala de 4pt. Usar sempre estas constantes para garantir consistência.
abstract final class AppSpacing {
  // ── Escala base ───────────────────────────────────────────────────────────
  static const double xs   =  4.0;
  static const double sm   =  8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double xxl  = 32.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;

  // ── Insets (paddings) predefinidos ───────────────────────────────────────
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets screen  = EdgeInsets.all(lg);
  static const EdgeInsets cardSm  = EdgeInsets.all(sm);
  static const EdgeInsets card    = EdgeInsets.all(md);
  static const EdgeInsets cardLg  = EdgeInsets.symmetric(horizontal: md, vertical: lg);

  // ── Gaps (SizedBox) ───────────────────────────────────────────────────────
  static const Widget gapXs  = SizedBox(height: xs,  width: xs);
  static const Widget gapSm  = SizedBox(height: sm,  width: sm);
  static const Widget gapMd  = SizedBox(height: md,  width: md);
  static const Widget gapLg  = SizedBox(height: lg,  width: lg);
  static const Widget gapXl  = SizedBox(height: xl,  width: xl);
  static const Widget gapXxl = SizedBox(height: xxl, width: xxl);

  static const Widget vXs  = SizedBox(height: xs);
  static const Widget vSm  = SizedBox(height: sm);
  static const Widget vMd  = SizedBox(height: md);
  static const Widget vLg  = SizedBox(height: lg);
  static const Widget vXl  = SizedBox(height: xl);
  static const Widget vXxl = SizedBox(height: xxl);

  static const Widget hXs  = SizedBox(width: xs);
  static const Widget hSm  = SizedBox(width: sm);
  static const Widget hMd  = SizedBox(width: md);
  static const Widget hLg  = SizedBox(width: lg);
  static const Widget hXl  = SizedBox(width: xl);
}
