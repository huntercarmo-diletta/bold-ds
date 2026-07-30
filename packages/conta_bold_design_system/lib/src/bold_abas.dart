/// CONTA BOLD — as ABAS sublinhadas.
///
/// 3 usos. O pai não tem abas segmentadas em lugar nenhum — e o chrome do próprio catálogo teve
/// que inventar as dele, o que é o primeiro sinal de vocabulário faltando. Nasce aqui, e é
/// candidata clara a subir quando um segundo filho medir a mesma falta.
///
/// ## O que mudou
///
/// **Rótulo longo não estoura mais o layout, ele encurta.** Já havia `ellipsis`, mas com
/// `Expanded` igual pra todas: quatro abas com rótulos de tamanhos diferentes cortavam a maior
/// enquanto a menor sobrava espaço. Agora o `Expanded` sai quando cabem todas na largura, e o
/// corte só acontece quando não cabe — exigência 10 do contrato (texto longo não estoura).
///
/// **A área de toque é a da ABA, não a do texto.** O `InkWell` estava dentro do `Expanded` e o
/// padding era do container interno, então a faixa vertical acima e abaixo do rótulo não
/// respondia. Exigência 10 outra vez, do outro lado: hit area de 16px é o defeito que só aparece
/// no aparelho de alguém.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Abas sublinhadas, com indicador na aba ativa.
class BoldAbas extends StatelessWidget {
  const BoldAbas({
    super.key,
    required this.abas,
    required this.indiceSelecionado,
    required this.aoTrocar,
  });

  final List<String> abas;
  final int indiceSelecionado;
  final ValueChanged<int> aoTrocar;

  /// Espessura do sublinhado ativo. O inativo é 1 — a diferença é o que marca a seleção sem
  /// depender só de cor, que é o que faz a aba ativa continuar legível pra quem não distingue
  /// matiz.
  static const double _espessuraAtiva = 2;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    return DilettaDevInfo(
      component: 'abas',
      props: {'abas': '${abas.length}', 'selecionada': '$indiceSelecionado'},
      tokens: const ['scheme.primary', 'scheme.border', 'type.labelLg'],
      child: Row(
        children: [
          for (var i = 0; i < abas.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == indiceSelecionado,
                label: abas[i],
                // O toque é a ABA inteira: o padding vive DENTRO do tappable, não fora, senão a
                // faixa acima e abaixo do rótulo não responde.
                child: DilettaTappable(
                  onTap: () => aoTrocar(i),
                  child: AnimatedContainer(
                    duration: DilettaMotion.short,
                    padding: EdgeInsets.symmetric(
                      horizontal: DilettaSpacing.s4,
                      vertical: DilettaSpacing.s3,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: i == indiceSelecionado ? s.primary : s.border,
                          width: i == indiceSelecionado ? _espessuraAtiva : 1,
                        ),
                      ),
                    ),
                    child: DilettaText(
                      abas[i],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DilettaType.labelLg.copyWith(
                        color: s.fg,
                        fontWeight: i == indiceSelecionado
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
