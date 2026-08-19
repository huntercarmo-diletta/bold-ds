/// CONTA BOLD — o ESQUEMA, e ele saiu do app em 19/08.
///
/// Os catorze papéis mode-aware deste produto: superfície, texto, borda e os papéis de marca que
/// viram entre claro e escuro. As cores estáveis moram em [BoldColors]; estas leem-se por
/// `BoldColors.of(context)`, que é o `ThemeExtension` que o tema registra.
///
/// **Por que ele mora AQUI e não no app**: enquanto o esquema morava lá, o app não podia receber
/// o `ThemeData` pronto do pacote — o tema precisa registrar a extensão, e a extensão era do app.
/// Era a peça que trancava a porta por dentro. E ele nunca foi decisão de aplicação: onze dos
/// catorze papéis do escuro e nove dos catorze do claro **derivam do `DilettaScheme`** do pai; o
/// que sobra são decisões de MARCA do Bold, que é exatamente o que um DS filho existe pra dizer.
///
/// A classe manteve o nome. Os ~400 sítios que chamam `BoldColors.of(context).surface` no app não
/// souberam da mudança, e é assim que uma mudança de dono deve chegar.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';

import 'bold_palette.dart';

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
    required this.textSecondary,
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
  /// A RAMPA DE TEXTO, e ela tem TRÊS degraus desde 17/08 — os mesmos papéis que a linguagem tem.
  ///
  /// Eram seis. Os três do meio (`textBody`, `textBodySoft`, `textLabel`) somavam **10 usos em
  /// 784**, todos dentro do próprio `design_system/`, e a medição mostrou que eles não eram
  /// decisão:
  ///
  /// | par | distância no ESCURO | no CLARO |
  /// |---|---|---|
  /// | `textBodySoft` → `textLabel` | **1,09** | 2,56 |
  /// | `textLabel` → `textSecondary` | **1,09** | 1,55 |
  /// | `textPrimary` → `textBody` | 1,21 | 1,25 |
  ///
  /// Dois degraus a 9% de distância não se distinguem em tela nenhuma. E o `label` fazia pior:
  /// no escuro ele é mais CLARO que o secundário (11,15 contra 10,24), no claro é mais ESCURO
  /// (3,23 contra 5,00) — **os dois trocam de ordem entre os temas**, o que é defeito e não
  /// escolha.
  ///
  /// Ficaram os três que o `DilettaScheme` também tem: `fg` · `textSecondary` · `textMuted`.
  final Color textPrimary, textSecondary, textMuted;
  final Color border, borderSoft, borderStrong;

  /// Legibility wash sobre a imagem de fundo.
  final Color overlay;

  /// Papéis de marca/estado (resolvem por modo — o componente usa o papel, não
  /// o primitivo). Dark = shades claros/vibrantes; light = shades profundos.
  final Color primary, onPrimary, primaryPressed, primaryWash;
  final Color danger, success, warning, info;

  bool get isDark => brightness == Brightness.dark;

  /// O ESCURO — **e onze dos catorze papéis vêm do `DilettaScheme` desde 17/08.**
  ///
  /// Este bloco era `const` com 25 hex escritos à mão, ao lado de um `DilettaScheme` que resolve
  /// os mesmos papéis a partir da paleta do filho. Duas fontes pro mesmo valor é a definição de
  /// drift esperando acontecer, e o `border` provou: ele e o do pai eram `0x14FFFFFF` hex por hex,
  /// por caminhos separados.
  ///
  /// A troca custou o `const`. É o preço certo: `const` aqui congelava a decisão no app, e a
  /// decisão é do DS.
  ///
  /// **Os três que NÃO derivam, com o número de cada um:**
  ///
  /// - `primary`: aqui `primary04` (`#FE3976`), no scheme `primary05` (`#F66FA0`). O pai clareia a
  ///   marca no escuro de propósito — *"a marca precisa pulsar no dark"*. Este produto usa o 04, e
  ///   trocar mexe na cor da marca em toda tela;
  /// - `onPrimary`: aqui branco, no scheme **preto**. E o preto dele é medido: branco sobre o 05
  ///   dá 2,73:1. Como aqui a marca é o 04, o par é outro — mas o número dele fica como aviso de
  ///   que este par também precisa ser medido no dia em que o 05 entrar;
  /// - `primaryWash`: alpha da marca a 20%, contra o `primarySubtle` SÓLIDO do pai. Fill
  ///   translúcido e fill sólido são materiais diferentes, não versões.
  factory BoldScheme.dark() {
    final d = DilettaScheme.dark(BoldPalette.bold);
    return BoldScheme(
      brightness: Brightness.dark,
      background: d.bg,
      surface: d.surface,
      field: d.surfaceMuted,
      textPrimary: d.fg,
      textSecondary: d.textSecondary,
      textMuted: d.textMuted,
      border: d.border,
      primaryPressed: d.primaryPressed,
      danger: d.error,
      success: d.success,
      warning: d.warning,
      // ── daqui pra baixo, o que a linguagem não diz (ou diz outra coisa) ──
      primary: const Color(0xFFFE3976), // primary04, e o scheme diz 05
      onPrimary: const Color(0xFFFFFFFF),
      primaryWash: const Color(0x33FE3976), // alpha 20%, e o subtle do pai é sólido
      secondaryFlow: const Color(0xFF100913), // wine-ink dos fluxos secundários
      surfaceRaised: const Color(0xFF1A1B27),
      surfacePressed: const Color(0xFF2A2C3A),
      borderSoft: const Color(0x12FFFFFF),
      borderStrong: const Color(0x2EFFFFFF),
      overlay: const Color(0xB30A0B12),
      info: const Color(0xFF3B82F6),
    );
  }

  /// O CLARO — **nove dos catorze derivam desde 18/08**, e os cinco que ficam têm número.
  ///
  /// Eram cinco derivando. O pedido do espelho fechou na `ds v0.111.0` e o filho declarou os
  /// quatro campos do claro, então `textSecondary`, `textMuted` e `border` entraram — e o
  /// `textMuted` entrou consertado: ele estava em **2,96** sobre a superfície, abaixo do piso de
  /// texto grande, e agora é **3,54**. Foi a régua que este filho apontou pro pai no escuro que
  /// acusou o defeito aqui dentro.
  ///
  /// **Os cinco que não derivam, com o número de cada um** (contraste sobre o branco):
  ///
  /// - `primary`: aqui `primary03` (**8,03**), no scheme `primary04` (**3,46**). O claro deste
  ///   produto usa os degraus PROFUNDOS porque o fundo é branco — link e rótulo de CTA no 04
  ///   reprovariam. A derivação do pai não está errada: ela é neutra e serve quem não declara;
  /// - `danger`: `error03` (**6,57**) contra `error04` (**3,68**), mesma razão;
  /// - `onPrimary`: branco aqui, preto no scheme — consequência do par acima, e o preto dele é
  ///   medido pro 04;
  /// - `primaryPressed`: `primary02` contra o `stateSelected` dele, que é um wash;
  /// - `background`: `#F4F3F6` contra branco puro. A página deste produto não é a superfície.
  ///
  /// Os dois primeiros são caso do eixo `ajustesDePapel` (motivo `contraste`) que o pai abriu na
  /// `v0.77.0`. É o próximo pedido, e ele vai com os pares medidos.
  factory BoldScheme.light() {
    final d = DilettaScheme.light(BoldPalette.bold);
    return BoldScheme(
      brightness: Brightness.light,
      surface: d.surface,
      textPrimary: d.fg,
      success: d.success,
      warning: d.warning,
      primaryWash: d.primarySubtle,
      textSecondary: d.textSecondary,
      textMuted: d.textMuted,
      border: d.border,
      // ── os cinco que divergem, com o número no `///` acima ──
      background: const Color(0xFFF4F3F6), // a página não é a superfície
      field: const Color(0xFFF1F0F4), // o do pai é neutral09
      primary: const Color(0xFF9E1241), // primary03 (8,03); o do pai é o 04 (3,46)
      onPrimary: const Color(0xFFFFFFFF), // o do pai é preto
      primaryPressed: const Color(0xFF600627), // primary02; o do pai é o stateSelected
      danger: const Color(0xFFB42318), // error03 (6,57); o do pai é o 04 (3,68)
      // ── e os que a linguagem não tem, iguais nos dois modos ──
      secondaryFlow: const Color(0xFFF6F3F5),
      surfaceRaised: const Color(0xFFFFFFFF),
      surfacePressed: const Color(0xFFE8E7EE),
      borderSoft: const Color(0x0D000000),
      borderStrong: const Color(0x24000000),
      overlay: const Color(0xD9F4F3F6),
      info: const Color(0xFF3B82F6),
    );
  }

  @override
  BoldScheme copyWith({Brightness? brightness}) => this;

  @override
  BoldScheme lerp(ThemeExtension<BoldScheme>? other, double t) {
    if (other is! BoldScheme) return this;
    return t < 0.5 ? this : other;
  }
}
