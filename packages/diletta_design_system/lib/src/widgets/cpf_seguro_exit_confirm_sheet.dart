import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_sheet_overlay.dart';

/// CPF SEGURO — ExitConfirmSheet.
///
/// Bottomsheet reusable pra confirmar saída sem salvar. Grip + xmark ·
/// título · subtítulo · CTA destrutivo · CTA cancelar · home indicator.
/// Figma node 14860:158616.
///
/// Precisa de um [Stack] ancestral (é `Positioned.fill` internamente).
///
/// ```dart
/// DilettaExitConfirmSheet(
///   open: showExit,
///   onClose: () => setState(() => showExit = false),
///   onConfirm: () => navigator.pop(),
/// ),
/// ```
class DilettaExitConfirmSheet extends StatelessWidget {
  const DilettaExitConfirmSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.onConfirm,
    this.title = 'Sair sem salvar?',
    this.subtitle = 'Ao sair sem salvar, suas alterações serão descartadas',
    this.confirmLabel = 'Sair',
    this.cancelLabel = 'Cancelar',
  });

  final bool open;
  final VoidCallback onClose;
  final VoidCallback onConfirm;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaSheetOverlay(
      open: open,
      onScrimTap: onClose,
      child: Container(
        decoration: BoxDecoration(
          color: s.surface,
          borderRadius: const BorderRadius.only(
            topLeft: DilettaRadius.r24,
            topRight: DilettaRadius.r24,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DilettaTopAppBar.bottomsheet(
              navBar: DilettaNavigationTopBar(
                left: DilettaNavigationLeftAccessory.close(onPressed: onClose),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: DilettaSpacing.s6, right: DilettaSpacing.s6, top: DilettaSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: DilettaType.title.copyWith(color: s.fg)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: DilettaType.bodyMd.copyWith(color: s.textTertiary)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: DilettaSpacing.s6, right: DilettaSpacing.s6, top: DilettaSpacing.s6, bottom: DilettaSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DilettaButton(
                    label: confirmLabel,
                    type: DilettaButtonType.primary,
                    state: DilettaButtonState.error,
                    size: DilettaButtonSize.lg,
                    fullWidth: true,
                    onPressed: onConfirm,
                  ),
                  const SizedBox(height: 8),
                  DilettaButton(
                    label: cancelLabel,
                    type: DilettaButtonType.secondary,
                    size: DilettaButtonSize.lg,
                    fullWidth: true,
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            const DilettaBottomHomeIndicator(),
          ],
        ),
      ),
    );
  }
}
