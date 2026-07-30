import 'package:flutter/material.dart';

import 'generated/cps_duration_tokens.g.dart';

/// CPF SEGURO — Metrics.
///
/// Spacing, radii e durations reutilizados no DS. Base 4 (Material/Apple).
class DilettaSpacing {
  DilettaSpacing._();

  /// 2 — micro (offset de badge, ajuste fino). Meio-passo.
  static const double s0_5 = 2;

  /// 4
  static const double s1 = 4;

  /// 6 — gap apertado (entre 4 e 8). Meio-passo.
  static const double s1_5 = 6;

  /// 8
  static const double s2 = 8;

  /// 12
  static const double s3 = 12;

  /// 16 — screen edge padding padrão.
  static const double s4 = 16;

  /// 20
  static const double s5 = 20;

  /// 24 — screen edge padding "confortável" (formulários).
  static const double s6 = 24;

  /// 32
  static const double s8 = 32;

  /// 40
  static const double s10 = 40;

  /// 48
  static const double s12 = 48;

  // ─── Escala estendida (alinhada ao Figma · Spacing 16–64) ────────────────
  /// 64
  static const double s16 = 64;

  /// 80
  static const double s20 = 80;

  /// 96
  static const double s24 = 96;

  /// 128
  static const double s32 = 128;

  /// 160
  static const double s40 = 160;

  /// 192
  static const double s48 = 192;

  /// 224
  static const double s56 = 224;

  /// 256
  static const double s64 = 256;
}

/// Radii comuns.
///
/// **Escala alinhada ao Figma** (Corner radius): `0 · 2 · 4 · 8 · 16 · 24 · 32 ·
/// 40 · 56` + `pill 200` (este último é adição do código, não existe no Figma).
/// Preferir os aliases semânticos (chatBubble, card, sheet, pill). Antes o time
/// restringia a `2·8·16·24·200`; ampliado pra bater com as Variables do Figma.
class DilettaRadius {
  DilettaRadius._();

  // ─── Escala numérica ────────────────────────────────────────────────────

  /// 0 — canto reto (âncora de ChatBubble, listas coladas).
  static const Radius r0 = Radius.circular(0);
  static const BorderRadius all0 = BorderRadius.all(r0);

  /// 2 — battery indicator, dashed dividers, battery frame.
  static const Radius r2 = Radius.circular(2);
  static const BorderRadius all2 = BorderRadius.all(r2);

  /// 4 — micro-cantos (Figma Corner radius 2).
  static const Radius r4 = Radius.circular(4);
  static const BorderRadius all4 = BorderRadius.all(r4);

  /// 8 — checkbox, numpad key, amountChip, small containers.
  static const Radius r8 = Radius.circular(8);
  static const BorderRadius all8 = BorderRadius.all(r8);

  /// 16 — cards, MenuButton horizontal.
  static const Radius r16 = Radius.circular(16);
  static const BorderRadius all16 = BorderRadius.all(r16);

  /// 24 — bottomsheets, cards grandes, AppListGroup, BottomNav item ativo,
  /// ChatButton, ChatCompletionCard, ChatInput.
  static const Radius r24 = Radius.circular(24);
  static const BorderRadius all24 = BorderRadius.all(r24);

  /// 32 — containers grandes (Figma Corner radius 6).
  static const Radius r32 = Radius.circular(32);
  static const BorderRadius all32 = BorderRadius.all(r32);

  /// 40 — cantos do nav flutuante (pop-out da BottomApp). Corner assinatura,
  /// maior que card/sheet pra dar leveza ao balão que descola da tela.
  static const Radius r40 = Radius.circular(40);
  static const BorderRadius all40 = BorderRadius.all(r40);

  /// 56 — superfícies extra-arredondadas (Figma Corner radius 8).
  static const Radius r56 = Radius.circular(56);
  static const BorderRadius all56 = BorderRadius.all(r56);

  /// 200 — pill radius (StatusTag, Button, chips, IconButton pill).
  static const Radius r200 = Radius.circular(200);
  static const BorderRadius all200 = BorderRadius.all(r200);

  // ─── Escala em double (logical px) — mesma dos rN ────────────────────────
  // Pro bridge do app (que usa raio como double) e pro DS web (CSS). const-safe.
  static const double px0 = 0;
  static const double px2 = 2;
  static const double px4 = 4;
  static const double px8 = 8;
  static const double px16 = 16;
  static const double px24 = 24;
  static const double px32 = 32;
  static const double px40 = 40;
  static const double px56 = 56;
  static const double px200 = 200;

  // ─── Aliases semânticos (preferir estes) ────────────────────────────────

  /// Pill (=200) — Button, chips, IconButton.
  static const Radius pill = r200;
  static const BorderRadius pillAll = all200;

  /// Radius das cantos "livres" de ChatBubble (24).
  static const Radius chatBubble = r24;

  /// Radius do canto âncora de ChatBubble (0 — apontado pra fonte da fala).
  static const Radius chatAnchor = Radius.circular(0);

  /// Chat button e completion card (24).
  static const Radius chatButton = r24;

  /// Card padrão (16).
  static const Radius card = r16;

  /// Bottomsheet e AppListGroup (24).
  static const Radius sheet = r24;
}

/// Par (duração, curva) de um contexto de motion. É o que um componente
/// consome — nunca um `Duration`/`Curve` solto. Legível pra IA: "esta transição
/// usa o motion `sheet`", não "250ms easeOut".
class DilettaMotionSpec {
  const DilettaMotionSpec(this.duration, this.curve);
  final Duration duration;
  final Curve curve;
}

/// CPF SEGURO — Motion.
///
/// Fonte única do movimento. Três camadas:
/// - **Duração** — escala fixa (micro→deliberate). Sem `Duration(...)` solto.
/// - **Curva** — easing semântico (enter/exit/standard/emphasized). Extraído do
///   uso real do app (easeOut domina a entrada, easeIn a saída).
/// - **Contexto** — [DilettaMotionSpec] que amarra duração+curva por caso de
///   uso (fade, sheet, page, toast, control, emphasis). É o que os componentes
///   consomem.
///
/// Os presets ([DilettaAnimation]) e a [DilettaScreenTransition] consomem
/// estes tokens — mudar o movimento do DS = editar aqui, um lugar só.
class DilettaMotion {
  DilettaMotion._();

  // ── Duração (ms) ──────────────────────────────────────────────────────────
  // Inversão L3: as durações consomem o gerado (DilettaDurationConsts, de
  // tokens/duration.tokens.json). Curvas (Curves.*) e specs seguem no Dart.
  /// 120 — micro: hover, transição de cor.
  static const Duration micro = DilettaDurationConsts.micro;

  /// 150 — curto: toggle thumb, focus ring, fade/scrim.
  static const Duration short = DilettaDurationConsts.short;

  /// 250 — médio (default): sheet, toast, a maioria das transições.
  static const Duration medium = DilettaDurationConsts.medium;

  /// 400 — longo: superfícies maiores, transição de página/push.
  static const Duration slow = DilettaDurationConsts.slow;

  /// 600 — deliberado: hero, ênfase. Raro.
  static const Duration deliberate = DilettaDurationConsts.deliberate;

  /// 700 — loop do spinner (1 volta). Não é transição.
  static const Duration spinner = DilettaDurationConsts.spinner;

  /// 1500 — loop do shimmer (sweep do skeleton). Não é transição.
  static const Duration shimmer = DilettaDurationConsts.shimmer;

  // ── Curva (easing) ────────────────────────────────────────────────────────
  /// Elemento CHEGANDO (desacelera) — o mais comum. Curves.easeOut.
  static const Curve enter = Curves.easeOut;

  /// Elemento SAINDO (acelera). Curves.easeIn.
  static const Curve exit = Curves.easeIn;

  /// Move on-screen (começa e termina visível). Curves.easeInOut.
  static const Curve standard = Curves.easeInOut;

  /// Ênfase/hero (desaceleração forte). Curves.easeOutCubic.
  static const Curve emphasized = Curves.easeOutCubic;

  // ── Contexto (duração + curva) ──────────────────────────────────────────────
  /// Fade/scrim de overlay.
  static const DilettaMotionSpec fade = DilettaMotionSpec(short, enter);

  /// Bottomsheet subindo.
  static const DilettaMotionSpec sheet = DilettaMotionSpec(medium, enter);

  /// Toast/notificação do topo.
  static const DilettaMotionSpec toast = DilettaMotionSpec(medium, enter);

  /// Transição de página/push horizontal.
  static const DilettaMotionSpec page = DilettaMotionSpec(slow, standard);

  /// Controle (toggle, checkbox, focus) — settla desacelerando.
  static const DilettaMotionSpec control = DilettaMotionSpec(short, enter);

  /// Ênfase/hero.
  static const DilettaMotionSpec emphasis =
      DilettaMotionSpec(deliberate, emphasized);
}
