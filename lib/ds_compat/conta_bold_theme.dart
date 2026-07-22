/// Conta BOLD — Design System
///
/// Pacote de tokens e componentes base para o app Flutter.
///
/// Importação única:
/// ```dart
/// import 'package:conta_bold_design_system/conta_bold_theme.dart';
/// ```
library conta_bold_theme;

// ── Tokens ────────────────────────────────────────────────────────────────────
export 'src/theme/app_colors.dart';
export 'src/theme/app_text_styles.dart';
export 'src/theme/app_spacing.dart';   // AppSpacing
export 'src/theme/app_radius.dart';    // AppRadius
export 'src/theme/app_gradients.dart';
export 'src/theme/app_shadows.dart';
export 'src/theme/app_theme.dart';

// ── Widgets base (legado App*, net-new no package) ────────────────────────────
export 'src/widgets/app_button.dart';
export 'src/widgets/app_text_field.dart'; // AppCurrencyField (campo de valor)
export 'src/widgets/app_card.dart';
export 'src/widgets/atmospheric_background.dart';
export 'src/widgets/app_icon.dart';   // appIcon(IconData) → BoldIcon SVG (fallback Material)

// NOTA: bold_logo + os widgets do design_system NÃO são re-exportados aqui — o
// barrel raiz (conta_bold_ds.dart) já exporta design_system inteiro. Duplicar
// causaria ambiguous_export.
