import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — AmountDisplay (molécula).
///
/// Bloco de valor de transação entre hairlines: valor central grande +
/// timestamp opcional embaixo. Usado no Detalhe de transação e no
/// "Pagamento efetuado" da Carteira (Figma 1158:39718 / 1200:45996).
///
/// **Composição** — só tokens.
class DilettaAmountDisplay extends StatelessWidget {
  const DilettaAmountDisplay({
    super.key,
    required this.value,
    this.timestamp,
    this.label,
    this.centered = true,
    this.hero = false,
    this.onTap,
  });

  /// Valor formatado ("R$ 560,00"). Obscurecido/loading ficam no consumidor
  /// (ele passa o texto mascarado ou troca por skeleton).
  final String value;

  /// Linha de data/hora ("13/10/2023 as 14:25").
  final String? timestamp;

  /// Label acima do valor ("Seu saldo", "Gasto no mês") — header de extrato.
  final String? label;

  /// Centralizado (detalhe de transação) ou à esquerda (header de extrato,
  /// Figma 1158:34891 "Seu saldo").
  final bool centered;

  /// Valor em tamanho hero (saldo da home) em vez do numeric padrão. Decisão:
  /// adotar o look do app (BalanceComponent).
  final bool hero;

  /// Toque no bloco (padrão saldo): mostra chevron ao lado do label e torna o
  /// bloco tocável.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DilettaDevInfo(
      component: 'DilettaAmountDisplay',
      props: {'value': "'$value'", if (label != null) 'label': "'$label'", if (timestamp != null) 'timestamp': "'$timestamp'", 'centered': '$centered'},
      tokens: const ['value: numeric 22 tabular neutral-01 · entre hairlines neutral-09'],
      child: _block(context),
    );
  }

  Widget _block(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final valueStyle = hero
        ? DilettaType.numeric
            .copyWith(color: s.fg, fontSize: 30, fontWeight: FontWeight.w700)
        : DilettaType.numeric.copyWith(color: s.fg);

    Widget block = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: s.divider, width: 1),
          bottom: BorderSide(color: s.divider, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label!,
                  style: DilettaType.subheading.copyWith(color: s.fg),
                ),
                // Chevron do padrão saldo (tocável).
                if (onTap != null) ...[
                  const SizedBox(width: 6),
                  DilettaIconAccessory(
                      icon: DilettaIcons.angleRightLight,
                      padding: 0,
                      size: 14,
                      color: s.textMuted),
                ],
              ],
            ),
            const SizedBox(height: 4),
          ],
          Text(
            value,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: valueStyle,
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 2),
            Text(
              timestamp!,
              textAlign: centered ? TextAlign.center : TextAlign.left,
              style: DilettaType.caption.copyWith(color: s.textMuted),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      block = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
            behavior: HitTestBehavior.opaque, onTap: onTap, child: block),
      );
    }
    return block;
  }
}
