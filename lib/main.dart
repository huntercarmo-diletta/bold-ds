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
import 'ds_tree_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

enum _Tab { preview, specs, map }

// Camadas do catálogo (atomic design) — viram subitens da aba Design System.
enum _DsTier { tokens, atoms, molecules, organisms, illustrations }

extension _DsTierX on _DsTier {
  String get label => switch (this) {
        _DsTier.tokens => 'Tokens',
        _DsTier.atoms => 'Átomos',
        _DsTier.molecules => 'Moléculas',
        _DsTier.organisms => 'Organismos',
        _DsTier.illustrations => 'Ilustrações',
      };
}

// ═══════════════════════════════════════════════════════════════════════════
// ILUSTRAÇÕES — catálogo do CPF Seguro Design System (Figma), exportadas como
// SVG em lib/design_system/assets/illustrations/<nome>_<tema>.svg. Cada uma tem
// as variações de tema Light/Dark/Theme 3 (algumas só Light/Dark).
// ═══════════════════════════════════════════════════════════════════════════
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

class _CatalogHome extends StatefulWidget {
  const _CatalogHome({required this.mode, required this.onMode});
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onMode;
  @override
  State<_CatalogHome> createState() => _CatalogHomeState();
}

class _CatalogHomeState extends State<_CatalogHome> {
  // Destino selecionado na navegação lateral: -1 = Design System;
  // 0.. = índice do fluxo em [kFlows].
  int _dest = -1;
  _Tab _dsTab = _Tab.preview;
  // Camada do Design System em foco no preview; null = visão geral (tudo).
  _DsTier? _dsTier;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Fundo = o background REAL do tema (espelha o app): light #F4F3F6, dark
    // neutral escuro. As superfícies glass (branco @50%) leem por cima dele.
    final bg = c.background;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Sidebar(
              dest: _dest,
              onSelect: (d) => setState(() => _dest = d),
              dsTier: _dsTier,
              onSelectTier: (t) => setState(() {
                _dest = -1;
                _dsTab = _Tab.preview;
                _dsTier = t;
              }),
              isDark: c.isDark,
              onToggleTheme: () =>
                  widget.onMode(c.isDark ? ThemeMode.light : ThemeMode.dark),
            ),
            Expanded(
              child: _dest == -1
                  ? _DesignSystemView(
                      tab: _dsTab,
                      onTab: (t) => setState(() => _dsTab = t),
                      tier: _dsTier,
                    )
                  : _FlowchartView(flow: kFlows[_dest]),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Navegação lateral — Design System + fluxos (agrupados). É o índice do site.
// ═══════════════════════════════════════════════════════════════════════════
class _Sidebar extends StatefulWidget {
  const _Sidebar({
    required this.dest,
    required this.onSelect,
    required this.dsTier,
    required this.onSelectTier,
    required this.isDark,
    required this.onToggleTheme,
  });
  final int dest;
  final ValueChanged<int> onSelect;
  final _DsTier? dsTier;
  final ValueChanged<_DsTier?> onSelectTier;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<_Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<_Sidebar> {
  // Accordion DESIGN SYSTEM: começa aberto quando o DS está em foco (dest -1).
  late bool _dsOpen = widget.dest < 0;
  // Accordion FLUXOGRAMAS: começa aberto se já há um fluxo selecionado.
  late bool _flowsOpen = widget.dest >= 0;
  // Barra lateral retrátil: recolhida vira uma faixa estreita só com o botão
  // de reabrir + troca de tema.
  bool _collapsed = false;

  @override
  void didUpdateWidget(_Sidebar old) {
    super.didUpdateWidget(old);
    // Selecionou um fluxo (ex.: via deep-link) → garante o accordion aberto.
    if (widget.dest >= 0 && !_flowsOpen) _flowsOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final isDark = widget.isDark;
    final dest = widget.dest;
    final onSelect = widget.onSelect;
    final dsTier = widget.dsTier;
    final onSelectTier = widget.onSelectTier;
    // Agrupa os fluxos por `group`, preservando a ordem de declaração.
    final groups = <String, List<int>>{};
    for (var i = 0; i < kFlows.length; i++) {
      (groups[kFlows[i].group] ??= <int>[]).add(i);
    }
    final railBg = isDark ? c.surface : BoldColors.neutral10;
    // Recolhida: rail estreito de ícones navegáveis (Design System + fluxos),
    // com tooltip do nome e destaque de seleção; reabrir + tema nas pontas.
    if (_collapsed) {
      return Container(
        width: 56,
        decoration: BoxDecoration(
          color: railBg,
          border: Border(right: BorderSide(color: c.border)),
        ),
        child: Column(children: [
          const SizedBox(height: 14),
          BoldIconButton(
            icon: 'bars-light',
            semanticLabel: 'Expandir menu',
            type: BoldIconButtonType.tertiary,
            onPressed: () => setState(() => _collapsed = false),
          ),
          const SizedBox(height: 6),
          Divider(height: 1, color: c.border),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                // No rail, cada seção é UM ícone (não explode os subitens):
                // Design System vai direto pra visão geral; Fluxogramas (sem
                // página índice) reabre o menu com o accordion de fluxos.
                _railItem(context,
                    icon: 'puzzle-light',
                    tooltip: 'Design System',
                    selected: dest == -1,
                    onTap: () => onSelectTier(null)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  child: Divider(height: 1, color: c.border),
                ),
                _railItem(context,
                    icon: 'table-tree-light',
                    tooltip: 'Fluxogramas',
                    selected: dest >= 0,
                    onTap: () => setState(() {
                          _collapsed = false;
                          _flowsOpen = true;
                        })),
              ],
            ),
          ),
          Divider(height: 1, color: c.border),
          const SizedBox(height: 8),
          BoldIconButton(
            icon: isDark ? 'sun' : 'moon',
            semanticLabel: isDark ? 'Modo claro' : 'Modo escuro',
            type: BoldIconButtonType.tertiary,
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(height: 14),
        ]),
      );
    }
    return Container(
      width: 268,
      decoration: BoxDecoration(
        color: railBg,
        border: Border(right: BorderSide(color: c.border)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
          child: Row(children: [
            BoldPixMark(size: 20, color: BoldColors.primary04),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Conta BOLD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BoldType.title.copyWith(color: c.textPrimary)),
            ),
            BoldIconButton(
              icon: isDark ? 'sun' : 'moon',
              semanticLabel: isDark ? 'Modo claro' : 'Modo escuro',
              type: BoldIconButtonType.tertiary,
              onPressed: widget.onToggleTheme,
            ),
            BoldIconButton(
              icon: 'arrow-left-light',
              semanticLabel: 'Recolher menu',
              type: BoldIconButtonType.tertiary,
              onPressed: () => setState(() => _collapsed = true),
            ),
          ]),
        ),
        Divider(height: 1, color: c.border),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
            children: [
              // Accordion DESIGN SYSTEM — camadas do atomic design como
              // subseções (Visão geral + Tokens/Átomos/Moléculas/Organismos).
              _dsHeader(context),
              if (_dsOpen) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _subItem(context,
                      label: 'Visão geral',
                      selected: dest == -1 && dsTier == null,
                      onTap: () => onSelectTier(null)),
                ),
                for (final ti in _DsTier.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _subItem(context,
                        label: ti.label,
                        selected: dest == -1 && dsTier == ti,
                        onTap: () => onSelectTier(ti)),
                  ),
              ],
              const SizedBox(height: 6),
              // Accordion FLUXOGRAMAS — engloba TODOS os fluxos do app,
              // agrupados por área (Conta, PIX, Pagamentos…) como subgrupos.
              _accordionHeader(context),
              if (_flowsOpen)
                for (final g in groups.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 10, 6),
                    child: Text(g.key.toUpperCase(),
                        style: BoldType.labelSm.copyWith(
                            color: c.textMuted,
                            letterSpacing: 1,
                            fontSize: 10)),
                  ),
                  for (final i in g.value)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _navItem(context,
                          icon: kFlows[i].icon,
                          label: kFlows[i].name,
                          selected: dest == i,
                          onTap: () => onSelect(i)),
                    ),
                ],
            ],
          ),
        ),
      ]),
    );
  }

  // Item do rail (sidebar recolhida): só o ícone, centralizado, com tooltip do
  // nome e destaque quando selecionado.
  Widget _railItem(BuildContext context,
      {required String icon,
      required String tooltip,
      required bool selected,
      required VoidCallback onTap}) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 300),
        child: Material(
          color: selected
              ? BoldColors.primary04.withValues(alpha: 0.12)
              : BoldColors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Center(
                child: BoldIcon(icon,
                    size: 18,
                    color:
                        selected ? BoldColors.primary04 : c.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Cabeçalho do accordion DESIGN SYSTEM: abre/fecha as camadas. Fica ativo
  // (rosa) enquanto o DS está em foco (dest -1).
  Widget _dsHeader(BuildContext context) {
    final c = BoldColors.of(context);
    final active = widget.dest == -1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: BoldColors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _dsOpen = !_dsOpen),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(children: [
              BoldIcon('puzzle-light',
                  size: 18,
                  color: active ? BoldColors.primary04 : c.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Design System',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BoldType.labelMd.copyWith(
                        color: active ? BoldColors.primary04 : c.textPrimary,
                        fontWeight: FontWeight.w600)),
              ),
              AnimatedRotation(
                turns: _dsOpen ? 0 : -0.25,
                duration: const Duration(milliseconds: 160),
                child: BoldIcon('chevron-down',
                    size: 16, color: c.textSecondary),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // Subitem de navegação (camadas do DS): indentado, com um "dot" à esquerda no
  // lugar do ícone. Destaca em rosa quando selecionado.
  Widget _subItem(BuildContext context,
      {required String label,
      required bool selected,
      required VoidCallback onTap}) {
    final c = BoldColors.of(context);
    final fg = selected ? BoldColors.primary04 : c.textPrimary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected
            ? BoldColors.primary04.withValues(alpha: 0.12)
            : BoldColors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? BoldColors.primary04 : c.textMuted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BoldType.labelMd.copyWith(
                        color: fg,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500)),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // Cabeçalho do accordion FLUXOGRAMAS: linha clicável que abre/fecha a lista
  // de fluxos. `_flowsOpen` guarda o estado; a seta vira com AnimatedRotation.
  Widget _accordionHeader(BuildContext context) {
    final c = BoldColors.of(context);
    // Ativo quando aberto OU quando há um fluxo selecionado por baixo.
    final hasSelectedFlow = widget.dest >= 0;
    final accent = _flowsOpen || hasSelectedFlow;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: BoldColors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _flowsOpen = !_flowsOpen),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(children: [
              BoldIcon('table-tree-light',
                  size: 18,
                  color: accent ? BoldColors.primary04 : c.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Fluxogramas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BoldType.labelMd.copyWith(
                        color: accent ? BoldColors.primary04 : c.textPrimary,
                        fontWeight: FontWeight.w600)),
              ),
              AnimatedRotation(
                turns: _flowsOpen ? 0 : -0.25,
                duration: const Duration(milliseconds: 160),
                child: BoldIcon('chevron-down',
                    size: 16, color: c.textSecondary),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context,
      {required String icon,
      required String label,
      required bool selected,
      required VoidCallback onTap}) {
    final c = BoldColors.of(context);
    final fg = selected ? BoldColors.primary04 : c.textPrimary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected
            ? BoldColors.primary04.withValues(alpha: 0.12)
            : BoldColors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(children: [
              BoldIcon(icon,
                  size: 18,
                  color: selected ? BoldColors.primary04 : c.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BoldType.labelMd.copyWith(
                        color: fg,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// Conteúdo do Design System (Preview / Specs) — o catálogo original.
class _DesignSystemView extends StatelessWidget {
  const _DesignSystemView(
      {required this.tab, required this.onTab, required this.tier});
  final _Tab tab;
  final ValueChanged<_Tab> onTab;
  final _DsTier? tier;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final title =
        tier == null ? 'Design System' : 'Design System · ${tier!.label}';
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 20, 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: Row(children: [
          Expanded(
            child: Text(title,
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
          const SizedBox(width: 4),
          _Pill(
              label: 'Mapa',
              selected: tab == _Tab.map,
              onTap: () => onTab(_Tab.map)),
        ]),
      ),
      Expanded(
        child: switch (tab) {
          _Tab.preview => _PreviewTab(tier: tier),
          _Tab.specs => const _SpecsTab(),
          _Tab.map => const DsTreeScreen(),
        },
      ),
    ]);
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
// FLUXOS — documentação dos fluxos do app (app-newbold), como fluxogramas.
// Fonte: rotas em lib/routing/routes.dart. Cada passo = um nó; `branches` são
// caminhos alternativos/decisões dentro do passo.
// ═══════════════════════════════════════════════════════════════════════════
// Padrão de user flow do time (ver documentação): verde = início · rosa = fim ·
// AMARELO = usuário · ROXO = sistema · retângulo = ação · losango = decisão ·
// roxo + X = caso de erro. Seta cheia = fluxo · tracejada = anotação/erro.
enum StepType {
  start,
  end,
  userAction,
  userDecision,
  systemAction,
  systemDecision,
  systemError,
}

class FlowStep {
  const FlowStep(this.label, {this.type, this.note, this.branches = const []});
  final String label;
  final StepType? type; // null = legado (forma inferida por posição)
  final String? note;
  final List<String> branches;
}

// Caso de erro FORA do fluxo feliz: sai de uma decisão do sistema (`from`).
class ErrorCase {
  const ErrorCase(this.label, {required this.from, this.note});
  final String label;
  final String from; // decisão de origem (rótulo do passo)
  final String? note;
}

class AppFlow {
  const AppFlow({
    required this.name,
    required this.group,
    required this.icon,
    required this.route,
    required this.description,
    required this.steps,
    this.errors = const <ErrorCase>[],
  });
  final String name;
  final String group;
  final String icon;
  final String route;
  final String description;
  final List<FlowStep> steps;
  final List<ErrorCase> errors;
}

const List<AppFlow> kFlows = [
  // ───────────────────────────── CONTA ──────────────────────────────────────
  AppFlow(
    name: 'Abertura de conta',
    group: 'Conta',
    icon: 'id-card-light',
    route: '/boas-vindas → /onboarding/*',
    description:
        'Onboarding completo (PF e PJ), do cadastro ao KYC e aprovação.',
    steps: [
      FlowStep('Boas-vindas', note: 'Entrar ou abrir conta'),
      FlowStep('Tipo de conta', branches: ['Pessoa Física', 'Pessoa Jurídica']),
      FlowStep('Informar CPF'),
      FlowStep('Documentos da empresa', note: 'Só PJ (CNPJ, contrato social)'),
      FlowStep('Criar senha'),
      FlowStep('Verificar OTP', note: 'Código enviado por SMS/e-mail'),
      FlowStep('Dados pessoais'),
      FlowStep('Endereço'),
      FlowStep('Dados da empresa', note: 'Só PJ'),
      FlowStep('KYC — selfie'),
      FlowStep('KYC — documento'),
      FlowStep('Análise', note: 'Aguardando validação',
          branches: ['Aprovada', 'Reprovada']),
      FlowStep('Configurar passkey', note: 'Login sem senha'),
      FlowStep('Home'),
    ],
  ),
  AppFlow(
    name: 'Login',
    group: 'Conta',
    icon: 'lock-light',
    route: '/login',
    description: 'Autenticação com CPF + senha, biometria ou acesso rápido.',
    steps: [
      FlowStep('Boas-vindas'),
      FlowStep('Login', note: 'CPF + senha',
          branches: ['Login recorrente', 'Biometria', 'Recuperar senha']),
      FlowStep('Selecionar conta', note: 'Quando há mais de uma conta'),
      FlowStep('Home'),
    ],
  ),
  AppFlow(
    name: 'Extrato',
    group: 'Conta',
    icon: 'receipt-light',
    route: '/extrato',
    description: 'Consulta de lançamentos, filtros, detalhe e exportação.',
    steps: [
      FlowStep('Extrato', note: 'Passado / Futuro (agendados)'),
      FlowStep('Filtros', note: 'Tipo, período, direção'),
      FlowStep('Detalhe da transação'),
      FlowStep('Exportar', note: 'Comprovante / relatório'),
    ],
  ),
  AppFlow(
    name: 'Segurança da conta',
    group: 'Conta',
    icon: 'fingerprint-light',
    route: '/perfil → /conta/*',
    description: 'Passkey, login biométrico, dispositivos e troca de senha.',
    steps: [
      FlowStep('Perfil'),
      FlowStep('Segurança'),
      FlowStep('Ação', branches: [
        'Passkey',
        'Login biométrico',
        'Meus dispositivos',
        'Alterar senha',
      ]),
    ],
  ),
  // ───────────────────────────── PIX ────────────────────────────────────────
  AppFlow(
    name: 'PIX — Enviar',
    group: 'PIX',
    icon: 'arrow-right-arrow-left-light',
    route: '/pix/pagar',
    description:
        'Transferência via chave, contato, copia-e-cola ou agência/conta.',
    steps: [
      FlowStep('Início', type: StepType.start),
      FlowStep('Abre a Área Pix', type: StepType.userAction),
      FlowStep('Escolhe para quem enviar',
          type: StepType.userDecision,
          branches: [
            'Chave / nome',
            'Copia e cola',
            'Contato favorito',
            'Agência e conta',
          ]),
      FlowStep('Informa a chave / os dados', type: StepType.userAction),
      FlowStep('Consulta o destinatário (DICT)', type: StepType.systemAction),
      FlowStep('Chave encontrada no DICT?', type: StepType.systemDecision),
      FlowStep('Informa o valor', type: StepType.userAction),
      FlowStep('Saldo e limite suficientes?', type: StepType.systemDecision),
      FlowStep('Revisa e confirma (senha / biometria)',
          type: StepType.userAction),
      FlowStep('Autenticação válida?', type: StepType.systemDecision),
      FlowStep('Efetiva o Pix', type: StepType.systemAction),
      FlowStep('Comprovante', type: StepType.end),
    ],
    errors: [
      ErrorCase('Chave não encontrada',
          from: 'Chave encontrada no DICT?',
          note: 'Chave inexistente ou indisponível no DICT'),
      ErrorCase('Saldo insuficiente / limite excedido',
          from: 'Saldo e limite suficientes?',
          note: 'Sem saldo ou acima do limite Pix do período'),
      ErrorCase('Falha na autenticação',
          from: 'Autenticação válida?', note: 'Senha/biometria incorreta'),
    ],
  ),
  AppFlow(
    name: 'PIX — Receber',
    group: 'PIX',
    icon: 'arrow-down-to-line-light',
    route: '/pix/receber',
    description: 'Geração de QR Code para receber (com ou sem valor).',
    steps: [
      FlowStep('Início', type: StepType.start),
      FlowStep('Abre a Área Pix', type: StepType.userAction),
      FlowStep('Toca em Receber', type: StepType.userAction),
      FlowStep('Define um valor?',
          type: StepType.userDecision, branches: ['Com valor', 'Sem valor']),
      FlowStep('Gera o QR Code', type: StepType.systemAction),
      FlowStep('Compartilha ou copia o código', type: StepType.userAction),
      FlowStep('QR pronto', type: StepType.end),
    ],
    errors: [
      ErrorCase('Falha ao gerar o QR',
          from: 'Gera o QR Code', note: 'Sem conexão / erro no servidor'),
    ],
  ),
  AppFlow(
    name: 'PIX — Minhas chaves',
    group: 'PIX',
    icon: 'key-light',
    route: '/pix/chaves',
    description: 'Cadastro, definição da chave preferida e remoção de chaves.',
    steps: [
      FlowStep('Início', type: StepType.start),
      FlowStep('Abre Minhas chaves', type: StepType.userAction),
      FlowStep('O que deseja fazer?',
          type: StepType.userDecision,
          branches: ['Cadastrar', 'Definir preferida', 'Remover']),
      FlowStep('Cadastra uma nova chave', type: StepType.userAction),
      FlowStep('Chave disponível e dentro do limite?',
          type: StepType.systemDecision),
      FlowStep('Registra a chave', type: StepType.systemAction),
      FlowStep('Chave ativa', type: StepType.end),
    ],
    errors: [
      ErrorCase('Chave já cadastrada / limite atingido',
          from: 'Chave disponível e dentro do limite?',
          note: 'Chave em uso em outra conta ou 5 chaves (PF) já ativas'),
    ],
  ),
  AppFlow(
    name: 'PIX Automático',
    group: 'PIX',
    icon: 'arrow-rotate-left-light',
    route: '/pix/automatico',
    description: 'Autorização e gestão de débitos recorrentes por PIX.',
    steps: [
      FlowStep('Início', type: StepType.start),
      FlowStep('Abre o PIX Automático', type: StepType.userAction),
      FlowStep('Qual ação?',
          type: StepType.userDecision,
          branches: ['Criar', 'Autorizar', 'Revogar']),
      FlowStep('Configura (valor, periodicidade, limite)',
          type: StepType.userAction),
      FlowStep('Confirma a autorização', type: StepType.userAction),
      FlowStep('Autorização aceita?', type: StepType.systemDecision),
      FlowStep('Registra a autorização', type: StepType.systemAction),
      FlowStep('Débito recorrente ativo', type: StepType.end),
    ],
    errors: [
      ErrorCase('Autorização recusada',
          from: 'Autorização aceita?',
          note: 'Dados inválidos ou limite recorrente excedido'),
    ],
  ),
  AppFlow(
    name: 'PIX — Contestação (MED)',
    group: 'PIX',
    icon: 'shield-user-light-full',
    route: '/pix/contestacao',
    description: 'Mecanismo Especial de Devolução para transações suspeitas.',
    steps: [
      FlowStep('Início', type: StepType.start),
      FlowStep('Abre Contestar Pix', type: StepType.userAction),
      FlowStep('Seleciona a transação', type: StepType.userAction),
      FlowStep('Escolhe o motivo',
          type: StepType.userDecision, branches: ['Golpe', 'Fraude', 'Erro']),
      FlowStep('Descreve a ocorrência', type: StepType.userAction),
      FlowStep('Confirma a contestação', type: StepType.userAction),
      FlowStep('Elegível ao MED (prazo e critérios)?',
          type: StepType.systemDecision),
      FlowStep('Registra e gera protocolo', type: StepType.systemAction),
      FlowStep('Acompanha o status', type: StepType.userAction),
      FlowStep('Contestação registrada', type: StepType.end),
    ],
    errors: [
      ErrorCase('Fora do prazo / não elegível',
          from: 'Elegível ao MED (prazo e critérios)?',
          note: 'Além do prazo do MED ou transação inelegível'),
    ],
  ),
  // ─────────────────────────── PAGAMENTOS ───────────────────────────────────
  AppFlow(
    name: 'Boleto — Pagar',
    group: 'Pagamentos',
    icon: 'barcode-light',
    route: '/boleto',
    description: 'Pagamento de boleto por leitura de código ou digitação.',
    steps: [
      FlowStep('Hub de boleto'),
      FlowStep('Código de barras', note: 'Câmera ou linha digitável'),
      FlowStep('Revisar', note: 'Valor, vencimento, beneficiário'),
      FlowStep('Autorização'),
      FlowStep('Comprovante'),
    ],
  ),
  AppFlow(
    name: 'Recarga de celular',
    group: 'Pagamentos',
    icon: 'mobile-light',
    route: '/recarga',
    description: 'Recarga de crédito pré-pago em 4 passos.',
    steps: [
      FlowStep('Número'),
      FlowStep('Operadora'),
      FlowStep('Valor'),
      FlowStep('Revisar'),
      FlowStep('Comprovante'),
    ],
  ),
  // ────────────────────────── TRANSFERÊNCIAS ────────────────────────────────
  AppFlow(
    name: 'TED',
    group: 'Transferências',
    icon: 'money-bill-transfer-light',
    route: '/ted',
    description: 'Transferência para conta de outra instituição.',
    steps: [
      FlowStep('Hub TED', branches: ['Enviar', 'Receber (meus dados)']),
      FlowStep('Enviar', note: 'Dados do destinatário e banco'),
      FlowStep('Revisar'),
      FlowStep('Autorização'),
      FlowStep('Comprovante'),
    ],
  ),
  AppFlow(
    name: 'Transferência interna',
    group: 'Transferências',
    icon: 'money-bill-transfer-in-light',
    route: '/contatos/transferencia-interna',
    description: 'Transferência entre contas BOLD (sem custo).',
    steps: [
      FlowStep('Contatos'),
      FlowStep('Transferência interna', note: 'Valor + destinatário BOLD'),
      FlowStep('Revisar'),
      FlowStep('Comprovante'),
    ],
  ),
  // ─────────────────────────────── PJ ───────────────────────────────────────
  AppFlow(
    name: 'Cobranças (PJ)',
    group: 'PJ',
    icon: 'file-invoice-dollar-light',
    route: '/cobrancas',
    description: 'Emissão de cobranças por boleto ou PIX QR dinâmico.',
    steps: [
      FlowStep('Hub de cobranças'),
      FlowStep('Emitir', branches: ['Boleto', 'PIX QR dinâmico']),
      FlowStep('Preview da cobrança'),
      FlowStep('Compartilhar'),
    ],
  ),
  AppFlow(
    name: 'Equipe / Usuários (PJ)',
    group: 'PJ',
    icon: 'users-light',
    route: '/usuarios',
    description: 'Gestão de operadores, perfis, alçadas e aprovações.',
    steps: [
      FlowStep('Usuários'),
      FlowStep('Ação', branches: [
        'Convidar operador',
        'Perfis',
        'Alçadas',
        'Aprovações pendentes',
      ]),
      FlowStep('Convite recebido', note: 'Aceite via deeplink (operador novo)'),
    ],
  ),
  // ───────────────────────────── SEGURANÇA ──────────────────────────────────
  AppFlow(
    name: 'Autorização Quântica',
    group: 'Segurança',
    icon: 'qrcode-light',
    route: '/scanner → /ib/aprovar',
    description:
        'Aprovação de transações do Internet Banking lendo o QR (selo quântico).',
    steps: [
      FlowStep('Scanner', note: 'Lê o QR exibido no Internet Banking'),
      FlowStep('Revisar transação'),
      FlowStep('Decisão', branches: ['Aprovar', 'Recusar']),
      FlowStep('Selo quântico', note: 'Confirmação assinada no dispositivo'),
    ],
  ),
  AppFlow(
    name: 'Pareamento de dispositivo',
    group: 'Segurança',
    icon: 'mobile-gear-light',
    route: '/dispositivos/parear',
    description: 'Autoriza um novo aparelho a aprovar pagamentos.',
    steps: [
      FlowStep('Meus dispositivos'),
      FlowStep('Parear dispositivo', note: 'Leitura de QR'),
      FlowStep('Confirmar', note: 'Aparelho autorizado'),
    ],
  ),
  // ───────────────────────────── ASSISTENTE ─────────────────────────────────
  AppFlow(
    name: 'Lia (assistente)',
    group: 'Assistente',
    icon: 'star-light',
    route: '/lia',
    description: 'Assistente virtual — conversa e preferências.',
    steps: [
      FlowStep('Abrir Lia', note: 'Pela nav inferior ou avatar'),
      FlowStep('Conversa', note: 'Voz/texto, idioma configurável'),
      FlowStep('Preferências da Lia', note: 'Idioma, avatar, visibilidade'),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// Fluxograma de um fluxo — nós numerados conectados verticalmente.
// ═══════════════════════════════════════════════════════════════════════════
class _FlowchartView extends StatelessWidget {
  const _FlowchartView({required this.flow});
  final AppFlow flow;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: Row(children: [
          BoldIcon(flow.icon, size: 24, color: BoldColors.primary04),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flow.name,
                    style: BoldType.title.copyWith(color: c.textPrimary)),
                Text(flow.route,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BoldType.labelSm.copyWith(color: c.textMuted)),
              ],
            ),
          ),
        ]),
      ),
      Expanded(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
              children: [
                Text(flow.description,
                    textAlign: TextAlign.center,
                    style:
                        BoldType.bodySmall.copyWith(color: c.textSecondary)),
                const SizedBox(height: 20),
                if (flow.steps.any((s) => s.type != null)) ...[
                  const _FlowLegend(),
                  const SizedBox(height: 20),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < flow.steps.length; i++) ...[
                      _FlowBox(
                        step: flow.steps[i],
                        index: i,
                        total: flow.steps.length,
                      ),
                      if (flow.steps[i].branches.isNotEmpty)
                        _BranchFan(
                          branches: flow.steps[i].branches,
                          accent: flow.steps[i].type == StepType.systemDecision
                              ? _sysStroke
                              : _usrStroke,
                        ),
                      if (i < flow.steps.length - 1) const _DownArrow(),
                    ],
                  ],
                ),
                if (flow.errors.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _ErrorCasesSection(errors: flow.errors),
                ],
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

// Paleta do padrão de user flow do time (documentação).
const Color _usrFill = Color(0xFFFCE7A6); // amarelo — usuário
const Color _usrStroke = Color(0xFFE0A93B);
const Color _usrText = Color(0xFF5C4610);
const Color _sysFill = Color(0xFFE7DBFA); // roxo — sistema
const Color _sysStroke = Color(0xFF7B3FF2);
const Color _sysText = Color(0xFF3A2A6B);
const Color _startFill = Color(0xFFCBEFD5); // verde — início
const Color _startText = Color(0xFF0A3F24);
const Color _endFill = Color(0xFFF8C9CF); // rosa — fim
const Color _endText = Color(0xFF7A2E3E);
const Color _errBadge = Color(0xFFEF4757); // vermelho — X do caso de erro

enum _NodeKind { start, process, decision, end }

_NodeKind _kindOf(int i, int total, FlowStep s) {
  if (s.branches.isNotEmpty) return _NodeKind.decision;
  if (i == 0) return _NodeKind.start;
  if (i == total - 1) return _NodeKind.end;
  return _NodeKind.process;
}

// Nó do fluxograma. Com `step.type` definido, segue o PADRÃO do time (amarelo =
// usuário, roxo = sistema; retângulo = ação, losango = decisão, roxo+X = erro;
// verde = início, rosa = fim). Sem type, cai no legado (formas da marca).
class _FlowBox extends StatelessWidget {
  const _FlowBox(
      {required this.step, required this.index, required this.total});
  final FlowStep step;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = step.type;
    if (t == null) return _legacy(context);
    switch (t) {
      case StepType.start:
        return _stadium(_startFill, _startText);
      case StepType.end:
        return _stadium(_endFill, _endText);
      case StepType.userAction:
        return _rect(context, _usrFill, _usrStroke, _usrText);
      case StepType.systemAction:
        return _rect(context, _sysFill, _sysStroke, _sysText);
      case StepType.systemError:
        return _rect(context, _sysFill, _errBadge, _sysText, error: true);
      case StepType.userDecision:
        return _diamond(context, _usrFill, _usrStroke, _usrText);
      case StepType.systemDecision:
        return _diamond(context, _sysFill, _sysStroke, _sysText);
    }
  }

  // ── Padrão (tipado) ──────────────────────────────────────────────────────
  Widget _stadium(Color fill, Color text) => Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration:
            BoxDecoration(color: fill, borderRadius: BorderRadius.circular(999)),
        child: Text(step.label,
            textAlign: TextAlign.center,
            style: BoldType.labelMd
                .copyWith(color: text, fontWeight: FontWeight.w700)),
      );

  Widget _rect(BuildContext context, Color fill, Color stroke, Color text,
      {bool error = false}) {
    final c = BoldColors.of(context);
    final box = Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: error ? _errBadge : stroke, width: error ? 1.5 : 1),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(step.label,
            textAlign: TextAlign.center,
            style:
                BoldType.labelMd.copyWith(color: text, fontWeight: FontWeight.w600)),
        if (step.note != null) ...[
          const SizedBox(height: 3),
          Text(step.note!,
              textAlign: TextAlign.center,
              style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
        ],
      ]),
    );
    if (!error) return box;
    return Stack(clipBehavior: Clip.none, children: [
      box,
      Positioned(
        right: -8,
        top: -8,
        child: Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: _errBadge, shape: BoxShape.circle),
          child: const Icon(Icons.close, size: 14, color: Colors.white),
        ),
      ),
    ]);
  }

  Widget _diamond(BuildContext context, Color fill, Color stroke, Color text) {
    final c = BoldColors.of(context);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      CustomPaint(
        painter: _DiamondPainter(fill: fill, stroke: stroke),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 26),
          child: Text(step.label,
              textAlign: TextAlign.center,
              style: BoldType.labelMd
                  .copyWith(color: text, fontWeight: FontWeight.w600)),
        ),
      ),
      if (step.note != null) ...[
        const SizedBox(height: 6),
        Text(step.note!,
            textAlign: TextAlign.center,
            style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
      ],
    ]);
  }

  // ── Legado (fluxos ainda não migrados ao padrão) ─────────────────────────
  Widget _legacy(BuildContext context) {
    switch (_kindOf(index, total, step)) {
      case _NodeKind.start:
        return _pillLegacy(context, gradient: BoldGradients.brand);
      case _NodeKind.end:
        return _pillLegacy(context, outlined: true);
      case _NodeKind.decision:
        return _diamond(
            context,
            BoldColors.warning04.withValues(alpha: 0.13),
            BoldColors.warning04,
            BoldColors.of(context).textPrimary);
      case _NodeKind.process:
        return _rect(
            context,
            BoldColors.primary04.withValues(alpha: 0.06),
            BoldColors.primary04.withValues(alpha: 0.30),
            BoldColors.of(context).textPrimary);
    }
  }

  Widget _pillLegacy(BuildContext context,
      {Gradient? gradient, bool outlined = false}) {
    final c = BoldColors.of(context);
    final fg = gradient != null ? BoldColors.onGradient : c.textPrimary;
    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        color:
            gradient == null ? (c.isDark ? c.surface : BoldColors.white) : null,
        borderRadius: BorderRadius.circular(999),
        border: outlined ? Border.all(color: c.borderStrong, width: 1.5) : null,
      ),
      child: Text(step.label,
          textAlign: TextAlign.center,
          style:
              BoldType.labelMd.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

class _DiamondPainter extends CustomPainter {
  _DiamondPainter({required this.fill, required this.stroke});
  final Color fill;
  final Color stroke;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(_DiamondPainter o) => o.fill != fill || o.stroke != stroke;
}

// Seta vertical entre nós. `dashed` (anotação/erro) vs cheia (fluxo).
class _DownArrow extends StatelessWidget {
  const _DownArrow({this.dashed = false});
  final bool dashed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 24,
      child: CustomPaint(
          painter:
              _ArrowPainter(BoldColors.of(context).textMuted, dashed: dashed)),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter(this.color, {this.dashed = false});
  final Color color;
  final bool dashed;
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    final endY = size.height - 7;
    if (dashed) {
      const dash = 4.0, gap = 3.0;
      var y = 0.0;
      while (y < endY) {
        canvas.drawLine(Offset(cx, y), Offset(cx, (y + dash).clamp(0, endY)),
            paint);
        y += dash + gap;
      }
    } else {
      canvas.drawLine(Offset(cx, 0), Offset(cx, endY), paint);
    }
    final head = Path()
      ..moveTo(cx - 5, size.height - 8)
      ..lineTo(cx + 5, size.height - 8)
      ..lineTo(cx, size.height)
      ..close();
    canvas.drawPath(head, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ArrowPainter o) => o.color != color || o.dashed != dashed;
}

// Leque de DECISÃO: barra horizontal saindo do losango para N saídas. As
// opções ficam rotuladas nas saídas (padrão do time).
class _BranchFan extends StatelessWidget {
  const _BranchFan({required this.branches, this.accent});
  final List<String> branches;
  final Color? accent;
  static const double _cw = 150;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final line = accent ?? c.textMuted;
    final n = branches.length;
    return SizedBox(
      width: n * _cw,
      child: Column(children: [
        SizedBox(
          height: 26,
          width: n * _cw,
          child: CustomPaint(
              painter: _BusPainter(count: n, cellWidth: _cw, color: line)),
        ),
        Row(children: [
          for (final b in branches)
            SizedBox(width: _cw, child: Center(child: _pill(context, b))),
        ]),
      ]),
    );
  }

  Widget _pill(BuildContext context, String label) {
    final c = BoldColors.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 138),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent?.withValues(alpha: 0.5) ?? c.border),
      ),
      child: Text(label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: BoldType.labelSm.copyWith(color: c.textPrimary, fontSize: 11)),
    );
  }
}

class _BusPainter extends CustomPainter {
  _BusPainter(
      {required this.count, required this.cellWidth, required this.color});
  final int count;
  final double cellWidth;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    const busY = 12.0;
    final topCx = size.width / 2;
    canvas.drawLine(Offset(topCx, 0), Offset(topCx, busY), line);
    final firstCx = cellWidth / 2;
    final lastCx = size.width - cellWidth / 2;
    if (count > 1) {
      canvas.drawLine(Offset(firstCx, busY), Offset(lastCx, busY), line);
    }
    for (var i = 0; i < count; i++) {
      final cx = cellWidth / 2 + i * cellWidth;
      canvas.drawLine(Offset(cx, busY), Offset(cx, size.height - 7), line);
      final head = Path()
        ..moveTo(cx - 5, size.height - 8)
        ..lineTo(cx + 5, size.height - 8)
        ..lineTo(cx, size.height)
        ..close();
      canvas.drawPath(head, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_BusPainter o) =>
      o.count != count || o.color != color || o.cellWidth != cellWidth;
}

// Seção de CASOS DE ERRO — fora do fluxo feliz. Cada erro é um nó do sistema
// (roxo + X) que sai de uma decisão (`from`), ligado por conector tracejado.
class _ErrorCasesSection extends StatelessWidget {
  const _ErrorCasesSection({required this.errors});
  final List<ErrorCase> errors;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.neutral10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.error_outline, size: 16, color: _errBadge),
          const SizedBox(width: 6),
          Text('Casos de erro — fora do fluxo feliz',
              style: BoldType.labelMd
                  .copyWith(color: c.textPrimary, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 14),
        for (final e in errors)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _card(context, e),
          ),
      ]),
    );
  }

  Widget _card(BuildContext context, ErrorCase e) {
    final c = BoldColors.of(context);
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: _sysFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _errBadge, width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.label,
              style: BoldType.labelMd
                  .copyWith(color: _sysText, fontWeight: FontWeight.w600)),
          if (e.note != null) ...[
            const SizedBox(height: 3),
            Text(e.note!,
                style: BoldType.bodySmall.copyWith(color: _sysText)),
          ],
          const SizedBox(height: 8),
          Row(children: [
            const _DashChip(),
            const SizedBox(width: 6),
            Flexible(
              child: Text('sai de: ${e.from}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BoldType.labelSm
                      .copyWith(color: c.textMuted, fontSize: 11)),
            ),
          ]),
        ]),
      ),
      Positioned(
        right: -8,
        top: -8,
        child: Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(color: _errBadge, shape: BoxShape.circle),
          child: const Icon(Icons.close, size: 14, color: Colors.white),
        ),
      ),
    ]);
  }
}

// Traço tracejado horizontal (indica saída de erro / anotação — padrão da doc).
class _DashChip extends StatelessWidget {
  const _DashChip();
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 22,
        height: 8,
        child: CustomPaint(painter: _HDashPainter(_errBadge)),
      );
}

class _HDashPainter extends CustomPainter {
  _HDashPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    final cy = size.height / 2;
    const dash = 3.0, gap = 2.5;
    var x = 0.0;
    final endX = size.width - 5;
    while (x < endX) {
      canvas.drawLine(Offset(x, cy), Offset((x + dash).clamp(0, endX), cy), paint);
      x += dash + gap;
    }
    final head = Path()
      ..moveTo(size.width - 6, cy - 3)
      ..lineTo(size.width, cy)
      ..lineTo(size.width - 6, cy + 3)
      ..close();
    canvas.drawPath(head, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_HDashPainter o) => o.color != color;
}

// Legenda do padrão de user flow (mostrada nos fluxos tipados).
class _FlowLegend extends StatelessWidget {
  const _FlowLegend();

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.neutral10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _item(context, _startFill, _startFill, 'Início'),
          _item(context, _endFill, _endFill, 'Fim'),
          _item(context, _usrFill, _usrStroke, 'Usuário · ação'),
          _item(context, _usrFill, _usrStroke, 'Usuário · decisão', diamond: true),
          _item(context, _sysFill, _sysStroke, 'Sistema · ação'),
          _item(context, _sysFill, _sysStroke, 'Sistema · decisão', diamond: true),
          _item(context, _sysFill, _errBadge, 'Caso de erro', error: true),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, Color fill, Color stroke, String label,
      {bool diamond = false, bool error = false}) {
    final c = BoldColors.of(context);
    Widget sw = Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(diamond ? 3 : 5),
        border: Border.all(color: error ? _errBadge : stroke, width: 1.2),
      ),
    );
    if (diamond) sw = Transform.rotate(angle: 0.785398, child: sw);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: 20, height: 18, child: Center(child: sw)),
      const SizedBox(width: 6),
      Text(label,
          style: BoldType.labelSm.copyWith(color: c.textSecondary, fontSize: 11)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PREVIEW — componentes vivos, por camada do Atomic Design.
// Cada _Section.composedOf lista os building blocks do DS que ele consome
// (widgets + tokens: Cores / Tipografia / Vidro / Gradiente).
// ═══════════════════════════════════════════════════════════════════════════
class _PreviewTab extends StatelessWidget {
  const _PreviewTab({this.tier});
  // Camada em foco; null = mostra tudo (visão geral).
  final _DsTier? tier;

  // Intercala um divider entre duas seções consecutivas. Não insere depois de
  // um _TierHeader (o cabeçalho já delimita o início da camada).
  static List<Widget> _sep(List<Widget> items) {
    final out = <Widget>[];
    for (final w in items) {
      if (w is _Section && out.isNotEmpty && out.last is _Section) {
        out.add(const _SectionDivider());
      }
      out.add(w);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final t = tier;
    final tokens = <Widget>[
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
    ];
    final atoms = <Widget>[
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
                builder: (ctx) {
                  final cc = BoldColors.of(ctx);
                  Widget box(Color bg, bool onDark, String label) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 190,
                            height: 92,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: cc.border),
                            ),
                            child: BoldLogo(width: 130, onDark: onDark),
                          ),
                          const SizedBox(height: 6),
                          Text(label,
                              style: BoldType.labelSm
                                  .copyWith(color: cc.textMuted)),
                        ],
                      );
                  return Wrap(spacing: 12, runSpacing: 12, children: [
                    box(BoldColors.white, false, 'Light'),
                    box(BoldColors.neutral00, true, 'Dark'),
                  ]);
                }),
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
                      BoldCheckbox(
                          checked: true,
                          variant: BoldCheckboxVariant.neutral,
                          label: 'Neutral'),
                      BoldCheckbox(
                          checked: true,
                          size: BoldCheckboxSize.sm,
                          label: 'Pequeno'),
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
                      BoldStatusTag(label: 'Neutro', tone: BoldStatusTone.neutral),
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
                title: 'Quick action',
                composedOf: const ['Cores', 'Tipografia', 'Ícone'],
                note: 'ícone + label no frame · 1ª em destaque (primary) · Expanded numa Row',
                builder: (_) => Row(children: const [
                      Expanded(
                          child: BoldQuickAction(
                              icon: 'pix', label: 'Pix', highlighted: true)),
                      SizedBox(width: 10),
                      Expanded(
                          child: BoldQuickAction(icon: 'qr', label: 'Scanear')),
                      SizedBox(width: 10),
                      Expanded(
                          child: BoldQuickAction(icon: 'pay', label: 'Pagar')),
                      SizedBox(width: 10),
                      Expanded(
                          child:
                              BoldQuickAction(icon: 'add', label: 'Depositar')),
                    ])),
            _Section(
                title: 'Home indicator',
                composedOf: const ['Cores'],
                builder: (_) => const BoldHomeIndicator()),

            _Section(
                title: 'Glass surface',
                composedOf: const ['Cores', 'Vidro (glass)'],
                note: 'fill + stroke + blur · característica do container',
                builder: (_) => const BoldGlassSurface(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 18),
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
                title: 'Glass avatar',
                composedOf: const ['Vidro (glass)', 'Cores', 'Tipografia'],
                builder: (_) => Row(children: const [
                      BoldGlassAvatar(initial: 'D'),
                      SizedBox(width: 12),
                      BoldGlassAvatar(initial: 'HS', size: 56),
                      SizedBox(width: 12),
                      BoldGlassAvatar(
                          initial: 'RC',
                          size: 56,
                          image: AssetImage(
                              'lib/design_system/assets/city-cyberpunk.webp')),
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
                title: 'Illustration',
                note: 'multicor — não recolore, só escala',
                builder: (_) => const Row(children: [
                      BoldIllustration('quantum-seal', size: 88),
                      SizedBox(width: 16),
                      BoldIllustration('city', size: 88),
                    ])),
            _Section(
                title: 'Motion (BoldAnimateIn)',
                note: 'presets de entrada: fade / slideUp / scaleIn',
                builder: (_) =>
                    Wrap(spacing: 10, runSpacing: 10, children: const [
                      BoldAnimateIn(
                          preset: BoldMotionPreset.slideUp,
                          child: BoldStatusBadge('slideUp')),
                      BoldAnimateIn(
                          preset: BoldMotionPreset.fade,
                          child: BoldStatusBadge('fade')),
                      BoldAnimateIn(
                          preset: BoldMotionPreset.scaleIn,
                          child: BoldStatusBadge('scaleIn')),
                    ])),
    ];
    final molecules = <Widget>[
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
                      BoldSpotIcon('shield', tone: BoldSpotTone.secure),
                      BoldSpotIcon('user-light', disabled: true),
                      BoldSpotIcon('user-light',
                          tone: BoldSpotTone.primary, loading: true),
                    ])),
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
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: BoldColors.primary04,
                            borderRadius: BorderRadius.circular(14)),
                        child: BoldButton('Branco',
                            variant: BoldButtonVariant.white, onPressed: () {}),
                      ),
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        const BoldButton('Carregando',
                            loading: true, expand: false),
                        const BoldButton('Off',
                            onPressed: null, expand: false),
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
                          icon: 'pix',
                          semanticLabel: 'x',
                          type: BoldIconButtonType.secondaryPrimary,
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
                      BoldIconButton(
                          icon: 'bell',
                          semanticLabel: 'x',
                          state: BoldIconButtonState.error,
                          onPressed: () {}),
                      const BoldIconButton(
                          icon: 'bell', semanticLabel: 'x', disabled: true),
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
                title: 'Select field',
                composedOf: const ['BoldIcon', 'Tipografia', 'Cores'],
                builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BoldSelectField(
                          label: 'Tipo de chave',
                          value: 'CPF',
                          onTap: () {}),
                      const SizedBox(height: 12),
                      BoldSelectField(
                          label: 'País',
                          placeholder: 'Selecionar',
                          onTap: () {}),
                      const SizedBox(height: 12),
                      BoldSelectField(
                          label: 'Desabilitado',
                          value: 'Indisponível',
                          enabled: false,
                          onTap: () {}),
                    ])),
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
                          label: 'Saldo',
                          leadIcon: 'eye',
                          tone: BoldInputChipTone.neutral),
                      BoldInputChip(
                          label: 'Filtro',
                          trailIcon: 'chevron-down',
                          tone: BoldInputChipTone.neutral),
                      BoldInputChip(
                          label: 'Extrato',
                          trailIcon: 'chevron-right',
                          tone: BoldInputChipTone.ghost),
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
                title: 'Accordion',
                note: 'começa fechado; toque pra abrir/fechar',
                composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
                builder: (ctx) {
                  final cc = BoldColors.of(ctx);
                  Widget resposta(String t) => Text(t,
                      style: BoldType.bodySm
                          .copyWith(color: cc.textSecondary, height: 1.5));
                  return Column(children: [
                    BoldAccordion(
                      title: 'O que é o Pix Automático?',
                      child: resposta(
                          'Pagamentos recorrentes autorizados uma única vez; a '
                          'cada cobrança o débito é agendado automaticamente.'),
                    ),
                    const SizedBox(height: BoldSpace.x3),
                    BoldAccordion(
                      title: 'Já começa aberto (initiallyOpen)',
                      initiallyOpen: true,
                      child: resposta(
                          'Variante com o conteúdo visível de início — para '
                          'destacar o primeiro item quando fizer sentido.'),
                    ),
                  ]);
                }),
            _Section(
                title: 'Empty state',
                composedOf: const ['BoldCard', 'BoldIcon', 'Tipografia'],
                builder: (_) => const BoldEmptyState(
                    title: 'Nada por aqui',
                    caption: 'Suas transações aparecem aqui.')),
            _Section(
                title: 'Promo card',
                composedOf: const ['Vidro', 'Tipografia', 'BoldIcon'],
                builder: (_) => BoldPromoCard(
                    title: 'Habilite sua passkey',
                    subtitle: 'Login sem senha, resistente a phishing.',
                    // Imagem placeholder no container 100×100 (ilustração do DS)
                    // pra visualizar o card com imagem real.
                    illustration: SvgPicture.asset(
                        'lib/design_system/assets/illustrations/fingerprint_light.svg',
                        fit: BoxFit.contain),
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
                title: 'Filter chip',
                composedOf: const ['Cores', 'Tipografia'],
                builder: (_) => Wrap(spacing: 8, runSpacing: 8, children: [
                      BoldFilterChip('Todos', selected: true, onTap: () {}),
                      BoldFilterChip('Entradas', selected: false, onTap: () {}),
                      BoldFilterChip('Saídas', selected: false, onTap: () {}),
                    ])),
            _Section(
                title: 'Status badge',
                composedOf: const ['Cores', 'Tipografia'],
                builder: (_) => const Wrap(spacing: 8, runSpacing: 8, children: [
                      BoldStatusBadge('Concluído'),
                      BoldStatusBadge('Erro', color: BoldColors.danger),
                      BoldStatusBadge('Validada', icon: Icons.check),
                    ])),
            _Section(
                title: 'Icon chip',
                composedOf: const ['Gradientes', 'Cores'],
                builder: (_) => const Wrap(spacing: 12, runSpacing: 12, children: [
                      BoldIconChip(Icons.send, gradient: BoldGradients.pix),
                      BoldIconChip(Icons.qr_code, tint: BoldColors.primary),
                      BoldIconChip.custom(
                          gradient: BoldGradients.brand,
                          child: Icon(Icons.bolt,
                              size: 20, color: BoldColors.white)),
                    ])),
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
                      BoldListTile(
                          leading: const BoldSpotIcon('mobile-light',
                              tone: BoldSpotTone.primary),
                          title: 'Recarga',
                          trailing: const BoldListTime('14min'),
                          onTap: () {}),
                    ])),
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
            _Section(
                title: 'Navigation button',
                composedOf: const ['BoldButton', 'Tipografia'],
                note: 'coluna de CTAs de rodapé (primary/secondary/tertiary)',
                builder: (_) => BoldNavigationButton(
                      primary: BoldNavAction(label: 'Continuar', onPressed: () {}),
                      secondary:
                          BoldNavAction(label: 'Agora não', onPressed: () {}),
                    )),
    ];
    final organisms = <Widget>[
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
                          BoldReceiptRow(
                              label: 'Tipo de pagamento', value: 'Pix'),
                        ],
                        sections: [
                          BoldReceiptSection(
                              icon: 'user-light',
                              title: 'Destino',
                              rows: [
                                BoldReceiptRow(
                                    label: 'Nome', value: 'Roberto da Silva'),
                                BoldReceiptRow(
                                    label: 'CPF/CNPJ', value: '***.777.888-**'),
                                BoldReceiptRow(
                                    label: 'Instituição',
                                    value: 'Banco XYZ S.A.'),
                              ]),
                          BoldReceiptSection(
                              icon: 'user-light',
                              title: 'Origem',
                              rows: [
                                BoldReceiptRow(
                                    label: 'Nome', value: 'Agatha Pedroso'),
                                BoldReceiptRow(
                                    label: 'CPF/CNPJ', value: '***.290.688-**'),
                                BoldReceiptRow(
                                    label: 'Instituição', value: 'Conta BOLD'),
                              ]),
                        ],
                        footerLines: ['Conta BOLD · Instituição de pagamento'],
                        transactionId: 'E1898765420260714153210abc',
                      ),
                    )),
            _Section(
                title: 'Circle button',
                composedOf: const ['BoldIcon', 'Cores'],
                builder: (_) => Wrap(spacing: 12, children: [
                      BoldCircleButton('bell', onTap: () {}),
                      BoldCircleButton('bell', dot: true, onTap: () {}),
                      BoldCircleButton('edit', active: true, onTap: () {}),
                    ])),
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
            _Section(
                title: 'Bottom app',
                composedOf: const ['Vidro (glass)', 'BoldNavigationButton', 'BoldIcon'],
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
                            primary: BoldNavAction(
                                label: 'Continuar', onPressed: () {}),
                            secondary: BoldNavAction(
                                label: 'Cancelar', onPressed: () {}),
                            safeBottom: false,
                          )),
                    ])),
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

            // ─────────────────────── MOTION / especiais ───────────────────
            const _TierHeader(
                tier: 'MOTION / especiais',
                description:
                    'Autorização Quântica — visual violeta, independente da marca.'),
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
                note: 'núcleo pintado (loop demo) — a tela cheia vive na aba Specs',
                builder: (_) => const Center(
                    child: SizedBox(
                        width: 200, height: 200, child: BoldQuantumCore()))),
            _Section(
                title: 'Limites (App list · valueAction)',
                composedOf: const [
                  'BoldAppList',
                  'BoldRightAccessory.valueAction',
                  'BoldIcon',
                  'Tipografia'
                ],
                builder: (context) {
                  final c = BoldColors.of(context);
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          BoldIcon('pix', size: 20, color: c.textPrimary),
                          const SizedBox(width: 8),
                          Text('Pix',
                              style: BoldType.title
                                  .copyWith(color: c.textPrimary)),
                        ]),
                        const SizedBox(height: 8),
                        Divider(height: 1, color: c.border),
                        BoldAppList(
                          middle:
                              const BoldMiddleAccessory.title(title: 'Diário'),
                          right: const BoldRightAccessory.valueAction(
                              value: 'R\$ 2.500,00'),
                          onTap: () {},
                        ),
                        BoldAppList(
                          middle:
                              const BoldMiddleAccessory.title(title: 'Noturno'),
                          right: const BoldRightAccessory.valueAction(
                              value: 'R\$ 2.500,00'),
                          onTap: () {},
                        ),
                      ]);
                }),
            _Section(
                title: 'Resumo de transação (BoldTransactionSummary)',
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
                                        initial: 'CR',
                                        size: 40,
                                        fontSize: 15)),
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
                            const BoldSummarySection(label: 'Detalhes', rows: [
                              BoldSummaryRow(
                                left: BoldLeftAccessory.spotIcon(
                                    icon: 'note-light-full',
                                    tone: BoldSpotTone.neutral),
                                title: 'Descrição',
                                subtitle: 'Uber de hoje',
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
            _Section(
                title: 'Amount display (BoldAmountDisplay)',
                composedOf: const ['Tipografia', 'Hairline'],
                builder: (_) => const BoldAmountDisplay(
                      value: 'R\$ 1.234,56',
                      label: 'Valor',
                      timestamp: 'Hoje · 14:20',
                    )),
            _Section(
                title: 'Detail row (BoldDetailRow)',
                composedOf: const ['BoldIcon', 'Tipografia', 'Hairline'],
                builder: (_) => const BoldDetailRow(
                      title: 'Chave Pix',
                      description: 'joao@email.com',
                      icon: 'key-light',
                      chevron: true,
                    )),
            _Section(
                title: 'Progress bar (BoldProgressBar)',
                composedOf: const ['Cor', 'Tipografia'],
                builder: (_) =>
                    const BoldProgressBar(value: 0.6, caption: '60% do limite')),
            _Section(
                title: 'Radio list (BoldRadioList)',
                composedOf: const ['BoldIcon', 'Tipografia'],
                builder: (_) {
                  var sel = 'pix';
                  return StatefulBuilder(
                    builder: (context, setLocal) => BoldRadioList(
                      title: 'Forma de pagamento',
                      value: sel,
                      onChanged: (v) => setLocal(() => sel = v),
                      options: const [
                        BoldRadioOption(value: 'pix', label: 'Pix'),
                        BoldRadioOption(value: 'boleto', label: 'Boleto'),
                        BoldRadioOption(value: 'cartao', label: 'Cartão'),
                      ],
                    ),
                  );
                }),
    ];
    final illustrations = <Widget>[
      const _TierHeader(
          tier: 'ILUSTRAÇÕES',
          description:
              'Ilustrações do CPF Seguro — cada uma com suas variações de tema.'),
      for (final il in _kIllustrations)
        _Section(
            title: il.label,
            note: il.themes.length < 3
                ? 'variações: Light · Dark'
                : 'variações: Light · Dark · Theme 3',
            builder: (_) => _IllustrationRow(il)),
    ];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: [
            // Visão geral (tier null) mostra a intro + todas as camadas em
            // ordem; uma camada selecionada mostra só as seções dela. `_sep`
            // intercala um divider entre seções consecutivas (não após header).
            if (t == null) const _Intro(),
            if (t == null || t == _DsTier.tokens) ..._sep(tokens),
            if (t == null || t == _DsTier.atoms) ..._sep(atoms),
            if (t == null || t == _DsTier.molecules) ..._sep(molecules),
            if (t == null || t == _DsTier.organisms) ..._sep(organisms),
            if (t == null || t == _DsTier.illustrations)
              ..._sep(illustrations),
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
    // Primary (rosa) — match exato.
    if (color == const Color(0xFF300313)) return BoldColors.primary01;
    if (color == const Color(0xFF600627)) return BoldColors.primary02;
    if (color == const Color(0xFFFE3976)) return BoldColors.primary04;
    if (color == const Color(0xFFF66FA0)) return BoldColors.primary05;
    if (color == const Color(0xFFFF87AB)) return BoldColors.primary06;
    if (color == const Color(0xFFFFB6CB)) return BoldColors.primary07;
    if (color == const Color(0xFFFFF6FA)) return BoldColors.primary09;
    // Neutral (cinza) — match exato com a rampa do DS.
    if (color == const Color(0xFF3D3939)) return BoldColors.neutral01;
    if (color == const Color(0xFF525252)) return BoldColors.neutral02;
    if (color == const Color(0xFF737373)) return BoldColors.neutral03;
    if (color == const Color(0xFF808080)) return BoldColors.neutral04;
    if (color == const Color(0xFFA0A0A0)) return BoldColors.neutral05;
    if (color == const Color(0xFFB3B3B3)) return BoldColors.neutral06;
    if (color == const Color(0xFFC6C6C6)) return BoldColors.neutral07;
    if (color == const Color(0xFFD9D9D9)) return BoldColors.neutral08;
    if (color == const Color(0xFFECECEC)) return BoldColors.neutral09;
    if (color == const Color(0xFFEBEBEB)) return BoldColors.neutral09; // ~snap
    if (color == const Color(0xFFF6F6F6)) return BoldColors.neutral10;
    // Line-art escuro → neutral00 (token novo). #262626 ~snap pro mesmo.
    if (color == const Color(0xFF2B2B2B)) return BoldColors.neutral00;
    if (color == const Color(0xFF262626)) return BoldColors.neutral00; // ~snap
    // Preto / branco.
    if (color == const Color(0xFF000000)) return BoldColors.black;
    if (color == const Color(0xFFFFFFFF)) return BoldColors.white;
    // Vermelho → error (match exato do error03).
    if (color == const Color(0xFFB42318)) return BoldColors.error03;
    // Corais/laranjas → rampa Warning (accent foi descontinuado do DS).
    if (color == const Color(0xFFFF7066)) return BoldColors.warning04;
    if (color == const Color(0xFFF47971)) return BoldColors.warning04;
    if (color == const Color(0xFFF9AA81)) return BoldColors.warning05;
    if (color == const Color(0xFFF3ABA5)) return BoldColors.warning05;
    // Âmbar/dourado → rampa Warning (mais próxima).
    if (color == const Color(0xFFF9AB43)) return BoldColors.warning05;
    if (color == const Color(0xFFFFCF74)) return BoldColors.warning06;
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
    final c = BoldColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Ramp('Primary', [
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
          ('00', BoldColors.neutral00),
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
        // Theme-aware: lê o scheme ATIVO (não as constantes do dark), então os
        // hex acompanham claro/escuro — espelhando o app.
        _Ramp('Fundo / superfície', [
          ('bg', c.background),
          ('flow', c.secondaryFlow),
          ('surf', c.surface),
          ('glass', BoldGlass.fill(c)),
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
                  '5 tipos (primary · secondary · secondaryPrimary · tertiary · tertiaryPrimary) × 3 tamanhos (sm 32 · md 40 · lg 56). error, disabled e badge são ortogonais — ver strip abaixo.',
              composedOf: const ['BoldIcon', 'Cores'],
              child: _VariantMatrix(
                rowAxis: 'Type',
                rows: const [
                  'secondary',
                  'secondaryPrimary',
                  'tertiary'
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
                  ('tint', BoldIconChip(Icons.qr_code, tint: BoldColors.primary)),
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
