/// CONTA BOLD — o card de SALDO da home.
///
/// Organismo do produto, por composição: vidro do pai + texto + selo de status + ícone. Nasceu no
/// filho como arranjo de UMA home e veio para o pai em 08/09 com as peças que não dependem de
/// produto — não é `AmountDisplay` com modo oculto, é uma peça com regra própria (o toggle de
/// ocultar mora no top bar; este card só reflete).
///
/// 3 usos no produto antigo.
///
/// ## O que a adaptação mudou
///
/// **Largura reservada em vez de `Stack` de opacidade.** A versão antiga empilhava o valor
/// invisível atrás do visível pra reservar a largura, então mascarar não deslocava nada. O truque
/// funciona e custa uma árvore dupla; o `TextPainter` do próprio Flutter mede sem pintar. Mesma
/// garantia, metade dos widgets — e o motivo do truque continua escrito, que é o que importa.
///
/// **`SizedBox` virou `DilettaGap`, `Text` virou `DilettaText`.** Exigência 3 e 5 do contrato:
/// construção crua fica fora da instrumentação, então o dev mode não publica o token nem o preset.
///
/// **O ocultar cobre valor E totais.** Já era assim, e fica registrado porque é decisão de
/// produto, não detalhe: esconder o saldo e deixar as entradas visíveis não esconde nada.
///
/// ## O saldo BLOQUEADO (05/10)
///
/// O app passou a conhecer saldo bloqueado (judicial, MED) e o número grande deixou de ser o saldo
/// inteiro. Dois parâmetros opcionais, e a peça é **idêntica à de antes quando os dois faltam**:
/// [rotuloDoValor], um rótulo curto acima do número («Disponível para usar»), e [bloqueado], uma
/// linha abaixo dele — cadeado, «R\$ 1.500,00 bloqueados» e, quando [aoTocarNoBloqueado] existe, o
/// chevron e o alvo de 44. A linha mascara com a MESMA máscara do valor e reserva a largura do
/// mesmo jeito: o olho não move o chevron. O total não entra aqui — é da folha e da recusa.
library;

import 'dart:math' as math;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'coreflow_scheme.dart' show CoreflowScheme;

/// O card de saldo.
class CoreflowSaldo extends StatelessWidget {
  const CoreflowSaldo({
    super.key,
    required this.valor,
    this.oculto = false,
    this.aoAbrirExtrato,
    this.entradas,
    this.saidas,
    this.carregandoValor = false,
    this.carregandoTotais = false,
    this.rotuloDoValor,
    this.bloqueado,
    this.aoTocarNoBloqueado,
  });

  /// Valor já formatado (`CoreflowDinheiro.formatar`). Mascarado aqui se [oculto].
  final String valor;

  /// O olho do top bar oculta o saldo E os totais — meia máscara não esconde nada.
  final bool oculto;

  /// Some quando nulo.
  final VoidCallback? aoAbrirExtrato;

  /// Totais do mês, SEM sinal: o selo carrega a semântica. Somem quando nulos.
  final String? entradas;
  final String? saidas;

  final bool carregandoValor;

  /// Skeleton no lugar dos selos. Existe pra evitar o "pop-in" — os selos surgirem do nada depois
  /// que o card já está na tela.
  final bool carregandoTotais;

  /// Rótulo curto ACIMA do número grande. Nulo: nenhuma linha, nenhum espaço.
  ///
  /// Existe porque com bloqueio o número grande não é o saldo inteiro, e um número sem nome é o
  /// que a pessoa lê como «meu dinheiro». No app é «Disponível para usar», e só quando há bloqueio.
  final String? rotuloDoValor;

  /// O que está bloqueado, JÁ FORMATADO (`CoreflowDinheiro.formatar`). A peça escreve
  /// «R\$ 1.500,00 bloqueados» abaixo do valor, com o cadeado. Nulo: nenhuma linha, nenhum espaço.
  ///
  /// Mascara com a mesma máscara do valor quando [oculto] — e não com a dos totais: é saldo, não
  /// selo. A largura é reservada como a do valor, pelo mesmo motivo: o olho não move o chevron.
  final String? bloqueado;

  /// Abre a explicação do bloqueio. Nulo: a linha fica, sem chevron e sem toque — não se desenha
  /// alvo morto. Com ele, a linha é alvo de 44 ([DilettaAlvoDeToque]) e absorve o respiro em volta.
  final VoidCallback? aoTocarNoBloqueado;

  static const String _mascaraDoValor = r'R$ ••••••';
  static const String _mascaraDoTotal = r'R$ ••••';

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final estiloDoValor = DilettaType.headlineMd.copyWith(color: s.fg);

    return DilettaDevInfo(
      component: 'saldo',
      props: {
        'oculto': '$oculto',
        'entradas': entradas == null ? 'ausente' : 'presente',
        'saidas': saidas == null ? 'ausente' : 'presente',
        'rotuloDoValor': rotuloDoValor == null ? 'ausente' : 'presente',
        'bloqueado': bloqueado == null ? 'ausente' : 'presente',
      },
      tokens: const [
        'type.headlineMd',
        'type.labelMd',
        'scheme.fg',
        'scheme.textSecondary',
        'scheme.formaDoVidro',
      ],
      child: DilettaGlassSurface(
        borderRadius: CoreflowScheme.of(context).formaDoVidro,
        child: Padding(
          // 16 nos lados e 8 à direita: o botão de extrato carrega o próprio respiro.
          padding: EdgeInsets.fromLTRB(DilettaSpacing.s4, DilettaSpacing.s4,
              DilettaSpacing.s2, DilettaSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                DilettaText('Seu saldo',
                    style: DilettaType.labelLg.copyWith(color: s.fg)),
                const Spacer(),
                if (aoAbrirExtrato != null)
                  _Extrato(aoTocar: aoAbrirExtrato!, cor: s.fg),
              ]),
              DilettaGap.h(DilettaSpacing.s2),
              if (rotuloDoValor != null) ...[
                DilettaText(rotuloDoValor!,
                    style:
                        DilettaType.labelMd.copyWith(color: s.textSecondary)),
                DilettaGap.h(DilettaSpacing.s1),
              ],
              if (carregandoValor)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: DilettaSpacing.s1),
                  // O ESQUELETO NÃO ANIMA SOZINHO — o `///` do pai diz, e este card é o caso mais visto
                  // do produto: a home abre nele. Chegou como *"o skeleton tem um shimmer rosinha, agora
                  // só é o frame cinza"*, e o meu conserto de ontem tinha embrulhado os 35 do APP e
                  // deixado os 3 que moram AQUI DENTRO — quem carrega o saldo vê estes, não aqueles.
                  child: DilettaShimmer(
                      child: DilettaSkeleton.box(width: 190, height: 26)),
                )
              else
                _ValorComLarguraReservada(
                  valor: valor,
                  mascara: _mascaraDoValor,
                  oculto: oculto,
                  estilo: estiloDoValor,
                ),
              if (bloqueado != null) ...[
                // Sem toque a linha é texto, e leva o respiro de texto. Com toque ela é alvo de
                // 44 e o respiro mora DENTRO do alvo (14 acima e abaixo de uma linha de 16): somar
                // o s2 por fora afastaria o bloqueado do número que ele qualifica.
                if (aoTocarNoBloqueado == null) DilettaGap.h(DilettaSpacing.s2),
                _Bloqueado(
                  valor: bloqueado!,
                  mascara: _mascaraDoValor,
                  oculto: oculto,
                  aoTocar: aoTocarNoBloqueado,
                  cor: s.fg,
                ),
              ],
              if (carregandoTotais) ...[
                if (bloqueado == null || aoTocarNoBloqueado == null)
                  DilettaGap.h(DilettaSpacing.s2),
                // UM shimmer pros dois selos, e não um por selo: a varredura atravessa o par como
                // atravessaria o conteúdo que vem no lugar dele. Dois wrappers dariam duas bandas fora
                // de fase, que lê como dois carregamentos independentes.
                DilettaShimmer(
                  child: Row(children: [
                    DilettaSkeleton.box(width: 92, height: 20),
                    DilettaGap.w(DilettaSpacing.s1),
                    DilettaSkeleton.box(width: 92, height: 20),
                  ]),
                ),
              ] else if (entradas != null || saidas != null) ...[
                if (bloqueado == null || aoTocarNoBloqueado == null)
                  DilettaGap.h(DilettaSpacing.s2),
                Row(children: [
                  if (entradas != null)
                    DilettaStatusTag(
                      label: oculto ? _mascaraDoTotal : entradas!,
                      icon: DilettaIcons.arrowRightToBracketSolid,
                      tone: DilettaStatusTone.success,
                    ),
                  if (entradas != null && saidas != null)
                    DilettaGap.w(DilettaSpacing.s1),
                  if (saidas != null)
                    DilettaStatusTag(
                      label: oculto ? _mascaraDoTotal : saidas!,
                      icon: DilettaIcons.arrowRightFromBracketSolid,
                      tone: DilettaStatusTone.error,
                    ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Extrato extends StatelessWidget {
  const _Extrato({required this.aoTocar, required this.cor});

  final VoidCallback aoTocar;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    // UM nó para o leitor de tela: botão, com nome e dica. Sem isto o `DilettaTappable` publica o
    // gesto sem papel e o texto solto ao lado — «Extrato», e não «Extrato, botão». É o mesmo
    // arranjo do `DilettaTextLink` do avô, com o texto de dentro fora da árvore para não repetir.
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: 'Extrato',
        hint: 'Abre o extrato',
        child: DilettaTappable(
          onTap: aoTocar,
          child: ExcludeSemantics(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              DilettaText('Extrato',
                  style: DilettaType.button.copyWith(color: cor)),
              DilettaGap.w(DilettaSpacing.s1),
              DilettaIcon(
                  name: DilettaIcons.angleRightSolid, size: 14, color: cor),
            ]),
          ),
        ),
      ),
    );
  }
}

/// A linha do BLOQUEADO: cadeado, «R\$ 1.500,00 bloqueados» e, se abre algo, o chevron.
///
/// O glifo e o texto vão juntos porque cor não é a única informação — a linha é da mesma cor do
/// valor, e o que a distingue é o cadeado e a palavra. O texto passa pela mesma reserva de largura
/// do valor, medido nos dois estados: mascarar não anda com o chevron.
class _Bloqueado extends StatelessWidget {
  const _Bloqueado({
    required this.valor,
    required this.mascara,
    required this.oculto,
    required this.aoTocar,
    required this.cor,
  });

  final String valor;
  final String mascara;
  final bool oculto;
  final VoidCallback? aoTocar;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    // Como o do valor: o degrau não fixa família, e é o medidor quem funde o `DefaultTextStyle`.
    final estilo = DilettaType.labelMd.copyWith(color: cor);
    final linha = Row(mainAxisSize: MainAxisSize.min, children: [
      DilettaIcon(name: DilettaIcons.lockLight, size: 14, color: cor),
      DilettaGap.w(DilettaSpacing.s1),
      _ValorComLarguraReservada(
        valor: '$valor bloqueados',
        mascara: '$mascara bloqueados',
        oculto: oculto,
        estilo: estilo,
      ),
      if (aoTocar != null) ...[
        DilettaGap.w(DilettaSpacing.s1),
        DilettaIcon(name: DilettaIcons.angleRightSolid, size: 14, color: cor),
      ],
    ]);
    // O nome para o leitor de tela. Com o olho fechado ele não lê a máscara («R cifrão, bullet
    // bullet…») nem vaza o número: diz que está oculto.
    final nome = oculto ? 'Saldo bloqueado, valor oculto' : '$valor bloqueados';
    if (aoTocar == null) {
      return Semantics(label: nome, excludeSemantics: true, child: linha);
    }
    // O toque fica POR FORA do alvo: é a caixa de 44 inteira que responde, não só a linha de 16.
    // E é UM nó, botão com nome e dica — esta linha é a única entrada da Home para a explicação
    // do bloqueio, e um gesto sem papel é «R\$ 1.500,00 bloqueados» sem dizer que se toca.
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: nome,
        hint: 'Abre a explicação do bloqueio',
        child: DilettaTappable(
          onTap: aoTocar,
          child: ExcludeSemantics(child: DilettaAlvoDeToque(child: linha)),
        ),
      ),
    );
  }
}

/// O valor, com a largura do valor REAL reservada mesmo quando mascarado.
///
/// Sem isso, alternar o olho encolhe o card e a tela pula. A versão antiga resolvia empilhando o
/// valor invisível atrás do visível; aqui o `TextPainter` mede sem pintar, o que dá a mesma
/// garantia com uma árvore em vez de duas.
class _ValorComLarguraReservada extends StatelessWidget {
  const _ValorComLarguraReservada({
    required this.valor,
    required this.mascara,
    required this.oculto,
    required this.estilo,
  });

  /// Os DOIS textos, sempre — e não "o que está na tela".
  ///
  /// A peça recebia `mostrado`, já resolvido pelo estado, e reservava o máximo entre ele e o valor.
  /// No estado VISÍVEL os dois são a mesma string, então o máximo era a largura do valor: a caixa
  /// media 98 com o saldo à mostra e 128 com ele oculto. **A intenção escrita aqui é que ela não
  /// mexa**, e ela mexia — o `max` só via um dos dois estados de cada vez.
  final String valor;
  final String mascara;
  final bool oculto;
  final TextStyle estilo;

  /// A largura de um texto, medida com o estilo que ele VAI TER — não com o que foi passado.
  ///
  /// **O `estilo` que chega aqui é incompleto de propósito.** Os degraus de [DilettaType] não fixam
  /// família nem escala: eles herdam do tema, e é assim que a fonte da marca chega em todo lugar
  /// sem ninguém repetir o nome dela. Só que o [TextPainter] **não herda nada** — ele mede exatamente
  /// o `TextSpan` que recebe. Então o medidor media numa fonte e o [DilettaText] pintava em outra.
  ///
  /// Onde isso doía: a máscara. `R\$ ••••••` é mais larga que `R\$ 0,14`, e quando a medição
  /// subestima a máscara o `SizedBox` sai pequeno — o valor oculto aparece cortado, ou some depois do
  /// `R\$`. O bug não é a máscara: é o medidor não saber que a tela mudou de fonte debaixo dele.
  ///
  /// O `textScaler` entra pela mesma razão, e é o mesmo defeito com outra causa: com a escala do
  /// sistema aumentada o texto cresce e a caixa não, porque a medição ignorava a escala. Este app
  /// trava o scaler hoje, mas o pacote não é deste app.
  double _largura(BuildContext context, String texto) => (TextPainter(
        text: TextSpan(
            text: texto,
            style: DefaultTextStyle.of(context).style.merge(estilo)),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 1,
      )..layout())
          .width;

  @override
  Widget build(BuildContext context) {
    // O máximo dos DOIS ESTADOS, medido nos dois sempre. `R$ ••••••` é mais larga que `R$ 0,14`,
    // então num saldo baixo a máscara não cabe na largura do valor — e o oculto sai cortado, que na
    // tela lê como uma peça sem máscara nenhuma.
    //
    // **A largura vai ARREDONDADA PARA CIMA, e sem isso o último algarismo
    // some.** A medição devolve fracionário; uma caixa de 96,4 px recebendo um
    // texto de 96,4 px corta o glifo final na pintura, porque o `maxLines: 1`
    // com clip não tem para onde sobrar. Na tela do app isso apareceu como
    // `R$ 913,2` num saldo de R$ 913,25 — e não é arredondamento de valor, é um
    // dígito faltando num número que a pessoa confere.
    return Semantics(
      // Oculto, o leitor de tela diz «valor oculto» — e não soletra a máscara nem vaza o número.
      label: oculto ? 'valor oculto' : valor,
      excludeSemantics: true,
      child: SizedBox(
        width: larguraDaCaixaDoSaldo(
            math.max(_largura(context, valor), _largura(context, mascara))),
        child:
            DilettaText(oculto ? mascara : valor, style: estilo, maxLines: 1),
      ),
    );
  }
}

/// A largura da caixa a partir da largura MEDIDA do texto.
///
/// Arredonda para cima, e é a regra inteira. Sobrar sub-pixel é invisível;
/// faltar algarismo, não — e num saldo é o algarismo que a pessoa está lendo.
///
/// Público para ser testável sem subir a árvore de widgets: o defeito vive na
/// aritmética, não no layout.
double larguraDaCaixaDoSaldo(double medida) => medida.ceilToDouble();
