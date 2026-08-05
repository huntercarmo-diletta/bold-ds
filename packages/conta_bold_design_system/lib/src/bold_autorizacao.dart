/// CONTA BOLD — as duas peças de uma AUTORIZAÇÃO PENDENTE.
///
/// Elas vivem na mesma linha da lista de autorizações, e por isso moram no mesmo arquivo: quem lê uma
/// pendência faz duas perguntas seguidas — **falta quanto?** e **tenho até quando?**
///
/// - [BoldProgressoDeAprovacao] responde a primeira: as assinaturas colhidas viram FORMA, não só
///   texto, pra dar pra ler de relance numa lista;
/// - [BoldPrazoDaPendencia] responde a segunda, e é quase só REGRA: os pixels são a etiqueta de status
///   do pai.
///
/// ## Por que o progresso não é o `DilettaStepper` do pai
///
/// Ele parece o mesmo componente e não é, e a diferença é de vocabulário: o stepper escreve
/// **"Passo X de Y"** — que é posição num fluxo — e aqui o número é **assinatura colhida**, que é
/// contagem de gente. "Passo 1 de 2" numa pendência de duas assinaturas diz outra coisa.
///
/// As duas diferenças de forma vêm dessa: o stepper ocupa a largura da tela (ele tem padding de tela
/// embutido) e é sempre da cor da marca; este é inline dentro de uma row de lista e **fica verde quando
/// completa**, porque numa lista de pendências o que salta é a que já pode executar.
///
/// ## O prazo é REGRA, não desenho — e foi assim que ele encolheu
///
/// O componente antigo pintava o próprio pill: fundo com 12% do tom, radius de pill, ícone 11, label.
/// Isso é a `DilettaStatusTag` do pai, que aceita ícone e tom. O que sobrou aqui é o que é do produto:
///
/// - **sem prazo do servidor, não se inventa contagem.** Mostra a idade da pendência, em tom neutro;
/// - **abaixo do limite de urgência vira alerta** (o padrão é 6h, e quem chama pode mudar);
/// - **vencido é estado terminal**, em danger, e não "faltam -2h".
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// "1 de 2 · falta 1" com os degraus preenchidos.
class BoldProgressoDeAprovacao extends StatelessWidget {
  const BoldProgressoDeAprovacao({
    super.key,
    required this.colhidas,
    required this.exigidas,
    this.exigeMaster = false,
    this.compacto = false,
  });

  /// Assinaturas já colhidas.
  final int colhidas;

  /// Assinaturas necessárias pra executar.
  final int exigidas;

  /// Uma delas precisa ser de um aprovador master.
  final bool exigeMaster;

  /// Só os degraus + "N de M", sem a linha de apoio. É o que cabe numa row de lista.
  final bool compacto;

  int get _faltam => (exigidas - colhidas).clamp(0, exigidas);
  bool get _completo => exigidas > 0 && colhidas >= exigidas;

  @override
  Widget build(BuildContext context) {
    // Sem exigência declarada não há progresso pra mostrar — e uma régua de zero degraus é ruído.
    if (exigidas <= 0) return const SizedBox.shrink();
    final s = DilettaTheme.schemeOf(context);

    // Verde quando completa: numa lista de pendências, a que já pode executar é a que interessa.
    final tom = _completo ? s.success : s.primary;
    final trilho = _completo ? s.successSubtle : s.primaryTrack;

    return DilettaDevInfo(
      component: 'progressoDeAprovacao',
      props: {
        'colhidas': '$colhidas',
        'exigidas': '$exigidas',
        if (exigeMaster) 'exigeMaster': 'true',
      },
      tokens: const ['degrau colhido: primary/success · vazio: primaryTrack/successSubtle'],
      child: Semantics(
        // O leitor de tela recebe a FRASE, não os degraus: a régua é redundância visual de um dado
        // que já é texto, e sem isto ele anuncia sete caixas vazias antes do número.
        container: true,
        label: _completo
            ? 'Aprovação completa: $colhidas de $exigidas assinaturas'
            : '$colhidas de $exigidas assinaturas, falta${_faltam == 1 ? '' : 'm'} $_faltam'
                '${exigeMaster ? ', uma precisa ser master' : ''}',
        child: ExcludeSemantics(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < exigidas; i++) ...[
              // O antigo usava 3 cru. Virou `s1` (4): aritmética sobre token é token quebrado, e um
              // pixel de diferença entre degraus de 4px de altura não é decisão de ninguém.
              if (i > 0) DilettaGap.w(DilettaSpacing.s1),
              DilettaBox(
                width: compacto ? 14 : 18,
                height: 4,
                radius: DilettaRadius.pillAll,
                color: i < colhidas ? tom : trilho,
              ),
            ],
            DilettaGap.w(DilettaSpacing.s2),
            DilettaText('$colhidas de $exigidas',
                style: DilettaType.labelSm.copyWith(color: tom)),
            if (!compacto)
              DilettaText(
                _completo ? ' · completo' : ' · falta${_faltam == 1 ? '' : 'm'} $_faltam',
                style: DilettaType.labelSm.copyWith(color: s.textSecondary),
              ),
            if (exigeMaster) ...[
              DilettaGap.w(DilettaSpacing.s2),
              DilettaIcon(
                  name: DilettaIcons.stampLight, size: 12, color: s.textSecondary),
              DilettaGap.w(DilettaSpacing.s0_5),
              DilettaText('master',
                  style: DilettaType.labelSm.copyWith(color: s.textSecondary)),
            ],
          ]),
        ),
      ),
    );
  }
}

/// Quanto tempo resta pra a pendência expirar. É a REGRA; o pill é a etiqueta do pai.
class BoldPrazoDaPendencia extends StatelessWidget {
  const BoldPrazoDaPendencia({
    super.key,
    this.restante,
    this.idade,
    this.urgenteAbaixoDe = const Duration(hours: 6),
  });

  /// Tempo restante. Nulo = o backend não informou prazo, e aí não se inventa contagem.
  final Duration? restante;

  /// Texto de recuo quando não há prazo ("criada há 2 h").
  final String? idade;

  /// Abaixo disto o prazo vira alerta.
  final Duration urgenteAbaixoDe;

  static String _duracao(Duration d) {
    if (d.inDays >= 1) return '${d.inDays} d';
    if (d.inHours >= 1) return '${d.inHours} h';
    if (d.inMinutes >= 1) return '${d.inMinutes} min';
    return 'agora';
  }

  /// A regra, separada do desenho pra poder ser lida e testada como regra.
  ///
  /// O tom da ESPERA é `pending`, e ele chegou porque esta casa pediu: o pedido era família `info`
  /// pra um azul próprio, e o pai voltou **ENTRA COMO TOM** (`ds v0.27.0`) medindo que 9 dos 10
  /// sítios não eram informação, eram espera. `pending` pinta igual a `neutral` nos dois modos —
  /// espera é a AUSÊNCIA de desfecho, e matiz competiria com as quatro famílias que JULGAM o
  /// desfecho —, então trocar não move pixel: move a declaração. `neutral` quer dizer *sem estado*.
  ({String rotulo, DilettaStatusTone tom, String icone})? get _estado {
    final r = restante;
    if (r == null) {
      if (idade == null || idade!.isEmpty) return null;
      return (rotulo: idade!, tom: DilettaStatusTone.pending, icone: DilettaIcons.clockLight);
    }
    if (r.isNegative || r == Duration.zero) {
      return (
        rotulo: 'prazo vencido',
        tom: DilettaStatusTone.danger,
        icone: DilettaIcons.circleExclamationLight,
      );
    }
    final urgente = r < urgenteAbaixoDe;
    return (
      rotulo: 'faltam ${_duracao(r)}',
      // Prazo largo é espera; prazo curto é ATENÇÃO, e essa é a fronteira que o pai escreveu ao
      // recusar pintar espera de âmbar. O `warning` aqui é juízo sobre o prazo, não sobre o desfecho.
      tom: urgente ? DilettaStatusTone.warning : DilettaStatusTone.pending,
      icone: urgente ? DilettaIcons.hourglassStartLight : DilettaIcons.clockLight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = _estado;
    // Sem prazo E sem idade não há nada verdadeiro a dizer. Etiqueta vazia é pior que ausência.
    if (e == null) return const SizedBox.shrink();

    return DilettaDevInfo(
      component: 'prazoDaPendencia',
      props: {'rotulo': "'${e.rotulo}'", 'tom': e.tom.name},
      tokens: const ['pill e tons: DilettaStatusTag do pai'],
      child: DilettaStatusTag(label: e.rotulo, tone: e.tom, icon: e.icone),
    );
  }
}
