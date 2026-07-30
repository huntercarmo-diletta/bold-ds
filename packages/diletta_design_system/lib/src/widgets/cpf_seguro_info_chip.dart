import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Tom do [DilettaInfoChip].
///
/// - **light** — pill claro (bg branco, texto/ícone neutros). Sobre fundo claro.
/// - **onColor** — pill translúcido branco + borda branca, texto branco. Pra
///   assentar SOBRE uma superfície colorida (card de nível, banner primary).
enum DilettaInfoChipTone { light, onColor }

/// CPF SEGURO — InfoChip.
///
/// Pill DECORATIVO/informativo: ícone + label, não-interativo. Distinto de:
/// - [DilettaStatusTag] (estado semântico com tom fixo success/error/…),
/// - [DilettaInputChip] (filtro/seleção interativo, com chevron/onTap).
///
/// É o "badge" genérico de rótulo — usado sobre cards e superfícies coloridas.
///
/// ```dart
/// DilettaInfoChip(label: 'Nível 2', icon: DilettaIcons.starLight),
/// DilettaInfoChip(label: 'Próximo nível', tone: DilettaInfoChipTone.onColor),
/// ```
class DilettaInfoChip extends StatelessWidget {
  const DilettaInfoChip({
    super.key,
    required this.label,
    this.icon,
    this.tone = DilettaInfoChipTone.light,
  });

  final String label;

  /// Nome do ícone (ds.Icons). Null = sem ícone.
  final String? icon;
  final DilettaInfoChipTone tone;

  @override
  Widget build(BuildContext context) {
    final onColor = tone == DilettaInfoChipTone.onColor;
    final s = DilettaTheme.schemeOf(context);
    // `onColor` é o chip POR CIMA de cor de marca: ali o branco é a intenção e não
    // reage ao tema — por isso ele lê a paleta. O tom `light` é chip sobre a
    // superfície da tela, e esse tem que acompanhar: superfície, tinta e borda por
    // PAPEL. Antes os dois usavam degrau fixo, e o chip ficava branco no escuro.
    final bg = onColor
        ? s.palette.white.withValues(alpha: 0.15)
        : s.surface;
    final fg = onColor ? s.palette.white : s.textSecondary;
    final border = onColor
        ? s.palette.white.withValues(alpha: 0.38)
        : s.borderSubtle;

    return DilettaDevInfo(
      component: 'DilettaInfoChip',
      props: {'tone': tone.name, if (icon != null) 'icon': icon!},
      tokens: const ['pill · icon 14 + labelSm', 'light: bg white / onColor: white@15% + border'],
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: DilettaSpacing.s3, vertical: DilettaSpacing.s1_5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: DilettaRadius.all200,
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              DilettaIcon(name: icon!, color: fg, size: 14),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(label,
                  style: DilettaType.labelSm.copyWith(color: fg)),
            ),
          ],
        ),
      ),
    );
  }
}
