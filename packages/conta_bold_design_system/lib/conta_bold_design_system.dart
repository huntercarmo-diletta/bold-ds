/// CONTA BOLD — o DS-filho.
///
/// Este arquivo é a identidade do produto, e é quase só isso: a paleta. Os **53 papéis de cor**
/// do scheme são DERIVADOS dela — contados por CAMPO e não por linha, que é o que errou as duas
/// versões anteriores desta frase (`~50` de chute, e `39` de um regex meu que lia
/// `final Color warning, onWarning, warningSubtle;` como um papel só). Confere com
/// `grep -oE 'final Color\??[^;]+;' diletta_scheme.dart | tr ',' '\n' | wc -l` — a pergunta é
/// quantos CAMPOS, e o comando tem que responder essa, não quantas linhas declaram algum.
///
/// Derivados quer dizer o que está escrito: este filho não escolhe papel nenhum, não monta
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

import 'src/bold_palette.dart';

/// A LINGUAGEM SAI POR AQUI, e é o que faz este pacote ser "o DS do Bold" pra quem
/// consome: o app e o catálogo importam UM caminho
/// (`package:conta_bold_design_system/...`) e recebem os componentes do pai — **77 com
/// contrato** (`kDilettaSpecs`, medido em 2026-08-06; eu dizia 100) — mais a identidade
/// daqui.
///
/// É também o que sustenta o `importNoCodigo` do catálogo: o código gerado diz
/// `ds.DilettaButton(...)` com `ds` apontando pra cá. Sem este reexport, o código gerado
/// não compilaria no app — e o catálogo não teria como saber.
export 'package:diletta_design_system/diletta_design_system.dart';

/// A identidade deste filho: paleta, fonte e os dois gradientes.
export 'src/bold_palette.dart';
export 'src/bold_scheme.dart';
export 'src/bold_radius.dart';
export 'src/bold_vidro.dart';
export 'src/bold_tema_material.dart';
export 'src/bold_pontos_de_pagina.dart';
export 'src/bold_vinho.dart';
export 'src/bold_fonts.dart';
export 'src/bold_type.dart';
export 'src/bold_fundamentos.dart';
export 'src/bold_gradients.dart';
export 'src/bold_ilustracao.dart';

/// Componentes que só o Bold tem, nascidos aqui compondo as peças do pai.
export 'src/bold_autorizacao.dart';
export 'src/bold_background.dart';
export 'src/bold_dinheiro.dart';
export 'src/bold_abas.dart';
export 'src/bold_cabecalho_da_home.dart';
export 'src/bold_contratos.dart';
export 'src/bold_copiar.dart';
export 'src/bold_escada_de_alcadas.dart';

/// AS QUATRO LACUNAS, e as duas que estavam do lado errado da fronteira.
///
/// Elas entraram juntas porque a causa é uma só: o dono pediu quatro telas em alta fidelidade pro
/// catálogo, e **as quatro paravam aqui**. `BoldMenuTile`, `BoldFilterChip`, `BoldNoticeRow` e
/// `BoldPromoCard` eram as quatro últimas peças marcadas como LACUNA no inventário de adoção
/// (alcance 4, 3, 2 e 2); a fileira de avatares e o grupo do dia já eram adotados, mas moravam em
/// `app-newbold/lib/design_system/` — e o catálogo consome o PACOTE, nunca o app.
///
/// São duas classes de defeito diferentes com o mesmo sintoma: **peça que não dá pra desenhar em
/// lugar nenhum**. A régua que saiu daqui: adotada e alcançável não são a mesma coisa.
export 'src/bold_cartao_da_conta.dart';
export 'src/bold_cartao_de_pedido.dart';
export 'src/bold_amostra_de_fundo.dart';
export 'src/bold_nav_flutuante.dart';
export 'src/bold_cartao_promocional.dart';
export 'src/bold_chip_de_filtro.dart';
export 'src/bold_fileira_de_avatares.dart';
export 'src/bold_grupo_do_dia.dart';
export 'src/bold_ladrilho_de_menu.dart';
export 'src/bold_linha_de_aviso.dart';
export 'src/bold_resumo_da_transacao.dart';
export 'src/bold_saldo.dart';
export 'src/bold_segmentos.dart';
export 'src/bold_selo_quantico.dart';
export 'src/bold_visor_de_codigo.dart';

/// Os temas do Bold — claro e escuro, com a paleta acima.
///
/// O escuro sai de graça: mesma paleta, rampa invertida pelo pai.
class BoldTheme {
  BoldTheme._();

  /// ONDE OS ASSETS DO PAI MORAM — uma linha, e sem ela nenhum ícone do pai aparece.
  ///
  /// `DilettaAssets.assetPackage` nasce `null`, que significa "assets na raiz do bundle". Num app que
  /// CONSOME o pacote eles moram em `packages/diletta_design_system/…`, então o `AssetBytesLoader`
  /// procura no lugar errado. E `VectorGraphic` com asset ausente **não estoura**: desenha caixa vazia.
  ///
  /// Chegou como *"os ícones não estão aparecendo no app"*, depois de a adoção trocar
  /// `BoldIconButton` por `DilettaIconButton`: as setas de voltar, os ícones da home e o `>` do extrato
  /// sumiram juntos. Nada falhou — nem `analyze`, nem a suíte inteira, nem o console. (O número que
  /// estava escrito aqui, `414 testes`, era de outra medição e ficou velho: hoje são 125 no pacote e 86
  /// no catálogo. O argumento nunca dependeu do tamanho da suíte — dependeu de nada nela olhar o asset.)
  ///
  /// **Fica AQUI e não no `main` do app**, e a razão é a mesma que o catálogo escreveu no plugue dele:
  /// quem liga o DS é quem sabe onde o DS guarda coisa. No `main` isso é uma linha que todo app novo
  /// tem que lembrar de copiar — e o primeiro filho, que resolveu no `main` do catálogo dele, tem o
  /// mesmo buraco de um lado só.
  ///
  /// É idempotente e roda no primeiro acesso ao tema. Não existe caminho que desenhe componente do pai
  /// sem passar por `BoldTheme.light`/`dark`: o `DilettaThemeScope` é obrigatório pra qualquer um deles.
  static void _garanteOsAssetsDoPai() {
    DilettaAssets.assetPackage ??= DilettaAssets.package;
  }

  static DilettaTheme get light {
    _garanteOsAssetsDoPai();
    return _claro;
  }

  static DilettaTheme get dark {
    _garanteOsAssetsDoPai();
    return _escuro;
  }

  /// A MARCA deste produto, declarada no plugue do pai — arquivos e o mapa da arte.
  ///
  /// Antes de 20/08 este filho não declarava nada aqui, e o custo era duplo: o `BoldLogo` vivia como
  /// peça privada no app (5 sítios, classificado `deliberado` com a razão *"o pai tem a marca DELE"*,
  /// que estava errada desde que o plugue existe), e as 77 ilustrações não recoloriam pra paleta
  /// nenhuma.
  ///
  /// **`logoTingePorCurrentColor`** é o veredito da `v0.120.0`: as partes tingíveis do arquivo dizem
  /// `currentColor` e o `ColorFilter` não entra. É o arquivo decidindo o alcance da tinta em vez de a
  /// peça adivinhar por hex — e adivinhar por hex era o defeito do outro pedido do mesmo dia.
  ///
  /// **`hexesDaArte`** é o mapa hex→NOME do degrau, e o nome é a parte que importa: nome sobrevive à
  /// troca de paleta, cor não. São **17 entradas em duas chaveaduras**: os 7 degraus de marca das
  /// artes DESTE produto (38 arquivos, 1751 pinturas, 403 de marca) e os 10 hexes das artes do PAI,
  /// que consumimos desde 20/08. Neutro e semântico ficam de fora por regra do pai — *"cor de marca
  /// troca, erro/aviso e neutro são invariantes"*.
  static const DilettaBrand marca = DilettaBrand(
    pacote: 'conta_bold_design_system',
    // O mesmo arquivo nos dois slots: este produto não tem símbolo exportado em SVG (o que existe é
    // um `.webp` raster), então `mark` cai no lockup até o símbolo existir. Está escrito pra ser
    // pedido ao dono da marca e não pra virar folclore de "o mark é o full aqui".
    logo: 'assets/logos/conta-bold-lockup.svg',
    logoFull: 'assets/logos/conta-bold-lockup.svg',
    logoTingePorCurrentColor: true,
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

  static final DilettaTheme _claro =
      DilettaTheme.resolve(palette: BoldPalette.bold, brand: marca);

  static final DilettaTheme _escuro = DilettaTheme.resolve(
      palette: BoldPalette.bold, brightness: Brightness.dark, brand: marca);
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
