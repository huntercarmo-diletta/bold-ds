import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Tom do [BoldInputChip].
enum BoldInputChipTone {
  /// Label/border primários, bg branco (ou wash se [BoldInputChip.filled]) —
  /// seletor de contexto chamativo ("Conta PF ▾").
  primary,

  /// Cinza GLASSY (tint translúcido + blur) — chips informativos/discretos
  /// sobre a foto ("Seu saldo", "Extrato ›").
  neutral,

  /// SEM fundo/border — só label+ícone primários. Pra chips embutidos em
  /// outros componentes (troca de conta no TopBar).
  ghost,
}

/// Conta BOLD — InputChip (molécula). Chip pill h24 interativo: dropdown de
/// contexto na top bar ("Conta PF ▾"), filtro removível ("15 dias ⊖") ou chip
/// de ação discreto ("Seu saldo" + olhinho, "Extrato ›").
///
/// - [tone] primary = label/border primários; neutral = cinza glassy.
/// - [filled] (só primary) = bg primary-08 (filtro ativo).
/// - [trailIcon] típico: 'chevron-down' (dropdown), 'chevron-right' (link),
///   'eye'/'eye-off' (toggle), 'circle-minus-light' (remover).
///
/// **Composição** — BoldIcon (átomo) + tokens (BoldGlass no tom neutral).
class BoldInputChip extends StatelessWidget {
  const BoldInputChip({
    super.key,
    required this.label,
    this.trailIcon,
    this.leadIcon,
    this.tone = BoldInputChipTone.primary,
    this.filled = false,
    this.onTap,
  });

  final String label;
  final String? trailIcon;
  final String? leadIcon;
  final BoldInputChipTone tone;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final neutral = tone == BoldInputChipTone.neutral;
    final ghost = tone == BoldInputChipTone.ghost;
    final fg = neutral ? BoldColors.neutral02 : BoldColors.primary04;

    Widget chip = Container(
      // Ghost abraça o conteúdo (sem altura fixa nem padding lateral) pra não
      // criar respiro fantasma quando embutido em outro componente. Os demais
      // são ESPAÇOSOS de propósito (chip apertado = sensação de malfeito).
      height: ghost ? null : 28,
      padding: EdgeInsets.symmetric(horizontal: ghost ? 0 : BoldSpace.x3),
      decoration: BoxDecoration(
        color: ghost
            ? BoldColors.transparent
            : neutral
                ? BoldColors.neutral10Alpha70
                : (filled ? BoldColors.primary08 : BoldColors.white),
        border: (neutral || ghost)
            ? null
            : Border.all(color: BoldColors.primary04, width: 1),
        borderRadius: BoldRadius.pillR,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadIcon != null) ...[
            BoldIcon(leadIcon!, size: 13, color: fg),
            const SizedBox(width: 5),
          ],
          Text(label,
              style: BoldType.bodySmall.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
          if (trailIcon != null) ...[
            const SizedBox(width: 5),
            BoldIcon(trailIcon!, size: 13, color: fg),
          ],
        ],
      ),
    );

    // Tom neutral é glassy: o tint translúcido pede blur do fundo.
    if (neutral) {
      chip = ClipRRect(
        borderRadius: BoldRadius.pillR,
        clipBehavior: BoldGlass.clip,
        child: BackdropFilter(filter: BoldGlass.blurFilter, child: chip),
      );
    }

    if (onTap != null) {
      chip = GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: onTap, child: chip);
    }
    return chip;
  }
}
