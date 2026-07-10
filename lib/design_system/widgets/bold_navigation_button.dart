import 'package:flutter/widgets.dart';
import 'bold_button.dart';

/// Descriptor de um CTA no [BoldNavigationButton].
class BoldNavAction {
  const BoldNavAction({
    required this.label,
    this.onPressed,
    this.glyph,
    this.trailingGlyph,
    this.loading = false,
    this.variant,
    this.filled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? glyph;
  final String? trailingGlyph;
  final bool loading;

  /// Override do variant do slot (default: primary→primary, secondary→
  /// secondary, tertiary→text). Use `BoldButtonVariant.destructive` +
  /// [filled] pra CTA destrutiva.
  final BoldButtonVariant? variant;
  final bool filled;
}

/// Conta BOLD — NavigationButton (molécula). Coluna de 1–3 CTAs (BoldButton lg,
/// full-width) empilhados com gap 12. É o CONTEÚDO do rodapé — sem glass nem
/// home indicator (isso é papel do [BoldBottomApp], organismo).
///
/// **Composição** — BoldButton (molécula) + tokens.
///
/// ```dart
/// BoldNavigationButton(primary: BoldNavAction(label: 'Continuar', onPressed: submit));
/// BoldNavigationButton(
///   primary: BoldNavAction(label: 'Salvar', onPressed: save),
///   secondary: BoldNavAction(label: 'Cancelar', onPressed: cancel),
/// );
/// ```
class BoldNavigationButton extends StatelessWidget {
  const BoldNavigationButton({
    super.key,
    this.primary,
    this.secondary,
    this.tertiary,
  });

  final BoldNavAction? primary;
  final BoldNavAction? secondary;
  final BoldNavAction? tertiary;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (primary != null) _slot(primary!, BoldButtonVariant.primary),
        if (secondary != null) ...[
          if (primary != null) const SizedBox(height: 12),
          _slot(secondary!, BoldButtonVariant.secondary),
        ],
        if (tertiary != null) ...[
          if (primary != null || secondary != null) const SizedBox(height: 12),
          _slot(tertiary!, BoldButtonVariant.text),
        ],
      ],
    );
  }

  Widget _slot(BoldNavAction a, BoldButtonVariant defaultVariant) {
    return BoldButton(
      a.label,
      variant: a.variant ?? defaultVariant,
      size: BoldButtonSize.lg,
      glyph: a.glyph,
      trailingGlyph: a.trailingGlyph,
      loading: a.loading,
      filled: a.filled,
      onPressed: a.onPressed,
    );
  }
}
