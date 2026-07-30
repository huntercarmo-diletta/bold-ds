import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_checkbox.dart';
import 'cpf_seguro_input.dart';
import 'cpf_seguro_action.dart' show DilettaActionDirection;
import 'cpf_seguro_app_list.dart'
    show
        DilettaAppList,
        DilettaAppListRow,
        DilettaLeftAccessory,
        DilettaMiddleAccessory,
        DilettaRightAccessory;
import 'cpf_seguro_sheet_overlay.dart';

/// Cartão salvo listado no [DilettaCheckoutSheet].
class DilettaCheckoutCard {
  const DilettaCheckoutCard({required this.label, this.sublabel});
  final String label;
  final String? sublabel;
}

/// Linha do resumo de valores ("Subtotal · R\$ 545,00").
class DilettaCheckoutLine {
  const DilettaCheckoutLine({required this.label, required this.value, this.emphasized = false});
  final String label;
  final String value;

  /// Total — renderiza em title ao invés de body.
  final bool emphasized;
}

/// Estados do [DilettaCheckoutSheet].
enum DilettaCheckoutSheetState {
  /// Resumo do pedido: valores detalhados + forma de pagamento com "Trocar".
  summary,

  /// Trocar forma: Pix (aprovação na hora) + cartões salvos + adicionar novo.
  methods,

  /// Inserir um cartão novo (com opção de salvar na carteira).
  newCard,

  /// Pagar com Pix: copia e cola + timer + confirmação automática.
  pix,
}

/// CPF SEGURO — CheckoutSheet (organismo).
///
/// Checkout e-commerce invocado pelo [WalletButton] na loja do parceiro —
/// bench: checkout do iFood (cartão E Pix):
///
/// - [DilettaCheckoutSheetState.summary] — pedido + resumo de valores +
///   forma de pagamento selecionada com link "Trocar" + CTA contextual
///   ("Pagar R\$ X" / "Pagar com Pix").
/// - [DilettaCheckoutSheetState.methods] — Pix primeiro ("Aprovação na
///   hora") + cartões salvos (radio) + "Adicionar novo cartão".
/// - [DilettaCheckoutSheetState.newCard] — form + "Salvar na minha carteira".
/// - [DilettaCheckoutSheetState.pix] — copia e cola + expiração +
///   confirmação automática (pagamento acontece no app do banco).
///
/// Cartão segue pro [DilettaPaymentSheet] (faceId → resultado); Pix
/// confirma sozinho e cai no success.
///
/// Precisa de um [Stack] ancestral (Positioned.fill + scrim internos).
class DilettaCheckoutSheet extends StatelessWidget {
  const DilettaCheckoutSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.state,
    required this.merchant,
    required this.amount,
    this.merchantInitials = '••',
    this.orderRef,
    this.lines = const [],
    this.cards = const [],
    this.selectedCard = 0,
    this.pixSelected = false,
    this.pixCode,
    this.pixExpiry,
    this.saveNewCard = true,
    this.onSelectCard,
    this.onSelectPix,
    this.onNewCard,
    this.onChangeMethod,
    this.onPay,
    this.onCopyPix,
    this.onToggleSave,
  });

  final bool open;
  final VoidCallback onClose;
  final DilettaCheckoutSheetState state;

  /// Nome da loja ("Pague menos").
  final String merchant;
  final String merchantInitials;

  /// Referência do pedido ("Pedido #4821").
  final String? orderRef;

  /// Total formatado ("R\$ 560,00").
  final String amount;

  /// Resumo de valores (Subtotal/Taxa/Total) — summary.
  final List<DilettaCheckoutLine> lines;

  final List<DilettaCheckoutCard> cards;
  final int selectedCard;

  /// Pix é a forma selecionada (summary/methods).
  final bool pixSelected;

  /// Código copia e cola (estado pix).
  final String? pixCode;

  /// Expiração do código ("9:58").
  final String? pixExpiry;

  /// Checkbox "Salvar na minha carteira" (estado newCard).
  final bool saveNewCard;

  final ValueChanged<int>? onSelectCard;
  final VoidCallback? onSelectPix;
  final VoidCallback? onNewCard;

  /// Link "Trocar" da forma de pagamento (summary).
  final VoidCallback? onChangeMethod;
  final VoidCallback? onPay;
  final VoidCallback? onCopyPix;
  final ValueChanged<bool>? onToggleSave;

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
                title: 'Pagamento',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(DilettaSpacing.s6, DilettaSpacing.s2, DilettaSpacing.s6, DilettaSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pedido — loja + referência, sempre visível.
                  DilettaAppListRow(
                    left: DilettaLeftAccessory.avatar(initials: merchantInitials),
                    middle: DilettaMiddleAccessory.titleSubtitle(
                      title: merchant,
                      subtitle: orderRef,
                    ),
                  ),
                  ...switch (state) {
                    DilettaCheckoutSheetState.summary => _summary(s),
                    DilettaCheckoutSheetState.methods => _methods(s),
                    DilettaCheckoutSheetState.newCard => _newCard(s),
                    DilettaCheckoutSheetState.pix => _pix(s),
                  },
                  const SizedBox(height: 24),
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

  // ─── summary — resumo de valores + forma de pagamento com Trocar ────────
  List<Widget> _summary(DilettaScheme s) {
    return [
      const SizedBox(height: 8),
      Container(height: 1, color: s.divider),
      const SizedBox(height: 12),
      for (final line in lines)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                line.label,
                style: line.emphasized
                    ? DilettaType.heading.copyWith(color: s.fg, letterSpacing: 0)
                    : DilettaType.bodyMd.copyWith(color: s.textTertiary),
              ),
              Text(
                line.value,
                style: line.emphasized
                    ? DilettaType.heading.copyWith(color: s.fg, letterSpacing: 0)
                    : DilettaType.bodyMd.copyWith(color: s.textSecondary),
              ),
            ],
          ),
        ),
      const SizedBox(height: 12),
      Container(height: 1, color: s.divider),
      const SizedBox(height: 16),
      // Forma de pagamento selecionada + Trocar (padrão iFood).
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Forma de pagamento', style: DilettaType.subheading.copyWith(color: s.fg)),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DilettaTappable(
              onTap: onChangeMethod,
              child: Text(
                'Trocar',
                style: DilettaType.label.copyWith(color: s.primary),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      DilettaAppList.carded(children: [
        pixSelected
            ? const DilettaAppListRow(
                left: DilettaLeftAccessory.spotIcon(icon: DilettaIcons.pixLight),
                middle: DilettaMiddleAccessory.titleSubtitle(
                  title: 'Pix',
                  subtitle: 'Aprovação na hora',
                ),
              )
            : DilettaAppListRow(
                left: const DilettaLeftAccessory.spotIcon(icon: DilettaIcons.creditCardLight),
                middle: DilettaMiddleAccessory.titleSubtitle(
                  title: cards.isNotEmpty ? cards[selectedCard].label : '',
                  subtitle: cards.isNotEmpty ? cards[selectedCard].sublabel : null,
                ),
              ),
      ]),
    ];
  }

  // ─── methods — Pix primeiro + cartões + adicionar ────────────────────────
  List<Widget> _methods(DilettaScheme s) {
    return [
      const SizedBox(height: 16),
      Text('Pagar com', style: DilettaType.subheading.copyWith(color: s.fg)),
      const SizedBox(height: 8),
      DilettaAppList.carded(children: [
        DilettaAppListRow(
          onTap: onSelectPix,
          left: const DilettaLeftAccessory.spotIcon(icon: DilettaIcons.pixLight),
          middle: const DilettaMiddleAccessory.titleSubtitle(
            title: 'Pix',
            subtitle: 'Aprovação na hora',
          ),
          right: DilettaRightAccessory.radio(
            selected: pixSelected,
            onPressed: onSelectPix ?? () {},
          ),
        ),
        for (var i = 0; i < cards.length; i++)
          DilettaAppListRow(
            onTap: onSelectCard == null ? null : () => onSelectCard!(i),
            left: const DilettaLeftAccessory.spotIcon(icon: DilettaIcons.creditCardLight),
            middle: DilettaMiddleAccessory.titleSubtitle(
              title: cards[i].label,
              subtitle: cards[i].sublabel,
            ),
            right: DilettaRightAccessory.radio(
              selected: !pixSelected && i == selectedCard,
              onPressed: () => onSelectCard?.call(i),
            ),
          ),
        DilettaAppListRow(
          onTap: onNewCard,
          left: const DilettaLeftAccessory.spotIcon(icon: DilettaIcons.plusLight),
          middle: const DilettaMiddleAccessory.titleSubtitle(
            title: 'Adicionar novo cartão',
            subtitle: 'Crédito ou débito — dá pra salvar na carteira',
          ),
          right: const DilettaRightAccessory.action(direction: DilettaActionDirection.right),
        ),
      ]),
    ];
  }

  // ─── newCard — form + salvar na carteira ─────────────────────────────────
  List<Widget> _newCard(DilettaScheme s) {
    return [
      const SizedBox(height: 16),
      Text('Novo cartão', style: DilettaType.subheading.copyWith(color: s.fg)),
      const SizedBox(height: 8),
      DilettaInput(
        controller: TextEditingController(text: '5502 09** **** 7665'),
        label: 'Número do cartão',
      ),
      const SizedBox(height: 12),
      DilettaInput(
        controller: TextEditingController(text: 'Ana Maria Soares'),
        label: 'Nome do titular',
      ),
      const SizedBox(height: 12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: DilettaInput(
            controller: TextEditingController(text: '12/2028'),
            label: 'Validade',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DilettaInput(
            controller: TextEditingController(text: '765'),
            label: 'CVV',
            helper: 'Não fica salvo',
          ),
        ),
      ]),
      const SizedBox(height: 12),
      DilettaCheckbox(
        checked: saveNewCard,
        onChanged: onToggleSave ?? (_) {},
        label: 'Salvar na minha carteira',
        description: 'Vira um código seguro — pague por aproximação depois',
      ),
    ];
  }

  // ─── pix — copia e cola + timer + confirmação automática ────────────────
  List<Widget> _pix(DilettaScheme s) {
    return [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pix copia e cola', style: DilettaType.subheading.copyWith(color: s.fg)),
          if (pixExpiry != null)
            Text(
              'expira em $pixExpiry',
              style: DilettaType.labelSm.copyWith(color: s.palette.warning03),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DilettaSpacing.s3),
        decoration: BoxDecoration(
          color: s.bg,
          borderRadius: DilettaRadius.all8,
          border: Border.all(color: s.divider, width: 1),
        ),
        child: Text(
          pixCode ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: DilettaType.caption.copyWith(color: s.textTertiary),
        ),
      ),
      const SizedBox(height: 16),
      for (final (i, step) in const [
        'Copie o código',
        'Pague no app do seu banco',
        'A confirmação aqui é automática',
      ].indexed)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s1),
          child: Row(children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: s.primarySubtle, shape: BoxShape.circle),
              child: Text('${i + 1}', style: DilettaType.labelSm.copyWith(color: s.primary)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(step, style: DilettaType.bodyMd.copyWith(color: s.textSecondary)),
            ),
          ]),
        ),
    ];
  }

  Widget _footer() {
    switch (state) {
      case DilettaCheckoutSheetState.pix:
        return DilettaButton(
          label: 'Copiar código Pix',
          size: DilettaButtonSize.lg,
          leadIcon: DilettaIcons.cloneLight,
          fullWidth: true,
          onPressed: onCopyPix,
        );
      case DilettaCheckoutSheetState.summary:
        return DilettaButton(
          label: pixSelected ? 'Pagar com Pix' : 'Pagar $amount',
          size: DilettaButtonSize.lg,
          fullWidth: true,
          onPressed: onPay,
        );
      case DilettaCheckoutSheetState.methods:
      case DilettaCheckoutSheetState.newCard:
        return DilettaButton(
          label: 'Pagar $amount',
          size: DilettaButtonSize.lg,
          fullWidth: true,
          onPressed: onPay,
        );
    }
  }
}
