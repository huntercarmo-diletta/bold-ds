import 'package:flutter/widgets.dart';

import 'generated/cps_absolute_tokens.g.dart';

/// CORES QUE NENHUMA MARCA É DONA — e por isso moram no PAI.
///
/// Este arquivo existe por causa de uma pergunta prática: quando o design system
/// se partir em pai (a linguagem) e filho (a identidade), **de quem é o branco?**
///
/// A resposta é que branco, preto e transparente não são identidade. Um filho não
/// escolhe um branco diferente — ele escolhe um AZUL diferente. O mesmo vale pros
/// alphas: "branco a 38%" é uma operação sobre o branco, não uma cor de marca.
///
/// A distinção não é estética, é de propriedade:
///
/// - **absoluto** → do PAI. Igual em todo filho. Um componente do pai pode ler
///   direto, e nada de identidade vaza.
/// - **degrau de paleta** (`primary04`, `neutral08`, `error04`) → do FILHO. Um
///   componente do pai que leia isso está mostrando a marca de um filho pra todos
///   os outros, e é exatamente o vazamento que `segundo_filho_do_ds_test` mede.
///
/// Antes deste arquivo, os dois grupos moravam juntos em `CpfSeguroColors`, então
/// "o widget lê cor estática" não distinguia os 57 casos legítimos dos 69 que são
/// dívida. Separar transformou uma contagem sem sentido em duas com sentido.
///
/// Os valores vêm do DTCG (`tokens/color.absolute.tokens.json`), como todo o resto
/// do sistema — 14 destes eram Dart escrito à mão, fora do gerador, e agora não são.
/// Uma via de autoria só, que é o que `tokens_parity_test` existe pra garantir.
///
/// `CpfSeguroColors` continua expondo estes nomes, como ALIAS deste arquivo e não
/// como cópia: o app do cliente usa vários (`black`, `blackAlpha40`…) e não muda uma
/// linha, sem que o branco passe a ter duas definições.
class DilettaAbsoluteColors {
  const DilettaAbsoluteColors._();

  static const Color white = Color(DilettaAbsoluteColorConsts.white);
  static const Color black = Color(DilettaAbsoluteColorConsts.black);

  /// Ausência de cor. Não é "uma cor clara" — não pinta.
  static const Color transparent = Color(DilettaAbsoluteColorConsts.transparent);

  // ── branco com alpha ────────────────────────────────────────────────────
  // O uso está no nome de cada um: são superfícies e bordas SOBRE algo
  // colorido, e o efeito é clarear o que está atrás. Funciona sobre qualquer
  // marca, e é isso que os torna do pai.

  /// white @ 24% — bg de chip de banner (sobre gradiente da marca).
  static const Color whiteAlpha24 = Color(DilettaAbsoluteColorConsts.whiteAlpha24);

  /// white @ 32% — divisor tracejado de banner.
  static const Color whiteAlpha32 = Color(DilettaAbsoluteColorConsts.whiteAlpha32);

  /// white @ 38% — borda de chip de banner, ponto inativo de progresso.
  static const Color whiteAlpha38 = Color(DilettaAbsoluteColorConsts.whiteAlpha38);

  /// white @ 80% — superfície de vidro (TopAppBar, BottomNav, Toast, sticky).
  static const Color whiteAlpha80 = Color(DilettaAbsoluteColorConsts.whiteAlpha80);

  /// white @ 90% — véu de folha / scrim claro.
  static const Color whiteAlpha90 = Color(DilettaAbsoluteColorConsts.whiteAlpha90);

  // ── preto com alpha: SOMBRA e SCRIM ─────────────────────────────────────
  // Sombra é física, não marca: é luz bloqueada. Um filho que quisesse sombra
  // colorida estaria descrevendo outra coisa (um glow), e aí é componente novo.

  /// black @ 8% — sombra de toast.
  static const Color blackAlpha8 = Color(DilettaAbsoluteColorConsts.blackAlpha8);

  /// black @ 13% — sombra de card, bottom nav e barra de chat.
  static const Color blackAlpha13 = Color(DilettaAbsoluteColorConsts.blackAlpha13);

  /// black @ 18% — sombra de tecla pressionada do numpad.
  static const Color blackAlpha18 = Color(DilettaAbsoluteColorConsts.blackAlpha18);

  /// black @ 20% — sombra de tooltip.
  static const Color blackAlpha20 = Color(DilettaAbsoluteColorConsts.blackAlpha20);

  /// black @ 40% — scrim padrão de bottomsheet.
  static const Color blackAlpha40 = Color(DilettaAbsoluteColorConsts.blackAlpha40);

  /// black @ 85% — overlay de tela cheia (biometria).
  static const Color blackAlpha85 = Color(DilettaAbsoluteColorConsts.blackAlpha85);

  /// slate `#101828` @ 10% e @ 6% — as duas camadas de sombra do knob do
  /// ToggleSwitch (padrão iOS).
  ///
  /// **Fica aqui apesar de não ser preto puro**, e a razão é o que ele faz: é
  /// sombra, e o leve navy só a deixa menos suja que preto sobre cinza. Nenhum
  /// filho tem opinião sobre isto — quem tiver, passa a cor por parâmetro.
  static const Color slateAlpha10 = Color(DilettaAbsoluteColorConsts.slateAlpha10);
  static const Color slateAlpha6 = Color(DilettaAbsoluteColorConsts.slateAlpha6);

  /// Tinta de DEPURAÇÃO — a listra que marca espaçamento no inspetor.
  ///
  /// Era `primary04 @ 18%`, a cor da marca do CPF, e isso tinha dois problemas:
  /// um filho azul-escuro veria a marca dele como "régua", e num filho de baixo
  /// contraste a listra simplesmente desapareceria. Régua de dev tem que ser
  /// visível sobre qualquer marca, então é magenta — cor que nenhum design
  /// system usa em componente, justamente por ser chapada.
  static const Color debugRuler = Color(DilettaAbsoluteColorConsts.debugRuler);

  /// Magenta cheio — contorno do componente sob o cursor e as linhas de token no
  /// painel do inspetor. Mesma família da régua, então o inspetor lê como UMA
  /// ferramenta em vez de três decisões soltas.
  static const Color debugAccent = Color(DilettaAbsoluteColorConsts.debugAccent);

  /// Superfície do painel do inspetor, e texto secundário sobre ela.
  ///
  /// Escuro neutro FIXO de propósito. O inspetor mostra informação SOBRE o design
  /// system, então ele não é superfície de produto: se lesse o tema, um filho de
  /// marca escura ganharia painel escuro sobre UI escura. É o que o inspetor do
  /// próprio Flutter faz, pela mesma razão.
  static const Color debugSurface = Color(DilettaAbsoluteColorConsts.debugSurface);
  static const Color debugMuted = Color(DilettaAbsoluteColorConsts.debugMuted);
}
