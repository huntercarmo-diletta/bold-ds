import 'dart:ui' show ImageFilter, TileMode;
import 'package:flutter/material.dart';
import 'bold_colors.dart';

/// Conta BOLD — single source of truth for the "glass" surface.
///
/// **SPEC ÚNICA do vidro:** fill + stroke 1px + backdrop blur UNIFORME 15.
/// Theme-aware: **dark** = fill vinho-ink escuro `#16060A` @ 50% + stroke rosa
/// `#FF9898`; **light** = fill BRANCO `#FFFFFF` @ 50% + stroke BRANCO. Não existe outro vidro:
/// sem variantes progressivas, sem gradientes — TODO elemento glass (cards,
/// bars, tiles, chips, sheets) lê daqui. O ink sobre/dentro do vidro é BRANCO
/// no dark; no light segue o ink do tema.
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

  /// Fill do vidro — theme-aware: dark = vinho-ink escuro #16060A @ 50%
  /// (painel mais escuro); light = BRANCO #FFFFFF @ 50%.
  static Color fill(BoldScheme c) => c.isDark
      ? BoldColors.glassFill.withValues(alpha: 0.50)
      : BoldColors.glassFillLight.withValues(alpha: 0.50);

  /// Stroke do vidro 1px — dark = rosa #FF9898 @ 30%; light = BRANCO @ 55%
  /// (borda branca nítida sobre o fill laranja).
  static Color border(BoldScheme c) => c.isDark
      ? BoldColors.glassStroke.withValues(alpha: 0.30)
      : BoldColors.white.withValues(alpha: 0.55);

  /// Largura do stroke do vidro.
  static const double borderWidth = 1;

  /// No drop shadow — a borda de 1px define a superfície; sombra atrás do
  /// vidro é re-amostrada pelo BackdropFilter e vira halo sujo.
  static List<BoxShadow> shadow(BoldScheme c) => const [];
}
