/// O `ThemeData` do Flutter de um produto deste DS, e ele veio do app em 19/08.
///
/// ## Por que um DS entrega o tema do Material
///
/// Enquanto ele morava no app, **o app decidia nove superfícies do Material** — a escada de tipo do
/// `textTheme`, o fundo do scaffold, o divisor, o ícone, o card, a folha, o campo, o botão de texto
/// e a transição de página. Todas são decisão de DS, e nenhuma delas é decisão de aplicação.
///
/// O sintoma que provou isso não foi arquitetural, foi visível: até 19/08 o `MaterialApp` era
/// servido pela camada legada, que pedia **Nunito**, enquanto os 644 sítios que leem um degrau da
/// escada saíam em **Inter**. Duas fontes na mesma tela, e o que decidia qual era o arquivo que
/// ninguém considerava DS.
///
/// ## O que ele NÃO configura, e isso é medido
///
/// O tema legado configurava treze peças do Material. Vieram **nove**. As que ficaram de fora —
/// `appBarTheme`, `bottomNavigationBarTheme`, `elevatedButtonTheme`, `outlinedButtonTheme`,
/// `chipTheme`, `dialogTheme`, `snackBarTheme` — têm **zero consumidores** no app: ele instancia um
/// `TextButton` e um `Dialog` do Material, e mais nada. Tema é declaração, e **declaração sem
/// consumidor envelhece igual token sem call site**.
///
/// ## O par com [CoreflowTheme]
///
/// [CoreflowTheme] devolve o `DilettaTheme` — o esquema que as peças do pai leem pelo
/// `DilettaThemeScope`. Este devolve o `ThemeData` — o que o Material lê. **Os dois saem da mesma
/// paleta**, e o app monta os dois do mesmo brilho, então não existem dois modos ao mesmo tempo.
library;

import 'bold_radius.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:diletta_design_system/diletta_design_system.dart';

import 'bold_scheme.dart';

/// O `ThemeData` de um produto deste DS, montado do esquema e da tipografia dele.
///
/// ```dart
/// final meu = CoreflowProduto(paleta: minhaPaleta, marca: minhaMarca, tipografia: minhaTipografia);
/// MaterialApp(theme: meu.materialClaro, darkTheme: meu.materialEscuro, themeMode: seuModo)
/// ```
///
/// Até 08/09 esta classe tinha `claro`/`escuro` que montavam o tema do primeiro produto — atalho de
/// marca com nome de linguagem, e o veredito do pai os tirou daqui (decisão 1, opção B).
/// A TIPOGRAFIA de um produto — os degraus que o `ThemeData` recebe, e a família, uma vez.
///
/// Veredito de 08/09 (`docs/pedidos/2026-09-04-…`): *família é do app, uma vez* — a `DilettaBrand`
/// não ganha campo, e o canal já existia: o `ThemeData` que [CoreflowTemaMaterial] monta. O que
/// faltava era a família ter UMA fonte em vez de duas: ela viaja aqui, é aplicada em
/// `ThemeData(fontFamily:)`, e o `textTheme` inteiro a herda. Os degraus de escala também são
/// declaração de produto — *o pai entrega o mecanismo e o GATE; o filho declara os passos* (ADR-005
/// do avô) —, então este objeto é o que um produto declara e [doAvo] é o que quem não declara recebe:
/// a escala do avô, sem família (herda a do app).
class CoreflowTipografia {
  const CoreflowTipografia({
    this.familia,
    required this.displayLarge,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.titleLarge,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.labelLarge,
    required this.labelSmall,
    required this.botaoDeTexto,
    required this.dica,
    required this.rotuloDeCampo,
  });

  /// A escala do avô, degrau a degrau, e nenhuma família: quem não declara herda a do app.
  static const CoreflowTipografia doAvo = CoreflowTipografia(
    displayLarge: DilettaType.displaySm,
    headlineLarge: DilettaType.headlineLg,
    headlineMedium: DilettaType.headlineMd,
    titleLarge: DilettaType.titleLg,
    bodyLarge: DilettaType.bodyLg,
    bodyMedium: DilettaType.bodyMd,
    labelLarge: DilettaType.labelLg,
    labelSmall: DilettaType.labelSm,
    botaoDeTexto: DilettaType.labelLg,
    dica: DilettaType.bodyMd,
    rotuloDeCampo: DilettaType.bodySm,
  );

  /// A família tipográfica do produto, QUALIFICADA (`packages/<pacote>/<Família>`). `null` herda a
  /// do app — que é o que o avô faz com a dele.
  final String? familia;

  /// Os oito slots do `textTheme` que este DS declara. Sem cor: a cor vem do esquema, na montagem.
  final TextStyle displayLarge, headlineLarge, headlineMedium, titleLarge;
  final TextStyle bodyLarge, bodyMedium, labelLarge, labelSmall;

  /// Os três estilos fora do `textTheme`: o rótulo do `TextButton`, a dica e o rótulo do campo.
  final TextStyle botaoDeTexto, dica, rotuloDeCampo;

  /// A mesma escala com outra família — o caso do filho que herda os degraus do avô e declara só a
  /// fonte: `CoreflowTipografia.doAvo.copyWith(familia: 'packages/meu_produto/MinhaFonte')`.
  CoreflowTipografia copyWith({String? familia}) => CoreflowTipografia(
        familia: familia ?? this.familia,
        displayLarge: displayLarge,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
        labelSmall: labelSmall,
        botaoDeTexto: botaoDeTexto,
        dica: dica,
        rotuloDeCampo: rotuloDeCampo,
      );

  /// Um estilo com a família do produto aplicada — pros três sítios que o `ThemeData` não alcança
  /// sozinho (o `apply(fontFamily:)` do Material só cobre o `textTheme`).
  TextStyle comFamilia(TextStyle s) => familia == null ? s : s.copyWith(fontFamily: familia);
}

abstract final class CoreflowTemaMaterial {
  const CoreflowTemaMaterial._();


  /// O `ThemeData` de QUALQUER esquema deste DS — a porta pra um produto que não é o primeiro.
  ///
  /// Era `_monta`, privado, e a privacidade era o bloqueio: [CoreflowScheme.de] aceita paleta desde a
  /// v0.55.0 e não havia nada acima dele que aceitasse. Um produto novo montava o esquema com a
  /// paleta dele e **não conseguia registrá-lo como `ThemeExtension`** — que é de onde os ~500
  /// `CoreflowScheme.of(context)` leem. Quem monta produto passa por [CoreflowProduto], que chama isto.
  static ThemeData de(CoreflowScheme s, {CoreflowTipografia tipografia = CoreflowTipografia.doAvo}) {
    final t = tipografia;
    final cores = ColorScheme(
      brightness: s.brightness,
      // O rosa da MARCA, lido da paleta que veio — e não o `s.primary`, que no claro é o degrau
      // profundo (escolhido pra passar AA com tinta branca). São dois valores com o mesmo nome, e
      // o Material quer o da marca. Era a const congelada do primeiro produto: um produto novo
      // recebia a cor daquele no `colorScheme` inteiro depois de declarar a paleta dele.
      primary: s.paleta.primary04,
      // Os três `on*` saem do PAPEL e não do branco cru. O valor é o mesmo nos dois modos hoje
      // (medido: `#FFFFFF` dos dois lados); a diferença é de quem é a decisão.
      onPrimary: s.onPrimary,
      secondary: s.paleta.primary04,
      onSecondary: s.onPrimary,
      surface: s.surface,
      onSurface: s.textPrimary,
      // Semântico e invariante por regra do pai — e mesmo assim lido da paleta que veio, porque
      // invariante por regra e congelado por leitor são coisas diferentes.
      error: s.paleta.error04,
      onError: DilettaAbsoluteColors.white,
    );

    // A ESCADA é do produto (`tipografia`), a COR é do esquema. A família entra uma vez, em
    // `ThemeData(fontFamily:)`, e o Material a aplica em todo o `textTheme`.
    final escada = TextTheme(
      displayLarge: t.displayLarge.copyWith(color: s.textPrimary),
      headlineLarge: t.headlineLarge.copyWith(color: s.textPrimary),
      headlineMedium: t.headlineMedium.copyWith(color: s.textPrimary),
      titleLarge: t.titleLarge.copyWith(color: s.textPrimary),
      bodyLarge: t.bodyLarge.copyWith(color: s.textPrimary),
      // O DEFAULT do `Text` sem estilo, e ele já esteve SECUNDÁRIO. Texto sem estilo é o corpo da
      // tela — quem quer metadado pede metadado.
      bodyMedium: t.bodyMedium.copyWith(color: s.textPrimary),
      labelLarge: t.labelLarge.copyWith(color: s.textPrimary),
      labelSmall: t.labelSmall.copyWith(color: s.textSecondary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: s.brightness,
      colorScheme: cores,
      scaffoldBackgroundColor: s.background,
      canvasColor: s.background,
      fontFamily: t.familia,
      textTheme: escada,
      splashFactory: InkRipple.splashFactory,
      // App primeiro: toque não tem hover. Mata o realce de hover no app inteiro (o ripple do toque
      // fica). Na web e no desktop isto também serve; volte atrás se um dia existir um produto
      // guiado por hover em cima deste DS.
      hoverColor: DilettaAbsoluteColors.transparent,
      // **A linha que trancava a porta.** É esta extensão que faz `CoreflowScheme.of(context)`
      // responder, e enquanto o esquema morava no app, o tema tinha que morar lá junto.
      extensions: [s],
      dividerTheme: DividerThemeData(color: s.border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: s.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: CoreflowRadius.cardR),
      ),
      iconTheme: IconThemeData(color: s.textSecondary, size: 22),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: s.paleta.primary04,
          textStyle: t.comFamilia(t.botaoDeTexto),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.surface,
        shape: const RoundedRectangleBorder(borderRadius: CoreflowRadius.sheetR),
        // Desligado de propósito: cada folha deste produto desenha o próprio grip. Com o handle do
        // tema ligado apareciam DUAS barrinhas.
        showDragHandle: false,
      ),
      // Transição Cupertino nas três plataformas — decisão do produto. Sem esta linha o Android
      // volta pro fade-upwards do Material.
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.field,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: t.comFamilia(t.dica).copyWith(color: s.textMuted),
        labelStyle: t.comFamilia(t.rotuloDeCampo).copyWith(color: s.textSecondary),
        border: const OutlineInputBorder(
            borderRadius: CoreflowRadius.fieldR, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(
            borderRadius: CoreflowRadius.fieldR, borderSide: BorderSide.none),
        // Deixou de ser `const` porque a cor deixou de ser congelada. É a única diferença.
        focusedBorder: OutlineInputBorder(
          borderRadius: CoreflowRadius.fieldR,
          borderSide: BorderSide(color: s.paleta.primary04, width: 1.5),
        ),
      ),
    );
  }
}
