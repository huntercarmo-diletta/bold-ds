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
}
