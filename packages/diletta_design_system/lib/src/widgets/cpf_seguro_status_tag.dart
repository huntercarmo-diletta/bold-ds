import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// Tom semântico da StatusTag.
enum DilettaStatusTone { warning, neutral, primary, success, danger, secure }

/// Data holder pra passar uma StatusTag como prop (ex.: slot right do AppList).
class DilettaStatusTagData {
  const DilettaStatusTagData({required this.label, required this.tone, this.icon});
  final String label;
  final DilettaStatusTone tone;
  final String? icon;
}

/// CPF SEGURO — StatusTag.
///
/// Pill 20px de altura com border 0.5px, opcional icon accessory 12px à
/// esquerda + label label-sm. 6 tones (bg + border + text por semântica).
///
/// ```dart
/// DilettaStatusTag(label: 'Pendente', tone: DilettaStatusTone.warning),
/// DilettaStatusTag(label: 'CPF Seguro', tone: DilettaStatusTone.primary, icon: DilettaIcons.shieldUserSolidFull),
/// ```
class DilettaStatusTag extends StatelessWidget {
  const DilettaStatusTag({
    super.key,
    required this.label,
    this.tone = DilettaStatusTone.neutral,
    this.icon,
  });

  final String label;
  final DilettaStatusTone tone;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final t = _toneSpec(tone, DilettaTheme.schemeOf(context));
    return DilettaDevInfo(
      component: 'DilettaStatusTag',
      props: {
        'label': "'$label'",
        'tone': tone.name,
        if (icon != null) 'icon': icon!,
      },
      tokens: [
        'bg: ${nomeDoToken(context, t.bg)}',
        'text: ${nomeDoToken(context, t.color)} · labelSm 11/500',
        'h 20 · radius pill · border 0.5',
      ],
      child: Container(
      height: 20,
      // Tag: 4 esq · 8 dir, align left. Icon accessory 12 (glyph 8 pelo
      // padding 2 do accessory), spacing 4 pro label.
      padding: const EdgeInsets.only(left: DilettaSpacing.s1, right: DilettaSpacing.s2),
      decoration: BoxDecoration(
        color: t.bg,
        border: Border.all(color: t.border, width: 0.5),
        borderRadius: DilettaRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            DilettaIconAccessory(icon: icon!, size: 12, color: t.color),
          // Gap SEMPRE presente: sem ícone o label fica com 4(pad)+4=8 à
          // esquerda, batendo com os 8 da direita → balanceado. O "4 fica".
          const SizedBox(width: DilettaSpacing.s1),
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: DilettaType.labelSm.copyWith(color: t.color),
          ),
        ],
      ),
    ),
    );
  }
}

class _ToneSpec {
  const _ToneSpec({required this.bg, required this.border, required this.color});
  final Color bg;
  final Color border;
  final Color color;
}

_ToneSpec _toneSpec(DilettaStatusTone t, DilettaScheme s) {
  // Dark: o chip vira tint translúcido do próprio tom + texto/borda claros
  // (o tint sólido claro do light estouraria sobre a surface escura). A cor
  // "base" carrega a semântica; a expressão muda com o contexto — é o TOM.
  if (s.isDark) {
    final Color base = switch (t) {
      DilettaStatusTone.warning => s.warning,
      DilettaStatusTone.neutral => s.textSecondary,
      // primary05 (s.primary no dark) é azul médio — como TEXTO sobre o tint
      // escuro fica ilegível. Clareia pra primary06.
      DilettaStatusTone.primary => s.palette.primary06,
      DilettaStatusTone.success => s.success,
      DilettaStatusTone.danger => s.error,
      DilettaStatusTone.secure => s.secure,
    };
    return _ToneSpec(
      bg: base.withValues(alpha: 0.16),
      border: base.withValues(alpha: 0.45),
      color: base,
    );
  }
  // Light: tinte sólido (*07/*08) com a BORDA no passo de acento e o TEXTO no
  // passo que passa AA sobre o tinte.
  //
  // Era `color` = passo 04 (o mesmo da borda), e aí o rótulo em `labelSm` ficava
  // em 2.16:1 no warning e 1.79:1 no secure — texto amarelo em fundo amarelo,
  // medido pela conformidade em 2026-07-28. Borda é elemento GRÁFICO (mínimo 3.0)
  // e pode continuar no 04; texto é texto (mínimo 4.5).
  return switch (t) {
    DilettaStatusTone.warning => _ToneSpec(
        bg: s.palette.warning07,
        border: s.palette.warning04,
        color: s.palette.warning02), // 5.99 (era 2.16)
    DilettaStatusTone.neutral => _ToneSpec(
        bg: s.palette.white,
        border: s.palette.neutral05,
        color: s.palette.neutral02),
    DilettaStatusTone.primary => _ToneSpec(
        bg: s.palette.primary08,
        border: s.palette.primary04,
        color: s.palette.primary04), // 7.14 — já passava
    DilettaStatusTone.success => _ToneSpec(
        bg: s.palette.success07,
        border: s.palette.success04,
        color: s.palette.success03), // 6.36 (era 3.90)
    DilettaStatusTone.danger => _ToneSpec(
        bg: s.palette.error07,
        border: s.palette.error04,
        color: s.palette.error03), // 6.05 (era 3.46)
    DilettaStatusTone.secure => _ToneSpec(
        bg: s.palette.secure08,
        border: s.palette.secure03,
        color: s.palette.secure02), // 7.08 (era 1.79)
  };
}
