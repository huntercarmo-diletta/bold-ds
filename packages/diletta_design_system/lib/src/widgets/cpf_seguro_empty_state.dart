import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_button.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — EmptyState (molécula).
///
/// Card de estado vazio de uma lista (ex: Atividade Recente sem eventos).
/// Border neutral-09, radius 24, px 40 py 16, conteúdo centralizado:
/// spot circular neutral-10 com ícone 12 + título title-sm + caption body-sm.
///
/// Figma 15:15620 ("Nenhuma ação ainda").
///
/// **Enriquecido (integração app):**
/// - [illustration]: substitui o spot de ícone por uma ilustração maior
///   (ex.: [DilettaIllustrationAccessory]) — usado em telas de bloqueio /
///   erro que mostram arte, não só um ícone pequeno.
/// - [actionLabel] + [onAction]: renderiza um [DilettaButton] primary abaixo
///   do caption — empty-state acionável (ex.: "Tentar de novo", "Adicionar").
///
/// **Composição** — Icon/Illustration (átomo) + Button (átomo) + tokens.
class DilettaEmptyState extends StatelessWidget {
  const DilettaEmptyState({
    super.key,
    required this.title,
    required this.caption,
    this.icon = 'arrow-rotate-left-light',
    this.illustration,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String caption;
  final String icon;

  /// Ilustração opcional (Widget) mostrada NO LUGAR do spot de ícone, maior.
  /// Quando null, cai no spot circular padrão com [icon].
  final Widget? illustration;

  /// Label do CTA opcional. Quando não-nulo (com [onAction]), renderiza um
  /// [DilettaButton] primary abaixo do caption.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final hasAction = actionLabel != null && onAction != null;
    return DilettaDevInfo(
      component: 'DilettaEmptyState',
      props: {
        'title': "'$title'",
        if (illustration == null) 'icon': icon else 'illustration': 'Widget',
        if (hasAction) 'action': "'$actionLabel'",
      },
      tokens: const ['card surface · border divider · radius 24 · spot 32', 'title: subheading fg · caption: caption textTertiary'],
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s10, vertical: DilettaSpacing.s4),
      decoration: BoxDecoration(
        color: s.surface,
        borderRadius: DilettaRadius.all24,
        border: Border.all(color: s.divider, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ilustração (quando passada) OU spot 32×32 — círculo neutro
          // (cinza no dark, não puxa a marca).
          if (illustration != null)
            illustration!
          else
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: s.isDark ? s.palette.neutral02 : s.palette.neutral10,
                shape: BoxShape.circle,
              ),
              child: DilettaIconAccessory(icon: icon, padding: 0, size: 12, color: s.textTertiary),
            ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: DilettaType.subheading.copyWith(color: s.fg),
          ),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: DilettaType.caption.copyWith(color: s.textTertiary),
          ),
          if (hasAction) ...[
            const SizedBox(height: DilettaSpacing.s4),
            DilettaButton(
              label: actionLabel!,
              onPressed: onAction!,
              size: DilettaButtonSize.md,
            ),
          ],
        ],
      ),
    ),
    );
  }
}
