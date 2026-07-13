import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';
import 'bold_list.dart';

/// Conta BOLD — Alert (molécula). Aviso inline dentro do fluxo (limites,
/// instruções, confirmações, erros). O [intent] escolhe o TOM SEMÂNTICO das
/// escalas: bg = wash (07/08/09), border = tom claro (06/07), spot no tom base
/// — o texto permanece neutro (legibilidade primeiro).
///
/// - `info`    → primary (rosa da marca)
/// - `error`   → error   · `warning` → warning · `success` → success
///
/// **Composição** — BoldSpotIcon (átomo, tom semântico) + BoldIcon (átomo) +
/// tokens (escalas de cor, tipografia, raio).
///
/// ```dart
/// BoldAlert(
///   intent: BoldIntent.error,
///   title: 'Não foi possível enviar o Pix',
///   message: 'Saldo insuficiente para esta transferência.',
///   onClose: () {},
/// );
/// BoldAlert(intent: BoldIntent.success, title: 'PIX enviado');
/// ```
enum BoldIntent { error, warning, success, info }

class _IntentSpec {
  const _IntentSpec(this.glyph, this.tone, this.bg, this.border);
  final String glyph;
  final BoldSpotTone tone;
  final Color bg;
  final Color border;
}

// Fill = wash @70% (tokens *Alpha70) — com a foto de fundo, todo fill do DS é
// GLASSY (tint translúcido + blur); inputs são a exceção (branco sólido).
_IntentSpec _spec(BoldIntent intent) => switch (intent) {
      BoldIntent.error => const _IntentSpec('circle-exclamation-light',
          BoldSpotTone.danger, BoldColors.error07Alpha70, BoldColors.error06),
      BoldIntent.warning => const _IntentSpec(
          'circle-exclamation-light',
          BoldSpotTone.warning,
          BoldColors.warning07Alpha70,
          BoldColors.warning06),
      BoldIntent.success => const _IntentSpec(
          'circle-check-light',
          BoldSpotTone.success,
          BoldColors.success07Alpha70,
          BoldColors.success06),
      BoldIntent.info => const _IntentSpec(
          'circle-info-light',
          BoldSpotTone.primary,
          BoldColors.primary09Alpha70,
          BoldColors.primary07),
    };

class BoldAlert extends StatelessWidget {
  const BoldAlert({
    super.key,
    required this.intent,
    required this.title,
    this.message,
    this.onClose,
  });

  final BoldIntent intent;
  final String title;
  final String? message;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final s = _spec(intent);
    // Glass tintado: o wash translúcido + blur deixam a foto de fundo passar.
    return ClipRRect(
      borderRadius: BoldRadius.fieldR,
      clipBehavior: BoldGlass.clip,
      child: BackdropFilter(
        filter: BoldGlass.blurFilter,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: s.bg,
            borderRadius: BoldRadius.fieldR,
            border: Border.all(color: s.border, width: 1),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldSpotIcon(s.glyph, tone: s.tone, filled: true, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: BoldType.title.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        // Fundo do alerta é SEMPRE escuro → título branco fixo (o
                        // default do BoldType.title é escuro e sumia no fundo).
                        color: BoldColors.textPrimary)),
                if (message != null) ...[
                  const SizedBox(height: 3),
                  Text(message!,
                      style: BoldType.bodySmall
                          .copyWith(color: BoldColors.neutral03)),
                ],
              ],
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: BoldIcon('close',
                    size: BoldIconSize.sm, color: BoldColors.neutral05),
              ),
            ),
        ],
      ),
        ),
      ),
    );
  }
}

/// Toast flutuante pós-ação. Renderiza via [Overlay] (root), então aparece
/// sobre QUALQUER tela — inclusive rotas sem Scaffold (perfil, hubs pushados),
/// onde o SnackBar do ScaffoldMessenger ficaria preso na fila. Mesma paleta do
/// [BoldAlert]: superfície + neutral, glyph no tom.
class BoldToast {
  BoldToast._();

  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String message,
    String? description,
    BoldIntent intent = BoldIntent.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _current?.remove();
    _current = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _BoldToastView(
        message: message,
        description: description,
        intent: intent,
        duration: duration,
        onDismissed: () {
          if (_current == entry) _current = null;
          entry.remove();
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }
}

class _BoldToastView extends StatefulWidget {
  const _BoldToastView({
    required this.message,
    required this.description,
    required this.intent,
    required this.duration,
    required this.onDismissed,
  });
  final String message;
  final String? description;
  final BoldIntent intent;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_BoldToastView> createState() => _BoldToastViewState();
}

class _BoldToastViewState extends State<_BoldToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 240));
  late final Animation<double> _anim =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _c.reverse();
    if (!mounted) return;
    widget.onDismissed();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _spec(widget.intent);
    final safeTop = MediaQuery.of(context).padding.top;
    // Espelha o toast do CPF Seguro: vidro semântico por estado (wash 07 @70% +
    // border 06 + spot no tom), blur 10, título + subtítulo. No TOPO.
    final toast = ClipRRect(
      borderRadius: BoldRadius.chipR,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Semantics(
          liveRegion: true,
          container: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: s.bg,
              borderRadius: BoldRadius.chipR,
              border: Border.all(color: s.border, width: 1),
              boxShadow: const [
                BoxShadow(
                    color: BoldColors.blackAlpha8,
                    offset: Offset(0, 4),
                    blurRadius: 10),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BoldSpotIcon(s.glyph, tone: s.tone, filled: true, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.message,
                            style: BoldType.body.copyWith(
                                color: BoldColors.neutral01,
                                fontSize: 14,
                                height: 20 / 14,
                                fontWeight: FontWeight.w600)),
                        if (widget.description != null) ...[
                          const SizedBox(height: 2),
                          Text(widget.description!,
                              style: BoldType.bodySmall.copyWith(
                                  color: BoldColors.neutral03,
                                  fontSize: 13,
                                  letterSpacing: 0,
                                  height: 16 / 13)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Positioned(
      left: 20,
      right: 20,
      top: safeTop + 12,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, child) => Opacity(
            opacity: _anim.value.clamp(0.0, 1.0),
            child: Transform.translate(
                offset: Offset(0, (1 - _anim.value) * -12), child: child),
          ),
          // Material ancestral: o toast vive no Overlay raiz (sem Scaffold), e
          // sem Material o texto ganha o sublinhado amarelo de debug do Flutter.
          child: Material(type: MaterialType.transparency, child: toast),
        ),
      ),
    );
  }
}
