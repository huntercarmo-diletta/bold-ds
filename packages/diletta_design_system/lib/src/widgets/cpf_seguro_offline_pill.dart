import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// CPF SEGURO — OfflinePill (molécula).
///
/// Pill de conectividade mostrada ACIMA do StatusBanner quando o app está
/// sem conexão (gap 8 pro banner). Bg neutral-01, radius 8, px 16 py 4,
/// wifi 16 + label-sm neutral-09.
///
/// Figma 15:15378.
///
/// **Composição** — Icon (átomo) + tokens.
class DilettaOfflinePill extends StatelessWidget {
  const DilettaOfflinePill({
    super.key,
    this.label = 'Sem conexão · mostrando dados salvos',
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaOfflinePill',
      props: {'label': "'$label'"},
      tokens: const ['bg neutral-01 · radius 8 · wifi-light 16 + labelSm neutral-09'],
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s4, vertical: DilettaSpacing.s1),
      decoration: BoxDecoration(
        color: s.isDark ? s.surfaceMuted : s.fg,
        borderRadius: DilettaRadius.all8,
      ),
      child: Row(
        children: [
          DilettaIconAccessory(icon: DilettaIcons.wifiLight, padding: 0, size: 16, color: s.isDark ? s.textSecondary : s.palette.neutral09),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DilettaType.labelSm.copyWith(color: s.isDark ? s.textSecondary : s.palette.neutral09),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
