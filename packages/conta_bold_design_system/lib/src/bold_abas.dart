/// CONTA BOLD — as ABAS sublinhadas.
///
/// 3 usos. O pai não tinha abas segmentadas em lugar nenhum — e o chrome do próprio catálogo teve
/// que inventar as dele, o que é o primeiro sinal de vocabulário faltando. Nasceu aqui, e a frase
/// que estava escrita nesta linha era *"candidata clara a subir quando um segundo filho medir a
/// mesma falta"*.
///
/// ## A condição disparou em 12/08, e ela não disparou por mim
///
/// O pai cruzou os DOIS DS que a linguagem serve — 216 nomes de componente — e a interseção virou
/// regra: **o que está nos dois é vocabulário da categoria**. `DilettaTabs` nasceu daí (`ds
/// v0.87.0`).
///
/// **Eu escrevi a condição e não tinha como verificá-la**: eu vejo um produto. A lição que fica pras
/// próximas peças que nascerem aqui é escrever a promessa como uma CONSULTA que alguém consegue
/// rodar, e não como uma intenção.
///
/// ## E ela não foi adotada, por 113 pixels
///
/// A do pai é `MainAxisSize.min` com cada aba do tamanho do rótulo; esta reparte a largura em fatias
/// iguais. Com `Pendentes · Histórico · Minhas` em 353 de largura — a tela de Autorizações — a dele
/// **estoura por 113px**. Com rótulos curtos (`Tudo · Entradas · Saídas`) cabe.
///
/// As duas estão certas em contextos diferentes, e a razão de repartir está três parágrafos abaixo:
/// **fatia desigual faz o alvo de toque mudar de tamanho a cada troca de tela.** Está pedido como
/// variante (`larguraIgual`), com o número medido; enquanto não vier, esta peça é a única deste
/// produto com par na linguagem que não adota — e isso está declarado em vez de silencioso.
///
/// ## O que mudou
///
/// **Rótulo longo não estoura mais o layout, ele encurta.** O `ellipsis` já estava lá e era código
/// morto: sem `Expanded`, cada aba recebia largura infinita e nada nunca apertava o texto. Agora o
/// `Expanded` é de todas — exigência 10 do contrato (texto longo não estoura).
///
/// **Fatia igual é escolha, e o custo é declarado:** a aba de rótulo comprido corta enquanto a curta
/// sobra espaço. É o certo AQUI porque barra de navegação ocupa a largura toda por contrato, e fatia
/// desigual faz o alvo de toque mudar de tamanho a cada troca de tela. Quem hoje HUGA é a pílula dos
/// `BoldSegmentos`, que mora ao lado de um rótulo — e por isso ela resolve largura de outro jeito
/// (`FittedBox`, e a razão está escrita lá).
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
