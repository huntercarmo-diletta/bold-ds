import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_dev_inspect.dart';

enum _Kind { cashIn, cashOut, cashBack }

/// CPF SEGURO — Amount (átomo).
///
/// Valor monetário COMPACTO de linha ("chip de valor" do extrato/lista). Recebe
/// o valor já formatado ("R$ 560,00"); o construtor nomeado resolve o estilo.
/// Figma "Amount-chips" (2415:36885).
///
/// ```dart
/// DilettaAmount.cashIn(value: 'R$ 560,00')   // chip verde + "+"
/// DilettaAmount.cashOut(value: 'R$ 560,00')  // "−"
/// DilettaAmount.cashBack(value: 'R$ 560,00') // tachado
/// ```
///
/// NÃO é [DilettaAmountDisplay] (bloco grande centralizado entre hairlines).
/// Este é o valor inline consumido por `DilettaRightAccessory.amount`.
///
/// **Composição** — só tokens.
class DilettaAmount extends StatelessWidget {
  /// Entrada — chip verde (success) + prefixo "+".
  const DilettaAmount.cashIn({super.key, required this.value, this.obscured = false}) : _kind = _Kind.cashIn;

  /// Saída — prefixo "−", sem chip.
  const DilettaAmount.cashOut({super.key, required this.value, this.obscured = false}) : _kind = _Kind.cashOut;

  /// Retorno — valor tachado (strikethrough).
  const DilettaAmount.cashBack({super.key, required this.value, this.obscured = false}) : _kind = _Kind.cashBack;

  /// Valor já formatado ("R$ 560,00").
  final String value;

  /// Saldo oculto — mascara o valor ("••••"), ignora sinal/chip.
  final bool obscured;
  final _Kind _kind;

  @override
  Widget build(BuildContext context) {
    // Papel e não degrau: `textSecondary` é neutral02 no claro e neutral07 no
    // escuro, então o valor deixa de ser tinta fixa. Achado pelo
    // `reage_ao_tema_test` do catálogo — o componente pintava igual nos dois temas.
    final s = DilettaTheme.schemeOf(context);
    final base = DilettaType.labelSm.copyWith(color: s.textSecondary);

    if (obscured) {
      return DilettaDevInfo(
        component: 'DilettaAmount',
        props: {'obscured': 'true'},
        tokens: const ['labelSm neutral-02 · valor mascarado'],
        child: Text('••••', maxLines: 1, style: base),
      );
    }

    late final Widget child;
    switch (_kind) {
      case _Kind.cashIn:
        child = Container(
          padding: const EdgeInsets.symmetric(
              horizontal: DilettaSpacing.s2, vertical: DilettaSpacing.s1),
          decoration: BoxDecoration(
            color: s.successSubtle,
            borderRadius: DilettaRadius.pillAll,
          ),
          child: Text('+ $value',
              maxLines: 1, style: base.copyWith(color: s.success)),
        );
      case _Kind.cashOut:
        child = Text('− $value', maxLines: 1, style: base);
      case _Kind.cashBack:
        child = Text(
          value,
          maxLines: 1,
          style: base.copyWith(
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.lineThrough,
          ),
        );
    }

    return DilettaDevInfo(
      component: 'DilettaAmount',
      props: {'value': "'$value'", 'kind': _kind.name},
      tokens: const [
        'labelSm neutral-02 · cashIn: chip success-07 + success-04 "+" · cashOut: "−" · cashBack: strikethrough',
      ],
      child: child,
    );
  }
}
