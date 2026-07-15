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
  // Destino selecionado na navegação lateral: -1 = Design System;
  // 0.. = índice do fluxo em [kFlows].
  int _dest = -1;
  _Tab _dsTab = _Tab.preview;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Fundo sólido e limpo (sem imagem/glass): branco no claro, neutral escuro
    // no dark. As superfícies glass dos componentes leem por cima dele.
    final bg = c.isDark ? c.background : BoldColors.white;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Sidebar(
              dest: _dest,
              onSelect: (d) => setState(() => _dest = d),
              isDark: c.isDark,
              onToggleTheme: () =>
                  widget.onMode(c.isDark ? ThemeMode.light : ThemeMode.dark),
            ),
            Expanded(
              child: _dest == -1
                  ? _DesignSystemView(
                      tab: _dsTab,
                      onTab: (t) => setState(() => _dsTab = t),
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
    required this.isDark,
    required this.onToggleTheme,
  });
  final int dest;
  final ValueChanged<int> onSelect;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<_Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<_Sidebar> {
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
                _railItem(context,
                    icon: 'puzzle-light',
                    tooltip: 'Design System',
                    selected: dest == -1,
                    onTap: () => onSelect(-1)),
                for (final g in groups.entries) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    child: Divider(height: 1, color: c.border),
                  ),
                  for (final i in g.value)
                    _railItem(context,
                        icon: kFlows[i].icon,
                        tooltip: '${g.key} · ${kFlows[i].name}',
                        selected: dest == i,
                        onTap: () => onSelect(i)),
                ],
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
              _navItem(context,
                  icon: 'puzzle-light',
                  label: 'Design System',
                  selected: dest == -1,
                  onTap: () => onSelect(-1)),
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
  const _DesignSystemView({required this.tab, required this.onTab});
  final _Tab tab;
  final ValueChanged<_Tab> onTab;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 20, 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: Row(children: [
          Expanded(
            child: Text('Design System',
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
        ]),
      ),
      Expanded(
        child: tab == _Tab.preview ? const _PreviewTab() : const _SpecsTab(),
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
