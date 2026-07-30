/// DILETTA — Design System (barril).
///
/// Import único pra widgets/theme consumers:
/// ```dart
/// import 'package:diletta_design_system/design_system/diletta_design_system.dart';
/// ```
///
/// Organização = atomic design: TOKENS → ATOMS → MOLECULES → ORGANISMS →
/// MOTION. Cada nível só compõe do nível abaixo.
library diletta_design_system;

// ═══════════════════════════════════════════════════════════════════════════
// TOKENS — cor (raiz), gradients/shadows derivam, depois radius e tipografia
// ═══════════════════════════════════════════════════════════════════════════
// Tier 1 → 2 → 3 (flavor + modo). Widgets consomem DilettaTheme.of(context).
export 'src/theme/cpf_seguro_palette.dart';
export 'src/theme/cpf_seguro_scheme.dart';
export 'src/theme/cpf_seguro_roles.dart';
export 'src/theme/cpf_seguro_theme.dart';
// Absolutos (branco, preto, sombras) — do PAI. Precisa estar no barril: sem isto
// um filho não alcança o branco canônico e reescreve `Color(0xFFFFFFFF)`.
export 'src/theme/diletta_absolute_colors.dart';
export 'src/theme/diletta_brand_assets.dart';

// A SUÍTE DE CONFORMIDADE. Ela mora em `lib/` justamente pra o filho poder chamá-la — o pai
// entrega a CHECAGEM, não a resposta. Faltava no barril, então só se chegava nela por dentro
// de `src/`, com `ignore: implementation_imports`.
//
// Achado pelo SEGUNDO filho (o Bold) na primeira hora de adoção, que é exatamente o trabalho
// de um segundo filho: o primeiro tinha a conformidade dentro do próprio pacote e nunca
// precisou do barril.
export 'src/conformance/ds_conformance.dart';
export 'src/theme/cpf_seguro_elevation.dart';
export 'src/theme/cpf_seguro_gradients.dart';
export 'src/theme/cpf_seguro_metrics.dart';
export 'src/theme/cpf_seguro_breakpoints.dart';
export 'src/theme/cpf_seguro_typography.dart';
export 'src/theme/cpf_seguro_icon_tokens.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ATOMS — primitivos indivisíveis (consomem só tokens)
// ═══════════════════════════════════════════════════════════════════════════
// Acessores de asset (ÁTOMOS): renderizam/escalam um SVG. O TOKEN é o asset
// cru — o .svg + o nome — não o widget. DilettaIcon dá cor/tamanho ao ícone;
// DilettaIllustrationAccessory escala a ilustração multi-cor.
export 'src/widgets/cpf_seguro_assets.dart' show DilettaAssets;
export 'src/widgets/cpf_seguro_icon.dart';
export 'src/widgets/cpf_seguro_icon_accessory.dart';
export 'src/widgets/cpf_seguro_spot_icon.dart';
export 'src/widgets/cpf_seguro_illustration.dart';
export 'src/widgets/cpf_seguro_logo.dart';
export 'src/widgets/cpf_seguro_glass_surface.dart';
export 'src/widgets/cpf_seguro_sticky_header.dart';
export 'src/widgets/cpf_seguro_status_bar.dart';
export 'src/widgets/cpf_seguro_bottom_home_indicator.dart';
export 'src/widgets/cpf_seguro_checkbox.dart';
export 'src/widgets/cpf_seguro_toggle_switch.dart';
export 'src/widgets/cpf_seguro_loading_spinner.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MOLECULES — combinações simples de átomos
// ═══════════════════════════════════════════════════════════════════════════
// Wrappers de ícone e tags
export 'src/widgets/cpf_seguro_action.dart';
export 'src/widgets/cpf_seguro_avatar.dart';
export 'src/widgets/cpf_seguro_status_tag.dart';
// Textos de página/seção
export 'src/widgets/cpf_seguro_page_title.dart';
export 'src/widgets/cpf_seguro_section_header.dart';
export 'src/widgets/cpf_seguro_text_link.dart';
export 'src/widgets/cpf_seguro_see_all_link.dart';
// Inputs
export 'src/widgets/cpf_seguro_button.dart';
export 'src/widgets/cpf_seguro_icon_button.dart';
export 'src/widgets/cpf_seguro_field.dart';
export 'src/widgets/cpf_seguro_input.dart';
export 'src/widgets/cpf_seguro_search_input.dart';
export 'src/widgets/cpf_seguro_input_chip.dart';
export 'src/widgets/cpf_seguro_info_chip.dart';
export 'src/widgets/cpf_seguro_radio_list.dart';
export 'src/widgets/cpf_seguro_otp_input.dart';
export 'src/widgets/cpf_seguro_menu_button.dart';
export 'src/widgets/cpf_seguro_partner_button.dart';
// Listas e cards
export 'src/widgets/cpf_seguro_app_list.dart';
export 'src/widgets/cpf_seguro_feature_card.dart';
export 'src/widgets/cpf_seguro_feature_detail_card.dart';
export 'src/widgets/cpf_seguro_info_card.dart';
export 'src/widgets/cpf_seguro_amount.dart';
export 'src/widgets/cpf_seguro_quick_access_card.dart';
export 'src/widgets/cpf_seguro_empty_state.dart';
export 'src/widgets/cpf_seguro_progress_bar.dart';
export 'src/widgets/cpf_seguro_progress_ring.dart';
export 'src/widgets/cpf_seguro_offline_pill.dart';
// Carteira
export 'src/widgets/cpf_seguro_wallet_card.dart';
export 'src/widgets/cpf_seguro_wallet_card_stack.dart';
export 'src/widgets/cpf_seguro_amount_display.dart';
export 'src/widgets/cpf_seguro_detail_row.dart';
export 'src/widgets/cpf_seguro_face_id_card.dart';
export 'src/widgets/cpf_seguro_receipt.dart';
export 'src/widgets/cpf_seguro_wallet_button.dart';
export 'src/widgets/cpf_seguro_journey_step.dart';
export 'src/widgets/cpf_seguro_dev_inspect.dart';
export 'src/widgets/cpf_seguro_text.dart';
export 'src/widgets/cpf_seguro_gap.dart';
// Frame — primitivo de layout (Row/Column/Stack encapsulado); base da árvore
export 'src/widgets/cpf_seguro_frame.dart';
// Divider — hairline por token (encapsula Divider/VerticalDivider crus)
export 'src/widgets/cpf_seguro_divider.dart';
// Tappable — área de toque (encapsula GestureDetector/InkWell crus)
export 'src/widgets/cpf_seguro_tappable.dart';
// Box — caixa decorada por token (encapsula Container/DecoratedBox crus)
export 'src/widgets/cpf_seguro_box.dart';
// Peça de composição das folhas (checkout, senha, confirmação de saída). Um filho que faça
// folha própria precisa dela — extensibilidade vem de o pai EXPOR as peças, não de hook.
export 'src/widgets/cpf_seguro_sheet_overlay.dart';
// ListTile — linha de lista genérica (encapsula ListTile do Material)
export 'src/widgets/cpf_seguro_list_tile.dart';
// ExpansionTile — linha expansível (encapsula ExpansionTile do Material)
export 'src/widgets/cpf_seguro_expansion_tile.dart';
// Dialog — modal central de marca (encapsula AlertDialog/Dialog)
export 'src/widgets/cpf_seguro_dialog.dart';
// Feedback e overlays leves
export 'src/widgets/cpf_seguro_toast.dart';
export 'src/widgets/cpf_seguro_tooltip.dart';
// Cobranding
export 'src/widgets/cpf_seguro_cobranded_badge.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ORGANISMS — composições em superfície (consomem moléculas)
// ═══════════════════════════════════════════════════════════════════════════
// Top/bottom bars (re-exportam navigation_top_bar/stepper e nav/navigation_button)
export 'src/widgets/cpf_seguro_top_app_bar.dart';
export 'src/widgets/cpf_seguro_bottom_app.dart';
// Surface — primitivo da gramática (top/content/bottom)
export 'src/widgets/cpf_seguro_surface.dart';
// Banner da Home (level/pausa/doc/erro) + slot-fillers (cada um em arquivo próprio)
export 'src/widgets/cpf_seguro_status_banner.dart';
export 'src/widgets/cpf_seguro_promo_banner.dart';
export 'src/widgets/cpf_seguro_notice_banner.dart';
export 'src/widgets/cpf_seguro_skeleton.dart';
export 'src/widgets/cpf_seguro_dropdown.dart';
export 'src/widgets/cpf_seguro_calendar.dart';
export 'src/widgets/cpf_seguro_date_field.dart';
export 'src/widgets/cpf_seguro_status_banner_action_icon.dart';
export 'src/widgets/cpf_seguro_status_banner_cta.dart';
export 'src/widgets/cpf_seguro_status_banner_error_panel.dart';
export 'src/widgets/cpf_seguro_status_banner_button.dart';
// Chat — cada componente em arquivo próprio (tokens internos não exportados)
export 'src/widgets/cpf_seguro_chat_bubble.dart';
export 'src/widgets/cpf_seguro_criteria_list.dart';
export 'src/widgets/cpf_seguro_chat_criteria_bubble.dart';
export 'src/widgets/cpf_seguro_chat_typing_indicator.dart';
export 'src/widgets/cpf_seguro_chat_scroll.dart';
export 'src/widgets/cpf_seguro_chat_tokens.dart';
export 'src/widgets/cpf_seguro_capture_frame.dart';
export 'src/widgets/cpf_seguro_cobrand_mark.dart';
// Chat extras — cada um em arquivo próprio
export 'src/widgets/cpf_seguro_cobrand_eyebrow.dart';
export 'src/widgets/cpf_seguro_chat_completion_card.dart';
export 'src/widgets/cpf_seguro_chat_input.dart';
// Sheets e overlays — cada um em arquivo próprio (SheetOverlay é interno)
export 'src/widgets/cpf_seguro_exit_confirm_sheet.dart';
export 'src/widgets/cpf_seguro_password_bottom_sheet.dart';
export 'src/widgets/cpf_seguro_keyboard.dart';
export 'src/widgets/cpf_seguro_biometria_overlay.dart';
export 'src/widgets/cpf_seguro_payment_sheet.dart';
export 'src/widgets/cpf_seguro_checkout_sheet.dart';
// Layout de tela SDK (Welcome, ErrorFatal, saída)
export 'src/widgets/cpf_seguro_sdk_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MOTION — presets de animação e transição de tela
// ═══════════════════════════════════════════════════════════════════════════
export 'src/widgets/cpf_seguro_animation.dart';
export 'src/widgets/cpf_seguro_screen_transition.dart';
