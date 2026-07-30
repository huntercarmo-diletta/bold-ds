import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_feature_detail_card.dart' show DilettaFeatureCapability;
import 'cpf_seguro_button.dart';
import 'cpf_seguro_status_tag.dart';
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Estado de um passo da Jornada.
enum DilettaJourneyStepState {
  /// Conquistado — AZUL (primary): o usuário está mais SEGURO.
  done,

  /// Próximo passo — ainda não tem: cinza.
  next,

  /// Bloqueado (depende de nível anterior): cinza + cadeado.
  locked,
}

/// Ação pendente de um nível da Jornada ("Fazer reconhecimento facial").
class DilettaJourneyAction {
  const DilettaJourneyAction({required this.icon, required this.label, this.onPressed});
  final String icon;
  final String label;
  final VoidCallback? onPressed;
}

/// CPF SEGURO — JourneyStep (molécula).
///
/// Passo do stepper vertical da tela "Sua jornada": marker + conector
/// DASHED até o próximo passo + card com o que o nível libera e os BOTÕES
/// do que falta ([actions]) — cada nível chama as próprias pendências.
/// Pendência concluída SOME da lista (ex: reconhecimento facial feito sai
/// do N3 — o caller filtra).
///
/// Regras de cor: conquistado = primary (azul = mais seguro); o que o
/// usuário ainda não tem = cinza. Marker de concluído é sempre o
/// `circle-check` (nunca check solto). As capacidades são listadas SEMPRE
/// uma embaixo da outra.
///
/// **Composição** — Icon, StatusTag (+ DilettaFeatureCapability como
/// data class) + tokens.
class DilettaJourneyStep extends StatelessWidget {
  const DilettaJourneyStep({
    super.key,
    required this.number,
    required this.title,
    required this.state,
    required this.tag,
    this.caption,
    this.capabilities = const [],
    this.actions = const [],
    this.isLast = false,
  });

  final String number;
  final String title;
  final DilettaJourneyStepState state;
  final DilettaStatusTagData tag;
  final String? caption;
  final List<DilettaFeatureCapability> capabilities;

  /// Pendências do nível — botões de chamada (primary no próximo passo,
  /// secondary nos bloqueados).
  final List<DilettaJourneyAction> actions;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final bool achieved = state == DilettaJourneyStepState.done;
    final Color accent = achieved ? s.primary : s.textPlaceholder;

    final Widget marker = switch (state) {
      // Conquistado: circle-check AZUL, sempre. IconAccessory segue a
      // regra do padding 2 (size 32 = ícone 28).
      DilettaJourneyStepState.done => DilettaIconAccessory(
          icon: DilettaIcons.circleCheckLight,
          size: 32,
          color: s.primary,
        ),
      DilettaJourneyStepState.next => Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: s.surfaceMuted, shape: BoxShape.circle),
          child: Text(number, style: DilettaType.subheading.copyWith(color: s.textTertiary)),
        ),
      DilettaJourneyStepState.locked => Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: s.isDark ? s.palette.neutral02 : s.palette.neutral10,
            shape: BoxShape.circle,
          ),
          child: DilettaIconAccessory(icon: DilettaIcons.lockLight, size: 14, padding: 0, color: s.textPlaceholder),
        ),
    };

    return DilettaDevInfo(
      component: 'DilettaJourneyStep',
      props: {'title': "'$title'", 'state': state.name, 'capabilities': '${capabilities.length}', 'actions': '${actions.length}'},
      tokens: const ['done=azul primary-04 · resto=cinza · circle-check', 'conector dashed 2px · pills e actions empilhados'],
      child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Marker + conector dashed até o próximo passo.
          SizedBox(
            width: 32,
            child: Column(children: [
              marker,
              if (!isLast)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s1),
                    child: _DashedVerticalLine(
                      color: achieved ? s.primary : s.border,
                    ),
                  ),
                ),
            ]),
          ),
          const SizedBox(width: 12),
          // Card do nível.
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : DilettaSpacing.s4),
              padding: const EdgeInsets.all(DilettaSpacing.s4),
              decoration: BoxDecoration(
                color: s.surface,
                borderRadius: DilettaRadius.all16,
                border: Border.all(color: s.divider, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        title,
                        style: DilettaType.subheading.copyWith(
                          color: state == DilettaJourneyStepState.locked
                              ? s.textMuted
                              : s.fg,
                        ),
                      ),
                    ),
                    DilettaStatusTag(label: tag.label, tone: tag.tone, icon: tag.icon),
                  ]),
                  if (caption != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      caption!,
                      style: DilettaType.caption.copyWith(color: s.textMuted),
                    ),
                  ],
                  if (capabilities.isNotEmpty) const SizedBox(height: 12),
                  // SEMPRE uma embaixo da outra — nunca lado a lado.
                  for (var i = 0; i < capabilities.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        height: 24,
                        padding: const EdgeInsets.only(left: DilettaSpacing.s2, right: DilettaSpacing.s3),
                        decoration: BoxDecoration(
                          border: Border.all(color: accent, width: 1),
                          borderRadius: DilettaRadius.all200,
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          DilettaIconAccessory(icon: capabilities[i].icon, size: 12, padding: 0, color: accent),
                          const SizedBox(width: 4),
                          Text(
                            capabilities[i].label,
                            style: DilettaType.labelSm.copyWith(color: accent),
                          ),
                        ]),
                      ),
                    ]),
                  ],
                  // Botões do que falta — primary quando é o próximo passo,
                  // secondary nos níveis bloqueados.
                  if (actions.isNotEmpty) const SizedBox(height: 16),
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    DilettaButton(
                      label: actions[i].label,
                      leadIcon: actions[i].icon,
                      type: state == DilettaJourneyStepState.next
                          ? DilettaButtonType.primary
                          : DilettaButtonType.secondary,
                      size: DilettaButtonSize.sm,
                      fullWidth: true,
                      onPressed: actions[i].onPressed,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

/// Linha vertical DASHED 2px — conector entre passos da jornada.
class _DashedVerticalLine extends StatelessWidget {
  const _DashedVerticalLine({required this.color});
  final Color color;

  // CustomPaint (não LayoutBuilder): o conector vive sob IntrinsicHeight (o
  // marker estica até a altura do card). LayoutBuilder não sabe responder
  // dimensões intrínsecas e quebrava o layout. CustomPaint sem filho reporta
  // intrínseco 0 e pinta os tracinhos na altura que o Expanded der.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      child: CustomPaint(painter: _DashedLinePainter(color)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 4.0;
    const gap = 3.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final x = size.width / 2;
    for (double y = 0; y < size.height; y += dash + gap) {
      final end = (y + dash) > size.height ? size.height : (y + dash);
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}
