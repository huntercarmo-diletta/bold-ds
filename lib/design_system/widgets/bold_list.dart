import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_card.dart';
import 'bold_icon.dart';
import 'bold_status_tag.dart';

export 'bold_status_tag.dart';

/// Conta BOLD — list primitives (portados do "App list" do cpf-seguro).
///
/// [BoldListGroup] é o card que empilha [BoldListTile]s com hairline; cada tile
/// é `leading + título/subtítulo + trailing`. Leading típico: [BoldSpotIcon].
/// Trailing típico: chevron (default com onTap), [BoldListTime],
/// [BoldListTimeStatus], [BoldListAmount] ou uma [BoldStatusTag].

/// Tom do [BoldSpotIcon]. Semânticos usam as escalas (wash 07/08 + base 04).
/// `secure` = ouro de blindagem (CPF Seguro / selo quântico).
enum BoldSpotTone { primary, neutral, success, warning, danger, secure }

/// Conta BOLD — SpotIcon (átomo). Ícone circular tonalizado, leading canônico
/// de lista — também standalone (banners, alertas, KPIs).
///
/// **Eixos ortogonais:**
/// - `filled` inverte o tipo: `false` = wash tonal + glyph no tom (outline);
///   `true` = bg sólido no tom base + glyph branco (fill).
/// - `tone` dá a cor semântica (neutral/primary/success/warning/danger/secure).
/// - `disabled` neutraliza e rebaixa (não-interativo); `loading` troca o glyph
///   por um spinner tonal. `badge` = dot de atenção no canto. Todos combináveis.
///
/// ```dart
/// BoldSpotIcon('pix', tone: BoldSpotTone.primary);
/// BoldSpotIcon('circle-check-light', tone: BoldSpotTone.success, filled: true);
/// BoldSpotIcon('shield-user-solid-full', tone: BoldSpotTone.secure, loading: true);
/// ```
class BoldSpotIcon extends StatelessWidget {
  const BoldSpotIcon(
    this.icon, {
    super.key,
    this.tone = BoldSpotTone.neutral,
    this.filled = false,
    this.badge = false,
    this.disabled = false,
    this.loading = false,
    this.size = 38,
  });

  /// BoldIcon name (semantic alias ou svg cru).
  final String icon;
  final BoldSpotTone tone;

  /// `true` = bg sólido no tom base + glyph branco (destaque forte).
  final bool filled;

  /// Dot de atenção (danger) no canto superior direito.
  final bool badge;

  /// Estado não-interativo: neutraliza o tom e rebaixa a opacidade.
  final bool disabled;

  /// Troca o glyph por um spinner tonal (busy). Mantém o container do tom.
  final bool loading;

  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = BoldColors.of(context).isDark;
    final s = disabled
        ? _spotDisabled(filled, isDark)
        : _spotSpec(tone, filled, isDark);
    return Opacity(
      opacity: disabled ? 0.55 : 1.0,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: s.bg, shape: BoxShape.circle),
        child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (loading)
                SizedBox(
                  width: size * 0.42,
                  height: size * 0.42,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: s.fg),
                )
              else
                BoldIcon(icon, size: BoldIconSize.lg, color: s.fg),
              if (badge)
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: BoldColors.danger, shape: BoxShape.circle),
                  ),
                ),
            ]),
      ),
    );
  }
}

class _SpotSpec {
  const _SpotSpec(this.bg, this.fg);
  final Color bg;
  final Color fg;
}

/// Estado desabilitado: neutro rebaixado, independente do tom.
_SpotSpec _spotDisabled(bool filled, bool isDark) {
  if (filled) {
    return isDark
        ? const _SpotSpec(BoldColors.neutral02, BoldColors.neutral05)
        : const _SpotSpec(BoldColors.neutral08, BoldColors.neutral05);
  }
  return isDark
      ? _SpotSpec(BoldColors.white.withValues(alpha: 0.06), BoldColors.neutral04)
      : const _SpotSpec(BoldColors.neutral10, BoldColors.neutral06);
}

_SpotSpec _spotSpec(BoldSpotTone tone, bool filled, bool isDark) {
  if (filled) {
    // Filled colorido = base 04 sólido + glyph branco: aguenta light e dark.
    // Só o neutral precisa virar por tema (senão o cinza claro some no dark).
    return switch (tone) {
      BoldSpotTone.primary =>
        const _SpotSpec(BoldColors.primary04, BoldColors.white),
      BoldSpotTone.neutral => isDark
          ? const _SpotSpec(BoldColors.neutral02, BoldColors.neutral09)
          : const _SpotSpec(BoldColors.neutral09, BoldColors.neutral03),
      BoldSpotTone.success =>
        const _SpotSpec(BoldColors.success04, BoldColors.white),
      BoldSpotTone.warning =>
        const _SpotSpec(BoldColors.warning04, BoldColors.white),
      BoldSpotTone.danger =>
        const _SpotSpec(BoldColors.error04, BoldColors.white),
      BoldSpotTone.secure =>
        const _SpotSpec(BoldColors.secure04, BoldColors.white),
    };
  }
  // Não-filled = wash tonal. No dark os washes claros (07/08) viram borrões
  // pálidos sobre o fundo escuro; troca por um tint translúcido do tom base
  // (glyph no shade claro 05) que respira o fundo em vez de brilhar.
  if (isDark) {
    return switch (tone) {
      BoldSpotTone.primary => _SpotSpec(
          BoldColors.primary04.withValues(alpha: 0.20), BoldColors.primary05),
      BoldSpotTone.neutral => _SpotSpec(
          BoldColors.white.withValues(alpha: 0.10), BoldColors.neutral07),
      BoldSpotTone.success => _SpotSpec(
          BoldColors.success04.withValues(alpha: 0.20), BoldColors.success05),
      BoldSpotTone.warning => _SpotSpec(
          BoldColors.warning04.withValues(alpha: 0.20), BoldColors.warning05),
      BoldSpotTone.danger => _SpotSpec(
          BoldColors.error04.withValues(alpha: 0.20), BoldColors.error05),
      BoldSpotTone.secure => _SpotSpec(
          BoldColors.secure04.withValues(alpha: 0.20), BoldColors.secure05),
    };
  }
  return switch (tone) {
    BoldSpotTone.primary =>
      const _SpotSpec(BoldColors.primary08, BoldColors.primary04),
    BoldSpotTone.neutral =>
      const _SpotSpec(BoldColors.neutral09, BoldColors.neutral03),
    BoldSpotTone.success =>
      const _SpotSpec(BoldColors.success07, BoldColors.success03),
    BoldSpotTone.warning =>
      const _SpotSpec(BoldColors.warning07, BoldColors.warning03),
    BoldSpotTone.danger =>
      const _SpotSpec(BoldColors.error07, BoldColors.error03),
    BoldSpotTone.secure =>
      const _SpotSpec(BoldColors.secure07, BoldColors.secure03),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// Acessórios de trailing (moléculas) — hora, hora+status, valor
// ═══════════════════════════════════════════════════════════════════════════

/// Hora/tempo à direita da row ("14min", "12:04").
class BoldListTime extends StatelessWidget {
  const BoldListTime(this.time, {super.key});
  final String time;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Text(time,
        maxLines: 1,
        style:
            BoldType.bodySmall.copyWith(fontSize: 12, color: c.textSecondary));
  }
}

/// Hora em cima + [BoldStatusTag] embaixo (padrão de atividade recente).
class BoldListTimeStatus extends StatelessWidget {
  const BoldListTimeStatus(
      {super.key, required this.time, required this.status});
  final String time;
  final BoldStatusTagData status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        BoldListTime(time),
        const SizedBox(height: 4),
        BoldStatusTag(
            label: status.label, tone: status.tone, icon: status.icon),
      ],
    );
  }
}

/// Valor de transação à direita ("—  R$ 560,00"); travessão prefixa débito.
class BoldListAmount extends StatelessWidget {
  const BoldListAmount(this.value, {super.key, this.negative = false});
  final String value;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Text(negative ? '—  $value' : value,
        maxLines: 1,
        style: BoldType.title.copyWith(
            fontSize: 14, fontWeight: FontWeight.w600, color: c.textPrimary));
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Tile + grupo
// ═══════════════════════════════════════════════════════════════════════════

/// Uma row de lista: `leading + título (+ subtítulo) + trailing`. Componha
/// dentro de um [BoldListGroup]. Com [onTap], um chevron aparece por default;
/// passe [trailing] custom ([BoldListTime], [BoldListTimeStatus],
/// [BoldListAmount], [BoldStatusTag], "Em breve"…) pra sobrepor, e
/// [enabled] = false pra esmaecer.
class BoldListTile extends StatelessWidget {
  const BoldListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final trail = trailing ??
        (onTap != null
            ? BoldIcon('chevron-right',
                size: BoldIconSize.md, color: c.textMuted)
            : null);
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: BoldSpace.x3),
      child: Row(children: [
        if (leading != null) ...[leading!, const SizedBox(width: 14)],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: BoldType.title
                      .copyWith(fontSize: 15, color: c.textPrimary)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!,
                    style: BoldType.bodySmall
                        .copyWith(color: c.textSecondary, fontSize: 12.5)),
              ],
            ],
          ),
        ),
        if (trail != null) ...[const SizedBox(width: 10), trail],
      ]),
    );
    final content = Opacity(opacity: enabled ? 1 : 0.55, child: row);
    if (onTap == null || !enabled) return content;
    return GestureDetector(
        onTap: onTap, behavior: HitTestBehavior.opaque, child: content);
  }
}

/// Card arredondado que empilha [BoldListTile]s com hairline entre elas —
/// mesma superfície branca translúcida do DS. [title] opcional = label de
/// seção uppercase acima.
class BoldListGroup extends StatelessWidget {
  const BoldListGroup({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        // Hairline tokenizada (BoldColors.hairline = neutral-09).
        rows.add(const Divider(
            height: 1, thickness: 1, color: BoldColors.hairline));
      }
      rows.add(children[i]);
    }
    final card = BoldCard(
      glass: true,
      radius: 20,
      padding:
          const EdgeInsets.symmetric(horizontal: BoldSpace.x4, vertical: 2),
      child: Column(children: rows),
    );
    if (title == null) return card;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: BoldSpace.x1, bottom: 10),
        child: Text(title!.toUpperCase(),
            style: BoldType.label
                .copyWith(color: c.textMuted, fontSize: 11, letterSpacing: 1)),
      ),
      card,
    ]);
  }
}
