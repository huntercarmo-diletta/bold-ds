/// CONTA BOLD — os SEGMENTOS, e por que eles não são as [BoldAbas].
///
/// Escolha entre poucas opções mutuamente exclusivas, na forma de pílula: trilho arredondado, e a
/// opção ativa como pastilha preenchida por cima.
///
/// ## A medição que decidiu não fundir os dois
///
/// Este componente e as `BoldAbas` têm a MESMA API (`List<String>` + índice + `aoTrocar`), e a
/// tentação óbvia era um componente com dois idiomas visuais. O que resolveu foi uma tela:
/// `pix_meus_qr_flow.dart` usa **os dois, seis linhas um do outro** —
///
/// ```
/// BoldSegmentedControl(segments: ['15 dias', '30 dias', '60 dias'])   // filtro
/// BoldTabs(tabs: ['Ativos', 'Encerrados'])                            // navegação
/// ```
///
/// — e a diferença é de JOB, não de estilo: o segmento troca um parâmetro do que está na tela; a aba
/// troca a lista que está sendo mostrada. Fundir os dois num `idioma` deixaria escolher a forma errada
/// pro trabalho, e a forma é o que ensina a pessoa o que vai acontecer ao tocar.
///
/// A classificação antiga mapeava isto pra `DilettaToggleSwitch`, o que era pior que fundir: switch é
/// binário, segmento é escolha entre N. O achado saiu da limpa de 2026-07-30.
///
/// ## Quatro coisas cravadas que saíram
///
/// 1. **`Colors.white` na pastilha ativa** — no escuro, uma pastilha branca dentro de um trilho escuro.
///    Virou `scheme.surface`;
/// 2. **`Color(0xFF1A1726)` no texto ativo** — tinta literal, que no escuro ficava preto sobre escuro.
///    Virou `scheme.fg`;
/// 3. **`fontSize: 14, fontWeight: w700` por cima de `bodySmall`** — preset reescrito na mão. Virou
///    `DilettaType.subheading`, que é 14/600 e é o degrau que existe pra isso;
/// 4. **`padding: 20/9`** — o 9 não é degrau de nada. Virou `s5`/`s2`, e a pastilha ficou 2px mais
///    baixa do que era.
///
/// E uma que entrou: **cada segmento anuncia o estado de seleção.** Sem isso o leitor de tela lê três
/// botões idênticos e não diz qual está ativo — que é a única informação que o componente carrega.
///
/// ## A largura, e a CORREÇÃO de um número que eu reportei errado
///
/// A pílula tem `Row(mainAxisSize: min)`, então ela pede a largura NATURAL dos rótulos e ignora quanto o
/// pai tem pra dar. O `overflow: ellipsis` do rótulo era **código morto**: numa Row de tamanho mínimo o
/// filho recebe largura infinita, e nada nunca apertava o texto.
///
/// **O defeito é esse, e ele é real. Os números que eu publiquei não eram.** Eu medi com a fonte do
/// `flutter_test`, em que todo glifo é um quadrado de 1em — e reportei ao pai que os rótulos do app
/// (`Claro, Escuro, Sistema`) vazavam 22px num telefone de 390. Medindo com **Inter**, que é a fonte deste
/// produto:
///
/// | rótulos | 280 | 312 | 358 |
/// |---|---|---|---|
/// | os do app (`Claro · Escuro · Sistema`) | **cabe** | **cabe** | **cabe** |
/// | três longos (`Aprovados · Rejeitados · Em análise`) | vaza 65px | vaza 33px | cabe |
///
/// Então: **não havia estouro no app.** O que existe é fragilidade pra conjunto de rótulo mais longo, e é
/// isso que o `FittedBox(scaleDown)` cobre — cabendo, nada muda; não cabendo, a escala cai e os rótulos
/// continuam inteiros. Encurtar seria pior: cortar `Rejeitados` em `Rejeita…` perde a palavra.
///
/// Não usei `Flexible` por causa da direção que ninguém mede: flex com largura infinita **estoura
/// asserção** em vez de estourar layout, e trocar aviso amarelo por crash na primeira pílula que alguém
/// puser numa faixa que rola não é robustez.
///
/// > **Gate de layout que roda na fonte de teste mede uma tela que não existe.** A fonte quadrada é 76%
/// > mais larga que o Inter, e o número que ela produz é um teto — não o produto.
///
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Seletor segmentado: escolhe UMA entre poucas opções.
class BoldSegmentos extends StatelessWidget {
  const BoldSegmentos({
    super.key,
    required this.segmentos,
    required this.indiceSelecionado,
    required this.aoTrocar,
  });

  /// Rótulos, na ordem. Dois ou três — acima disso a pílula não cabe em tela de telefone, e o
  /// componente certo passa a ser outro (lista, dropdown).
  final List<String> segmentos;

  final int indiceSelecionado;
  final ValueChanged<int> aoTrocar;

  @override
  Widget build(BuildContext context) {
    if (segmentos.isEmpty) return const SizedBox.shrink();
    final s = DilettaTheme.schemeOf(context);

    return DilettaDevInfo(
      component: 'segmentos',
      props: {
        'segmentos': '${segmentos.length}',
        'indiceSelecionado': '$indiceSelecionado',
      },
      tokens: const [
        'trilho: surfaceMuted · pastilha: surface · texto ativo: fg',
        'subheading 14/600 · padding s5/s2',
      ],
      // A pílula pede a largura natural dos rótulos; quando o pai não tem tanto, ela reduz a ESCALA em
      // vez de vazar. `centerLeft` porque ela mora ao lado de um rótulo de seção, alinhada à esquerda.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: DilettaBox(
          color: s.surfaceMuted,
          radius: DilettaRadius.pillAll,
          padding: EdgeInsets.all(DilettaSpacing.s1),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < segmentos.length; i++)
              _Segmento(
                rotulo: segmentos[i],
                selecionado: i == indiceSelecionado,
                aoTocar: () => aoTrocar(i),
              ),
          ]),
        ),
      ),
    );
  }
}

class _Segmento extends StatelessWidget {
  const _Segmento({
    required this.rotulo,
    required this.selecionado,
    required this.aoTocar,
  });

  final String rotulo;
  final bool selecionado;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    return Semantics(
      button: true,
      // `selected` é a informação que o componente EXISTE pra dar. Sem ela são três botões iguais.
      selected: selecionado,
      label: rotulo,
      child: ExcludeSemantics(
        child: DilettaTappable(
          onTap: aoTocar,
          child: AnimatedContainer(
            // Os 180ms do antigo não eram degrau de nada: `short` é 150 e é o token de "toggle
            // thumb", que é literalmente isto. A curva também é token (`enter`, que desacelera).
            duration: DilettaMotion.short,
            curve: DilettaMotion.enter,
            padding: EdgeInsets.symmetric(
              horizontal: DilettaSpacing.s5,
              vertical: DilettaSpacing.s2,
            ),
            decoration: BoxDecoration(
              // Só a pastilha ativa tem cor: as outras deixam o trilho aparecer.
              color: selecionado ? s.surface : null,
              borderRadius: DilettaRadius.pillAll,
            ),
            child: DilettaText(
              rotulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DilettaType.subheading.copyWith(
                color: selecionado ? s.fg : s.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
