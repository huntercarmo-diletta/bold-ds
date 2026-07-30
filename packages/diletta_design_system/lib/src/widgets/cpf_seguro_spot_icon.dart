import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart';
import 'cpf_seguro_dev_inspect.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ATOM · SpotIcon (círculo colorido com ícone)
// ═══════════════════════════════════════════════════════════════════════════

enum DilettaSpotType { fill, outline }

enum DilettaSpotState {
  normal,
  disabled,
  primary,
  error,
  warning,
  success,
  loading,
  secure,
}

class _SpotSpec {
  const _SpotSpec({required this.bg, this.border, required this.iconColor});
  final Color bg;
  final Color? border;
  final Color iconColor;
}

_SpotSpec _resolveSpot(DilettaSpotType type, DilettaSpotState state, DilettaScheme s) {
  if (type == DilettaSpotType.fill) {
    return switch (state) {
      // Listagem cinza: icon neutral-03 (não 01) — padrão do extrato geral.
      DilettaSpotState.normal => _SpotSpec(bg: s.surfaceMuted, iconColor: s.textTertiary),
      DilettaSpotState.disabled => _SpotSpec(
          bg: s.isDark ? s.palette.neutral02 : s.palette.neutral10,
          iconColor: s.palette.neutral06),
      // PAPEL e não degrau: no escuro o role clareia, então o spot preenchido
      // acompanha o tema em vez de ficar com o mesmo azul dos dois lados. Foi o
      // teste `reage_ao_tema` que mostrou que a conversão anterior tinha preservado
      // um comportamento errado.
      DilettaSpotState.primary => _SpotSpec(bg: s.primary, iconColor: s.palette.white),
      DilettaSpotState.error => _SpotSpec(bg: s.error, iconColor: s.palette.error07),
      DilettaSpotState.warning => _SpotSpec(bg: s.warning, iconColor: s.palette.white),
      DilettaSpotState.success => _SpotSpec(bg: s.success, iconColor: s.palette.white),
      DilettaSpotState.loading => _SpotSpec(bg: s.surfaceMuted, iconColor: s.textTertiary),
      DilettaSpotState.secure => _SpotSpec(bg: s.secure, iconColor: s.palette.white),
    };
  }
  return switch (state) {
    DilettaSpotState.normal => _SpotSpec(bg: s.surfaceMuted, iconColor: s.textTertiary),
    DilettaSpotState.disabled => _SpotSpec(
        bg: s.isDark ? s.palette.neutral02 : s.palette.neutral10,
        iconColor: s.palette.neutral06),
    DilettaSpotState.primary => _SpotSpec(bg: s.primarySubtle, iconColor: s.primary),
    // Dark: fundo pálido (error-07) vira tint escuro; ícone clareia.
    DilettaSpotState.error => s.isDark
        ? _SpotSpec(bg: s.errorSubtle, iconColor: s.error)
        : _SpotSpec(bg: s.palette.error07, iconColor: s.palette.error03),
    DilettaSpotState.warning => s.isDark
        ? _SpotSpec(bg: s.palette.warning05.withValues(alpha: 0.18), iconColor: s.palette.warning05)
        : _SpotSpec(bg: s.palette.warning07, border: s.palette.warning03, iconColor: s.palette.warning03),
    DilettaSpotState.success => s.isDark
        ? _SpotSpec(bg: s.palette.success05.withValues(alpha: 0.18), iconColor: s.palette.success05)
        : _SpotSpec(bg: s.palette.success07, border: s.palette.success03, iconColor: s.palette.success03),
    DilettaSpotState.loading => s.isDark
        ? _SpotSpec(bg: s.surfaceMuted, iconColor: s.primary)
        : _SpotSpec(bg: s.palette.primary07, border: s.palette.neutral07, iconColor: s.palette.primary04),
    // Dark: creme (secure-08) vira tint dourado escuro; ícone clareia.
    DilettaSpotState.secure => s.isDark
        ? _SpotSpec(bg: s.palette.secure05.withValues(alpha: 0.18), iconColor: s.palette.secure05)
        : _SpotSpec(bg: s.palette.secure08, iconColor: s.palette.secure03),
  };
}

/// CPF SEGURO — SpotIcon (átomo STANDALONE).
///
/// Círculo colorido com ícone. 10 variantes (fill/outline × 8 states).
/// Default 34px (mobile). Icon escala pra ~58% do container.
///
/// Vive por conta própria (banner, KPI card, etc). Dentro do AppList,
/// use [DilettaLeftAccessory.spotIcon].
class DilettaSpotIcon extends StatelessWidget {
  const DilettaSpotIcon({
    super.key,
    required this.icon,
    this.type = DilettaSpotType.fill,
    this.state = DilettaSpotState.normal,
    this.badge = DilettaBadge.none,
    this.size = 34,
  });

  final String icon;
  final DilettaSpotType type;
  final DilettaSpotState state;
  final DilettaBadge badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final spec = _resolveSpot(type, state, s);
    final iconSize = (size * 0.58).roundToDouble();
    return DilettaDevInfo(
      component: 'DilettaSpotIcon',
      props: {
        'icon': icon,
        'type': type.name,
        'state': state.name,
        'size': '${size.toInt()}',
        if (badge != DilettaBadge.none) 'badge': badge.name,
      },
      tokens: [
        'bg: ${nomeDoToken(context, spec.bg)}',
        'icon: ${nomeDoToken(context, spec.iconColor)} · ${iconSize.toInt()}px',
        if (spec.border != null) 'border: ${nomeDoToken(context, spec.border)}',
      ],
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: spec.bg,
          shape: BoxShape.circle,
          border: spec.border == null ? null : Border.all(color: spec.border!, width: 1),
        ),
        child: DilettaIconAccessory(icon: icon, size: iconSize, color: spec.iconColor, badge: badge),
      ),
    );
  }
}
