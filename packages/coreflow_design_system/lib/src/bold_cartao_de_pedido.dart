/// CONTA BOLD — o CARTÃO DO PEDIDO: a tela de aprovação, vista por quem está aprovando.
///
/// É o organismo mais denso deste produto, e ele responde quatro perguntas na ordem em que quem
/// aprova as faz:
///
/// 1. **quem pediu, o quê e quanto** — a linha de cima, com o valor à direita;
/// 2. **quanto falta pra sair** — o progresso de assinaturas e a idade da pendência;
/// 3. **por que precisa de mim** — a regra de alçada que foi violada;
/// 4. **o que eu faço** — rejeitar ou aprovar, lado a lado.
///
/// ## Ele era `_PendingCard`, privado dentro de `autorizacoes_screen.dart`
///
/// Mesma classe de dívida do [CoreflowCartaoDaConta]: **widget privado que a tela constrói é invisível
/// pra qualquer gate.** Ele funcionava, tinha uso e não existia pra ninguém de fora — inclusive pro
/// catálogo, que é a razão de a tela de aprovação nunca ter podido ser desenhada.
///
/// ## Ele COMPÕE as três peças de alçada que já existiam aqui
///
/// `CoreflowProgressoDeAprovacao`, `CoreflowPrazoDaPendencia` e o botão do pai. Nenhuma das três nasceu
/// neste cartão — elas nasceram soltas, com uso medido no app e **zero uso em tela declarada**, que
/// é o caso mais fácil de um componente apodrecer sem ninguém ver. Este cartão é o que as põe juntas
/// no lugar em que o produto as usa.
///
/// ## Os dois estados, e a razão de o segundo não ter botão
///
/// Quem já assinou vê uma linha em verde no lugar das ações: *"Você já aprovou · aguardando as
/// demais"*. Não é botão desabilitado — é que **não há o que fazer**, e botão cinza convida a
/// tentar. A distinção é do domínio: assinatura colhida não se retira por aqui.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'bold_scheme.dart';
import 'bold_autorizacao.dart';

/// O cartão de um pedido esperando assinatura.
/// O TOM do ladrilho do tipo, e ele é o que diz "Pix" ou "boleto" antes de o texto ser lido.
///
/// Entrou em 22/08, adotando o cartão na tela de onde ele saiu: lá o ladrilho já era colorido por
/// TIPO DE TRANSAÇÃO — Pix na marca, TED em informação, boleto em aviso, transferência interna em
/// sucesso — e a peça portada tinha o tinte da marca cravado nos quatro. Cor por tipo é vocabulário
/// do produto, não decoração: quem aprova reconhece o tipo pela cor antes de ler a linha.
///
/// Não é `DilettaSpotState`: aquele enum não tem `info`, porque o pai recusou a família na
/// `v0.27.0` — e a recusa continua certa lá. Aqui `info` é papel EXTRA declarado por este produto,
/// e é o tom da TED.
enum CoreflowTomDoPedido { marca, info, aviso, sucesso }

class CoreflowCartaoDePedido extends StatelessWidget {
  const CoreflowCartaoDePedido({
    super.key,
    required this.quemPediu,
    required this.detalhe,
    required this.valor,
    required this.icone,
    required this.colhidas,
    required this.exigidas,
    this.exigeMaster = false,
    this.idade,
    this.aprovadaPor,
    this.motivo,
    this.justificativa,
    this.jaAprovei = false,
    this.tom = CoreflowTomDoPedido.marca,
    this.emLote = false,
    this.selecionada = false,
    this.aoAprovar,
    this.aoRejeitar,
    this.aoTocar,
  });

  /// O CRIADOR é o protagonista da linha de cima. O destinatário vai no detalhe — quem aprova
  /// decide por quem pediu, e não por quem recebe.
  final String quemPediu;

  /// *"Pix · para Ana Maria · 14:32"*. Já montado: a junção com `·` é regra de tela.
  final String detalhe;

  /// Já formatado.
  final String valor;

  /// O glifo do tipo de transação.
  final String icone;

  final int colhidas;
  final int exigidas;
  final bool exigeMaster;

  /// *"há 3 horas"*. Sem `expiresAt` no contrato do backend, o produto mostra a IDADE em vez de
  /// inventar contagem regressiva.
  final String? idade;

  /// Quem já assinou. Some quando ninguém assinou ainda.
  final String? aprovadaPor;

  /// A regra de alçada violada — o *por que isto precisa de mim*.
  final String? motivo;

  /// A justificativa da despesa, escrita por quem pediu.
  final String? justificativa;

  /// Liga o estado sem ações. Ver o `///`.
  final bool jaAprovei;

  /// O tom do ladrilho do tipo. Ver [CoreflowTomDoPedido].
  final CoreflowTomDoPedido tom;

  /// MODO LOTE: a tela está escolhendo vários pedidos pra assinar de uma vez.
  ///
  /// Muda três coisas, e as três são a mesma decisão — no lote o cartão é um ITEM de seleção e não
  /// uma tela de decisão: entra a caixa de marcar à esquerda, sai o par Rejeitar/Aprovar (a ação é
  /// da barra de baixo, não do cartão), e o toque escolhe em vez de abrir o detalhe.
  ///
  /// Quem já aprovou não tem o que marcar: no lugar da caixa vai o disco de sucesso, porque ali é
  /// ESTADO e não escolha.
  final bool emLote;

  /// Escolhida no lote: a borda do cartão vai pro `primary`.
  final bool selecionada;

  final VoidCallback? aoAprovar;
  final VoidCallback? aoRejeitar;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    return DilettaDevInfo(
      component: 'cartaoDePedido',
      props: {
        'assinaturas': '$colhidas/$exigidas',
        'jaAprovei': '$jaAprovei',
      },
      tokens: const ['radius.all16', 'type.labelMd', 'type.labelLg'],
      child: DilettaTappable(
        onTap: aoTocar,
        child: DilettaCardSurface(
        radius: DilettaRadius.all16,
        corSolida: s.surface,
        // No lote a borda diz o que está escolhido. Fora dele, a borda da superfície.
        bordaSolida: selecionada ? s.primary : s.border,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              // A CAIXA DE MARCAR só existe no lote, e quem já aprovou não a tem: ali é estado, e
              // não escolha. Eram dois glifos do Material (`Icons.check_box` e o vazio) fazendo o
              // papel de um componente que existe.
              if (emLote) ...[
                if (jaAprovei)
                  DilettaIcon(
                      name: DilettaIcons.circleCheckLight,
                      size: 22,
                      color: s.success)
                else
                  DilettaCheckbox(checked: selecionada, onChanged: (_) {}),
                DilettaGap.w(DilettaSpacing.s3),
              ],
              // O LADRILHO É A PEÇA desde 22/08 — `DilettaSpotIcon(forma: ladrilho)`.
              //
              // Aqui moravam 20 linhas montando um quadrado de 46 com o tinte do tom, e elas eram o
              // SEXTO sítio da tabela do meu próprio pedido: *"o último é meu e é o mais
              // constrangedor — o cartão compõe três peças do pai e desenha o ladrilho num
              // Container, porque não havia o que chamar."* Agora há.
              //
              // O `info` é o único tom que não atravessa: `DilettaSpotState` não tem `info`, porque
              // o pai recusou a família na `v0.27.0` — e a recusa continua certa lá. Aqui `info` é
              // papel EXTRA deste produto, então esse tom fica com o ladrilho montado à mão, com o
              // raio que a REGRA do pai dá (46 ⇒ `all16`), e o resto delega.
              if (tom == CoreflowTomDoPedido.info)
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CoreflowScheme.of(context).infoSubtle,
                    borderRadius: DilettaRadius.all16,
                  ),
                  child: DilettaIcon(
                      name: icone,
                      size: 20,
                      color: CoreflowScheme.of(context).info),
                )
              else
                DilettaSpotIcon(
                  icon: icone,
                  forma: DilettaSpotForma.ladrilho,
                  type: DilettaSpotType.outline,
                  state: switch (tom) {
                    CoreflowTomDoPedido.marca => DilettaSpotState.primary,
                    CoreflowTomDoPedido.aviso => DilettaSpotState.warning,
                    CoreflowTomDoPedido.sucesso => DilettaSpotState.success,
                    CoreflowTomDoPedido.info => DilettaSpotState.normal,
                  },
                  size: 46,
                ),
              DilettaGap.w(DilettaSpacing.s3),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DilettaText(quemPediu,
                        maxLines: 1,
                        style: DilettaType.labelMd.copyWith(color: s.fg)),
                    const SizedBox(height: 2),
                    DilettaText(detalhe,
                        maxLines: 1,
                        style: DilettaType.bodySm
                            .copyWith(color: s.textSecondary)),
                  ],
                ),
              ),
              DilettaGap.w(DilettaSpacing.s2),
              DilettaText(valor,
                  style: DilettaType.labelLg
                      .copyWith(color: s.fg, fontWeight: FontWeight.w800)),
            ]),
            DilettaGap.h(DilettaSpacing.s3),
            // O progresso vai na forma COMPACTA aqui, e o número é o motivo: a forma longa desenha
            // um degrau de 18 por assinatura mais "1 de 3 · faltam 2" mais o carimbo de master, e
            // ao lado do prazo isso estourou o cartão por 85 pixels com três exigidas.
            //
            // Não é aperto de layout, é hierarquia: dentro do cartão o progresso é UM dos quatro
            // dados, e a frase inteira dele compete com o valor. Ela continua chegando por inteiro
            // em quem lê a tela — o `Semantics` do progresso anuncia "1 de 3 assinaturas, faltam 2,
            // uma precisa ser master" nas duas formas.
            //
            // E o afastamento é `spaceBetween`, não um `Spacer`: `Spacer` é `Expanded`, então ele
            // disputava o espaço livre com o `Flexible` do progresso meio a meio — o progresso
            // recebia metade do que sobrava e estourava por dentro. Espaçador que compete com
            // conteúdo é a causa mais silenciosa de estouro num `Row`.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CoreflowProgressoDeAprovacao(
                      colhidas: colhidas,
                      exigidas: exigidas,
                      exigeMaster: exigeMaster,
                      compacto: true),
                ),
                if (idade != null) ...[
                  DilettaGap.w(DilettaSpacing.s2),
                  CoreflowPrazoDaPendencia(idade: idade),
                ],
              ],
            ),
            if (aprovadaPor != null) ...[
              const SizedBox(height: 6),
              DilettaText('Aprovada por: $aprovadaPor',
                  style:
                      DilettaType.labelSm.copyWith(color: s.textSecondary)),
            ],
            if (motivo != null) ...[
              DilettaGap.h(DilettaSpacing.s2),
              DilettaText('Motivo: $motivo',
                  style:
                      DilettaType.labelSm.copyWith(color: s.textSecondary)),
            ],
            if (justificativa != null) ...[
              const SizedBox(height: 10),
              _Citacao(justificativa!),
            ],
            DilettaGap.h(DilettaSpacing.s3),
            if (jaAprovei)
              // Sem botão, e de propósito: não há o que fazer. Ver o `///`.
              Row(children: [
                DilettaIcon(
                    name: DilettaIcons.circleCheckLight,
                    size: 16,
                    color: s.success),
                const SizedBox(width: 6),
                Expanded(
                  child: DilettaText('Você já aprovou · aguardando as demais',
                      style:
                          DilettaType.bodySm.copyWith(color: s.success)),
                ),
              ])
            else if (!emLote)
              Row(children: [
                Expanded(
                  // O destrutivo é o TIPO secundário e não um tipo próprio: 16 sítios de
                  // destrutivo no app, nenhum deles um tipo. É a medição que o botão já tinha.
                  child: DilettaButton(
                      label: 'Rejeitar',
                      type: DilettaButtonType.secondary,
                      onPressed: aoRejeitar),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: DilettaButton(
                        label: 'Aprovar', onPressed: aoAprovar)),
              ]),
          ],
        ),
      ),
      ),
    );
  }
}

/// A justificativa de quem pediu, entre aspas visuais.
class _Citacao extends StatelessWidget {
  const _Citacao(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaCardSurface(
      radius: DilettaRadius.all8,
      corSolida: s.surfaceLoading,
      padding: EdgeInsets.all(DilettaSpacing.s3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DilettaIcon(
            name: DilettaIcons.noteLightFull, size: 14, color: s.textSecondary),
        DilettaGap.w(DilettaSpacing.s2),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DilettaText('Justificativa do solicitante',
                  style:
                      DilettaType.labelSm.copyWith(color: s.textSecondary)),
              const SizedBox(height: 2),
              DilettaText(texto,
                  style: DilettaType.bodySm.copyWith(color: s.fg)),
            ],
          ),
        ),
      ]),
    );
  }
}
