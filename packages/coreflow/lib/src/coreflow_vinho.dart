/// O VINHO — o polo PROFUNDO da marca de um produto, em três degraus, e ele é da linguagem.
///
/// Toda marca deste DS tem dois eixos: a cor de AÇÃO, que mora em `primary01..09`, e a PROFUNDIDADE
/// — o fill do vidro escuro, o fluxo secundário, o ladrilho de ícone, o realce escuro. O nome
/// "vinho" veio do primeiro produto, onde ele é literal; num banco verde ele é um verde quase preto.
/// O nome ficou porque é o que o app lê (`CoreflowScheme.vinhoTinta`), e renomear API não é
/// separar.
///
/// ## Três degraus, e de onde eles saem
///
/// | degrau | o trabalho | de onde sai |
/// |---|---|---|
/// | `marca` | ladrilho de ícone, badge, realce escuro, polo frio dos fundos | `papeisExtras['vinhoMarca']` |
/// | `tinta` | o quase-preto com o matiz da marca: fill do vidro escuro, tinta sobre o gradiente | `papeisExtras['vinhoTinta']` |
/// | `lavagem` | a base do vidro no escuro — material, não degrau de rampa | `papeisExtras['vinhoLavagem']` |
///
/// Quem declara os três na paleta recebe o que declarou. Quem NÃO declara recebe [derivadosDe]: os
/// três degraus derivados da rampa DELE, nas posições em que eles caem na rampa do primeiro produto
/// — medidas com erro zero na terceira casa de claridade. Até 04/09 a reserva era a constante do
/// primeiro produto, e o defeito estava medido: **o vidro escuro de um banco verde saía vermelho**.
///
/// Existe como classe, e não só como campos do `CoreflowScheme`, porque nem todo sítio tem esquema
/// na mão: as peças leem `DilettaTheme.schemeOf(context)`, que dá o esquema do PAI e a paleta. Com a
/// paleta, resolve. O `CoreflowScheme` chama exatamente estas funções — um valor, uma implementação.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/painting.dart' show Color;

abstract final class CoreflowVinho {
  static Color _de(DilettaPalette p, String nome) =>
      p.papeisExtras[nome]?.claro ?? derivadosDe(p)[nome]!.claro;

  /// O vinho da marca desta paleta. Declarado, ou derivado da rampa dela.
  static Color marcaDe(DilettaPalette p) => _de(p, 'vinhoMarca');

  /// O vinho-tinta desta paleta.
  static Color tintaDe(DilettaPalette p) => _de(p, 'vinhoTinta');

  /// A lavagem desta paleta.
  static Color lavagemDe(DilettaPalette p) => _de(p, 'vinhoLavagem');

  // ── A REGRA, e ela é medida e não escolhida ─────────────────────────────────
  //
  // Os três valores do primeiro produto caem em pontos definidos da rampa DELE, e é essa posição
  // que viaja:
  //
  // | degrau | onde cai na rampa | erro de claridade |
  // |---|---|---|
  // | `marca` | entre o 02 e o 03, em **0,69** | 0,000 |
  // | `lavagem` | entre o 01 e o 02, em **0,41** | 0,000 |
  // | `tinta` | entre o PRETO e o 01, em **0,54** | 0,000 |
  //
  // As três posições reproduzem os três hexes daquele produto com erro zero na terceira casa — então
  // descrevem os valores em vez de aproximá-los, e aplicadas à rampa de outra marca dão o vinho
  // DAQUELA marca. Iguais nos dois modos porque o vinho não muda com o tema — quem muda é quem o
  // escolhe (o vidro pega a lavagem só no escuro).

  /// Os três degraus do vinho derivados da rampa de marca desta paleta.
  static Map<String, DilettaPapelExtra> derivadosDe(DilettaPalette p) {
    final marca = Color.lerp(p.primary02, p.primary03, 0.69)!;
    final lavagem = Color.lerp(p.primary01, p.primary02, 0.41)!;
    final tinta = Color.lerp(p.black, p.primary01, 0.54)!;
    return {
      'vinhoMarca': DilettaPapelExtra(
          claro: marca, escuro: marca, significado: 'o vinho da marca, derivado da rampa dela'),
      'vinhoLavagem': DilettaPapelExtra(
          claro: lavagem,
          escuro: lavagem,
          significado: 'a lavagem do material, derivada da rampa da marca'),
      'vinhoTinta': DilettaPapelExtra(
          claro: tinta, escuro: tinta, significado: 'o quase-preto com o matiz da marca'),
    };
  }
}
