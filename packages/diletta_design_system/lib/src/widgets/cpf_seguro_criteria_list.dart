import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;

/// Estado de cada critério.
///
/// - **pending** — ainda não avaliado (marker vazio).
/// - **ok** — atendido (check verde).
/// - **fail** — reprovado (x vermelho).
enum DilettaCriteriaStatus { pending, ok, fail }

/// Item da lista de critérios (regra + estado).
class DilettaCriteriaItem {
  const DilettaCriteriaItem(
      {required this.label, this.status = DilettaCriteriaStatus.pending});
  final String label;
  final DilettaCriteriaStatus status;
}

/// CPF SEGURO — CriteriaList.
///
/// Lista de critérios/validações com marker de estado à esquerda (requisitos de
/// senha, checagens de formulário). Vocabulário standalone — consumido pela
/// [DilettaChatCriteriaBubble], pelo PasswordBottomSheet e por requisitos de
/// senha no app. O marker e o tom saem de tokens (success/error/placeholder).
///
/// ```dart
/// DilettaCriteriaList(items: [
///   DilettaCriteriaItem(label: 'Mínimo 8 caracteres', status: DilettaCriteriaStatus.ok),
///   DilettaCriteriaItem(label: 'Uma letra maiúscula'),
/// ])
/// ```
class DilettaCriteriaList extends StatelessWidget {
  const DilettaCriteriaList({super.key, required this.items, this.gap = 8});

  final List<DilettaCriteriaItem> items;

  /// Espaço vertical entre itens.
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          DilettaCriteriaRow(item: items[i]),
        ],
      ],
    );
  }
}

/// Uma linha de critério (marker + label). Público pra compor fora da lista.
class DilettaCriteriaRow extends StatelessWidget {
  const DilettaCriteriaRow({super.key, required this.item});
  final DilettaCriteriaItem item;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final labelColor = item.status == DilettaCriteriaStatus.ok
        ? s.palette.success04
        : s.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CriteriaMarker(status: item.status),
        const SizedBox(width: 8),
        Flexible(
          child: Text(item.label,
              style: DilettaType.chatBody.copyWith(color: labelColor)),
        ),
      ],
    );
  }
}

class _CriteriaMarker extends StatelessWidget {
  const _CriteriaMarker({required this.status});
  final DilettaCriteriaStatus status;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    if (status == DilettaCriteriaStatus.ok) {
      return DilettaIconAccessory(
          icon: DilettaIcons.circleCheckSolid,
          padding: 0,
          size: 16,
          color: s.success);
    }
    if (status == DilettaCriteriaStatus.fail) {
      return DilettaIconAccessory(
          icon: DilettaIcons.xmarkSolid,
          padding: 0,
          size: 16,
          color: s.error);
    }
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: s.textPlaceholder, width: 1.5),
      ),
    );
  }
}
