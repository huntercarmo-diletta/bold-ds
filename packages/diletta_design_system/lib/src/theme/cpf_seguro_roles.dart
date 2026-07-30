import 'dart:math' as math;
import 'package:flutter/painting.dart' show Color;
import 'cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_scheme.dart';

/// CPF SEGURO — Roles (camada semântica / o "significado").
///
/// Um role não é uma cor: é um pacote de intenção (cor + on-color + subtle +
/// ícone default), resolvido a partir do [DilettaScheme]. É o dicionário da
/// linguagem — "vermelho = erro" mora aqui. Componentes devem consumir role,
/// nunca cor crua. Ver spec `openspec/specs/design-system-semantic-roles` e
/// `DS_LANGUAGE.md` §1.
///
/// Aditivo: reusa os campos que o Scheme já expõe (primary/success/warning/
/// error/secure + on/subtle). Não recria tokens.
enum DilettaRole { primary, neutral, success, warning, danger, secure }

/// Pacote resolvido de um role.
class DilettaRoleStyle {
  const DilettaRoleStyle({
    required this.color,
    required this.onColor,
    required this.subtle,
    required this.onSubtle,
    this.icon,
  });

  /// Cor sólida do role (fill / acento).
  final Color color;

  /// Conteúdo (texto/ícone) sobre [color]. Nunca escolher manualmente.
  final Color onColor;

  /// Conteúdo sobre [subtle] — o par que faltava. Usar [color] como texto sobre
  /// [subtle] deixava tag de warning em 2.16:1 e de secure em 1.79:1: um token
  /// não serve duas exigências de contraste ao mesmo tempo.
  final Color onSubtle;

  /// Tinte suave pra fundos sutis.
  final Color subtle;

  /// Ícone default do role (token string de [DilettaIcons]). Null = sem ícone
  /// canônico (ex: primary).
  final String? icon;
}

/// Resolve roles a partir do scheme corrente.
abstract final class DilettaRoles {
  /// Todos os roles, na ordem canônica de exibição.
  static const List<DilettaRole> all = DilettaRole.values;

  static DilettaRoleStyle of(DilettaScheme s, DilettaRole role) {
    final (Color color, Color subtle, Color onSubtle, String? icon) =
        switch (role) {
      DilettaRole.primary =>
        (s.primary, s.primarySubtle, s.onPrimarySubtle, null),
      DilettaRole.neutral => (
          s.textSecondary,
          s.surfaceMuted,
          // Neutro: o texto sobre `surfaceMuted` é o próprio texto da tela.
          s.fg,
          DilettaIcons.circleInfoLight
        ),
      DilettaRole.success => (
          s.success,
          s.successSubtle,
          s.onSuccessSubtle,
          DilettaIcons.circleCheckLight
        ),
      DilettaRole.warning => (
          s.warning,
          s.warningSubtle,
          s.onWarningSubtle,
          DilettaIcons.triangleExclamationLight
        ),
      DilettaRole.danger => (
          s.error,
          s.errorSubtle,
          s.onErrorSubtle,
          DilettaIcons.triangleExclamationLight
        ),
      DilettaRole.secure => (
          s.secure,
          s.secureSubtle,
          s.onSecureSubtle,
          DilettaIcons.lockLight
        ),
    };
    // On-color é propriedade do role: escolhe branco vs ink pelo maior contraste
    // sobre o fill. Garante legibilidade mesmo em roles amarelos (warning/secure),
    // onde os on* do scheme não garantem AA sobre o sólido.
    return DilettaRoleStyle(
      color: color,
      onColor: _bestOn(color),
      subtle: subtle,
      onSubtle: onSubtle,
      icon: icon,
    );
  }

  static Color _bestOn(Color bg) {
    const white = Color(0xFFFFFFFF);
    const ink = Color(0xFF3D3939); // neutral-01
    return cpfSeguroContrastRatio(bg, white) >= cpfSeguroContrastRatio(bg, ink)
        ? white
        : ink;
  }

  /// Nome legível do role.
  static String label(DilettaRole role) => role.name;
}

// ═══════════════════════════════════════════════════════════════════════════
// Contraste (WCAG 2.x) — usado pelo catálogo e pelo teste de gate (V4)
// ═══════════════════════════════════════════════════════════════════════════

/// Razão de contraste WCAG entre duas cores (1.0 a 21.0).
double cpfSeguroContrastRatio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Alvos WCAG AA. `normal` = texto normal (4.5:1). `large` = texto grande /
/// componentes de UI / ícones (3:1).
const double cpfSeguroContrastAANormal = 4.5;
const double cpfSeguroContrastAALarge = 3.0;

double _luminance(Color c) {
  // `c.r/g/b` são 0..1 (float, wide-gamut). Antes eram `c.red/green/blue` em 0..255 e o
  // `chan` dividia por 255 — os três estão DEPRECIADOS e vão ser removidos, o que faria
  // este arquivo parar de compilar numa atualização de Flutter.
  //
  // O resultado é o mesmo: a divisão por 255 saiu porque a entrada já vem normalizada.
  // `roles_contrast_test` é quem confirma que nenhum papel mudou de veredito.
  double chan(double s) =>
      s <= 0.03928 ? s / 12.92 : math.pow((s + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * chan(c.r) + 0.7152 * chan(c.g) + 0.0722 * chan(c.b);
}
