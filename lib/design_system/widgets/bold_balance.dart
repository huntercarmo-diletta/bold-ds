import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';
import 'bold_skeleton.dart';
import 'bold_status_tag.dart';

/// Conta BOLD — Balance (organismo). Card de saldo da home, spec Redesenho
/// v.01 (Figma 4841-38668):
///
/// - card GLASS (vidro único) · radius 16 · padding 16 em todos os lados
///   MENOS a direita (0 — o botão Extrato carrega o próprio respiro);
/// - alinhado à ESQUERDA;
/// - linha 1: "Seu saldo" (Label/large) + botão "Extrato ›" (tertiary
///   branco, xs);
/// - valor em Headline/medium branco (largura reservada — mascarar não
///   desloca nada);
/// - pills de entradas/saídas ([BoldStatusTag]) com 4px entre elas.
///
/// O toggle de ocultar vive no TOP BAR (ícone eye-slash) — o card só reflete
/// [hidden]. Controlado: o pai guarda o estado.
///
/// **Composição** — BoldCard + BoldButton + BoldStatusTag + tokens.
///
/// ```dart
/// BoldBalance(
///   value: 'R$ 2.912,47',
///   hidden: _hidden,
///   onExtrato: openExtrato,
///   entradas: 'R$ 300,00',
///   saidas: 'R$ 300,00',
/// );
/// ```
class BoldBalance extends StatelessWidget {
  const BoldBalance({
    super.key,
    required this.value,
    this.hidden = false,
    this.onExtrato,
    this.entradas,
    this.saidas,
    this.loading = false,
    this.statsLoading = false,
  });

  /// Valor formatado ("R$ 2.912,47"). Mascarado internamente se [hidden].
  final String value;
  final bool hidden;

  /// Botão "Extrato ›" na linha do label (some se null).
  final VoidCallback? onExtrato;

  /// Valores do mês, SEM sinal — o pill já carrega a semântica (somem se null).
  final String? entradas;
  final String? saidas;

  /// Skeleton no lugar do valor enquanto o saldo carrega.
  final bool loading;

  /// Skeleton no lugar dos pills enquanto os totais do mês carregam — evita o
  /// "pop-in" (os pills surgirem do nada depois).
  final bool statsLoading;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final amountStyle = BoldType.headlineMd.copyWith(color: c.textPrimary);

    return BoldCard(
      glass: true,
      radius: 16,
      // 16 nos lados + 8 à direita. Sem altura forçada nem centro: o padding
      // faz o trabalho, top/bottom IGUAIS (16), gaps exatos (8).
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── "Seu saldo" + botão Extrato ─────────────────────────────────
          Row(children: [
            Text('Seu saldo',
                style: BoldType.labelLg.copyWith(color: c.textPrimary)),
            const Spacer(),
            if (onExtrato != null)
              // Link tertiary no ink do tema (branco no dark, preto no light) —
              // NÃO coral.
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onExtrato,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Extrato',
                      style: BoldType.button
                          .copyWith(fontSize: 13, color: c.textPrimary)),
                  const SizedBox(width: 4),
                  BoldIcon('angle-right-solid',
                      size: BoldIconSize.sm, color: c.textPrimary),
                ]),
              ),
          ]),
          const SizedBox(height: BoldSpace.x2),

          // ── Valor — skeleton no load; largura reservada senão ───────────
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: BoldSkeleton(width: 190, height: 26, radius: 8),
            )
          else
            Stack(alignment: Alignment.centerLeft, children: [
              Opacity(
                  opacity: 0,
                  child: Text(value, maxLines: 1, style: amountStyle)),
              Text(hidden ? 'R\$ ••••••' : value,
                  maxLines: 1, style: amountStyle),
            ]),

          // ── Pills de entradas/saídas (skeleton no load) — 4px entre elas ─
          if (statsLoading) ...[
            const SizedBox(height: BoldSpace.x2),
            const Row(children: [
              BoldSkeleton(width: 92, height: 20, radius: 200),
              SizedBox(width: BoldSpace.x1),
              BoldSkeleton(width: 92, height: 20, radius: 200),
            ]),
          ] else if (entradas != null || saidas != null) ...[
            const SizedBox(height: BoldSpace.x2),
            Row(children: [
              if (entradas != null)
                BoldStatusTag(
                    // o "olho" oculta o saldo E os totais (pedido do Michel)
                    label: hidden ? 'R\$ ••••' : entradas!,
                    icon: 'arrow-right-to-bracket-solid',
                    tone: BoldStatusTone.success),
              if (entradas != null && saidas != null)
                const SizedBox(width: BoldSpace.x1),
              if (saidas != null)
                BoldStatusTag(
                    label: hidden ? 'R\$ ••••' : saidas!,
                    icon: 'arrow-right-from-bracket-solid',
                    tone: BoldStatusTone.danger),
            ]),
          ],
        ],
      ),
    );
  }
}
