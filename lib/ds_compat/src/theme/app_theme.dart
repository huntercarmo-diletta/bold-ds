import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design_system/theme/bold_colors.dart' show BoldScheme;
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_radius.dart';

/// Conta BOLD — ThemeData completo
///
/// Uso no main.dart:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  // ── Tema claro (formulários, onboarding, fluxos transacionais) ────────────
  static ThemeData get light => _buildTheme(Brightness.light);

  // ── Tema escuro (home, hubs, splash) ─────────────────────────────────────
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary:          AppColors.brand,
            primaryContainer: AppColors.brand2,
            secondary:        AppColors.accent,
            surface:          AppColors.surfDark,
            onSurface:        AppColors.textDark,
            error:            AppColors.error,
            outline:          AppColors.borderDark,
          )
        : const ColorScheme.light(
            primary:          AppColors.brand,
            primaryContainer: AppColors.brand2,
            secondary:        AppColors.accent,
            surface:          AppColors.surfLight,
            onSurface:        AppColors.textLight,
            error:            AppColors.error,
            outline:          AppColors.borderLight,
          );

    return ThemeData(
      useMaterial3:      true,
      brightness:        brightness,
      colorScheme:       colorScheme,
      // Transição estilo iOS em TODAS as plataformas → habilita o gesto de
      // voltar deslizando da borda esquerda para a direita (edge-swipe back),
      // inclusive no Android (que por padrão não tem).
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS:   CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      // Registra o BoldScheme do DS para que TODO widget que lê
      // `BoldColors.of(context)` (BoldButton, BoldCard, BoldListTile, BoldSwitch,
      // BoldSegmentedControl, BoldTextField…) acompanhe claro/escuro.
      extensions: [isDark ? BoldScheme.dark() : BoldScheme.light()],
      scaffoldBackgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation:        0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? AppColors.bgDark : AppColors.surfLight,
        foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
        centerTitle:     true,
        titleTextStyle:  AppTextStyles.h3.copyWith(
          color: isDark ? AppColors.textDark : AppColors.textLight,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // ── BottomNavigationBar ──────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:      isDark ? AppColors.surf2Dark : AppColors.surfLight,
        selectedItemColor:    AppColors.brand,
        unselectedItemColor:  isDark ? AppColors.text2Dark : AppColors.text2Light,
        elevation:            0,
        type:                 BottomNavigationBarType.fixed,
        selectedLabelStyle:   AppTextStyles.labelSm,
        unselectedLabelStyle: AppTextStyles.labelSm,
      ),

      // ── ElevatedButton (botão primário) ──────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:   AppColors.brand,
          foregroundColor:   Colors.white,
          elevation:         0,
          shadowColor:       Colors.transparent,
          minimumSize:       const Size(double.infinity, 52),
          padding:           const EdgeInsets.symmetric(vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.cardLg,
          ),
          textStyle: AppTextStyles.buttonLg,
        ),
      ),

      // ── OutlinedButton (botão secundário) ────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.textDark : AppColors.brand,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
          minimumSize: const Size(double.infinity, 52),
          padding:     const EdgeInsets.symmetric(vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.cardLg,
          ),
          textStyle: AppTextStyles.buttonLg,
        ),
      ),

      // ── TextButton ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand,
          textStyle:       AppTextStyles.labelLg,
        ),
      ),

      // ── InputDecoration (campos de texto) ────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:      true,
        fillColor:   isDark ? AppColors.surf2Dark : AppColors.bgLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical:   AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: AppColors.brand, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyMd.copyWith(
          color: isDark ? AppColors.text2Dark : AppColors.text3Light,
        ),
        labelStyle: AppTextStyles.labelMd.copyWith(
          color: isDark ? AppColors.text2Dark : AppColors.text2Light,
        ),
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color:     isDark ? AppColors.surf2Dark : AppColors.surfLight,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.card,
        ),
        margin: EdgeInsets.zero,
      ),

      // ── BottomSheet ──────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:       isDark ? AppColors.surf2Dark : AppColors.surfLight,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheet,
        ),
        // OFF: cada sheet do app desenha o PRÓPRIO grip (BoldSheet / BoldTopBar
        // .sheet / grip manual). Com o handle do tema ligado apareciam DUAS
        // barrinhas (a do Flutter + a do sheet). Fica só a de dentro.
        showDragHandle: false,
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.surf2Dark : AppColors.surfLight,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardXl,
        ),
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: isDark ? AppColors.textDark : AppColors.textLight,
        ),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.surf2Dark : AppColors.bgLight,
        selectedColor:   AppColors.brand,
        labelStyle:      AppTextStyles.labelMd,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.2,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.pill,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical:   AppSpacing.xs,
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color:     isDark ? AppColors.borderDark : AppColors.borderLight,
        thickness: 1,
        space:     0,
      ),

      // ── SnackBar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surf2Dark,
        contentTextStyle: TextStyle(color: AppColors.textDark),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.card,
        ),
      ),

      // ── Typography geral ─────────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge:  AppTextStyles.displayXL,
        displayMedium: AppTextStyles.displayLg,
        displaySmall:  AppTextStyles.displayMd,
        headlineLarge: AppTextStyles.h1,
        headlineMedium:AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        bodyLarge:     AppTextStyles.bodyLg,
        bodyMedium:    AppTextStyles.bodyMd,
        bodySmall:     AppTextStyles.bodySm,
        labelLarge:    AppTextStyles.labelLg,
        labelMedium:   AppTextStyles.labelMd,
        labelSmall:    AppTextStyles.labelSm,
      ).apply(
        bodyColor:    isDark ? AppColors.textDark  : AppColors.textLight,
        displayColor: isDark ? AppColors.textDark  : AppColors.textLight,
      ),
    );
  }
}
