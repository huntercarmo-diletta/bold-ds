import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_status_tag.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — InfoCard (molécula).
///
/// Card horizontal com borda: ícone à esquerda + título (+ [DilettaStatusTag]
/// opcional à direita) + descrição multi-linha. Padrão das telas de detalhe de
/// funcionalidade ("O que é a Carteira", "Sou eu", "CPF Seguro"...).
///
/// **Composição** — CONSOME [DilettaStatusTag] (átomo) direto: mudança na tag
/// reflete aqui. Também usa Icon (átomo) + tokens. Não reimplementa o pill.
class DilettaInfoCard extends StatelessWidget {
  const DilettaInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.status,
    this.onTap,
  });

  /// Token de ícone (ex. `DilettaIcons.walletLight`).
  final String icon;
  final String title;
  final String description;

  /// Tag de status opcional (available/soon…). Renderizada por
  /// [DilettaStatusTag] — o InfoCard só carrega os dados.
  final DilettaStatusTagData? status;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    Widget card = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DilettaSpacing.s3,
        vertical: DilettaSpacing.s2,
      ),
      decoration: BoxDecoration(
        borderRadius: DilettaRadius.all8,
        border: Border.all(color: s.divider, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: DilettaSpacing.s1),
            child: DilettaIconAccessory(
              icon: icon,
              padding: 0,
              size: 20,
              color: s.textSecondary,
            ),
          ),
          const SizedBox(width: DilettaSpacing.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(title,
                          style: DilettaType.subheading.copyWith(color: s.fg)),
                    ),
                    if (status != null) ...[
                      const SizedBox(width: DilettaSpacing.s2),
                      DilettaStatusTag(
                        label: status!.label,
                        tone: status!.tone,
                        icon: status!.icon,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: DilettaSpacing.s1),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: DilettaType.bodySm.copyWith(color: s.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
            behavior: HitTestBehavior.opaque, onTap: onTap, child: card),
      );
    }
    return DilettaDevInfo(
      component: 'DilettaInfoCard',
      props: {
        'title': "'$title'",
        'icon': icon,
        if (status != null) 'status': "'${status!.label}' (${status!.tone.name})",
      },
      tokens: const [
        'card: border neutral-09 · radius 8 · px12 py8',
        'icon 20 textSecondary · title subheading fg · descr bodySm textSecondary (3 linhas)',
        'consome DilettaStatusTag (átomo) no slot de status',
      ],
      child: card,
    );
  }
}
