import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_cobrand_mark.dart';
import 'cpf_seguro_glass_surface.dart';
import 'cpf_seguro_navigation_top_bar.dart';
import 'cpf_seguro_status_bar.dart';
import 'cpf_seguro_stepper.dart';

export 'cpf_seguro_navigation_top_bar.dart';
export 'cpf_seguro_stepper.dart';

/// CPF SEGURO — TopAppBar (organismo unificado).
///
/// Único ponto de entrada pro slot superior da tela. Cada variante é uma
/// **factory nomeada** que compõe [DilettaStatusBar] +
/// [DilettaNavigationTopBar] (+ [DilettaStepper] opcional) numa
/// [DilettaGlassSurface] — ou, no `.bottomsheet()`, num container branco
/// opaco com grip no topo.
///
/// **Filosofia atomic**:
/// - Átomo: [DilettaStatusBar]
/// - Moléculas: [DilettaNavigationTopBar] (com [DilettaNavigationLeftAccessory]
///   e [DilettaNavigationRightAccessory] como accessories), [DilettaStepper]
/// - Organismo: este widget
///
/// Variantes:
/// - `.defaultVariant(navBar:)`  → glass (StatusBar + NavigationTopBar)
/// - `.stepper(navBar:, stepper:)` → glass (StatusBar + NavigationTopBar + Stepper)
/// - `.cobrand(navBar:, partnerName:)` → glass + a CO-MARCA pequena, centralizada no fim da barra
/// - `.bottomsheet(navBar:)`     → container branco (grip + NavigationTopBar)
class DilettaTopAppBar extends StatelessWidget {
  final _TopAppBarVariant variant;

  /// Default = StatusBar + NavigationTopBar em glass.
  DilettaTopAppBar.defaultVariant({
    super.key,
    required DilettaNavigationTopBar navBar,
  }) : variant = _DefaultVariant(navBar);

  /// Stepper = StatusBar + NavigationTopBar + Stepper em glass.
  DilettaTopAppBar.stepper({
    super.key,
    required DilettaNavigationTopBar navBar,
    required DilettaStepper stepper,
  }) : variant = _StepperVariant(navBar, stepper);

  /// Cobrand = StatusBar + NavigationTopBar + a CO-MARCA pequena, centralizada, DENTRO da barra.
  ///
  /// Existe porque a co-marca estava trocando de lugar entre as telas: no stepper ela é o rótulo à
  /// esquerda; nas telas sem stepper ela era um bloco solto no começo do content — e aí a posição
  /// dependia de quanto conteúdo vinha antes. Marca que muda de lugar a cada tela lê como descuido,
  /// e é justamente a informação que precisa ser constante: quem protege esta jornada.
  ///
  /// O tamanho é o do stepper (logo 36 / texto 11): a co-marca é assinatura, não título.
  DilettaTopAppBar.cobrand({
    super.key,
    required DilettaNavigationTopBar navBar,
    required String partnerName,
  }) : variant = _CobrandVariant(navBar, partnerName);

  /// Bottomsheet = grip (traço) + NavigationTopBar em container branco opaco.
  /// **Sem StatusBar** (é uma superfície interna, não a barra do sistema) e
  /// **sem glass** (o sheet já é sólido branco atrás).
  DilettaTopAppBar.bottomsheet({
    super.key,
    required DilettaNavigationTopBar navBar,
  }) : variant = _BottomsheetVariant(navBar);

  /// App real = glass + **inset REAL da status bar** (SafeArea) + NavigationTopBar.
  /// Diferente do `.defaultVariant`, NÃO desenha a [DilettaStatusBar] mock
  /// (9:41) — no app a status bar do sistema é a de verdade. Use como
  /// `flexibleSpace`/conteúdo do topo com `extendBodyBehindAppBar: true`.
  DilettaTopAppBar.app({
    super.key,
    required DilettaNavigationTopBar navBar,
  }) : variant = _AppVariant(navBar);

  /// Plain = glass + NavigationTopBar, **SEM status bar e SEM SafeArea**.
  /// Pra usar como `appBar:` normal de um [Scaffold] (que já insere a barra
  /// abaixo da status bar do sistema) — mantém o glass (gramática do DS) sem
  /// duplicar o inset. É a versão "sem status bar" das variantes de topo.
  DilettaTopAppBar.plain({
    super.key,
    required DilettaNavigationTopBar navBar,
  }) : variant = _PlainVariant(navBar);

  @override
  Widget build(BuildContext context) => variant.build(context);
}

// ═══════════════════════════════════════════════════════════════════════════
// Variantes
// ═══════════════════════════════════════════════════════════════════════════

sealed class _TopAppBarVariant {
  const _TopAppBarVariant();
  Widget build(BuildContext context);
}

class _DefaultVariant extends _TopAppBarVariant {
  const _DefaultVariant(this.navBar);
  final DilettaNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) => DilettaGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DilettaStatusBar(),
            navBar,
          ],
        ),
      );
}

class _StepperVariant extends _TopAppBarVariant {
  const _StepperVariant(this.navBar, this.stepper);
  final DilettaNavigationTopBar navBar;
  final DilettaStepper stepper;

  @override
  Widget build(BuildContext context) => DilettaGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DilettaStatusBar(),
            navBar,
            stepper,
            const SizedBox(height: 8),
          ],
        ),
      );
}

class _CobrandVariant extends _TopAppBarVariant {
  const _CobrandVariant(this.navBar, this.partnerName);
  final DilettaNavigationTopBar navBar;
  final String partnerName;

  @override
  Widget build(BuildContext context) => DilettaGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DilettaStatusBar(),
            navBar,
            // Centralizada e no FIM da barra: é o último elemento antes do content, então a marca
            // fica no mesmo lugar em todas as telas — independente do que a tela tem dentro.
            Padding(
              padding: const EdgeInsets.only(bottom: DilettaSpacing.s3),
              child: Center(
                child: DilettaCobrandMark(
                  partnerName: partnerName,
                  logoSize: 36,
                  textSize: 11,
                ),
              ),
            ),
          ],
        ),
      );
}

class _AppVariant extends _TopAppBarVariant {
  const _AppVariant(this.navBar);
  final DilettaNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) => DilettaGlassSurface(
        child: SafeArea(
          bottom: false,
          child: navBar,
        ),
      );
}

class _PlainVariant extends _TopAppBarVariant {
  const _PlainVariant(this.navBar);
  final DilettaNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) => DilettaGlassSurface(child: navBar);
}

class _BottomsheetVariant extends _TopAppBarVariant {
  const _BottomsheetVariant(this.navBar);
  final DilettaNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: s.surface,
        borderRadius: const BorderRadius.only(
          topLeft: DilettaRadius.r24,
          topRight: DilettaRadius.r24,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Center(
              child: Container(
                width: 75,
                height: 5,
                decoration: BoxDecoration(
                  color: s.fg,
                  borderRadius: DilettaRadius.pillAll,
                ),
              ),
            ),
          ),
          navBar,
        ],
      ),
    );
  }
}
