/// O VOCABULÁRIO EXTRA da linguagem — os papéis que o pai não tem, e a regra de quem não declara.
///
/// O `DilettaScheme` resolve 57 papéis a partir da paleta. Este DS precisa de quatro que ele não
/// tem: a superfície ELEVADA (o card sobre a página), a PRESSIONADA (o mesmo card sob o dedo), o
/// FLUXO SECUNDÁRIO (o fundo sólido de quem saiu da navegação principal) e a INFORMAÇÃO categórica
/// (o pai recusou a família `info` na `v0.27.0`, e a recusa continua certa). Eles viajam em
/// `papeisExtras`, e um produto declara os dele.
///
/// **Quem não declara recebe uma REGRA sobre a paleta dele, não o valor de outro produto.** Até
/// 04/09 a reserva era a constante do primeiro produto — um navy que era decisão de marca dele.
/// Valor congelado no produto certo é indistinguível de valor correto; só aparece quando existe um
/// segundo produto, e aí aparece como *"declarei a paleta e o card continua com a superfície do
/// outro"*.
///
/// [reserva] é a regra; [extrasDe] é a mesma regra escrita como declaração, pra um produto que
/// nasce de uma cor (`CoreflowProduto.daMarca`) sair com os quatro DECLARADOS — visíveis na página
/// de Styles do catálogo e no gate de contraste do pai. Uma implementação, dois jeitos de alcançar.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/painting.dart' show Color;

import 'coreflow_vinho.dart';

abstract final class CoreflowVocabulario {
  /// Os quatro nomes, na ordem em que o esquema os lê.
  static const List<String> nomes = [
    'superficieElevada',
    'superficiePressionada',
    'fluxoSecundario',
    'info',
  ];

  /// O azul de INFORMAÇÃO de referência da linguagem.
  ///
  /// Cor semântica é invariante por regra do pai — um produto novo não inventa outro vermelho de
  /// erro, nem outro azul de informação. É o único dos quatro que não deriva da paleta, pela mesma
  /// razão que `error04` não deriva: informação não é marca.
  static const Color infoDeReferencia = Color(0xFF3B82F6);

  /// A regra de um papel extra que a paleta não declarou, sobre o esquema do pai daquele modo.
  ///
  /// - elevada: no claro é o branco da paleta contra a página tingida; no escuro é a superfície do pai;
  /// - pressionada: a superfície muda do pai — um degrau na direção oposta à elevação;
  /// - fluxo secundário: no claro é a página; no escuro é o vinho-tinta da marca;
  /// - informação: [infoDeReferencia].
  static Color reserva(String nome, DilettaPalette p, DilettaScheme d) => switch (nome) {
        'superficieElevada' => d.isDark ? d.surface : p.white,
        'superficiePressionada' => d.surfaceMuted,
        'fluxoSecundario' => d.isDark ? CoreflowVinho.tintaDe(p) : d.bg,
        'info' => infoDeReferencia,
        _ => throw ArgumentError.value(nome, 'nome', 'não é papel extra desta linguagem'),
      };

  /// Os quatro, DECLARADOS pela regra — pra um produto nascer com eles na paleta.
  static Map<String, DilettaPapelExtra> extrasDe(DilettaPalette p) {
    final claro = DilettaScheme.light(p);
    final escuro = DilettaScheme.dark(p);
    const significados = {
      'superficieElevada': 'A superfície elevada: o card sobre a página.',
      'superficiePressionada': 'O mesmo card sob o dedo — um degrau na direção oposta à elevação.',
      'fluxoSecundario': 'O fundo sólido de quem saiu da navegação principal.',
      'info': 'Informação categórica — o azul de referência da linguagem.',
    };
    return {
      for (final n in nomes)
        n: DilettaPapelExtra(
            claro: reserva(n, p, claro), escuro: reserva(n, p, escuro), significado: significados[n]!),
    };
  }
}

/// A GRAMÁTICA DO MATERIAL deste DS — o que faz um produto novo PARECER Coreflow.
///
/// Card de vidro, botão de canto 16, folha de canto 22, blur 15 e o tinte claro do vidro. Não são
/// identidade de produto nenhum: são o jeito deste sistema montar superfície. Um produto que nasce de
/// uma cor herda os cinco; quem discordar declara o dele em `comMaterial`.
abstract final class CoreflowGramatica {
  static const bool cardDeVidro = true;
  static const double raioDeBotao = 16;
  static const double raioDeFolha = 22;
  static const double blurDeVidro = 15;

  /// O tinte do vidro CLARO: branco a 50%. O escuro é da marca (o degrau 01 dela a 50%) e sai da
  /// rampa de quem nasce.
  static final Color tinteDeVidroClaro = DilettaAbsoluteColors.white.withValues(alpha: 0.50);
}
