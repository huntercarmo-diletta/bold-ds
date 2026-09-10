/// CONTA BOLD — a ESCADA DE ALÇADAS, e o que a adaptação mediu nela.
///
/// Faixas de valor empilhadas da menor pra maior, cada uma dizendo quantas assinaturas a saída exige.
/// É o vocabulário da conta PJ deste produto: quem pode mandar quanto, e com quantas mãos. Aparece no
/// editor de alçadas e no detalhe do operador, e é o mesmo desenho nos dois.
///
/// ## Três coisas mudaram, e as três são medição
///
/// **1 · O texto da exigência tinha contraste abaixo de AA.** O componente antigo pintava o rótulo com
/// o tom cheio (`primary`/`success`) sobre um banho de 10% do MESMO tom — cor sobre cor. Medido com a
/// paleta do Bold, com a razão de contraste do próprio pai:
///
/// | par | claro | escuro |
/// |---|---|---|
/// | `primary` sobre banho de primary (o antigo) | **3.08** | **2.94** |
/// | `onPrimarySubtle` sobre `primarySubtle` (o novo) | **7.13** | **4.89** |
/// | `success` sobre banho de success (o antigo) | **3.90** | **3.42** |
/// | `onSuccessSubtle` sobre `successSubtle` (o novo) | **5.19** | **5.11** |
///
/// AA de texto de corpo é 4.5. As quatro leituras antigas passavam longe, e o par certo já existia no
/// pai — ele nasceu justamente porque um token não serve a duas exigências de contraste.
///
/// **2 · A rampa de calor era código morto no caso comum.** A cor subia com a exigência
/// (`aprovacoes / maxAprovacoes` interpolado entre 55% e 100% de `primary`). Só que o modelo de dados
/// deste produto, quando o backend não manda faixas escalonadas, produz **exatamente dois degraus**:
/// autonomia e "acima disso, N aprovações". Nesse caso `maxAprovacoes` é o único N, a intensidade é
/// sempre 1.0, e a rampa nunca desenha diferença nenhuma.
///
/// Fora isso ela codificava em COR o que a linha já diz em TEXTO ("2 aprovações"), num canal que leitor
/// de tela não lê e que empata quando duas faixas pedem o mesmo número. Saiu. O que separa os degraus é
/// o que sempre separou: a família de cor (autonomia é sucesso, exigência é marca) e o número escrito.
///
/// **3 · A moeda saiu do componente, e não por purismo.** O antigo recebia `double` mais uma função de
/// formatação. Função não é prop **vinculável a dado** — então o bloco do catálogo não conseguiria
/// oferecer esta escada pra montar tela, que é metade da razão de o DS existir. Agora o degrau recebe o
/// valor JÁ FORMATADO (`ate: 'R\$ 5.000,00'`) e a escada só compõe as palavras da faixa. Custo pro app:
/// uma linha por ponto de uso, e são dois. Quem quer o formatador tem o `CoreflowDinheiro` aqui do lado.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Um degrau: até [ate] reais, a saída exige [aprovacoes] assinaturas.
class CoreflowDegrauDeAlcada {
  const CoreflowDegrauDeAlcada({
    this.ate,
    required this.aprovacoes,
    this.exigeMaster = false,
  });

  /// Teto da faixa, JÁ FORMATADO pelo produto (`'R$ 5.000,00'`). Nulo = faixa terminal
  /// ("acima disso"), que é o último degrau de toda escada.
  final String? ate;

  /// Assinaturas necessárias. Zero = o operador faz sozinho.
  final int aprovacoes;

  /// Uma das assinaturas precisa ser de um aprovador master.
  final bool exigeMaster;

  bool get ehAutonomia => aprovacoes == 0;
  bool get ehTerminal => ate == null;
}

/// A escada de alçadas em leitura.
class CoreflowEscadaDeAlcadas extends StatelessWidget {
  const CoreflowEscadaDeAlcadas({
    super.key,
    required this.degraus,
    this.densa = false,
  });

  final List<CoreflowDegrauDeAlcada> degraus;

  /// Versão compacta: uma linha por faixa, com menos respiro. É a usada nas duas telas de hoje.
  final bool densa;

  @override
  Widget build(BuildContext context) {
    // Escada vazia não desenha caixa vazia: sem faixa declarada não existe regra pra ler, e uma
    // moldura vazia lê como "carregando" — que é o oposto do que aconteceu.
    if (degraus.isEmpty) return const SizedBox.shrink();

    return DilettaDevInfo(
      component: 'escadaDeAlcadas',
      props: {'degraus': '${degraus.length}', 'densa': '$densa'},
      tokens: const [
        'autonomia: successSubtle · successBorder · onSuccessSubtle',
        'exigência: primarySubtle · primaryTrack · onPrimarySubtle',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < degraus.length; i++) ...[
            if (i > 0) DilettaGap.h(densa ? DilettaSpacing.s1 : DilettaSpacing.s2),
            _Degrau(
              degrau: degraus[i],
              anterior: i == 0 ? null : degraus[i - 1].ate,
              densa: densa,
            ),
          ],
        ],
      ),
    );
  }
}

class _Degrau extends StatelessWidget {
  const _Degrau({required this.degrau, required this.anterior, required this.densa});

  final CoreflowDegrauDeAlcada degrau;

  /// Teto do degrau de cima — é dele que sai o "De X a Y". A faixa não é propriedade do degrau
  /// sozinho: ela é a distância entre dois, e por isso quem compõe é a escada.
  final String? anterior;

  final bool densa;

  String get _faixa {
    if (degrau.ehTerminal) {
      return anterior == null ? 'Qualquer valor' : 'Acima de $anterior';
    }
    return anterior == null ? 'Até ${degrau.ate}' : 'De $anterior a ${degrau.ate}';
  }

  String get _exigencia {
    if (degrau.ehAutonomia) return 'Faz sozinho';
    final base = '${degrau.aprovacoes} '
        'aprovaç${degrau.aprovacoes == 1 ? 'ão' : 'ões'}';
    return degrau.exigeMaster ? '$base · 1 master' : base;
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    // Autonomia é uma FAMÍLIA de cor, não um tom mais claro da outra: "faz sozinho" e "precisa de
    // gente" são estados diferentes, e o pai já tem o trio de cada família com o contraste medido.
    final (fundo, traco, tinta) = degrau.ehAutonomia
        ? (s.successSubtle, s.successBorder, s.onSuccessSubtle)
        : (s.primarySubtle, s.primaryTrack, s.onPrimarySubtle);

    return DilettaBox(
      color: fundo,
      borderColor: traco,
      radius: DilettaRadius.all24,
      padding: EdgeInsets.symmetric(
        horizontal: DilettaSpacing.s4,
        vertical: densa ? DilettaSpacing.s2 : DilettaSpacing.s3,
      ),
      child: Row(children: [
        DilettaIcon(
          name: degrau.ehAutonomia ? DilettaIcons.circleCheckLight : DilettaIcons.stampLight,
          size: 16,
          color: tinta,
        ),
        DilettaGap.w(DilettaSpacing.s3),
        Expanded(
          child: DilettaText(
            _faixa,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (densa ? DilettaType.bodySm : DilettaType.bodyMd).copyWith(color: tinta),
          ),
        ),
        DilettaGap.w(DilettaSpacing.s2),
        // `Flexible` e não texto fixo: a exigência é curta com a fonte do produto, mas "4 aprovações ·
        // 1 master" numa tela de 280 estourava a linha em 55px — medido, não suposto. A ORDEM do
        // sacrifício é a decisão: a faixa (`Expanded`) cede primeiro e reticencia; a exigência só
        // encolhe quando não sobrou nada, porque o número de assinaturas é o que se veio ler.
        Flexible(
          child: DilettaText(
            _exigencia,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DilettaType.labelSm.copyWith(color: tinta),
          ),
        ),
      ]),
    );
  }
}
