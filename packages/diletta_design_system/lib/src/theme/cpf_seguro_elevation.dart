import 'package:flutter/widgets.dart';
import 'cpf_seguro_palette.dart';
import 'diletta_absolute_colors.dart';
import 'generated/cps_elevation_tokens.g.dart';

/// Elevation (tier suporte).
///
/// Espelha a coleção `Elevation` do Figma, mas **filtrada** pro que o DS usa
/// de verdade: das 21 do Figma sobram as sombras reais em 2 famílias —
/// **neutra** (preto, superfícies) e **brand lift** (a cor da marca, em
/// elementos que "pulam"). Rings de foco (`primary-07`/`error-07` com spread)
/// não são elevação e vivem no border, fora daqui.
///
/// A diferença entre as duas famílias não é estética, é de DONO:
///
/// - **neutra** é preto e cinza absoluto — cor que ninguém é dono. Vive em
///   `const`, autorada no DTCG deste repo;
/// - **brand lift** é a cor de um FILHO. Aqui mora só a FORMA (alpha, offset,
///   blur) e a cor entra por parâmetro — `brandLowDe(paleta)`. É a mesma
///   correção que os gradientes já tinham levado (ver `DilettaGradients`).
///
/// Uso: `boxShadow: DilettaElevation.low` pro neutro,
/// `DilettaElevation.brandLowDe(s.palette)` pro que carrega marca.
///
/// Mode-aware só a neutra: `resolve(level, dark: theme.isDark)`. Brand não
/// reage ao tema (a marca continua "acesa" no escuro, igual um logo), então
/// não entra no enum de nível.
enum DilettaElevationLevel { low, medium, soft, overlay }

class DilettaElevation {
  DilettaElevation._();

  // ─── Neutra (preto) — superfícies ────────────────────────────────────────

  // Inversão L3: as shadows estáticas consomem o gerado (DilettaElevationConsts,
  // de tokens/elevation.tokens.json). Dark, funções e resolve() seguem no Dart.

  /// Card / nav base. black@13 · (0,2) · blur 8.
  static const List<BoxShadow> low = DilettaElevationConsts.low;

  /// Card flutuante / bottom bar / chat bar. black@13 · (5,4) · blur 20.
  static const List<BoxShadow> medium = DilettaElevationConsts.medium;

  /// Toast. black@8 · (0,4) · blur 10 (mais leve, feedback flutuante).
  static const List<BoxShadow> soft = DilettaElevationConsts.soft;

  /// Tooltip / popover. black@20 · (0,4) · blur 12.
  static const List<BoxShadow> overlay = DilettaElevationConsts.overlay;

  /// Overlay grande (dev inspect / popover largo). black@20 · (0,4) · blur 16.
  static const List<BoxShadow> overlayLg = DilettaElevationConsts.overlayLg;

  /// Tecla do numpad (pressionada). black@18 · (0,1) · sem blur.
  static const List<BoxShadow> keyPress = DilettaElevationConsts.keyPress;

  // ─── Brand lift — a FORMA é do pai, a COR é do filho ─────────────────────
  //
  // As cinco de baixo eram `const` geradas do DTCG deste repo, com o azul do CPF
  // SEGURO dentro (`#003BE0` e um `#2157EF` que nem existe mais na paleta dele).
  // Nome do pai, valor de filho — o mesmo furo que os gradientes tiveram, e pelo
  // mesmo caminho: sombra não era olhada por nenhum gate.
  //
  // O que isso fazia, medido: a Aurora (âmbar) renderizava botão de chat, banner,
  // card de conclusão e item de nav com sombra AZUL. Não quebrava nada — só entregava
  // a marca do primeiro filho pra quem não é ele.
  //
  // O alpha, o offset e o blur são linguagem e ficam aqui. A cor entra por paleta.

  /// Chat button. primary-04@18 · (0,2) · blur 8.
  static List<BoxShadow> brandLowDe(DilettaPalette p) => [
        BoxShadow(color: p.primary04.withValues(alpha: 0.18), offset: const Offset(0, 2), blurRadius: 8),
      ];

  /// Banner "PARA VOCÊ". primary-05@40 · (2,8) · blur 20.
  static List<BoxShadow> brandMediumDe(DilettaPalette p) => [
        BoxShadow(color: p.primary05.withValues(alpha: 0.40), offset: const Offset(2, 8), blurRadius: 20),
      ];

  /// Chat completion card. primary-05@32 · (0,12) · blur 40.
  static List<BoxShadow> brandHighDe(DilettaPalette p) => [
        BoxShadow(color: p.primary05.withValues(alpha: 0.32), offset: const Offset(0, 12), blurRadius: 40),
      ];

  /// Nav item ativo (glow suave da marca). primary-04@18 · (0,4) · blur 10.
  static List<BoxShadow> brandSoftDe(DilettaPalette p) => [
        BoxShadow(color: p.primary04.withValues(alpha: 0.18), offset: const Offset(0, 4), blurRadius: 10),
      ];

  /// Glow da marca no item ativo da bottom nav. primary-04@35 · (0,2) · blur 10.
  static List<BoxShadow> navGlowDe(DilettaPalette p) => [
        BoxShadow(color: p.primary04.withValues(alpha: 0.35), offset: const Offset(0, 2), blurRadius: 10),
      ];

  /// Footer ancorado — sombra pra CIMA. neutral-01@5 · (0,-4) · blur 10.
  static List<BoxShadow> footerUpDe(DilettaPalette p) => [
        BoxShadow(color: p.neutral01.withValues(alpha: 0.05), offset: const Offset(0, -4), blurRadius: 10),
      ];

  // ─── Receitas do app (produção) — fonte única do bridge do app ───────────

  /// Sopro sutil (bolha de chat / instrução). black@2 · (0,2) · blur 5.
  /// (App `Shadows.soft`; renomeado p/ não colidir com [soft].)
  static const List<BoxShadow> subtle = DilettaElevationConsts.subtle;

  /// Input flutuante (barras/campos do onboarding). black@10 · (5,4) · blur 20.
  static const List<BoxShadow> input = DilettaElevationConsts.input;

  /// Botão de ícone flutuante (pesada). black@50 · (0,4) · blur 10.
  static const List<BoxShadow> heavy = DilettaElevationConsts.heavy;

  /// Lift de card-herói — a cor acompanha o gradiente. base@35 · (0,10) · blur 24.
  static List<BoxShadow> heroLift(Color base) => [
        BoxShadow(color: base.withValues(alpha: 0.35), offset: const Offset(0, 10), blurRadius: 24),
      ];

  /// Lift compacto dos level cards. base@40 · (2,8) · blur 24.
  static List<BoxShadow> cardLift(Color base) => [
        BoxShadow(color: base.withValues(alpha: 0.4), offset: const Offset(2, 8), blurRadius: 24),
      ];

  // ─── Dark (1ª versão) — neutra aprofunda; brand mantém ───────────────────

  static const List<BoxShadow> _lowDark = [
    BoxShadow(color: DilettaAbsoluteColors.blackAlpha40, offset: Offset(0, 2), blurRadius: 8),
  ];
  static const List<BoxShadow> _mediumDark = [
    BoxShadow(color: DilettaAbsoluteColors.blackAlpha40, offset: Offset(5, 4), blurRadius: 20),
  ];
  static const List<BoxShadow> _softDark = [
    BoxShadow(color: DilettaAbsoluteColors.blackAlpha20, offset: Offset(0, 4), blurRadius: 10),
  ];
  static const List<BoxShadow> _overlayDark = [
    BoxShadow(color: DilettaAbsoluteColors.blackAlpha40, offset: Offset(0, 4), blurRadius: 12),
  ];

  /// Resolve nível + modo. Só a família NEUTRA passa por aqui: brand não reage ao
  /// tema, e sombra de marca precisa de paleta — `brandLowDe(p)` e companhia.
  static List<BoxShadow> resolve(DilettaElevationLevel level, {bool dark = false}) {
    switch (level) {
      case DilettaElevationLevel.low:
        return dark ? _lowDark : low;
      case DilettaElevationLevel.medium:
        return dark ? _mediumDark : medium;
      case DilettaElevationLevel.soft:
        return dark ? _softDark : soft;
      case DilettaElevationLevel.overlay:
        return dark ? _overlayDark : overlay;
    }
  }
}
