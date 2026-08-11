/// CONTA BOLD — o card de SALDO da home.
///
/// Organismo do produto, por composição: vidro do pai + texto + selo de status + ícone. Nasce no
/// filho porque é arranjo de UMA home — não é `AmountDisplay` com modo oculto, é uma peça com
/// regra própria (o toggle de ocultar mora no top bar; este card só reflete).
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
library;

import 'dart:math' as math;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// O card de saldo.
class BoldSaldo extends StatelessWidget {
  const BoldSaldo({
    super.key,
    required this.valor,
    this.oculto = false,
    this.aoAbrirExtrato,
    this.entradas,
    this.saidas,
    this.carregandoValor = false,
    this.carregandoTotais = false,
  });

  /// Valor já formatado (`BoldDinheiro.formatar`). Mascarado aqui se [oculto].
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
      },
      tokens: const ['type.headlineMd', 'scheme.fg', 'radius.all16'],
      child: DilettaGlassSurface(
        borderRadius: DilettaRadius.all16,
        child: Padding(
          // 16 nos lados e 8 à direita: o botão de extrato carrega o próprio respiro.
          padding: EdgeInsets.fromLTRB(
              DilettaSpacing.s4, DilettaSpacing.s4, DilettaSpacing.s2, DilettaSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                DilettaText('Seu saldo',
                    style: DilettaType.labelLg.copyWith(color: s.fg)),
                const Spacer(),
                if (aoAbrirExtrato != null) _Extrato(aoTocar: aoAbrirExtrato!, cor: s.fg),
              ]),
              DilettaGap.h(DilettaSpacing.s2),
              if (carregandoValor)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: DilettaSpacing.s1),
                  // O ESQUELETO NÃO ANIMA SOZINHO — o `///` do pai diz, e este card é o caso mais visto
                  // do produto: a home abre nele. Chegou como *"o skeleton tem um shimmer rosinha, agora
                  // só é o frame cinza"*, e o meu conserto de ontem tinha embrulhado os 35 do APP e
                  // deixado os 3 que moram AQUI DENTRO — quem carrega o saldo vê estes, não aqueles.
                  child: DilettaShimmer(child: DilettaSkeleton.box(width: 190, height: 26)),
                )
              else
                _ValorComLarguraReservada(
                  valor: valor,
                  mostrado: oculto ? _mascaraDoValor : valor,
                  estilo: estiloDoValor,
                ),
              if (carregandoTotais) ...[
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
                      tone: DilettaStatusTone.danger,
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
    return DilettaTappable(
      onTap: aoTocar,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        DilettaText('Extrato', style: DilettaType.button.copyWith(color: cor)),
        DilettaGap.w(DilettaSpacing.s1),
        DilettaIcon(name: DilettaIcons.angleRightSolid, size: 14, color: cor),
      ]),
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
    required this.mostrado,
    required this.estilo,
  });

  final String valor;
  final String mostrado;
  final TextStyle estilo;

  double _largura(String texto) => (TextPainter(
        text: TextSpan(text: texto, style: estilo),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout())
          .width;

  @override
  Widget build(BuildContext context) {
    // A largura é a do MAIOR dos dois, e não a do valor real. Reservar só o
    // valor funciona enquanto a máscara for mais estreita que ele — e ela não é:
    // `R$ ••••••` é mais larga que `R$ 0,14`, então o saldo baixo ocultava
    // sumia, cortado dentro do próprio `SizedBox`. O que se quer aqui é que o
    // card NÃO MEXA ao virar o olho, e isso é o máximo dos dois estados.
    return SizedBox(
      width: math.max(_largura(valor), _largura(mostrado)),
      child: DilettaText(mostrado, style: estilo, maxLines: 1),
    );
  }
}
