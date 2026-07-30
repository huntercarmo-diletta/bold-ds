import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_status_tag.dart';

/// CPF SEGURO — FeatureCard (molécula).
///
/// Card 150×150 de acesso rápido com status. **Decisão (07-21): adotar o look
/// do app** (QuickAccessCardWithStatusComponent):
/// - superfície branca (surface) + border neutral-09, radius 16
/// - tile de ícone 34×34 colorido ([brandColor] — o consumidor passa a cor de
///   estado: primary-04 ativo / neutral-06 inativo) com [icon] branco
/// - título ([fg]) + descrição ([textMuted]) alinhados embaixo
/// - **status em OVERLAY** no canto superior-direito ([DilettaStatusTag])
///
/// A máquina de estado (habilitado/processando/bloqueado/loading) fica no
/// consumidor, que alimenta [brandColor] + [status].
class DilettaFeatureCard extends StatelessWidget {
  const DilettaFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.brandColor,
    required this.description,
    this.status,
    this.statusOverlay,
    this.actionLabel,
    this.iconColor = DilettaAbsoluteColors.white,
    this.onTap,
  });

  final String icon;
  final String title;

  /// Legado — o look do app não tem CTA no card; mantido por compat, não
  /// renderizado.
  final String? actionLabel;

  /// Cor do tile de ícone — o consumidor passa a cor do ESTADO (primary-04
  /// ativo, neutral-06 inativo, etc.).
  final Color brandColor;
  final Color iconColor;

  /// Status simples (chip). Ignorado se [statusOverlay] for passado.
  final DilettaStatusTagData? status;

  /// Slot do overlay (canto superior-direito) — o consumidor passa o que a
  /// máquina de estado exigir (StatusTag, ícone, loader). Prioridade sobre
  /// [status].
  final Widget? statusOverlay;
  final String description;
  final VoidCallback? onTap;

  Widget? get _overlay =>
      statusOverlay ??
      (status != null
          ? DilettaStatusTag(
              label: status!.label, tone: status!.tone, icon: status!.icon)
          : null);

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    Widget card = SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(DilettaSpacing.s4),
            decoration: BoxDecoration(
              color: s.surface,
              borderRadius: DilettaRadius.all16,
              border: Border.all(color: s.divider, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: brandColor,
                    borderRadius: DilettaRadius.all8,
                  ),
                  child: DilettaIconAccessory(
                      icon: icon, padding: 0, size: 18, color: iconColor),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DilettaType.bodyMd
                      .copyWith(color: s.fg, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DilettaType.labelSm.copyWith(color: s.textMuted),
                ),
              ],
            ),
          ),
          if (_overlay != null)
            Positioned(top: 12, right: 12, child: _overlay!),
        ],
      ),
    );

    if (onTap != null) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: card,
        ),
      );
    }
    return DilettaDevInfo(
      component: 'DilettaFeatureCard',
      props: {
        'title': "'$title'",
        'icon': icon,
        if (status != null) 'status': "'${status!.label}' (${status!.tone.name})",
      },
      tokens: [
        '150×150 · radius 16 · surface + border neutral-09 (look do app)',
        'tile 34 ${nomeDoToken(context, brandColor)} · status em overlay top-right',
      ],
      child: card,
    );
  }
}
