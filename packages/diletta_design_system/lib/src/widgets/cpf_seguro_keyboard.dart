import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;

class _NumKey {
  const _NumKey(this.n, [this.sub]) : type = _NumKeyType.number;
  const _NumKey.blank() : n = '', sub = null, type = _NumKeyType.blank;
  const _NumKey.backspace() : n = '', sub = null, type = _NumKeyType.backspace;
  final String n;
  final String? sub;
  final _NumKeyType type;
}

enum _NumKeyType { number, blank, backspace }

const _numpadRows = <List<_NumKey>>[
  [_NumKey('1'), _NumKey('2', 'ABC'), _NumKey('3', 'DEF')],
  [_NumKey('4', 'GHI'), _NumKey('5', 'JKL'), _NumKey('6', 'MNO')],
  [_NumKey('7', 'PQRS'), _NumKey('8', 'TUV'), _NumKey('9', 'WXYZ')],
  [_NumKey.blank(), _NumKey('0'), _NumKey.backspace()],
];

class _Numpad extends StatelessWidget {
  const _Numpad({required this.onKey, required this.onBackspace});
  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    // O FUNDO do numpad vem do scheme, igual as teclas. Era `neutral08` cravado:
    // no dark as teclas escureciam (elas usam `s.surface`) e o fundo continuava
    // cinza claro — o teclado ficava "mal formado", com tecla escura em cima de
    // placa clara. `surfaceMuted` é o papel certo: uma elevação abaixo da tecla.
    final s = DilettaTheme.schemeOf(context);
    return Container(
      color: s.surfaceMuted,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: DilettaSpacing.s4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < _numpadRows.length; r++) ...[
            if (r > 0) const SizedBox(height: 9),
            Row(
              children: [
                for (var i = 0; i < _numpadRows[r].length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _NumpadKey(
                      k: _numpadRows[r][i],
                      onPress: () {
                        final k = _numpadRows[r][i];
                        if (k.type == _NumKeyType.backspace) onBackspace();
                        else if (k.type == _NumKeyType.number) onKey(k.n);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({required this.k, required this.onPress});
  final _NumKey k;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    if (k.type == _NumKeyType.blank) return const SizedBox(height: 47);
    final s = DilettaTheme.schemeOf(context);
    final isBackspace = k.type == _NumKeyType.backspace;
    return Semantics(
      button: true,
      label: isBackspace ? 'Apagar' : k.n,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
          onTap: onPress,
          child: Container(
            height: 47,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isBackspace ? DilettaAbsoluteColors.transparent : s.surface,
              borderRadius: DilettaRadius.all8,
              boxShadow: isBackspace
                  ? null
                  : DilettaElevation.keyPress,
            ),
            child: isBackspace
                ? DilettaIconAccessory(icon: DilettaIcons.xmarkLight, padding: 0, size: 22, color: s.fg)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(k.n, style: DilettaType.numpadDigit.copyWith(color: s.fg)),
                      if (k.sub != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(k.sub!, style: DilettaType.numpadSubLabel.copyWith(color: s.fg)),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// CPF SEGURO — Numpad iOS público.
///
/// Reusável fora dos sheets — ex: dentro de CpfSeguroBottomButtonKeyboard.
/// Fundo cinza iOS (#D1D4DB), keys brancas com sombra sutil, backspace
/// como ícone xmark. Retorna `void` — o pai gerencia buffer.
class DilettaKeyboard extends StatelessWidget {
  const DilettaKeyboard({super.key, required this.onKey, required this.onBackspace});
  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) => _Numpad(onKey: onKey, onBackspace: onBackspace);
}

/// CPF SEGURO — KeyboardIndicator.
///
/// Barra de home indicator sobre o fundo cinza do numpad (fecha o teclado
/// numérico embaixo). Usada junto do [DilettaKeyboard] em sheets de senha.
class DilettaKeyboardIndicator extends StatelessWidget {
  const DilettaKeyboardIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Mesma correção do numpad: a placa e a barra vêm do scheme.
    final s = DilettaTheme.schemeOf(context);
    return Container(
      height: 34,
      color: s.surfaceMuted,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: DilettaSpacing.s2),
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: s.fg,
            borderRadius: DilettaRadius.pillAll,
          ),
        ),
      ),
    );
  }
}
