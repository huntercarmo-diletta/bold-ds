import 'package:flutter/material.dart';
import 'generated/cps_type_tokens.g.dart';

/// CPF SEGURO — Typography.
///
/// Escala M3 completa (15 estilos: display/headline/title/body/label × lg/md/sm),
/// paridade 1:1 com o React (~/Desktop/cpf-seguro-app/src/styles/type.css).
///
/// Cores NÃO estão embutidas — aplique via `.copyWith(color: ...)` no callsite
/// (só `headline`, `body` e `eyebrow` — os presets do PageTitle/MenuSection —
/// já vêm coloridos por conveniência).
class DilettaType {
  DilettaType._();

  // ============ DISPLAY — hero screens, marketing ==========================
  // Inversão L3: a escala M3 + vozes limpas consomem o gerado do DTCG
  // (DilettaTypeConsts, de tokens/type.tokens.json).
  static const TextStyle displayLg = DilettaTypeConsts.displayLg;
  static const TextStyle displayMd = DilettaTypeConsts.displayMd;
  static const TextStyle displaySm = DilettaTypeConsts.displaySm;

  // ============ HEADLINE — títulos de seção grandes (w600, = app) ==========
  static const TextStyle headlineLg = DilettaTypeConsts.headlineLg;
  static const TextStyle headlineMd = DilettaTypeConsts.headlineMd;
  static const TextStyle headlineSm = DilettaTypeConsts.headlineSm;

  // ============ TITLE — títulos de screen/card =============================
  static const TextStyle titleLg = DilettaTypeConsts.titleLg;
  static const TextStyle titleMd = DilettaTypeConsts.titleMd;
  static const TextStyle titleSm = DilettaTypeConsts.titleSm;

  // ============ BODY — texto de leitura ====================================
  static const TextStyle bodyLg = DilettaTypeConsts.bodyLg;
  static const TextStyle bodyMd = DilettaTypeConsts.bodyMd;
  static const TextStyle bodySm = DilettaTypeConsts.bodySm;

  // ============ LABEL — botões, chips, eyebrows ============================
  /// Card titles ("Sou eu!", "CPF Seguro") — SF Pro Rounded Semibold.
  static const TextStyle labelLg = DilettaTypeConsts.labelLg;

  /// Section headers ("PARA VOCÊ"), "Ver todos".
  static const TextStyle labelMd = DilettaTypeConsts.labelMd;

  /// Banner chip "Nível 1 de 3", banner eyebrow, status tags, tile labels.
  static const TextStyle labelSm = DilettaTypeConsts.labelSm;

  // ═══════════════════════════════════════════════════════════════════════
  // VOZES — a API semântica (Apple-style: um nome por degrau). Cor SEMPRE do
  // scheme. A escala M3 acima é o "alfabeto"; estas são as "palavras".
  // Leitura usa a escala direto: bodyLg (16) e bodyMd (14) são as vozes de body.
  // ═══════════════════════════════════════════════════════════════════════

  /// Herói · valores grandes · celebração (raro).
  static const TextStyle display = DilettaTypeConsts.display;

  /// Título de tela (h1).
  static const TextStyle title = DilettaTypeConsts.title;

  /// Título de seção / card.
  static const TextStyle heading = DilettaTypeConsts.heading;

  /// Sub-bloco · destaque forte ("Sou eu!").
  static const TextStyle subheading = DilettaTypeConsts.subheading;

  /// Legenda · metadados · timestamps.
  static const TextStyle caption = DilettaTypeConsts.caption;

  /// Rótulo de UI · chips · tags (tracked).
  static const TextStyle label = DilettaTypeConsts.label;

  /// Kicker de seção — aplicar `.toUpperCase()`.
  static const TextStyle overline = DilettaTypeConsts.overline;

  /// Texto de ação / CTA.
  static const TextStyle button = DilettaTypeConsts.button;

  /// Figuras tabulares — OTP · valores.
  static const TextStyle numeric = TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1, letterSpacing: 0.5, fontFeatures: [FontFeature.tabularFigures()]);

  /// Figuras tabulares em DEGRAU PEQUENO — dado técnico dentro de linha (CPF mascarado, chave,
  /// valor em lista).
  ///
  /// Promoção por evidência de DOIS filhos, que é a regra: os dois chegaram sozinhos à mesma
  /// conclusão — dado técnico é a fonte da marca com dígitos TABULARES, não outra família. O pai já
  /// tinha `numeric`, mas só em 22; o segundo filho usa 13 e 11, e sem os degraus ele teria que
  /// recriar o estilo no filho — que é como uma família de tipografia se parte em duas.
  ///
  /// Tabular importa aqui mais que no 22: numa lista, dígito de largura variável faz a coluna
  /// dançar entre as linhas.
  static const TextStyle numericSm = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.2, letterSpacing: 0.2, fontFeatures: [FontFeature.tabularFigures()]);

  static const TextStyle numericXs = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.2, letterSpacing: 0.2, fontFeatures: [FontFeature.tabularFigures()]);

  /// Relógio / system (status bar).
  static const TextStyle mono = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1, letterSpacing: -0.14);

  /// Corpo de bolha de chat (negrito é identidade — decisão do time).
  static const TextStyle chatBody = TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.4);

  // ============ PROTOTIPAGEM (numpad — fora do léxico: o app usa teclados
  // nativos; isto só existe pra reproduzir telas no catálogo) ===============

  /// Numpad key digit — 24 · height 1 · ls 0.5.
  // SEM cor, como todo estilo deste arquivo. Tinha `neutral01` cravada e era
  // código morto: o teclado, único consumidor, já fazia `.copyWith(color: s.fg)`.
  // Uma cor que nunca pinta ainda assim é dívida — vira exemplo pro próximo.
  static const TextStyle numpadDigit = TextStyle(
    fontSize: 24,
    height: 1,
    letterSpacing: 0.5,
  );

  /// Numpad key sub-label (ABC, DEF…) — 9 · 500 · ls 1.5.
  static const TextStyle numpadSubLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );
}
