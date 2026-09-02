/// **O TETO DE LARGURA DESTE PRODUTO** — 600, e o que ele resolve é o tablet.
///
/// Escrito pelo time do app entre 27/08 e 01/09, dentro de `lib/design_system/widgets/` — e chegou
/// aqui por um merge, não por uma decisão: a adoção esvaziou aquela pasta no mesmo dia em que eles
/// estavam construindo dentro dela. As duas coisas estavam certas e nenhuma sabia da outra.
///
/// Numa tela larga o conteúdo deste produto não estica: ele para em 600 e centraliza. Três peças
/// dizem isso, e a terceira é a que faz a regra ser usável:
///
/// - [CoreflowLarguraDeConteudo] — o teto;
/// - [CoreflowBarraComTeto] — o mesmo teto para quem precisa ser `PreferredSizeWidget` (a barra de
///   topo de um `Scaffold`);
/// - [CoreflowSemTeto] — a fuga. Um fundo, uma faixa colorida, um carrossel que sangra: quem
///   precisa da largura CHEIA pede por nome, em vez de escapar do teto por acidente;
/// - [coreflowSobraLateral] — quanto sobrou de cada lado. É o que um overlay posicionado por
///   coordenada absoluta precisa saber pra não colar na borda da tela em vez da borda do conteúdo.
///
/// **O `OverflowBoxFit.deferToChild` do [CoreflowSemTeto] não é detalhe**: sem ele o `OverflowBox`
/// reporta o tamanho do PAI, e uma faixa que sangra passaria a ditar a altura da coluna inteira.

import 'dart:math' as math;

import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/widgets.dart';

/// O número, num lugar só.
class CoreflowLargura {
  CoreflowLargura._();

  /// 600 — o ponto em que o conteúdo deste produto para de esticar e centraliza.
  static const double teto = 600;
}



/// Conta BOLD — Teto de largura do conteúdo.
///
/// Limita o conteúdo de interface a [CoreflowLargura.teto] e centraliza a sobra.
/// Em tela mais estreita que o teto é **transparente**: a largura continua sendo
/// a do pai, sem faixa lateral vazia.
///
/// O ponto de aplicação principal é o `child` de [BoldBackground] — as camadas de
/// fundo são irmãs anteriores no mesmo `Stack` e ficam de fora, então o fundo
/// segue em 100% da largura por trás do conteúdo limitado. As camadas que não
/// passam pelo corpo da tela (rodapé do `Scaffold`, bandeja flutuante, gaveta,
/// diálogo, toast) aplicam este envelope uma a uma.
///
/// A largura é **tight** (`SizedBox(width:)`) de propósito, e não um
/// `ConstrainedBox(maxWidth:)`: [Align] passa constraints LOOSE ao filho, e sob
/// largura loose um [Column] se encolhe até a largura do filho mais largo — o
/// `CrossAxisAlignment.stretch` dos scaffolds e os `Expanded`/`ListView` de
/// dezenas de telas passariam a esticar até esse filho em vez de até o teto. Com
/// largura tight os layouts se comportam como sempre, só com outro número.
///
/// O eixo VERTICAL não é assunto daqui — daí o `heightFactor: 1`, que faz o
/// envelope ter a altura EXATA do filho. Com um [Center] (ou um [Align] sem
/// `heightFactor`) ele esticaria na vertical e recentralizaria o conteúdo: um
/// bloco que vive dentro de um `Align(bottomCenter)` sairia do rodapé e iria para
/// o meio da tela. Quem posiciona continua sendo o `Positioned` / `Align` /
/// `Column` de fora.
class CoreflowLarguraDeConteudo extends StatelessWidget {
  const CoreflowLarguraDeConteudo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      // Só o eixo horizontal: sem `widthFactor` o Align ocupa a largura toda e
      // centraliza o filho nela.
      alignment: Alignment.center,
      heightFactor: 1,
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: math.min(constraints.maxWidth, CoreflowLargura.teto),
          child: child,
        ),
      ),
    );
  }
}

/// [BoldContentWidth] para o slot `appBar:` do `Scaffold`, que exige um
/// [PreferredSizeWidget].
///
/// Só as telas de `Scaffold` cru que usam `AppBar` do Material precisam disto —
/// as telas do DS desenham a `BoldTopBar` dentro do corpo, já coberto pelo teto.
/// O `preferredSize` é delegado ao filho: quem manda na ALTURA da barra continua
/// sendo a própria barra.
class CoreflowBarraComTeto extends StatelessWidget
    implements PreferredSizeWidget {
  const CoreflowBarraComTeto({super.key, required this.child});

  final PreferredSizeWidget child;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) => CoreflowLarguraDeConteudo(child: child);
}

/// Quanto a tela passa de [CoreflowLargura.teto], dividido pelos dois lados —
/// `0` em tela de até 600 px.
///
/// É o teto expresso como MARGEM, para quem posiciona por inset em vez de por
/// pai que centraliza: `Positioned(left:/right:)`, `insetPadding` de diálogo,
/// `EdgeInsets` de uma faixa. Nesses lugares o [BoldContentWidth] não serve — ele
/// expande até a largura disponível para poder centralizar, o que esticaria a
/// superfície (o painel do diálogo, a barra do toast) e encolheria só o texto
/// dentro dela.
///
/// ```dart
/// Positioned(left: 24 + boldSobraLateral(context), right: 24 + boldSobraLateral(context), ...)
/// ```
double coreflowSobraLateral(BuildContext context) =>
    math.max(0.0, MediaQuery.of(context).size.width - CoreflowLargura.teto) / 2;

/// Conta BOLD — Escape do teto: pinta o filho na largura INTEIRA da tela, de
/// dentro do conteúdo já limitado.
///
/// Depois do teto, um elemento dentro do conteúdo não alcança mais as bordas da
/// tela: um `Positioned.fill` passa a se referir ao box de [CoreflowLargura.teto].
/// Este é o escape para o caso legítimo — um herói, uma faixa ou uma arte que
/// precisa sangrar. Use com parcimônia: fora daqui, conteúdo nenhum ultrapassa o
/// teto.
///
/// `OverflowBox` é a mesma técnica que [BoldBackground.statusBarScrim] já usa no
/// eixo vertical — não é padrão novo no repo, é o padrão existente no outro eixo.
///
/// `fit: OverflowBoxFit.deferToChild` **não é opcional**: no `max` (o default) o
/// `OverflowBox` se dimensiona por `constraints.biggest`, e aí ele ocupa TODA a
/// altura disponível — dentro de um `Column` sem altura limitada isso vira
/// altura infinita, e dentro de um com altura limitada empurra os irmãos para
/// fora (medido em teste antes de chegar aqui). Com `deferToChild` a pegada é a
/// do filho (largura ainda contida no pai, sem violar constraint) e só a PINTURA
/// sangra.
class CoreflowSemTeto extends StatelessWidget {
  const CoreflowSemTeto({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final larguraDaTela = MediaQuery.of(context).size.width;
    return OverflowBox(
      alignment: Alignment.center,
      fit: OverflowBoxFit.deferToChild,
      minWidth: larguraDaTela,
      maxWidth: larguraDaTela,
      child: child,
    );
  }
}
