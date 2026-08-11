/// CONTA BOLD — o CHIP DE FILTRO. Terceira lacuna, e a que mais parece já existir.
///
/// Pílula selecionável: *Todos · Entradas · Saídas*. Seis arquivos do app, todos no extrato e nas
/// folhas de filtro.
///
/// ## Por que ele não é o `DilettaInputChip`
///
/// O chip do pai tem `filled`, e a distância entre `filled` e `selected` é o desenho inteiro:
///
/// | | não escolhido | escolhido |
/// |---|---|---|
/// | `DilettaInputChip` | superfície + borda | `primarySubtle` + label `primary` |
/// | este | transparente + borda neutra + tinta forte | **`primary` cheio** + `onPrimary` |
///
/// O do pai fica no mesmo tom nos dois estados — ele marca *este filtro está aplicado* numa fila de
/// filtros aplicados. Este INVERTE, porque ele vive numa fila onde exatamente um está escolhido e a
/// leitura tem que ser instantânea. Cor sozinha também não decide: o peso do rótulo vai de 400 pra
/// 600 junto.
///
/// Está pedido ao pai como variante `selecionavel` — o par que falta na família de chips. Enquanto
/// não vem, mora aqui, que é onde o desenho do produto mora.
///
/// ## O alvo de toque é 44 e o desenho é 26, de propósito
///
/// WCAG 2.5.5. A pílula visível tem ~26px; o respiro vertical de 9 de cada lado leva a área de toque
/// a 44 **sem inflar a pílula**. É a razão de o respiro estar por fora do `AnimatedContainer` e não
/// dentro — invertê-los engorda o desenho e não muda o alvo.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// A pílula de filtro.
class BoldChipDeFiltro extends StatelessWidget {
  const BoldChipDeFiltro(
    this.rotulo, {
    super.key,
    required this.escolhido,
    required this.aoTocar,
  });

  final String rotulo;
  final bool escolhido;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    return Semantics(
      button: true,
      selected: escolhido,
      label: rotulo,
      child: DilettaTappable(
        onTap: aoTocar,
        child: DilettaDevInfo(
          component: 'chipDeFiltro',
          props: {'escolhido': '$escolhido'},
          tokens: const ['radius.pill', 'type.bodySm', 'scheme.primary'],
          child: Padding(
            // Fora da pílula: ele é alvo de toque, não desenho. Ver o `///`.
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(
                  horizontal: DilettaSpacing.s3 + 2, vertical: DilettaSpacing.s1),
              decoration: BoxDecoration(
                color: escolhido ? s.primary : const Color(0x00000000),
                borderRadius: DilettaRadius.pillAll,
                border: Border.all(color: escolhido ? s.primary : s.border),
              ),
              child: DilettaText(
                rotulo,
                style: DilettaType.bodySm.copyWith(
                  // O peso acompanha a cor: cor sozinha não é informação, e a fila inteira muda
                  // de tom quando o tema muda.
                  fontWeight: escolhido ? FontWeight.w600 : FontWeight.w400,
                  color: escolhido ? s.onPrimary : s.fg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
