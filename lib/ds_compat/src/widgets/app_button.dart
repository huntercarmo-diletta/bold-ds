import 'package:flutter/material.dart';
import '../../../design_system/widgets/bold_button.dart';

/// Conta BOLD — Botão.
///
/// Camada de compatibilidade: delega 100% para o `BoldButton` nativo do design
/// system (`lib/design_system/`). Mantém a API antiga (factories + `onTap`)
/// para não quebrar os call sites; quando o DS muda (novo zip), os botões
/// refletem automaticamente. `danger` usa a variante destrutiva sólida do DS.
class AppButton extends StatelessWidget {
  const AppButton._({
    required this.label,
    required this.onTap,
    required _Variant variant,
    this.icon,
    this.loading = false,
    this.enabled = true,
    this.width,
  }) : _variant = variant;

  factory AppButton.primary({
    required String label,
    required VoidCallback? onTap,
    Widget? icon,
    bool loading = false,
    bool enabled = true,
    double? width,
  }) => AppButton._(label: label, onTap: onTap, variant: _Variant.primary,
        icon: icon, loading: loading, enabled: enabled, width: width);

  factory AppButton.secondary({
    required String label,
    required VoidCallback? onTap,
    Widget? icon,
    bool loading = false,
    double? width,
  }) => AppButton._(label: label, onTap: onTap, variant: _Variant.secondary,
        icon: icon, loading: loading, width: width);

  factory AppButton.accent({
    required String label,
    required VoidCallback? onTap,
    Widget? icon,
    bool loading = false,
    bool enabled = true,
    double? width,
  }) => AppButton._(label: label, onTap: onTap, variant: _Variant.accent,
        icon: icon, loading: loading, enabled: enabled, width: width);

  factory AppButton.outline({
    required String label,
    required VoidCallback? onTap,
    Widget? icon,
    double? width,
  }) => AppButton._(label: label, onTap: onTap, variant: _Variant.outline,
        icon: icon, width: width);

  factory AppButton.danger({
    required String label,
    required VoidCallback? onTap,
    double? width,
  }) => AppButton._(label: label, onTap: onTap, variant: _Variant.danger,
        width: width);

  final String label;
  final VoidCallback? onTap;
  final Widget? icon;
  final bool loading;
  final bool enabled;
  final double? width;
  final _Variant _variant;

  @override
  Widget build(BuildContext context) {
    final variant = switch (_variant) {
      _Variant.primary   => BoldButtonVariant.primary,
      // Decisão de DS: o antigo CTA "accent" (coral) foi aposentado — todas as
      // telas usam o botão SECUNDÁRIO do design system. `AppButton.accent`
      // segue existindo só por compat de API e agora renderiza secondary.
      _Variant.accent    => BoldButtonVariant.secondary,
      _Variant.secondary => BoldButtonVariant.secondary,
      _Variant.outline   => BoldButtonVariant.secondary,
      _Variant.danger    => BoldButtonVariant.destructive,
    };

    final button = BoldButton(
      label,
      onPressed: (enabled && !loading) ? onTap : null,
      variant:   variant,
      loading:   loading,
      expand:    width == null,
      filled:    _variant == _Variant.danger, // pílula vermelha sólida
    );

    return width == null ? button : SizedBox(width: width, child: button);
  }
}

enum _Variant { primary, accent, secondary, outline, danger }
