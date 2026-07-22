// Conta BOLD — Gramática (aba Foundations).
//
// Como o sistema se compõe: o DS lido como uma LINGUAGEM (vocabulário +
// gramática + dicionário) e a progressão TOKEN → ÁTOMO → MOLÉCULA → ORGANISMO.
// Espelha a Gramática do catálogo do CPF Seguro, com os tokens/componentes do
// Bold. Renderiza componentes REAIS onde mostra exemplo vivo.
import 'package:flutter/material.dart';
import 'design_system/bold_design_system.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gramática',
                style: BoldType.headlineMd.copyWith(color: c.textPrimary)),
            const SizedBox(height: 8),
            Text(
                'O Design System do Conta BOLD é uma LINGUAGEM. O vocabulário são '
                'os tokens (cor, tipografia, vidro, gradiente); a gramática é a '
                'ordem em que eles se combinam — TOKEN → ÁTOMO → MOLÉCULA → '
                'ORGANISMO; o dicionário é o catálogo de componentes. Cada peça '
                'só consome as da camada abaixo, nunca valores crus.',
                style: BoldType.bodySmall
                    .copyWith(color: c.textSecondary, height: 1.5)),
            const SizedBox(height: 28),
            const _LanguageBanner(),
            const _SectionHead('1 · CAMADAS',
                'A progressão atômica. Cada camada consome a anterior.'),
            const _LayersFlow(),
            const _SectionHead('2 · REGRA DE OURO',
                'O componente consome o TOKEN/PAPEL, nunca o valor cru.'),
            const _RoleRule(),
            const _SectionHead('3 · GRAMÁTICA DE SUPERFÍCIE',
                'Toda tela é TOPO · CONTEÚDO · RODAPÉ. O vidro é característica '
                'de container, nunca de elemento solto.'),
            const _SurfaceGrammar(),
            const _SectionHead('4 · GRAMÁTICA DE LINHA',
                'Uma linha de lista é ESQUERDA · MEIO · DIREITA — acessórios '
                'plugáveis no BoldAppList.'),
            const _RowGrammar(),
          ]),
        ),
      ),
    );
  }
}

// Banner: o DS-como-linguagem em 3 colunas.
class _LanguageBanner extends StatelessWidget {
  const _LanguageBanner();

  static const _cols = <(String, String, String)>[
    ('VOCABULÁRIO', 'Tokens',
        'BoldColors · BoldType · BoldGradients · BoldGlass · BoldSpace · BoldRadius. As palavras do sistema.'),
    ('GRAMÁTICA', 'Composição',
        'Token → Átomo → Molécula → Organismo. A ordem em que as palavras viram frases.'),
    ('DICIONÁRIO', 'Componentes',
        'Os widgets Bold* — cada um declara o que o compõe. As frases prontas.'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BoldColors.primary04.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BoldColors.primary04.withValues(alpha: 0.24)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final (over, title, desc) in _cols)
            SizedBox(
              width: 300,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 4, 8, 4),
                decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: BoldColors.primary04, width: 3)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(over,
                          style: BoldType.labelSm.copyWith(
                              color: BoldColors.primary04,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(title,
                          style: BoldType.title.copyWith(color: c.textPrimary)),
                      const SizedBox(height: 4),
                      Text(desc,
                          style: BoldType.bodySmall.copyWith(
                              color: c.textSecondary, height: 1.4)),
                    ]),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHead extends StatelessWidget {
  const _SectionHead(this.over, this.desc);
  final String over;
  final String desc;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(over,
            style: BoldType.labelLg.copyWith(
                color: c.textPrimary, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(desc, style: BoldType.bodySmall.copyWith(color: c.textMuted)),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: child,
    );
  }
}

// A progressão TOKEN → ÁTOMO → MOLÉCULA → ORGANISMO como nós conectados.
class _LayersFlow extends StatelessWidget {
  const _LayersFlow();

  static const _layers = <(String, String, Color)>[
    ('TOKEN', 'BoldColors · BoldType\nBoldGradients · BoldGlass', BoldColors.neutral04),
    ('ÁTOMO', 'BoldIcon · BoldAvatar\nBoldCheckbox · BoldStatusTag', BoldColors.primary04),
    ('MOLÉCULA', 'BoldButton · BoldTextField\nBoldSpotIcon · BoldCard', BoldColors.warning04),
    ('ORGANISMO', 'BoldTopBar · BoldBalance\nBoldBottomApp · BoldReceipt', BoldColors.success04),
  ];

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return _Card(
      child: Wrap(
        spacing: 4,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < _layers.length; i++) ...[
            _LayerNode(
                layer: _layers[i].$1,
                example: _layers[i].$2,
                accent: _layers[i].$3),
            if (i < _layers.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  BoldIcon('arrow-right-long-light',
                      size: 18, color: c.textMuted),
                  Text('consome',
                      style: BoldType.labelSm
                          .copyWith(color: c.textMuted, fontSize: 9)),
                ]),
              ),
          ],
        ],
      ),
    );
  }
}

class _LayerNode extends StatelessWidget {
  const _LayerNode(
      {required this.layer, required this.example, required this.accent});
  final String layer;
  final String example;
  final Color accent;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      width: 176,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(layer,
              style: BoldType.labelMd.copyWith(
                  color: c.textPrimary, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        Text(example,
            style: BoldType.labelSm
                .copyWith(color: c.textSecondary, fontSize: 11, height: 1.5)),
      ]),
    );
  }
}

// Regra de ouro: nunca hardcode, sempre token/papel.
class _RoleRule extends StatelessWidget {
  const _RoleRule();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: const [
        _RuleCard(
          ok: false,
          title: 'Nunca — valor cru',
          code: "Container(\n  color: Color(0xFFFE3976),\n  child: Text('Pix',\n    style: TextStyle(fontSize: 17)),\n)",
          why: 'Hex e tamanho soltos não trocam de tema nem cascateiam quando o DS muda.',
        ),
        _RuleCard(
          ok: true,
          title: 'Sempre — token / papel',
          code: "Container(\n  color: BoldColors.primary04,\n  child: Text('Pix',\n    style: BoldType.title.copyWith(\n      color: BoldColors.of(context).textPrimary)),\n)",
          why: 'O papel resolve por tema; mudou o token, muda em todo o app de uma vez.',
        ),
      ],
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard(
      {required this.ok,
      required this.title,
      required this.code,
      required this.why});
  final bool ok;
  final String title;
  final String code;
  final String why;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final accent = ok ? BoldColors.success04 : BoldColors.error04;
    return SizedBox(
      width: 440,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: 0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(ok ? Icons.check_circle : Icons.cancel,
                size: 16, color: accent),
            const SizedBox(width: 6),
            Text(title,
                style: BoldType.labelMd
                    .copyWith(color: accent, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BoldColors.neutral01,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(code,
                style: BoldType.mono.copyWith(
                    color: BoldColors.neutral08, fontSize: 12, height: 1.5)),
          ),
          const SizedBox(height: 10),
          Text(why,
              style: BoldType.bodySmall
                  .copyWith(color: c.textSecondary, height: 1.4)),
        ]),
      ),
    );
  }
}

// Gramática de superfície: TOPO · CONTEÚDO · RODAPÉ + exemplo glass vivo.
class _SurfaceGrammar extends StatelessWidget {
  const _SurfaceGrammar();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    Widget region(String label, String desc, double h) => Container(
          width: double.infinity,
          height: h,
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: BoldColors.primary04.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BoldColors.primary04.withValues(alpha: 0.3)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: BoldType.labelMd.copyWith(
                    color: c.textPrimary, fontWeight: FontWeight.w700)),
            Text(desc,
                style: BoldType.labelSm.copyWith(color: c.textMuted)),
          ]),
        );
    return _Card(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(children: [
            region('TOPO', 'BoldTopBar · BoldNavTopBar', 64),
            region('CONTEÚDO', 'listas, cards, campos — rola', 150),
            region('RODAPÉ', 'BoldBottomApp · BoldHomeIndicator', 64),
          ]),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Exemplo vivo — vidro de container',
                style: BoldType.labelSm.copyWith(color: c.textMuted)),
            const SizedBox(height: 8),
            const BoldGlassSurface(
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
            const SizedBox(height: 12),
            BoldCard(
              glass: true,
              child: Text('BoldCard(glass: true) — a mesma spec de vidro.',
                  style: BoldType.bodySmall.copyWith(color: c.textPrimary)),
            ),
          ]),
        ),
      ]),
    );
  }
}

// Gramática de linha: ESQUERDA · MEIO · DIREITA + linhas reais do BoldAppList.
class _RowGrammar extends StatelessWidget {
  const _RowGrammar();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    Widget slot(String label, int flex, Color accent) => Expanded(
          flex: flex,
          child: Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            child: Text(label,
                style: BoldType.labelSm.copyWith(
                    color: c.textPrimary, fontWeight: FontWeight.w600)),
          ),
        );
    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          slot('ESQUERDA', 2, BoldColors.primary04),
          slot('MEIO', 4, BoldColors.warning04),
          slot('DIREITA', 2, BoldColors.success04),
        ]),
        const SizedBox(height: 8),
        Text('leadingAccessory · título/subtítulo · trailingAccessory',
            style: BoldType.labelSm.copyWith(color: c.textMuted)),
        const SizedBox(height: 16),
        BoldAppListGroup(children: [
          BoldAppList.activityItem(
              icon: 'pix-light',
              iconTone: BoldSpotTone.success,
              title: 'Recebido de Diletta',
              subtitle: 'PIX',
              time: '14:20',
              status: const BoldStatusTagData(
                  label: 'Concluído', tone: BoldStatusTone.success)),
          BoldAppList.menuItem(
              icon: 'bank',
              title: 'Minha conta',
              subtitle: 'Ag 0001 · Conta 12345-6',
              onTap: () {}),
        ]),
      ]),
    );
  }
}
