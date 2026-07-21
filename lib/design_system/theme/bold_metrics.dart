import 'package:flutter/widgets.dart';

/// Conta BOLD — Radius, spacing & elevation tokens.

/// Border radii. Generous corners everywhere; controls are full pills.
class BoldRadius {
  BoldRadius._();

  static const double chip = 10;
  static const double field = 16;
  static const double card = 24;
  static const double sheet = 22;
  /// Full pill — buttons, segmented controls, switches, nav.
  static const double pill = 999;

  static const BorderRadius chipR = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius fieldR = BorderRadius.all(Radius.circular(field));
  static const BorderRadius cardR = BorderRadius.all(Radius.circular(card));
  static const BorderRadius sheetR = BorderRadius.all(Radius.circular(sheet));
  static const BorderRadius pillR = BorderRadius.all(Radius.circular(pill));
}

/// 4-based spacing scale. Use these instead of raw numbers.
class BoldSpace {
  BoldSpace._();

  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  /// 20 — gutter lateral padrão das telas.
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;

  /// Respiro inferior obrigatório de rodapés ([BoldBottomApp]) — 32.
  static const double bottomBreath = x8;
}

/// Icon sizing scale — the single source of truth for [BoldIcon] sizes.
///
/// FontAwesome glyphs fill their box more than Material icons, so we keep the
/// scale slightly tighter. Use these tokens everywhere instead of raw numbers
/// so icons stay consistent across the app.
class BoldIconSize {
  BoldIconSize._();

  /// 14 — inline with caption text, tiny chevrons/affordances.
  static const double xs = 14;

  /// 16 — dense lists, secondary inline icons.
  static const double sm = 16;

  /// 18 — DEFAULT. Menu cells, buttons, chips, list rows.
  static const double md = 18;

  /// 20 — tab bar, section/header actions, leading row icons.
  static const double lg = 20;

  /// 24 — emphasis, empty states.
  static const double xl = 24;

  /// 28 — hero glyph on a gradient tile.
  static const double xxl = 28;
}

/// Elevation presets — soft, and tinted by the action when relevant.
class BoldElevation {
  BoldElevation._();

  /// Flat surface. 0 1px 2px /40%.
  static List<BoxShadow> get flat => const [
        BoxShadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
      ];

  /// Raised sheet / modal. 0 12px 30px /55%.
  static List<BoxShadow> get raised => const [
        BoxShadow(color: Color(0x8C000000), blurRadius: 30, offset: Offset(0, 12)),
      ];

  /// Colored glow under a primary action. Pass the action color.
  static List<BoxShadow> glow(Color color, {double opacity = 0.4}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 26,
          offset: const Offset(0, 10),
        ),
      ];

  /// App bar / nav flutuante — do CPF Seguro Design System (Figma), effect de
  /// elevação "app-navigation". Composta das variáveis de sombra do arquivo:
  /// `position-x/0` · `position-y/4` · `blur/10` · `spread/0`. Cor preto @ 13%
  /// no tema claro (Elevation/Light); no escuro a opacidade é aprofundada p/ a
  /// sombra registrar sobre o fundo escuro (Elevation/Dark).
  static List<BoxShadow> nav({bool dark = false}) => [
        BoxShadow(
          color: Color(dark ? 0x59000000 : 0x21000000),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ];
}
