import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_spot_icon.dart' show DilettaSpotIcon;
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// CPF SEGURO — DetailRow (molécula).
///
/// Row de detalhe label/descrição com hairline inferior — padrão das telas
/// de Detalhe de transação e Número do cartão da Carteira:
///
/// - "Para" / "Pague menos"
/// - "Rede" / "Mastercard"
/// - "•••• 7665" / texto explicativo
/// - "Entre em contato com Swile" + chevron (action row, sem descrição)
///
/// Figma 1158:39718 / 1158:28870.
///
/// **Composição** — Icon (átomo) + tokens.
class DilettaDetailRow extends StatelessWidget {
  const DilettaDetailRow({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.chevron = false,
    this.hairline = true,
    this.onTap,
  });

  final String title;
  final String? description;

  /// SpotIcon à esquerda (opcional) — dá respiro em telas de lista seca.
  final String? icon;

  /// Chevron à direita (row de navegação).
  final bool chevron;

  /// Hairline neutral-09 no rodapé da row.
  final bool hairline;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    Widget row = Container(
      padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s4),
      decoration: BoxDecoration(
        border: hairline
            ? Border(bottom: BorderSide(color: s.divider, width: 1))
            : null,
      ),
      // Layout HORIZONTAL (decisão: adotar o look do app): label à esquerda,
      // valor à direita (end-aligned), padrão de comprovante.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            DilettaSpotIcon(icon: icon!),
            const SizedBox(width: 12),
          ],
          Text(title, style: DilettaType.subheading.copyWith(color: s.fg)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              description ?? '',
              textAlign: TextAlign.end,
              style: DilettaType.bodyMd.copyWith(color: s.textTertiary),
            ),
          ),
          if (chevron) ...[
            const SizedBox(width: 8),
            DilettaIconAccessory(icon: DilettaIcons.angleRightLight, padding: 0, size: 16, color: s.textSecondary),
          ],
        ],
      ),
    );

    if (onTap != null) {
      row = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(onTap: onTap, child: row),
      );
    }
    return DilettaDevInfo(
      component: 'DilettaDetailRow',
      props: {'title': "'$title'", if (description != null) 'description': "'$description'", if (icon != null) 'icon': icon!, if (chevron) 'chevron': 'true'},
      tokens: const ['title: titleSm neutral-01 · descr: bodySm neutral-03 · py16', 'hairline neutral-09'],
      child: row,
    );
  }
}
