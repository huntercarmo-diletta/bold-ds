/// DILETTA — a identidade, e ela é uma cor, dois arquivos e uma fonte.
///
/// ## A cor, medida antes de escolhida (09/09/2026)
///
/// O design entregou uma escala de sete vermelhos escuros e um logo cujo símbolo é `#E60000` — e o
/// símbolo não estava na escala. A decisão da dona foi seguir a rampa do avô a partir do vermelho do
/// logo. Ele cai sozinho no degrau 04, o de ação: é a claridade dele que pede esse degrau, o que não
/// acontece com quatro das cinco marcas da família. Conformidade do avô: zero violações nos dois
/// modos. Texto branco sobre o botão: 4,81:1 — AA para texto, AAA para gráfico.
///
/// **O semáforo foi medido e a resposta é forma, não matiz.** O erro da linguagem (`#B3251D` no
/// claro, `#D8483F` no escuro) está no mesmo matiz. Escurecer o vermelho pra alcançar AAA o aproxima
/// do erro (ΔE 10,0 → 2,6 em `#B30000`); deslocar o matiz ao laranja ou ao carmim compra 1 a 3 de
/// distância e paga em fidelidade ao logo ou em proximidade com o rosa do primeiro filho. Ficou o
/// `#E60000`, e perigo continua se dizendo por ponto, contorno, ícone e botão sólido — regra do avô.
library;

import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Color, ThemeData;

abstract final class Diletta {
  /// O vermelho do símbolo. A ÚNICA decisão de cor deste produto.
  static const Color vermelho = Color(0xFFE60000);

  /// A marca: o símbolo e o lockup horizontal, recortados do arquivo oficial. O símbolo mantém o
  /// vermelho; as letras dizem `currentColor` e viram com o tema — `#1F1F1F` no claro, branco no
  /// escuro. Sem arte própria, o mapa da arte é o do avô: as ilustrações dele saem na rampa daqui.
  static const DilettaBrand marca = DilettaBrand(
    pacote: 'diletta_coreflow',
    logo: 'assets/logos/diletta-mark.svg',
    logoFull: 'assets/logos/diletta-lockup.svg',
    logoTingePorCurrentColor: true,
    nomeDaMarca: 'Diletta',
    // Medido no arquivo: viewBox 10918 × 4128.
    proporcaoDoLockup: 10918 / 4128,
    hexesDaArte: DilettaIllustrationBrand.rampaDoPai,
  );

  /// A escala do avô com a família da casa. Os degraus são da linguagem; só a fonte é declaração.
  static final CoreflowTipografia tipografia =
      CoreflowTipografia.doAvo.copyWith(familia: 'packages/diletta_coreflow/Inter');

  /// O produto — a porta de uma cor. Rampa, papéis, vidro, vinho e gradiente derivam.
  static final CoreflowProduto produto = CoreflowProduto.daMarca(
    marca: vermelho,
    id: 'diletta',
    nome: 'Diletta',
    marcaVisual: marca,
    tipografia: tipografia,
  );

  static DilettaTheme get temaClaro => produto.claro;
  static DilettaTheme get temaEscuro => produto.escuro;
  static ThemeData get materialClaro => produto.materialClaro;
  static ThemeData get materialEscuro => produto.materialEscuro;
  static CoreflowScheme get esquemaClaro => produto.esquemaClaro;
  static CoreflowScheme get esquemaEscuro => produto.esquemaEscuro;
}
