/// CONTA BOLD — o RESUMO DA TRANSAÇÃO, e por que ele é conteúdo e não tela.
///
/// O app tem um organismo `BoldTransactionSummary` que é a TELA inteira do comprovante: `Scaffold` +
/// fundo + barra de topo + este cabeçalho + as seções + a barra de baixo. Ele NÃO entra na linguagem
/// nessa forma, e a razão é a dinâmica do catálogo: lá se monta tela COM blocos, então um bloco que
/// já é a tela não compõe com nada — ele só pode ser usado sozinho.
///
/// Das seis peças daquele organismo, cinco já existem: fundo (`fundoDoFrame`), casca de topo,
/// cabeçalho de seção, lista e barra de baixo. **A que faltava é esta**, e ela é a única que carrega
/// decisão de produto.
///
/// ## O que a medição mostrou, e é o argumento pra ele nascer
///
/// **Três telas de comprovante escrevem o mesmo cabeçalho, com números diferentes:**
///
/// | tela | título | valor | spot |
/// |---|---|---|---|
/// | Pix (via organismo) | `headlineSm` | display **32**, ls −1 | 38 |
/// | Boleto (via organismo) | `headlineSm` | display **32**, ls −1 | 38 |
/// | TED (à mão) | `headlineSm` | display **34**, ls −1 | **40** |
///
/// Dois valores de dinheiro e dois tamanhos de spot pro mesmo cabeçalho. Nenhum revisor pega 32 vs
/// 34 lado a lado — é a classe de deriva que só um componente resolve.
///
/// ## Duas decisões que mudaram na adaptação
///
/// **O estado virou enum, e antes eram dois argumentos calculados na tela.** O app passava
/// `statusIcon` e `statusTone` com um ternário em cima de `isScheduled`, nos quatro pontos de uso —
/// quatro chances de escolher o ícone certo com o tom errado. Aqui a tela diz o ESTADO e o
/// componente resolve o par, com `switch` exaustivo: estado novo não compila até ser desenhado.
///
/// **O valor ENCOLHE em vez de cortar.** `R$ 1.234.567,89` a 32px não cabe em tela estreita, e
/// dinheiro com reticências é dinheiro errado na tela — `R$ 1.234...` lê como um valor menor. Então
/// é `FittedBox` com `scaleDown`: perde tamanho, nunca dígito.
///
/// O tamanho do valor fechou em `DilettaType.headlineLg` (32), que é o token do pai que casa com o
/// que duas das três telas já usavam. O 34 da TED sai.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Em que ponto a transação está — o que decide o ícone e o tom do spot.
///
/// Dois valores porque dois é o que as telas de hoje têm (`enviado`/`agendado`). Sem `negada` nem
/// `emAnalise`: valor de enum que ninguém usa é desenho especulativo, e o `switch` daqui é exaustivo
/// — quando a primeira tela de recusa aparecer, ela não compila até o estado existir, que é
/// exatamente o aviso que se quer.
enum CoreflowEstadoDaTransacao {
  /// Já aconteceu: pago, enviado, recebido.
  concluida,

  /// Vai acontecer numa data: agendada.
  agendada,
}

/// O cabeçalho de um comprovante: o que foi, quanto, quando.
class CoreflowResumoDaTransacao extends StatelessWidget {
  const CoreflowResumoDaTransacao({
    super.key,
    required this.titulo,
    required this.valor,
    required this.quando,
    this.estado = CoreflowEstadoDaTransacao.concluida,
  });

  /// O que aconteceu ("Pix enviado", "Boleto agendado").
  final String titulo;

  /// Valor já formatado. Formatar é da tela — este componente não sabe de moeda.
  final String valor;

  /// A linha de data/hora ("30 de julho · 14:32", "Para 12/08").
  final String quando;

  final CoreflowEstadoDaTransacao estado;

  /// O par ícone + estado do spot, num lugar só. Era um ternário duplicado em cada tela.
  ({String icone, DilettaSpotState estadoDoSpot}) get _spot => switch (estado) {
        CoreflowEstadoDaTransacao.concluida =>
          (icone: DilettaIcons.circleCheckLight, estadoDoSpot: DilettaSpotState.success),
        CoreflowEstadoDaTransacao.agendada =>
          (icone: DilettaIcons.calendarLight, estadoDoSpot: DilettaSpotState.warning),
      };

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final spot = _spot;

    return DilettaDevInfo(
      component: 'resumoDaTransacao',
      props: {'estado': estado.name, 'valor': "'$valor'"},
      tokens: const [
        'titulo: headlineSm scheme.fg',
        'valor: headlineLg scheme.fg (encolhe, não corta)',
        'quando: bodySm scheme.textSecondary',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DilettaText(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DilettaType.headlineSm.copyWith(color: s.fg),
                ),
              ),
              DilettaGap.w(DilettaSpacing.s3),
              // O spot é REDUNDANTE pro leitor de tela: o estado já está escrito no título ("Boleto
              // agendado"). Anunciar o ícone de novo é ruído, então ele sai da árvore de semântica.
              ExcludeSemantics(
                child: DilettaSpotIcon(icon: spot.icone, state: spot.estadoDoSpot, size: 38),
              ),
            ],
          ),
          DilettaGap.h(DilettaSpacing.s4),
          // Dinheiro nunca com reticências: `R$ 1.234...` lê como um valor menor do que é.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: DilettaText(
              valor,
              maxLines: 1,
              style: DilettaType.headlineLg.copyWith(color: s.fg),
            ),
          ),
          DilettaGap.h(DilettaSpacing.s0_5),
          DilettaText(
            quando,
            style: DilettaType.bodySm.copyWith(color: s.textSecondary),
          ),
        ],
      ),
    );
  }
}
