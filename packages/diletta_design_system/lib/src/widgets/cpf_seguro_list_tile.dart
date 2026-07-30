import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_frame.dart';
import 'cpf_seguro_tappable.dart';
import 'cpf_seguro_text.dart';

/// CPF SEGURO — ListTile (linha de lista genérica).
///
/// Encapsula o `ListTile` do Material: leading/título/subtítulo/trailing com
/// densidade, padding e tipografia por **token**, toque via [DilettaTappable]
/// e layout via [DilettaFrame]. Para linhas ricas do SDK (accessories,
/// spot/avatar, tags), use `DilettaAppListRow`; este é o tile genérico.
class DilettaListTile extends StatelessWidget {
  const DilettaListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.dense = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Densidade compacta (padding vertical menor).
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final sub = subtitle?.trim();

    final middle = DilettaFrame.column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DilettaText(title, style: DilettaType.bodyMd),
        if (sub != null && sub.isNotEmpty)
          DilettaText(sub,
              style: DilettaType.bodySm.copyWith(color: s.textMuted)),
      ],
    );

    final row = DilettaFrame.row(
      gap: DilettaSpacing.s3,
      padding: EdgeInsets.symmetric(
        horizontal: DilettaSpacing.s4,
        vertical: dense ? DilettaSpacing.s2 : DilettaSpacing.s3,
      ),
      children: [
        if (leading != null) leading!,
        Expanded(child: middle),
        if (trailing != null) trailing!,
      ],
    );

    return DilettaTappable(onTap: onTap, child: row);
  }
}
