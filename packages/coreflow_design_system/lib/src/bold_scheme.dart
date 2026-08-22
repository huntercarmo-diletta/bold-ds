/// CONTA BOLD — o ESQUEMA, e ele saiu do app em 19/08.
///
/// Os catorze papéis mode-aware deste produto: superfície, texto, borda e os papéis de marca que
/// viram entre claro e escuro. As cores estáveis moram em [BoldColors]; estas leem-se por
/// `BoldColors.of(context)`, que é o `ThemeExtension` que o tema registra.
///
/// **Por que ele mora AQUI e não no app**: enquanto o esquema morava lá, o app não podia receber
/// o `ThemeData` pronto do pacote — o tema precisa registrar a extensão, e a extensão era do app.
/// Era a peça que trancava a porta por dentro. E ele nunca foi decisão de aplicação: onze dos
/// catorze papéis do escuro e nove dos catorze do claro **derivam do `DilettaScheme`** do pai; o
/// que sobra são decisões de MARCA do Bold, que é exatamente o que um DS filho existe pra dizer.
///
/// A classe manteve o nome. Os ~400 sítios que chamam `BoldColors.of(context).surface` no app não
/// souberam da mudança, e é assim que uma mudança de dono deve chegar.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';

import 'bold_palette.dart';
import 'bold_vinho.dart';

class CoreflowScheme extends ThemeExtension<CoreflowScheme> {
  const CoreflowScheme({
    required this.paleta,
    required this.vinho,
    required this.vinhoTinta,
    required this.vinhoLavagem,
    required this.brightness,
    required this.background,
    required this.secondaryFlow,
    required this.surface,
    required this.surfaceRaised,
    required this.field,
    required this.surfacePressed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderSoft,
    required this.borderStrong,
    required this.overlay,
    // Papéis de marca/estado mode-aware (Figma-like): o componente referencia o
    // papel; o valor troca por modo. Ver [CoreflowScheme.dark]/[light].
    required this.primary,
    required this.onPrimary,
    required this.primaryPressed,
    required this.primaryWash,
    required this.danger,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Brightness brightness;
  /// A RAMPA de onde este esquema saiu.
  ///
  /// Entrou em 20/08 porque o `ThemeData` precisa de degraus que não são papel: o
  /// `colorScheme.primary` do Material é o **rosa da marca** (`primary04`), e não o `primary` deste
  /// esquema — que no claro é o degrau profundo, escolhido pra passar AA com tinta branca. Eram dois
  /// valores diferentes com o mesmo nome, e o `CoreflowTemaMaterial` resolvia isso lendo a const
  /// congelada `BoldColors.primary04`. Guardar a paleta é o que deixa ele ler o degrau **da paleta
  /// que veio**, sem mudar um pixel deste produto.
  ///
  /// É o mesmo que o pai faz: `DilettaScheme` também carrega a `palette` de onde derivou.
  final DilettaPalette paleta;

  final Color background, surface, surfaceRaised, field, surfacePressed;

  /// Fundo sólido dos fluxos secundários (fora da navegação inferior).
  /// Ver [BoldColors.secondaryFlow].
  final Color secondaryFlow;
  /// A RAMPA DE TEXTO, e ela tem TRÊS degraus desde 17/08 — os mesmos papéis que a linguagem tem.
  ///
  /// Eram seis. Os três do meio (`textBody`, `textBodySoft`, `textLabel`) somavam **10 usos em
  /// 784**, todos dentro do próprio `design_system/`, e a medição mostrou que eles não eram
  /// decisão:
  ///
  /// | par | distância no ESCURO | no CLARO |
  /// |---|---|---|
  /// | `textBodySoft` → `textLabel` | **1,09** | 2,56 |
  /// | `textLabel` → `textSecondary` | **1,09** | 1,55 |
  /// | `textPrimary` → `textBody` | 1,21 | 1,25 |
  ///
  /// Dois degraus a 9% de distância não se distinguem em tela nenhuma. E o `label` fazia pior:
  /// no escuro ele é mais CLARO que o secundário (11,15 contra 10,24), no claro é mais ESCURO
  /// (3,23 contra 5,00) — **os dois trocam de ordem entre os temas**, o que é defeito e não
  /// escolha.
  ///
  /// Ficaram os três que o `DilettaScheme` também tem: `fg` · `textSecondary` · `textMuted`.
  final Color textPrimary, textSecondary, textMuted;
  final Color border, borderSoft, borderStrong;

  /// Legibility wash sobre a imagem de fundo.
  final Color overlay;

  /// Papéis de marca/estado (resolvem por modo — o componente usa o papel, não
  /// o primitivo). Dark = shades claros/vibrantes; light = shades profundos.
  final Color primary, onPrimary, primaryPressed, primaryWash;
  final Color danger, success, warning, info;

  /// O VINHO — o segundo eixo da marca deste produto, em três degraus.
  ///
  /// [vinho] é a marca (ladrilho, badge, realce), [vinhoTinta] é o quase-preto com matiz (fill do
  /// vidro escuro, tinta sobre o gradiente do lockup) e [vinhoLavagem] é a base do vidro no escuro.
  ///
  /// Vêm de `papeisExtras`, então um filho deste DS declara os dele na paleta dele. Antes de 20/08
  /// eram três `static const` de `BoldVinho` lidas direto por 8 sítios do pacote — o rosa viajava
  /// com a paleta e o vinho não.
  final Color vinho, vinhoTinta, vinhoLavagem;

  bool get isDark => brightness == Brightness.dark;
  /// O ESQUEMA A PARTIR DE UMA PALETA — e é esta assinatura que faz o DS ser retematizável.
  ///
  /// **Até 19/08 as duas fábricas cravavam `BoldPalette.bold` por dentro.** Isso quer dizer que um
  /// neto deste DS não tinha como pedir o esquema DELE: trocar a paleta não mudava nada, porque nada
  /// aqui lia a paleta que foi passada — não existia paleta passada.
  ///
  /// A pergunta que produziu esta mudança foi do dono do produto: *"se o Bold tiver um filho, apenas
  /// mudando os tokens conseguiremos mudar toda a aplicação?"*. A resposta medida era **não**: 8
  /// papéis cravados no escuro e 13 no claro, 21 valores dentro deste arquivo. Os componentes estavam
  /// limpos (zero hex real nos 33 do pacote); quem decidia cor fora do contrato era o tradutor entre
  /// paleta e papel, que é a última camada onde isso deveria acontecer.
  ///
  /// ## As três formas de um papel chegar aqui
  ///
  /// 1. **derivado do pai** — `DilettaScheme` resolve 57 papéis a partir da paleta. É o caminho da
  ///    maioria, e o único que não precisa de nada deste arquivo;
  /// 2. **derivado por REGRA** — o valor é uma função da paleta, não um literal: *"no claro a marca
  ///    escreve com o degrau profundo"*, *"a borda suave é a tinta de borda a 5%"*, *"o scrim é o
  ///    fundo a 85%"*. A regra viaja; o valor não;
  /// 3. **`papeisExtras` da paleta** — vocabulário que o pai não tem (superfície elevada, superfície
  ///    pressionada, fluxo secundário, informação). O neto declara os dele na paleta dele.
  ///
  /// ## E os DOIS que não viajavam fecharam em 20/08
  ///
  /// Eram `background` e `field` no CLARO: a paleta do pai tinha os overrides do ESCURO (`v0.1.9`) e
  /// o espelho do claro pro TEXTO e pra BORDA (`v0.111.0`), e faltava a SUPERFÍCIE. Pedido de 19/08,
  /// veredito ENTRA na **`v0.119.0`** — `bgClaro` e `surfaceMutedClara`.
  ///
  /// **Agora são 44 de 44.** Os dois valores continuam sendo deste produto; o que mudou é que eles
  /// entram pela paleta, então um neto declara os dele no mesmo lugar.
  factory CoreflowScheme.de(DilettaPalette paleta, {required Brightness brilho}) {
    final escuro = brilho == Brightness.dark;
    final d = escuro ? DilettaScheme.dark(paleta) : DilettaScheme.light(paleta);

    /// Um papel que o pai não tem, lido da paleta. Sem declaração, cai no valor deste produto — o
    /// fallback existe pra uma paleta incompleta desenhar em vez de estourar, e o gate cobra que a
    /// paleta do Bold declare os quatro.
    Color extra(String nome, Color reserva) {
      final e = paleta.papeisExtras[nome];
      return e == null ? reserva : (escuro ? e.escuro : e.claro);
    }

    /// A tinta de BORDA: branco no escuro, preto no claro. É sobre ela que os dois alphas incidem.
    final tintaDeBorda = escuro ? paleta.white : paleta.black;

    /// O fundo da página, e ele **passou a derivar em 20/08**.
    ///
    /// Era o primeiro dos dois valores que não viajavam pra uma paleta de neto: no claro ele lia
    /// `BoldColors.fundoClaroDaPagina` porque o contrato do pai não tinha onde declarar a superfície
    /// clara. Tem desde a `v0.119.0` (`bgClaro`), e a paleta deste filho declara — então aqui virou
    /// derivação nos dois modos.
    final fundo = d.bg;

    return CoreflowScheme(
      paleta: paleta,
      brightness: brilho,
      // ── derivados do pai ──────────────────────────────────────────────────
      surface: d.surface,
      textPrimary: d.fg,
      textSecondary: d.textSecondary,
      textMuted: d.textMuted,
      border: d.border,
      onPrimary: d.onPrimary,
      success: d.success,
      warning: d.warning,
      // ── derivados por REGRA ───────────────────────────────────────────────
      background: fundo,
      // O scrim é o FUNDO com alpha, não uma cor própria: assim ele acompanha a página em qualquer
      // paleta. 70% no escuro e 85% no claro porque o claro precisa de mais véu pra o conteúdo
      // atrás parar de competir.
      overlay: fundo.withValues(alpha: escuro ? 0.70 : 0.85),
      // **No claro a marca escreve com o degrau PROFUNDO**, e não com o degrau de ação. A página é
      // branca: link e rótulo no 04 reprovariam contraste. Medido: `primary03` dá 8,03 sobre o
      // branco contra 3,46 do 04. A REGRA viaja; o hex não.
      primary: escuro ? d.primary : paleta.primary03,
      primaryPressed: escuro ? d.primaryPressed : paleta.primary02,
      danger: escuro ? d.error : paleta.error03,
      // Fill TRANSLÚCIDO no escuro contra o `primarySubtle` SÓLIDO do pai: são materiais diferentes,
      // não versões — e o translúcido deixa a arte de fundo aparecer por baixo do tinte.
      primaryWash:
          escuro ? paleta.primary04.withValues(alpha: 0.20) : d.primarySubtle,
      // Os dois alphas de borda. Alpha não é valor de marca: ele viaja inteiro pra qualquer paleta,
      // porque o que muda de produto pra produto é a TINTA, e ela vem da paleta acima.
      borderSoft: tintaDeBorda.withValues(alpha: escuro ? 0.07 : 0.05),
      borderStrong: tintaDeBorda.withValues(alpha: escuro ? 0.18 : 0.14),
      // ── o vocabulário que é deste produto, declarado na paleta ─────────────
      surfaceRaised: extra('superficieElevada',
          escuro ? BoldColors.superficieElevadaEscura : BoldColors.superficieElevadaClara),
      surfacePressed: extra('superficiePressionada',
          escuro ? BoldColors.superficiePressionadaEscura : BoldColors.superficiePressionadaClara),
      secondaryFlow: extra('fluxoSecundario',
          escuro ? BoldColors.fluxoSecundarioEscuro : BoldColors.fluxoSecundarioClaro),
      info: extra('info', BoldColors.info),
      // O VINHO, pelo mesmo caminho dos outros quatro extras.
      // Pelos resolvedores do próprio `BoldVinho`, e não pelo `extra()` daqui: os dois fariam a
      // mesma conta, e conta repetida diverge. Quem não tem esquema na mão chama lá direto.
      vinho: BoldVinho.marcaDe(paleta),
      vinhoTinta: BoldVinho.tintaDe(paleta),
      vinhoLavagem: BoldVinho.lavagemDe(paleta),
      // O segundo que não viajava, e ele fechou junto: `surfaceMutedClara` na `v0.119.0`.
      field: d.surfaceMuted,
    );
  }

  /// O escuro do Bold. Atalho pra [CoreflowScheme.de] com a paleta deste produto.
  static CoreflowScheme dark() =>
      CoreflowScheme.de(BoldPalette.bold, brilho: Brightness.dark);

  /// O claro do Bold. Atalho pra [CoreflowScheme.de] com a paleta deste produto.
  static CoreflowScheme light() =>
      CoreflowScheme.de(BoldPalette.bold, brilho: Brightness.light);


  @override
  CoreflowScheme copyWith({Brightness? brightness}) => this;

  @override
  CoreflowScheme lerp(ThemeExtension<CoreflowScheme>? other, double t) {
    if (other is! CoreflowScheme) return this;
    return t < 0.5 ? this : other;
  }
}
