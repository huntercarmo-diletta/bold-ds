// Conta BOLD — Design System · Catálogo (Flutter web / Vercel).
//
// App SEPARADO do app real: importa só o barrel puro do DS
// (bold_design_system.dart, sem Firebase/Riverpod/plugins), então builda pra
// web sem tocar na infra. Estrutura ESPELHA o catálogo do cpf-seguro-flutter:
// abas Foundations (Gramática + Árvore) · Styles (tokens) · Components (por
// função) · Specs (tabelas) · Integração (adoção real no app-newbold).
//
// Build:  flutter build web --release
// Deploy: Vercel serve build/web (vercel.json → outputDirectory).
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_system/bold_design_system.dart';
import 'ds_tree_screen.dart';
import 'grammar_screen.dart';
import 'integration_screen.dart';

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

class _Illu {
  const _Illu(this.name, this.label,
      [this.themes = const ['light', 'dark', 'theme3']]);
  final String name;
  final String label;
  final List<String> themes;
}

const _kIllustrations = <_Illu>[
  _Illu('timer_woman', 'Timer woman'),
  _Illu('money_jar', 'Money jar'),
  _Illu('online_payment', 'Online payment'),
  _Illu('sad_face', 'Sad face'),
  _Illu('security_phone', 'Security phone'),
  _Illu('config', 'Config'),
  _Illu('search', 'Search'),
  _Illu('page_not_found', 'Page not found'),
  _Illu('error', 'Error'),
  _Illu('file_not_found', 'File not found'),
  _Illu('invalid_file', 'Invalid file'),
  _Illu('pix', 'Pix'),
  _Illu('internet_off', 'Internet off'),
  _Illu('search_engine', 'Search engine'),
  _Illu('data_analysis', 'Data analysis'),
  _Illu('no_files_line', 'No files (line)'),
  _Illu('search_line', 'Search (line)'),
  _Illu('success', 'Success'),
  _Illu('graphics', 'Graphics'),
  _Illu('success_alt', 'Success 2'),
  _Illu('invalid_state', 'Invalid state'),
  _Illu('no_files', 'No files', ['light', 'dark']),
  _Illu('files_search', 'Files search'),
  _Illu('key_word', 'Key word'),
  _Illu('no_data', 'No data'),
  _Illu('fingerprint', 'Fingerprint'),
];

// ═══════════════════════════════════════════════════════════════════════════
// Navegação — abas de topo (padrão do catálogo CPF): Foundations · Styles ·
// Components · Specs · Integração. Sem aba SDK (não faz sentido no Bold).
// ═══════════════════════════════════════════════════════════════════════════
enum _Tab { foundations, styles, components, specs, integracao }

extension _TabX on _Tab {
  String get label => switch (this) {
        _Tab.foundations => 'Foundations',
        _Tab.styles => 'Styles',
        _Tab.components => 'Components',
        _Tab.specs => 'Specs',
        _Tab.integracao => 'Integração',
      };
}

// Categorias de Components — agrupamento por FUNÇÃO (Material 3). O eixo atômico
// (token→átomo→molécula→organismo) vive em Foundations (Gramática + Árvore).
enum _Cat { acoes, inputs, selecao, comunicacao, conteineres, navegacao, dominio }

extension _CatX on _Cat {
  String get label => switch (this) {
        _Cat.acoes => 'Ações',
        _Cat.inputs => 'Campos & entrada',
        _Cat.selecao => 'Seleção',
        _Cat.comunicacao => 'Comunicação',
        _Cat.conteineres => 'Contêineres',
        _Cat.navegacao => 'Navegação',
        _Cat.dominio => 'BOLD · domínio',
      };
}

class _CatalogHome extends StatefulWidget {
  const _CatalogHome({required this.mode, required this.onMode});
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onMode;
  @override
  State<_CatalogHome> createState() => _CatalogHomeState();
}

class _CatalogHomeState extends State<_CatalogHome> {
  _Tab _tab = _Tab.components;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final bg = c.isDark ? c.background : BoldColors.white;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(children: [
          _CatTopBar(
            active: _tab,
            onTap: (t) => setState(() => _tab = t),
            isDark: c.isDark,
            onToggleTheme: () =>
                widget.onMode(c.isDark ? ThemeMode.light : ThemeMode.dark),
          ),
          Expanded(child: _body()),
        ]),
      ),
    );
  }

  Widget _body() {
    switch (_tab) {
      case _Tab.foundations:
        return const _FoundationsView();
      case _Tab.styles:
        return const _StylesView();
      case _Tab.components:
        return const _ComponentsView();
      case _Tab.specs:
        return const _SpecsView();
      case _Tab.integracao:
        return const IntegrationScreen();
    }
  }
}

// Barra de topo: marca + abas + troca de tema. Mesma pegada do header da CPF.
class _CatTopBar extends StatelessWidget {
  const _CatTopBar(
      {required this.active,
      required this.onTap,
      required this.isDark,
      required this.onToggleTheme});
  final _Tab active;
  final ValueChanged<_Tab> onTap;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.white,
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(children: [
        BoldPixMark(size: 18, color: BoldColors.primary04),
        const SizedBox(width: 10),
        Text('Conta BOLD · Design System',
            style: BoldType.labelLg.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2)),
        const SizedBox(width: 24),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final t in _Tab.values)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _CatTabButton(
                      label: t.label,
                      selected: active == t,
                      onTap: () => onTap(t)),
                ),
            ]),
          ),
        ),
        const SizedBox(width: 12),
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

class _CatTabButton extends StatelessWidget {
  const _CatTabButton(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? BoldColors.primary04.withValues(alpha: 0.14)
                : BoldColors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              style: BoldType.labelMd.copyWith(
                  color: selected ? BoldColors.primary04 : c.textSecondary,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// Pílula de sub-navegação (Foundations / Components).
class _CatNavPill extends StatelessWidget {
  const _CatNavPill(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? BoldColors.primary04 : BoldColors.transparent,
            borderRadius: BorderRadius.circular(200),
            border: Border.all(
                color: selected ? BoldColors.primary04 : c.border, width: 1),
          ),
          child: Text(label,
              style: BoldType.labelMd.copyWith(
                  color: selected ? BoldColors.white : c.textSecondary,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// Divisor de macro-grupo dentro de uma categoria de Components.
class _CatMacroHeader extends StatelessWidget {
  const _CatMacroHeader(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(children: [
        Text(label,
            style: BoldType.labelSm.copyWith(
                color: BoldColors.primary04,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: c.border)),
      ]),
    );
  }
}

// Cabeçalho de tela (Styles / Components) — título + subtítulo + hairline.
class _CatHeader extends StatelessWidget {
  const _CatHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: BoldType.headlineSm.copyWith(color: c.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: BoldType.bodySmall
                  .copyWith(color: c.textSecondary, height: 1.5)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FOUNDATIONS — Gramática + Árvore de dependências.
// ═══════════════════════════════════════════════════════════════════════════
class _FoundationsView extends StatefulWidget {
  const _FoundationsView();
  @override
  State<_FoundationsView> createState() => _FoundationsViewState();
}

class _FoundationsViewState extends State<_FoundationsView> {
  int _view = 0; // 0 = Gramática · 1 = Árvore
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: Wrap(spacing: 8, children: [
          _CatNavPill(
              label: 'Gramática',
              selected: _view == 0,
              onTap: () => setState(() => _view = 0)),
          _CatNavPill(
              label: 'Árvore de dependências',
              selected: _view == 1,
              onTap: () => setState(() => _view = 1)),
        ]),
      ),
      Expanded(
          child: _view == 0 ? const GrammarScreen() : const DsTreeScreen()),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STYLES — tokens: scheme, cores, gradiente, vidro, backdrop, tipografia,
// raio, spacing, elevação, motion + ilustrações. O material bruto do sistema.
// ═══════════════════════════════════════════════════════════════════════════
class _StylesView extends StatelessWidget {
  const _StylesView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
          children: [
            const _CatHeader(
              title: 'Styles · Tokens',
              subtitle:
                  'O material bruto do sistema. O Scheme resolve os papéis por '
                  'tema; cor, tipografia, vidro, gradiente, raio, spacing, '
                  'elevação e motion são o que todo componente consome — nunca '
                  'valores crus.',
            ),
            _Section(
                title: 'Scheme',
                note: 'papéis mode-aware (light & dark) que os widgets consomem',
                composedOf: const ['Cores'],
                builder: (_) => const _TokScheme()),
            _Section(title: 'Cores', builder: (_) => const _Swatches()),
            _Section(
                title: 'Gradiente da marca',
                note: 'rosa → coral → amarelo (o "O" do logo)',
                composedOf: const ['Cores'],
                builder: (_) => const _GradientBar()),
            _Section(
                title: 'Vidro (glass)',
                note:
                    'spec única: fill 50% + stroke 1px + blur 15 · theme-aware',
                composedOf: const ['Cores'],
                builder: (_) => const _GlassSample()),
            _Section(
                title: 'Fundo (backdrop)',
                note: 'home (imagem + degradê) · secundário (wine-ink sólido)',
                composedOf: const ['Cores', 'Vidro (glass)'],
                builder: (_) => const _BackdropSample()),
            _Section(title: 'Tipografia', builder: (_) => const _TypeScale()),
            _Section(
                title: 'Raio (radius)',
                note: 'cantos generosos; controles são pílula',
                builder: (_) => const _TokRadius()),
            _Section(
                title: 'Espaçamento',
                note: 'escala base-4 · x5=20 é o gutter lateral',
                builder: (_) => const _TokSpacing()),
            _Section(
                title: 'Elevação',
                note: 'sombras suaves; glow tingido pela ação',
                composedOf: const ['Cores'],
                builder: (_) => const _TokElevation()),
            _Section(
                title: 'Motion',
                note: 'durações + curvas amarradas por contexto',
                builder: (_) => const _TokMotion()),
            const _CatMacroHeader('ILUSTRAÇÕES'),
            for (final il in _kIllustrations)
              _Section(
                  title: il.label,
                  note: il.themes.length < 3
                      ? 'variações: Light · Dark'
                      : 'variações: Light · Dark · Theme 3',
                  builder: (_) => _IllustrationRow(il)),
          ],
        ),
      ),
    );
  }
}

// ── Token showcases novos (radius / spacing / elevation / motion / scheme) ──
class _TokScheme extends StatelessWidget {
  const _TokScheme();
  static const _roles = <String>[
    'background',
    'surface',
    'field',
    'primary',
    'textPrimary',
  ];
  static Color _val(BoldScheme s, String r) => switch (r) {
        'background' => s.background,
        'surface' => s.surface,
        'field' => s.field,
        'primary' => s.primary,
        _ => s.textPrimary,
      };
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    Widget col(String label, BoldScheme s) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: BoldType.labelSm.copyWith(
                    color: c.textSecondary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final r in _roles)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _val(s, r),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: c.border),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(r,
                      style: BoldType.labelSm
                          .copyWith(color: c.textMuted, fontSize: 11)),
                ]),
              ),
          ]),
        );
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      col('LIGHT', BoldScheme.light()),
      const SizedBox(width: 20),
      col('DARK', BoldScheme.dark()),
    ]);
  }
}

class _TokRadius extends StatelessWidget {
  const _TokRadius();
  static const _items = <(String, double)>[
    ('chip · 10', BoldRadius.chip),
    ('field · 16', BoldRadius.field),
    ('sheet · 22', BoldRadius.sheet),
    ('card · 24', BoldRadius.card),
    ('pill · 999', BoldRadius.pill),
  ];
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Wrap(spacing: 14, runSpacing: 14, children: [
      for (final (label, r) in _items)
        SizedBox(
          width: 100,
          child: Column(children: [
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: BoldColors.primary04.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(r),
                border: Border.all(color: BoldColors.primary04.withValues(alpha: 0.4)),
              ),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: BoldType.labelSm.copyWith(color: c.textMuted, fontSize: 11)),
          ]),
        ),
    ]);
  }
}

class _TokSpacing extends StatelessWidget {
  const _TokSpacing();
  static const _scale = <(String, double)>[
    ('x1 · 4', BoldSpace.x1),
    ('x2 · 8', BoldSpace.x2),
    ('x3 · 12', BoldSpace.x3),
    ('x4 · 16', BoldSpace.x4),
    ('x5 · 20 · gutter', BoldSpace.x5),
    ('x6 · 24', BoldSpace.x6),
    ('x8 · 32', BoldSpace.x8),
    ('x10 · 40', BoldSpace.x10),
  ];
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final (label, v) in _scale)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            SizedBox(
                width: 128,
                child: Text(label,
                    style: BoldType.labelSm
                        .copyWith(color: c.textSecondary, fontSize: 11))),
            Container(
              width: v,
              height: 14,
              decoration: BoxDecoration(
                color: BoldColors.primary04,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ]),
        ),
    ]);
  }
}

class _TokElevation extends StatelessWidget {
  const _TokElevation();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final surface = c.isDark ? c.surface : BoldColors.white;
    final items = <(String, List<BoxShadow>)>[
      ('flat', BoldElevation.flat),
      ('raised', BoldElevation.raised),
      ('glow(primary)', BoldElevation.glow(BoldColors.primary04)),
    ];
    return Wrap(spacing: 28, runSpacing: 20, children: [
      for (final (label, sh) in items)
        SizedBox(
          width: 120,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 120,
              height: 56,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: sh,
                border: Border.all(color: c.border),
              ),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: BoldType.labelSm.copyWith(color: c.textMuted)),
          ]),
        ),
    ]);
  }
}

class _TokMotion extends StatefulWidget {
  const _TokMotion();
  @override
  State<_TokMotion> createState() => _TokMotionState();
}

class _TokMotionState extends State<_TokMotion> {
  int _run = 0;
  static const _ctx = <(String, Duration)>[
    ('fast · 150ms', BoldMotion.fast),
    ('base · 250ms', BoldMotion.base),
    ('slow · 400ms', BoldMotion.slow),
  ];
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 160,
        child: BoldButton('Reproduzir',
            variant: BoldButtonVariant.secondary,
            size: BoldButtonSize.sm,
            onPressed: () => setState(() => _run++)),
      ),
      const SizedBox(height: 16),
      Wrap(spacing: 16, runSpacing: 16, children: [
        for (final (name, dur) in _ctx)
          SizedBox(
            width: 200,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  style: BoldType.labelSm.copyWith(color: c.textMuted)),
              const SizedBox(height: 6),
              Container(
                height: 44,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: c.field, borderRadius: BorderRadius.circular(8)),
                child: TweenAnimationBuilder<double>(
                  key: ValueKey('$name-$_run'),
                  tween: Tween(begin: 0, end: 1),
                  duration: dur,
                  curve: BoldMotion.standard,
                  builder: (context, t, child) => Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(t * 152, 0),
                      child: Opacity(
                          opacity: (0.25 + 0.75 * t).clamp(0.0, 1.0),
                          child: child),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: BoldColors.primary04,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ]),
          ),
      ]),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// COMPONENTS — widgets Bold* agrupados por FUNÇÃO, com preview vivo.
// ═══════════════════════════════════════════════════════════════════════════
class _ComponentsView extends StatefulWidget {
  const _ComponentsView();
  @override
  State<_ComponentsView> createState() => _ComponentsViewState();
}

class _ComponentsViewState extends State<_ComponentsView> {
  _Cat _cat = _Cat.acoes;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
          children: [
            const _CatHeader(
              title: 'Components',
              subtitle:
                  'Componentes reais do DS, agrupados por função. Cada seção '
                  'traz o preview vivo e os chips "formado por:" (o que consome). '
                  'O eixo atômico completo vive em Foundations.',
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                for (final cat in _Cat.values)
                  _CatNavPill(
                      label: cat.label,
                      selected: cat == _cat,
                      onTap: () => setState(() => _cat = cat)),
              ]),
            ),
            ..._componentSections(_cat),
          ],
        ),
      ),
    );
  }
}

List<Widget> _componentSections(_Cat c) {
  switch (c) {
    case _Cat.acoes:
      return [
        _Section(
            title: 'Botões',
            composedOf: const ['Tipografia', 'Cores', 'BoldIcon'],
            builder: (_) => Column(children: [
                  BoldButton('Primário', onPressed: () {}),
                  const SizedBox(height: 8),
                  BoldButton('Secundário',
                      variant: BoldButtonVariant.secondary, onPressed: () {}),
                  const SizedBox(height: 8),
                  BoldButton('Texto',
                      variant: BoldButtonVariant.text, onPressed: () {}),
                  const SizedBox(height: 8),
                  BoldButton('Destrutivo',
                      variant: BoldButtonVariant.destructive, onPressed: () {}),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    const BoldButton('Carregando', loading: true, expand: false),
                    const BoldButton('Off', onPressed: null, expand: false),
                    BoldButton('Revogar',
                        variant: BoldButtonVariant.destructive,
                        filled: true,
                        expand: false,
                        onPressed: () {}),
                  ]),
                ])),
        _Section(
            title: 'Icon buttons',
            composedOf: const ['BoldIcon', 'Cores'],
            builder: (_) => Wrap(spacing: 10, runSpacing: 10, children: [
                  BoldIconButton(
                      icon: 'bell',
                      semanticLabel: 'x',
                      type: BoldIconButtonType.secondaryPrimary,
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
                  BoldIconButton(
                      icon: 'bell',
                      semanticLabel: 'x',
                      size: BoldIconButtonSize.sm,
                      onPressed: () {}),
                  BoldIconButton(
                      icon: 'bell',
                      semanticLabel: 'x',
                      size: BoldIconButtonSize.lg,
                      onPressed: () {}),
                  const BoldIconButton(
                      icon: 'bell', semanticLabel: 'x', disabled: true),
                ])),
        _Section(
            title: 'Circle button',
            composedOf: const ['BoldIcon', 'Cores'],
            builder: (_) => Wrap(spacing: 12, children: [
                  BoldCircleButton('bell', onTap: () {}),
                  BoldCircleButton('bell', dot: true, onTap: () {}),
                  BoldCircleButton('edit', active: true, onTap: () {}),
                ])),
        _Section(
            title: 'Copy button',
            composedOf: const ['BoldIcon', 'Cores', 'Tipografia'],
            note: 'toque → copia + check verde in-place',
            builder: (_) => const BoldCopyButton(
                text: '0001 · 1234567-8',
                semanticLabel: 'Copiar conta',
                label: 'Conta copiada')),
        _Section(
            title: 'Menu tile',
            composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
            builder: (_) => Wrap(spacing: 12, runSpacing: 12, children: [
                  BoldMenuTile(
                      icon: 'qrcode-light',
                      label: 'Ler QR',
                      size: BoldMenuTileSize.compact,
                      onTap: () {}),
                  BoldMenuTile(
                      icon: 'pix-light',
                      label: 'Fazer um Pix',
                      size: BoldMenuTileSize.wide,
                      onTap: () {}),
                  BoldMenuTile(
                      icon: 'barcode-light',
                      label: 'Pagar conta',
                      size: BoldMenuTileSize.large,
                      onTap: () {}),
                ])),
        _Section(
            title: 'Navigation button',
            composedOf: const ['BoldButton', 'Tipografia'],
            note: 'coluna de CTAs de rodapé (primary/secondary)',
            builder: (_) => BoldNavigationButton(
                  primary: BoldNavAction(label: 'Continuar', onPressed: () {}),
                  secondary: BoldNavAction(label: 'Agora não', onPressed: () {}),
                )),
      ];
    case _Cat.inputs:
      return [
        _Section(
            title: 'Text field',
            composedOf: const ['Tipografia', 'Cores'],
            builder: (_) => const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldTextField(label: 'Nome', hint: 'Como te chamam'),
                  SizedBox(height: 12),
                  BoldTextField(
                      label: 'E-mail',
                      hint: 'voce@email.com',
                      errorText: 'E-mail inválido'),
                  SizedBox(height: 12),
                  BoldTextField(
                      label: 'Desabilitado',
                      hint: 'Indisponível',
                      enabled: false),
                ])),
        _Section(
            title: 'Search input',
            composedOf: const ['BoldIcon', 'Tipografia', 'Cores'],
            builder: (_) => const _SearchDemo()),
        _Section(
            title: 'Currency field',
            composedOf: const ['Tipografia', 'Cores'],
            builder: (_) => const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldCurrencyField(initialValue: 1234.56),
                  SizedBox(height: 12),
                  BoldCurrencyField(large: true, initialValue: 1234.56),
                ])),
        _Section(
            title: 'OTP input',
            composedOf: const ['Tipografia', 'Cores'],
            builder: (_) => const BoldOtpInput(value: '1234', length: 6)),
        _Section(
            title: 'PIN dots',
            composedOf: const ['Cores'],
            builder: (_) => const Row(children: [
                  BoldPinDots(length: 4, filled: 0),
                  SizedBox(width: 24),
                  BoldPinDots(length: 4, filled: 2),
                  SizedBox(width: 24),
                  BoldPinDots(length: 4, filled: 4),
                ])),
        _Section(
            title: 'Keypad',
            composedOf: const ['Tipografia', 'BoldIcon', 'Cores'],
            builder: (_) => BoldKeypad(onKey: (_) {}, onDelete: () {})),
      ];
    case _Cat.selecao:
      return [
        _Section(
            title: 'Checkbox',
            composedOf: const ['BoldIcon', 'Cores', 'Tipografia'],
            builder: (_) => Wrap(spacing: 20, runSpacing: 12, children: const [
                  BoldCheckbox(checked: true, label: 'Marcado'),
                  BoldCheckbox(label: 'Vazio'),
                  BoldCheckbox(indeterminate: true, label: 'Parcial'),
                  BoldCheckbox(checked: true, disabled: true, label: 'Off'),
                  BoldCheckbox(
                      checked: true,
                      variant: BoldCheckboxVariant.neutral,
                      label: 'Neutral'),
                ])),
        _Section(
            title: 'Switch',
            composedOf: const ['Cores'],
            builder: (_) => const _SwitchDemo()),
        _Section(
            title: 'Radio list',
            composedOf: const ['Cores', 'Tipografia'],
            builder: (_) => BoldRadioList(
                  title: 'Motivo',
                  value: 'oferta',
                  onChanged: (_) {},
                  options: const [
                    BoldRadioOption(
                        value: 'oferta', label: 'Oferta de outro banco'),
                    BoldRadioOption(value: 'tarifas', label: 'Tarifas'),
                    BoldRadioOption(value: 'outro', label: 'Outro motivo'),
                  ],
                )),
        _Section(
            title: 'Segmented control',
            composedOf: const ['Tipografia', 'Cores'],
            builder: (_) => const _SegmentedDemo()),
        _Section(
            title: 'Filter chip',
            composedOf: const ['Cores', 'Tipografia'],
            builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: [
                  BoldFilterChip('Todos', selected: true, onTap: () {}),
                  BoldFilterChip('Entradas', selected: false, onTap: () {}),
                  BoldFilterChip('Saídas', selected: false, onTap: () {}),
                ])),
        _Section(
            title: 'Input chip',
            composedOf: const ['Tipografia', 'BoldIcon', 'Cores'],
            builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: const [
                  BoldInputChip(label: 'R\$ 50'),
                  BoldInputChip(label: 'R\$ 100', filled: true),
                  BoldInputChip(
                      label: 'Saldo',
                      leadIcon: 'eye',
                      tone: BoldInputChipTone.neutral),
                  BoldInputChip(
                      label: 'Filtro',
                      trailIcon: 'chevron-down',
                      tone: BoldInputChipTone.neutral),
                ])),
      ];
    case _Cat.comunicacao:
      return [
        const _CatMacroHeader('STATUS'),
        _Section(
            title: 'Status tag',
            composedOf: const ['Cores', 'Tipografia'],
            builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: const [
                  BoldStatusTag(label: 'Sucesso', tone: BoldStatusTone.success),
                  BoldStatusTag(label: 'Falha', tone: BoldStatusTone.danger),
                  BoldStatusTag(label: 'Pendente', tone: BoldStatusTone.warning),
                  BoldStatusTag(label: 'Info', tone: BoldStatusTone.primary),
                  BoldStatusTag(label: 'Neutro', tone: BoldStatusTone.neutral),
                ])),
        _Section(
            title: 'Status badge',
            composedOf: const ['Cores', 'Tipografia'],
            builder: (_) => const Wrap(spacing: 8, runSpacing: 8, children: [
                  BoldStatusBadge('Concluído'),
                  BoldStatusBadge('Erro', color: BoldColors.danger),
                  BoldStatusBadge('Validada', icon: Icons.check),
                ])),
        const _CatMacroHeader('FEEDBACK & LOADING'),
        _Section(
            title: 'Spinner',
            composedOf: const ['Cores'],
            note: 'arco com gradiente + trilho · sm / md / lg',
            builder: (_) => const Row(children: [
                  BoldSpinner(size: BoldSpinnerSize.sm),
                  SizedBox(width: 20),
                  BoldSpinner(),
                  SizedBox(width: 20),
                  BoldSpinner(size: BoldSpinnerSize.lg),
                ])),
        _Section(
            title: 'Skeleton (loading)',
            composedOf: const ['Cores'],
            builder: (_) => Row(children: [
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
                ])),
        _Section(
            title: 'Progress bar',
            composedOf: const ['Cores', 'Tipografia'],
            builder: (_) => const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldProgressBar(value: 0.2, caption: '1 de 5'),
                  SizedBox(height: 14),
                  BoldProgressBar(value: 0.6, caption: '3 de 5'),
                  SizedBox(height: 14),
                  BoldProgressBar(value: 1.0, caption: 'Concluído'),
                ])),
        _Section(
            title: 'Tooltip',
            composedOf: const ['Cores', 'Tipografia'],
            builder: (_) => const Wrap(spacing: 20, runSpacing: 16, children: [
                  BoldTooltip(label: 'Dica', style: BoldTooltipStyle.dark),
                  BoldTooltip(
                      label: 'Dica',
                      style: BoldTooltipStyle.light,
                      side: BoldTooltipSide.bottom),
                ])),
        _Section(
            title: 'Alert',
            composedOf: const ['BoldSpotIcon', 'Vidro (glass)', 'Cores'],
            builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldAlert(
                      intent: BoldIntent.error,
                      title: 'Pix não enviado',
                      message: 'Saldo insuficiente.',
                      onClose: () {}),
                  const SizedBox(height: 10),
                  const BoldAlert(
                      intent: BoldIntent.success, title: 'Pix enviado'),
                  const SizedBox(height: 10),
                  const BoldAlert(
                      intent: BoldIntent.info,
                      title: 'Limite diário',
                      message: 'Até R\$ 5.000,00 por dia.'),
                ])),
        const _CatMacroHeader('BANNERS & OVERLAYS'),
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
            title: 'Notice row',
            composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
            builder: (_) => BoldNoticeRow(
                icon: 'paper-plane-light',
                title: 'Autorizações',
                subtitle: 'Veja o que está esperando você.',
                count: 3,
                onTap: () {})),
        _Section(
            title: 'Dialog / Toast (gatilhos)',
            composedOf: const ['BoldButton', 'BoldCard', 'Tipografia'],
            builder: (_) => const _OverlayDemo()),
      ];
    case _Cat.conteineres:
      return [
        const _CatMacroHeader('SUPERFÍCIE & CARDS'),
        _Section(
            title: 'Glass surface',
            composedOf: const ['Cores', 'Vidro (glass)'],
            note: 'fill + stroke + blur · característica do container',
            builder: (_) => const BoldGlassSurface(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoldIcon('home'),
                        BoldIcon('pix'),
                        BoldIcon('cards'),
                        BoldIcon('gear'),
                      ],
                    ),
                  ),
                )),
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
        const _CatMacroHeader('LISTAS & LINHAS'),
        _Section(
            title: 'List tile / group',
            composedOf: const ['BoldSpotIcon', 'BoldCard', 'Tipografia'],
            builder: (_) => BoldListGroup(title: 'Atividade', children: [
                  const BoldListTile(
                      leading: BoldSpotIcon('arrow-down-light',
                          tone: BoldSpotTone.success, filled: true),
                      title: 'Recebido de Ana',
                      subtitle: 'Hoje',
                      trailing: BoldListAmount('R\$ 560,00')),
                  const BoldListTile(
                      leading: BoldSpotIcon('arrow-up-light',
                          tone: BoldSpotTone.neutral, filled: true),
                      title: 'Boleto',
                      subtitle: 'Ontem',
                      trailing: BoldListAmount('R\$ 132,90', negative: true)),
                ])),
        _Section(
            title: 'App list — menu (grupo glass)',
            composedOf: const [
              'BoldSpotIcon',
              'BoldCard',
              'BoldIcon',
              'Tipografia'
            ],
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
            title: 'Detail row',
            composedOf: const ['BoldIcon', 'Tipografia'],
            builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BoldDetailRow(title: 'Para', description: 'Ana Silva'),
                  const BoldDetailRow(
                      title: 'Chave Pix',
                      description: 'ana@email.com',
                      icon: 'key-light'),
                  BoldDetailRow(
                      title: 'Ajuda',
                      icon: 'circle-question-light',
                      chevron: true,
                      hairline: false,
                      onTap: () {}),
                ])),
        _Section(
            title: 'Section header',
            composedOf: const ['Tipografia', 'BoldSeeAllLink'],
            builder: (_) => BoldSectionHeader(
                label: 'Enviar para',
                trailing: BoldSeeAllLink(label: 'Ver tudo', onPressed: () {}))),
        const _CatMacroHeader('SHEETS'),
        _Section(
            title: 'Bottom sheet',
            composedOf: const ['BoldGlassSurface', 'BoldIconButton'],
            note: 'BoldSheet.show(context, …) — sobe do rodapé sobre scrim',
            builder: (ctx) => BoldButton('Abrir sheet',
                expand: false,
                onPressed: () => BoldSheet.show(ctx,
                    title: 'Escolha uma conta',
                    builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BoldAppList.menuItem(
                                icon: 'user-light',
                                title: 'Conta PF',
                                subtitle: 'Ag 0001 · 12345-6',
                                onTap: () {}),
                            BoldAppList.menuItem(
                                icon: 'building-light',
                                title: 'Conta PJ',
                                subtitle: 'Ag 0001 · 67890-1',
                                onTap: () {}),
                          ],
                        )))),
        _Section(
            title: 'Password sheet (PIN)',
            composedOf: const [
              'BoldSheet',
              'BoldPinDots',
              'BoldKeypad',
              'BoldButton'
            ],
            note: 'BoldPasswordSheet.show — dots + keypad + CTA',
            builder: (ctx) => BoldButton('Confirmar com senha',
                expand: false,
                onPressed: () => BoldPasswordSheet.show(ctx,
                    subtitle: 'Digite os 6 dígitos da sua senha.',
                    onForgot: () {}))),
      ];
    case _Cat.navegacao:
      return [
        const _CatMacroHeader('TOPO'),
        _Section(
            title: 'Top bar (home)',
            composedOf: const [
              'BoldAvatar',
              'BoldIconButton',
              'Vidro',
              'Tipografia'
            ],
            builder: (_) => BoldTopBar.home(
                  firstName: 'Diletta',
                  safeArea: false,
                  accountLabel: '12345-6',
                  onOpenProfile: () {},
                  onSwitchAccount: () {},
                  icons: [
                    BoldNavRightIcon(
                        icon: 'eye-off',
                        semanticLabel: 'Ocultar',
                        onPressed: () {}),
                    BoldNavRightIcon(
                        icon: 'bell',
                        semanticLabel: 'Notificações',
                        badge: true,
                        onPressed: () {}),
                  ],
                )),
        _Section(
            title: 'Stepper',
            composedOf: const ['Tipografia', 'Cores'],
            builder: (_) => const BoldStepper(
                current: 2, total: 4, labelText: 'PASSO 2 DE 4')),
        const _CatMacroHeader('RODAPÉ & PÁGINA'),
        _Section(
            title: 'Bottom app',
            composedOf: const [
              'Vidro (glass)',
              'BoldNavigationButton',
              'BoldIcon'
            ],
            builder: (_) => Column(children: [
                  SizedBox(
                      width: 340,
                      child: BoldBottomApp.nav<int>(
                        current: 0,
                        onTap: (_) {},
                        items: const [
                          BoldTabItem(
                              value: 0,
                              label: 'Início',
                              icon: Icons.home_rounded),
                          BoldTabItem(
                              value: 1,
                              label: 'Cartões',
                              icon: Icons.credit_card),
                          BoldTabItem(
                              value: 2,
                              label: 'Pix',
                              icon: Icons.qr_code_rounded),
                          BoldTabItem(
                              value: 3,
                              label: 'Perfil',
                              icon: Icons.person_rounded),
                        ],
                      )),
                  const SizedBox(height: 12),
                  SizedBox(
                      width: 340,
                      child: BoldBottomApp.button(
                        primary:
                            BoldNavAction(label: 'Continuar', onPressed: () {}),
                        secondary:
                            BoldNavAction(label: 'Cancelar', onPressed: () {}),
                        safeBottom: false,
                      )),
                ])),
        _Section(
            title: 'Tab bar',
            composedOf: const ['BoldIcon', 'Tipografia', 'Vidro'],
            builder: (_) => const _TabBarDemo()),
        _Section(
            title: 'Home indicator',
            composedOf: const ['Cores'],
            builder: (_) => const BoldHomeIndicator()),
        _Section(
            title: 'Page dots',
            composedOf: const ['Cores'],
            builder: (_) => const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldPageDots(count: 4, activeIndex: 0),
                  SizedBox(height: 10),
                  BoldPageDots(count: 4, activeIndex: 2),
                ])),
        _Section(
            title: 'Page title',
            composedOf: const ['Tipografia'],
            builder: (_) => const BoldPageTitle(
                title: 'Quanto você quer enviar?',
                subtitle: 'O valor sai da sua conta BOLD.')),
        _Section(
            title: 'Account pill / switcher',
            composedOf: const ['BoldIcon', 'Tipografia', 'Cores'],
            builder: (_) => Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const BoldAccountPill(label: 'CONTA PF'),
                  BoldAccountPill(label: 'CONTA PJ', onTap: () {}),
                  BoldAccountSwitcher(name: 'Ana Carolina', onTap: () {}),
                ])),
      ];
    case _Cat.dominio:
      return [
        const _CatMacroHeader('IDENTIDADE & ÍCONES'),
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
            title: 'Spot icon',
            composedOf: const ['BoldIcon', 'Cores'],
            builder: (_) => Wrap(spacing: 12, runSpacing: 12, children: const [
                  BoldSpotIcon('pix-light', tone: BoldSpotTone.primary),
                  BoldSpotIcon('bank', tone: BoldSpotTone.primary, filled: true),
                  BoldSpotIcon('bell-light', tone: BoldSpotTone.success),
                  BoldSpotIcon('key-light', tone: BoldSpotTone.danger, badge: true),
                  BoldSpotIcon('shield', tone: BoldSpotTone.secure),
                  BoldSpotIcon('user-light', disabled: true),
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
            title: 'Avatar row / stack',
            composedOf: const ['BoldAvatar'],
            builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldAvatarRow(initials: const ['DL', 'HS', 'MJ'], onAdd: () {}),
                  const SizedBox(height: 16),
                  const BoldAvatarStack(initials: ['DL', 'HS', 'MJ', 'AB']),
                ])),
        _Section(
            title: 'Glass avatar',
            composedOf: const ['Vidro (glass)', 'Cores', 'Tipografia'],
            builder: (_) => Row(children: const [
                  BoldGlassAvatar(initial: 'D'),
                  SizedBox(width: 12),
                  BoldGlassAvatar(initial: 'HS', size: 56),
                ])),
        _Section(
            title: 'Icon chip',
            composedOf: const ['Gradientes', 'Cores'],
            builder: (_) => const Wrap(spacing: 12, runSpacing: 12, children: [
                  BoldIconChip(Icons.send, gradient: BoldGradients.pix),
                  BoldIconChip(Icons.qr_code, tint: BoldColors.warning04),
                  BoldIconChip.custom(
                      gradient: BoldGradients.brand,
                      child: Icon(Icons.bolt, size: 20, color: BoldColors.white)),
                ])),
        const _CatMacroHeader('VALOR & CARTEIRA'),
        _Section(
            title: 'Amount display',
            composedOf: const ['Tipografia', 'Cores'],
            builder: (_) => const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldAmountDisplay(
                      value: 'R\$ 560,00', timestamp: '13/10 às 14:25'),
                  SizedBox(height: 12),
                  BoldAmountDisplay(
                      value: 'R\$ 2.912,47',
                      label: 'Seu saldo',
                      centered: false),
                ])),
        _Section(
            title: 'Balance',
            composedOf: const [
              'BoldCard',
              'BoldStatusTag',
              'BoldIcon',
              'Tipografia'
            ],
            builder: (_) => BoldBalance(
                  value: 'R\$ 2.912,47',
                  entradas: 'R\$ 300,00',
                  saidas: 'R\$ 120,00',
                  onExtrato: () {},
                )),
        _Section(
            title: 'Comprovante (BoldReceipt)',
            composedOf: const [
              'BoldSpotIcon',
              'BoldCard',
              'BoldLogo',
              'Tipografia'
            ],
            builder: (_) => BoldCard(
                  radius: 20,
                  padding: const EdgeInsets.all(20),
                  child: const BoldReceipt(
                    title: 'Comprovante de pagamento',
                    timestamp: '14/07/2026 · 15:32',
                    rows: [
                      BoldReceiptRow(label: 'Valor', value: 'R\$ 250,00'),
                      BoldReceiptRow(label: 'Tipo de pagamento', value: 'Pix'),
                    ],
                    sections: [
                      BoldReceiptSection(icon: 'user-light', title: 'Destino', rows: [
                        BoldReceiptRow(label: 'Nome', value: 'Roberto da Silva'),
                        BoldReceiptRow(
                            label: 'CPF/CNPJ', value: '***.777.888-**'),
                      ]),
                    ],
                    footerLines: ['Conta BOLD · Instituição de pagamento'],
                    transactionId: 'E1898765420260714153210abc',
                  ),
                )),
        _Section(
            title: 'Resumo de transação',
            composedOf: const [
              'BoldTopBar',
              'BoldSpotIcon',
              'BoldAppList',
              'BoldSectionHeader',
              'BoldBottomApp'
            ],
            builder: (_) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 720,
                    child: BoldTransactionSummary(
                      title: 'Pix enviado',
                      amountText: 'R\$ 35,00',
                      subtitle: '23 de fevereiro de 2025 · 18:09',
                      sections: [
                        BoldSummarySection(label: 'Para', rows: [
                          BoldSummaryRow(
                            left: BoldLeftAccessory.custom(
                                child: const BoldGlassAvatar(
                                    initial: 'CR', size: 40, fontSize: 15)),
                            title: 'Carlos Roberto',
                            subtitle: '***.456.567-**',
                          ),
                          const BoldSummaryRow(
                            left: BoldLeftAccessory.spotIcon(
                                icon: 'bank', tone: BoldSpotTone.neutral),
                            title: 'Banco',
                            subtitle: '014 - Santander Brasil S.A.',
                          ),
                        ]),
                      ],
                      helpActions: [
                        BoldSummaryAction(
                            icon: 'messages-question-light-full',
                            title: 'Contestar transação',
                            onTap: () {}),
                      ],
                      onBack: () {},
                      onPrimary: () {},
                    ),
                  ),
                )),
        const _CatMacroHeader('SEGURANÇA'),
        _Section(
            title: 'Quantum seal',
            composedOf: const ['CustomPaint', 'Tipografia'],
            builder: (_) => Wrap(spacing: 16, runSpacing: 16, children: const [
                  BoldQuantumSeal(waiting: true, size: 110),
                  BoldQuantumSeal(waiting: false, failed: false, size: 110),
                  BoldQuantumSeal(waiting: false, failed: true, size: 110),
                ])),
        _Section(
            title: 'Quantum core',
            composedOf: const ['CustomPaint'],
            note: 'núcleo pintado (loop demo)',
            builder: (_) => const Center(
                child: SizedBox(
                    width: 200, height: 200, child: BoldQuantumCore()))),
      ];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SPECS — tabelas de spec dos componentes (matriz Type × State / faixa).
// ═══════════════════════════════════════════════════════════════════════════
class _SpecsView extends StatelessWidget {
  const _SpecsView();
  @override
  Widget build(BuildContext context) => const _SpecsTab();
}

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

// Hairline entre seções de componente. O espaçamento em cima casa com o
// `top: 28` de _Section, deixando o divider centrado no vão entre elementos.
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Divider(height: 1, thickness: 1, color: c.border),
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
  static const _tokens = {
    'Cores',
    'Tipografia',
    'Vidro',
    'Gradiente',
    'Gradientes',
    'Vidro (glass)',
  };

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

// Uma ilustração no catálogo: as variações de tema lado a lado (Wrap).
class _IllustrationRow extends StatelessWidget {
  const _IllustrationRow(this.illu);
  final _Illu illu;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final t in illu.themes) _IllustrationCard(name: illu.name, theme: t),
      ],
    );
  }
}

// Card de uma variação: SVG num quadro com fundo apropriado ao tema (as
// variações Dark/Theme 3 têm traços claros, então precisam de fundo escuro/
// tonalizado pra ler bem) + legenda do tema.
class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard({required this.name, required this.theme});
  final String name;
  final String theme;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Fundos derivados da paleta Primary do DS (nada hardcoded): claro→escuro.
    final (Color bg, String label) = switch (theme) {
      'dark' => (BoldColors.primary01, 'Dark'),
      'theme3' => (BoldColors.primary02, 'Theme 3'),
      _ => (BoldColors.primary09, 'Light'),
    };
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
        ),
        child: SvgPicture.asset(
          'lib/design_system/assets/illustrations/${name}_$theme.svg',
          fit: BoxFit.contain,
          // Cores da ilustração vêm dos tokens do DS (não do hex do arquivo).
          colorMapper: const _DsColorMapper(),
        ),
      ),
      const SizedBox(height: 6),
      Text(label, style: BoldType.labelSm.copyWith(color: c.textMuted)),
    ]);
  }
}

// Vincula as cores das ilustrações aos tokens do DS: cada hex da família
// Primary presente no SVG é substituído, no render, pelo `BoldColors.primaryXX`
// correspondente — o token vira a fonte única (mudou o token, a arte acompanha).
// O hex no arquivo é só a "chave"; line-art (cinza/preto) e acentos passam direto.
class _DsColorMapper extends ColorMapper {
  const _DsColorMapper();
  @override
  Color substitute(
      String? id, String elementName, String attributeName, Color color) {
    if (color == const Color(0xFF300313)) return BoldColors.primary01;
    if (color == const Color(0xFF600627)) return BoldColors.primary02;
    if (color == const Color(0xFFFE3976)) return BoldColors.primary04;
    if (color == const Color(0xFFF66FA0)) return BoldColors.primary05;
    if (color == const Color(0xFFFF87AB)) return BoldColors.primary06;
    if (color == const Color(0xFFFFB6CB)) return BoldColors.primary07;
    if (color == const Color(0xFFFFF6FA)) return BoldColors.primary09;
    return color;
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
// ═══════════════════════════════════════════════════════════════════════════
// SPEC SHEET — formato "print": cabeçalho (nome + descrição + "compõe:") e
// corpo (matriz de variações Type × State, ou faixa de eixo único).
// ═══════════════════════════════════════════════════════════════════════════

/// Ficha de um componente na aba Specs: nome grande, descrição, chips do que o
/// compõe e o corpo (uma [_VariantMatrix] ou [_VariantStrip]).
class _ComponentSpec extends StatelessWidget {
  const _ComponentSpec({
    required this.title,
    required this.description,
    this.composedOf,
    required this.child,
  });
  final String title;
  final String description;
  final List<String>? composedOf;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 44),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: BoldType.headlineSm.copyWith(color: c.textPrimary)),
        const SizedBox(height: 8),
        Text(description,
            style: BoldType.bodySmall
                .copyWith(color: c.textSecondary, height: 1.45)),
        if (composedOf != null && composedOf!.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('compõe:',
                  style: BoldType.labelSm.copyWith(color: c.textSecondary)),
              for (final w in composedOf!) _DepChip(name: w),
            ],
          ),
        ],
        const SizedBox(height: 24),
        child,
      ]),
    );
  }
}

/// Matriz rotulada nos dois eixos (linhas × colunas), como o print do SpotIcon.
/// Caption + rótulos roxos; o grid de hairline envolve só as células. Os
/// cabeçalhos de coluna e o grid usam a MESMA largura flexível por coluna, então
/// ficam alinhados; o eixo de linhas ("Type") é uma legenda rotacionada.
class _VariantMatrix extends StatelessWidget {
  const _VariantMatrix({
    required this.rowAxis,
    required this.rows,
    required this.colAxis,
    required this.cols,
    required this.cell,
    this.cellHeight = 78,
  });
  final String rowAxis;
  final List<String> rows;
  final String colAxis;
  final List<String> cols;
  final Widget Function(int row, int col) cell;
  final double cellHeight;

  static const double _labelW = 62; // largura da coluna de rótulos de linha
  static const double _axisW = 22; // faixa da legenda vertical ("Type")
  static const double _lead = _labelW + _axisW + 6; // recuo até a 1ª célula

  @override
  Widget build(BuildContext context) {
    // Altura fixa do corpo (evita IntrinsicHeight sobre Table flex, que lança):
    // n células + (n+1) hairlines de 1px.
    final bodyH = rows.length * cellHeight + (rows.length + 1);
    final line = BoldColors.infoSoft.withValues(alpha: 0.38);
    final axis = BoldType.labelSm
        .copyWith(color: BoldColors.infoSoft, fontWeight: FontWeight.w600);
    final cap = BoldType.labelSm.copyWith(
        color: BoldColors.infoSoft,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ── Eixo de colunas: caption "State" + cabeçalhos, alinhados ao grid ──
      Row(children: [
        const SizedBox(width: _lead),
        Expanded(child: Center(child: Text(colAxis, style: cap))),
      ]),
      const SizedBox(height: 2),
      Container(
        margin: const EdgeInsets.only(left: _lead),
        height: 1,
        color: line,
      ),
      const SizedBox(height: 4),
      Row(children: [
        const SizedBox(width: _lead),
        for (final h in cols)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              child: Center(
                  child: Text(h, textAlign: TextAlign.center, style: axis)),
            ),
          ),
      ]),
      const SizedBox(height: 2),
      // ── Corpo: legenda vertical "Type" + rótulos de linha + grid ──────────
      SizedBox(
        height: bodyH,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: _axisW,
            child: Center(
              child: RotatedBox(
                  quarterTurns: 3, child: Text(rowAxis, style: cap)),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              for (var r = 0; r < rows.length; r++)
                SizedBox(
                  width: _labelW,
                  height: cellHeight + 1, // + hairline entre linhas
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(rows[r],
                          textAlign: TextAlign.right, style: axis),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Table(
                border: TableBorder.all(color: line, width: 1),
                defaultColumnWidth: const FlexColumnWidth(),
                children: [
                  for (var r = 0; r < rows.length; r++)
                    TableRow(children: [
                      for (var col = 0; col < cols.length; col++)
                        SizedBox(
                          height: cellHeight,
                          child: Center(child: cell(r, col)),
                        ),
                    ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

/// Faixa de variação de eixo único: células rotuladas embaixo, num Wrap. Para
/// componentes que variam só numa dimensão (ex.: variantes de botão, tons).
class _VariantStrip extends StatelessWidget {
  const _VariantStrip({required this.items, this.cellWidth = 120});
  final List<(String, Widget)> items;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    final line = BoldColors.infoSoft.withValues(alpha: 0.38);
    final axis = BoldType.labelSm
        .copyWith(color: BoldColors.infoSoft, fontWeight: FontWeight.w600);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final (label, w) in items)
          SizedBox(
            width: cellWidth,
            child: Column(children: [
              Container(
                height: 74,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: line, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: w),
              ),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center, style: axis),
            ]),
          ),
      ],
    );
  }
}

class _SpecsTab extends StatelessWidget {
  const _SpecsTab();

  // Ícone canônico de demonstração da matriz (glyph de usuário, como o print).
  static Widget _spot(int row, int col) {
    final filled = row == 0;
    return switch (col) {
      0 => BoldSpotIcon('user-light', filled: filled),
      1 => BoldSpotIcon('user-light', filled: filled, disabled: true),
      2 => BoldSpotIcon('user-light',
          filled: filled, tone: BoldSpotTone.primary),
      3 => BoldSpotIcon('user-light',
          filled: filled, tone: BoldSpotTone.danger),
      4 => BoldSpotIcon('user-light',
          filled: filled, tone: BoldSpotTone.warning),
      5 => BoldSpotIcon('user-light',
          filled: filled, tone: BoldSpotTone.success),
      6 => BoldSpotIcon('user-light',
          filled: filled, tone: BoldSpotTone.primary, loading: true),
      _ => BoldSpotIcon('user-light',
          filled: filled, tone: BoldSpotTone.secure),
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: [
            const _TierHeader(
                tier: 'ÁTOMOS',
                description: 'Primitivos indivisíveis — só consomem tokens.'),
            _ComponentSpec(
              title: 'SpotIcon',
              description:
                  '2 tipos (fill · outline) × 8 estados. Tamanho padrão 34 (mobile), glyph escala pra ~58% do container. Badge é ortogonal — passe direto.',
              composedOf: const ['BoldIcon', 'Cores'],
              child: _VariantMatrix(
                rowAxis: 'Type',
                rows: const ['fill', 'outline'],
                colAxis: 'State',
                cols: const [
                  'normal',
                  'disabled',
                  'primary',
                  'error',
                  'warning',
                  'success',
                  'loading',
                  'secure',
                ],
                cell: _spot,
              ),
            ),

            // BoldIcon(String name, {double size = BoldIconSize.md, Color? color})
            _ComponentSpec(
              title: 'BoldIcon',
              description:
                  'Glyph SVG recolorido via ColorFilter — 1 eixo: o alias semântico (mapa nome→arquivo FontAwesome). Cor default = textSecondary do tema; tamanho pelo param size (BoldIconSize.xs…xxl, default md 18).',
              composedOf: const ['Cores'],
              child: _VariantStrip(
                cellWidth: 96,
                items: [
                  ('home', BoldIcon('home')),
                  ('pix', BoldIcon('pix')),
                  ('bell', BoldIcon('bell')),
                  ('eye', BoldIcon('eye')),
                  ('bank', BoldIcon('bank')),
                  ('key', BoldIcon('key')),
                  ('qr', BoldIcon('qr')),
                  ('chevron-right', BoldIcon('chevron-right')),
                  ('size 28', BoldIcon('shield', size: 28)),
                ],
              ),
            ),
            // const BoldLogo({double width = 200, bool onDark = true})
            _ComponentSpec(
              title: 'BoldLogo',
              description:
                  'Wordmark oficial CONTA/BOLD (o "O" carrega o gradiente da marca) — 1 eixo: onDark. onDark:true = wordmark branco (fundos escuros); onDark:false = wordmark preto (precisa de fundo claro atrás).',
              composedOf: const ['Cores'],
              child: _VariantStrip(
                cellWidth: 160,
                items: [
                  (
                    'onDark: true',
                    Container(
                      color: BoldColors.neutral01,
                      padding: const EdgeInsets.all(10),
                      child: const BoldLogo(width: 110),
                    ),
                  ),
                  (
                    'onDark: false',
                    Container(
                      color: BoldColors.white,
                      padding: const EdgeInsets.all(10),
                      child: const BoldLogo(width: 110, onDark: false),
                    ),
                  ),
                ],
              ),
            ),
            // const BoldPixMark({double size = BoldIconSize.lg, Color? color, bool solid = true})
            _ComponentSpec(
              title: 'BoldPixMark',
              description:
                  'Marca Pix oficial (pinwheel do BCB) sobre o mesmo grid do BoldIcon — 1 eixo: solid (preenchida, default) vs. outline. Cor default = rosa da marca.',
              composedOf: const ['BoldIcon', 'Cores'],
              child: _VariantStrip(
                items: [
                  ('solid', BoldPixMark(size: 32)),
                  ('outline', BoldPixMark(size: 32, solid: false)),
                  ('color', BoldPixMark(size: 32, color: BoldColors.primary04)),
                ],
              ),
            ),
            // const BoldGlassSurface({required Widget child})
            _ComponentSpec(
              title: 'BoldGlassSurface',
              description:
                  'A superfície "vidro" ÚNICA do DS: fill 26% + stroke 1px 30% + blur 15, theme-aware. É característica de CONTAINER (top bar, bottom app, toast) — nunca de elemento. Envolve o child.',
              composedOf: const ['Cores', 'Vidro (glass)'],
              child: const BoldGlassSurface(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoldIcon('home'),
                      BoldIcon('pix'),
                      BoldIcon('cards'),
                      BoldIcon('gear'),
                    ],
                  ),
                ),
              ),
            ),
            // const BoldHomeIndicator({Color color = BoldColors.neutral01, Color? background})
            _ComponentSpec(
              title: 'BoldHomeIndicator',
              description:
                  'Slot inferior mínimo: a barra de gesto do iOS (pill num container h34). Só tokens. color = tom do pill; background = fundo do container.',
              composedOf: const ['Cores'],
              child: _VariantStrip(
                cellWidth: 170,
                items: [
                  ('default', const BoldHomeIndicator()),
                  (
                    'sobre escuro',
                    const BoldHomeIndicator(
                      color: BoldColors.white,
                      background: BoldColors.neutral01,
                    ),
                  ),
                ],
              ),
            ),
            // const BoldPageDots({required int count, required int activeIndex, Color? activeColor, double size = 8, double spacing = BoldSpace.x2})
            _ComponentSpec(
              title: 'BoldPageDots',
              description:
                  'Indicador de página de carrossel/onboarding: o dot ativo vira uma pílula alongada no tom da marca. Presentational puro — count × activeIndex controlados pelo caller.',
              composedOf: const ['Cores'],
              child: _VariantStrip(
                cellWidth: 140,
                items: [
                  ('4 · ativo 0', const BoldPageDots(count: 4, activeIndex: 0)),
                  ('4 · ativo 2', const BoldPageDots(count: 4, activeIndex: 2)),
                  ('3 · ativo 1', const BoldPageDots(count: 3, activeIndex: 1)),
                ],
              ),
            ),
            // const BoldGlassAvatar({required String initial, double size = 40, ImageProvider? image, double? fontSize})
            _ComponentSpec(
              title: 'BoldGlassAvatar',
              description:
                  'Avatar canônico do usuário: disco de vidro (fill+stroke+blur) — inicial(is) em textPrimary quando não há foto, ou a foto cobrindo o disco quando image é passado.',
              composedOf: const ['Vidro (glass)', 'Cores', 'Tipografia'],
              child: _VariantStrip(
                items: [
                  ('inicial', const BoldGlassAvatar(initial: 'D')),
                  ('2 letras', const BoldGlassAvatar(initial: 'HS', size: 56)),
                  (
                    'foto',
                    const BoldGlassAvatar(
                      initial: 'RC',
                      size: 56,
                      image: AssetImage(
                          'lib/design_system/assets/city-cyberpunk.webp'),
                    ),
                  ),
                ],
              ),
            ),
            // const BoldCopyButton({required String text, required String semanticLabel, String label = 'Copiado', VoidCallback? onCopied})
            _ComponentSpec(
              title: 'BoldCopyButton',
              description:
                  'Botão de copiar com feedback IN-PLACE: ao tocar copia o texto e o ícone vira um check verde por ~2s. Aqui no estado idle (ícone "copy").',
              composedOf: const ['BoldIcon', 'Cores', 'Tipografia'],
              child: const SizedBox(
                height: 72,
                child: Center(
                  child: BoldCopyButton(
                    text: '0001 · 1234567-8',
                    semanticLabel: 'Copiar conta',
                    label: 'Conta copiada',
                  ),
                ),
              ),
            ),
            // const BoldSkeleton({double? width, double height = 16, double radius = 8}) · factory BoldSkeleton.circle(double size)
            _ComponentSpec(
              title: 'BoldSkeleton',
              description:
                  'Placeholder de carregamento com shimmer deslizante — 1 eixo: a forma (retângulo width/height/radius e o factory circle(size) p/ avatar/spot).',
              composedOf: const ['Cores'],
              child: _VariantStrip(
                items: [
                  ('rect', const BoldSkeleton(width: 96, height: 16)),
                  ('pill', const BoldSkeleton(width: 80, height: 20, radius: 200)),
                  ('circle', BoldSkeleton.circle(44)),
                ],
              ),
            ),
            // const BoldSwitch({required bool value, required ValueChanged<bool>? onChanged, bool accent = true})
            _ComponentSpec(
              title: 'BoldSwitch',
              description:
                  '2 eixos: accent (laranja = biometria/segurança · violeta = permissões) × estado (off · on · desabilitado). Controlado — value fixo, onChanged null desabilita.',
              composedOf: const ['Cores'],
              child: _VariantMatrix(
                rowAxis: 'Accent',
                rows: const ['laranja', 'violeta'],
                colAxis: 'Estado',
                cols: const ['off', 'on', 'disabled'],
                cellHeight: 60,
                cell: (row, col) => BoldSwitch(
                  value: col == 1,
                  accent: row == 0,
                  onChanged: col == 2 ? null : (_) {},
                ),
              ),
            ),
            // const BoldSegmentedControl({required List<String> segments, required int selectedIndex, required ValueChanged<int> onChanged})
            _ComponentSpec(
              title: 'BoldSegmentedControl',
              description:
                  'Track pílula com 2+ opções; o segmento selecionado preenche. 1 eixo: a contagem de segmentos. Controlado via selectedIndex/onChanged.',
              composedOf: const ['Cores', 'Tipografia'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldSegmentedControl(
                    segments: const ['Pessoa Física', 'Pessoa Jurídica'],
                    selectedIndex: 0,
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  BoldSegmentedControl(
                    segments: const ['Dia', 'Semana', 'Mês'],
                    selectedIndex: 1,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            // const BoldCheckbox({bool checked, bool indeterminate, bool disabled, BoldCheckboxSize size, BoldCheckboxVariant variant, String? label, String? description, ValueChanged<bool>? onChanged})
            _ComponentSpec(
              title: 'BoldCheckbox',
              description:
                  '2 eixos: variant (primary rosa-preenchido · neutral outline) × estado (vazio · marcado · parcial · desabilitado). Também há size sm/md e slots label/description.',
              composedOf: const ['Cores', 'Tipografia'],
              child: _VariantMatrix(
                rowAxis: 'Variant',
                rows: const ['primary', 'neutral'],
                colAxis: 'Estado',
                cols: const ['vazio', 'marcado', 'parcial', 'disabled'],
                cellHeight: 56,
                cell: (row, col) => BoldCheckbox(
                  variant: row == 0
                      ? BoldCheckboxVariant.primary
                      : BoldCheckboxVariant.neutral,
                  checked: col == 1 || col == 3,
                  indeterminate: col == 2,
                  disabled: col == 3,
                  onChanged: (_) {},
                ),
              ),
            ),

            const _TierHeader(
                tier: 'MOLÉCULAS',
                description: 'Combinações simples de átomos.'),
            // const BoldPageTitle({required String title, String? subtitle})
            _ComponentSpec(
              title: 'BoldPageTitle',
              description:
                  'Headline + subtítulo opcional. Fica abaixo do TopBar em telas de formulário/config.',
              composedOf: const ['Tipografia'],
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldPageTitle(title: 'Alterar senha'),
                  SizedBox(height: 20),
                  BoldPageTitle(
                      title: 'Meus dados',
                      subtitle: 'Atualize suas informações.'),
                ],
              ),
            ),
            // const BoldSectionHeader({required String label, Widget? trailing, EdgeInsetsGeometry padding})
            // const BoldSeeAllLink({VoidCallback? onPressed, String label = 'Ver todos'})
            _ComponentSpec(
              title: 'BoldSectionHeader + BoldSeeAllLink',
              description:
                  'Rótulo + slot trailing opcional (tipicamente BoldSeeAllLink "Ver todos"). Separa o conteúdo em seções.',
              composedOf: const ['Tipografia'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BoldSectionHeader(label: 'Menu'),
                  const SizedBox(height: 12),
                  BoldSectionHeader(
                      label: 'Serviços',
                      trailing: BoldSeeAllLink(onPressed: () {})),
                ],
              ),
            ),
            // const BoldButton(String label, {VoidCallback? onPressed, BoldButtonVariant variant, BoldButtonSize size, IconData? icon, String? glyph, String? trailingGlyph, bool loading, bool expand, bool filled, bool error})
            _ComponentSpec(
              title: 'BoldButton',
              description:
                  '5 variantes (primary · secondary · text · destructive · white) × 4 tamanhos (xs · sm · md · lg). expand:false aqui p/ caber; no app o default estica. A variante white ganha um fundo primary04 na célula p/ contraste.',
              composedOf: const ['BoldIcon', 'Gradientes', 'Tipografia'],
              child: _VariantMatrix(
                rowAxis: 'Variant',
                rows: const ['primary', 'secondary', 'text', 'destructive', 'white'],
                colAxis: 'Size',
                cols: const ['xs', 'sm', 'md', 'lg'],
                cellHeight: 64,
                cell: (row, col) {
                  const variants = [
                    BoldButtonVariant.primary,
                    BoldButtonVariant.secondary,
                    BoldButtonVariant.text,
                    BoldButtonVariant.destructive,
                    BoldButtonVariant.white,
                  ];
                  const sizes = [
                    BoldButtonSize.xs,
                    BoldButtonSize.sm,
                    BoldButtonSize.md,
                    BoldButtonSize.lg,
                  ];
                  final btn = BoldButton(
                    'Ação',
                    variant: variants[row],
                    size: sizes[col],
                    expand: false,
                    onPressed: () {},
                  );
                  if (variants[row] == BoldButtonVariant.white) {
                    return Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: BoldColors.primary04,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: btn,
                    );
                  }
                  return btn;
                },
              ),
            ),
            // BoldButton — estados (mesmo construtor).
            _ComponentSpec(
              title: 'BoldButton — estados',
              description:
                  'loading (spinner) · disabled (onPressed null) · destructive filled (pill vermelho sólido) · com glyph (trailingGlyph) · error (paleta destrutiva sobre qualquer variante).',
              child: _VariantStrip(
                cellWidth: 190,
                items: [
                  ('loading', const BoldButton('Enviar', loading: true, expand: false)),
                  ('disabled',
                      const BoldButton('Enviar', onPressed: null, expand: false)),
                  (
                    'destructive filled',
                    BoldButton('Revogar',
                        variant: BoldButtonVariant.destructive,
                        filled: true,
                        expand: false,
                        onPressed: () {})
                  ),
                  (
                    'com glyph',
                    BoldButton('Continuar',
                        trailingGlyph: 'chevron-right',
                        expand: false,
                        onPressed: () {})
                  ),
                  (
                    'error',
                    BoldButton('Tentar de novo',
                        error: true, expand: false, onPressed: () {})
                  ),
                ],
              ),
            ),
            // const BoldIconButton({required String icon, required String semanticLabel, BoldIconButtonType type, BoldIconButtonSize size, BoldIconButtonState state, double? iconSize, bool disabled, VoidCallback? onPressed, bool badge, double? rotate, BoldIconFlush? flush})
            _ComponentSpec(
              title: 'BoldIconButton',
              description:
                  '3 tipos (secondary · secondaryPrimary · tertiary) × 3 tamanhos (sm 32 · md 40 · lg 56). error, disabled e badge são ortogonais — ver strip abaixo.',
              composedOf: const ['BoldIcon', 'Cores'],
              child: _VariantMatrix(
                rowAxis: 'Type',
                rows: const [
                  'secondary',
                  'secondaryPrimary',
                  'tertiary',
                ],
                colAxis: 'Size',
                cols: const ['sm', 'md', 'lg'],
                cell: (row, col) {
                  const types = [
                    BoldIconButtonType.secondary,
                    BoldIconButtonType.secondaryPrimary,
                    BoldIconButtonType.tertiary,
                  ];
                  const sizes = [
                    BoldIconButtonSize.sm,
                    BoldIconButtonSize.md,
                    BoldIconButtonSize.lg,
                  ];
                  return BoldIconButton(
                    icon: 'bell',
                    semanticLabel: 'Notificações',
                    type: types[row],
                    size: sizes[col],
                    onPressed: () {},
                  );
                },
              ),
            ),
            // BoldIconButton — error / disabled / badge (mesmo construtor).
            _ComponentSpec(
              title: 'BoldIconButton — estados & badge',
              description:
                  'error (BoldIconButtonState.error) · disabled (disabled:true) · badge (dot de notificação).',
              child: _VariantStrip(
                cellWidth: 110,
                items: [
                  (
                    'error',
                    BoldIconButton(
                        icon: 'bell',
                        semanticLabel: 'Erro',
                        state: BoldIconButtonState.error,
                        onPressed: () {})
                  ),
                  (
                    'disabled',
                    const BoldIconButton(
                        icon: 'bell',
                        semanticLabel: 'Desabilitado',
                        disabled: true)
                  ),
                  (
                    'badge',
                    BoldIconButton(
                        icon: 'bell',
                        semanticLabel: 'Notificações',
                        badge: true,
                        onPressed: () {})
                  ),
                ],
              ),
            ),
            // const BoldTextField({String? label, String? hint, TextEditingController? controller, bool obscureText, Widget? suffixIcon, IconData? prefixIcon, String? errorText, bool readOnly, bool enabled, bool mono, ...})
            _ComponentSpec(
              title: 'BoldTextField',
              description:
                  'Label + hint. Estados: default · erro (errorText) · disabled (enabled:false) · obscure (senha + suffix) · readOnly · mono+prefix (CPF/códigos). Focus acende o anel; erro troca p/ vermelho.',
              composedOf: const ['BoldIcon', 'Tipografia'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldTextField(
                      label: 'Nome',
                      hint: 'Digite seu nome',
                      controller: TextEditingController(text: 'Ana')),
                  const SizedBox(height: 16),
                  BoldTextField(
                      label: 'E-mail',
                      hint: 'voce@email.com',
                      errorText: 'E-mail inválido',
                      controller: TextEditingController(text: 'ana@')),
                  const SizedBox(height: 16),
                  const BoldTextField(
                      label: 'Campo desabilitado',
                      hint: 'Indisponível',
                      enabled: false),
                  const SizedBox(height: 16),
                  BoldTextField(
                      label: 'Senha',
                      hint: '••••••',
                      obscureText: true,
                      suffixIcon: const Icon(Icons.visibility_off, size: 20),
                      controller: TextEditingController(text: 'segredo')),
                  const SizedBox(height: 16),
                  BoldTextField(
                      label: 'Chave Pix (somente leitura)',
                      readOnly: true,
                      mono: true,
                      controller: TextEditingController(text: 'ana@bold.com')),
                  const SizedBox(height: 16),
                  BoldTextField(
                      label: 'CPF (mono)',
                      mono: true,
                      prefixIcon: Icons.badge_outlined,
                      controller:
                          TextEditingController(text: '123.456.789-00')),
                ],
              ),
            ),
            // const BoldCurrencyField({TextEditingController? controller, double? initialValue, ValueChanged<double>? onChanged, bool large, String? Function(String?)? validator})
            _ComponentSpec(
              title: 'BoldCurrencyField',
              description:
                  'Campo de valor em centavos: "R\$ " fixo, formata milhar/decimal. large:true = número hero; false = médio.',
              child: _VariantStrip(
                cellWidth: 260,
                items: [
                  ('large: false', const BoldCurrencyField(initialValue: 1234.56)),
                  ('large: true',
                      const BoldCurrencyField(large: true, initialValue: 1234.56)),
                ],
              ),
            ),
            // const BoldSearchInput({required TextEditingController controller, String placeholder, ValueChanged<String>? onChanged, ValueChanged<String>? onSubmitted, FocusNode? focusNode, bool error})
            _ComponentSpec(
              title: 'BoldSearchInput',
              description:
                  'Busca compacta (lupa + placeholder inline, pill); o X limpa quando há texto. error:true = borda vermelha.',
              composedOf: const ['BoldIcon'],
              child: _VariantStrip(
                cellWidth: 260,
                items: [
                  (
                    'default',
                    BoldSearchInput(
                        controller: TextEditingController(),
                        placeholder: 'Buscar serviço…')
                  ),
                  (
                    'error',
                    BoldSearchInput(
                        controller: TextEditingController(text: 'xyz'),
                        error: true)
                  ),
                ],
              ),
            ),
            // const BoldOtpInput({required String value, String? error, int length = 6})
            _ComponentSpec(
              title: 'BoldOtpInput',
              description:
                  '6 boxes; preenchido · próximo (primário) · erro (danger + mensagem). Visual apenas — a digitação vem de um keypad externo.',
              child: _VariantStrip(
                cellWidth: 340,
                items: [
                  ('preenchendo', const BoldOtpInput(value: '123')),
                  ('erro',
                      const BoldOtpInput(value: '12345', error: 'Código incorreto')),
                ],
              ),
            ),
            // const BoldKeypad({required ValueChanged<String> onKey, required VoidCallback onDelete, bool compact})
            _ComponentSpec(
              title: 'BoldKeypad',
              description:
                  'Teclado numérico 3 colunas + apagar. Input puro — ligue onKey/onDelete. compact:true p/ sheets de PIN.',
              child: _VariantStrip(
                cellWidth: 240,
                items: [
                  ('default', BoldKeypad(onKey: (_) {}, onDelete: () {})),
                  ('compact',
                      BoldKeypad(compact: true, onKey: (_) {}, onDelete: () {})),
                ],
              ),
            ),
            // const BoldPinDots({required int length, required int filled})
            _ComponentSpec(
              title: 'BoldPinDots',
              description:
                  'Fileira de dots de PIN; preenche filled de length (aceso = primário, apagado = anel muted).',
              child: _VariantStrip(
                cellWidth: 160,
                items: [
                  ('0 / 4', const BoldPinDots(length: 4, filled: 0)),
                  ('2 / 4', const BoldPinDots(length: 4, filled: 2)),
                  ('4 / 4', const BoldPinDots(length: 4, filled: 4)),
                ],
              ),
            ),
            // enum BoldStatusTone { warning, neutral, primary, success, danger }
            _ComponentSpec(
              title: 'BoldStatusTag',
              description:
                  'Pill de status semântico (tom + label + ícone opcional). 1 eixo: BoldStatusTone. Acessório de listas/rows.',
              composedOf: const ['BoldIcon', 'Cores', 'Tipografia'],
              child: const _VariantStrip(
                cellWidth: 130,
                items: [
                  ('neutral', BoldStatusTag(label: 'Neutro', tone: BoldStatusTone.neutral)),
                  ('primary', BoldStatusTag(label: 'Ativo', tone: BoldStatusTone.primary)),
                  ('success', BoldStatusTag(label: 'R\$ 300,00', tone: BoldStatusTone.success, icon: 'arrow-trend-up-light')),
                  ('warning', BoldStatusTag(label: 'Pendente', tone: BoldStatusTone.warning)),
                  ('danger', BoldStatusTag(label: 'Recusado', tone: BoldStatusTone.danger)),
                ],
              ),
            ),
            // const BoldStatusBadge(String label, {Color color = BoldColors.success, IconData? icon})
            _ComponentSpec(
              title: 'BoldStatusBadge',
              description:
                  'Badge tintado por intent (bg 14% + label bold). Eixos: cor semântica e ícone opcional (IconData).',
              composedOf: const ['Cores', 'Tipografia'],
              child: const _VariantStrip(
                cellWidth: 150,
                items: [
                  ('default (success)', BoldStatusBadge('Concluído')),
                  ('color', BoldStatusBadge('Erro', color: BoldColors.danger)),
                  ('icon', BoldStatusBadge('Chave validada', icon: Icons.check)),
                ],
              ),
            ),
            // const BoldFilterChip(String label, {required bool selected, required VoidCallback onTap})
            _ComponentSpec(
              title: 'BoldFilterChip',
              description:
                  'Chip de filtro multi-seleção (pill). Ativo preenche + border primário; 1 eixo: selected. Controlado — selected fixo aqui.',
              composedOf: const ['Cores', 'Tipografia'],
              child: _VariantStrip(
                cellWidth: 140,
                items: [
                  ('selected: false',
                      BoldFilterChip('Todos', selected: false, onTap: () {})),
                  ('selected: true',
                      BoldFilterChip('Entradas', selected: true, onTap: () {})),
                ],
              ),
            ),
            // enum BoldInputChipTone { primary, neutral, ghost }
            // const BoldInputChip({required String label, String? trailIcon, String? leadIcon, BoldInputChipTone tone, bool filled, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldInputChip',
              description:
                  'Chip pill interativo (dropdown de contexto, filtro removível). Eixos: tone (primary/neutral/ghost) + filled + lead/trailIcon.',
              composedOf: const ['BoldIcon', 'Vidro (glass)', 'Tipografia'],
              child: const _VariantStrip(
                cellWidth: 160,
                items: [
                  ('primary', BoldInputChip(label: 'Conta PF', trailIcon: 'chevron-down')),
                  ('primary · filled', BoldInputChip(label: '15 dias', trailIcon: 'circle-minus-light', filled: true)),
                  ('neutral (glassy)', BoldInputChip(label: 'Seu saldo', leadIcon: 'eye', tone: BoldInputChipTone.neutral)),
                  ('ghost', BoldInputChip(label: 'Extrato', trailIcon: 'chevron-right', tone: BoldInputChipTone.ghost)),
                ],
              ),
            ),
            // const BoldCard({required Widget child, EdgeInsetsGeometry padding, VoidCallback? onTap, Gradient? gradient, Color? color, Color? borderColor, double radius, List<BoxShadow>? shadow, bool glass, bool highlight})
            _ComponentSpec(
              title: 'BoldCard',
              description:
                  'Superfície base: surface + hairline, radius 24. Variantes: plain sólido, glass (default calmo / highlight rosa), gradient e onTap (clicável).',
              composedOf: const ['BoldCardSurface', 'Vidro (glass)', 'Cores'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BoldCard(child: Text('plain — surface sólido + hairline')),
                  const SizedBox(height: 12),
                  const BoldCard(glass: true, child: Text('glass — default sóbrio (stroke cinza)')),
                  const SizedBox(height: 12),
                  const BoldCard(glass: true, highlight: true, child: Text('glass · highlight — destaque (stroke rosa)')),
                  const SizedBox(height: 12),
                  const BoldCard(gradient: BoldGradients.brand, child: Text('gradient — hero (brand sunset)')),
                  const SizedBox(height: 12),
                  BoldCard(onTap: () {}, child: const Text('onTap — bloco clicável (InkWell)')),
                ],
              ),
            ),
            // const BoldIconChip(IconData icon, {Gradient? gradient, Color? tint, double size, double iconSize})
            // const BoldIconChip.custom({required Widget child, Gradient? gradient, Color? tint, double size, double iconSize})
            _ComponentSpec(
              title: 'BoldIconChip',
              description:
                  'Chip de ícone arredondado (leading de action cards). Variantes: gradient (featured), tint (suave) e .custom (glyph/SVG próprio).',
              composedOf: const ['Gradientes', 'Cores'],
              child: const _VariantStrip(
                cellWidth: 120,
                items: [
                  ('gradient', BoldIconChip(Icons.send, gradient: BoldGradients.pix)),
                  ('tint', BoldIconChip(Icons.qr_code, tint: BoldColors.warning04)),
                  ('.custom', BoldIconChip.custom(gradient: BoldGradients.brand, child: Icon(Icons.bolt, size: 20, color: BoldColors.white))),
                ],
              ),
            ),
            // BoldListGroup({required List<Widget> children, String? title}) + BoldListTile({Widget? leading, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap, bool enabled})
            _ComponentSpec(
              title: 'BoldListTile · BoldListGroup',
              description:
                  'Card que empilha rows (leading spot + título/subtítulo + trailing) com hairline. Trailing: chevron (onTap), BoldListAmount ±, BoldListTime, BoldListTimeStatus.',
              composedOf: const ['BoldSpotIcon', 'BoldCard', 'BoldStatusTag', 'BoldIcon'],
              child: BoldListGroup(
                title: 'Atividade',
                children: [
                  BoldListTile(
                    leading: const BoldSpotIcon('pix', tone: BoldSpotTone.primary),
                    title: 'Fazer um Pix',
                    subtitle: 'Transferência instantânea',
                    onTap: () {},
                  ),
                  const BoldListTile(
                    leading: BoldSpotIcon('arrow-down-light', tone: BoldSpotTone.success, filled: true),
                    title: 'Recebido de Ana',
                    subtitle: 'Hoje',
                    trailing: BoldListAmount('R\$ 560,00'),
                  ),
                  const BoldListTile(
                    leading: BoldSpotIcon('arrow-up-light', tone: BoldSpotTone.neutral, filled: true),
                    title: 'Pagamento boleto',
                    subtitle: 'Ontem',
                    trailing: BoldListAmount('R\$ 132,90', negative: true),
                  ),
                  const BoldListTile(
                    leading: BoldSpotIcon('mobile-light', tone: BoldSpotTone.primary),
                    title: 'Recarga celular',
                    trailing: BoldListTime('14min'),
                  ),
                  const BoldListTile(
                    leading: BoldSpotIcon('clock-light', tone: BoldSpotTone.warning),
                    title: 'Transferência TED',
                    trailing: BoldListTimeStatus(
                      time: '12:04',
                      status: BoldStatusTagData(label: 'Concluído', tone: BoldStatusTone.success),
                    ),
                  ),
                ],
              ),
            ),
            // BoldAppList.menuItem/activityItem/transactionItem/profileBanner + BoldAppListGroup({required List<Widget> children, String? title})
            _ComponentSpec(
              title: 'BoldAppList',
              description:
                  'Row componível (left/middle/right) via factories: menuItem, activityItem, transactionItem e profileBanner (standalone). Rows full-width.',
              composedOf: const ['BoldSpotIcon', 'BoldStatusTag', 'BoldCard', 'Tipografia'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldAppListGroup(
                    title: 'Factories',
                    children: [
                      BoldAppList.menuItem(icon: 'pix-light', title: 'Fazer um Pix', subtitle: 'Instantâneo', onTap: () {}),
                      BoldAppList.activityItem(
                        icon: 'arrow-down-light',
                        iconTone: BoldSpotTone.success,
                        title: 'Recebido de Ana',
                        subtitle: 'Pix',
                        time: '14min',
                        status: const BoldStatusTagData(label: 'Concluído', tone: BoldStatusTone.success),
                      ),
                      BoldAppList.transactionItem(
                        title: 'Mercado Central',
                        source: 'Pix',
                        time: '11:34',
                        amount: 'R\$ 89,90',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BoldAppList.profileBanner(initials: 'CM', name: 'Carla Mendes', subtitle: 'Ver perfil', onTap: () {}),
                ],
              ),
            ),
            // const BoldAmountDisplay({required String value, String? timestamp, String? label, bool centered})
            _ComponentSpec(
              title: 'BoldAmountDisplay',
              description:
                  'Bloco de valor entre hairlines: valor grande + timestamp/label opcionais. Eixos: centered (comprovante) x alinhado à esquerda (header de extrato).',
              composedOf: const ['Tipografia', 'Cores'],
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldAmountDisplay(value: 'R\$ 560,00', timestamp: '13/10/2023 às 14:25'),
                  SizedBox(height: 16),
                  BoldAmountDisplay(value: 'R\$ 2.912,47', label: 'Seu saldo', centered: false),
                ],
              ),
            ),
            // const BoldDetailRow({required String title, String? description, String? icon, bool chevron, bool hairline, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldDetailRow',
              description:
                  'Row de detalhe título/descrição com hairline inferior (detalhe de transação, dados do cartão). Spot à esquerda e chevron opcionais.',
              composedOf: const ['BoldSpotIcon', 'BoldIcon', 'Tipografia'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BoldDetailRow(title: 'Para', description: 'Ana Silva'),
                  const BoldDetailRow(title: 'Valor', description: 'R\$ 300,67'),
                  const BoldDetailRow(title: 'Chave Pix', description: 'ana@email.com', icon: 'key-light'),
                  BoldDetailRow(title: 'Ajuda', icon: 'circle-question-light', chevron: true, hairline: false, onTap: () {}),
                ],
              ),
            ),
            // const BoldReceipt({required String title, required String timestamp, String icon, BoldSpotTone statusTone, List<BoldReceiptRow> rows, List<BoldReceiptSection> sections, List<String> footerLines, String? transactionId})
            _ComponentSpec(
              title: 'BoldReceipt',
              description:
                  'Comprovante (organismo): spot de status + título + timestamp + rows label/valor + seções + rodapé institucional com ID e logo. statusTone dá o estado.',
              composedOf: const ['BoldSpotIcon', 'BoldCard', 'BoldLogo', 'Tipografia'],
              child: const BoldReceipt(
                title: 'Comprovante de pagamento',
                timestamp: '24 Out 2022 - 11:34:32',
                statusTone: BoldSpotTone.success,
                rows: [
                  BoldReceiptRow(label: 'Valor', value: 'R\$ 300,67'),
                  BoldReceiptRow(label: 'Tipo de pagamento', value: 'Pix'),
                ],
                sections: [
                  BoldReceiptSection(
                    icon: 'user-light',
                    title: 'Destino',
                    rows: [
                      BoldReceiptRow(label: 'Nome', value: 'Ana Silva'),
                      BoldReceiptRow(label: 'Instituição', value: 'Banco BOLD'),
                    ],
                  ),
                ],
                footerLines: ['BOLD Instituição de Pagamento S.A.', 'CNPJ 00.000.000/0001-00'],
                transactionId: 'E1234567890',
              ),
            ),
            // const BoldProgressBar({required double value, String? caption, bool onGlass})
            _ComponentSpec(
              title: 'BoldProgressBar',
              description:
                  'Trilho h5 + preenchimento (0..1) + caption opcional. onGlass = skin claro sobre foto. 1 eixo: value.',
              composedOf: const ['Cores', 'Tipografia'],
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldProgressBar(value: 0.2, caption: '1 de 5 confirmados'),
                  SizedBox(height: 16),
                  BoldProgressBar(value: 0.6, caption: '3 de 5 confirmados'),
                  SizedBox(height: 16),
                  BoldProgressBar(value: 1.0, caption: 'Concluído'),
                ],
              ),
            ),
            // const BoldRadioList({required List<BoldRadioOption> options, required String? value, required ValueChanged<String> onChanged, String? title})
            _ComponentSpec(
              title: 'BoldRadioList',
              description:
                  'Lista single-select com título opcional; a opção marcada pinta ring+dot primário. Controlado — value fixo aqui.',
              composedOf: const ['Cores', 'Tipografia'],
              child: BoldRadioList(
                title: 'Selecione o motivo',
                value: 'oferta',
                onChanged: (_) {},
                options: const [
                  BoldRadioOption(value: 'oferta', label: 'Recebi oferta de outro banco'),
                  BoldRadioOption(value: 'tarifas', label: 'Preço das tarifas'),
                  BoldRadioOption(value: 'outro', label: 'Outro motivo'),
                ],
              ),
            ),
            // enum BoldTooltipSide { top, right, bottom, left } · BoldTooltipStyle { dark, light } · BoldTooltipSize { big, small, xsmall }
            // const BoldTooltip({required String label, BoldTooltipSide side, BoldTooltipSize size, BoldTooltipStyle style, bool tail})
            _ComponentSpec(
              title: 'BoldTooltip',
              description:
                  'Label flutuante com tail. Dois eixos ortogonais: style (dark/light) × side (top/right/bottom/left). Posicionamento é do caller.',
              composedOf: const ['Cores', 'Tipografia'],
              child: _VariantMatrix(
                rowAxis: 'Style',
                rows: const ['dark', 'light'],
                colAxis: 'Side',
                cols: const ['top', 'right', 'bottom', 'left'],
                cellHeight: 92,
                cell: (row, col) => BoldTooltip(
                  label: 'Dica',
                  style: row == 0 ? BoldTooltipStyle.dark : BoldTooltipStyle.light,
                  side: const [
                    BoldTooltipSide.top,
                    BoldTooltipSide.right,
                    BoldTooltipSide.bottom,
                    BoldTooltipSide.left,
                  ][col],
                ),
              ),
            ),
            // enum BoldMenuTileSize { compact, wide, large }
            // const BoldMenuTile({required String icon, required String label, VoidCallback? onTap, BoldMenuTileSize size})
            _ComponentSpec(
              title: 'BoldMenuTile',
              description:
                  'Card glass alinhado à esquerda (ícone + label). 1 eixo: size (compact / wide / large).',
              composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
              child: _VariantStrip(
                cellWidth: 160,
                items: [
                  ('compact', BoldMenuTile(icon: 'qrcode-light', label: 'Ler QR', size: BoldMenuTileSize.compact, onTap: () {})),
                  ('wide', BoldMenuTile(icon: 'pix-light', label: 'Fazer um Pix', size: BoldMenuTileSize.wide, onTap: () {})),
                  ('large', BoldMenuTile(icon: 'barcode-light', label: 'Pagar conta', size: BoldMenuTileSize.large, onTap: () {})),
                ],
              ),
            ),
            // const BoldAvatarStack({required List<String> initials, double size, double overlap, bool bordered})
            _ComponentSpec(
              title: 'BoldAvatarStack',
              description:
                  'Mini-avatares de iniciais empilhados com overlap. 1 eixo: bordered (anel branco) true/false.',
              composedOf: const ['Gradientes', 'Tipografia'],
              child: const _VariantStrip(
                cellWidth: 160,
                items: [
                  ('bordered: true', BoldAvatarStack(initials: ['CM', 'BL', 'RS'])),
                  ('bordered: false', BoldAvatarStack(initials: ['CM', 'BL', 'RS'], bordered: false)),
                ],
              ),
            ),
            // const BoldAvatarRow({required List<String> initials, List<String>? labels, List<String>? sublabels, double size, ValueChanged<int>? onTapAvatar, VoidCallback? onAdd})
            _ComponentSpec(
              title: 'BoldAvatarRow',
              description:
                  'Fileira "Enviar para": avatares + botão-spot tracejado (adicionar). Formas: compacta (só avatares) e rotulada (nome + banco).',
              composedOf: const ['Gradientes', 'BoldIcon', 'Tipografia'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldAvatarRow(initials: const ['CM', 'BL', 'RS'], onAdd: () {}),
                  const SizedBox(height: 16),
                  BoldAvatarRow(
                    initials: const ['CM', 'BL'],
                    labels: const ['Carla', 'Bruno'],
                    sublabels: const ['Nubank', 'Itaú'],
                    onAdd: () {},
                  ),
                ],
              ),
            ),
            // const BoldEmptyState({required String title, required String caption, String icon})
            _ComponentSpec(
              title: 'BoldEmptyState',
              description:
                  'Estado vazio de lista: card glass com spot circular + título + caption, centralizado.',
              composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
              child: const BoldEmptyState(
                title: 'Nada por aqui',
                caption: 'Suas transações aparecerão aqui.',
              ),
            ),
            // enum BoldIntent { error, warning, success, info }
            // const BoldAlert({required BoldIntent intent, required String title, String? message, VoidCallback? onClose})
            _ComponentSpec(
              title: 'BoldAlert',
              description:
                  'Aviso inline glass tintado por intent (error/warning/success/info): wash + border + spot no tom. onClose opcional. Componente largo. (BoldToast usa os mesmos intents via BoldToast.show — API imperativa.)',
              composedOf: const ['BoldSpotIcon', 'BoldIcon', 'Vidro (glass)', 'Cores'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BoldAlert(
                    intent: BoldIntent.error,
                    title: 'Não foi possível enviar o Pix',
                    message: 'Saldo insuficiente para esta transferência.',
                    onClose: () {},
                  ),
                  const SizedBox(height: 12),
                  const BoldAlert(intent: BoldIntent.warning, title: 'Chave a expirar', message: 'Revalide sua chave Pix em 3 dias.'),
                  const SizedBox(height: 12),
                  const BoldAlert(intent: BoldIntent.success, title: 'PIX enviado'),
                  const SizedBox(height: 12),
                  const BoldAlert(intent: BoldIntent.info, title: 'Limite diário', message: 'Você pode transferir até R\$ 5.000,00 por dia.'),
                ],
              ),
            ),

            const _TierHeader(
                tier: 'ORGANISMOS',
                description: 'Composições em superfície — consomem moléculas.'),
            // BoldCircleButton(String icon, {VoidCallback? onTap, bool dot, bool active, double size, double iconSize})
            _ComponentSpec(
              title: 'BoldCircleButton',
              description:
                  'Botão redondo glass da top bar, com ponto de notificação (dot) e tint de marca quando active. 1 eixo: estado.',
              composedOf: const ['BoldIcon', 'Cores'],
              child: _VariantStrip(
                cellWidth: 96,
                items: [
                  ('base', BoldCircleButton('bell', onTap: () {})),
                  ('dot', BoldCircleButton('bell', dot: true, onTap: () {})),
                  ('active', BoldCircleButton('edit', active: true, onTap: () {})),
                ],
              ),
            ),
            // BoldAvatar({String? initials, ImageProvider? image, double size, bool gear, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldAvatar',
              description:
                  'Avatar de perfil: imagem se houver, senão iniciais sobre gradiente de marca. gear anexa um badge de configurações.',
              composedOf: const ['Gradientes', 'BoldIcon', 'Tipografia'],
              child: _VariantStrip(
                cellWidth: 96,
                items: [
                  ('initials', const BoldAvatar(initials: 'AC')),
                  ('image', BoldAvatar(image: const AssetImage('lib/design_system/assets/city-cyberpunk.webp'))),
                  ('gear', const BoldAvatar(initials: 'AC', gear: true)),
                ],
              ),
            ),
            // BoldAccountPill({required String label, Color color, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldAccountPill',
              description:
                  'Pill sólida que expõe a conta ativa (PF/PJ). Ganha chevron quando onTap abre o seletor. Fill sólido + texto branco p/ ler sobre o header.',
              composedOf: const ['BoldIcon', 'Tipografia'],
              child: _VariantStrip(
                cellWidth: 120,
                items: [
                  ('estático', const BoldAccountPill(label: 'CONTA PF')),
                  ('com seletor', BoldAccountPill(label: 'CONTA PJ', onTap: () {})),
                ],
              ),
            ),
            // BoldAccountSwitcher({required String name, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldAccountSwitcher',
              description:
                  'O nome da conta COMO seletor: pill com tint de marca + chevron-down. Emparelhe com um "Olá," acima no header da home.',
              composedOf: const ['BoldIcon', 'Tipografia', 'Cores'],
              child: SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Olá,', style: BoldType.bodySmall),
                    const SizedBox(height: 4),
                    BoldAccountSwitcher(name: 'Ana Carolina', onTap: () {}),
                  ],
                ),
              ),
            ),
            // BoldBalance({required String value, bool hidden, VoidCallback? onExtrato, String? entradas, String? saidas, bool loading, bool statsLoading})
            _ComponentSpec(
              title: 'BoldBalance',
              description:
                  'Card de saldo (glass) da home: label + Extrato, valor em Headline e pills de entradas/saídas. Reflete hidden, e tem skeletons de valor (loading) e de totais (statsLoading).',
              composedOf: const ['BoldCard', 'BoldStatusTag', 'BoldSkeleton', 'BoldIcon'],
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BoldBalance(value: 'R\$ 2.912,47', onExtrato: () {}, entradas: 'R\$ 300,00', saidas: 'R\$ 180,00'),
                    const SizedBox(height: 12),
                    BoldBalance(value: 'R\$ 2.912,47', hidden: true, onExtrato: () {}, entradas: 'R\$ 300,00', saidas: 'R\$ 180,00'),
                    const SizedBox(height: 12),
                    BoldBalance(value: 'R\$ 2.912,47', onExtrato: () {}, loading: true, statsLoading: true),
                  ],
                ),
              ),
            ),
            // BoldNoticeRow({required String icon, required String title, String? subtitle, int? count, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldNoticeRow',
              description:
                  'Linha-aviso glass da home: ícone-tile + título/subtítulo e badge de contagem opcional (some se null ou 0). Full-width.',
              composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BoldNoticeRow(icon: 'paper-plane-light', title: 'Autorizações', subtitle: 'Veja o que está esperando você.', count: 8, onTap: () {}),
                    const SizedBox(height: 12),
                    BoldNoticeRow(icon: 'paper-plane-light', title: 'Autorizações', subtitle: 'Nada pendente no momento.', onTap: () {}),
                  ],
                ),
              ),
            ),
            // BoldPromoBanner({required String title, String? subtitle, required String primaryLabel, required String secondaryLabel, List<String> avatars, int? moreCount, VoidCallback? onPrimary, VoidCallback? onSecondary, VoidCallback? onClose})
            _ComponentSpec(
              title: 'BoldPromoBanner',
              description:
                  'Banner de destaque (gradiente de marca) com título/subtítulo, cluster de avatares + contagem, dois CTAs e X de fechar. Full-width.',
              composedOf: const ['BoldButton', 'BoldAvatarStack', 'BoldIcon'],
              child: SizedBox(
                width: 320,
                child: BoldPromoBanner(
                  title: 'Veja as pessoas próximas',
                  subtitle: 'Realize transações :)',
                  primaryLabel: 'Enviar dinheiro',
                  secondaryLabel: 'Receber',
                  avatars: const ['CM', 'BL'],
                  moreCount: 400,
                  onPrimary: () {},
                  onSecondary: () {},
                  onClose: () {},
                ),
              ),
            ),
            // BoldPromoCard({required String title, String? subtitle, Widget? illustration, VoidCallback? onClose, VoidCallback? onTap})
            _ComponentSpec(
              title: 'BoldPromoCard',
              description:
                  'Card de atenção/promoção do carrossel: título Headline + subtítulo, ilustração (placeholder se null) e X. Mesmo gradiente do banner, SEM botões.',
              composedOf: const ['BoldIcon', 'Cores', 'Tipografia'],
              child: SizedBox(
                width: 320,
                child: BoldPromoCard(
                  title: 'Habilite sua biometria',
                  subtitle: 'O melhor de dois mundos',
                  onClose: () {},
                  onTap: () {},
                ),
              ),
            ),
            // BoldTopBar.page / .home / .stepper / .sheet
            _ComponentSpec(
              title: 'BoldTopBar',
              description:
                  'Organismo do slot superior (glass + BoldNavTopBar + stepper opcional). Named ctors: .page (back + título), .home (conta + saudação), .stepper (page + progresso) e .sheet (cabeçalho de bottom sheet).',
              composedOf: const ['BoldGlassSurface', 'BoldNavTopBar', 'BoldStepper'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 340, child: BoldTopBar.page(title: 'Menu completo', onBack: () {})),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 340,
                    child: BoldTopBar.home(
                      firstName: 'Ana',
                      accountLabel: '0001·9',
                      onSwitchAccount: () {},
                      onOpenProfile: () {},
                      icons: [
                        BoldNavRightIcon(icon: 'bell', semanticLabel: 'Notificações', badge: true, onPressed: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(width: 340, child: BoldTopBar.stepper(title: 'Abrir conta', onBack: () {}, current: 2, total: 4)),
                  const SizedBox(height: 12),
                  SizedBox(width: 340, child: BoldTopBar.sheet(title: 'Escolha uma conta', onClose: () {})),
                ],
              ),
            ),
            // BoldBottomApp.nav / .button / .keyboard / .buttonAndKeyboard / .child + BoldTabItem
            _ComponentSpec(
              title: 'BoldBottomApp + BoldTabItem',
              description:
                  'Organismo do slot inferior (glass + home indicator). Named ctors: .nav (tabs — a ativa ganha spot rosa), .button (1–3 CTAs), .keyboard (teclado), .buttonAndKeyboard e .child (escape hatch).',
              composedOf: const ['BoldGlassSurface', 'BoldNavigationButton', 'BoldKeypad'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 340,
                    child: BoldBottomApp.nav<int>(
                      current: 0,
                      onTap: (_) {},
                      items: const [
                        BoldTabItem(value: 0, label: 'Início', icon: Icons.home_rounded),
                        BoldTabItem(value: 1, label: 'Cartões', icon: Icons.credit_card),
                        BoldTabItem(value: 2, label: 'Pix', icon: Icons.qr_code_rounded),
                        BoldTabItem(value: 3, label: 'Perfil', icon: Icons.person_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 340,
                    child: BoldBottomApp.button(
                      primary: BoldNavAction(label: 'Continuar', onPressed: () {}),
                      secondary: BoldNavAction(label: 'Cancelar', onPressed: () {}),
                      homeIndicator: true,
                      safeBottom: false,
                    ),
                  ),
                ],
              ),
            ),
            // BoldDialog.confirm — API IMPERATIVA (showDialog); sem forma de widget p/ preview.
            _ComponentSpec(
              title: 'BoldDialog',
              description:
                  'Diálogo de confirmação crítica (ícone + título + descrição + cancelar/ação). API IMPERATIVA: await BoldDialog.confirm(context, ...) — sem forma de widget inline.',
              composedOf: const ['BoldButton', 'Tipografia', 'Cores'],
              child: Text(
                'BoldDialog.confirm(context, …) → Future<bool>. Acionado via showDialog; não renderiza standalone.',
                style: BoldType.bodySmall,
              ),
            ),

            const _TierHeader(
                tier: 'MOTION / especiais',
                description:
                    'Autorização Quântica — visual violeta, independente da marca.'),
            // BoldQuantumSeal({bool waiting, bool failed, VoidCallback? onCompleted, VoidCallback? onFailed, double size, bool showLabel, String label, String failLabel})
            _ComponentSpec(
              title: 'BoldQuantumSeal',
              description:
                  'Selo de autorização quântica (sobreposto à transação). Três estados por waiting+failed: securing (loop), sucesso (verde, check) e falha (vermelho, X).',
              composedOf: const ['CustomPaint', 'Tipografia'],
              child: const _VariantStrip(
                cellWidth: 150,
                items: [
                  ('waiting', BoldQuantumSeal(waiting: true, size: 120)),
                  ('success', BoldQuantumSeal(waiting: false, failed: false, size: 120)),
                  ('failed', BoldQuantumSeal(waiting: false, failed: true, size: 120)),
                ],
              ),
            ),
            // BoldQuantumCore({double? progress}) · BoldQuantumPairingScreen({double? progress, ...}) — tela cheia
            _ComponentSpec(
              title: 'BoldQuantumCore + BoldQuantumPairingScreen',
              description:
                  'Animação de pareamento pós-quântico. Core = núcleo pintado (progress 0..1, ou null = loop demo). PairingScreen = TELA CHEIA (header, fase, barra, 4 passos) — aqui num viewport constrito.',
              composedOf: const ['BoldQuantumCore', 'BoldProgressBar', 'Tipografia'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 220, height: 220, child: BoldQuantumCore()),
                  SizedBox(height: 12),
                  SizedBox(width: 320, height: 480, child: BoldQuantumPairingScreen()),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // ───────────────────────────── TOKENS ─────────────────────────
            Text('TOKENS',
                style: BoldType.labelLg
                    .copyWith(color: c.textPrimary, letterSpacing: 1.2)),
            const SizedBox(height: 16),
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
