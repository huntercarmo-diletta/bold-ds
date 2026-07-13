import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_glass_surface.dart';
import 'bold_icon.dart';
import 'bold_nav_top_bar.dart';
import 'bold_skeleton.dart';
import 'bold_stepper.dart';

export 'bold_nav_top_bar.dart';
export 'bold_stepper.dart';

/// Conta BOLD — TopBar (organismo unificado). Único ponto de entrada pro slot
/// superior da tela: compõe [BoldNavTopBar] (molécula) numa [BoldGlassSurface]
/// (átomo), com [BoldStepper] opcional — ou, no `.sheet()`, num container
/// branco com grip (cabeçalho de bottom sheet).
///
/// **Filosofia atomic** — Átomo: [BoldGlassSurface] · Moléculas:
/// [BoldNavTopBar] (+ acessórios sealed), [BoldStepper] · Organismo: este.
///
/// Variantes:
/// - `BoldTopBar(...)`           → slots crus (leading/title/trailing), glass
/// - `.page(title, onBack)`      → back + título centrado (+ ação opcional)
/// - `.home(firstName, icons)`   → "Olá, {nome}!" + ícones à direita
/// - `.stepper(title, current…)` → page + linha de progresso de fluxo
/// - `.sheet(title, onClose)`    → cabeçalho de bottom sheet (grip + close)
///
/// ```dart
/// BoldTopBar.page(title: 'Menu completo', onBack: pop);
/// BoldTopBar.home(firstName: 'Ana', icons: [
///   BoldNavRightIcon(icon: 'bell', semanticLabel: 'Notificações', badge: true),
/// ]);
/// BoldTopBar.stepper(title: 'Abrir conta', onBack: pop, current: 2, total: 4);
/// ```
class BoldTopBar extends StatelessWidget {
  /// Slots crus — compat com a API anterior (leading/title/trailing).
  const BoldTopBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.centerTitle = true,
  })  : _navBar = null,
        _stepper = null,
        _custom = null,
        _sheet = false,
        _safeArea = true,
        _onClose = null;

  const BoldTopBar._({
    super.key,
    BoldNavTopBar? navBar,
    BoldStepper? stepper,
    Widget? custom,
    bool sheet = false,
    bool safeArea = true,
    VoidCallback? onClose,
    this.title,
  })  : leading = null,
        trailing = null,
        centerTitle = true,
        _navBar = navBar,
        _stepper = stepper,
        _custom = custom,
        _sheet = sheet,
        _safeArea = safeArea,
        _onClose = onClose;

  /// Back + título centrado + ação opcional à direita.
  factory BoldTopBar.page({
    Key? key,
    required String title,
    VoidCallback? onBack,
    BoldNavRightAccessory? action,
  }) =>
      BoldTopBar._(
        key: key,
        navBar: BoldNavTopBar(
          left: BoldNavLeftAccessory.back(onPressed: onBack),
          title: title,
          right: action,
        ),
      );

  /// Header da home (Redesenho v.01) — DUAS linhas:
  /// 1. botão de conta (🐷 + nº + ▾) + ícones tertiary à direita;
  /// 2. avatar (stroke primary + mini-avatar) + "Olá, {nome}!".
  ///
  /// [accountLoading] mostra shimmer no lugar do nº enquanto a conta carrega.
  factory BoldTopBar.home({
    Key? key,
    required String firstName,
    VoidCallback? onOpenProfile,
    String? accountLabel,
    bool accountLoading = false,
    VoidCallback? onSwitchAccount,
    List<BoldNavRightIcon> icons = const [],
    bool safeArea = true,
  }) =>
      BoldTopBar._(
        key: key,
        safeArea: safeArea,
        custom: _HomeHeader(
          firstName: firstName,
          onOpenProfile: onOpenProfile,
          accountLabel: accountLabel ?? '',
          accountLoading: accountLoading,
          onSwitchAccount: onSwitchAccount,
          icons: icons,
        ),
      );

  /// Page + linha de progresso de fluxo (multi-etapa).
  factory BoldTopBar.stepper({
    Key? key,
    required String title,
    VoidCallback? onBack,
    required int current,
    required int total,
    String? stepLabel,
  }) =>
      BoldTopBar._(
        key: key,
        navBar: BoldNavTopBar(
          left: BoldNavLeftAccessory.back(onPressed: onBack),
          title: title,
        ),
        stepper: BoldStepper(
            current: current, total: total, labelText: stepLabel ?? title),
      );

  /// Cabeçalho de bottom sheet: grip + título + close, container branco opaco
  /// (sem glass — o sheet já é sólido atrás).
  factory BoldTopBar.sheet({
    Key? key,
    required String title,
    VoidCallback? onClose,
  }) =>
      BoldTopBar._(key: key, title: title, sheet: true, onClose: onClose);

  // — API crua (compat) —
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final bool centerTitle;

  // — composição interna —
  final BoldNavTopBar? _navBar;
  final Widget? _custom;
  final BoldStepper? _stepper;
  final bool _safeArea;
  final bool _sheet;
  final VoidCallback? _onClose;

  @override
  Widget build(BuildContext context) {
    if (_sheet) return _buildSheet(context);

    // Header da home (Redesenho v.01): SEM glass/fill/stroke — só o conteúdo
    // sobre o fundo (a imagem já tem o scrim preto 50%). Safe-area no topo.
    if (_custom != null) {
      return Padding(
        padding: EdgeInsets.only(
            top: _safeArea ? MediaQuery.of(context).padding.top : 0,
            bottom: BoldSpace.x4),
        child: _custom,
      );
    }

    final bar = _navBar ?? _rawBar(context);
    // Local pra permitir promotion do nullable (campo de instância não promove).
    final stepper = _stepper;
    final column = stepper == null
        ? bar
        : Column(mainAxisSize: MainAxisSize.min, children: [
            bar,
            stepper,
          ]);
    // O slot superior é status bar + nav NUM só vidro: o glass se estende por
    // baixo da status bar do sistema (safe-area top entra DENTRO da surface),
    // com respiro inferior pra nada colar na borda do vidro.
    return BoldGlassSurface(
      child: Padding(
        // Safe-area do notch + respiro (senão o back/título colam na borda).
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + BoldSpace.x2,
            bottom: BoldSpace.x4),
        child: column,
      ),
    );
  }

  // Compat: monta a linha a partir dos slots crus (leading/title/trailing).
  Widget _rawBar(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        SizedBox(
            width: 40,
            child: Align(alignment: Alignment.centerLeft, child: leading)),
        const SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
            child: title == null
                ? null
                : Text(title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                    style: BoldType.title
                        .copyWith(fontSize: 17, color: c.textPrimary)),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
            width: 40,
            child: Align(alignment: Alignment.centerRight, child: trailing)),
      ]),
    );
  }

  Widget _buildSheet(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      decoration: BoxDecoration(
        // Superfície do tema (dark no dark) — branco fixo criava faixa branca
        // no topo do sheet com o título (texto branco) invisível.
        color: c.surface,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(BoldRadius.sheet),
            topRight: Radius.circular(BoldRadius.sheet)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: 24,
          child: Center(
            child: Container(
              width: 64,
              height: 5,
              decoration: BoxDecoration(
                  color: c.border, borderRadius: BoldRadius.pillR),
            ),
          ),
        ),
        BoldNavTopBar(
          left: BoldNavLeftAccessory.close(onPressed: _onClose),
          title: title,
        ),
      ]),
    );
  }
}

/// Header da home (2 linhas) — spec Redesenho v.01.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.firstName,
    required this.accountLabel,
    this.accountLoading = false,
    this.onOpenProfile,
    this.onSwitchAccount,
    this.icons = const [],
  });

  final String firstName;
  final String accountLabel;
  final bool accountLoading;
  final VoidCallback? onOpenProfile;
  final VoidCallback? onSwitchAccount;
  final List<BoldNavRightIcon> icons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _AccountButton(
                label: accountLabel,
                loading: accountLoading,
                onTap: onSwitchAccount),
            const Spacer(),
            if (icons.isNotEmpty) BoldNavRightAccessory.icons(icons: icons),
          ]),
          const SizedBox(height: BoldSpace.x4),
          BoldNavLeftAccessory.home(
              firstName: firstName, onOpenProfile: onOpenProfile),
        ],
      ),
    );
  }
}

/// Botão de troca de conta da home: pill outline branco com 🐷 (16) + número
/// da conta (ou shimmer se [loading]) + chevron. Sem a palavra "Conta".
class _AccountButton extends StatelessWidget {
  const _AccountButton({required this.label, this.loading = false, this.onTap});

  final String label;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ink = BoldColors.of(context).textPrimary; // branco no dark, neutral-01 no light
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: ink, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          BoldIcon('piggy-bank-light', size: 16, color: ink),
          const SizedBox(width: 6),
          if (loading)
            const BoldSkeleton(width: 58, height: 11, radius: 6)
          else
            Text(label, style: BoldType.labelMd.copyWith(color: ink)),
          // Chevron só quando há troca de conta (senão é rótulo estático).
          if (onTap != null) ...[
            const SizedBox(width: 6),
            BoldIcon('chevron-down', size: 12, color: ink),
          ],
        ]),
      ),
    );
  }
}
