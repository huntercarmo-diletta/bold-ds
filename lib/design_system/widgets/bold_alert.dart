import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';
import 'bold_list.dart';

/// Conta BOLD — Alert (molécula). Aviso inline dentro do fluxo (limites,
/// instruções, confirmações, erros). O [intent] escolhe o TOM SEMÂNTICO das
/// escalas: bg = wash 07 (superfície SÓLIDA clara), border = tom 05, título no
/// tom 02 (escuro) e mensagem em neutral02 — o par claro+escuro garante
/// contraste WCAG AA independente da foto de fundo. Espelha o info-box do Figma
/// (CPF Seguro): caixa clara sólida com texto escuro, não vidro translúcido.
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

// Glyph + tom do spot por intent (estáticos; independem do tema).
class _IntentSpec {
  const _IntentSpec(this.glyph, this.tone);
  final String glyph;
  final BoldSpotTone tone;
}

_IntentSpec _spec(BoldIntent intent) => switch (intent) {
      BoldIntent.error =>
        const _IntentSpec('circle-exclamation-light', BoldSpotTone.danger),
      BoldIntent.warning =>
        const _IntentSpec('circle-exclamation-light', BoldSpotTone.warning),
      BoldIntent.success =>
        const _IntentSpec('circle-check-light', BoldSpotTone.success),
      BoldIntent.info =>
        const _IntentSpec('circle-info-light', BoldSpotTone.primary),
    };

// Cores do alerta resolvidas por TEMA (o par superfície↔texto é o que garante
// o contraste WCAG AA):
//   • LIGHT → caixa clara (wash 07) + título no tom 02 (escuro) — info-box Figma.
//   • DARK  → superfície escura tingida (base @14% sobre surface) + título no
//     tom vibrante 05 + mensagem clara (textBody).
// Mensagem usa scheme.textBody (troca sozinho por tema: escuro no light, claro
// no dark). base = matiz do tint; washLight/borderLight/titleLight = paleta do
// modo claro; titleDark = tom vibrante do modo escuro.
class _AlertColors {
  const _AlertColors(this.bg, this.border, this.title, this.text);
  final Color bg, border, title, text;
}

_AlertColors _colorsFor(BoldIntent intent, BoldScheme s) {
  final (
    Color base,
    Color washLight,
    Color borderLight,
    Color titleLight,
    Color titleDark,
  ) = switch (intent) {
    BoldIntent.warning => (
        BoldColors.warning04,
        BoldColors.warning07,
        BoldColors.warning05,
        BoldColors.warning02,
        BoldColors.warning05,
      ),
    BoldIntent.error => (
        BoldColors.error05,
        BoldColors.error07,
        BoldColors.error05,
        BoldColors.error02,
        BoldColors.error05,
      ),
    BoldIntent.success => (
        BoldColors.success05,
        BoldColors.success07,
        BoldColors.success05,
        BoldColors.success02,
        BoldColors.success05,
      ),
    BoldIntent.info => (
        BoldColors.primary04,
        BoldColors.primary09,
        BoldColors.primary05,
        BoldColors.primary02,
        BoldColors.primary05,
      ),
  };

  if (s.isDark) {
    return _AlertColors(
      Color.alphaBlend(base.withValues(alpha: 0.14), s.surface),
      base.withValues(alpha: 0.50),
      titleDark,
      s.textBody,
    );
  }
  return _AlertColors(washLight, borderLight, titleLight, s.textBody);
}

// Spec do TOAST — espelha 1:1 o CpfSeguroToast: glyphs check/xmark/triangle/
// hand-wave, spot filled 34, radius 8, e o estado neutro (info) em neutral10/08
// (o CPF não tem toast rosa/primary). Separado do _spec do BoldAlert de propósito
// (o alert inline mantém o visual próprio).
class _ToastSpec {
  const _ToastSpec(this.glyph, this.tone, this.bg, this.border);
  final String glyph;
  final BoldSpotTone tone;
  final Color bg;
  final Color border;
}

_ToastSpec _toastSpec(BoldIntent intent) => switch (intent) {
      BoldIntent.success => const _ToastSpec('check-light',
          BoldSpotTone.success, BoldColors.success07Alpha70, BoldColors.success06),
      BoldIntent.error => const _ToastSpec('xmark-light', BoldSpotTone.danger,
          BoldColors.error07Alpha70, BoldColors.error06),
      // 'triangle-exclamation-light 1' = asset com nome vindo do import (espaço).
      BoldIntent.warning => const _ToastSpec(
          'triangle-exclamation-light 1',
          BoldSpotTone.warning,
          BoldColors.warning07Alpha70,
          BoldColors.warning06),
      BoldIntent.info => const _ToastSpec('hand-wave-light',
          BoldSpotTone.neutral, BoldColors.neutral10Alpha70, BoldColors.neutral08),
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
    final scheme = BoldColors.of(context);
    final cs = _colorsFor(intent, scheme);
    // Caixa sólida theme-aware (sem glass): light = clara+texto escuro, dark =
    // escura tingida+texto claro. O par superfície↔texto garante WCAG AA.
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.bg,
        borderRadius: BoldRadius.fieldR,
        border: Border.all(color: cs.border, width: 1),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        // Título no tom do intent (02 escuro no light / 05
                        // vibrante no dark) — alto contraste sobre a superfície.
                        color: cs.title)),
                if (message != null) ...[
                  const SizedBox(height: 3),
                  Text(message!,
                      style: BoldType.bodySmall.copyWith(color: cs.text)),
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
                    size: BoldIconSize.sm, color: scheme.textSecondary),
              ),
            ),
        ],
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
    final s = _toastSpec(widget.intent);
    final safeTop = MediaQuery.of(context).padding.top;
    // Espelha 1:1 o toast do CPF Seguro: vidro semântico (wash 07 @70% + border
    // 06, neutro no info), blur 10, spot filled 34, radius 8, sombra soft. No TOPO.
    const radius = BorderRadius.all(Radius.circular(8));
    final toast = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Semantics(
          liveRegion: true,
          container: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: s.bg,
              borderRadius: radius,
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
                  BoldSpotIcon(s.glyph, tone: s.tone, filled: true, size: 34),
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
