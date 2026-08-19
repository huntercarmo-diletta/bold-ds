/// CONTA BOLD — o LADRILHO do menu, e ele era a maior lacuna que restava.
///
/// O inventário de adoção marcava `BoldMenuTile` como **lacuna com alcance 4** — a maior das quatro
/// que sobraram depois de o legado sair. Lacuna quer dizer o que está escrito: peça que desenha
/// sozinha, sem par na linguagem, e que por isso não existe no catálogo.
///
/// O custo não era teórico. O dono pediu as quatro telas de loja em alta fidelidade, e **três delas
/// param aqui**: o menu 2×2 da home, o menu compacto da Área Pix e os atalhos do login recorrente
/// são todos este ladrilho. Uma peça que só existe no aparelho é uma peça que não dá pra desenhar
/// em lugar nenhum.
///
/// ## Por que ele NÃO é o `DilettaQuickAccessCard`
///
/// A pergunta óbvia, e ela tem resposta medida. O cartão de acesso rápido do pai é 75×84, ícone
/// dentro de um pill circular, conteúdo **centrado**, e tem estado `locked` com cadeado. Este é
/// alinhado à **esquerda**, sem pill, sem estado, e existe em três portes porque o produto o usa em
/// três grades diferentes.
///
/// São duas peças com o mesmo papel e gramáticas opostas. Trocar uma pela outra não é adoção — é
/// redesenhar três telas por baixo do pano. Fica como componente deste filho, que é onde mora o
/// desenho do produto.
///
/// ## O que a mudança de casa alterou
///
/// **`BoldType.tileLabel` (10/12) virou `DilettaType.labelSm` (11/16).** O grau de 10px não existe
/// na escada do pai, e ele era o único sítio do app que o usava. Um degrau com um usuário é um
/// degrau que não é escada — e 10px de rótulo já estava no limite do que se lê num ladrilho de 85.
///
/// **O vidro virou o `DilettaGlassSurface` do pai.** Era `BoldCard(glass: true)`, que é a mesma
/// superfície com outro nome deste lado da fronteira.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Porte do [BoldLadrilhoDeMenu] — os três são medidos no produto, não inventados.
enum BoldPorteDoLadrilho {
  /// Altura 80, largura de quem posiciona. A grade de três colunas do menu da Área Pix.
  ///
  /// Era 85×80 fixo até 19/08, num fluxo que quebrava de linha. Ver a razão no `switch` do `build`.
  compacto,

  /// Largura cheia, altura 82. O menu 2×2 da home.
  largo,

  /// Largura cheia, altura 100. Os atalhos do login recorrente, com o conteúdo centrado na vertical.
  alto,
}

/// O ladrilho de menu: vidro, ícone em cima, rótulo embaixo, tudo à esquerda.
class BoldLadrilhoDeMenu extends StatelessWidget {
  const BoldLadrilhoDeMenu({
    super.key,
    required this.icone,
    required this.rotulo,
    this.aoTocar,
    this.porte = BoldPorteDoLadrilho.largo,
  });

  /// Nome do glifo no conjunto do pai.
  final String icone;

  final String rotulo;
  final VoidCallback? aoTocar;
  final BoldPorteDoLadrilho porte;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final compacto = porte == BoldPorteDoLadrilho.compacto;

    final respiro = switch (porte) {
      // O compacto respira 8 e não 12, e o número saiu de uma medição: com o rótulo em `labelSm`
      // (11/16) duas linhas ocupam 32, e 20 de ícone + 8 de vão + 32 + 12×2 dá **84 num cartão de
      // 80** — o board estourou por 4 pixels exatos. O degrau antigo era 10/12 e cabia; ele saiu
      // porque tinha um usuário só, e um degrau com um usuário não é escada.
      //
      // Encolher o respiro é melhor que crescer o cartão: 85 de largura com 12 de cada lado deixa
      // 61 pro rótulo, e "Agência e conta" trunca. Com 8 sobram 69.
      BoldPorteDoLadrilho.compacto => EdgeInsets.all(DilettaSpacing.s2),
      BoldPorteDoLadrilho.largo => EdgeInsets.all(DilettaSpacing.s4),
      BoldPorteDoLadrilho.alto => EdgeInsets.symmetric(
          horizontal: DilettaSpacing.s4, vertical: DilettaSpacing.s3),
    };
    // O largo respira mais entre ícone e rótulo porque é o único que tem altura sobrando.
    final vao = porte == BoldPorteDoLadrilho.largo ? DilettaSpacing.s3 : DilettaSpacing.s2;

    Widget ladrilho = DilettaDevInfo(
      component: 'ladrilhoDeMenu',
      props: {'icone': icone, 'porte': porte.name},
      tokens: const ['radius.all16', 'type.labelMd', 'scheme.fg'],
      child: DilettaGlassSurface(
        borderRadius: DilettaRadius.all16,
        child: Padding(
          padding: respiro,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // O alto centra na vertical: ele tem 100 de altura pra 40 de conteúdo, e alinhar ao topo
            // deixaria metade do cartão vazia embaixo.
            mainAxisAlignment: porte == BoldPorteDoLadrilho.alto
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              DilettaIcon(name: icone, size: 20, color: s.fg),
              DilettaGap.h(vao),
              DilettaText(
                rotulo,
                // O compacto quebra em duas linhas porque a largura é 85 e os rótulos do Pix
                // ("Agência e conta") não cabem numa.
                maxLines: compacto ? 2 : 1,
                style: (compacto ? DilettaType.labelSm : DilettaType.labelMd)
                    .copyWith(color: s.fg),
              ),
            ],
          ),
        ),
      ),
    );

    if (aoTocar != null) {
      ladrilho = DilettaTappable(onTap: aoTocar, child: ladrilho);
    }

    return switch (porte) {
      // **O COMPACTO PAROU DE CRAVAR LARGURA em 19/08, por decisão do dono do produto.**
      //
      // Era `width: 85` fixo, e o desenho em volta era um FLUXO: os ladrilhos abraçavam a própria
      // largura e quebravam de linha quando não cabiam. Isso tinha razão escrita e defendida — foi o
      // argumento que pôs o `DilettaFrame.flow` na linguagem do pai.
      //
      // O que derrubou o argumento foi o aparelho: 85×3 + 8×2 = **271 numa linha de 350**, então
      // sobravam **79pt vazios à direita** enquanto três dos seis rótulos quebravam em duas linhas
      // por falta de 4px. Fluxo que sobra espaço e quebra texto ao mesmo tempo não está economizando
      // nada — e o dono decidiu a grade olhando as duas coisas juntas.
      //
      // Só a ALTURA fica: quem posiciona decide a largura (`Expanded` numa fila de três), e a peça
      // continua respondendo por 80 de altura, que é o número do desenho.
      BoldPorteDoLadrilho.compacto => SizedBox(height: 80, child: ladrilho),
      BoldPorteDoLadrilho.largo => SizedBox(height: 82, child: ladrilho),
      BoldPorteDoLadrilho.alto => SizedBox(height: 100, child: ladrilho),
    };
  }
}
