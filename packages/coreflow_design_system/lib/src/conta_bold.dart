/// CONTA BOLD — o produto, com o NOME dele.
///
/// Até 08/09 o Bold era o default de quatro classes da linguagem: `CoreflowProduto.bold`,
/// `CoreflowTemaMaterial.claro/escuro`, `CoreflowScheme.dark()/light()` e
/// `CoreflowGradients.primaryDoBold`. O veredito do pai (decisão 1) escolheu a opção B — nomes de
/// produto no app, sem sombra homônima —, e a razão não foi o custo: **o nome mentia.** *"Valor de
/// marca com nome de linguagem"* é a forma que o pai nunca aceita, e a sombra é essa forma um degrau
/// abaixo. No app são 14 linhas de 344: 5 são conserto (leem a paleta do produto onde o esquema já
/// está no contexto) e 9 são nome.
///
/// Tudo aqui é ATALHO: as instâncias saem de [produto], que é um `CoreflowProduto` como qualquer
/// outro — o pai não sabe que este existe.
library;

import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show ThemeData;

import 'bold_palette.dart';
import 'bold_type.dart';
import 'bold_vinho.dart';

abstract final class ContaBold {
  static const DilettaBrand marca = DilettaBrand(
    pacote: 'coreflow_design_system',
    // O mesmo arquivo nos dois slots: este produto não tem símbolo exportado em SVG (o que existe é
    // um `.webp` raster), então `mark` cai no lockup até o símbolo existir. Está escrito pra ser
    // pedido ao dono da marca e não pra virar folclore de "o mark é o full aqui".
    logo: 'assets/logos/conta-bold-lockup.svg',
    logoFull: 'assets/logos/conta-bold-lockup.svg',
    logoTingePorCurrentColor: true,
    // A PROPORÇÃO DO LOCKUP — 164,5 × 84, medido no arquivo.
    //
    // Ela morava em duas constantes privadas de uma casca do app (`BoldLogo`), que existia só pra
    // dividir largura por altura. O campo entrou no pai na `v0.147.0` com a razão que decidiu o
    // endereço: **proporção não é decisão de produto, é medida do arquivo** — e quem declara o
    // arquivo declara a medida dele.
    proporcaoDoLockup: 164.5 / 84,
    hexesDaArte: {
      '#fe3976': 'primary04', // 343 pinturas
      '#ff87ab': 'primary06', // 244
      '#f66fa0': 'primary05', // 159
      '#ffb6cb': 'primary07', // 121
      '#600627': 'primary02', // 73
      '#300313': 'primary01', // 27
      '#fff6fa': 'primary09', // 4
      // E a rampa DELE, composta e não copiada.
      //
      // Ontem eram 10 linhas copiadas daqui, porque `rampaDe` é exclusivo — declarar mapa próprio
      // desliga a tabela dele, e foi o ato de declarar o nosso rosa que fez o azul dele atravessar
      // `key_word` e `no_data` inteiras. A cópia resolvia hoje e envelhecia calada: hex que muda do
      // lado dele continuaria traduzido pelo valor velho, e o `apply` não erra alto.
      //
      // O pedido voltou ENTRA DIFERENTE com uma retificação dele que vale mais que a forma: as 59
      // artes moram no pacote DELE — foram DESENHADAS pelo primeiro filho e DOADAS ao pai. O mapa
      // que as traduz é dado dele sobre asset dele, então ele não morre em 20/09; fica público.
      // *"Uma preposição, e ela mudou de quem era o dado."*
      //
      // Vieram 3 hexes de graça na composição (`#7096ff`, `#dfe7ff`, `#f5f9ff`), que eu tinha
      // medido como faltando na tabela dele e ele conferiu por luminância. São 13 agora, não 10 —
      // e é exatamente por isso que a composição paga: eu não precisei saber que mudou.
      ...DilettaIllustrationBrand.rampaDoPai,
    },
  );

  /// Os dois gradientes do Conta BOLD: a curva do lockup, parada por parada, com o vinho-tinta por
  /// cima. A forma é do pai (`CoreflowGradients`); os valores são deste produto e moram na paleta dele.
  static const CoreflowGradients gradientes = CoreflowGradients(
    paleta: BoldPalette.bold,
    paradasDoLockup: BoldColors.lockupParadas,
    offsetsDoLockup: BoldColors.lockupStops,
    tintaSobreOGradiente: BoldVinho.ink,
  );

  /// O produto: paleta inteira, marca, tipografia e gradientes — as quatro declarações do Bold.
  static final CoreflowProduto produto = CoreflowProduto(
    paleta: BoldPalette.bold,
    marca: marca,
    tipografia: CoreflowType.tipografia,
    gradientes: gradientes,
  );

  /// O tema do avô, o que as peças dele leem pelo `DilettaThemeScope`.
  static DilettaTheme get temaClaro => produto.claro;
  static DilettaTheme get temaEscuro => produto.escuro;

  /// O `ThemeData` do Material — `theme:`/`darkTheme:` do `MaterialApp`.
  static ThemeData get materialClaro => produto.materialClaro;
  static ThemeData get materialEscuro => produto.materialEscuro;

  /// O esquema deste produto, por modo.
  static CoreflowScheme get esquemaClaro => produto.esquemaClaro;
  static CoreflowScheme get esquemaEscuro => produto.esquemaEscuro;
}
