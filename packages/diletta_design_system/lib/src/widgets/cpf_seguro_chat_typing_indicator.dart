import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_chat_tokens.dart';

/// CPF SEGURO — ChatTypingIndicator.
///
/// Bubble hug-content com 3 dots pulsando (pattern "digitando…" comum).
class DilettaChatTypingIndicator extends StatefulWidget {
  const DilettaChatTypingIndicator({super.key});

  @override
  State<DilettaChatTypingIndicator> createState() => _CpsChatTypingIndicatorState();
}

class _CpsChatTypingIndicatorState extends State<DilettaChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        label: 'Digitando',
        liveRegion: true,
        // Caixa fixa hug (não-fill): 80×54, padding-h 16 (Figma). Bot shape
        // (canto inferior-esquerdo âncora).
        child: Container(
          width: DilettaChatTokens.loadingWidth,
          height: DilettaChatTokens.loadingHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s4),
          decoration: BoxDecoration(
            color: s.surfaceMuted,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(DilettaChatTokens.radius),
              topRight: Radius.circular(DilettaChatTokens.radius),
              bottomRight: Radius.circular(DilettaChatTokens.radius),
              bottomLeft: Radius.circular(DilettaChatTokens.anchor),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                _Dot(controller: _c, index: i),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.controller, required this.index});
  final AnimationController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Pulso sequencial: cada dot atrasado 0.2s (16% do período).
        final t = (controller.value - index * 0.16667) % 1.0;
        final active = t >= 0 && t < 0.3;
        // Simplificação: opacity + translateY entre 0.3→1 e 0→-2 em 30% do ciclo.
        final progress = active ? (t / 0.3) : 0.0;
        final wave = active
            ? (0.5 - 0.5 * (1 - 2 * (progress - 0.5).abs()))
            : 0.0;
        final opacity = 0.3 + 0.7 * (active ? 1 - (2 * (progress - 0.5).abs()) : 0);
        return Transform.translate(
          offset: Offset(0, -2 * wave * 2),
          child: Opacity(
            opacity: opacity.clamp(0.3, 1.0),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: s.textMuted, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}
