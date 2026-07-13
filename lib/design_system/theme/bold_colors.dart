import 'package:flutter/material.dart';

/// Conta BOLD — Color tokens.
///
/// Fonte única de verdade. Nunca hardcode um hex num widget: referencie uma
/// constante daqui. Sistema ORGANIZADO (estrutura portada do DS cpf-seguro):
/// cada família tem uma escala de shade `01..09/10` onde **04 = base**, os
/// tons baixos (01–03) escurecem e os altos (05–09) clareiam até virar wash de
/// fundo; alphas semânticos (com o uso documentado); e aliases de intenção
/// (`primary`, `danger`, `success`…) que apontam pra escala. A marca é
/// rosa → coral → amarelo (logo CONTA BOLD).
class BoldColors {
  BoldColors._();

  // ═══════════════════════════════════════════════════════════════════════
  // PRIMARY (brand pink) — 04 = base + states + alphas
  // ═══════════════════════════════════════════════════════════════════════
  static const Color primary01 = Color(0xFF300313); // Redesenho v.01
  static const Color primary02 = Color(0xFF600627); // Redesenho v.01
  static const Color primary03 = Color(0xFFCC1E58);

  /// primary-04 = marca principal (rosa do logo).
  static const Color primary04 = Color(0xFFFE3976);
  static const Color primary05 = Color(0xFFF66FA0); // Redesenho v.01
  static const Color primary06 = Color(0xFFFF87AB);
  static const Color primary07 = Color(0xFFFFB6CB);

  /// primary-08 = wash de fundo sutil (bg de tint rosa).
  static const Color primary08 = Color(0xFFFFEDF3);

  /// primary-09 = wash mais claro ainda.
  static const Color primary09 = Color(0xFFFFF6FA);

  static const Color primaryStateSelected = Color(0xFFFFE0EA);
  static const Color primaryStateHover = Color(0xFFFFEDF2);
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// primary-09 @ 70% — glass tint do alert/toast info.
  static const Color primary09Alpha70 = Color(0xB3FFF6FA);

  // ── REDESENHO v.01 (Figma 4841-38668) — marca nova ─────────────────────
  /// brand/principal — vinho da marca (stroke de avatar, badges, botões
  /// filled sobre rosa).
  static const Color brandPrincipal = Color(0xFF90093A);

  /// Fim do gradiente da marca (brand/gradient: #90093A → #F33F80).
  static const Color brandGradientEnd = Color(0xFFF33F80);

  /// Vidro DARK: fill vinho-ink ESCURO #16060A @ 50% (painel mais escuro, era
  /// #4C0202 @ 26%) + stroke rosa #FF9898 @ 30%. Cores-base — o alpha é
  /// aplicado no token [BoldGlass].
  static const Color glassFill = Color(0xFF16060A);
  static const Color glassStroke = Color(0xFFFF9898);

  /// Glass no LIGHT mode: fill BRANCO #FFFFFF @ 26% + stroke branco. Vidro
  /// neutro/frost no claro. Ver [BoldGlass]/[BoldCardSurface].
  static const Color glassFillLight = Color(0xFFFFFFFF);

  /// primary-04 @ 18% — drop shadow de botão/realce.
  static const Color primary04Alpha18 = Color(0x2EFE3976);

  /// primary-04 @ 40% — glow/shadow forte.
  static const Color primary04Alpha40 = Color(0x66FE3976);

  // ═══════════════════════════════════════════════════════════════════════
  // ACCENT (coral) — mid-stop do gradiente da marca
  // ═══════════════════════════════════════════════════════════════════════
  static const Color accent03 = Color(0xFFC24A2E);
  static const Color accent04 = Color(0xFFFE7B5E); // base
  static const Color accent05 = Color(0xFFFF9578);
  static const Color accent07 = Color(0xFFFFD6C9);
  static const Color accent08 = Color(0xFFFFF2EE);

  /// Amarelo — cauda do gradiente da marca (highlight do "O" do logo).
  static const Color brandYellow = Color(0xFFFEED35);

  // ═══════════════════════════════════════════════════════════════════════
  // NEUTRAL (grey) + white/black + alphas
  // ═══════════════════════════════════════════════════════════════════════
  static const Color neutral01 = Color(0xFF3D3939);
  static const Color neutral02 = Color(0xFF525252);
  static const Color neutral03 = Color(0xFF737373);
  static const Color neutral04 = Color(0xFF808080);
  static const Color neutral05 = Color(0xFFA0A0A0);
  static const Color neutral06 = Color(0xFFB3B3B3);
  static const Color neutral07 = Color(0xFFC6C6C6);
  static const Color neutral08 = Color(0xFFD9D9D9);
  static const Color neutral09 = Color(0xFFECECEC);
  static const Color neutral10 = Color(0xFFF6F6F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  /// neutral-10 @ 70% — glass tint (toast normal).
  static const Color neutral10Alpha70 = Color(0xB3F6F6F6);

  static const Color whiteAlpha24 = Color(0x3DFFFFFF); // chip bg sobre gradiente
  static const Color whiteAlpha32 = Color(0x52FFFFFF); // divider tracejado
  static const Color whiteAlpha38 = Color(0x61FFFFFF); // chip border
  static const Color whiteAlpha80 = Color(0xCCFFFFFF); // glass surface (top/nav/toast)

  static const Color blackAlpha8 = Color(0x14000000);  // toast shadow
  static const Color blackAlpha13 = Color(0x21000000); // card/nav shadow
  static const Color blackAlpha18 = Color(0x2D000000); // key press shadow
  static const Color blackAlpha20 = Color(0x33000000); // tooltip shadow
  static const Color blackAlpha40 = Color(0x66000000); // scrim de bottomsheet
  static const Color blackAlpha85 = Color(0xD9000000); // overlay full-screen

  // ═══════════════════════════════════════════════════════════════════════
  // ERROR (red) — 04 = base
  // ═══════════════════════════════════════════════════════════════════════
  static const Color error01 = Color(0xFF530E16);
  static const Color error02 = Color(0xFF8E1B28);
  static const Color error03 = Color(0xFFB42318); // (Redesenho v.01)
  static const Color error04 = Color(0xFFEF4757); // base
  static const Color error05 = Color(0xFFFF4D5E);
  static const Color error06 = Color(0xFFF7A9B1);
  static const Color error07 = Color(0xFFFEF3F2); // wash (Redesenho v.01)
  static const Color error04Alpha12 = Color(0x1FEF4757);
  static const Color error04Alpha40 = Color(0x66EF4757);
  static const Color error07Alpha70 = Color(0xB3FEF3F2);

  // ═══════════════════════════════════════════════════════════════════════
  // WARNING (amber) — 04 = base
  // ═══════════════════════════════════════════════════════════════════════
  static const Color warning01 = Color(0xFF573703);
  static const Color warning02 = Color(0xFF8F5A06);
  static const Color warning03 = Color(0xFFC47C0A);
  static const Color warning04 = Color(0xFFF6A21A); // base
  static const Color warning05 = Color(0xFFFDB43D);
  static const Color warning06 = Color(0xFFFBD79B);
  static const Color warning07 = Color(0xFFFEF6E7); // wash
  static const Color warning07Alpha70 = Color(0xB3FEF6E7);

  // ═══════════════════════════════════════════════════════════════════════
  // SUCCESS (green) — 04 = base
  // ═══════════════════════════════════════════════════════════════════════
  static const Color success01 = Color(0xFF0A3F24);
  static const Color success02 = Color(0xFF12693A);
  static const Color success03 = Color(0xFF1E8F4E);
  static const Color success04 = Color(0xFF0E9154); // base (Redesenho v.01)
  static const Color success05 = Color(0xFF2FD27A);
  static const Color success06 = Color(0xFFA9EFC8);
  static const Color success07 = Color(0xFFF1FEF6); // wash (Redesenho v.01)
  static const Color success07Alpha70 = Color(0xB3F1FEF6);

  // ═══════════════════════════════════════════════════════════════════════
  // INFO (blue / violet)
  // ═══════════════════════════════════════════════════════════════════════
  static const Color info04 = Color(0xFF3B82F6); // base
  static const Color infoSoft = Color(0xFF8B7BFF);

  // ═══════════════════════════════════════════════════════════════════════
  // ALIASES DE INTENÇÃO — apontam pra escala (compat + legibilidade)
  // ═══════════════════════════════════════════════════════════════════════
  static const Color primary = primary04;
  static const Color primary500 = primary05;
  static const Color primaryDeep = primary03;
  static const Color primaryIndigo = primary06; // legacy alias → rosa claro
  static const Color accent = accent04;
  static const Color accentDeep = accent03;
  static const Color accentLight = accent05;
  static const Color accentEyebrow = Color(0xFFFF9A52);
  static const Color accentSoftText = Color(0xFFF89B5E);
  static const Color onGradient = white;

  static const Color success = success04;
  static const Color successBright = success05;
  static const Color danger = error04;
  static const Color dangerBright = error05;
  static const Color warning = warning04;
  static const Color info = info04;

  /// Hairline suave pra divisórias / separadores em superfície clara.
  static const Color hairline = neutral09;

  // ═══════════════════════════════════════════════════════════════════════
  // SURFACES / TEXT / BORDERS (estáticos dark; versão mode-aware em BoldScheme)
  // ═══════════════════════════════════════════════════════════════════════
  static const Color background = Color(0xFF0A0B12);
  static const Color surface = Color(0xFF14151F);
  static const Color surfaceRaised = Color(0xFF1A1B27);
  static const Color field = Color(0xFF1E1F2D);
  static const Color surfacePressed = Color(0xFF2A2C3A);
  static const Color surfaceDeep = Color(0xFF101019);

  /// Fundo SÓLIDO dos fluxos secundários (tudo que não faz parte da navegação
  /// inferior). É o par plano do backdrop de imagem da home: um "wine-ink"
  /// profundo, herdando o vinho da marca (`brandPrincipal` #90093A / glass
  /// #4C0202) rebaixado a quase-preto — dialoga com o resto do app mas é
  /// distinto do azul-preto das surfaces, então os cards continuam saltando.
  /// Versão mode-aware em [BoldScheme.secondaryFlow]; este é o default dark.
  static const Color secondaryFlow = Color(0xFF100913);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textBody = Color(0xFFE8E9EE);
  static const Color textBodySoft = Color(0xFFC8CBD4);
  static const Color textSecondary = Color(0xFFB7BBC8);
  static const Color textLabel = Color(0xFFBFC3CF);
  static const Color textMuted = Color(0xFF686D7E);
  static const Color textDisabled = Color(0xFF7E8294);

  static const Color border = Color(0x14FFFFFF);
  static const Color borderSoft = Color(0x12FFFFFF);
  static const Color borderStrong = Color(0x2EFFFFFF);

  // ----- Helpers ----------------------------------------------------------
  /// Tint translúcido de qualquer cor (ex.: icon chips, fills de alerta).
  static Color tint(Color c, double opacity) => c.withValues(alpha: opacity);

  /// A escala mode-aware ativa. As cores de marca acima são estáveis; as
  /// surfaces/text/borders viram entre light e dark.
  static BoldScheme of(BuildContext context) =>
      Theme.of(context).extension<BoldScheme>() ?? BoldScheme.dark();
}

/// Mode-aware surfaces / text / borders (light + dark). As cores de marca
/// (primary, accent, semânticas) vivem em [BoldColors] — não viram. Leia estas
/// via `BoldColors.of(context)`.
@immutable
class BoldScheme extends ThemeExtension<BoldScheme> {
  const BoldScheme({
    required this.brightness,
    required this.background,
    required this.secondaryFlow,
    required this.surface,
    required this.surfaceRaised,
    required this.field,
    required this.surfacePressed,
    required this.textPrimary,
    required this.textBody,
    required this.textBodySoft,
    required this.textSecondary,
    required this.textLabel,
    required this.textMuted,
    required this.border,
    required this.borderSoft,
    required this.borderStrong,
    required this.overlay,
    // Papéis de marca/estado mode-aware (Figma-like): o componente referencia o
    // papel; o valor troca por modo. Ver [BoldScheme.dark]/[light].
    required this.primary,
    required this.onPrimary,
    required this.primaryPressed,
    required this.primaryWash,
    required this.accent,
    required this.danger,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Brightness brightness;
  final Color background, surface, surfaceRaised, field, surfacePressed;

  /// Fundo sólido dos fluxos secundários (fora da navegação inferior).
  /// Ver [BoldColors.secondaryFlow].
  final Color secondaryFlow;
  final Color textPrimary, textBody, textBodySoft, textSecondary, textLabel, textMuted;
  final Color border, borderSoft, borderStrong;

  /// Legibility wash sobre a imagem de fundo.
  final Color overlay;

  /// Papéis de marca/estado (resolvem por modo — o componente usa o papel, não
  /// o primitivo). Dark = shades claros/vibrantes; light = shades profundos.
  final Color primary, onPrimary, primaryPressed, primaryWash;
  final Color accent, danger, success, warning, info;

  bool get isDark => brightness == Brightness.dark;

  factory BoldScheme.dark() => const BoldScheme(
        brightness: Brightness.dark,
        background: Color(0xFF0A0B12),
        secondaryFlow: Color(0xFF100913), // wine-ink (fluxos secundários)
        surface: Color(0xFF14151F),
        surfaceRaised: Color(0xFF1A1B27),
        field: Color(0xFF1E1F2D),
        surfacePressed: Color(0xFF2A2C3A),
        textPrimary: Color(0xFFFFFFFF),
        textBody: Color(0xFFE8E9EE),
        textBodySoft: Color(0xFFC8CBD4),
        textSecondary: Color(0xFFB7BBC8),
        textLabel: Color(0xFFBFC3CF),
        textMuted: Color(0xFF686D7E),
        border: Color(0x14FFFFFF),
        borderSoft: Color(0x12FFFFFF),
        borderStrong: Color(0x2EFFFFFF),
        overlay: Color(0xB30A0B12),
        // Marca/estado no DARK: shades claros/vibrantes (leem sobre o escuro).
        primary: Color(0xFFFE3976),        // primary04
        onPrimary: Color(0xFFFFFFFF),
        primaryPressed: Color(0xFFCC1E58), // primary03
        primaryWash: Color(0x33FE3976),    // primary04 @20%
        accent: Color(0xFFFE7B5E),         // accent04
        danger: Color(0xFFFF4D5E),         // error05
        success: Color(0xFF2FD27A),        // success05
        warning: Color(0xFFFDB43D),        // warning05
        info: Color(0xFF3B82F6),           // info04
      );

  factory BoldScheme.light() => const BoldScheme(
        brightness: Brightness.light,
        background: Color(0xFFF4F3F6),
        secondaryFlow: Color(0xFFF6F3F5), // off-white plum sutil (par claro)
        surface: Color(0xFFFFFFFF),
        surfaceRaised: Color(0xFFFFFFFF),
        field: Color(0xFFF1F0F4),
        surfacePressed: Color(0xFFE8E7EE),
        // Redesenho: ink primário do light = neutral black (#000) — o que era
        // branco no dark vira preto no light.
        textPrimary: Color(0xFF3D3939), // neutral01 (scrim do fundo subiu p/ 80%)
        textBody: Color(0xFF2C2935),
        textBodySoft: Color(0xFF4A4657),
        textSecondary: Color(0xFF6B6678),
        textLabel: Color(0xFF8A8598),
        textMuted: Color(0xFF9A93A6),
        border: Color(0x12000000),
        borderSoft: Color(0x0D000000),
        borderStrong: Color(0x24000000),
        overlay: Color(0xD9F4F3F6),
        // Marca/estado no LIGHT: shades profundos (contraste no branco).
        primary: Color(0xFFCC1E58),        // primary03
        onPrimary: Color(0xFFFFFFFF),
        primaryPressed: Color(0xFF600627), // primary02
        primaryWash: Color(0xFFFFEDF3),    // primary08
        accent: Color(0xFFC24A2E),         // accent03
        danger: Color(0xFFB42318),         // error03
        success: Color(0xFF0E9154),        // success04
        warning: Color(0xFFF6A21A),        // warning04
        info: Color(0xFF3B82F6),           // info04
      );

  @override
  BoldScheme copyWith({Brightness? brightness}) => this;

  @override
  BoldScheme lerp(ThemeExtension<BoldScheme>? other, double t) {
    if (other is! BoldScheme) return this;
    return t < 0.5 ? this : other;
  }
}
