import 'package:flutter/material.dart';
import 'design_system/bold_design_system.dart';

/// Aba "Mapa" — MAPA de dependências do DS Bold. Cada nó é um token/átomo/
/// molécula/organismo; cada aresta liga um componente ao que ele CONSOME.
/// Colunas = camadas atômicas (esquerda→direita: tokens → organismos), então
/// as arestas fluem da direita (consumidor) pra esquerda (matéria-prima).
/// Tocar num nó acende a rede dele (deps + dependentes); resto apaga.
/// (Portado do catálogo do CPF Seguro — mesma UX, tokens/nós do Bold.)
class DsTreeScreen extends StatefulWidget {
  const DsTreeScreen({super.key});
  @override
  State<DsTreeScreen> createState() => _DsTreeScreenState();
}

/// Nó do grafo: nome, camada, e o que consome (nomes de outros nós).
class _N {
  const _N(this.name, this.tier, [this.deps = const []]);
  final String name;
  final String tier;
  final List<String> deps;
}

// Grafo curado dos componentes reais do DS Bold (lib/design_system/). Token
// consumido = família referenciada no componente. Refinar conforme o DS evolui.
const _nodes = <_N>[
  // ── TOKENS (primitivos; Scheme deriva de Palette) ──
  _N('Palette', 'TOKENS'),
  _N('Scheme', 'TOKENS', ['Palette']),
  _N('Typography', 'TOKENS'),
  _N('Radius', 'TOKENS'),
  _N('Spacing', 'TOKENS'),
  _N('Glass', 'TOKENS', ['Scheme']),
  _N('Gradients', 'TOKENS', ['Palette']),
  _N('Icon', 'TOKENS'),
  // ── ATOMS ──
  _N('Logo', 'ATOMS', ['Palette']),
  _N('Background', 'ATOMS', ['Scheme', 'Palette']),
  _N('GlassSurface', 'ATOMS', ['Glass', 'Scheme']),
  _N('HomeIndicator', 'ATOMS', ['Scheme', 'Radius']),
  _N('PageDots', 'ATOMS', ['Palette', 'Scheme', 'Radius', 'Spacing']),
  _N('Avatar', 'ATOMS', ['Glass', 'Gradients', 'Scheme', 'Typography']),
  _N('Checkbox', 'ATOMS', ['Palette', 'Scheme', 'Radius']),
  _N('Switch', 'ATOMS', ['Palette', 'Scheme']),
  _N('Spinner', 'ATOMS', ['Palette']),
  // ── MOLECULES ──
  _N('SpotIcon', 'MOLECULES', ['Icon', 'Palette', 'Scheme', 'Spacing']),
  _N('StatusTag', 'MOLECULES', ['Icon', 'Scheme', 'Typography', 'Spacing']),
  _N('StatusBadge', 'MOLECULES', ['Palette', 'Typography']),
  _N('SectionHeader', 'MOLECULES', ['Scheme', 'Typography']),
  _N('PageTitle', 'MOLECULES', ['Scheme', 'Typography', 'Spacing']),
  _N('Button', 'MOLECULES', ['Icon', 'Scheme', 'Gradients', 'Radius']),
  _N('IconButton', 'MOLECULES', ['Icon', 'Scheme', 'Radius']),
  _N('CopyButton', 'MOLECULES', ['Icon', 'StatusTag', 'Scheme']),
  _N('InputChip', 'MOLECULES', ['Icon', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('SegmentedControl', 'MOLECULES', ['Scheme', 'Radius', 'Typography']),
  _N('TextField', 'MOLECULES', ['Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('SearchInput', 'MOLECULES', ['Icon', 'Scheme', 'Radius', 'Typography']),
  _N('Card', 'MOLECULES', ['Glass', 'Scheme', 'Radius']),
  _N('MenuTile', 'MOLECULES', ['Card', 'Icon', 'Scheme', 'Typography']),
  _N('EmptyState', 'MOLECULES', ['Icon', 'Scheme', 'Typography', 'Spacing']),
  _N('Illustration', 'MOLECULES', ['Palette', 'Scheme']),
  _N('Keypad', 'MOLECULES', ['Scheme', 'Radius', 'Typography']),
  _N('Stepper', 'MOLECULES', ['Palette', 'Scheme', 'Radius', 'Typography']),
  _N('AvatarRow', 'MOLECULES', ['Avatar', 'Scheme', 'Typography', 'Spacing']),
  _N('NavigationButton', 'MOLECULES', ['Button']),
  _N('NavTopBar', 'MOLECULES', ['IconButton', 'Avatar', 'InputChip', 'Scheme', 'Typography', 'Spacing']),
  _N('AppList', 'MOLECULES',
      ['SpotIcon', 'Avatar', 'StatusTag', 'IconButton', 'Checkbox', 'Switch', 'Icon', 'Scheme', 'Typography', 'Spacing']),
  // ── ORGANISMS ──
  _N('TopBar', 'ORGANISMS', ['NavTopBar', 'GlassSurface', 'Stepper', 'Scheme', 'Radius']),
  _N('BottomApp', 'ORGANISMS', ['NavigationButton', 'Keypad', 'HomeIndicator', 'GlassSurface', 'Scheme', 'Spacing']),
  _N('Toast', 'ORGANISMS', ['SpotIcon', 'Glass', 'Palette', 'Radius', 'Typography', 'Spacing']),
  _N('TransactionSummary', 'ORGANISMS',
      ['AppList', 'Button', 'SpotIcon', 'Avatar', 'Background', 'TopBar', 'Scheme', 'Typography', 'Spacing']),
  _N('Sheet', 'ORGANISMS', ['TopBar', 'Button', 'TextField', 'Scheme', 'Radius', 'Spacing']),
];

const _tiers = ['TOKENS', 'ATOMS', 'MOLECULES', 'ORGANISMS'];
const _colX = {'TOKENS': 150.0, 'ATOMS': 480.0, 'MOLECULES': 890.0, 'ORGANISMS': 1310.0};

// Cor por camada (ink, bg-claro).
const _tierInk = {
  'TOKENS': BoldColors.neutral02,
  'ATOMS': BoldColors.primary04,
  'MOLECULES': BoldColors.success04,
  'ORGANISMS': BoldColors.warning04,
};
const _tierBg = {
  'TOKENS': BoldColors.neutral10,
  'ATOMS': BoldColors.primary08,
  'MOLECULES': BoldColors.success07,
  'ORGANISMS': BoldColors.warning07,
};

const double _spacing = 33;
const double _canvasH = 1420;
const double _canvasW = 1480;
const double _nodeW = 158;
const double _nodeH = 24;

class _DsTreeScreenState extends State<DsTreeScreen> {
  String? _sel;

  Map<String, Offset> _positions() {
    final pos = <String, Offset>{};
    for (final t in _tiers) {
      final list = _nodes.where((n) => n.tier == t).toList();
      final startY = (_canvasH - list.length * _spacing) / 2 + _spacing / 2;
      for (var i = 0; i < list.length; i++) {
        pos[list[i].name] = Offset(_colX[t]!, startY + i * _spacing);
      }
    }
    return pos;
  }

  Set<String> _network(String sel) {
    final byName = {for (final n in _nodes) n.name: n};
    final set = <String>{sel};
    void down(String name) {
      for (final d in byName[name]?.deps ?? const <String>[]) {
        if (set.add(d)) down(d);
      }
    }
    void up(String name) {
      for (final n in _nodes) {
        if (n.deps.contains(name) && set.add(n.name)) up(n.name);
      }
    }
    down(sel);
    up(sel);
    return set;
  }

  @override
  Widget build(BuildContext context) {
    final pos = _positions();
    final hl = _sel == null ? null : _network(_sel!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 12),
          child: Row(
            children: [
              Text('Design System · Mapa de dependências',
                  style: BoldType.h2.copyWith(
                      color: BoldColors.neutral01, fontWeight: FontWeight.w700)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _sel == null
                      ? 'Cada aresta = "consome". Toque num nó pra acender a rede dele (mão pra arrastar, scroll pra zoom).'
                      : 'Rede de "$_sel" — ${hl!.length} nós conectados. Toque de novo pra limpar.',
                  style: BoldType.bodySm.copyWith(color: BoldColors.neutral04),
                ),
              ),
              for (final t in _tiers) ...[
                _LegendDot(color: _tierInk[t]!, label: t),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
        Expanded(
          child: ClipRect(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.3,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(500),
              child: SizedBox(
                width: _canvasW,
                height: _canvasH,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _EdgePainter(pos: pos, hl: hl)),
                    ),
                    for (final t in _tiers)
                      Positioned(
                        left: _colX[t]! - _nodeW / 2,
                        top: 12,
                        child: Text(t,
                            style: BoldType.labelSm.copyWith(
                                color: _tierInk[t], fontWeight: FontWeight.w700)),
                      ),
                    for (final n in _nodes)
                      Positioned(
                        left: pos[n.name]!.dx - _nodeW / 2,
                        top: pos[n.name]!.dy - _nodeH / 2,
                        child: _NodeChip(
                          node: n,
                          selected: _sel == n.name,
                          dimmed: hl != null && !hl.contains(n.name),
                          onTap: () => setState(
                              () => _sel = _sel == n.name ? null : n.name),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EdgePainter extends CustomPainter {
  _EdgePainter({required this.pos, required this.hl});
  final Map<String, Offset> pos;
  final Set<String>? hl;

  @override
  void paint(Canvas canvas, Size size) {
    for (final n in _nodes) {
      final to = pos[n.name];
      if (to == null) continue;
      for (final d in n.deps) {
        final from = pos[d];
        if (from == null) continue;
        final active = hl != null && hl!.contains(n.name) && hl!.contains(d);
        final faded = hl != null && !active;
        final color = active
            ? (_tierInk[n.tier] ?? BoldColors.neutral04)
            : BoldColors.neutral05;
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = active ? 1.8 : 1
          ..color = color.withValues(alpha: active ? 0.85 : (faded ? 0.04 : 0.08));

        final start = Offset(from.dx + _nodeW / 2, from.dy);
        final end = Offset(to.dx - _nodeW / 2, to.dy);
        final dx = (end.dx - start.dx) * 0.5;
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(start.dx + dx, start.dy, end.dx - dx, end.dy, end.dx, end.dy);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter old) => old.hl != hl;
}

class _NodeChip extends StatelessWidget {
  const _NodeChip({
    required this.node,
    required this.selected,
    required this.dimmed,
    required this.onTap,
  });
  final _N node;
  final bool selected;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = _tierInk[node.tier]!;
    final bg = _tierBg[node.tier]!;
    return Opacity(
      opacity: dimmed ? 0.28 : 1,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: _nodeW,
            height: _nodeH,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? ink : bg,
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: ink, width: selected ? 1.5 : 1),
            ),
            child: Text(
              node.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BoldType.labelSm.copyWith(
                color: selected ? BoldColors.white : ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: BoldType.labelSm.copyWith(color: BoldColors.neutral04, letterSpacing: 0.5)),
      ],
    );
  }
}
