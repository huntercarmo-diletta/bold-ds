/// CONTA BOLD — o DS-filho.
///
/// Este arquivo é a identidade do produto, e é quase só isso: a paleta. Os ~50 papéis
/// do scheme são DERIVADOS dela, então este filho não escolhe papel nenhum, não monta
/// tema Material, não registra componente e não copia widget do pai.
///
/// A fonte dos valores é `app-newbold/lib/design_system/theme/bold_colors.dart` — as
/// rampas de lá já nasceram com a estrutura do pai (01 = tinta, 10 = superfície),
/// porque o DS do Bold começou se integrando com o do primeiro filho.
///
/// O que NÃO está aqui e é de propósito: os extras do Bold (glass, gradiente de marca,
/// escada de aprovação, `secondaryFlow`, alphas). Cada um precisa passar pela pergunta
/// da governança — "outro produto ia querer isso?" — antes de virar campo daqui ou
/// pedido pro pai. Enquanto não passarem, este arquivo é a paleta e mais nada.
library conta_bold_design_system;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// A LINGUAGEM SAI POR AQUI, e é o que faz este pacote ser "o DS do Bold" pra quem
/// consome: o app e o catálogo importam UM caminho
/// (`package:conta_bold_design_system/...`) e recebem os 100 componentes do pai mais a
/// identidade daqui.
///
/// É também o que sustenta o `importNoCodigo` do catálogo: o código gerado diz
/// `ds.DilettaButton(...)` com `ds` apontando pra cá. Sem este reexport, o código gerado
/// não compilaria no app — e o catálogo não teria como saber.
export 'package:diletta_design_system/diletta_design_system.dart';

/// A fonte da marca. Identidade, então mora no filho.
export 'src/bold_fonts.dart';

/// A paleta do Conta BOLD: rosa da marca, vinho como profundidade.
class BoldPalette {
  BoldPalette._();

  static const DilettaPalette bold = DilettaPalette(
    id: 'contaBold',

    // MARCA — rosa. 01 escuro → 09 lavado. 04 é a cor de ação (rosa do logo).
    primary01: Color(0xFF300313),
    primary02: Color(0xFF600627),
    // AJUSTADO na adoção (era #CC1E58): no escuro o pai usa o 03 como tinte e o 07
    // como texto em cima, e o par dava 3.29:1. Escurecer o 03 é o único conserto que
    // não mexe no rosa da marca (o 04). Efeito no app: pressed state mais profundo.
    primary03: Color(0xFF9E1241),
    primary04: Color(0xFFFE3976),
    primary05: Color(0xFFF66FA0),
    primary06: Color(0xFFFF87AB),
    primary07: Color(0xFFFFB6CB),
    primary08: Color(0xFFFFEDF3),
    primary09: Color(0xFFFFF6FA),
    primaryStateSelected: Color(0xFFFFE0EA),
    primaryStateHover: Color(0xFFFFEDF2),
    onPrimary: Color(0xFFFFFFFF),

    // PARCEIRO — o Bold não tem cobrand hoje, então o slot recebe o vinho da marca
    // (`brandPrincipal`) e a superfície wine-ink do glass escuro. Assim nada cai no
    // laranja de REFERÊNCIA do pai, que não é marca de ninguém.
    // REVISAR quando existir um parceiro de verdade: esta é escolha de fallback.
    partnerPrimary: Color(0xFF90093A),
    partnerOnPrimary: Color(0xFFFFFFFF),
    partnerSurface: Color(0xFF16060A),

    // NEUTROS
    neutral01: Color(0xFF3D3939),
    neutral02: Color(0xFF525252),
    neutral03: Color(0xFF737373),
    neutral04: Color(0xFF808080),
    neutral05: Color(0xFFA0A0A0),
    neutral06: Color(0xFFB3B3B3),
    neutral07: Color(0xFFC6C6C6),
    neutral08: Color(0xFFD9D9D9),
    neutral09: Color(0xFFECECEC),
    neutral10: Color(0xFFF6F6F6),
    white: DilettaAbsoluteColors.white,
    black: DilettaAbsoluteColors.black,

    // ERRO
    error01: Color(0xFF530E16),
    error02: Color(0xFF8E1B28),
    error03: Color(0xFFB42318),
    error04: Color(0xFFEF4757),
    error05: Color(0xFFFF4D5E),
    error06: Color(0xFFF7A9B1),
    error07: Color(0xFFFEF3F2),
    // Banner sólido de erro: o vermelho profundo do app, que lê branco em cima.
    errorBanner: Color(0xFF8E1B28),

    // AVISO
    warning01: Color(0xFF573703),
    // AJUSTADO na adoção (era #8F5A06): tinte de aviso no escuro, com o 06 como texto
    // em cima — dava 4.21:1.
    warning02: Color(0xFF85520A),
    warning03: Color(0xFFC47C0A),
    warning04: Color(0xFFF6A21A),
    warning05: Color(0xFFFDB43D),
    warning06: Color(0xFFFBD79B),
    warning07: Color(0xFFFEF6E7),

    // SUCESSO
    success01: Color(0xFF0A3F24),
    success02: Color(0xFF12693A),
    // AJUSTADO na adoção (era #1E8F4E): a rampa de sucesso do app estava INVERTIDA no
    // meio — o 03 era mais claro que o 04, e o 03 é o que escreve sobre o wash (dava
    // 3.97:1). O valor novo é mais escuro que o 04, então a rampa volta a subir.
    success03: Color(0xFF157A45),
    success04: Color(0xFF0E9154),
    success05: Color(0xFF2FD27A),
    success06: Color(0xFFA9EFC8),
    success07: Color(0xFFF1FEF6),

    // ── AS SUPERFÍCIES DO ESCURO (opcionais, entraram na v0.1.9 do pai) ──────
    //
    // Sem declarar, o pai cai na rampa neutra (01/02/03), que é neutra e serve. O
    // Bold declara porque o escuro DELE é escolha de marca, não cinza: o app usa um
    // blue-black quase preto, e é o par plano do backdrop da home.
    //
    // Medido: com a rampa neutra o par `neutral onSubtle/subtle` no escuro dava
    // 4.39:1, porque o `neutral01` do Bold (#3D3939) é claro pra fundo de tela. Com
    // os valores do app o escuro fica mais escuro e o par passa. É o conserto certo,
    // não afrouxamento: o defeito era o fundo, não o texto.
    bgEscuro: Color(0xFF0A0B12),
    surfaceEscura: Color(0xFF14151F),
    surfaceMutedEscura: Color(0xFF1E1F2D),

    // O VIDRO — a receita inteira, que virou do filho na v0.4.0 do pai.
    //
    // O pai sabe COMO se constrói vidro (o clip colado no filtro, o tinte por cima, e
    // nada de sombra atrás — sombra atrás de vidro é reamostrada e vira halo sujo). O
    // filho diz de que MATERIAL, e o material do Bold é:
    //
    // - fill a 50% nos dois modos: vinho-ink no escuro, branco no claro;
    // - blur 15, uniforme em todo vidro do app;
    // - traço de 1px, e ele existe por um defeito medido: no claro a borda BRANCA sumia
    //   sobre fundo claro, então o traço claro é o rosa lavado do 08. É o mesmo caso que
    //   a regra `traco-de-vidro-visivel` do pai passou a cobrar.
    tinteDeVidroClaro: Color(0x80FFFFFF),
    tinteDeVidroEscuro: Color(0x8016060A),
    blurDeVidro: 15,
    tracoDeVidroClaro: Color(0xFFFFEDF3), // primary08
    tracoDeVidroEscuro: Color(0x4DFF9898), // rosa claro @ 30%

    // SEGURO (o selo) — ouro fosco do Bold. O 02 e o 08 não existiam no app: o pai
    // pede os dois degraus extremos, e eles foram derivados da rampa que já havia.
    secure02: Color(0xFF5C4813),
    secure03: Color(0xFF8A6D1F),
    secure04: Color(0xFFC9A227),
    secure05: Color(0xFFE0BE4D),
    secure07: Color(0xFFFBF3D6),
    secure08: Color(0xFFFEFBF0),
  );
}

/// Os temas do Bold — claro e escuro, com a paleta acima.
///
/// O escuro sai de graça: mesma paleta, rampa invertida pelo pai.
class BoldTheme {
  BoldTheme._();

  static final DilettaTheme light =
      DilettaTheme.resolve(palette: BoldPalette.bold);

  static final DilettaTheme dark = DilettaTheme.resolve(
      palette: BoldPalette.bold, brightness: Brightness.dark);
}

/// Uma tela do Bold montada SÓ com componentes do pai.
///
/// Serve de exemplo e de instrumento: é o que o teste renderiza pra medir se sobrou
/// cor do primeiro filho em algum lugar.
class TelaDeExemploBold extends StatelessWidget {
  const TelaDeExemploBold({super.key, this.escuro = false});

  final bool escuro;

  @override
  Widget build(BuildContext context) {
    return DilettaThemeScope(
      theme: escuro ? BoldTheme.dark : BoldTheme.light,
      child: Builder(
        builder: (ctx) {
          final s = DilettaTheme.schemeOf(ctx);
          return ColoredBox(
            color: s.bg,
            child: DilettaFrame.column(
              gap: DilettaSpacing.s4,
              padding: EdgeInsets.all(DilettaSpacing.s5),
              children: [
                DilettaText('Conta BOLD', style: DilettaType.displaySm),
                DilettaText(
                  'Nenhuma linha desta tela é do Bold: os componentes são do pai, e a '
                  'cor vem da paleta.',
                  style: DilettaType.bodyMd,
                ),
                DilettaButton(label: 'Continuar', onPressed: () {}),
                DilettaStatusTag(label: 'Ativo', tone: DilettaStatusTone.success),
                DilettaBox(
                  color: s.primarySubtle,
                  radius: DilettaRadius.all16,
                  child: DilettaText('Superfície da marca', style: DilettaType.label),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
