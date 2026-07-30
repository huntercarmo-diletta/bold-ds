import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — PartnerButton.
///
/// CTA primário com a cor do PARCEIRO (não do CPF SEGURO). Usado nas telas
/// do SDK dentro do app do parceiro — mantém a identidade visual dele.
///
/// Sempre size lg (56h), pill radius, disabled = neutral-08 + neutral-04.
///
/// ```dart
/// DilettaPartnerButton(label: 'Continuar no Banco Aurora', onPressed: submit),
/// ```
class DilettaPartnerButton extends StatelessWidget {
  const DilettaPartnerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    // Disabled só quando explícito — onPressed null não muda o visual.
    final effectivelyDisabled = disabled;
    // A cor do PARCEIRO é marca dele: não reage ao tema, como um logo. O estado
    // desabilitado é superfície da TELA, e esse reage.
    final bg = effectivelyDisabled ? s.surfaceMuted : s.partner;
    final color = effectivelyDisabled
        ? s.textPlaceholder
        : s.palette.white;
    return DilettaDevInfo(
      component: 'DilettaPartnerButton',
      props: {'label': "'$label'", 'disabled': '$effectivelyDisabled'},
      tokens: const ['h56 · radius pill · bg partner-primary'],
      child: Semantics(
      button: true,
      enabled: !effectivelyDisabled,
      label: label,
      child: MouseRegion(
        cursor: effectivelyDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: DilettaTappable(
          behavior: HitTestBehavior.opaque,
          onTap: effectivelyDisabled ? null : onPressed,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: DilettaRadius.pillAll,
            ),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              style: DilettaType.subheading.copyWith(color: color),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
