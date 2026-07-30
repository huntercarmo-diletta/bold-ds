import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — InputChip (molécula).
///
/// Chip pill h24 com label primary + border primary — usado como dropdown
/// de contexto na top bar do Histórico ("Meu CPF ▾", "Esposa ▾") e como
/// filtro removível ("15 dias ⊖").
///
/// Figma "Input chips" (99:4019 / 99:4075).
///
/// - [filled] = bg primary-08 (filtro ativo); default bg branco.
/// - [trailIcon] típico: 'chevron-down-light' (dropdown) ou
///   'circle-minus-light' (remover filtro).
///
/// **Composição** — Icon (átomo) + tokens.
class DilettaInputChip extends StatelessWidget {
  const DilettaInputChip({
    super.key,
    required this.label,
    this.trailIcon,
    this.leadIcon,
    this.filled = false,
    this.iconSize = 12,
    this.onTap,
  });

  final String label;
  final String? trailIcon;
  final String? leadIcon;
  final bool filled;

  /// Tamanho dos ícones lead/trail. Default 12; o app passa o seu (8 dropdown
  /// fechado / 18) — a decisão foi manter raio+cor do DS, ícone do app.
  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    Widget chip = Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2),
      decoration: BoxDecoration(
        color: filled ? s.primarySubtle : s.surface,
        border: Border.all(color: s.primary, width: 1),
        borderRadius: DilettaRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leadIcon != null) ...[
            DilettaIconAccessory(icon: leadIcon!, padding: 0, size: iconSize, color: s.primary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            // height 1.0 + even = line-box justo e leading igual dos 2 lados →
            // o glifo centra na folga (não "cai" pela métrica do SF Pro).
            style: DilettaType.labelSm.copyWith(
              color: s.primary,
              height: 1.0,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          if (trailIcon != null) ...[
            const SizedBox(width: 4),
            DilettaIconAccessory(icon: trailIcon!, padding: 0, size: iconSize, color: s.primary),
          ],
        ],
      ),
    );

    if (onTap != null) {
      chip = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(behavior: HitTestBehavior.opaque, onTap: onTap, child: chip),
      );
    }
    return DilettaDevInfo(
      component: 'DilettaInputChip',
      props: {
        'label': "'$label'",
        if (leadIcon != null) 'leadIcon': leadIcon!,
        if (trailIcon != null) 'trailIcon': trailIcon!,
        'filled': '$filled',
      },
      tokens: [
        'h 24 · radius pill · border primary-04',
        'bg: ${filled ? 'primary-08' : 'white'} · label primary-04 labelSm',
      ],
      child: chip,
    );
  }
}
