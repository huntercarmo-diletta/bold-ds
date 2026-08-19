/// CONTA BOLD — o `ThemeData` do Flutter, e ele veio do app em 19/08.
///
/// ## Por que um DS entrega o tema do Material
///
/// Enquanto ele morava no app, **o app decidia nove superfícies do Material** — a escada de tipo do
/// `textTheme`, o fundo do scaffold, o divisor, o ícone, o card, a folha, o campo, o botão de texto
/// e a transição de página. Todas são decisão de DS, e nenhuma delas é decisão de aplicação.
///
/// O sintoma que provou isso não foi arquitetural, foi visível: até 19/08 o `MaterialApp` era
/// servido pela camada legada, que pedia **Nunito**, enquanto os 644 sítios que leem um degrau da
/// escada saíam em **Inter**. Duas fontes na mesma tela, e o que decidia qual era o arquivo que
/// ninguém considerava DS.
///
/// ## O que ele NÃO configura, e isso é medido
///
/// O tema legado configurava treze peças do Material. Vieram **nove**. As que ficaram de fora —
/// `appBarTheme`, `bottomNavigationBarTheme`, `elevatedButtonTheme`, `outlinedButtonTheme`,
/// `chipTheme`, `dialogTheme`, `snackBarTheme` — têm **zero consumidores** no app: ele instancia um
/// `TextButton` e um `Dialog` do Material, e mais nada. Tema é declaração, e **declaração sem
/// consumidor envelhece igual token sem call site**.
///
/// ## O par com [BoldTheme]
///
/// [BoldTheme] devolve o `DilettaTheme` — o esquema que as peças do pai leem pelo
/// `DilettaThemeScope`. Este devolve o `ThemeData` — o que o Material lê. **Os dois saem da mesma
/// paleta**, e o app monta os dois do mesmo brilho, então não existem dois modos ao mesmo tempo.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'bold_palette.dart';
import 'bold_radius.dart';
import 'bold_scheme.dart';
import 'bold_type.dart';

/// O `ThemeData` do Conta BOLD, nos dois modos.
///
/// ```dart
/// MaterialApp(
///   theme: BoldTemaMaterial.claro,
///   darkTheme: BoldTemaMaterial.escuro,
///   themeMode: seuModo,
/// )
/// ```
abstract final class BoldTemaMaterial {
  const BoldTemaMaterial._();

  static ThemeData get claro => _monta(BoldScheme.light());
  static ThemeData get escuro => _monta(BoldScheme.dark());

  static ThemeData _monta(BoldScheme s) {
    final cores = ColorScheme(
      brightness: s.brightness,
      primary: BoldColors.primary04,
      // Os três `on*` saem do PAPEL e não do branco cru. O valor é o mesmo nos dois modos hoje
      // (medido: `#FFFFFF` dos dois lados); a diferença é de quem é a decisão.
      onPrimary: s.onPrimary,
      secondary: BoldColors.primary04,
      onSecondary: s.onPrimary,
      surface: s.surface,
      onSurface: s.textPrimary,
      error: BoldColors.error04,
      onError: DilettaAbsoluteColors.white,
    );

    final escada = TextTheme(
      displayLarge: BoldType.display.copyWith(color: s.textPrimary),
      headlineLarge: BoldType.h1.copyWith(color: s.textPrimary),
      headlineMedium: BoldType.h2.copyWith(color: s.textPrimary),
      titleLarge: BoldType.title.copyWith(color: s.textPrimary),
      bodyLarge: BoldType.body.copyWith(color: s.textPrimary),
      // O DEFAULT do `Text` sem estilo, e ele já esteve SECUNDÁRIO. Texto sem estilo é o corpo da
      // tela — quem quer metadado pede metadado.
      bodyMedium: BoldType.bodySmall.copyWith(color: s.textPrimary),
      labelLarge: BoldType.button.copyWith(color: s.textPrimary),
      labelSmall: BoldType.label.copyWith(color: s.textSecondary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: s.brightness,
      colorScheme: cores,
      scaffoldBackgroundColor: s.background,
      canvasColor: s.background,
      fontFamily: BoldType.fontFamily,
      textTheme: escada,
      splashFactory: InkRipple.splashFactory,
      // App primeiro: toque não tem hover. Mata o realce de hover no app inteiro (o ripple do toque
      // fica). Na web e no desktop isto também serve; volte atrás se um dia existir um produto
      // guiado por hover em cima deste DS.
      hoverColor: DilettaAbsoluteColors.transparent,
      // **A linha que trancava a porta.** É esta extensão que faz `BoldColors.of(context)`
      // responder, e enquanto o esquema morava no app, o tema tinha que morar lá junto.
      extensions: [s],
      dividerTheme: DividerThemeData(color: s.border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: s.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BoldRadius.cardR),
      ),
      iconTheme: IconThemeData(color: s.textSecondary, size: 22),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BoldColors.primary04,
          textStyle: BoldType.labelLg,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.surface,
        shape: const RoundedRectangleBorder(borderRadius: BoldRadius.sheetR),
        // Desligado de propósito: cada folha deste produto desenha o próprio grip. Com o handle do
        // tema ligado apareciam DUAS barrinhas.
        showDragHandle: false,
      ),
      // Transição Cupertino nas três plataformas — decisão do produto. Sem esta linha o Android
      // volta pro fade-upwards do Material.
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.field,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: BoldType.body.copyWith(color: s.textMuted),
        labelStyle: BoldType.bodySmall.copyWith(color: s.textSecondary),
        border: const OutlineInputBorder(
            borderRadius: BoldRadius.fieldR, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BoldRadius.fieldR, borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BoldRadius.fieldR,
          borderSide: BorderSide(color: BoldColors.primary04, width: 1.5),
        ),
      ),
    );
  }
}
