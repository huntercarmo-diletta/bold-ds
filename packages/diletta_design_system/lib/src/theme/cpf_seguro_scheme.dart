import 'package:flutter/widgets.dart';
import 'cpf_seguro_palette.dart';

/// CPF SEGURO — Scheme (semântica / tier 2).
///
/// Espelha a coleção `0.Theme` do Figma (modos Light/Dark). Cada campo é um
/// **papel** (BG, FG, Primary...), não uma cor crua. Resolve os primitivos de
/// um [DilettaPalette] conforme o modo.
///
/// É isto que os widgets consomem (via `DilettaTheme.of(context).scheme`),
/// nunca [DilettaPalette] direto. Nome de cada papel segue os grupos do
/// Figma: Common (bg/bgMenu/fg), Neutral (surface/border/muted), Brand
/// (primary...), e as famílias de status.
///
/// `.light(palette)` reproduz 1:1 o uso atual do DS (não-quebra). `.dark(...)`
/// é 1ª versão — afinar contra os valores Dark do Figma depois.
@immutable
class DilettaScheme {
  const DilettaScheme({
    required this.brightness,
    required this.palette,
    // Common
    required this.bg,
    required this.bgMenu,
    required this.fg,
    // Superfície (card / sheet / glass base)
    required this.surface,
    required this.onSurface,
    required this.surfaceMuted,
    // Texto hierárquico (régua neutral 01→05: fg/secondary/tertiary/muted/placeholder)
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.textPlaceholder,
    required this.textDisabled,
    // Bordas / divisores
    required this.border,
    required this.borderSubtle,
    required this.surfaceLoading,
    required this.primaryOnSurface,
    required this.primaryTrack,
    required this.divider,
    // Glass (tint da superfície glassy — muda com o modo)
    required this.glassTint,
    // Brand
    required this.primary,
    required this.onPrimary,
    required this.primaryHover,
    required this.primaryPressed,
    required this.primarySubtle,
    required this.onPrimarySubtle,
    required this.onSuccessSubtle,
    required this.onWarningSubtle,
    required this.onErrorSubtle,
    required this.onSecureSubtle,
    // Status — success / warning / error / secure (base + subtle bg)
    required this.success,
    required this.onSuccess,
    required this.successSubtle,
    required this.warning,
    required this.onWarning,
    required this.warningSubtle,
    required this.error,
    required this.onError,
    required this.errorSubtle,
    required this.secure,
    required this.onSecure,
    required this.secureSubtle,
    // Partner (cobranding — mode-agnóstico)
    required this.partner,
    required this.onPartner,
    required this.surfaceSubtle,
    required this.surfaceLoadingStrong,
    required this.surfaceInverse,
    required this.partnerSurface,
    required this.successBorder,
    required this.errorBorder,
    required this.warningBorder,
    required this.errorSolid,
    required this.onErrorSolid,
  });

  final Brightness brightness;
  final DilettaPalette palette;

  /// Common — fundo geral da tela.
  final Color bg;

  /// Common — fundo da barra de menu / navegação (glass base).
  final Color bgMenu;

  /// Common — texto/ícone de maior contraste sobre [bg].
  final Color fg;

  /// Fundo de card / sheet (elevado sobre [bg]).
  final Color surface;

  /// Conteúdo de maior contraste sobre [surface].
  final Color onSurface;

  /// Fundo sutil (chip neutro, campo desabilitado, wash).
  final Color surfaceMuted;

  final Color textSecondary, textTertiary, textMuted, textPlaceholder;

  /// Texto e glyph de controle DESABILITADO.
  ///
  /// Entrou porque a lista de app pintava `neutral06` cru pro estado desabilitado:
  /// o cinza de um filho não chegava lá, e no escuro o item desabilitado ficava
  /// mais claro que o habilitado. Desabilitado é papel, e todo design system tem.
  final Color textDisabled;
  final Color border, divider;

  /// Borda SUAVE — mais leve que a de card. Avatar, chip, divisor interno.
  ///
  /// Existe porque `border` (degrau 08) é o limite de um card, e havia componentes
  /// usando o 09 de propósito: um contorno que separa sem pesar. Sem papel, cada um
  /// cravava o degrau — e aí não reagia ao tema.
  final Color borderSubtle;

  /// Superfície de CARREGAMENTO (a placa do skeleton).
  ///
  /// Mais presente que [surfaceMuted]: placeholder de carregamento precisa ser
  /// VISTO, senão a tela parece vazia em vez de carregando.
  final Color surfaceLoading;

  /// Acento de marca como TEXTO sobre superfície normal.
  ///
  /// Diferente de [primary] (preenchimento) e de [onPrimarySubtle] (texto sobre o
  /// tinte). Este é o azul que se LÊ sobre o branco: precisa de contraste de corpo,
  /// não de elemento gráfico. O chrome do catálogo precisou dele por conta própria
  /// antes de existir aqui, e as iniciais do avatar também — dois pedidos
  /// independentes é papel faltando, não coincidência.
  final Color primaryOnSurface;

  /// TRILHO de progresso — fundo de barra ou anel de marca.
  ///
  /// Entre o tinte ([primarySubtle], quase branco) e o acento ([primary]): o trilho
  /// tem que se ver contra a superfície sem competir com o preenchimento.
  final Color primaryTrack;

  /// Tint da superfície glassy (nav, top bar, toast). Light = white@80;
  /// dark = tint escuro. Consumido por DilettaGlassSurface.
  final Color glassTint;

  final Color primary, onPrimary, primaryHover, primaryPressed;

  /// Fundo suave da marca (accent bg — ex: spot de ícone azul).
  final Color primarySubtle;

  /// Conteúdo sobre [primarySubtle].
  final Color onPrimarySubtle;

  /// Conteúdo sobre o preenchimento SUTIL de cada role.
  ///
  /// Existe porque um token não consegue servir duas exigências de contraste: a
  /// cor sólida do role precisa contrastar com `onColor` (branco/tinta), e o TEXTO
  /// sobre o tinte sutil precisa de 4.5:1 contra o tinte. Usar a mesma cor pros
  /// dois deixava tag de `warning` em 2.16:1 e de `secure` em 1.79:1 — texto
  /// amarelo em fundo amarelo, medido em 2026-07-28.
  ///
  /// O `primary` já tinha esse par (`onPrimarySubtle`); as outras famílias não. A
  /// escolha de cada passo é medida, não estética: ver `docs/ADR-003`.
  final Color onSuccessSubtle;
  final Color onWarningSubtle;
  final Color onErrorSubtle;
  final Color onSecureSubtle;

  final Color success, onSuccess, successSubtle;
  final Color warning, onWarning, warningSubtle;
  final Color error, onError, errorSubtle;
  final Color secure, onSecure, secureSubtle;

  /// Partner (cobranding) — cor do parceiro white-label. Mode-agnóstico.
  final Color partner, onPartner;

  /// Superfície um passo ACIMA da base — o cinza levíssimo de tooltip claro,
  /// placeholder de ilustração e fundo de toast neutro.
  ///
  /// Faltava, e por isso três componentes liam `neutral10` cru.
  final Color surfaceSubtle;

  /// Bloco de esqueleto com CONTRASTE dentro do esqueleto (a tarja magnética do
  /// cartão). `surfaceLoading` é o campo do esqueleto; este é a peça sobre ele.
  final Color surfaceLoadingStrong;

  /// Superfície INVERTIDA — escura no claro. Tooltip escuro, chip onDark.
  final Color surfaceInverse;

  /// Superfície do cartão do PARCEIRO no cobrand. Vem de `palette.partnerSurface`,
  /// que entrou na paleta junto deste papel.
  final Color partnerSurface;

  /// Borda de superfície de STATUS suave (o contorno do toast de cada estado).
  ///
  /// A rampa tem o degrau, mas não havia papel: os três toasts liam `success06`,
  /// `error06` e `warning06` crus.
  final Color successBorder, errorBorder, warningBorder;

  /// Banner de erro SÓLIDO e a tinta sobre ele.
  ///
  /// O papel absorve a troca de modo que o componente fazia à mão
  /// (`dark ? error03 : errorBanner`) — que é exatamente o trabalho do scheme.
  final Color errorSolid, onErrorSolid;


  // ═══════════════════════════════════════════════════════════════════════
  // LIGHT — resolve o palette pro uso atual do DS (paridade 1:1 com o legado)
  // ═══════════════════════════════════════════════════════════════════════
  factory DilettaScheme.light(DilettaPalette p) => DilettaScheme(
        brightness: Brightness.light,
        palette: p,
        bg: p.white,
        bgMenu: p.white,
        fg: p.neutral01,
        surface: p.white,
        onSurface: p.neutral01,
        surfaceMuted: p.neutral09,
        textSecondary: p.neutral02,
        textTertiary: p.neutral03,
        textMuted: p.neutral04,
        textPlaceholder: p.neutral05,
        textDisabled: p.neutral06,
        border: p.neutral08,
        borderSubtle: p.neutral09,
        surfaceLoading: p.neutral08,
        primaryOnSurface: p.primary03,
        primaryTrack: p.primary07,
        divider: p.neutral09,
        glassTint: p.tinteDeVidroClaro ?? p.white.withValues(alpha: 0.8),

        primary: p.primary04,
        onPrimary: p.onPrimary,
        primaryHover: p.primaryStateHover,
        primaryPressed: p.primaryStateSelected,
        primarySubtle: p.primary08,
        // DEGRAU 03, não 04. Mudou por evidência de DOIS filhos, que é o que promove.
        //
        // `primary04` é a cor de AÇÃO. Usá-la como texto sobre o wash amarrava a marca a um
        // requisito de contraste que não é dela: o Bold tem o rosa do logo em 04 e dava
        // 3.08:1, sem conserto possível do lado do filho — escurecer o 04 é trocar a marca, e
        // escurecer o 08 levaria o wash a quase preto.
        //
        // Medido nos três: Bold 3.08 → 4.80, Aurora 4.62 → 6.28, CPF SEGURO 7.14 → 10.01.
        // Ninguém piora, e a Aurora até desfez um escurecimento que tinha feito só por isso.
        onPrimarySubtle: p.primary03, // 10.01 sobre primary08 no CPF SEGURO
        // Medidos sobre o respectivo tinte: 03 resolve success (6.36) e error
        // (6.05); warning precisa do 02 (5.99, porque o 03 dá 4.32); e secure só
        // passa no 02 (7.08) — é a família mais clara, então 03/04 ficam em ~1.8.
        onSuccessSubtle: p.success03,
        onWarningSubtle: p.warning02,
        onErrorSubtle: p.error03,
        onSecureSubtle: p.secure02,
        success: p.success04,
        onSuccess: p.white,
        successSubtle: p.success07,
        warning: p.warning04,
        onWarning: p.white,
        warningSubtle: p.warning07,
        error: p.error04,
        onError: p.white,
        errorSubtle: p.error07,
        secure: p.secure04,
        onSecure: p.neutral01,
        secureSubtle: p.secure08,
        partner: p.partnerPrimary,
        onPartner: p.partnerOnPrimary,
        surfaceSubtle: p.neutral10,
        surfaceLoadingStrong: p.neutral06,
        surfaceInverse: p.neutral01,
        partnerSurface: p.partnerSurface,
        successBorder: p.success06,
        errorBorder: p.error06,
        warningBorder: p.warning06,
        errorSolid: p.errorBanner,
        onErrorSolid: p.error06,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // DARK — 1ª versão. Fundo = primary escuro, marca clareia (primary-06).
  // Afinar contra os valores Dark do Figma (variable defs) antes de shippar.
  // ═══════════════════════════════════════════════════════════════════════
  factory DilettaScheme.dark(DilettaPalette p) => DilettaScheme(
        brightness: Brightness.dark,
        palette: p,
        // Superfícies do escuro: DA PALETA, com a rampa neutra como default.
        //
        // Estavam cravadas em hex aqui (#0B1020 / #161C2E / #212A42 — o navy do primeiro filho), e
        // o segundo filho mediu o efeito: com a paleta dele plugada, o fundo do escuro saía navy.
        // Superfície dessaturada é decisão de MARCA (o navy do CPF, o wine-ink do Bold), então ela
        // desce pra paleta; quem não declara recebe a rampa neutra, que é neutra e serve.
        bg: p.bgEscuro ?? p.neutral01,
        bgMenu: p.surfaceEscura ?? p.neutral02,
        fg: p.neutral10,
        surface: p.surfaceEscura ?? p.neutral02,
        onSurface: p.neutral10,
        surfaceMuted: p.surfaceMutedEscura ?? p.neutral03,
        textSecondary: p.neutral07,
        textTertiary: p.neutral06,
        textMuted: p.neutral05,
        textPlaceholder: p.neutral05,
        textDisabled: p.neutral04,
        border: const Color(0x14FFFFFF), // white @ 8%
        borderSubtle: p.neutral02,
        surfaceLoading: p.neutral02,
        primaryOnSurface: p.primary06,
        primaryTrack: p.primary02,
        divider: const Color(0x14FFFFFF),
        // O tinte do vidro também é da marca: o do segundo filho é tingido de vinho, e com o
        // literal daqui saía neutro sem conserto possível do lado do filho.
        glassTint: p.tinteDeVidroEscuro ?? p.neutral01.withValues(alpha: 0.8),

        // primary-05 (vivo) em vez do primary-06 (lavado) — a marca precisa
        // pulsar no dark. onPrimary = branco (lê bem sobre o azul).
        primary: p.primary05,
        onPrimary: p.onPrimary,
        primaryHover: p.primary04,
        primaryPressed: p.primary03,
        primarySubtle: p.primary03,
        // No escuro o tinte é o passo 02/03 (escuro), então o texto vai pro lado
        // CLARO da rampa. primary06 dava 3.89 — abaixo de texto; o 07 dá 6.71.
        onPrimarySubtle: p.primary07,
        onSuccessSubtle: p.success06, // 9.13 (o 05 dava 4.97, no limite)
        onWarningSubtle: p.warning06, // 4.60 (o 05 dava 3.01)
        onErrorSubtle: p.error06, // 5.46 (o 05 dava 3.82)
        onSecureSubtle: p.secure07, // 6.93
        success: p.success05,
        onSuccess: p.success01,
        successSubtle: p.success02,
        warning: p.warning05,
        onWarning: p.warning01,
        warningSubtle: p.warning02,
        error: p.error05,
        onError: p.error01,
        errorSubtle: p.error02,
        secure: p.secure05,
        onSecure: p.secure03,
        secureSubtle: p.secure02,
        partner: p.partnerPrimary,
        onPartner: p.partnerOnPrimary,
        surfaceSubtle: p.neutral02,
        surfaceLoadingStrong: p.neutral04,
        // Tooltip escuro mantém 1:1 nos dois modos, então o invertido não inverte.
        surfaceInverse: p.neutral01,
        partnerSurface: p.partnerSurface,
        successBorder: p.success04,
        errorBorder: p.error04,
        warningBorder: p.warning04,
        errorSolid: p.error03,
        onErrorSolid: p.error06,
      );

  bool get isDark => brightness == Brightness.dark;
}
