import 'package:flutter/material.dart';
import 'bold_colors.dart';
import 'bold_typography.dart';
import 'bold_metrics.dart';

/// Conta BOLD — assembled Flutter [ThemeData].
///
/// v2 supports **light and dark** (v1.0 was dark-only). Wire both:
///
/// ```dart
/// MaterialApp(
///   theme: BoldTheme.light(),
///   darkTheme: BoldTheme.dark(),
///   themeMode: ThemeMode.system, // or your toggle
/// );
/// ```
///
/// Mode-aware surfaces/text live in the [BoldScheme] theme extension — read
/// them in widgets via `BoldColors.of(context)`. Brand colors (pink primary,
/// gradient, semantic) are mode-stable and stay on [BoldColors].
class BoldTheme {
  BoldTheme._();

  static ThemeData dark() => _build(BoldScheme.dark());
  static ThemeData light() => _build(BoldScheme.light());

  static ThemeData _build(BoldScheme s) {
    final scheme = ColorScheme(
      brightness: s.brightness,
      primary: BoldColors.primary,
      onPrimary: Colors.white,
      secondary: BoldColors.primary,
      onSecondary: Colors.white,
      surface: s.surface,
      onSurface: s.textBody,
      error: BoldColors.danger,
      onError: Colors.white,
    );

    final t = BoldType.fontFamily;
    final textTheme = TextTheme(
      displayLarge: BoldType.display.copyWith(color: s.textPrimary),
      headlineLarge: BoldType.h1.copyWith(color: s.textPrimary),
      headlineMedium: BoldType.h2.copyWith(color: s.textPrimary),
      titleLarge: BoldType.title.copyWith(color: s.textPrimary),
      bodyLarge: BoldType.body.copyWith(color: s.textBodySoft),
      bodyMedium: BoldType.bodySmall.copyWith(color: s.textSecondary),
      labelLarge: BoldType.button.copyWith(color: s.textPrimary),
      labelSmall: BoldType.label.copyWith(color: s.textLabel),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: s.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: s.background,
      canvasColor: s.background,
      fontFamily: t,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      // App-first: touch has no hover. Kill hover highlights app-wide (the tap
      // ripple stays). On web/desktop this is also fine; flip it back if you
      // build a hover-driven web product on top of this DS.
      hoverColor: Colors.transparent,
      extensions: [s],
      dividerTheme: DividerThemeData(color: s.border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: s.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BoldRadius.cardR),
      ),
      iconTheme: IconThemeData(color: s.textBodySoft, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.field,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: BoldType.body.copyWith(color: s.textMuted),
        labelStyle: BoldType.bodySmall.copyWith(color: s.textSecondary),
        border: const OutlineInputBorder(borderRadius: BoldRadius.fieldR, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderRadius: BoldRadius.fieldR, borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BoldRadius.fieldR,
          borderSide: BorderSide(color: BoldColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
