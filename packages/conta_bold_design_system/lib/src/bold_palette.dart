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

  // ═══════════════════════════════════════════════════════════════════════
  // O LOCKUP — as duas paradas do gradiente da marca que não são degrau de rampa
  // ═══════════════════════════════════════════════════════════════════════
  //
  // Decisão do dono do produto (2026-08-19), e ela REABRE uma de 30/07.
  //
  // O gradiente da marca voltou a ser o do lockup CONTA BOLD: rosa → coral → amarelo, que é a
  // leitura do anel do "O" do símbolo. Ele havia sido modulado pra duas paradas dentro das rampas,
  // por duas razões medidas — e a decisão de hoje responde às duas:
  //
  // **1 · A legibilidade.** O argumento de 30/07 era o branco: sobre as três paradas ele dá
  // 3,46 · 2,56 · **1,21**, e 1,21 no amarelo é conteúdo invisível. O que mudou não é a medição, é a
  // TINTA: com o vinho-tinta da marca o gradiente dá **5,69 · 7,71 · 16,33** — pior caso 5,69, que
  // passa AA de TEXTO. O de duas paradas com branco tinha pior caso 3,37, que passa AA-grande e
  // **não** passa AA de texto. Trocar a tinta melhorou o pior caso em vez de piorá-lo.
  //
  // **2 · Os literais fora da paleta.** Esse argumento continua válido, e é por isso que os dois
  // valores moram AQUI e não dentro do arquivo de gradiente. Eles não são degraus — são cores de
  // MARCA declaradas, como o vinho, e um rebrand as alcança neste arquivo.

  /// O CORAL do lockup — a parada do meio do gradiente da marca.
  static const Color lockupCoral = Color(0xFFFE7B5E);

  /// O AMARELO do lockup — a cauda do gradiente, e o que o símbolo tem que a rampa não tem.
  static const Color lockupAmarelo = Color(0xFFFEED35);

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

  // ── O TEXTO DO ESCURO (opcionais, entraram na v0.109.0 do pai, a meu pedido) ──────────
  //
  // Mesmo caso das superfícies, uma camada acima: a derivação do pai dá cinza PURO (distância
  // entre canais RGB = 0 nos quatro papéis) e o texto deste produto é AZULADO — 6 no corpo, 17
  // no secundário, 22 no mudo. Não é preferência: o fundo daqui é `#0A0B12`, um azul-quase-preto,
  // e cinza puro sobre fundo azulado lê como sujo.
  //
  // O `mudo` é o degrau que decidiu o pedido: ele fica em **3,81** contra o fundo, de propósito,
  // porque é METADADO — passa o piso de texto e não compete com o corpo. A derivação da rampa o
  // punha em 7,51, mais forte que o `textSecondary` de muitos produtos. Mudo que grita deixa de
  // ser mudo.
  //
  // Quatro campos, SETE papéis: `texto` → `fg` + `onSurface` · `mudo` → `textMuted` +
  // `textPlaceholder` · `borda` → `border` + `divider`. E o terciário e o desabilitado chegam
  // DERIVADOS, pela fração de luminância que o degrau ocupa entre os vizinhos desta rampa — o
  // pai não abriu slot pros dois porque eu não tinha medição pra eles, e ele estava certo.
  static const Color textoEscuro = Color(0xFFFFFFFF);
  static const Color textoSecundarioEscuro = Color(0xFFB7BBC8);
  static const Color textoMudoEscuro = Color(0xFF686D7E);

  // ── O TEXTO DO CLARO (opcionais, v0.111.0 do pai, no mesmo dia do pedido) ─────────────
  //
  // O espelho do escuro, e ele veio com DOIS defeitos consertados. O meu: o `textMuted` do claro
  // estava em **2,96** sobre a superfície — abaixo do piso de texto GRANDE —, enquanto eu defendia
  // 3,81 pro mesmo papel no escuro. A régua que eu apontei pro pai acusou o que eu tinha em casa.
  //
  // O dele: o `textPlaceholder` do claro derivava por degrau FIXO e dava **2,61** sobre o branco
  // nesta rampa. O piso entrou na derivação, nos dois modos — terceira vez que a lição volta, e
  // agora ela é conta e não convenção.
  //
  // Os valores: o texto e o secundário são os que este produto já usava (medidos e aprovados,
  // 10,31 e 5,53). O MUDO subiu — `#8A8398` dá 3,54 contra os 2,96 de antes, e mantém a
  // temperatura (spread 21) que a rampa neutra do pai não tem como dar.
  static const Color textoClaro = Color(0xFF3D3939);
  static const Color textoSecundarioClaro = Color(0xFF6B6678);
  static const Color textoMudoClaro = Color(0xFF8A8398);
  static const Color bordaClara = Color(0x12000000);

  /// Branco a 8% — e ele chegou aqui por CRUZAMENTO, não por desenho: o `border` do escuro do
  /// pai era `const Color(0x14FFFFFF)` cravado no scheme, hex por hex igual ao deste produto em
  /// 127 sítios. Dois caminhos separados no mesmo valor é o sinal de token que já era da
  /// linguagem e ainda não tinha nome nela.
  static const Color bordaEscura = Color(0x14FFFFFF);

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

    // O NOME DA MARCA como ela se escreve na tela, obrigatório desde a `ds v0.76.0`.
    //
    // Ele entrou pagando um defeito que vale reter porque é da minha classe favorita de dívida:
    // **duas peças da LINGUAGEM pintavam o nome do primeiro filho** — o botão de carteira dizia
    // literalmente *"Pagar com CPF Seguro"*, e ele é o único ponto de contato que um parceiro embeda
    // no app dele.
    //
    // A régua do pai: *"string que é lookup é inofensiva; string que é PINTADA é o pior caso da
    // classe"*. `id` eu podia renomear à vontade; este aqui é o que a pessoa lê.
    //
    // Escrito como o produto se escreve — `Conta BOLD`, com o BOLD em caixa alta, que é a assinatura
    // da marca e não ênfase de texto.
    nome: 'Conta BOLD',

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

    // O TEXTO E A BORDA DO ESCURO (opcionais, v0.109.0 do pai)
    textoEscuro: BoldColors.textoEscuro,
    textoSecundarioEscuro: BoldColors.textoSecundarioEscuro,
    textoMudoEscuro: BoldColors.textoMudoEscuro,
    bordaEscura: BoldColors.bordaEscura,

    // E O ESPELHO NO CLARO (v0.111.0), que consertou 2,96 -> 3,54 no mudo
    textoClaro: BoldColors.textoClaro,
    textoSecundarioClaro: BoldColors.textoSecundarioClaro,
    textoMudoClaro: BoldColors.textoMudoClaro,
    bordaClara: BoldColors.bordaClara,

    // O VIDRO — a receita inteira, que virou do filho na v0.4.0 do pai.
    tinteDeVidroClaro: BoldColors.tinteDeVidroClaro,
    tinteDeVidroEscuro: BoldColors.tinteDeVidroEscuro,
    blurDeVidro: 15,
    tracoDeVidroClaro: BoldColors.tracoDeVidroClaro,
    tracoDeVidroEscuro: BoldColors.tracoDeVidroEscuro,

    // A TINTA QUE ESTE PRODUTO ASSUME — `v0.115.0` do pai, e ela vem com o número que eu devo.
    //
    // O caso: `DilettaInputChip.selecionavel` pintava rótulo ESCURO sobre o rosa e o CTA deste
    // produto pintava BRANCO sobre o mesmo rosa, na mesma tela. Nenhum dos dois estava errado — o
    // pai deriva a tinta por contraste e o branco não alcança AA sobre o `primary04`, então ele
    // corrigia; eu declarava branco e a declaração era descartada em silêncio.
    //
    // **O veredito não me deu o que eu pedi, me deu melhor**: em vez de um motivo novo no ajuste de
    // papel (que resolveria 6 arquivos e deixaria o sétimo nascer errado), a exceção virou
    // DECLARAÇÃO AUDITÁVEL. Três travas: razão e medida obrigatórias, a medida CONFERIDA pela
    // auditoria contra o pior modo, e teto no piso gráfico — *"marca decide entre legível e mais
    // legível; ninguém decide por ilegível"*.
    //
    // **E ela vale só no CLARO, por aritmética e não por escolha.** No escuro o pai clareia a marca
    // pro degrau 05 (`#F66FA0`), e ali o branco cai pra **2,73** — abaixo do teto de 3:1, então a
    // derivação segue mandando. O `3,46` declarado é o pior modo em que eu de fato assumo.
    tintasAssumidas: const [
      DilettaTintaAssumida(
        papel: 'onPrimary',
        razao: 'o rótulo branco sobre o rosa da marca é o CTA deste produto desde antes da adoção; '
            'trocar a tinta pro escuro mudaria o botão mais visto do app, e escurecer o rosa mudaria '
            'a marca. Decisão do dono do produto em 19/08.',
        medida: 3.46,
      ),
    ],

    // A FORMA DO BOTÃO — 16, e não a pílula.
    //
    // O CTA deste produto é retângulo de canto 16 desde antes de existir adoção; o do pai era
    // `pillAll` cravado, e isso trancava 55 telas fora da casca de baixo dele: adotar viraria
    // redesenho, não integração. Entrou na v0.44.0 do pai como campo de PALETA (o scheme deriva
    // `formaDoBotao`), pela razão que ele mesmo escreveu sobre o vidro — *a receita é do filho, a
    // construção é do pai*. Raio de botão é receita.
    //
    // Nulo ⇒ pílula, que é o default dele. Este 16 é o único lugar do produto que diz a forma.
    raioDeBotao: 16,

    // E O CARD DE CONTEÚDO É VIDRO, que é a quinta linha da mesma receita (`ds v0.32.0`).
    //
    // Ela existe porque o dono do produto olhou o board e disse *"o fundo nos cards (lista) também é
    // glassy e eles estão solid"*. O card de lista deste produto é vidro em **96 sítios do app**, e a
    // razão não é estética: o fundo da home é o mood de IMAGEM, e card sólido em cima da arte apaga a
    // arte — *"fills deixam a foto de fundo passar"* é regra do DS do app de antes de eu existir.
    //
    // O veredito do pai foi pela forma que eu preferia, e o argumento dele é a fronteira e não o knob:
    // dos 4 arquivos dele que usavam o vidro, **os 4 eram chrome** — a construção já era dele, e o
    // vocabulário só a oferecia pra barra. Parâmetro por componente teria espalhado a mesma falta em
    // quatro assinaturas.
    //
    // Uma linha aqui converte `AppList.carded`, `EmptyState` e `QuickAccessCard`. **Declarar isto num
    // produto de fundo liso seria pagar `BackdropFilter` por nada** — e é por isso que a decisão é do
    // filho: só ele sabe o que está atrás.
    cardDeVidro: true,

    // O BRILHO DO ESQUELETO É ROSA, e é a sexta linha da mesma receita (`ds v0.34.0`).
    //
    // O relato que a produziu: *"o skeleton tem um shimmer rosinha, agora só é o frame cinza"* — o dono do
    // produto reconheceu a marca **pela ausência dela**. O esqueleto é a primeira coisa que toda tela que
    // espera dado mostra: o momento com menos conteúdo e mais identidade por pixel.
    //
    // O que fica no componente e NÃO se declara é o alpha: ele é a FORMA da varredura (banda que entra e
    // sai), não a identidade. O que é do produto é a cor — a frase é do veredito, e ela também é o limite
    // da regra: **material se declara; estado não.**
    // O FEIXE, e ele vem em PAR — a `ds v0.35.1` corrigiu as duas metades do mesmo pedido: a varredura
    // virou luz que atravessa (três stops, pontas transparentes) e a cor passou a ter um valor por modo.
    //
    // Por que dois rosas e não um: o que se vê é a cor MISTURADA com o que está atrás, e o que está
    // atrás muda. No claro o esqueleto é cinza 217 e o `primary07` (rosa lavado) abre a banda sem
    // estourar; no escuro ele é cinza 82, e sobre esse fundo o mesmo rosa lavado quase some — a medição
    // do pedido mostrou o pico caindo de `236,199,210` pra `169,132,142`. No escuro entra o `primary06`,
    // um degrau mais forte, pra a luz ter o mesmo peso de leitura nos dois modos.
    brilhoDoEsqueletoClaro: BoldColors.primary07,
    brilhoDoEsqueletoEscuro: BoldColors.primary06,

    // SEGURO (o selo) — ouro fosco do Bold.
    secure02: BoldColors.secure02,
    secure03: BoldColors.secure03,
    secure04: BoldColors.secure04,
    secure05: BoldColors.secure05,
    secure07: BoldColors.secure07,
    secure08: BoldColors.secure08,
  );
}
