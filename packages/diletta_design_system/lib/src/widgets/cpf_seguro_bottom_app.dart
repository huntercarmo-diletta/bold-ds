import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_chat_input.dart';
import 'cpf_seguro_glass_surface.dart';
import 'cpf_seguro_nav.dart';
import 'cpf_seguro_navigation_button.dart';
import 'cpf_seguro_keyboard.dart' show DilettaKeyboard;
import '../theme/cpf_seguro_theme.dart';

export 'cpf_seguro_bottom_home_indicator.dart';
export 'cpf_seguro_nav.dart';
export 'cpf_seguro_navigation_button.dart';

/// CPF SEGURO — BottomApp (organismo unificado).
///
/// Único ponto de entrada pro slot inferior da tela. Cada variante é uma
/// **factory nomeada** que compõe moléculas + [DilettaBottomHomeIndicator]
/// dentro de uma [DilettaGlassSurface] (ou sem, no caso `.default()`).
///
/// **Filosofia atomic**:
/// - Átomo: [DilettaBottomHomeIndicator]
/// - Moléculas: [DilettaNav], [DilettaNavigationButton], [DilettaKeyboard],
///   [DilettaChatInput]
/// - Organismo: este widget
///
/// Variantes:
/// - `.default()`             → só HomeIndicator (sem glass, sem fundo)
/// - `.nav(nav:)`             → Nav + indicator em glass
/// - `.button(button:)`       → NavigationButton + indicator em glass
/// - `.keyboard(keyboard:)`   → Keyboard + indicator cinza
/// - `.buttonAndKeyboard(button:, keyboard:)` → NavigationButton em glass + Keyboard + indicator cinza
/// - `.chatInput(input:)`     → ChatInput + indicator em glass
/// - `.chatInputAndKeyboard(input:, keyboard:)` → ChatInput em glass + Keyboard + indicator cinza
///
/// [heightFor] é o helper pra reservar espaço no shell.
class DilettaBottomApp extends StatelessWidget {
  final _BottomAppVariant variant;

  /// Só HomeIndicator, sem fundo, sem glass. Uso: Welcome, ErrorFatal, telas
  /// de resultado que não pedem barra fixa no rodapé.
  const DilettaBottomApp.defaultVariant({super.key})
      : variant = const _DefaultVariant();

  /// Nav (tabs) em glass + indicator.
  DilettaBottomApp.nav({super.key, required DilettaNav nav})
      : variant = _NavVariant(nav);

  /// NavigationButton (1-3 CTAs) em glass + indicator.
  DilettaBottomApp.button({
    super.key,
    required DilettaNavigationButton button,
  }) : variant = _ButtonVariant(button);

  /// Keyboard (numpad) + indicator cinza. Sem glass (numpad já é cinza sólido).
  DilettaBottomApp.keyboard({
    super.key,
    required DilettaKeyboard keyboard,
  }) : variant = _KeyboardVariant(keyboard);

  /// NavigationButton em glass + Keyboard + indicator cinza.
  DilettaBottomApp.buttonAndKeyboard({
    super.key,
    required DilettaNavigationButton button,
    required DilettaKeyboard keyboard,
  }) : variant = _ButtonAndKeyboardVariant(button, keyboard);

  /// ChatInput em glass + indicator.
  DilettaBottomApp.chatInput({
    super.key,
    required DilettaChatInput input,
  }) : variant = _ChatInputVariant(input);

  /// ChatInput em glass + Keyboard + indicator cinza.
  DilettaBottomApp.chatInputAndKeyboard({
    super.key,
    required DilettaChatInput input,
    required DilettaKeyboard keyboard,
  }) : variant = _ChatInputAndKeyboardVariant(input, keyboard);

  /// Altura útil de cada variante — usar como `bottomSlotHeight` no shell pai.
  static double heightFor(_BottomAppVariant v) => v.height;

  // Constantes de altura por variante (compat com callers legados).
  static const double heightDefault = 34;
  // Nav = 16 headroom (estouro do ativo) + 76 row + 34 indicator.
  // Barra VISUAL = 110 (spec): glass + stroke white + shadow blackAlpha13.
  static const double heightNav = 126;
  static const double heightButton1 = 122;
  static const double heightButton2 = 190;
  static const double heightButton3 = 258;
  static const double heightKeyboard = 315;
  static const double heightChatInput = 122;
  static const double heightChatInputAndKeyboard = 369;
  static const double heightButtonAndKeyboardPrimaryOnly = 369;

  @override
  Widget build(BuildContext context) => variant.build();
}

// ═══════════════════════════════════════════════════════════════════════════
// Variantes
// ═══════════════════════════════════════════════════════════════════════════

sealed class _BottomAppVariant {
  const _BottomAppVariant();
  Widget build();
  double get height;
}

class _DefaultVariant extends _BottomAppVariant {
  const _DefaultVariant();
  @override
  double get height => DilettaBottomApp.heightDefault;
  @override
  Widget build() => const DilettaBottomHomeIndicator();
}

class _NavVariant extends _BottomAppVariant {
  const _NavVariant(this.nav);
  final DilettaNav nav;
  @override
  double get height => DilettaBottomApp.heightNav;

  /// Nav já traz glass + HomeIndicator próprios — embrulhar em GlassSurface
  /// aqui clipava o pop-out do item ativo (que estoura 16px acima da barra).
  @override
  Widget build() => nav;
}

class _ButtonVariant extends _BottomAppVariant {
  const _ButtonVariant(this.button);
  final DilettaNavigationButton button;
  @override
  double get height => DilettaBottomApp.heightButton1;
  @override
  Widget build() => DilettaGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
              child: button,
            ),
            const DilettaBottomHomeIndicator(),
          ],
        ),
      );
}

class _KeyboardVariant extends _BottomAppVariant {
  const _KeyboardVariant(this.keyboard);
  final DilettaKeyboard keyboard;
  @override
  double get height => DilettaBottomApp.heightKeyboard;
  @override
  Widget build() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          keyboard,
          DilettaTheme.comEsquema((s) => DilettaBottomHomeIndicator(background: s.border)),
        ],
      );
}

class _ButtonAndKeyboardVariant extends _BottomAppVariant {
  const _ButtonAndKeyboardVariant(this.button, this.keyboard);
  final DilettaNavigationButton button;
  final DilettaKeyboard keyboard;
  @override
  double get height => DilettaBottomApp.heightButtonAndKeyboardPrimaryOnly;
  @override
  Widget build() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaGlassSurface(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
              child: button,
            ),
          ),
          keyboard,
          DilettaTheme.comEsquema((s) => DilettaBottomHomeIndicator(background: s.border)),
        ],
      );
}

class _ChatInputVariant extends _BottomAppVariant {
  const _ChatInputVariant(this.input);
  final DilettaChatInput input;
  @override
  double get height => DilettaBottomApp.heightChatInput;
  @override
  Widget build() => DilettaGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(DilettaSpacing.s6, DilettaSpacing.s4, DilettaSpacing.s6, DilettaSpacing.s2),
              child: input,
            ),
            const DilettaBottomHomeIndicator(),
          ],
        ),
      );
}

class _ChatInputAndKeyboardVariant extends _BottomAppVariant {
  const _ChatInputAndKeyboardVariant(this.input, this.keyboard);
  final DilettaChatInput input;
  final DilettaKeyboard keyboard;
  @override
  double get height => DilettaBottomApp.heightChatInputAndKeyboard;
  @override
  Widget build() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaGlassSurface(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(DilettaSpacing.s6, DilettaSpacing.s4, DilettaSpacing.s6, DilettaSpacing.s4),
              child: input,
            ),
          ),
          keyboard,
          DilettaTheme.comEsquema((s) => DilettaBottomHomeIndicator(background: s.border)),
        ],
      );
}
