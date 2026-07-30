import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_glass_surface.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_keyboard.dart';
import 'cpf_seguro_sheet_overlay.dart';

/// CPF SEGURO — PasswordBottomSheet.
///
/// Confirmação de senha via bottomsheet: título · 6 pin dots · "Esqueci
/// minha senha" · CTA Continuar · numpad iOS + home indicator.
/// Figma node 14860:158730.
///
/// Digitação vem do numpad interno; [value] é controlado externamente. O
/// pai valida a senha após [onSubmit] disparar.
class DilettaPasswordBottomSheet extends StatefulWidget {
  const DilettaPasswordBottomSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.onSubmit,
    this.onForgot,
    this.length = 6,
  });

  final bool open;
  final VoidCallback onClose;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onForgot;
  final int length;

  @override
  State<DilettaPasswordBottomSheet> createState() => _CpsPasswordBottomSheetState();
}

class _CpsPasswordBottomSheetState extends State<DilettaPasswordBottomSheet> {
  String _digits = '';

  @override
  void didUpdateWidget(covariant DilettaPasswordBottomSheet old) {
    super.didUpdateWidget(old);
    if (widget.open && !old.open) _digits = '';
  }

  bool get _canSubmit => _digits.length == widget.length;

  void _append(String d) {
    if (_digits.length >= widget.length) return;
    setState(() => _digits += d);
  }

  void _backspace() {
    if (_digits.isEmpty) return;
    setState(() => _digits = _digits.substring(0, _digits.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaSheetOverlay(
      open: widget.open,
      onScrimTap: widget.onClose,
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
                left: DilettaNavigationLeftAccessory.close(onPressed: widget.onClose),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: DilettaSpacing.s6, right: DilettaSpacing.s6, top: DilettaSpacing.s4, bottom: DilettaSpacing.s10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Digite sua senha',
                    textAlign: TextAlign.center,
                    style: DilettaType.title.copyWith(color: s.fg),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < widget.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        _PinDot(filled: i < _digits.length),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            _ForgotButton(onPressed: widget.onForgot),
            _ContinueBar(canSubmit: _canSubmit, onSubmit: () => widget.onSubmit(_digits)),
            DilettaKeyboard(onKey: _append, onBackspace: _backspace),
            const DilettaKeyboardIndicator(),
          ],
        ),
      ),
    );
  }
}

class _PinDot extends StatelessWidget {
  const _PinDot({required this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: s.palette.neutral07, width: 1.5),
      ),
      child: filled
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: s.textSecondary, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class _ForgotButton extends StatelessWidget {
  const _ForgotButton({required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
          onTap: onPressed,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: Text(
              'Esqueci minha senha',
              style: DilettaType.subheading.copyWith(color: s.textTertiary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  const _ContinueBar({required this.canSubmit, required this.onSubmit});
  final bool canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return DilettaGlassSurface(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
        child: DilettaButton(
          label: 'Continuar',
          fullWidth: true,
          size: DilettaButtonSize.lg,
          disabled: !canSubmit,
          onPressed: canSubmit ? onSubmit : null,
        ),
      ),
    );
  }
}
