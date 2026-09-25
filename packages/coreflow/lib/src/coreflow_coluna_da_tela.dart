import 'package:flutter/widgets.dart';

import 'coreflow_espaco.dart' show CoreflowEspaco;
import 'coreflow_largura.dart'
    show CoreflowLargura, CoreflowLarguraDeConteudo, CoreflowSemTeto;

/// **CoreflowColunaDaTela** — a coluna de conteúdo de uma tela, e o ALINHAMENTO dela.
///
/// Nasceu da mesma medição que deu nome ao [CoreflowEspaco.gutter], um eixo adiante. O gutter
/// respondeu *"onde o conteúdo começa"* e o [CoreflowLargura.teto] respondeu *"até onde ele
/// estica"*. Faltava a terceira, e ela não tinha resposta nenhuma: **para que lado os elementos se
/// alinham dentro da coluna.**
///
/// ## A medição, no app do primeiro filho
///
/// 50 colunas de tela em 40 arquivos, todas montadas à mão como
/// `SingleChildScrollView(padding: …gutter…) → Column`. O que elas diziam sobre alinhamento:
///
/// | alinhamento | quantas |
/// |---|---|
/// | `CrossAxisAlignment.start` | 22 |
/// | `CrossAxisAlignment.stretch` | 12 |
/// | **nada declarado** | **16** |
///
/// As 16 não escolheram o centro: elas **não escreveram nada**, e o default do `Column` é `center`.
/// UM TERÇO das telas do produto está centralizado por omissão — e é por isso que um
/// `Center` sozinho no meio de uma coluna à esquerda passava por seis revisões sem ninguém ver: não
/// havia com o que comparar.
///
/// O respiro de baixo dessas 50 tinha **12 valores diferentes**, entre eles `140`, `120` e `60`
/// escritos à mão — enquanto o [CoreflowEspaco.respiroDoRodape] existe, vale 32 e não era usado por
/// nenhuma. O de cima também tinha 8, e o mais comum era 24 (somando `s6` e o próprio
/// `gutter`, que são o mesmo número dito de dois jeitos).
///
/// ## A regra
///
/// **A coluna de uma tela alinha à ESQUERDA. O centro é exceção, e se pede por nome.**
///
/// O nome é [CoreflowAoCentro], e a gramática é a mesma que o teto de largura já usa: quem precisa
/// escapar da regra pede a fuga pelo nome dela ([CoreflowSemTeto]), em vez de escapar por acidente.
/// A diferença entre as duas formas de centralizar passa a estar escrita na tela:
///
/// - `CoreflowAoCentro` é **um elemento** centrado dentro da coluna (um conector, um selo);
/// - centralizar a TELA INTEIRA — rodela de carregando, estado vazio, ilustração — não é assunto
///   desta peça e continua sendo `Center` cru, porque ali não existe coluna nenhuma para alinhar.
///   Medido: das 156 ocorrências de `Center` do app, 48 embrulham uma rodela de carregamento.
///
/// ## Por que [estica] é parâmetro e o alinhamento não é
///
/// Porque as duas leituras existem e foram medidas — 22 contra 12 —, e nenhuma está errada: uma
/// coluna de botões e cartões de largura cheia é `stretch`, uma coluna de texto é `start`. Abrir um
/// `CrossAxisAlignment` livre seria outra coisa: transformaria as 16 omissões em 16 escolhas
/// explícitas de centro e não decidiria nada. O default é a regra; `estica` é a segunda leitura,
/// com nome.
class CoreflowColunaDaTela extends StatelessWidget {
  const CoreflowColunaDaTela({
    super.key,
    required this.filhos,
    this.estica = false,
    this.respiroDeCima = CoreflowEspaco.gutter,
    this.respiroDeBaixo = CoreflowEspaco.respiroDoRodape,
    this.rola = true,
    this.controller,
  });

  final List<Widget> filhos;

  /// Filhos de largura cheia (`CrossAxisAlignment.stretch`) — a segunda leitura. Ver o `///`.
  final bool estica;

  /// 24 por default: a coluna começa à mesma distância da barra e das bordas.
  final double respiroDeCima;

  /// 32 por default ([CoreflowEspaco.respiroDoRodape]) — o fim da rolagem, para o último item não
  /// encostar na barra de baixo.
  final double respiroDeBaixo;

  /// `false` para a coluna que já vive dentro de um scroll de fora (uma folha arrastável, uma aba).
  /// Duas rolagens aninhadas no mesmo eixo é o defeito que isto evita.
  final bool rola;

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final coluna = Column(
      crossAxisAlignment:
          estica ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: filhos,
    );
    final respiro = EdgeInsets.fromLTRB(CoreflowEspaco.gutter, respiroDeCima,
        CoreflowEspaco.gutter, respiroDeBaixo);
    return rola
        ? SingleChildScrollView(
            controller: controller, padding: respiro, child: coluna)
        : Padding(padding: respiro, child: coluna);
  }
}

/// **CoreflowAoCentro** — a exceção à regra da [CoreflowColunaDaTela], pedida por nome.
///
/// UM elemento centrado dentro de uma coluna que alinha à esquerda. Existe para o centro ser uma
/// decisão legível no diff, e não um `Center` que ninguém sabe se foi escolha ou descuido.
///
/// `heightFactor: 1` pela mesma razão do [CoreflowLarguraDeConteudo]: o eixo vertical não é assunto
/// daqui, e sem ele o envelope esticaria na altura e recentralizaria o que estivesse dentro.
class CoreflowAoCentro extends StatelessWidget {
  const CoreflowAoCentro({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Align(alignment: Alignment.center, heightFactor: 1, child: child);
}
