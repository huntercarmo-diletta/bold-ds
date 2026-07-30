import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_tappable.dart';

/// Variantes do [DilettaWalletButton].
enum DilettaWalletButtonVariant {
  /// "Pagar com CPF Seguro" — abre o PaymentSheet.
  pay,

  /// "Carteira CPF Seguro" — abre a gestão da carteira.
  manage,
}

/// CPF SEGURO — WalletButton (molécula).
///
/// O ÚNICO ponto de contato que o parceiro embeda no app dele (padrão
/// "Buy with Apple Pay"): um botão brandado que abre o fluxo de pagamento
/// ([DilettaWalletButtonVariant.pay] → PaymentSheet) ou a gestão da
/// carteira ([DilettaWalletButtonVariant.manage]).
///
/// Pill h56 · bg primary-04 · logo branco + label. Não expõe customização
/// de cor — a marca é o contrato visual do botão.
///
/// **Composição** — Logo (átomo) + tokens.
class DilettaWalletButton extends StatelessWidget {
  const DilettaWalletButton({
    super.key,
    this.variant = DilettaWalletButtonVariant.pay,
    this.onPressed,
    this.disabled = false,
  });

  final DilettaWalletButtonVariant variant;
  final VoidCallback? onPressed;

  /// Disabled é estado explícito — onPressed null não muda o visual.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final label = switch (variant) {
      DilettaWalletButtonVariant.pay => 'Pagar com CPF Seguro',
      DilettaWalletButtonVariant.manage => 'Carteira CPF Seguro',
    };
    final bg = disabled ? s.surfaceMuted : s.primary;
    final fg = disabled ? s.textPlaceholder : s.palette.white;

    Widget button = Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: DilettaRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaLogo(size: 22, color: fg),
          const SizedBox(width: 8),
          Text(
            label,
            style: DilettaType.button.copyWith(color: fg),
          ),
        ],
      ),
    );

    if (!disabled && onPressed != null) {
      button = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(onTap: onPressed, child: button),
      );
    }
    return DilettaDevInfo(
      component: 'DilettaWalletButton',
      props: {'variant': variant.name, 'disabled': '$disabled'},
      tokens: ['h56 · radius pill · bg ${disabled ? "neutral-08" : "primary-04"} · logo + label'],
      child: Semantics(button: true, label: label, child: button),
    );
  }
}
