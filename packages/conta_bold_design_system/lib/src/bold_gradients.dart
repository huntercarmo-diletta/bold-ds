/// CONTA BOLD — os gradientes da marca, e são DOIS.
///
/// Regra do dono do produto (2026-07-30): **no máximo dois — `primary` e `accent`** — e todo o
/// resto se modula neles. O produto antigo declarava dez; sete tinham ZERO uso (`pay`, `ted`,
/// `statement`, `receive`, `charge`, `balanceCard` e um alias), e os três que restavam eram
/// estes dois com um nome a mais.
///
/// ## O LOCKUP VOLTOU, e o que decidiu foi a TINTA
///
/// O `primary` era o pôr do sol de três paradas — rosa → coral → amarelo, do anel do "O" do
/// símbolo. Em 30/07 ele foi modulado pra duas paradas dentro das rampas, por duas razões medidas.
/// Em **19/08 o dono do produto reabriu**, e a reabertura responde às duas:
///
/// **1 · A legibilidade era do BRANCO, não do gradiente.** O argumento de 30/07 media branco sobre
/// as três paradas: 3,46 · 2,56 · **1,21** — a última é conteúdo invisível. A medição está certa e
/// não mudou. O que mudou é a tinta: com o **vinho-tinta da marca** as três dão
/// **5,69 · 7,71 · 16,33**, pior caso 5,69. O de duas paradas com branco tinha pior caso **3,37**.
/// Então o lockup com tinta escura não é o desenho bonito custando contraste — ele tem **pior caso
/// melhor** que o que estava no lugar dele, e é o primeiro dos dois que passa AA de TEXTO.
///
/// **2 · Os literais fora da paleta.** Este argumento continua de pé, e é por isso que o coral e o
/// amarelo agora são `BoldColors.lockupCoral` e `BoldColors.lockupAmarelo` — cores de MARCA
/// declaradas na paleta, como o vinho. Não são degraus de rampa e não fingem ser; o que se ganhou é
/// que um rebrand as alcança.
///
/// O `accent` **não mudou**: ele é o laranja inteiro, as duas paradas são da mesma rampa, e o caso
/// dele (controle pequeno) nunca pediu o matiz do lockup.
library;

import 'package:flutter/painting.dart';

import 'package:diletta_design_system/diletta_design_system.dart';

import 'bold_palette.dart';
import 'bold_vinho.dart';

/// Os dois gradientes do Conta BOLD, e os dois saem da paleta.
/// Os gradientes de um produto feito com este DS.
///
/// Deixou de ser só estático em 20/08. A classe abria com `static const _p = BoldPalette.bold` e as
/// oito paradas do lockup vinham de `BoldColors.lockupNN` — quer dizer: **um filho deste DS recebia
/// o rosa→amarelo do Conta BOLD** no card de destaque e no topo, depois de declarar a paleta dele.
/// A curva do lockup é a assinatura da marca; não existe versão dela que sirva pra duas marcas.
///
/// As paradas são do PRODUTO e não da paleta de propósito: `DilettaPalette` é rampa (degraus
/// nomeados), e a curva do símbolo não é rampa — é uma lista ordenada com offsets que saem do
/// arquivo do logo. Forçá-la em `papeisExtras` seria oito entradas fingindo ser papel.
///
/// Os estáticos ficam como atalho do Conta BOLD, que é o caso de 4 sítios hoje.
class BoldGradients {
  const BoldGradients({
    required this.paleta,
    required this.paradasDoLockup,
    required this.offsetsDoLockup,
    required this.tintaSobreOGradiente,
  });

  /// As paradas do Conta BOLD — a curva do símbolo, parada por parada.
  static const BoldGradients bold = BoldGradients(
    paleta: BoldPalette.bold,
    paradasDoLockup: [
      BoldColors.lockup01,
      BoldColors.lockup02,
      BoldColors.lockup03,
      BoldColors.lockup04,
      BoldColors.lockup05,
      BoldColors.lockup06,
      BoldColors.lockup07,
      BoldColors.lockup08,
    ],
    offsetsDoLockup: BoldColors.lockupStops,
    tintaSobreOGradiente: BoldVinho.ink,
  );

  final DilettaPalette paleta;

  /// A curva da marca, na ordem do símbolo. Mesmo comprimento que [offsetsDoLockup].
  final List<Color> paradasDoLockup;

  /// Os offsets de cada parada, de 0 a 1.
  final List<double> offsetsDoLockup;

  /// A tinta que vai POR CIMA do gradiente. No Bold é o vinho-tinta, com pior parada 5,69:1.
  final Color tintaSobreOGradiente;

  DilettaPalette get _p => paleta;

  /// **PRIMARY** — o lockup CONTA BOLD: rosa → coral → amarelo. Gradiente de momento herói: saldo,
  /// avatar de convite, superfície de destaque.
  ///
  /// **As OITO paradas do símbolo, com os offsets dele.** Tinta: [onGradient] (vinho-tinta), pior
  /// parada **5,69:1**.
  ///
  /// Eram três, escolhidas em 19/08 como amostra da curva — e declaradas SEM offset, o que fez o
  /// Flutter distribuí-las igualmente e jogar o coral pra 0,5 quando no símbolo ele está em 0,60.
  /// Medido no arquivo em 20/08: a curva da UI e a curva do logo eram diferentes no mesmo dia em
  /// que eu disse que o gradiente tinha voltado a ser o do lockup.
  LinearGradient get primary => LinearGradient(
        begin: const Alignment(-0.8, -1),
        end: const Alignment(0.8, 1),
        colors: paradasDoLockup,
        stops: offsetsDoLockup,
      );

  /// **ACCENT** — só laranja, e mais fundo: o âmbar descendo pro tostado. Para controle pequeno,
  /// onde o contraste de matiz do primary fica agitado: chip de ícone, círculo destacado da
  /// navegação, Pix.
  ///
  /// `warning03 → warning02`. Branco na pior parada: **3.37:1**; na outra, **6.54:1**.
  LinearGradient get accent => LinearGradient(
        begin: const Alignment(-0.7, -1),
        end: const Alignment(0.7, 1),
        colors: [_p.warning03, _p.warning02],
      );

  /// Os dois, pra quem precisa iterar — o catálogo, e o gate que trava a regra em dois.
  Map<String, LinearGradient> get todos => {
        'primary': primary,
        'accent': accent,
      };

  /// Conteúdo sobre gradiente: **o vinho-tinta da marca**, e a troca é o que destravou o lockup.
  ///
  /// Enquanto a tinta era branca, o gradiente do símbolo era impossível: 1,21:1 no amarelo é
  /// conteúdo que não existe na tela. **A pergunta certa não era qual gradiente, era qual tinta** —
  /// e ela só apareceu porque alguém mediu as duas tintas nas duas opções em vez de medir uma tinta
  /// nas duas.
  ///
  /// Uma tinta pro gradiente inteiro, julgada onde é mais fraca:
  ///
  /// | tinta | `primary` (rosa · coral · amarelo) | pior |
  /// |---|---|---|
  /// | branco | 3,46 · 2,56 · 1,21 | **1,21** |
  /// | vinho-tinta | 5,69 · 7,71 · 16,33 | **5,69** |
  /// | preto puro | 6,06 · 8,21 · 17,38 | 6,06 |
  ///
  /// **Vinho e não preto**, com 0,37 de diferença: o preto ganha por uma margem que ninguém vê, e o
  /// vinho já é o escuro DESTA marca (é o fill do vidro e a base do fluxo secundário). Trocar 0,37
  /// de contraste por uma tinta que pertence à identidade é a mesma escolha que este DS já faz no
  /// vidro — *"preto puro dá cinza morto; o matiz é o que faz dialogar com o rosa"*.
  ///
  /// **E a regra de uso ficou mais larga, não mais estreita.** 5,69 passa AA de TEXTO (4,5), então
  /// sobre gradiente cabe rótulo em qualquer tamanho — não só glifo e título grande, como era com
  /// os 3,37 do gradiente anterior. O `accent` continua com pior caso 3,37 e continua com a regra
  /// antiga: lá vale glifo e texto grande.
  Color get onGradient => tintaSobreOGradiente;

  // ── OS ATALHOS DO CONTA BOLD ───────────────────────────────────────────────
  //
  // Ficam porque 4 sítios os escrevem e porque o caso comum merece nome curto. Não são uma
  // segunda fonte: os três leem `bold`, que é a única declaração.

  /// O gradiente do lockup do Conta BOLD. Atalho pra `BoldGradients.bold.primary`.
  static LinearGradient get primaryDoBold => bold.primary;

  /// O gradiente âmbar do Conta BOLD. Atalho pra `BoldGradients.bold.accent`.
  static LinearGradient get accentDoBold => bold.accent;

  /// A tinta sobre gradiente do Conta BOLD. Atalho pra `BoldGradients.bold.onGradient`.
  static Color get onGradientDoBold => bold.onGradient;
}
