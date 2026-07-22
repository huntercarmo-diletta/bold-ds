import 'package:flutter/material.dart';
import '../../../design_system/widgets/bold_icon.dart';

/// Conta BOLD — ponte ícone Material → BoldIcon (SVG do DS).
///
/// `appIcon(Icons.x, size:, color:)` rende o glifo SVG do BOLD Design System
/// quando há equivalente no mapa abaixo; caso contrário cai no `Icon` Material
/// (fallback seguro — nada quebra). Migração app-wide sem risco de ícone faltando.
///
/// Os nomes SVG são os arquivos reais em `lib/design_system/assets/icons`
/// (peso `light` do FontAwesome, para o visual outline do DS).
final Map<IconData, String> _icons = {
  // info / erro / aviso
  Icons.info_outline_rounded: 'circle-info-light',
  Icons.info_outlined: 'circle-info-light',
  Icons.info_rounded: 'circle-info-light',
  Icons.error_outline_rounded: 'circle-exclamation-light',
  Icons.error_outline: 'circle-exclamation-light',
  Icons.error_rounded: 'circle-exclamation-light',
  // lixeira / fechar / check
  Icons.delete_outline_rounded: 'trash-light',
  Icons.delete_outline: 'trash-light',
  Icons.delete_rounded: 'trash-light',
  Icons.close_rounded: 'xmark-light',
  Icons.close: 'xmark-light',
  Icons.check_rounded: 'check-light',
  Icons.check: 'check-light',
  Icons.check_circle_rounded: 'circle-check-light',
  Icons.check_circle_outline_rounded: 'circle-check-light',
  Icons.check_circle: 'circle-check-light',
  Icons.check_circle_outline: 'circle-check-light',
  Icons.verified_rounded: 'circle-check-light',
  // estrela
  Icons.star_rounded: 'star-solid',
  Icons.star: 'star-solid',
  Icons.star_outline_rounded: 'star-light',
  Icons.star_border_rounded: 'star-light',
  Icons.star_border: 'star-light',
  // recibo / docs
  Icons.receipt_long_rounded: 'receipt-light',
  Icons.receipt_long: 'receipt-light',
  Icons.receipt_rounded: 'receipt-light',
  Icons.receipt: 'receipt-light',
  // copiar / colar
  Icons.content_copy_rounded: 'clone-light',
  Icons.content_copy: 'clone-light',
  Icons.content_paste_rounded: 'clone-light',
  Icons.content_paste: 'clone-light',
  // identidade / chave
  Icons.badge_outlined: 'id-card-light',
  Icons.badge_rounded: 'id-card-light',
  Icons.key_outlined: 'key-light',
  Icons.key_rounded: 'key-light',
  Icons.vpn_key_outlined: 'key-light',
  Icons.vpn_key_rounded: 'key-light',
  Icons.fingerprint_rounded: 'fingerprint-light',
  Icons.fingerprint: 'fingerprint-light',
  Icons.lock_outline_rounded: 'lock-light',
  Icons.lock_rounded: 'lock-light',
  Icons.lock_outline: 'lock-light',
  Icons.shield_outlined: 'shield-user-light-full',
  Icons.verified_user_outlined: 'shield-user-light-full',
  // setas / chevrons
  Icons.chevron_right_rounded: 'angle-right-light',
  Icons.arrow_forward_ios_rounded: 'angle-right-light',
  Icons.arrow_forward_ios: 'angle-right-light',
  Icons.chevron_left_rounded: 'angle-left-light',
  Icons.arrow_back_ios_new_rounded: 'arrow-left-light',
  Icons.arrow_back_ios_rounded: 'arrow-left-light',
  Icons.arrow_back_rounded: 'arrow-left-light',
  Icons.keyboard_arrow_down_rounded: 'angle-down-light',
  Icons.keyboard_arrow_up_rounded: 'angle-up-light',
  Icons.arrow_downward_rounded: 'arrow-down-light',
  Icons.arrow_upward_rounded: 'arrow-up-light',
  Icons.swap_horiz_rounded: 'arrow-right-arrow-left-light',
  Icons.autorenew_rounded: 'arrow-rotate-left-light',
  // qr / scanner / busca
  Icons.qr_code_scanner_rounded: 'qrcode-light',
  Icons.qr_code_rounded: 'qrcode-light',
  Icons.qr_code: 'qrcode-light',
  Icons.search_rounded: 'magnifying-glass-light',
  Icons.search: 'magnifying-glass-light',
  // contato / comunicação
  Icons.phone_outlined: 'mobile-light',
  Icons.phone_rounded: 'mobile-light',
  Icons.smartphone_rounded: 'mobile-light',
  Icons.email_outlined: 'envelope-light',
  Icons.email_rounded: 'envelope-light',
  Icons.mail_outline_rounded: 'envelope-light',
  Icons.send_rounded: 'paper-plane-light',
  Icons.share_rounded: 'share-light',
  // tempo / agenda
  Icons.calendar_today_outlined: 'calendar-day-light',
  Icons.calendar_today_rounded: 'calendar-day-light',
  Icons.calendar_month_rounded: 'calendar-days-light',
  Icons.schedule_rounded: 'clock-light',
  Icons.access_time_rounded: 'clock-light',
  // banco / dinheiro
  Icons.account_balance_outlined: 'landmark-light',
  Icons.account_balance_rounded: 'landmark-light',
  Icons.credit_card_outlined: 'credit-card-light',
  Icons.credit_card_rounded: 'credit-card-light',
  Icons.credit_card: 'credit-card-light',
  // visibilidade
  Icons.visibility_rounded: 'eye-light',
  Icons.visibility_outlined: 'eye-light',
  Icons.visibility_off_rounded: 'eye-slash-light-full',
  Icons.visibility_off_outlined: 'eye-slash-light-full',
  // pessoas
  Icons.person_rounded: 'user-light',
  Icons.person_outline_rounded: 'user-light',
  Icons.person_outline: 'user-light',
  Icons.people_outline_rounded: 'users-light',
  Icons.group_rounded: 'users-light',
  Icons.group_outlined: 'users-light',
  // navegação / sistema
  Icons.home_rounded: 'house-light',
  Icons.notifications_none_rounded: 'bell-light',
  Icons.notifications_outlined: 'bell-light',
  Icons.notifications_rounded: 'bell-light',
  Icons.tune_rounded: 'sliders-light',
  Icons.edit_outlined: 'pen-to-square-light',
  Icons.edit_rounded: 'pen-to-square-light',
  Icons.block_rounded: 'ban-light',
  Icons.logout_rounded: 'arrow-right-from-bracket-light',
  Icons.add_rounded: 'plus-light',
  Icons.add: 'plus-light',
  Icons.add_circle_outline_rounded: 'circle-plus-light',
  Icons.camera_alt_rounded: 'camera-light',
  Icons.business_rounded: 'building-light',
  Icons.wifi_rounded: 'wifi-light',
};

/// Rende o ícone do DS (SVG) ou cai no Material se não houver equivalente.
Widget appIcon(IconData icon, {double? size, Color? color}) {
  final svg = _icons[icon];
  if (svg == null) return Icon(icon, size: size, color: color);
  return BoldIcon(svg, size: size ?? 24, color: color);
}
