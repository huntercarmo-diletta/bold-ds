import 'package:flutter/widgets.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Descriptor de um CTA no [DilettaNavigationButton].
class DilettaNavigationAction {
  const DilettaNavigationAction({
    required this.label,
    this.onPressed,
    this.leadIcon,
    this.disabled = false,
    this.state = DilettaButtonState.normal,
    this.type,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? leadIcon;
  final bool disabled;
  final DilettaButtonState state;

  /// Override do type do slot (default vem do slot: primary→primary,
  /// secondary→secondary, tertiary→tertiary).
  final DilettaButtonType? type;
}

/// CPF SEGURO — NavigationButton (molécula).
///
/// Coluna de 1, 2 ou 3 CTAs (Button size lg fullWidth) empilhados com gap 12.
/// É o **conteúdo** do slot inferior — NÃO tem glass surface nem HomeIndicator.
/// Pra usar como rodapé real da tela, envolver em `DilettaBottomApp.button()`
/// ou `.buttonAndKeyboard()`.
///
/// Variantes (definidas pelo número de slots preenchidos):
/// - só `primary`
/// - `primary` + `secondary`
/// - `primary` + `secondary` + `tertiary`
///
/// Cada slot também pode ter `state: error` pra CTA destrutiva.
///
/// ```dart
/// DilettaNavigationButton(
///   primary: DilettaNavigationAction(label: 'Continuar', onPressed: submit),
/// )
/// DilettaNavigationButton(
///   primary: DilettaNavigationAction(label: 'Salvar', onPressed: save),
///   secondary: DilettaNavigationAction(label: 'Cancelar', onPressed: cancel),
/// )
/// ```
class DilettaNavigationButton extends StatelessWidget {
  const DilettaNavigationButton({
    super.key,
    this.primary,
    this.secondary,
    this.tertiary,
  });

  final DilettaNavigationAction? primary;
  final DilettaNavigationAction? secondary;
  final DilettaNavigationAction? tertiary;

  @override
  Widget build(BuildContext context) {
    return DilettaDevInfo(
      component: 'DilettaNavigationButton',
      props: {if (primary != null) 'primary': "'${primary!.label}'", if (secondary != null) 'secondary': "'${secondary!.label}'", if (tertiary != null) 'tertiary': "'${tertiary!.label}'"},
      tokens: const ['1-3 CTAs empilhados · gap 8 · dentro do BottomApp glass'],
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (primary != null)
          _slot(primary!, defaultType: DilettaButtonType.primary),
        if (secondary != null) ...[
          if (primary != null) const SizedBox(height: 12),
          _slot(secondary!, defaultType: DilettaButtonType.secondary),
        ],
        if (tertiary != null) ...[
          if (primary != null || secondary != null) const SizedBox(height: 12),
          _slot(tertiary!, defaultType: DilettaButtonType.tertiary),
        ],
      ],
    ),
    );
  }

  Widget _slot(DilettaNavigationAction a, {required DilettaButtonType defaultType}) {
    return DilettaButton(
      label: a.label,
      type: a.type ?? defaultType,
      state: a.state,
      size: DilettaButtonSize.lg,
      fullWidth: true,
      leadIcon: a.leadIcon,
      disabled: a.disabled,
      onPressed: a.onPressed,
    );
  }
}
