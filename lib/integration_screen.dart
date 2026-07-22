// Conta BOLD — Integração (adoção real do DS no app).
//
// Espelha a aba "Integração" do catálogo CPF: um tracker de quanto do app
// (app-newbold) já consome o Design System via `package:conta_bold_ds` (ds.X).
// Dados reais da auditoria: 136 arquivos importam o DS; a tabela abaixo lista
// as superfícies e o quanto cada uma é consumida (call-sites por ds.X).
import 'package:flutter/material.dart';
import 'design_system/bold_design_system.dart';

// ── Camada atômica (dimensão ortogonal ao status) ────────────────────────────
enum _Layer { token, atom, molecule, organism }

extension _LayerX on _Layer {
  String get label => switch (this) {
        _Layer.token => 'token',
        _Layer.atom => 'átomo',
        _Layer.molecule => 'molécula',
        _Layer.organism => 'organismo',
      };
  Color get accent => switch (this) {
        _Layer.token => BoldColors.neutral04,
        _Layer.atom => BoldColors.primary04,
        _Layer.molecule => BoldColors.warning04,
        _Layer.organism => BoldColors.success04,
      };
}

// ── Status de adoção ─────────────────────────────────────────────────────────
enum _Status { adotado, pontual, disponivel }

extension _StatusX on _Status {
  String get label => switch (this) {
        _Status.adotado => 'Adotado',
        _Status.pontual => 'Pontual',
        _Status.disponivel => 'Disponível',
      };
  String get blurb => switch (this) {
        _Status.adotado =>
          'Consumido em várias telas via ds.X — parte viva do app.',
        _Status.pontual =>
          'Consumido em 1–2 telas. Adoção parcial, pronto para expandir.',
        _Status.disponivel =>
          'Publicado no DS, sem uso no app hoje. Pronto para adotar.',
      };
  Color get accent => switch (this) {
        _Status.adotado => BoldColors.success04,
        _Status.pontual => BoldColors.warning04,
        _Status.disponivel => BoldColors.neutral04,
      };
}

// SSOT — cada superfície do DS + status de adoção + call-sites reais (ds.X).
class _Item {
  const _Item(this.name, this.status, this.layer, {this.sites, this.note});
  final String name;
  final _Status status;
  final _Layer layer;
  final int? sites; // call-sites ds.X no app (grep), quando conhecido
  final String? note;
}

const _items = <_Item>[
  // ── Tokens ──────────────────────────────────────────────────────────────
  _Item('BoldColors / AppColors', _Status.adotado, _Layer.token, sites: 1067,
      note: 'ds.AppColors (899) + ds.BoldColors (168)'),
  _Item('BoldSpace / AppSpacing', _Status.adotado, _Layer.token, sites: 1190,
      note: 'ds.BoldSpace (842) + ds.AppSpacing (348)'),
  _Item('BoldType / AppTextStyles', _Status.adotado, _Layer.token, sites: 706,
      note: 'ds.AppTextStyles (420) + ds.BoldType (286)'),
  _Item('BoldRadius / AppRadius', _Status.adotado, _Layer.token, sites: 113),
  _Item('AppShadows / BoldElevation', _Status.adotado, _Layer.token, sites: 15),
  _Item('BoldGradients', _Status.pontual, _Layer.token,
      note: 'via componentes (promo, pix, balance)'),
  _Item('BoldGlass', _Status.adotado, _Layer.token,
      note: 'spec única de vidro, consumida por todo container'),
  _Item('BoldMotion', _Status.disponivel, _Layer.token,
      note: 'presets de entrada — pouco uso direto'),
  // ── Átomos ──────────────────────────────────────────────────────────────
  _Item('BoldIcon', _Status.adotado, _Layer.atom, sites: 46),
  _Item('BoldSkeleton', _Status.adotado, _Layer.atom, sites: 20),
  _Item('BoldStatusTag', _Status.adotado, _Layer.atom, sites: 12),
  _Item('BoldSpotIcon', _Status.adotado, _Layer.atom, sites: 19),
  _Item('BoldSpotTone', _Status.adotado, _Layer.atom, sites: 93),
  _Item('BoldCheckbox', _Status.pontual, _Layer.atom),
  _Item('BoldSwitch', _Status.pontual, _Layer.atom),
  _Item('BoldLogo', _Status.pontual, _Layer.atom),
  _Item('BoldPixMark', _Status.pontual, _Layer.atom),
  _Item('BoldGlassAvatar', _Status.pontual, _Layer.atom,
      note: 'catálogo à frente do app (65 > 29 linhas)'),
  // ── Moléculas ───────────────────────────────────────────────────────────
  _Item('BoldButton / AppButton', _Status.adotado, _Layer.molecule, sites: 115,
      note: 'ds.BoldButton (57) + ds.AppButton (58)'),
  _Item('BoldTextField', _Status.adotado, _Layer.molecule, sites: 67),
  _Item('BoldCard', _Status.adotado, _Layer.molecule, sites: 43),
  _Item('BoldSectionHeader', _Status.adotado, _Layer.molecule, sites: 44),
  _Item('BoldIconButton', _Status.adotado, _Layer.molecule, sites: 12,
      note: 'catálogo à frente (302 > 285 linhas)'),
  _Item('BoldAlert', _Status.adotado, _Layer.molecule, sites: 15),
  _Item('BoldNavAction', _Status.adotado, _Layer.molecule, sites: 43),
  _Item('BoldMoneyInputFormatter', _Status.adotado, _Layer.molecule, sites: 21),
  _Item('BoldSearchInput', _Status.pontual, _Layer.molecule),
  _Item('BoldSelectField', _Status.pontual, _Layer.molecule,
      note: 'usado em 1 tela'),
  _Item('BoldPromoCard / BoldPromoBanner', _Status.pontual, _Layer.molecule),
  _Item('BoldNoticeRow', _Status.pontual, _Layer.molecule),
  _Item('BoldQuickAction', _Status.disponivel, _Layer.molecule,
      note: '0 uso hoje — mantido no catálogo'),
  // ── Organismos ──────────────────────────────────────────────────────────
  _Item('BoldTopBar', _Status.adotado, _Layer.organism, sites: 72),
  _Item('BoldAppList', _Status.adotado, _Layer.organism, sites: 171,
      note: 'ds.BoldAppList (114) + ds.BoldAppListGroup (57)'),
  _Item('BoldMiddle/Left/RightAccessory', _Status.adotado, _Layer.organism,
      sites: 221, note: 'os acessórios plugáveis do BoldAppList'),
  _Item('BoldBackground / BoldBackdrop', _Status.adotado, _Layer.organism,
      sites: 133),
  _Item('BoldBottomApp', _Status.adotado, _Layer.organism, sites: 37),
  _Item('BoldSheet', _Status.adotado, _Layer.organism, sites: 20),
  _Item('BoldToast', _Status.adotado, _Layer.organism, sites: 124),
  _Item('BoldDialog', _Status.adotado, _Layer.organism, sites: 16),
  _Item('BoldReceipt', _Status.adotado, _Layer.organism, sites: 58,
      note: 'ds.BoldReceiptRow (46) + ds.BoldReceiptSection (12)'),
  _Item('BoldBalance', _Status.pontual, _Layer.organism),
  _Item('BoldTransactionSummary', _Status.pontual, _Layer.organism),
  _Item('BoldTabBar', _Status.pontual, _Layer.organism,
      note: 'usado em 1 tela (HomeFlatNav)'),
  _Item('BoldQuantumSeal / QuantumCore', _Status.pontual, _Layer.organism,
      note: 'Autorização Quântica'),
  _Item('BoldAccordion', _Status.disponivel, _Layer.organism,
      note: '0 uso hoje'),
  _Item('BoldBottomNav', _Status.disponivel, _Layer.organism,
      note: '0 uso hoje'),
];

class IntegrationScreen extends StatefulWidget {
  const IntegrationScreen({super.key});
  @override
  State<IntegrationScreen> createState() => _IntegrationScreenState();
}

class _IntegrationScreenState extends State<IntegrationScreen> {
  _Status? _filter; // null = todos

  int _count(_Status s) => _items.where((i) => i.status == s).length;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final total = _items.length;
    final adotado = _count(_Status.adotado);
    final pct = (adotado / total * 100).round();
    final shown =
        _filter == null ? _items : _items.where((i) => i.status == _filter);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Integração',
                style: BoldType.headlineMd.copyWith(color: c.textPrimary)),
            const SizedBox(height: 8),
            Text(
                'Adoção real do Design System no app-newbold. 136 arquivos '
                'importam `package:conta_bold_ds` e consomem as superfícies via '
                '`ds.X`. Cada linha abaixo é uma superfície do DS e o quanto o '
                'app já a consome (call-sites reais).',
                style: BoldType.bodySmall
                    .copyWith(color: c.textSecondary, height: 1.5)),
            const SizedBox(height: 24),
            _SummaryPanel(pct: pct, total: total),
            const SizedBox(height: 24),
            _ReachPanel(),
            const SizedBox(height: 24),
            const _DebtPanel(),
            const SizedBox(height: 28),
            // Filtros por status.
            Wrap(spacing: 8, runSpacing: 8, children: [
              _FilterTab(
                  label: 'Todos',
                  count: total,
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null)),
              for (final s in _Status.values)
                _FilterTab(
                    label: s.label,
                    count: _count(s),
                    accent: s.accent,
                    selected: _filter == s,
                    onTap: () => setState(() => _filter = s)),
            ]),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [for (final it in shown) _ItemCard(it)],
            ),
          ]),
        ),
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.pct, required this.total});
  final int pct;
  final int total;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final adotado = _items.where((i) => i.status == _Status.adotado).length;
    final pontual = _items.where((i) => i.status == _Status.pontual).length;
    final disp = _items.where((i) => i.status == _Status.disponivel).length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$pct%',
              style: BoldType.display.copyWith(color: BoldColors.primary04)),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('adotado amplamente',
                style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
          ),
        ]),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Row(children: [
              Expanded(flex: adotado, child: const ColoredBox(color: BoldColors.success04)),
              Expanded(flex: pontual, child: const ColoredBox(color: BoldColors.warning04)),
              Expanded(flex: disp, child: const ColoredBox(color: BoldColors.neutral06)),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 16, runSpacing: 8, children: [
          _Dot(BoldColors.success04, 'Adotado · $adotado'),
          _Dot(BoldColors.warning04, 'Pontual · $pontual'),
          _Dot(BoldColors.neutral06, 'Disponível · $disp'),
        ]),
        const SizedBox(height: 20),
        Divider(height: 1, color: c.border),
        const SizedBox(height: 16),
        Text('POR CAMADA DA LINGUAGEM',
            style: BoldType.labelSm.copyWith(
                color: c.textMuted, letterSpacing: 1, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: [
          for (final l in _Layer.values) _LayerTally(l),
        ]),
      ]),
    );
  }
}

class _LayerTally extends StatelessWidget {
  const _LayerTally(this.layer);
  final _Layer layer;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final all = _items.where((i) => i.layer == layer).toList();
    final adopted =
        all.where((i) => i.status == _Status.adotado).length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: layer.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: layer.accent.withValues(alpha: 0.4)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: layer.accent, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(layer.label,
            style: BoldType.labelMd.copyWith(color: c.textPrimary)),
        const SizedBox(width: 8),
        Text('$adopted/${all.length}',
            style: BoldType.labelMd.copyWith(
                color: layer.accent, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// Alcance da adoção por área do app (grep de imports).
class _ReachPanel extends StatelessWidget {
  const _ReachPanel();
  static const _areas = <(String, int)>[
    ('features', 126),
    ('shared', 7),
    ('core', 1),
    ('app / main', 2),
  ];
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('136',
              style: BoldType.display.copyWith(color: c.textPrimary)),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('arquivos consomem o DS (ds.X)',
                style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
          ),
        ]),
        const SizedBox(height: 8),
        Text('DISTRIBUIÇÃO POR ÁREA',
            style: BoldType.labelSm.copyWith(
                color: c.textMuted, letterSpacing: 1, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: [
          for (final (name, n) in _areas)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: c.field,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(name,
                    style: BoldType.labelMd.copyWith(color: c.textPrimary)),
                const SizedBox(width: 8),
                Text('$n',
                    style: BoldType.labelMd.copyWith(
                        color: BoldColors.primary04,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
        ]),
      ]),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab(
      {required this.label,
      required this.count,
      required this.selected,
      required this.onTap,
      this.accent});
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final Color? accent;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final fill = accent ?? BoldColors.primary04;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? fill.withValues(alpha: 0.16) : BoldColors.transparent,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(color: selected ? fill : c.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: BoldType.labelMd.copyWith(
                  color: selected ? fill : c.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Text('$count',
              style: BoldType.labelSm.copyWith(
                  color: selected ? fill : c.textMuted)),
        ]),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard(this.item);
  final _Item item;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return SizedBox(
      width: 328,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.isDark ? c.surface : BoldColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _Pill(item.layer.label, item.layer.accent),
            const Spacer(),
            _Pill(item.status.label, item.status.accent, solid: true),
          ]),
          const SizedBox(height: 10),
          Text(item.name,
              style: BoldType.title.copyWith(color: c.textPrimary)),
          if (item.sites != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.data_usage_rounded, size: 13, color: c.textMuted),
              const SizedBox(width: 5),
              Text('${item.sites} call-sites ds.X',
                  style: BoldType.labelSm.copyWith(color: c.textSecondary)),
            ]),
          ],
          if (item.note != null) ...[
            const SizedBox(height: 8),
            Text(item.note!,
                style: BoldType.bodySmall
                    .copyWith(color: c.textMuted, height: 1.4)),
          ],
        ]),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.accent, {this.solid = false});
  final String label;
  final Color accent;
  final bool solid;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: solid ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: BoldType.labelSm.copyWith(
              color: accent, fontWeight: FontWeight.w700, fontSize: 10)),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color, this.label);
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: BoldType.labelSm.copyWith(color: c.textSecondary)),
    ]);
  }
}

// ── Débito de aderência: o que AINDA é inline/fora do DS nas telas ────────────
// Contagens reais (grep em lib/features + lib/shared + lib/core do app-newbold).
class _DebtRow {
  final int count;
  final String label;
  final String hint;
  const _DebtRow(this.count, this.label, this.hint);
}

const _looseTokens = <_DebtRow>[
  _DebtRow(133, 'EdgeInsets numérico', 'snap → ds.AppSpacing / ds.BoldSpace'),
  _DebtRow(68, 'fontSize solto', 'usar estilo ds.BoldType'),
  _DebtRow(32, 'Colors.X (não-transparente)', '→ ds.AppColors / ds.BoldColors'),
  _DebtRow(20, 'BorderRadius.circular(n)', '→ ds.AppRadius'),
  _DebtRow(11, 'Color(0x..) literal', '→ token de cor do DS'),
];

const _inlineWidgets = <_DebtRow>[
  _DebtRow(200, 'BoxDecoration (card/superfície cru)', '→ ds.BoldCard / ds.BoldGlassSurface'),
  _DebtRow(92, 'Scaffold cru', '→ scaffold local do DS'),
  _DebtRow(19, 'botão cru (Elevated/Text/Outlined/Material)', '→ ds.BoldButton'),
  _DebtRow(11, 'TextField/TextFormField cru', '→ ds.BoldTextField'),
  _DebtRow(3, 'showDialog / showModalBottomSheet cru', '→ ds.BoldDialog / ds.BoldSheet'),
  _DebtRow(3, 'AppBar cru', '→ ds.BoldTopBar'),
];

class _DebtPanel extends StatelessWidget {
  const _DebtPanel();
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final loose = _looseTokens.fold<int>(0, (a, r) => a + r.count);
    final inline = _inlineWidgets.fold<int>(0, (a, r) => a + r.count);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.isDark ? c.surface : BoldColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Débito de aderência',
            style: BoldType.titleMd.copyWith(color: c.textPrimary)),
        const SizedBox(height: 4),
        Text(
            'O que ainda é inline / fora do DS nas telas (grep real). '
            'Meta: cada linha vira token ou componente do DS (snap ao mais '
            'próximo ou enriquecer a palavra que encaixa). Colors.transparent '
            '(109) não conta — é semântico.',
            style: BoldType.bodySm.copyWith(color: c.textSecondary, height: 1.5)),
        const SizedBox(height: 20),
        _debtGroup(c, 'Tokens soltos', loose, _looseTokens),
        const SizedBox(height: 20),
        _debtGroup(c, 'Widgets inline (fora do DS)', inline, _inlineWidgets),
      ]),
    );
  }

  Widget _debtGroup(BoldScheme c, String title, int total, List<_DebtRow> rows) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(title, style: BoldType.labelMd.copyWith(color: c.textPrimary)),
        const SizedBox(width: 8),
        Text('$total',
            style: BoldType.labelMd.copyWith(color: BoldColors.warning04)),
      ]),
      const SizedBox(height: 10),
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            SizedBox(
              width: 44,
              child: Text('${r.count}',
                  textAlign: TextAlign.right,
                  style: BoldType.labelMd.copyWith(color: c.textPrimary)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(r.label,
                  style: BoldType.bodySm.copyWith(color: c.textPrimary)),
            ),
            Text(r.hint,
                style: BoldType.labelSm.copyWith(color: c.textSecondary)),
          ]),
        ),
    ]);
  }
}
