import 'package:flutter/widgets.dart';

import 'diletta_absolute_colors.dart';

/// CPF SEGURO — Palette (primitivos / tier 1).
///
/// Espelha as coleções `Palette 01/02/03` do Figma: rampas cruas de cor,
/// uma **instância por flavor**. Trocar de flavor (ex: SDK dentro do app de
/// um parceiro white-label) = trocar a instância de [DilettaPalette]; a
/// camada semântica ([DilettaScheme]) repontar sozinha.
///
/// REGRA: componente **nunca** lê primitivo daqui. Lê [DilettaScheme] (papel
/// semântico). Isto aqui é matéria-prima da paleta, não contrato de uso.
///
/// `DilettaPalette.cpf` = flavor padrão (azul CPF SEGURO), valores 1:1 com o
/// legado `CpfSeguroColors`. Flavors de parceiro entram como novas instâncias.
@immutable
class DilettaPalette {
  const DilettaPalette({
    required this.id,
    // Primary (brand)
    required this.primary01,
    required this.primary02,
    required this.primary03,
    required this.primary04,
    required this.primary05,
    required this.primary06,
    required this.primary07,
    required this.primary08,
    required this.primary09,
    required this.primaryStateSelected,
    required this.primaryStateHover,
    required this.onPrimary,
    required this.partnerPrimary,
    required this.partnerOnPrimary,
    required this.partnerSurface,
    // Neutral
    required this.neutral01,
    required this.neutral02,
    required this.neutral03,
    required this.neutral04,
    required this.neutral05,
    required this.neutral06,
    required this.neutral07,
    required this.neutral08,
    required this.neutral09,
    required this.neutral10,
    required this.white,
    required this.black,
    // Error
    required this.error01,
    required this.error02,
    required this.error03,
    required this.error04,
    required this.error05,
    required this.error06,
    required this.error07,
    required this.errorBanner,
    this.bgEscuro,
    this.surfaceEscura,
    this.surfaceMutedEscura,
    this.tinteDeVidroClaro,
    this.tinteDeVidroEscuro,
    // Warning
    required this.warning01,
    required this.warning02,
    required this.warning03,
    required this.warning04,
    required this.warning05,
    required this.warning06,
    required this.warning07,
    // Success
    required this.success01,
    required this.success02,
    required this.success03,
    required this.success04,
    required this.success05,
    required this.success06,
    required this.success07,
    // Secure (modo segurança — sempre amarelo, nunca vermelho)
    required this.secure02,
    required this.secure03,
    required this.secure04,
    required this.secure05,
    required this.secure07,
    required this.secure08,
  });

  /// Identificador do flavor ('cpf', 'aurora', ...). Aparece no dev inspect.
  final String id;

  final Color primary01, primary02, primary03, primary04, primary05, primary06, primary07, primary08, primary09;
  final Color primaryStateSelected, primaryStateHover, onPrimary;

  /// Cor do PARCEIRO no cobrand, e a tinta sobre ela.
  ///
  /// Estavam fora da paleta — literais numa classe estática — e por isso um DS-filho não
  /// tinha campo pra trocar a cor do parceiro DELE: recebia a laranja do parceiro do CPF
  /// SEGURO. Achado pelo teste de segundo filho, no catálogo.
  final Color partnerPrimary, partnerOnPrimary;

  /// Superfície do cartão COBRANDED (o cartão do parceiro, escuro).
  ///
  /// Era `cardDark`, literal numa classe estática e fora da paleta — então o
  /// cartão de parceiro de qualquer filho vinha com o cinza-quase-preto do CPF
  /// SEGURO, sem campo pra trocar. Entrou junto de `partnerPrimary`, que tinha o
  /// mesmo problema e foi achado pelo mesmo teste.
  final Color partnerSurface;

  final Color neutral01, neutral02, neutral03, neutral04, neutral05, neutral06, neutral07, neutral08, neutral09, neutral10;
  final Color white, black;

  final Color error01, error02, error03, error04, error05, error06, error07;

  /// Superfície do banner de erro SÓLIDO (vermelho escuro com texto pálido).
  ///
  /// Era `errorBanner`, também fora da paleta. Não é degrau da rampa `error` — é
  /// uma decisão própria, e por isso precisa de campo: sem ele o banner de erro de
  /// todo filho ficaria no vermelho do CPF SEGURO.
  final Color errorBanner;

  // ─── SUPERFÍCIES DO ESCURO, e o tinte do vidro ─────────────────────────────
  //
  // Opcionais DE PROPÓSITO: campo obrigatório novo na paleta é major pra todo filho, e o default
  // derivado já é o certo pra quem não tem opinião.
  //
  // Elas existem porque o escuro do primeiro filho estava CRAVADO EM HEX aqui dentro (#0B1020,
  // #161C2E, #212A42 — o navy do CPF). Medido pelo segundo filho: com a paleta dele plugada, o
  // `bg` do escuro saía navy. É a mesma classe de defeito dos gradientes que já foram consertados,
  // num lugar onde o teste de vazamento não olhava — a lista de cores do CPF tem só as de marca, e
  // superfície não estava nela.
  //
  // Nulo ⇒ derivado da rampa neutra (01/02/03 no escuro), que é neutro e serve. Declarado ⇒ a
  // marca decide: o navy do CPF e o wine-ink do Bold são decisões de design, não default de motor.

  /// Fundo da tela no escuro. Nulo ⇒ `neutral01`.
  final Color? bgEscuro;

  /// Superfície elevada no escuro (cartão, menu). Nulo ⇒ `neutral02`.
  final Color? surfaceEscura;

  /// Superfície de apoio no escuro. Nulo ⇒ `neutral03`.
  final Color? surfaceMutedEscura;

  /// Tinte do VIDRO (barras glass). Nulo ⇒ branco a 80% no claro, `neutral01` a 80% no escuro.
  ///
  /// O vidro do segundo filho é tingido de vinho por decisão de design; com o literal do pai ele
  /// saía neutro, e não havia como corrigir do lado do filho.
  final Color? tinteDeVidroClaro;
  final Color? tinteDeVidroEscuro;
  final Color warning01, warning02, warning03, warning04, warning05, warning06, warning07;
  final Color success01, success02, success03, success04, success05, success06, success07;
  final Color secure02, secure03, secure04, secure05, secure07, secure08;


  /// PALETA DE REFERÊNCIA — a segunda identidade, e a prova de que existe uma.
  ///
  /// Não é a marca de nenhum produto: é uma rampa verde/teal coerente, escolhida pra
  /// ser inconfundível ao lado do azul do CPF SEGURO. Serve pra duas coisas:
  ///
  /// 1. **prova de que o DS é dirigido por paleta.** Um teste renderiza os componentes
  ///    com ela e cobra que nenhuma cor de marca do CPF apareça. Cada vazamento é um
  ///    lugar onde a identidade de um filho NÃO chega — e o teste diz quantos são;
  /// 2. **paleta dos testes do próprio pai**, no dia em que o DS virar pai de verdade.
  ///    Se o pai passa nos próprios testes com uma paleta que não é de ninguém, nenhuma
  ///    identidade de produto vazou pra dentro dele.
  ///
  /// Os passos seguem a mesma gramática da rampa do CPF (01 escuro → 09/10 claro, 04 =
  /// base), porque a gramática é do PAI e a cor é do filho.
  static const DilettaPalette referencia = DilettaPalette(
    id: 'referencia',
    primary01: Color(0xFF04231C),
    primary02: Color(0xFF06382C),
    primary03: Color(0xFF0A5744),
    primary04: Color(0xFF0E7C5F),
    primary05: Color(0xFF17A37D),
    primary06: Color(0xFF3FBF9B),
    primary07: Color(0xFFA6E2D1),
    primary08: Color(0xFFE3F6F0),
    primary09: Color(0xFFF2FBF8),
    primaryStateSelected: Color(0xFFD3F0E7),
    primaryStateHover: Color(0xFFC2E9DC),
    onPrimary: Color(0xFFFFFFFF),
    // Parceiro da paleta de REFERÊNCIA: um roxo, distinto da laranja do CPF, pra o
    // teste de vazamento conseguir distinguir os dois.
    partnerPrimary: Color(0xFF6B3FA0),
    partnerOnPrimary: Color(0xFFFFFFFF),
    // Cartão do parceiro na referência: quase-preto levemente frio, distinto do
    // cinza do CPF pra o teste de vazamento enxergar a diferença.
    partnerSurface: Color(0xFF1C2124),
    neutral01: Color(0xFF14181A),
    neutral02: Color(0xFF20262A),
    neutral03: Color(0xFF39424A),
    neutral04: Color(0xFF5A656E),
    neutral05: Color(0xFF74818B),
    neutral06: Color(0xFF929EA7),
    neutral07: Color(0xFFB2BCC4),
    neutral08: Color(0xFFD5DCE1),
    neutral09: Color(0xFFE9EEF1),
    neutral10: Color(0xFFF5F8F9),
    white: DilettaAbsoluteColors.white,
    black: DilettaAbsoluteColors.black,
    error01: Color(0xFF3D0A08),
    error02: Color(0xFF5E110D),
    error03: Color(0xFF8A1A14),
    error04: Color(0xFFB3251D),
    error05: Color(0xFFD8483F),
    error06: Color(0xFFE8837C),
    error07: Color(0xFFFBE4E2),
    errorBanner: Color(0xFF8E2B2B),
    warning01: Color(0xFF3A2A02),
    warning02: Color(0xFF5C4304),
    warning03: Color(0xFF876307),
    warning04: Color(0xFFB0810A),
    warning05: Color(0xFFD4A62A),
    warning06: Color(0xFFE6C86B),
    warning07: Color(0xFFFBF2DA),
    success01: Color(0xFF06301F),
    success02: Color(0xFF0A4B31),
    success03: Color(0xFF0E6E47),
    success04: Color(0xFF12905C),
    success05: Color(0xFF2FB37B),
    success06: Color(0xFF6ACCA2),
    success07: Color(0xFFE0F5EB),
    secure02: Color(0xFF4A3A05),
    secure03: Color(0xFF6E5708),
    secure04: Color(0xFF9C7B0C),
    secure05: Color(0xFFC49E1E),
    secure07: Color(0xFFF6ECC8),
    secure08: Color(0xFFFBF6E4),
  );
}
