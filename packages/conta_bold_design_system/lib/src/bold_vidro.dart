/// CONTA BOLD — o VIDRO, e ele parou de ser declarado duas vezes em 19/08.
///
/// A receita já morava aqui desde a `v0.4.0` do pai: `tinteDeVidroClaro`, `tinteDeVidroEscuro`,
/// `blurDeVidro`, `tracoDeVidroClaro` e `tracoDeVidroEscuro` são campos de [BoldPalette.bold], e a
/// regra que os pôs lá é do pai — *"o pai sabe COMO se constrói vidro; o filho diz de que material
/// ele é"*.
///
/// **E o app declarava a mesma receita outra vez**, com os mesmos valores por outro caminho:
/// `#16060A @ 50%`, `#FFFFFF @ 50%`, `#FF9898 @ 30%`, `primary08`, blur 15. Cinco valores, duas
/// fontes, zero gates entre elas — a definição de drift esperando acontecer. Conferido valor por
/// valor antes de apagar o segundo: os cinco batem, e o teste ao lado é o que impede que parem de
/// bater.
library;

import 'dart:ui' show ImageFilter, TileMode;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';

import 'bold_palette.dart';
import 'bold_vinho.dart';

/// O vidro do app inteiro: fill chapado, traço de 1px, blur uniforme, zero sombra.
///
/// Não existe outro — sem variantes progressivas, sem gradiente. Card, barra, ladrilho, chip e
/// folha leem daqui. A exceção tem nome e razão: [BoldVidroDeEntrada].
abstract final class BoldVidro {
  const BoldVidro._();

  /// `true` → vidro fosco (`BackdropFilter` ligado). `false` → superfície sólida.
  static const bool fosco = true;

  /// O sigma do blur, uniforme em todo vidro — **15** no Bold, e ele vem da paleta.
  ///
  /// O do pai é 10; o material deste produto é mais leitoso, e essa é a frase que o campo
  /// `blurDeVidro` existe pra carregar.
  ///
  /// **Recebe a PALETA em vez de ler a do Bold**, e a mudança é de 20/08.
  ///
  /// Este arquivo abria com `static DilettaPalette get _p => BoldPalette.bold;`, e com isso o
  /// vidro inteiro era do Bold: um produto novo declarava `blurDeVidro`, `tinteDeVidro*` e
  /// `tracoDeVidro*` na paleta dele — campos que o pai criou justamente pra isso — e recebia os
  /// valores do Bold assim mesmo. Os campos viajavam; o leitor não.
  static double blur(DilettaPalette p) => p.blurDeVidro!;

  static ImageFilter filtro(DilettaPalette p) =>
      ImageFilter.blur(sigmaX: blur(p), sigmaY: blur(p), tileMode: TileMode.decal);

  /// Recorte do vidro. **Tem** que ser `antiAlias` e não `antiAliasWithSaveLayer`: a variante com
  /// save-layer isola a subárvore, então o [BackdropFilter] lê a camada vazia em vez do fundo
  /// real e o blur simplesmente some.
  static const Clip recorte = Clip.antiAlias;

  /// O tinte: escuro é vinho-tinta a 50% ([BoldVinho.ink]), claro é branco a 50%.
  ///
  /// Vinho e não preto: preto puro sobre a arte de fundo dá cinza morto, e o matiz é o que mantém
  /// o painel escuro dialogando com o rosa.
  static Color tinte(DilettaPalette p, {required bool escuro}) =>
      escuro ? p.tinteDeVidroEscuro! : p.tinteDeVidroClaro!;

  /// O traço de 1px: escuro é o rosa claro a 30%, claro é o `primary08`.
  ///
  /// No claro a borda branca desaparecia sobre fundo claro — o traço nasceu de um defeito medido
  /// (1,06:1 é invisível), e o gate `traco-de-vidro-visivel` do pai cobra o piso.
  static Color traco(DilettaPalette p, {required bool escuro}) =>
      escuro ? p.tracoDeVidroEscuro! : p.tracoDeVidroClaro!;

  static const double espessuraDoTraco = 1;

  /// SEM sombra, e é regra do pai: sombra atrás de vidro é reamostrada pelo filtro e vira halo
  /// sujo. O que define a superfície é o traço de 1px.
  static const List<BoxShadow> sombra = [];
}

/// O SEGUNDO vidro, e ele existe por um motivo que o primeiro não cobre.
///
/// [BoldVidro] é o vidro do app: fill chapado sobre o backdrop. Este aqui fica sobre uma FOTO de
/// tela cheia — a tela de entrada recorrente. Fill chapado ali achata a imagem; o desenho pede um
/// wash que some subindo, deixando a cidade aparecer no topo do card.
///
/// **Uso restrito à tela de entrada.** Não vire "o vidro alternativo": se um terceiro caso
/// aparecer, a pergunta certa é se o primeiro vidro devia ganhar variante, não se este devia
/// crescer.
///
/// Valores do Figma, com duas ressalvas honestas de tradução:
///
/// 1. O Figma exprime blur como RAIO e o Flutter como SIGMA de gaussiana. A conversão é
///    `sigma = raio / 2`, que é a que bate visualmente;
/// 2. o efeito **Glass** do Figma (refraction 80, depth 20, dispersion 50) não tem equivalente no
///    Flutter sem shader próprio. Sobrevive a parte reproduzível — frost vira blur, mais o
///    gradiente e o traço. **A refração da borda NÃO é reproduzida**, e isso fica escrito em vez
///    de virar surpresa de quem comparar com o desenho.
abstract final class BoldVidroDeEntrada {
  const BoldVidroDeEntrada._();

  /// Figma: background blur uniforme 10 → sigma 5.
  static const double blur = 5;

  static final ImageFilter filtro =
      ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.decal);

  /// Opacidade da CAMADA de fill (Figma: 70% no claro, 60% no escuro). Aplicada sobre o gradiente
  /// inteiro, não por parada.
  static double opacidade({required bool escuro}) => escuro ? 0.60 : 0.70;

  /// A base do wash: claro é `primary09`, escuro é [BoldVinho.lavagem].
  static Color base(DilettaPalette p, {required bool escuro}) =>
      escuro ? BoldVinho.lavagemDe(p) : p.primary09;

  /// O gradiente do fill: opaco embaixo, transparente no topo.
  ///
  /// Figma claro: parada em 50% a 100% de alpha, 100% a 20%.
  /// Figma escuro: parada em 53% a 100% de alpha, 100% a 0%.
  ///
  /// O eixo é de baixo pra cima — a base ancora o conteúdo, o topo entrega a imagem.
  static LinearGradient gradiente(DilettaPalette p, {required bool escuro}) {
    final cor = base(p, escuro: escuro);
    final o = opacidade(escuro: escuro);
    return escuro
        ? LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              cor.withValues(alpha: o),
              cor.withValues(alpha: o),
              cor.withValues(alpha: 0),
            ],
            stops: const [0, 0.53, 1],
          )
        : LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              cor.withValues(alpha: o),
              cor.withValues(alpha: o),
              cor.withValues(alpha: o * 0.20),
            ],
            stops: const [0, 0.50, 1],
          );
  }

  /// Traço de 1px por dentro — Figma: `primary03` no escuro, `primary07` no claro.
  static Color traco(DilettaPalette p, {required bool escuro}) =>
      escuro ? p.primary03 : p.primary07;

  static const double espessuraDoTraco = 1;

  /// SEM sombra, e aqui a razão é medida e não herdada.
  ///
  /// Era preto a 8%, blur 16, subindo (Y −4), pra separar o topo do card da imagem. O topo deste
  /// card é o ponto mais TRANSLÚCIDO do gradiente (alpha 14% no claro), então a sombra preta atrás
  /// dele aparecia ATRAVÉS do vidro: *"por que o topo do card está meio cinza?"*. O que separa o
  /// card da imagem é o traço de 1px, que já existe e é da marca.
  ///
  /// Lista vazia em vez de remover o símbolo: o call site continua legível, e quem procurar a
  /// sombra acha esta explicação.
  static const List<BoxShadow> sombra = [];
}
