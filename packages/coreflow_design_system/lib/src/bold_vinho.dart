/// CONTA BOLD — o VINHO, que é o segundo eixo da marca.
///
/// A marca do Bold tem dois eixos, e só um deles cabia numa rampa. O rosa é a cor de ação e vive
/// em `primary01..09`. O **vinho** é a profundidade: o vidro escuro, o fluxo secundário, o ladrilho
/// de ícone, o realce escuro. Ele aparecia em quatro lugares do produto antigo com quatro nomes
/// diferentes (`brandPrincipal`, `glassFill`, `secondaryFlow` e o violeta dos fundos frios), e
/// nenhum deles era token de cor de marca — eram literais espalhados.
///
/// Decisão do dono do produto (2026-07-30): **um token de cor de vidro pro vinho**, e é o que
/// resolve o problema do fundo.
///
/// ## O que isso resolveu, em ordem
///
/// **1 · O violeta morreu.** Os dois fundos frios (`vidroFrio` e `aurora`) usavam `#7B3FF2`, um
/// violeta que não pertencia a rampa nenhuma deste produto. Era o único valor fora da paleta que
/// tinha sobrado no componente mais usado do app. O vinho faz o mesmo trabalho — dar um polo FRIO
/// e profundo contra o rosa — e faz com cor que é da marca.
///
/// **2 · O `tinteDeVidroEscuro` da paleta deixou de ser um hex solto.** Ele é `vinhoInk` a 50%,
/// e agora diz isso.
///
/// **3 · O slot de parceiro parou de mentir.** Eu havia posto o vinho em `partnerPrimary` como
/// fallback, com um "REVISAR" escrito — porque sem valor ali o componente cobranded cairia no
/// laranja de REFERÊNCIA do pai, que não é marca de ninguém. Agora o valor tem nome próprio, e o
/// slot de parceiro empresta dele em vez de ser a casa dele.
library;

import 'package:diletta_design_system/diletta_design_system.dart';

import 'package:flutter/painting.dart';

/// Os dois degraus do vinho. Dois, não uma rampa: mais que isso seria inventar escala sem
/// medição — a régua desta casa é que degrau nasce quando um caso pede, não antes.
abstract final class BoldVinho {
  /// O vinho da marca. Ladrilho de ícone, badge, realce escuro, e o polo frio dos fundos.
  static const Color marca = Color(0xFF90093A);

  /// O vinho-tinta: quase preto com o matiz da marca. É o fill do vidro escuro e a base do
  /// fluxo secundário.
  ///
  /// Ele não é `black` com alpha, e a diferença é o ponto: preto puro sobre a arte de fundo dá
  /// cinza morto, e o matiz é o que faz o painel escuro continuar dialogando com o rosa.
  static const Color ink = Color(0xFF16060A);

  /// O TERCEIRO degrau, e ele entrou em 19/08 com o caso na mão.
  ///
  /// Este arquivo abre dizendo *"dois, não uma rampa: degrau nasce quando um caso pede, não
  /// antes"*. O caso pediu: o vidro da tela de ENTRADA veio do app e trouxe um `#420616` que
  /// vivia como literal privado lá dentro, com a razão escrita ao lado — *"fica entre `primary01`
  /// e `primary02` e não existia na escala; é cor de SUPERFÍCIE, não de marca"*.
  ///
  /// Ele não vira `vinho03`: não é degrau de uma rampa de vinho, é a lavagem de um material.
  /// O nome diz o trabalho — o wash que some subindo sobre a foto da cidade, pra a imagem
  /// aparecer no topo do card e o conteúdo ancorar embaixo.
  static const Color lavagem = Color(0xFF420616);

  // ── A PORTA DO NETO ────────────────────────────────────────────────────────
  //
  // Os três acima são os valores DESTE produto. Um filho deste DS declara os dele em
  // `papeisExtras` (`vinhoMarca`, `vinhoTinta`, `vinhoLavagem`) e lê pelos três resolvedores
  // abaixo — que caem nas constantes quando a paleta não declara nada.
  //
  // Existem porque nem todo sítio tem um `CoreflowScheme` na mão: as peças do pacote leem
  // `DilettaTheme.schemeOf(context)`, que dá o esquema do PAI e a paleta. Com a paleta, resolve.
  // O `CoreflowScheme` também expõe os três, e chama exatamente estas funções — um valor, uma
  // implementação, dois jeitos de alcançar.

  static Color _de(DilettaPalette p, String nome, Color reserva) =>
      p.papeisExtras[nome]?.claro ?? reserva;

  /// O vinho da marca desta paleta. Cai em [marca] se ela não declarar.
  static Color marcaDe(DilettaPalette p) => _de(p, 'vinhoMarca', marca);

  /// O vinho-tinta desta paleta. Cai em [ink].
  static Color tintaDe(DilettaPalette p) => _de(p, 'vinhoTinta', ink);

  /// A lavagem desta paleta. Cai em [lavagem].
  static Color lavagemDe(DilettaPalette p) => _de(p, 'vinhoLavagem', lavagem);

  // ── O VINHO DE UM FILHO, e ele não é o meu ─────────────────────────────────
  //
  // A reserva acima é o vinho do BOLD, e ela é reserva de verdade só pra quem esqueceu de
  // declarar. Um filho que nasce de UMA cor não esqueceu de nada — ele nunca teve chance de
  // declarar —, e herdar o meu vinho quer dizer que **o vidro escuro de um banco verde sai
  // vermelho**.
  //
  // O defeito foi medido em 01/09 pelo gate `o_app_recebe_um_filho_test` do filho: as peças
  // resolviam o verde dele em `primary*` e o vinho do Bold em `vinhoTinta`. Duas rotas pro mesmo
  // material — o `CoreflowVidro.tinte` já derivava, e estas três não.
  //
  // ## A regra, e ela é medida e não escolhida
  //
  // Os três valores do Bold ficam em pontos definidos da rampa DELE, e é essa posição que viaja:
  //
  // | valor | onde ele cai na rampa do Bold | erro de claridade |
  // |---|---|---|
  // | `marca` (#90093A) | entre o 02 e o 03, em **0,69** | 0,000 |
  // | `lavagem` (#420616) | entre o 01 e o 02, em **0,41** | 0,000 |
  // | `ink` (#16060A) | entre o PRETO e o 01, em **0,54** | 0,000 |
  //
  // As três posições reproduzem a claridade dos três hexes do Bold com erro zero na terceira casa
  // — então elas descrevem os valores dele em vez de aproximá-los, e aplicadas à rampa de outra
  // marca dão o vinho DAQUELA marca.
  //
  // Isto **não muda um pixel do Bold**: ele declara os três em `papeisExtras`, e o declarado
  // sempre ganha. Quem usa é quem não declarou.

  /// O vinho de uma paleta que não declarou o dela — derivado da rampa de marca DELA.
  static Map<String, DilettaPapelExtra> derivadosDe(DilettaPalette p) => {
        'vinhoMarca': DilettaPapelExtra(
            claro: Color.lerp(p.primary02, p.primary03, 0.69)!,
            escuro: Color.lerp(p.primary02, p.primary03, 0.69)!,
            significado: 'o vinho da marca, derivado da rampa dela'),
        'vinhoLavagem': DilettaPapelExtra(
            claro: Color.lerp(p.primary01, p.primary02, 0.41)!,
            escuro: Color.lerp(p.primary01, p.primary02, 0.41)!,
            significado: 'a lavagem do material, derivada da rampa da marca'),
        'vinhoTinta': DilettaPapelExtra(
            claro: Color.lerp(const Color(0xFF000000), p.primary01, 0.54)!,
            escuro: Color.lerp(const Color(0xFF000000), p.primary01, 0.54)!,
            significado: 'o quase-preto com o matiz da marca'),
      };
}
