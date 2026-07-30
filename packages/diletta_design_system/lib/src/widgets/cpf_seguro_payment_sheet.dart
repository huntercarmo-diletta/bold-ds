import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_wallet_card.dart';
import 'cpf_seguro_face_id_card.dart';
import 'cpf_seguro_loading_spinner.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_spot_icon.dart'
    show DilettaSpotIcon, DilettaSpotType, DilettaSpotState;
import 'cpf_seguro_sheet_overlay.dart';

/// Estados do [DilettaPaymentSheet].
enum DilettaPaymentSheetState {
  /// Autenticação biométrica inline (FaceIdCard).
  faceId,

  /// Aguardando a maquininha (ícone + instrução).
  approach,

  /// Valor recebido da maquininha — o usuário CONFIRMA vendo o valor
  /// antes do commit final ("Pagar").
  confirm,

  /// Pagamento em processamento — spinner + "não feche o app".
  processing,

  /// Aprovado — check verde + valor + CTA (comprovante/voltar).
  success,

  /// Recusado pelo emissor — motivo + Tentar novamente / Usar outro cartão.
  failed,
}

/// CPF SEGURO — PaymentSheet (organismo).
///
/// Bottom sheet do pagamento por aproximação (Figma 14967:20863). É um
/// sheet — e não uma tela — de propósito: um dia pode ser invocado até
/// FORA do app (padrão Apple Pay). Sequência:
///
/// 1. [DilettaPaymentSheetState.faceId]     — autentica
/// 2. [DilettaPaymentSheetState.approach]   — aproxima da maquininha
/// 3. [DilettaPaymentSheetState.confirm]    — VÊ O VALOR e toca "Pagar"
/// 4. [DilettaPaymentSheetState.processing] — processando (sem footer)
/// 5. [DilettaPaymentSheetState.success] ou [DilettaPaymentSheetState.failed]
///
/// O fluxo INTEIRO mora no sheet — do Face ID ao resultado.
///
/// O passo confirm é CONFIGURÁVEL ("Confirmar valor antes de pagar" nas
/// configurações da carteira) — desligado, o Face ID já aprova e o fluxo
/// pula direto pro processamento.
///
/// Precisa de um [Stack] ancestral (Positioned.fill + scrim internos).
class DilettaPaymentSheet extends StatelessWidget {
  const DilettaPaymentSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.state,
    this.value,
    this.timestamp,
    this.onPay,
    this.onReadQr,
    this.successLabel = 'Ver comprovante',
    this.onSuccessAction,
    this.onRetry,
    this.onChangeCard,
    this.title = 'Pix por aproximação',
  }) : assert(
            (state != DilettaPaymentSheetState.confirm &&
                    state != DilettaPaymentSheetState.success) ||
                value != null,
            'confirm/success exigem o value da transação.');

  final bool open;
  final VoidCallback onClose;
  final DilettaPaymentSheetState state;

  /// Valor formatado recebido da maquininha ("R\$ 1,00") — confirm/success.
  final String? value;

  /// Linha de data/hora no success ("hoje às 17:43").
  final String? timestamp;

  final VoidCallback? onPay;
  final VoidCallback? onReadQr;

  /// Label do CTA no success — "Ver comprovante" no app próprio,
  /// "Voltar ao Aurora" quando invocado do parceiro.
  final String successLabel;
  final VoidCallback? onSuccessAction;
  final VoidCallback? onRetry;
  final VoidCallback? onChangeCard;
  final String title;

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
                title: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(DilettaSpacing.s6, DilettaSpacing.s4, DilettaSpacing.s6, DilettaSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DilettaWalletCard.payment(),
                  const SizedBox(height: 40),
                  _body(s),
                  const SizedBox(height: 40),
                  _footer(),
                ],
              ),
            ),
            const DilettaBottomHomeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _body(DilettaScheme s) {
    switch (state) {
      case DilettaPaymentSheetState.faceId:
        return const Center(child: DilettaFaceIdCard());
      case DilettaPaymentSheetState.approach:
        return Column(children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: s.primary, width: 2),
            ),
            child: DilettaIconAccessory(icon: DilettaIcons.mobileLight, padding: 0, size: 28, color: s.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Aproxime da maquininha',
            style: DilettaType.bodyMd.copyWith(color: s.fg),
          ),
        ]);
      case DilettaPaymentSheetState.confirm:
        return Column(children: [
          DilettaIconAccessory(icon: DilettaIcons.circleCheckLight, padding: 0, size: 44, color: s.primary),
          const SizedBox(height: 24),
          // Pill com o valor — o usuário SEMPRE vê quanto vai pagar antes
          // de confirmar.
          _valuePill(s, s.primary),
        ]);
      case DilettaPaymentSheetState.processing:
        return Column(children: [
          const DilettaLoadingSpinner(size: DilettaSpinnerSize.lg),
          const SizedBox(height: 16),
          Text(
            'Processando pagamento...',
            style: DilettaType.heading.copyWith(color: s.fg, letterSpacing: 0),
          ),
          const SizedBox(height: 4),
          Text(
            'Não feche o app — leva só alguns segundos.',
            style: DilettaType.caption.copyWith(color: s.textMuted),
          ),
        ]);
      case DilettaPaymentSheetState.success:
        return Column(children: [
          DilettaIconAccessory(icon: DilettaIcons.circleCheckLight, padding: 0, size: 44, color: s.palette.success04),
          const SizedBox(height: 16),
          Text(
            'Pagamento efetuado',
            style: DilettaType.heading.copyWith(color: s.fg, letterSpacing: 0),
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 2),
            Text(
              timestamp!,
              style: DilettaType.caption.copyWith(color: s.textMuted),
            ),
          ],
          const SizedBox(height: 16),
          _valuePill(s, s.palette.success04),
        ]);
      case DilettaPaymentSheetState.failed:
        return Column(children: [
          const DilettaSpotIcon(
            icon: DilettaIcons.triangleExclamationLight,
            type: DilettaSpotType.outline,
            state: DilettaSpotState.error,
            size: 44,
          ),
          const SizedBox(height: 16),
          Text(
            'Pagamento não aprovado',
            style: DilettaType.heading.copyWith(color: s.fg, letterSpacing: 0),
          ),
          const SizedBox(height: 4),
          Text(
            'O emissor recusou a transação. Você não foi cobrado.',
            textAlign: TextAlign.center,
            style: DilettaType.caption.copyWith(color: s.textMuted),
          ),
        ]);
    }
  }

  Widget _valuePill(DilettaScheme s, Color accent) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s8, vertical: DilettaSpacing.s2),
        decoration: BoxDecoration(
          border: Border.all(color: accent, width: 1.5),
          borderRadius: DilettaRadius.pillAll,
        ),
        child: Text(
          value ?? '',
          style: DilettaType.title.copyWith(color: s.fg),
        ),
      ),
    );
  }

  Widget _footer() {
    switch (state) {
      case DilettaPaymentSheetState.confirm:
        return DilettaButton(
          label: 'Pagar',
          size: DilettaButtonSize.lg,
          fullWidth: true,
          onPressed: onPay,
        );
      case DilettaPaymentSheetState.processing:
        // Sem ação durante o processamento — o estado fala por si.
        return const SizedBox.shrink();
      case DilettaPaymentSheetState.success:
        return DilettaButton(
          label: successLabel,
          size: DilettaButtonSize.lg,
          fullWidth: true,
          onPressed: onSuccessAction,
        );
      case DilettaPaymentSheetState.failed:
        return Column(mainAxisSize: MainAxisSize.min, children: [
          DilettaButton(
            label: 'Tentar novamente',
            size: DilettaButtonSize.lg,
            fullWidth: true,
            onPressed: onRetry,
          ),
          const SizedBox(height: 8),
          DilettaButton(
            label: 'Usar outro cartão',
            type: DilettaButtonType.secondary,
            size: DilettaButtonSize.lg,
            fullWidth: true,
            onPressed: onChangeCard,
          ),
        ]);
      case DilettaPaymentSheetState.faceId:
      case DilettaPaymentSheetState.approach:
        return DilettaButton(
          label: 'Ler QR Code',
          type: DilettaButtonType.secondary,
          size: DilettaButtonSize.lg,
          leadIcon: DilettaIcons.qrcodeLight,
          fullWidth: true,
          onPressed: onReadQr,
        );
    }
  }
}
