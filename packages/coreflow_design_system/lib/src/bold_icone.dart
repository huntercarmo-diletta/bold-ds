import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaIcon;
import 'package:flutter/widgets.dart';

import 'bold_scheme.dart';

/// **CoreflowIcone** — o glifo do produto, com o nome que o produto usa e a caixa que ele pede.
///
/// O desenho é do pai (`DilettaIcon`, que resolve no bundle dele). O que esta peça acrescenta são
/// duas coisas que o pai não tem, e nenhuma das duas é desenho:
///
/// 1. **o mapa de apelidos.** As telas falam `home`, `pay`, `eye-off`; o conjunto do pai fala
///    `house-light`, `file-invoice-light`, `eye-slash-light-full`. A tradução é o vocabulário deste
///    produto, e ela mora numa fronteira só. Nome que o pai não tem **desenha NADA** — não estoura,
///    não avisa —, e foi assim que as setas de voltar e o `>` do extrato sumiram um dia;
/// 2. **a caixa EXATA.** `DilettaIcon` passa `width`/`height` pro `VectorGraphic`, e dentro de um pai
///    com constraint apertado (um chip de 40) o glifo estica. O `UnconstrainedBox` + `SizedBox`
///    garante o tamanho pedido em qualquer caixa. É composição, não desenho — por isso resolve aqui e
///    não vira mudança na peça do pai, que todo consumidor dele sentiria.
///
/// A cor default é `textSecondary` do esquema: o glifo de chrome deste produto é secundário, e o
/// default do pai (a cor do `DefaultTextStyle`) é outra decisão.
///
/// Veio de `lib/design_system/widgets/bold_icon.dart` do app em 01/09, quando a camada de DS do app
/// se desfez. **Um filho herda o mapa inteiro** — apelido é vocabulário de interface, não de marca.
class CoreflowIcone extends StatelessWidget {
  const CoreflowIcone(this.name, {super.key, this.size = md, this.color});

  final String name;
  final double size;
  final Color? color;

  /// A ESCADA DE TAMANHO deste produto: 16 · 18 · 20.
  ///
  /// Ela morava numa classe `BoldIconSize` do app, ao lado das sombras, e é pequena de propósito — o
  /// chrome deste produto usa três tamanhos e nada entre eles. Fica aqui, e não numa classe própria,
  /// porque tamanho de ícone sem o ícone é um número solto: quem escreve `size:` já está escrevendo
  /// `CoreflowIcone`.
  static const double sm = 16;
  static const double md = 18;
  static const double lg = 20;

  /// Nome semântico → arquivo do conjunto do pai (kebab, pesos light/solid do FontAwesome).
  static const Map<String, String> alias = {
    // marca Pix — `pix` pro chrome de ícone. O `'pix-solid': 'pix-solid'` SAIU em 01/09: era
    // entrada de identidade, e ela não traduzia nada. Pior que inútil — um gate do app cobra que
    // apelido não atravesse pra campo de ícone de peça do pai (lá ele desenha NADA em silêncio), e
    // não tem como distinguir uma chave que traduz de uma que não traduz. `comoOPaiChama` devolve o
    // nome cru pra quem não está no mapa, então o `pix-solid` continua funcionando por todo lado.
    'pix': 'pix-light',
    // chrome / navegação
    'home': 'house-light', 'home-solid': 'house-solid',
    'pay': 'file-invoice-light', 'pay-solid': 'file-invoice-solid',
    'cards': 'credit-card-light', 'cards-solid': 'credit-card-solid',
    'bell': 'bell-light', 'gear': 'gear-light', 'edit': 'sliders-light',
    'close': 'xmark-light', 'add': 'plus-light',
    'chevron-right': 'angle-right-light', 'chevron-down': 'angle-down-light',
    'chevron-left': 'chevron-left-light',
    'arrow-forward': 'arrow-right-long-light',
    'share': 'arrow-up-from-bracket-light',
    'copy': 'clone-light', 'qr': 'qrcode-light',
    // dinheiro / ações
    'eye': 'eye-light', 'eye-off': 'eye-slash-light-full',
    'send': 'paper-plane-light', 'transfer': 'arrow-right-arrow-left-light',
    'smartphone': 'mobile-light', 'barcode': 'barcode-light',
    // finanças / descobrir
    'trending-up': 'chart-line-light', 'invest': 'arrow-trend-up-light',
    'shield': 'shield-user-light-full', 'bank': 'landmark-light',
    'verified': 'circle-check-light',
    // perfil / segurança
    'fingerprint': 'fingerprint-light', 'lock': 'lock-light', 'key': 'key-light',
    'logout': 'arrow-right-from-bracket-light', 'help': 'circle-question-light',
    'language': 'globe', 'moon': 'moon-stars-light', 'sun': 'sun-light',
    // assistente — os dois pesos do sparkle
    'sparkle': 'sparkles-light-full', 'sparkle-solid': 'sparkles-solid-full',
    // microfone da conversa. Os dois SVGs carregam um `<g transform>` normalizando o frame do Figma
    // (15×20 e 22×22) pro box 18×18 do kit — MESMA escala nos dois, pra o corpo do mic cair no mesmo
    // pixel e não "encolher" ao mutar.
    'mic': 'microphone-light', 'mic-off': 'microphone-slash-light',
    // enviar do compositor de chat: avião na diagonal com entalhe na base. NÃO é o `send` acima
    // (`paper-plane-light`), que é o glifo de enviar/transferir usado em toda parte.
    'send-chat': 'paper-plane-top-light',
  };

  /// O nome COMO O PAI CHAMA — a tradução na fronteira.
  ///
  /// Todo ponto em que este produto entrega um nome a um widget `Diletta*` passa por aqui. É UMA
  /// função numa fronteira, em vez de um `grep` por literal: o defeito que a criou chegou por um
  /// ternário (`_hidden ? 'eye-off' : 'eye'`), e literal nenhum acha ternário.
  static String comoOPaiChama(String nome) => alias[nome] ?? nome;

  @override
  Widget build(BuildContext context) {
    final col = color ?? CoreflowScheme.of(context).textSecondary;
    return UnconstrainedBox(
      child: SizedBox(
        width: size,
        height: size,
        child: DilettaIcon(name: comoOPaiChama(name), size: size, color: col),
      ),
    );
  }
}
