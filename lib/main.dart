// Conta BOLD — Design System · Catálogo (Flutter web / Vercel).
//
// App SEPARADO do app real: importa SÓ o barrel puro do DS
// (bold_design_system.dart, sem Firebase/Riverpod/plugins), então builda pra
// web sem tocar na infra. Espelha o catálogo do cpf-seguro-flutter: Preview
// (componentes vivos por camada do Atomic Design) + Specs (tokens em tabela).
//
// REGRAS DO CATÁLOGO (e do DS):
//  1. Ordem canônica: TOKENS → ÁTOMOS → MOLÉCULAS → ORGANISMOS.
//  2. Todo componente declara o que o compõe (composedOf) — inclusive os tokens
//     que consome (Cores/Tipografia/Vidro/Gradiente).
//  3. Nenhuma cor ou texto hardcoded: cor = BoldColors, texto = BoldType. Mudou
//     no DS, cascateia em tudo.
//
// Build:  flutter build web -t lib/catalog/main_catalog.dart --release
// Deploy: Vercel serve build/web (vercel.json → outputDirectory).
import 'package:conta_bold_ds/design_system/bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Poppins é a fonte oficial do DS (token de runtime). Carrega via google_fonts
  // e fixa a família ANTES de montar o tema — todo BoldType passa a usá-la.
  BoldType.fontFamily = GoogleFonts.poppins().fontFamily ?? 'Poppins';
  runApp(const BoldCatalogApp());
}

class BoldCatalogApp extends StatefulWidget {
  const BoldCatalogApp({super.key});
  @override
  State<BoldCatalogApp> createState() => _BoldCatalogAppState();
}

class _BoldCatalogAppState extends State<BoldCatalogApp> {
  ThemeMode _mode = ThemeMode.light;

  void _setMode(ThemeMode m) => setState(() => _mode = m);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conta BOLD · Design System',
      debugShowCheckedModeBanner: false,
      theme: BoldTheme.light(),
      darkTheme: BoldTheme.dark(),
      themeMode: _mode,
      home: _CatalogHome(mode: _mode, onMode: _setMode),
    );
  }
}

enum _Tab { preview, specs }

class _CatalogHome extends StatefulWidget {
  const _CatalogHome({required this.mode, required this.onMode});
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onMode;
  @override
  State<_CatalogHome> createState() => _CatalogHomeState();
}

class _CatalogHomeState extends State<_CatalogHome> {
  _Tab _tab = _Tab.preview;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Fundo sólido e limpo (sem imagem/glass): branco no claro, neutral escuro
    // no dark. As superfícies glass dos componentes leem por cima dele.
    final bg = c.isDark ? c.background : BoldColors.white;
    return Scaffold(
      backgroundColor: bg,
      body: ColoredBox(
        color: bg,
        child: SafeArea(
          child: Column(children: [
            _TopBar(
              tab: _tab,
              onTab: (t) => setState(() => _tab = t),
              isDark: c.isDark,
              onToggleTheme: () =>
                  widget.onMode(c.isDark ? ThemeMode.light : ThemeMode.dark),
            ),
            Expanded(
              child: _tab == _Tab.preview
                  ? const _PreviewTab()
                  : const _SpecsTab(),
            ),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Top bar — título + toggle claro/escuro + tabs Preview/Specs.
// ═══════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.tab,
    required this.onTab,
    required this.isDark,
    required this.onToggleTheme,
  });
  final _Tab tab;
  final ValueChanged<_Tab> onTab;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(children: [
        BoldPixMark(size: 22, color: BoldColors.primary04),
        const SizedBox(width: 10),
        Expanded(
          child: Text('Conta BOLD · Design System',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BoldType.title.copyWith(color: c.textPrimary)),
        ),
        _Pill(
            label: 'Preview',
            selected: tab == _Tab.preview,
            onTap: () => onTab(_Tab.preview)),
        const SizedBox(width: 4),
        _Pill(
            label: 'Specs',
            selected: tab == _Tab.specs,
            onTap: () => onTab(_Tab.specs)),
        const SizedBox(width: 8),
        BoldIconButton(
          icon: isDark ? 'sun' : 'moon',
          semanticLabel: isDark ? 'Modo claro' : 'Modo escuro',
          type: BoldIconButtonType.tertiary,
          onPressed: onToggleTheme,
        ),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? BoldColors.primary04.withValues(alpha: 0.18)
              : BoldColors.transparent,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(
              color: selected ? BoldColors.primary04 : c.border, width: 1),
        ),
        child: Text(label,
            style: BoldType.labelSm.copyWith(
                color: selected ? BoldColors.primary04 : c.textSecondary)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PREVIEW — componentes vivos, por camada do Atomic Design.
// Cada _Section.composedOf lista os building blocks do DS que ele consome
// (widgets + tokens: Cores / Tipografia / Vidro / Gradiente).
// ═══════════════════════════════════════════════════════════════════════════
class _PreviewTab extends StatelessWidget {
  const _PreviewTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          children: [
            const _Intro(),

            // ───────────────────────── TOKENS ─────────────────────────────
            const _TierHeader(
                tier: 'TOKENS',
                description:
                    'Fundação — cor, forma, texto, vidro. Tudo deriva daqui.'),
            _Section(title: 'Cores', builder: (_) => const _Swatches()),
            _Section(
                title: 'Gradiente da marca',
                note: 'derivado das Cores',
                composedOf: const ['Cores'],
                builder: (_) => const _GradientBar()),
            _Section(
                title: 'Vidro (glass)',
                note: 'fill 50% + stroke + blur 15 · theme-aware (dark vinho / light branco)',
                composedOf: const ['Cores'],
                builder: (_) => const _GlassSample()),
            _Section(
                title: 'Fundo (backdrop)',
                note:
                    'home = imagem + degradê rosa→laranja @80% + wash @65% · secundário = sólido wine-ink + glow',
                composedOf: const ['Cores', 'Vidro (glass)'],
                builder: (_) => const _BackdropSample()),
            _Section(title: 'Tipografia', builder: (_) => const _TypeScale()),

            // ───────────────────────── ÁTOMOS ─────────────────────────────
            const _TierHeader(
                tier: 'ÁTOMOS',
                description:
                    'Primitivos indivisíveis — só consomem tokens.'),
            _Section(
                title: 'Ícone (BoldIcon)',
                composedOf: const ['Cores'],
                builder: (_) => Wrap(spacing: 16, runSpacing: 12, children: const [
                      BoldIcon('home'),
                      BoldIcon('pix'),
                      BoldIcon('bell'),
                      BoldIcon('eye'),
                      BoldIcon('bank'),
                      BoldIcon('key'),
                      BoldIcon('chevron-right'),
                    ])),
            _Section(
                title: 'Logo',
                composedOf: const ['Cores'],
                builder: (_) => const BoldLogo(width: 150)),
            _Section(
                title: 'Marca PIX',
                composedOf: const ['Cores'],
                builder: (_) => BoldPixMark(size: 40, color: BoldColors.primary04)),
            _Section(
                title: 'Avatar',
                composedOf: const ['Cores', 'Tipografia', 'Gradiente'],
                builder: (_) => Row(children: const [
                      BoldAvatar(initials: 'DL'),
                      SizedBox(width: 12),
                      BoldAvatar(initials: 'HS', size: 56),
                    ])),
            _Section(
                title: 'Checkbox',
                composedOf: const ['BoldIcon', 'Cores', 'Tipografia'],
                builder: (_) => Wrap(spacing: 20, runSpacing: 12, children: const [
                      BoldCheckbox(checked: true, label: 'Marcado'),
                      BoldCheckbox(label: 'Vazio'),
                      BoldCheckbox(indeterminate: true, label: 'Parcial'),
                      BoldCheckbox(checked: true, disabled: true, label: 'Off'),
                    ])),
            _Section(
                title: 'Switch',
                composedOf: const ['Cores'],
                builder: (_) => const _SwitchDemo()),
            _Section(
                title: 'Skeleton (loading)',
                composedOf: const ['Cores'],
                builder: (_) => Column(children: [
                      Row(children: [
                        BoldSkeleton.circle(40),
                        const SizedBox(width: 12),
                        const Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoldSkeleton(width: 140, height: 14),
                            SizedBox(height: 8),
                            BoldSkeleton(width: 90, height: 12),
                          ],
                        )),
                      ]),
                    ])),
            _Section(
                title: 'Status tag',
                composedOf: const ['Cores', 'Tipografia'],
                builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: const [
                      BoldStatusTag(label: 'Sucesso', tone: BoldStatusTone.success),
                      BoldStatusTag(label: 'Falha', tone: BoldStatusTone.danger),
                      BoldStatusTag(label: 'Pendente', tone: BoldStatusTone.warning),
                      BoldStatusTag(label: 'Info', tone: BoldStatusTone.primary),
                    ])),
            _Section(
                title: 'Chips',
                composedOf: const ['Cores', 'Tipografia'],
                builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: const [
                      BoldInputChip(label: 'Tag'),
                      BoldInputChip(label: 'Muted', tone: BoldInputChipTone.neutral),
                      BoldStatusBadge('Ativo'),
                    ])),
            _Section(
                title: 'Home indicator',
                composedOf: const ['Cores'],
                builder: (_) => const BoldHomeIndicator()),

            // ──────────────────────── MOLÉCULAS ───────────────────────────
            const _TierHeader(
                tier: 'MOLÉCULAS',
                description: 'Combinações simples de átomos.'),
            _Section(
                title: 'Spot icon',
                composedOf: const ['BoldIcon', 'Cores'],
                builder: (_) => Wrap(spacing: 12, runSpacing: 12, children: const [
                      BoldSpotIcon('pix-light', tone: BoldSpotTone.primary),
                      BoldSpotIcon('bank', tone: BoldSpotTone.primary, filled: true),
                      BoldSpotIcon('bell-light', tone: BoldSpotTone.success),
                      BoldSpotIcon('key-light', tone: BoldSpotTone.danger, badge: true),
                    ])),
            _Section(
                title: 'Botões',
                composedOf: const ['Tipografia', 'Cores', 'BoldIcon'],
                builder: (_) => Column(children: [
                      BoldButton('Primário', onPressed: () {}),
                      const SizedBox(height: 8),
                      BoldButton('Accent',
                          variant: BoldButtonVariant.accent, onPressed: () {}),
                      const SizedBox(height: 8),
                      BoldButton('Secundário',
                          variant: BoldButtonVariant.secondary, onPressed: () {}),
                      const SizedBox(height: 8),
                      BoldButton('Texto',
                          variant: BoldButtonVariant.text, onPressed: () {}),
                      const SizedBox(height: 8),
                      BoldButton('Destrutivo',
                          variant: BoldButtonVariant.destructive, onPressed: () {}),
                    ])),
            _Section(
                title: 'Icon buttons',
                composedOf: const ['BoldIcon', 'Cores'],
                builder: (_) => Wrap(spacing: 10, runSpacing: 10, children: [
                      BoldIconButton(
                          icon: 'bell',
                          semanticLabel: 'x',
                          type: BoldIconButtonType.primary,
                          onPressed: () {}),
                      BoldIconButton(
                          icon: 'qr',
                          semanticLabel: 'x',
                          type: BoldIconButtonType.secondary,
                          onPressed: () {}),
                      BoldIconButton(
                          icon: 'eye',
                          semanticLabel: 'x',
                          type: BoldIconButtonType.tertiary,
                          onPressed: () {}),
                      BoldIconButton(
                          icon: 'bell',
                          semanticLabel: 'x',
                          badge: true,
                          onPressed: () {}),
                    ])),
            _Section(
                title: 'Segmented control',
                composedOf: const ['Tipografia', 'Cores'],
                builder: (_) => const _SegmentedDemo()),
            _Section(
                title: 'Section header',
                composedOf: const ['Tipografia', 'BoldSeeAllLink'],
                builder: (_) => BoldSectionHeader(
                    label: 'Enviar para',
                    trailing: BoldSeeAllLink(label: 'Ver tudo', onPressed: () {}))),
            _Section(
                title: 'Text field',
                composedOf: const ['Tipografia', 'Cores'],
                builder: (_) => const BoldTextField(
                    label: 'Nome', hint: 'Como te chamam')),
            _Section(
                title: 'Search input',
                composedOf: const ['BoldIcon', 'Tipografia', 'Cores'],
                builder: (_) => const _SearchDemo()),
            _Section(
                title: 'Input chip',
                composedOf: const ['Tipografia', 'BoldIcon', 'Cores'],
                builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: const [
                      BoldInputChip(label: 'R\$ 50'),
                      BoldInputChip(label: 'R\$ 100', filled: true),
                      BoldInputChip(
                          label: 'Filtro',
                          trailIcon: 'chevron-down',
                          tone: BoldInputChipTone.neutral),
                    ])),
            _Section(
                title: 'OTP input',
                composedOf: const ['Tipografia', 'Cores'],
                builder: (_) => const BoldOtpInput(value: '1234', length: 6)),
            _Section(
                title: 'Stepper',
                composedOf: const ['Tipografia', 'Cores'],
                builder: (_) => const BoldStepper(
                    current: 2, total: 4, labelText: 'PASSO 2 DE 4')),
            _Section(
                title: 'Page title',
                composedOf: const ['Tipografia'],
                builder: (_) => const BoldPageTitle(
                    title: 'Quanto você quer enviar?',
                    subtitle: 'O valor sai da sua conta BOLD.')),
            _Section(
                title: 'Keypad',
                composedOf: const ['Tipografia', 'BoldIcon', 'Cores'],
                builder: (_) => BoldKeypad(onKey: (_) {}, onDelete: () {})),
            _Section(
                title: 'App list — menu (grupo glass)',
                composedOf: const ['BoldSpotIcon', 'BoldCard', 'BoldIcon', 'Tipografia'],
                builder: (_) => BoldAppListGroup(title: 'Menu', children: [
                      BoldAppList.menuItem(
                          icon: 'pix-light',
                          title: 'Fazer um Pix',
                          subtitle: 'Para qualquer chave',
                          onTap: () {}),
                      BoldAppList.menuItem(
                          icon: 'bank',
                          title: 'Minha conta',
                          subtitle: 'Ag 0001 · Conta 12345-6',
                          onTap: () {}),
                    ])),
            _Section(
                title: 'App list — atividade',
                composedOf: const ['BoldSpotIcon', 'BoldStatusTag', 'Tipografia'],
                builder: (_) => BoldAppListGroup(children: [
                      BoldAppList.activityItem(
                          icon: 'pix-light',
                          iconTone: BoldSpotTone.success,
                          title: 'Recebido de Diletta',
                          subtitle: 'PIX',
                          time: '14:20',
                          status: const BoldStatusTagData(
                              label: 'Concluído', tone: BoldStatusTone.success)),
                    ])),
            _Section(
                title: 'Notice row',
                composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
                builder: (_) => BoldNoticeRow(
                    icon: 'paper-plane-light',
                    title: 'Autorizações',
                    subtitle: 'Veja o que está esperando você.',
                    count: 3,
                    onTap: () {})),
            // TODO(ds): BoldQuickAction ainda não foi portado pro DS atual
            // (fila de portes: FeatureCard/DetailCard/QuickAccessCard).
            // Reativar quando o componente existir.
            // _Section(
            //     title: 'Quick action',
            //     composedOf: const ['BoldIcon', 'Tipografia', 'Cores'],
            //     builder: (_) => Row(children: [
            //           BoldQuickAction(icon: 'pix-light', label: 'Pix', onTap: () {}),
            //           const SizedBox(width: 16),
            //           BoldQuickAction(
            //               icon: 'bank', label: 'Conta', highlighted: true, onTap: () {}),
            //         ])),
            _Section(
                title: 'Card',
                composedOf: const ['Vidro', 'Cores'],
                builder: (ctx) => BoldCard(
                    glass: true,
                    child: Text('Card glass padrão do DS.',
                        style: BoldType.bodySmall
                            .copyWith(color: BoldColors.of(ctx).textPrimary)))),
            _Section(
                title: 'Empty state',
                composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
                builder: (_) => const BoldEmptyState(
                    title: 'Nada por aqui',
                    caption: 'Suas transações aparecem aqui.')),
            _Section(
                title: 'Promo card',
                composedOf: const ['Gradiente', 'Tipografia', 'BoldIcon'],
                builder: (_) => BoldPromoCard(
                    title: 'Habilite sua passkey',
                    subtitle: 'Login sem senha, resistente a phishing.',
                    onTap: () {},
                    onClose: () {})),
            _Section(
                title: 'Promo banner',
                composedOf: const [
                  'BoldAvatarStack',
                  'BoldButton',
                  'Gradiente',
                  'Tipografia'
                ],
                builder: (_) => BoldPromoBanner(
                    title: 'Veja as pessoas próximas',
                    subtitle: 'Realize transações :)',
                    primaryLabel: 'Enviar',
                    secondaryLabel: 'Receber',
                    avatars: const ['DL', 'HS', 'MJ'],
                    moreCount: 4,
                    onPrimary: () {},
                    onSecondary: () {},
                    onClose: () {})),
            _Section(
                title: 'Avatar row / stack',
                composedOf: const ['BoldAvatar'],
                builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldAvatarRow(
                          initials: const ['DL', 'HS', 'MJ'], onAdd: () {}),
                      const SizedBox(height: 16),
                      const BoldAvatarStack(initials: ['DL', 'HS', 'MJ', 'AB']),
                    ])),

            // ─────────────────────── ORGANISMOS ───────────────────────────
            const _TierHeader(
                tier: 'ORGANISMOS',
                description: 'Composições em superfície glass.'),
            _Section(
                title: 'Top bar (home)',
                composedOf: const ['BoldAvatar', 'BoldIconButton', 'Vidro', 'Tipografia'],
                builder: (_) => BoldTopBar.home(
                      firstName: 'Diletta',
                      safeArea: false,
                      accountLabel: '12345-6',
                      onOpenProfile: () {},
                      onSwitchAccount: () {},
                      icons: [
                        BoldNavRightIcon(
                            icon: 'eye-off', semanticLabel: 'Ocultar', onPressed: () {}),
                        BoldNavRightIcon(
                            icon: 'bell',
                            semanticLabel: 'Notificações',
                            badge: true,
                            onPressed: () {}),
                      ],
                    )),
            _Section(
                title: 'Balance',
                composedOf: const ['BoldCard', 'BoldStatusTag', 'BoldIcon', 'Tipografia'],
                builder: (_) => BoldBalance(
                      value: 'R\$ 2.912,47',
                      entradas: 'R\$ 300,00',
                      saidas: 'R\$ 120,00',
                      onExtrato: () {},
                    )),
            _Section(
                title: 'Tab bar',
                composedOf: const ['BoldIcon', 'Tipografia', 'Vidro'],
                builder: (_) => const _TabBarDemo()),
            _Section(
                title: 'Dialog / Toast (gatilhos)',
                composedOf: const ['BoldButton', 'BoldCard', 'Tipografia'],
                builder: (_) => const _OverlayDemo()),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Scaffolding — intro, tier header, section, dep chip.
// ═══════════════════════════════════════════════════════════════════════════
class _Intro extends StatelessWidget {
  const _Intro();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Design System · Catálogo',
          style: BoldType.headlineMd.copyWith(color: c.textPrimary)),
      const SizedBox(height: 6),
      Text(
          'Referência viva do Redesenho v.01. Componentes reais, renderizados '
          'pelo próprio DS, na ordem TOKENS → ÁTOMOS → MOLÉCULAS → ORGANISMOS. '
          'Cada um declara o que o compõe. Alterne claro/escuro no topo.',
          style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
    ]);
  }
}

class _TierHeader extends StatelessWidget {
  const _TierHeader({required this.tier, required this.description});
  final String tier;
  final String description;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 44, bottom: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
                color: BoldColors.primary04, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(tier,
              style: BoldType.labelLg
                  .copyWith(color: c.textPrimary, letterSpacing: 1.2)),
        ]),
        const SizedBox(height: 4),
        Text(description,
            style: BoldType.bodySmall.copyWith(color: c.textMuted)),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(
      {required this.title, required this.builder, this.composedOf, this.note});
  final String title;
  final WidgetBuilder builder;
  final List<String>? composedOf;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Título do componente — nome + o que o forma, direto no cabeçalho.
        Text(title, style: BoldType.title.copyWith(color: c.textPrimary)),
        if (composedOf != null && composedOf!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('formado por:',
                  style: BoldType.labelSm.copyWith(color: c.textSecondary)),
              for (final w in composedOf!) _DepChip(name: w),
            ],
          ),
        ],
        if (note != null) ...[
          const SizedBox(height: 6),
          Text(note!, style: BoldType.labelSm.copyWith(color: c.textMuted)),
        ],
        const SizedBox(height: 14),
        builder(context),
      ]),
    );
  }
}

class _DepChip extends StatelessWidget {
  const _DepChip({required this.name});
  final String name;

  // Tokens ganham um leve tint da marca pra distinguir de widgets.
  static const _tokens = {'Cores', 'Tipografia', 'Vidro', 'Gradiente'};

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final isToken = _tokens.contains(name);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isToken
            ? BoldColors.primary04.withValues(alpha: 0.12)
            : c.field,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(name,
          style: BoldType.labelSm.copyWith(
              color: isToken ? BoldColors.primary04 : c.textMuted,
              fontSize: 11)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Token samples.
// ═══════════════════════════════════════════════════════════════════════════
class _Swatches extends StatelessWidget {
  const _Swatches();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _Ramp('Primary', [
          ('01', BoldColors.primary01),
          ('02', BoldColors.primary02),
          ('03', BoldColors.primary03),
          ('04', BoldColors.primary04),
          ('05', BoldColors.primary05),
          ('06', BoldColors.primary06),
          ('07', BoldColors.primary07),
          ('08', BoldColors.primary08),
          ('09', BoldColors.primary09),
        ]),
        _Ramp('Accent', [
          ('03', BoldColors.accent03),
          ('04', BoldColors.accent04),
          ('05', BoldColors.accent05),
          ('07', BoldColors.accent07),
          ('08', BoldColors.accent08),
        ]),
        _Ramp('Neutral', [
          ('01', BoldColors.neutral01),
          ('02', BoldColors.neutral02),
          ('03', BoldColors.neutral03),
          ('04', BoldColors.neutral04),
          ('05', BoldColors.neutral05),
          ('06', BoldColors.neutral06),
          ('07', BoldColors.neutral07),
          ('08', BoldColors.neutral08),
          ('09', BoldColors.neutral09),
          ('10', BoldColors.neutral10),
        ]),
        _Ramp('Sucesso', [
          ('01', BoldColors.success01),
          ('02', BoldColors.success02),
          ('03', BoldColors.success03),
          ('04', BoldColors.success04),
          ('05', BoldColors.success05),
          ('06', BoldColors.success06),
          ('07', BoldColors.success07),
        ]),
        _Ramp('Alerta', [
          ('01', BoldColors.warning01),
          ('02', BoldColors.warning02),
          ('03', BoldColors.warning03),
          ('04', BoldColors.warning04),
          ('05', BoldColors.warning05),
          ('06', BoldColors.warning06),
          ('07', BoldColors.warning07),
        ]),
        _Ramp('Erro', [
          ('01', BoldColors.error01),
          ('02', BoldColors.error02),
          ('03', BoldColors.error03),
          ('04', BoldColors.error04),
          ('05', BoldColors.error05),
          ('06', BoldColors.error06),
          ('07', BoldColors.error07),
        ]),
        _Ramp('Info', [
          ('info', BoldColors.info04),
          ('soft', BoldColors.infoSoft),
        ]),
        _Ramp('Fundo / superfície', [
          ('bg', BoldColors.background),
          ('flow', BoldColors.secondaryFlow),
          ('surf', BoldColors.surface),
          ('glass', BoldColors.glassFill),
        ]),
      ],
    );
  }
}

/// Uma escala de cor (label + chips de shade com hex).
class _Ramp extends StatelessWidget {
  const _Ramp(this.label, this.shades);
  final String label;
  final List<(String, Color)> shades;

  static String _hex(Color c) {
    final v = (c.toARGB32() & 0xFFFFFF).toRadixString(16).toUpperCase();
    return '#${v.padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sc = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: BoldType.labelSm.copyWith(color: sc.textSecondary)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in shades)
            SizedBox(
              width: 66,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: s.$2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sc.border),
                  ),
                ),
                const SizedBox(height: 3),
                Text(s.$1,
                    style: BoldType.labelSm
                        .copyWith(color: sc.textPrimary, fontSize: 10)),
                Text(_hex(s.$2),
                    style: BoldType.labelSm
                        .copyWith(color: sc.textMuted, fontSize: 9)),
              ]),
            ),
        ]),
      ]),
    );
  }
}

class _GradientBar extends StatelessWidget {
  const _GradientBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: BoldGradients.brand,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text('BoldGradients.brand',
          style: BoldType.labelMd.copyWith(color: BoldColors.onGradient)),
    );
  }
}

class _GlassSample extends StatelessWidget {
  const _GlassSample();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return BoldCard(
      glass: true,
      child: Row(children: [
        BoldSpotIcon('pix-light', tone: BoldSpotTone.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Superfície de vidro única do DS.',
              style: BoldType.bodySmall.copyWith(color: c.textPrimary)),
        ),
      ]),
    );
  }
}

/// Mostra os dois fundos do DS lado a lado: HOME (imagem + degradê + wash) e
/// SECUNDÁRIO (sólido wine-ink + glow). Ambos theme-aware.
class _BackdropSample extends StatelessWidget {
  const _BackdropSample();

  @override
  Widget build(BuildContext context) {
    final sc = BoldColors.of(context);
    Widget frame(String label, String sub, Widget bg) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(height: 170, width: double.infinity, child: bg),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: BoldType.labelMd.copyWith(color: sc.textPrimary)),
            Text(sub,
                style: BoldType.labelSm
                    .copyWith(color: sc.textMuted, fontSize: 10)),
          ]),
        );
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      frame('BoldHomeBackground', 'home + entrada',
          const BoldHomeBackground(child: SizedBox.expand())),
      const SizedBox(width: 12),
      frame('BoldSecondaryBackground', 'fluxos secundários',
          const BoldSecondaryBackground(child: SizedBox.expand())),
    ]);
  }
}

class _TypeScale extends StatelessWidget {
  const _TypeScale();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final items = <(String, TextStyle)>[
      ('headlineMd', BoldType.headlineMd),
      ('title', BoldType.title),
      ('labelLg', BoldType.labelLg),
      ('labelMd', BoldType.labelMd),
      ('bodySmall', BoldType.bodySmall),
      ('button', BoldType.button),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final it in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${it.$1} · Poppins',
                  style: BoldType.labelSm
                      .copyWith(color: c.textMuted, fontSize: 11)),
              Text('Conta BOLD', style: it.$2.copyWith(color: c.textPrimary)),
            ]),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Stateful demos.
// ═══════════════════════════════════════════════════════════════════════════
class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();
  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _on = true;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      BoldSwitch(value: _on, onChanged: (v) => setState(() => _on = v)),
      const SizedBox(width: 16),
      const BoldSwitch(value: false, onChanged: null),
    ]);
  }
}

class _SegmentedDemo extends StatefulWidget {
  const _SegmentedDemo();
  @override
  State<_SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<_SegmentedDemo> {
  int _i = 0;
  @override
  Widget build(BuildContext context) {
    return BoldSegmentedControl(
      segments: const ['Claro', 'Escuro', 'Sistema'],
      selectedIndex: _i,
      onChanged: (i) => setState(() => _i = i),
    );
  }
}

class _SearchDemo extends StatefulWidget {
  const _SearchDemo();
  @override
  State<_SearchDemo> createState() => _SearchDemoState();
}

class _SearchDemoState extends State<_SearchDemo> {
  final _ctrl = TextEditingController();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BoldSearchInput(controller: _ctrl, placeholder: 'Buscar contato');
}

class _TabBarDemo extends StatefulWidget {
  const _TabBarDemo();
  @override
  State<_TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<_TabBarDemo> {
  int _cur = 0;
  // BoldTabBar foi aposentado; o switch de contexto atual do DS é o
  // BoldSegmentedControl (pill, label-only).
  @override
  Widget build(BuildContext context) {
    return BoldSegmentedControl(
      segments: const ['Início', 'PIX', 'Perfil'],
      selectedIndex: _cur,
      onChanged: (v) => setState(() => _cur = v),
    );
  }
}

class _OverlayDemo extends StatelessWidget {
  const _OverlayDemo();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      BoldButton(
        'Dialog',
        expand: false,
        variant: BoldButtonVariant.secondary,
        size: BoldButtonSize.sm,
        onPressed: () => BoldDialog.confirm(
          context,
          icon: Icons.logout_rounded,
          title: 'Sair da conta',
          message: 'Tem certeza que deseja sair?',
          confirmLabel: 'Sair',
        ),
      ),
      const SizedBox(width: 12),
      BoldButton(
        'Toast',
        expand: false,
        variant: BoldButtonVariant.secondary,
        size: BoldButtonSize.sm,
        onPressed: () =>
            BoldToast.show(context, message: 'Foto atualizada com sucesso!'),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SPECS — tokens em tabela.
// ═══════════════════════════════════════════════════════════════════════════
class _SpecsTab extends StatelessWidget {
  const _SpecsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          children: [
            _SpecTable(title: 'Cor', rows: const [
              ('primary04', '#FE3976'),
              ('accent04', '#FE7B5E'),
              ('glass fill (dark)', '#4C0202 · 26%'),
              ('glass fill (light)', '#FFC8DC · 26%'),
              ('glass stroke', 'branco 30% (light) · #FF9898 (dark)'),
            ]),
            _SpecTable(title: 'Tipografia', rows: const [
              ('família', 'Poppins (todo texto do app)'),
              ('headlineMd', 'display do saldo'),
              ('title', 'títulos de row'),
              ('labelLg / Md / Sm', 'labels'),
              ('bodySmall', 'subtítulos'),
              ('button', 'CTA'),
            ]),
            _SpecTable(title: 'Espaçamento (BoldSpace)', rows: const [
              ('x1 / x2 / x3', '4 · 8 · 12'),
              ('x4 / x5 / x6', '16 · 20 · 24'),
              ('x8 / x10', '32 · 40'),
            ]),
            _SpecTable(title: 'Vidro (glass) — regra única', rows: const [
              ('fill', '26% de opacidade'),
              ('stroke', '30% · 1px inside'),
              ('blur', '15 (frosted no web)'),
              ('característica', 'do container, nunca do elemento'),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SpecTable extends StatelessWidget {
  const _SpecTable({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: BoldType.labelLg.copyWith(color: c.textPrimary)),
        const SizedBox(height: 10),
        BoldCard(
          glass: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) Divider(height: 1, thickness: 1, color: c.border),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Text(rows[i].$1,
                        style: BoldType.bodySmall
                            .copyWith(color: c.textSecondary)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(rows[i].$2,
                        textAlign: TextAlign.right,
                        style: BoldType.labelSm.copyWith(color: c.textPrimary)),
                  ),
                ]),
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}
