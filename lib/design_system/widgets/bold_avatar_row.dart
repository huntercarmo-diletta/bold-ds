import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_gradients.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Conta BOLD — AvatarRow (molécula). Fileira de "Enviar para": avatares
/// circulares com as iniciais do contato + um botão-spot tracejado (adicionar).
///
/// Duas formas:
/// - **compacta** (default) — só avatares, 4px entre eles.
/// - **rotulada** — passe [labels] (1º nome) e opcionalmente [sublabels]
///   (banco): cada avatar ganha nome + banco embaixo, e a fileira rola na
///   horizontal (não estoura).
///
/// **Composição** — círculos com token de gradiente/tipografia + BoldIcon.
///
/// ```dart
/// BoldAvatarRow(initials: ['CM', 'BL'], onAdd: novoContato);
/// BoldAvatarRow(initials: ['CM'], labels: ['Carla'], sublabels: ['Nubank']);
/// ```
class BoldAvatarRow extends StatelessWidget {
  const BoldAvatarRow({
    super.key,
    required this.initials,
    this.labels,
    this.sublabels,
    this.size = 32,
    this.onTapAvatar,
    this.onAdd,
  });

  final List<String> initials;

  /// 1º nome sob cada avatar (ativa a forma rotulada se != null).
  final List<String>? labels;

  /// Banco (2ª linha) sob cada avatar — opcional, só na forma rotulada.
  final List<String>? sublabels;

  final double size;

  /// Toque num avatar (recebe o índice).
  final ValueChanged<int>? onTapAvatar;

  /// Botão "+" tracejado no fim (some se null).
  final VoidCallback? onAdd;

  bool get _labeled => labels != null;

  Widget _circle(int i) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: BoldGradients.brand,
          shape: BoxShape.circle,
        ),
        child: Text(initials[i],
            style: BoldType.bodySmall.copyWith(
                fontSize: size * 0.30,
                fontWeight: FontWeight.w700,
                color: BoldColors.onGradient)),
      );

  // Ink do tema: branco no dark (sobre a foto), neutral-01 no light.
  Widget _addButton(Color color) => CustomPaint(
        painter: _DashedCirclePainter(color),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: BoldIcon('plus-solid', size: 14, color: color),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return _labeled ? _buildLabeled(c) : _buildCompact(c);
  }

  // ── Compacta — só avatares, 4px entre eles ────────────────────────────────
  Widget _buildCompact(BoldScheme c) {
    final children = <Widget>[];
    for (var i = 0; i < initials.length; i++) {
      if (i > 0) children.add(const SizedBox(width: 4));
      children.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTapAvatar == null ? null : () => onTapAvatar!(i),
        child: _circle(i),
      ));
    }
    if (onAdd != null) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 4));
      children.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onAdd,
        child: _addButton(c.textPrimary),
      ));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  // ── Rotulada — avatar + 1º nome + banco, rola na horizontal ───────────────
  Widget _buildLabeled(BoldScheme c) {
    const itemW = 60.0;
    final items = <Widget>[];

    Widget cell({required Widget top, String? label, String? sub, VoidCallback? onTap}) =>
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: itemW,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              top,
              const SizedBox(height: 6),
              Text(label ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: BoldType.labelSm.copyWith(color: c.textPrimary)),
              if (sub != null && sub.isNotEmpty)
                Text(sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: BoldType.tileLabel.copyWith(color: c.textMuted)),
            ]),
          ),
        );

    for (var i = 0; i < initials.length; i++) {
      if (i > 0) items.add(const SizedBox(width: 8));
      items.add(cell(
        top: _circle(i),
        label: i < labels!.length ? labels![i] : '',
        sub: (sublabels != null && i < sublabels!.length) ? sublabels![i] : null,
        onTap: onTapAvatar == null ? null : () => onTapAvatar!(i),
      ));
    }
    if (onAdd != null) {
      if (items.isNotEmpty) items.add(const SizedBox(width: 8));
      items.add(cell(top: _addButton(c.textPrimary), label: 'Adicionar', onTap: onAdd));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: items),
    );
  }
}

/// Anel circular tracejado (stroke inside) — botão "adicionar".
class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    // Inside: raio deslocado meia-espessura pra dentro.
    final r = size.width / 2 - 0.5;
    final center = Offset(size.width / 2, size.height / 2);
    const dash = 3.4; // comprimento do traço
    const gap = 3.0; // vão
    final circ = 2 * 3.1415926535 * r;
    final count = (circ / (dash + gap)).floor();
    final step = 2 * 3.1415926535 / count;
    final dashAngle = step * dash / (dash + gap);
    for (var i = 0; i < count; i++) {
      final start = i * step;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        start,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter o) => o.color != color;
}
