import 'dart:ui' show ImageFilter, TileMode;
import 'package:flutter/material.dart';
import 'bold_colors.dart';

/// Conta BOLD — single source of truth for the "glass" surface.
///
/// **SPEC ÚNICA do vidro (Redesenho v.01, Figma 4841-38668):**
/// fill `#FFFFFF 26%` · stroke 1px `#FFFFFF 30%` · backdrop blur UNIFORME 15.
/// Não existe outro vidro: sem variantes progressivas, sem tints rosa, sem
/// gradientes — TODO elemento glass (cards, bars, tiles, chips, sheets) lê
/// daqui. O vidro assume fundo com imagem escurecida
/// ([BoldBackground] aplica sempre #000000 50% sobre a foto), então o ink
/// sobre/dentro do vidro é BRANCO.
class BoldGlass {
  BoldGlass._();

  /// true → frosted glass (BackdropFilter on). false → flat solid surface.
  static const bool frosted = true;

  /// Backdrop blur sigma — UNIFORME em todo vidro do app (spec: 15).
  static const double blur = 15;

  /// The shared blur filter for every glass element.
  static final ImageFilter blurFilter =
      ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.decal);

  /// Clip behaviour for glass. MUST be `antiAlias` (NOT `antiAliasWithSaveLayer`):
  /// the save-layer variant isolates the subtree, so the [BackdropFilter] reads
  /// the empty layer instead of the real backdrop and the blur vanishes.
  static const Clip clip = Clip.antiAlias;

  /// Fill do vidro @ 26% — theme-aware: dark = vinho #4C0202, light = rosa
  /// #FFC8DC (spec Figma).
  static Color fill(BoldScheme c) => (c.isDark
          ? BoldColors.glassFill
          : BoldColors.glassFillLight)
      .withValues(alpha: 0.26);

  /// Stroke do vidro 1px @ 30% — dark = rosa #FF9898, light = branco.
  static Color border(BoldScheme c) =>
      (c.isDark ? BoldColors.glassStroke : BoldColors.white)
          .withValues(alpha: 0.30);

  /// Largura do stroke do vidro.
  static const double borderWidth = 1;

  /// No drop shadow — a borda de 1px define a superfície; sombra atrás do
  /// vidro é re-amostrada pelo BackdropFilter e vira halo sujo.
  static List<BoxShadow> shadow(BoldScheme c) => const [];
}
