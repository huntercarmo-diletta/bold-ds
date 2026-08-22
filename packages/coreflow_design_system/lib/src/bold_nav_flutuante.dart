/// CONTA BOLD — a NAV FLUTUANTE da home: pílula de vidro que abraça os itens.
///
/// Ela atravessou a fronteira em 13/08, e o print que a trouxe foi direto ao ponto: *"a navbar da home tá
/// diferente, parece que você redesenhou do zero."* Não redesenhei — o catálogo desenhava a barra do
/// PAI, porque era a única que existia deste lado. E a diferença entre as duas está escrita, palavra por
/// palavra, no `///` do `BoldBottomApp` dentro do app:
///
/// > *"A `.nav` é outra história: a do pai é barra ANCORADA full-width, itens em `Expanded`, círculo do
/// > ativo estourando a borda de cima, traço de home por dentro. A daqui é **pílula flutuante** com hug e
/// > margem de 16. Não é cópia da dele com defeito — é outro desenho, e trocar é decisão de produto."*
///
/// O desenho estava declarado, o produto tinha escolhido, e o board mostrava o outro. **Divergência que
/// alguém precisa de um print pra achar é a mais cara que este repo tem** — ela passa por decisão de
/// design.
///
/// ## Ela é peça PRÓPRIA, e não variante da casca do pai
///
/// O `barraDeBaixo` do catálogo é a união das cinco factories do `DilettaBottomApp`, e a `nav` dele
/// continua lá — a barra ancorada existe, e outro produto da família pode querer ela. Esta é um segundo
/// bloco porque é um segundo desenho: hug em vez de fill, flutuante em vez de ancorada, e **sem o traço
/// de home por dentro** — na pílula o indicador é do aparelho, e é por isso que a home declara o
/// `indicadorDeHome` ao lado dela enquanto as telas de `barraDeBaixo` não declaram.
///
/// ## O que a mudança de casa alterou, e cada uma tem número
///
/// **O vidro virou `DilettaGlassSurface`.** No app são `BoldGlass.fill` + stroke + `BackdropFilter`
/// montados à mão, com um desvio SÓ aqui: no claro o branco sobe de 50% pra 75%, porque a nav puxava
/// escuro pelo blur sobre a arte da home. É a mesma troca que o ladrilho de menu fez ao cruzar
/// (`BoldCard(glass: true)` → superfície do pai), e o desvio do claro fica de fora — vidro com exceção
/// por componente é o começo de dois vidros.
///
/// **Raio 26 → `all24`.** Vinte e seis não é degrau da escada do pai. A diferença de 2 num raio de
/// pílula não é vista; a de um raio fora da escada é, no dia em que alguém copia o 26 pra outra peça.
///
/// **Rótulo de 10px cravado → `DilettaType.labelSm` (11/16).** Terceira peça a pagar este mesmo atalho
/// na travessia — o ladrilho e a amostra de fundo vieram antes. Dez não existe na escada.
///
/// **Vão ícone→rótulo 3 → `s1` (4)**, e o respiro do spot 6 → `s1_5`, que existe e é exatamente 6.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Um item da [CoreflowNavFlutuante]: glifo do conjunto do pai + rótulo.
class CoreflowItemDeNav {
  const CoreflowItemDeNav({required this.icone, required this.rotulo});

  /// Nome do glifo no conjunto do pai (`DilettaIcons.houseLight`).
  final String icone;

  final String rotulo;
}

/// A pílula flutuante de navegação da home.
class CoreflowNavFlutuante extends StatelessWidget {
  const CoreflowNavFlutuante({
    super.key,
    required this.itens,
    required this.ativo,
    this.aoTrocar,
  });

  final List<CoreflowItemDeNav> itens;

  /// Índice do item ativo. Fora da lista, nenhum acende — e isso é de propósito: a nav também aparece
  /// em tela EMPILHADA sobre a home, onde nenhuma aba é a atual.
  final int ativo;

  final ValueChanged<int>? aoTrocar;

  @override
  Widget build(BuildContext context) {
    final pilula = DilettaGlassSurface(
      borderRadius: DilettaRadius.all24,
      child: DilettaFrame.row(
        mainAxisSize: MainAxisSize.min,
        gap: DilettaSpacing.s6,
        padding: const EdgeInsets.symmetric(
            vertical: DilettaSpacing.s2, horizontal: DilettaSpacing.s6),
        children: [
          for (final (i, item) in itens.indexed)
            _Item(
              item: item,
              ativo: i == ativo,
              aoTocar: aoTrocar == null ? null : () => aoTrocar!(i),
            ),
        ],
      ),
    );

    return DilettaDevInfo(
      component: 'navFlutuante',
      props: {'itens': '${itens.length}', 'ativo': '$ativo'},
      tokens: const [
        'radius.all24',
        'elevation.medium',
        'espaco.s6',
        'type.labelSm',
        'scheme.primary',
      ],
      // A sombra mora no container EXTERNO, fora do clip do vidro. É requisito do app e a razão é
      // física: sombra atrás de um `BackdropFilter` é reamostrada pelo blur e vira halo sujo.
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: DilettaSpacing.s4),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: DilettaRadius.all24,
              boxShadow: DilettaElevation.medium,
            ),
            child: ClipRRect(borderRadius: DilettaRadius.all24, child: pilula),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.item, required this.ativo, this.aoTocar});

  final CoreflowItemDeNav item;
  final bool ativo;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    final coluna = DilettaFrame.column(
      mainAxisSize: MainAxisSize.min,
      // `center` e não o default: o `DilettaFrame.column` nasce em `stretch`, e dentro de uma linha que
      // encolhe isso vira LARGURA INFINITA TIGHT no filho — o render estourou com
      // `BoxConstraints(w=Infinity)` na primeira tentativa. O item da pílula tem largura de conteúdo, e o
      // ícone e o rótulo se alinham no meio dela.
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: DilettaSpacing.s1,
      children: [
        // O SPOT do ativo é círculo cheio de `primary` com o glifo em `onPrimary`; o inativo não tem
        // círculo, e o glifo fica no ink do tema. Círculo transparente e não ausente: sem ele o item
        // inativo sobe 12 pixels e a fila desalinha.
        DecoratedBox(
          decoration: BoxDecoration(
            color: ativo ? s.primary : const Color(0x00000000),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(DilettaSpacing.s1_5),
            child: DilettaIcon(
              name: item.icone,
              size: 20,
              color: ativo ? s.onPrimary : s.fg,
            ),
          ),
        ),
        // O rótulo fica no ink do tema NOS DOIS estados, e só o peso muda. É decisão do app, e ela está
        // certa por contraste: rótulo rosa sobre vidro claro perde do fundo, e o peso responde por quem
        // não distingue as duas tintas.
        DilettaText(
          item.rotulo,
          maxLines: 1,
          style: DilettaType.labelSm.copyWith(
            color: s.fg,
            fontWeight: ativo ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );

    if (aoTocar == null) return coluna;
    return DilettaTappable(onTap: aoTocar, child: coluna);
  }
}
