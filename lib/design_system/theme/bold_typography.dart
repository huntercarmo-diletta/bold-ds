import 'package:flutter/material.dart';

/// Conta BOLD — Typography tokens.
///
/// One UI family ([fontFamily]) across the interface; one mono family
/// ([monoFamily]) for technical data (CPF, keys, codes).
///
/// [fontFamily] is a RUNTIME token: load a font (e.g. via `google_fonts`) and
/// set `BoldType.fontFamily = '<family>'` once at startup — every style below
/// follows it (they're getters, so the swap is live). If you vendor fonts,
/// register the family in pubspec.yaml and set the name here.
class BoldType {
  BoldType._();

  /// The UI family. **Poppins** é a fonte oficial do Conta BOLD (Redesenho
  /// v.01) — TODO texto renderizado usa ela. Mutável pra re-skin com uma
  /// linha (o app carrega Poppins via google_fonts / bundle).
  static String fontFamily = 'Poppins';

  /// Regra do DS: dados "técnicos" (CPF, chaves, valores) também são Poppins —
  /// com dígitos TABULARES ([mono]/[monoCaption]), não outra família.
  static String get monoFamily => fontFamily;

  // ═══════════════════════════════════════════════════════════════════════
  // ESCALA REDESENHO v.01 (estilos nomeados do Figma) — use ESTES nos
  // componentes novos; os antigos abaixo seguem por compat.
  // ═══════════════════════════════════════════════════════════════════════

  /// Headline/medium — 28/36 · 600. Valor do saldo.
  static TextStyle get headlineMd => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Headline/small — 24/32 · 600. Títulos de banner/card grande.
  static TextStyle get headlineSm => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
      );

  /// Title/medium — 16/24 · 500 · ls 0.15. "Olá, {nome}!", títulos de banner.
  static TextStyle get titleMd => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      );

  /// Label/large — 14/20 · 500 · ls 1.4. Labels de seção ("Seu saldo",
  /// "Menu", "Ver tudo") e títulos dos menu tiles.
  static TextStyle get labelLg => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
      );

  /// Label/medium — 12/16 · 500 · ls 0.5. Botões pequenos, badges.
  static TextStyle get labelMd => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  /// Label/small — 11/16 · 500 · ls 0.5. Pills/tags, eyebrows.
  static TextStyle get labelSm => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  /// Tile label — 10/12 · 500 · ls 0.4. Rótulo dos tiles de menu (Figma).
  static TextStyle get tileLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        height: 12 / 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      );

  /// Body/small — 12/16 · 400 · ls 0.4. Subtítulos e apoio.
  static TextStyle get bodySm => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      );

  /// Body/large — 16/24 · 400 · ls 0.5. Corpo maior (footer de cards).
  static TextStyle get bodyLg => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      );

  /// Big balance / hero number. 46 / 800. Tabular figures so digits keep a
  /// fixed width (money never "jiggles" when the value changes).
  static TextStyle get display => TextStyle(
        fontFamily: fontFamily,
        fontSize: 46,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Screen title. 30 / 800.
  static TextStyle get h1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.1,
      );

  /// Section heading. 22 / 700.
  static TextStyle get h2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  /// List / card title. 17 / 700.
  static TextStyle get title => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      );

  /// Body copy. 15 / 500.
  static TextStyle get body => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.6,
      );

  /// Smaller supporting copy. 13 / 500.
  static TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  /// Button label. 15 / 700.
  static TextStyle get button => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      );

  /// Uppercase eyebrow / section label. 12 / 700 · +1.5 tracking.
  static TextStyle get label => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      );

  /// Dados técnicos (CPF, chaves, valores). Inter 13 / 400 com dígitos
  /// tabulares — largura fixa sem trocar de família.
  static TextStyle get mono => TextStyle(
        fontFamily: monoFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Caption técnica. Inter 11 / 400 tabular.
  static TextStyle get monoCaption => TextStyle(
        fontFamily: monoFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
