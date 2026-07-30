import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Gap (primitivo instrumentado).
///
/// Espaço (SizedBox) instrumentado — no dev mode, hover mostra o valor do
/// gap. Uso: `DilettaGap.h(24)` (vertical) · `DilettaGap.w(12)` (horizontal).
class DilettaGap extends StatelessWidget {
  const DilettaGap.h(this.size, {super.key}) : _vertical = true;
  const DilettaGap.w(this.size, {super.key}) : _vertical = false;

  final double size;
  final bool _vertical;

  @override
  Widget build(BuildContext context) {
    final box = _vertical ? SizedBox(height: size) : SizedBox(width: size);
    if (!DilettaDevMode.of(context)) return box;
    // Pinta uma faixa fina translúcida sobre o gap só pra dar hit-area e
    // marcar visualmente o espaçamento.
    return DilettaDevInfo(
      component: 'gap',
      props: {(_vertical ? 'height' : 'width'): '${size.toInt()}px'},
      tokens: const [],
      child: _vertical
          ? SizedBox(height: size, width: double.infinity, child: const _GapMarker(vertical: true))
          : SizedBox(width: size, height: double.infinity, child: const _GapMarker(vertical: false)),
    );
  }
}

class _GapMarker extends StatelessWidget {
  const _GapMarker({required this.vertical});
  final bool vertical;
  @override
  Widget build(BuildContext context) => const ColoredBox(color: DilettaAbsoluteColors.debugRuler);
}
