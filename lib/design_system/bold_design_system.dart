/// Conta BOLD — Design System (barrel).
///
/// Import único:
/// ```dart
/// import 'package:conta_bold/design_system/bold_design_system.dart';
/// ```
///
/// **Organização = atomic design:** TOKENS → ÁTOMOS → MOLÉCULAS → ORGANISMOS →
/// MOTION. Regra de ouro: **cada nível só compõe do nível abaixo**. Nenhum
/// widget hardcoda um hex/tamanho — tudo vem dos TOKENS. Telas se montam a
/// partir de ORGANISMOS/MOLÉCULAS (fluidez + padronização + elegância).
///
/// - **Tokens** — cor, tipografia, raio/spacing, gradientes, glass, tema.
/// - **Átomos** — primitivos indivisíveis que consomem só tokens.
/// - **Moléculas** — combinações simples de átomos.
/// - **Organismos** — composições em superfície que consomem moléculas.
/// - **Motion** — presets de animação/transição.
library bold_design_system;

// ═══════════════════════════════════════════════════════════════════════════
// TOKENS — cor (raiz) → gradientes → raio/spacing → tipografia → glass → tema
// ═══════════════════════════════════════════════════════════════════════════
export 'theme/bold_colors.dart';
export 'theme/bold_gradients.dart';
export 'theme/bold_metrics.dart';
export 'theme/bold_typography.dart';
export 'theme/bold_glass.dart';
export 'theme/bold_theme.dart';
export 'theme/bold_motion.dart';           // BoldMotion + BoldAnimateIn (presets)

// ═══════════════════════════════════════════════════════════════════════════
// ÁTOMOS — primitivos indivisíveis (consomem só tokens)
// ═══════════════════════════════════════════════════════════════════════════
export 'widgets/bold_icon.dart';           // BoldIcon, BoldIconSize
export 'widgets/bold_logo.dart';           // BoldLogo
export 'widgets/bold_pix_mark.dart';       // BoldPixMark
export 'widgets/bold_background.dart';     // BoldBackground (backdrop)
export 'widgets/bold_glass_surface.dart';  // BoldGlassSurface
export 'widgets/bold_home_indicator.dart'; // BoldHomeIndicator
export 'widgets/bold_page_dots.dart';      // BoldPageDots (carrossel/onboarding)
export 'widgets/bold_glass_avatar.dart';   // BoldGlassAvatar (avatar do usuário)
export 'widgets/bold_copy_button.dart';    // BoldCopyButton (copiar + check in-place)
export 'widgets/bold_skeleton.dart';       // BoldSkeleton (shimmer loading)
export 'widgets/bold_spinner.dart';        // BoldSpinner (arco com gradiente)
export 'widgets/bold_illustration.dart';   // BoldIllustration (multicor, sem recolor)
export 'widgets/bold_controls.dart';       // BoldSwitch, BoldSegmentedControl
export 'widgets/bold_checkbox.dart';       // BoldCheckbox

// ═══════════════════════════════════════════════════════════════════════════
// MOLÉCULAS — combinações simples de átomos
// ═══════════════════════════════════════════════════════════════════════════
// Textos de página/seção
export 'widgets/bold_page_title.dart';     // BoldPageTitle
export 'widgets/bold_section_header.dart'; // BoldSectionHeader, BoldSeeAllLink
// Inputs
export 'widgets/bold_button.dart';         // BoldButton (variants + sm/md/lg)
export 'widgets/bold_icon_button.dart';    // BoldIconButton
export 'widgets/bold_text_field.dart';     // BoldTextField
export 'widgets/bold_select_field.dart';   // BoldSelectField
export 'widgets/bold_date_picker.dart';    // BoldDatePicker (calendário em bottom sheet)
export 'widgets/bold_currency_field.dart'; // BoldCurrencyField (valor em centavos)
export 'widgets/bold_money_input_formatter.dart'; // BoldMoneyInputFormatter (R$ em campo)
export 'widgets/bold_search_input.dart';   // BoldSearchInput
export 'widgets/bold_otp_input.dart';      // BoldOtpInput
export 'widgets/bold_keypad.dart';         // BoldKeypad, BoldPinDots
// Chips / tags / badges
export 'widgets/bold_chip.dart';           // BoldStatusBadge, BoldFilterChip
export 'widgets/bold_status_tag.dart';     // BoldStatusTag (tons semânticos)
export 'widgets/bold_input_chip.dart';     // BoldInputChip
// Navegação (peças dos bars)
export 'widgets/bold_nav_top_bar.dart';    // BoldNavTopBar + acessórios sealed
export 'widgets/bold_stepper.dart';        // BoldStepper
export 'widgets/bold_navigation_button.dart'; // BoldNavigationButton, BoldNavAction
export 'widgets/bold_tabs.dart';           // BoldTabs (abas sublinhadas — seções/listas)
// Cards, listas e estados
export 'widgets/bold_card.dart';           // BoldCard, BoldIconChip, BoldCardSurface
export 'widgets/bold_accordion.dart';      // BoldAccordion (card expansivel / FAQ)
export 'widgets/bold_list.dart';           // BoldSpotIcon, BoldListTile, BoldListGroup
export 'widgets/bold_app_list.dart';       // BoldAppList + Left/Middle/RightAccessory (sealed)
export 'widgets/bold_amount_display.dart'; // BoldAmountDisplay (valor entre hairlines) — CPF Seguro
export 'widgets/bold_detail_row.dart';     // BoldDetailRow (título/descrição + hairline) — CPF Seguro
export 'widgets/bold_receipt.dart';        // BoldReceipt + Row/Section (comprovante) — CPF Seguro
export 'widgets/bold_transaction_summary.dart'; // BoldTransactionSummary + Row/Section/Action
export 'widgets/bold_progress_bar.dart';   // BoldProgressBar (trilho h5 + caption) — CPF Seguro
export 'widgets/bold_radio_list.dart';     // BoldRadioList + BoldRadioOption — CPF Seguro
export 'widgets/bold_tooltip.dart';        // BoldTooltip (label flutuante + tail) — CPF Seguro
export 'widgets/bold_quick_card.dart';     // BoldMenuTile
export 'widgets/bold_quick_action.dart';   // BoldQuickAction (ícone+label em frame, linha do saldo)
export 'widgets/bold_avatar_stack.dart';   // BoldAvatarStack
export 'widgets/bold_avatar_row.dart';     // BoldAvatarRow (Enviar para)
export 'widgets/bold_empty_state.dart';    // BoldEmptyState
// Feedback e overlays leves
export 'widgets/bold_alert.dart';          // BoldAlert, BoldToast, BoldIntent

// ═══════════════════════════════════════════════════════════════════════════
// ORGANISMOS — composições em superfície (consomem moléculas)
// ═══════════════════════════════════════════════════════════════════════════
export 'widgets/bold_app_bar.dart';    // BoldCircleButton, BoldAvatar, BoldAccountPill/Switcher
export 'widgets/bold_balance.dart';    // BoldBalance
export 'widgets/bold_notice_row.dart'; // BoldNoticeRow (Autorizações)
export 'widgets/bold_promo_banner.dart'; // BoldPromoBanner (pessoas próximas)
export 'widgets/bold_promo_card.dart';   // BoldPromoCard (carrossel de promos)
export 'widgets/bold_top_bar.dart';    // BoldTopBar (.page/.home/.stepper/.sheet)
export 'widgets/bold_bottom_app.dart'; // BoldBottomApp (.nav/.button/.keyboard/.buttonAndKeyboard/.child) + BoldTabItem
export 'widgets/bold_dialog.dart';     // BoldDialog
export 'widgets/bold_sheet.dart';      // BoldSheet (bottom sheet + .show)
export 'widgets/bold_password_sheet.dart'; // BoldPasswordSheet (PIN/senha)

// ═══════════════════════════════════════════════════════════════════════════
// MOTION / especiais — Autorização Quântica (visual violeta, independente da marca)
// ═══════════════════════════════════════════════════════════════════════════
export 'widgets/bold_quantum_pairing.dart'; // BoldQuantumPairingScreen, BoldQuantumCore
export 'widgets/bold_quantum_seal.dart';    // BoldQuantumSeal
