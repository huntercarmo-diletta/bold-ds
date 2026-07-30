import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_tappable.dart';

/// Cor do link: `cpf` (primary do CPF SEGURO) ou `partner` (cor do parceiro —
/// ação que pertence à jornada do app cobranded).
enum DilettaTextLinkTone { cpf, partner }

/// CPF SEGURO — TextLink.
///
/// Átomo de link textual: rótulo `label` (type label, w600) na cor do scheme,
/// sem caixa nem borda. É o vocabulário das ações secundárias inline —
/// "Esqueci minha senha", "Reenviar código", "Esqueci meu PIN".
///
/// Não usar pra CTA (isso é [DilettaButton]/[DilettaPartnerButton]) nem pro
/// "Ver todos" de cabeçalho de seção — esse tem nome próprio
/// ([DilettaSeeAllLink], que é este átomo com tone `cpf`).
///
/// ```dart
/// DilettaTextLink(
///   label: 'Esqueci minha senha',
///   tone: DilettaTextLinkTone.partner,
///   onPressed: openRecovery,
/// )
/// ```
class DilettaTextLink extends StatelessWidget {
  const DilettaTextLink({
    super.key,
    required this.label,
    this.onPressed,
    this.tone = DilettaTextLinkTone.cpf,
  });

  final String label;
  final VoidCallback? onPressed;
  final DilettaTextLinkTone tone;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final color = switch (tone) {
      DilettaTextLinkTone.cpf => s.primary,
      DilettaTextLinkTone.partner => s.partner,
    };
    return Semantics(
      button: true,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
          onTap: onPressed,
          child: Text(label, style: DilettaType.label.copyWith(color: color)),
        ),
      ),
    );
  }
}
