/// CONTA BOLD — a rampa e a paleta, nesta ordem.
///
/// Mora em `src/` e sai pelo barril. Estava no arquivo do barril e saiu de lá quando os
/// gradientes precisaram lê-la: um arquivo em `src/` importando o barril fecharia ciclo, e a
/// saída certa não é o import esperto, é a peça no lugar.
///
/// ## A ordem de declaração é a peça, e ela custou um pedido
///
/// A rampa é declarada em [BoldColors], em `static const Color`, e [BoldPalette.bold] é
/// **montada a partir dela**. O inverso — hex dentro do construtor da paleta — compila igual
/// e tira do consumidor a única forma de derivar sem copiar:
///
/// ```dart
/// static const Color acao = BoldPalette.bold.primary04;
/// // error • The property 'primary04' can't be accessed on the type 'DilettaPalette'
/// //         in a constant expression
/// ```
///
/// Acesso a campo de instância não é expressão constante em Dart, mesmo quando a instância é
/// `const`. Medido no `app-newbold` antes de o pai fechar a convenção: as duas saídas sem esta
/// inversão eram **84 constantes copiadas** (com uma suíte comparando cópia com pacote),
/// `static final` quebrando as **51 linhas** `const` do app, ou `Palette.p.x` espalhado nos
/// **427** sítios, tirando o `const` de todos.
///
/// Regra do pai, `O-QUE-O-FILHO-FORNECE.md` §1, veredito ENTRA COMO FORMA da `ds v0.25.0`:
///
/// > **A rampa é a fonte; a paleta é derivada dela.**
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/painting.dart';

import 'bold_vinho.dart';

/// A RAMPA do Conta BOLD — a fonte, legível em contexto `const`.
///
/// Quem consome deriva daqui (`static const Color acao = BoldColors.primary04;`), e não da
/// paleta. Cada família vai de 01 (escuro) a 07/09/10 (lavado), com **04 = base**.
class BoldColors {
  BoldColors._();

  // ── MARCA — rosa. 04 é a cor de ação (o rosa do logo). ────────────────────
  static const Color primary01 = Color(0xFF300313);
  static const Color primary02 = Color(0xFF600627);

  /// AJUSTADO na adoção (era `#CC1E58`): no escuro o pai usa o 03 como tinte e o 07 como
  /// texto em cima, e o par dava 3.29:1. Escurecer o 03 é o único conserto que não mexe no
  /// rosa da marca (o 04). Efeito no app: pressed state mais profundo.
  static const Color primary03 = Color(0xFF9E1241);

  static const Color primary04 = Color(0xFFFE3976);
  static const Color primary05 = Color(0xFFF66FA0);
  static const Color primary06 = Color(0xFFFF87AB);
  static const Color primary07 = Color(0xFFFFB6CB);
  static const Color primary08 = Color(0xFFFFEDF3);
  static const Color primary09 = Color(0xFFFFF6FA);
  static const Color primaryStateSelected = Color(0xFFFFE0EA);
  static const Color primaryStateHover = Color(0xFFFFEDF2);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── NEUTROS ───────────────────────────────────────────────────────────────
  static const Color neutral01 = Color(0xFF3D3939);
  static const Color neutral02 = Color(0xFF525252);
  static const Color neutral03 = Color(0xFF737373);
  static const Color neutral04 = Color(0xFF808080);
  static const Color neutral05 = Color(0xFFA0A0A0);
  static const Color neutral06 = Color(0xFFB3B3B3);
  static const Color neutral07 = Color(0xFFC6C6C6);
  static const Color neutral08 = Color(0xFFD9D9D9);
  static const Color neutral09 = Color(0xFFECECEC);
  static const Color neutral10 = Color(0xFFF6F6F6);

  // ── ERRO ──────────────────────────────────────────────────────────────────
  static const Color error01 = Color(0xFF530E16);
  static const Color error02 = Color(0xFF8E1B28);
  static const Color error03 = Color(0xFFB42318);
  static const Color error04 = Color(0xFFEF4757);
  static const Color error05 = Color(0xFFFF4D5E);
  static const Color error06 = Color(0xFFF7A9B1);
  static const Color error07 = Color(0xFFFEF3F2);

  /// Banner sólido de erro: o vermelho profundo do app, que lê branco em cima.
  static const Color errorBanner = error02;

  // ── AVISO ─────────────────────────────────────────────────────────────────
  static const Color warning01 = Color(0xFF573703);

  /// AJUSTADO na adoção (era `#8F5A06`): tinte de aviso no escuro, com o 06 como texto em
  /// cima — dava 4.21:1.
  static const Color warning02 = Color(0xFF85520A);

  static const Color warning03 = Color(0xFFC47C0A);
  static const Color warning04 = Color(0xFFF6A21A);
  static const Color warning05 = Color(0xFFFDB43D);
  static const Color warning06 = Color(0xFFFBD79B);
  static const Color warning07 = Color(0xFFFEF6E7);

  // ── SUCESSO ───────────────────────────────────────────────────────────────
  static const Color success01 = Color(0xFF0A3F24);
  static const Color success02 = Color(0xFF12693A);

  /// AJUSTADO na adoção (era `#1E8F4E`): a rampa de sucesso do app estava INVERTIDA no meio
  /// — o 03 era mais claro que o 04, e o 03 é o que escreve sobre o wash (dava 3.97:1). O
  /// valor novo é mais escuro que o 04, então a rampa volta a subir.
  static const Color success03 = Color(0xFF157A45);

  static const Color success04 = Color(0xFF0E9154);
  static const Color success05 = Color(0xFF2FD27A);
  static const Color success06 = Color(0xFFA9EFC8);
  static const Color success07 = Color(0xFFF1FEF6);

  // ── SEGURO (o selo) — ouro fosco do Bold ──────────────────────────────────
  //
  // O 02 e o 08 não existiam no app: o pai pede os dois degraus extremos, e eles foram
  // derivados da rampa que já havia.
  static const Color secure02 = Color(0xFF5C4813);
  static const Color secure03 = Color(0xFF8A6D1F);
  static const Color secure04 = Color(0xFFC9A227);
  static const Color secure05 = Color(0xFFE0BE4D);
  static const Color secure07 = Color(0xFFFBF3D6);
  static const Color secure08 = Color(0xFFFEFBF0);

  // ── AS SUPERFÍCIES DO ESCURO ──────────────────────────────────────────────
  //
  // Sem declarar, o pai cai na rampa neutra (01/02/03), que é neutra e serve. O Bold declara
  // porque o escuro DELE é escolha de marca, não cinza: o app usa um blue-black quase preto,
  // e é o par plano do backdrop da home.
  //
  // Medido: com a rampa neutra o par `neutral onSubtle/subtle` no escuro dava 4.39:1, porque
  // o `neutral01` do Bold (#3D3939) é claro pra fundo de tela. Com os valores do app o escuro
  // fica mais escuro e o par passa. É o conserto certo, não afrouxamento: o defeito era o
  // fundo, não o texto.
  static const Color bgEscuro = Color(0xFF0A0B12);
  static const Color surfaceEscura = Color(0xFF14151F);
  static const Color surfaceMutedEscura = Color(0xFF1E1F2D);

  // ── O VIDRO ───────────────────────────────────────────────────────────────
  //
  // O pai sabe COMO se constrói vidro (o clip colado no filtro, o tinte por cima, e nada de
  // sombra atrás — sombra atrás de vidro é reamostrada e vira halo sujo). O filho diz de que
  // MATERIAL, e o material do Bold é fill a 50% nos dois modos, blur 15, traço de 1px.
  //
  // O traço existe por um defeito medido: no claro a borda BRANCA sumia sobre fundo claro,
  // então o traço claro é o rosa lavado do 08. É o mesmo caso que a regra
  // `traco-de-vidro-visivel` do pai passou a cobrar.
  static const Color tinteDeVidroClaro = Color(0x80FFFFFF);

  /// `BoldVinho.ink` a 50% — o vidro escuro é vinho-tinta, não preto: preto puro sobre a arte
  /// de fundo dá cinza morto, e o matiz é o que mantém o painel dialogando com o rosa.
  static const Color tinteDeVidroEscuro = Color(0x8016060A);

  static const Color tracoDeVidroClaro = primary08;
  static const Color tracoDeVidroEscuro = Color(0x4DFF9898); // rosa claro @ 30%
}

/// A paleta do Conta BOLD: rosa da marca, vinho como profundidade.
///
/// **Derivada** de [BoldColors] — ver a nota de ordem no topo do arquivo.
class BoldPalette {
  BoldPalette._();

  static const DilettaPalette bold = DilettaPalette(
    id: 'contaBold',

    // MARCA — rosa. 01 escuro → 09 lavado. 04 é a cor de ação (rosa do logo).
    primary01: BoldColors.primary01,
    primary02: BoldColors.primary02,
    primary03: BoldColors.primary03,
    primary04: BoldColors.primary04,
    primary05: BoldColors.primary05,
    primary06: BoldColors.primary06,
    primary07: BoldColors.primary07,
    primary08: BoldColors.primary08,
    primary09: BoldColors.primary09,
    primaryStateSelected: BoldColors.primaryStateSelected,
    primaryStateHover: BoldColors.primaryStateHover,
    onPrimary: BoldColors.onPrimary,

    // PARCEIRO — o Bold não tem cobrand hoje, então o slot EMPRESTA o vinho da marca. Sem
    // valor aqui, o componente cobranded cairia no laranja de REFERÊNCIA do pai, que não é
    // marca de ninguém.
    //
    // Empresta, e não mora: a casa do vinho é `BoldVinho`, e é de lá que o vidro, o fundo e o
    // ladrilho de ícone leem. Quando existir parceiro de verdade, trocar aqui não move mais
    // nada — que é o ponto de o valor ter nome próprio.
    partnerPrimary: BoldVinho.marca,
    partnerOnPrimary: BoldColors.onPrimary,
    partnerSurface: BoldVinho.ink,

    // NEUTROS
    neutral01: BoldColors.neutral01,
    neutral02: BoldColors.neutral02,
    neutral03: BoldColors.neutral03,
    neutral04: BoldColors.neutral04,
    neutral05: BoldColors.neutral05,
    neutral06: BoldColors.neutral06,
    neutral07: BoldColors.neutral07,
    neutral08: BoldColors.neutral08,
    neutral09: BoldColors.neutral09,
    neutral10: BoldColors.neutral10,
    white: DilettaAbsoluteColors.white,
    black: DilettaAbsoluteColors.black,

    // ERRO
    error01: BoldColors.error01,
    error02: BoldColors.error02,
    error03: BoldColors.error03,
    error04: BoldColors.error04,
    error05: BoldColors.error05,
    error06: BoldColors.error06,
    error07: BoldColors.error07,
    errorBanner: BoldColors.errorBanner,

    // AVISO
    warning01: BoldColors.warning01,
    warning02: BoldColors.warning02,
    warning03: BoldColors.warning03,
    warning04: BoldColors.warning04,
    warning05: BoldColors.warning05,
    warning06: BoldColors.warning06,
    warning07: BoldColors.warning07,

    // SUCESSO
    success01: BoldColors.success01,
    success02: BoldColors.success02,
    success03: BoldColors.success03,
    success04: BoldColors.success04,
    success05: BoldColors.success05,
    success06: BoldColors.success06,
    success07: BoldColors.success07,

    // AS SUPERFÍCIES DO ESCURO (opcionais, entraram na v0.1.9 do pai)
    bgEscuro: BoldColors.bgEscuro,
    surfaceEscura: BoldColors.surfaceEscura,
    surfaceMutedEscura: BoldColors.surfaceMutedEscura,

    // O VIDRO — a receita inteira, que virou do filho na v0.4.0 do pai.
    tinteDeVidroClaro: BoldColors.tinteDeVidroClaro,
    tinteDeVidroEscuro: BoldColors.tinteDeVidroEscuro,
    blurDeVidro: 15,
    tracoDeVidroClaro: BoldColors.tracoDeVidroClaro,
    tracoDeVidroEscuro: BoldColors.tracoDeVidroEscuro,

    // SEGURO (o selo) — ouro fosco do Bold.
    secure02: BoldColors.secure02,
    secure03: BoldColors.secure03,
    secure04: BoldColors.secure04,
    secure05: BoldColors.secure05,
    secure07: BoldColors.secure07,
    secure08: BoldColors.secure08,
  );
}
