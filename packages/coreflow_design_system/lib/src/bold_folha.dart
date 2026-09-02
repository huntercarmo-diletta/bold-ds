import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAbsoluteColors, DilettaIconButton, DilettaIconButtonSize, DilettaIconButtonType;
import 'package:flutter/material.dart';
// `bold_background` vem da development (o sheet com papel de parede do app). O
// `bold_icon_button` NÃO volta: o botão de ícone é peça do pai desde a v0.13.0 do
// pacote, e o fechar abaixo monta com `DilettaIconButton`.
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_background.dart' show CoreflowBackground;
import 'bold_espaco.dart' show CoreflowEspaco;
import 'bold_radius.dart' show CoreflowRadius;
import 'bold_scheme.dart' show CoreflowScheme;
import 'bold_type.dart' show CoreflowType;

/// Conta BOLD — BottomSheet (organismo). O CONTAINER de sheet que faltava:
/// o [CoreflowBarraDeTopo.sheet] só dava o cabeçalho e o [BoldDialog] é modal central.
///
/// Painel ancorado no rodapé, cantos superiores arredondados, com grip iOS +
/// título/fechar opcionais + conteúdo. Sobe do rodapé sobre um scrim escuro.
///
/// Use direto como widget (dentro de um Stack/overlay próprio) ou via o helper
/// imperativo [CoreflowFolha.show], que embrulha `showModalBottomSheet` com a
/// aparência do DS e devolve o valor do `Navigator.pop`.
///
/// ```dart
/// final ok = await CoreflowFolha.show<bool>(
///   context,
///   title: 'Escolha uma conta',
///   builder: (ctx) => Column(children: [...]),
/// );
/// ```
/// Espaço que um bottom sheet precisa reservar no rodapé: teclado **ou** barra
/// de navegação do sistema.
///
/// Substitui o `MediaQuery.of(context).viewInsets.bottom` usado solto nos sheets
/// que não passam pelo [CoreflowFolha]: no Android 15 o edge-to-edge é obrigatório e
/// a barra de navegação fica SOBRE o sheet, cobrindo botões e o último item da
/// lista.
///
/// Os dois nunca somam de fato — com o teclado aberto o `padding.bottom` já vem
/// 0 (o `MediaQuery` desconta os `viewInsets`) —, então dá para trocar um pelo
/// outro sem risco de contar a barra duas vezes.
double boldSheetBottomInset(BuildContext context) {
  final mq = MediaQuery.of(context);
  return mq.viewInsets.bottom + mq.padding.bottom;
}

/// O TECLADO empurra a SUPERFÍCIE; a área segura padeia o CONTEÚDO. São dois insets, não um.
///
/// Chegou olhando o login no iPhone: *"o bottom sheet de senha está acima do home indicator padrão"*. A
/// folha flutuava 34px do fundo, com o scrim aparecendo embaixo dela — porque o mesmo
/// [boldSheetBottomInset] (teclado + área segura) estava aplicado FORA do container da superfície.
///
/// A regra que separa os dois:
///
/// - **teclado** (`viewInsets.bottom`) tem que mover a superfície inteira, senão o campo em foco fica
///   coberto;
/// - **home indicator** (`padding.bottom`) NÃO move a superfície: ela vai até a borda da tela, e quem
///   recua é o conteúdo de dentro. Folha que para antes da borda deixa uma faixa de scrim que lê como
///   defeito de layout — e é.
double boldSheetTecladoInset(BuildContext context) => MediaQuery.of(context).viewInsets.bottom;

/// O recuo do conteúdo pra não encostar no traço do sistema. Vai DENTRO do container da folha.
double boldSheetRodapeSeguro(BuildContext context) => MediaQuery.of(context).padding.bottom;

class CoreflowFolha extends StatelessWidget {
  const CoreflowFolha({
    super.key,
    this.title,
    this.onClose,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(CoreflowEspaco.gutter, DilettaSpacing.s1, CoreflowEspaco.gutter, DilettaSpacing.s5),
    this.centerTitle = false,
    this.fundoDoApp = false,
    this.fecharEmCirculo = false,
  });

  final String? title;
  final VoidCallback? onClose;
  final Widget child;
  final EdgeInsets padding;

  /// Título centralizado no sheet (e um degrau menor), com o fechar solto à
  /// direita. Padrão é `false` — o alinhamento à esquerda continua sendo o do
  /// DS; só as telas cujo Figma pede o título centrado ligam isto.
  final bool centerTitle;

  /// Painel com o MESMO fundo das telas do app — inclusive o papel de parede
  /// que a pessoa escolheu em Aparência ([CoreflowBackground] resolvendo o
  /// [CoreflowBackdropScope]), em vez da `surface` chapada do DS.
  ///
  /// Padrão `false`: o sheet do DS é uma superfície elevada, e é assim que os
  /// outros continuam.
  final bool fundoDoApp;

  /// Fechar como botão redondo com anel de 1px (`secondary` do DS) em vez do
  /// X solto (`tertiary`). É o mesmo desenho dos botões circulares da Letti —
  /// sobre o papel de parede, o X sem contorno fica solto na tela.
  final bool fecharEmCirculo;

  /// Abre o sheet via `showModalBottomSheet` com o estilo do DS.
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required WidgetBuilder builder,
    bool dismissible = true,
    bool useRootNavigator = false,
    EdgeInsets? padding,
    bool centerTitle = false,
    bool fundoDoApp = false,
    bool fecharEmCirculo = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      // O grip é do próprio CoreflowFolha — desliga o handle do Material pra não
      // duplicar (o tema global pode ligá-lo).
      showDragHandle: false,
      useRootNavigator: useRootNavigator,
      backgroundColor: DilettaAbsoluteColors.transparent,
      barrierColor: DilettaAbsoluteColors.blackAlpha40,
      isDismissible: dismissible,
      builder: (ctx) => CoreflowFolha(
        title: title,
        onClose: dismissible ? () => Navigator.of(ctx).maybePop() : null,
        padding: padding ?? const EdgeInsets.fromLTRB(CoreflowEspaco.gutter, DilettaSpacing.s1, CoreflowEspaco.gutter, DilettaSpacing.s5),
        centerTitle: centerTitle,
        fundoDoApp: fundoDoApp,
        fecharEmCirculo: fecharEmCirculo,
        child: builder(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    final mq = MediaQuery.of(context);
    // Android 15 (edge-to-edge obrigatório) desenha a barra de navegação SOBRE
    // o sheet: o `useSafeArea: true` do `showModalBottomSheet` embrulha em
    // `SafeArea(bottom: false)` — protege só o topo. Compensamos aqui.
    //
    // Usa `padding.bottom` (e NÃO `viewPadding.bottom`) de propósito: com o
    // teclado aberto o `padding` já vem 0 e o espaço quem dá é o `viewInsets`
    // abaixo — com `viewPadding` a barra contaria duas vezes.
    final safeBottom = mq.padding.bottom;
    // O `fecharEmCirculo` é da development e o BOTÃO é do pai: `secondary` desenha
    // o círculo, `tertiary` é o glifo solto. O nome do glifo muda com o dono —
    // `close` era o do app, `xmark-light` é o do vocabulário do pai.
    final fechar = onClose == null
        ? null
        : DilettaIconButton(
            icon: 'xmark-light',
            semanticLabel: 'Fechar',
            type: fecharEmCirculo
                ? DilettaIconButtonType.secondary
                : DilettaIconButtonType.tertiary,
            size: DilettaIconButtonSize.sm,
            onPressed: onClose,
          );
    final conteudo = Padding(
      // Empurra o conteúdo acima do teclado quando aberto.
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grip iOS.
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            decoration: BoxDecoration(
              color: c.textMuted.withValues(alpha: 0.5),
              borderRadius: CoreflowRadius.pillR,
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(DilettaSpacing.s5, DilettaSpacing.s2, DilettaSpacing.s3, DilettaSpacing.s1),
              // Centralizado: o título fica no meio do SHEET (e não do espaço
              // que sobra do botão fechar), por isso um Stack e não um Row.
              child: centerTitle
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          // Reserva o lugar do fechar dos dois lados para o
                          // título longo não passar por baixo dele.
                          padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s10),
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: CoreflowType.titleMd
                                .copyWith(color: c.textPrimary),
                          ),
                        ),
                        if (fechar != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: fechar,
                          ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(title!,
                              style: CoreflowType.headlineSm
                                  .copyWith(color: c.textPrimary)),
                        ),
                        if (fechar != null) fechar,
                      ],
                    ),
            ),
          // SingleChildScrollView dentro do Flexible: o sheet ENCOLHE pro
          // tamanho do conteúdo (não estica até o topo) e rola só quando o
          // conteúdo passa da altura disponível.
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    padding.copyWith(bottom: padding.bottom + safeBottom),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        // Light = primary08 (#FFEDF3): o branco puro (c.surface) ficava claro
        // demais e sem separação do fundo. Dark segue c.surface.
        // Com [fundoDoApp] quem pinta é o CoreflowBackground abaixo.
        color: fundoDoApp
            ? null
            // O CLARO usa o wash de MARCA, e ele sai da paleta e não da rampa do Bold: uma folha
            // de outro produto tinge com o rosa dele, não com o nosso. O gate deste pacote pegou
            // a const aqui na mudança de casa, pela mesma razão que pegou a etiqueta.
            : (c.isDark ? c.surface : c.paleta.primary08),
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(CoreflowRadius.sheet)),
        border: Border.all(color: c.border, width: 1),
      ),
      // O papel de parede tem que respeitar os cantos arredondados do painel.
      clipBehavior: fundoDoApp ? Clip.antiAlias : Clip.none,
      child: fundoDoApp ? CoreflowBackground(child: conteudo) : conteudo,
    );
  }
}
