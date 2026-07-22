import 'package:flutter/material.dart';
import '../../../design_system/theme/bold_colors.dart';

/// Conta BOLD — Paleta de cores (camada de compatibilidade).
///
/// Os nomes antigos (`AppColors.*`) são encaminhados para os tokens do novo
/// BOLD Design System (`BoldColors.*`, em `lib/design_system/`). Quando o drop
/// do design muda (novo zip), a paleta do app reflete automaticamente — basta
/// rebuildar. NÃO hardcodar hex aqui; aponte para um `BoldColors`.
abstract final class AppColors {
  // ── Modo de tema (light/dark) ──────────────────────────────────────────────
  /// Brilho ativo do app. Sincronizado pelo `ContaBoldApp` a partir do
  /// `themeMode` (claro/escuro/sistema). As superfícies e os textos abaixo são
  /// getters que viram com este flag; as cores de MARCA e SEMÂNTICAS não viram.
  static Brightness brightness = Brightness.dark;
  static final BoldScheme _dark  = BoldScheme.dark();
  static final BoldScheme _light = BoldScheme.light();
  static BoldScheme get scheme =>
      brightness == Brightness.dark ? _dark : _light;
  static bool get isLight => brightness == Brightness.light;

  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color brand        = BoldColors.primary;        // v2 rosa #FE3976
  static const Color brand2       = BoldColors.primaryIndigo;  // v2 rosa claro #FF6FA0
  static const Color accent       = BoldColors.primary;         // compat: aponta para primary (accent descontinuado)

  // ── Superfícies / texto (mode-aware: viram com AppColors.brightness) ───────
  // Nomes "Dark" são legados; no modo claro retornam os tons claros do DS.
  static Color get bgDark       => scheme.background;
  static Color get surfDark     => scheme.surface;
  static Color get surf2Dark    => scheme.surfaceRaised;
  static Color get borderDark   => scheme.surfacePressed;
  static Color get textDark     => scheme.textPrimary;
  static Color get text2Dark    => scheme.textSecondary;

  /// Texto/ícone sobre superfície **sempre escura** (câmera, hero, imagem):
  /// NÃO vira com o tema (senão some no modo claro). Aponta para o branco do DS
  /// (customizável por tenant) — usar no lugar de `Colors.white` direto.
  static const Color textOnDark = BoldColors.textPrimary;

  // ── Light surfaces (uso residual — sem equivalente no DS dark-only) ────────
  static const Color bgLight      = Color(0xFFF4F5FA);
  static const Color surfLight    = Color(0xFFFFFFFF);
  static const Color borderLight  = Color(0xFFE8EAF2);
  static const Color textLight    = Color(0xFF18183A);
  static const Color text2Light   = Color(0xFF7B7FA8);
  static const Color text3Light   = Color(0xFFB8BAD8);

  // ── Semânticas ────────────────────────────────────────────────────────────
  static const Color success      = BoldColors.success;        // #2FBF6B
  static const Color successBg    = Color(0x1F2FBF6B);
  static const Color error        = BoldColors.danger;         // #EF4757
  static const Color errorDark    = BoldColors.dangerBright;   // #FF4D5E
  static const Color errorBg      = Color(0x1FFF4D5E);
  static const Color warning      = BoldColors.warning;        // #F6A21A
  /// Dourado — destaque discreto de itens "diferenciados" (ex.: contato
  /// favorito na tela Pagar). Usar via token (nunca hex direto nas telas).
  static const Color gold         = Color(0xFFD4AF37);

  /// Paleta "quente" da alçada escalonada (nº de aprovações crescente):
  /// tons DISTINTOS de âmbar → vinho, para as faixas não se confundirem
  /// (alphas do brand ficavam similares demais). Índice = aprovações - 1.
  static const List<Color> alcadaHeat = [
    Color(0xFFF2B90D), // 1 aprovação  — âmbar
    Color(0xFFF28C0D), // 2            — laranja
    Color(0xFFEF5A1E), // 3            — laranja profundo
    Color(0xFFD93030), // 4            — vermelho
    Color(0xFF8E1B2E), // 5+           — vinho
  ];
  static const Color warningBg    = Color(0x1FF6A21A);
  static const Color info         = BoldColors.info;           // #3B82F6
  static const Color infoBg       = Color(0x1F3B82F6);

  // ── Extrato: crédito / débito ──────────────────────────────────────────────
  static const Color creditGreen  = BoldColors.successBright;  // #2FD27A
  static const Color debitRed     = BoldColors.dangerBright;   // #FF4D5E

  // ── Overlays ──────────────────────────────────────────────────────────────
  static const Color white08      = Color(0x14FFFFFF);
  static const Color white12      = Color(0x1FFFFFFF);
  static const Color white25      = Color(0x40FFFFFF);
  static const Color white50      = Color(0x80FFFFFF);
  static const Color black50      = Color(0x80000000);
  /// Scrim do overlay do Selo Quântico (ModalBarrier): preto puro ~60%, FIXO
  /// (independe do tema — não usar scheme.overlay, que é adaptativo/near-black).
  static const Color scrim        = Color(0x99000000);
}
