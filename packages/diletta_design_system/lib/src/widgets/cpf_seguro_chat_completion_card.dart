import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;

/// Capability (ícone + label) listada no [DilettaChatCompletionCard].
class DilettaCompletionCapability {
  const DilettaCompletionCapability({required this.icon, required this.label});
  final String icon;
  final String label;
}

/// CTA (label + callback) dos botões do [DilettaChatCompletionCard].
class DilettaCtaAction {
  const DilettaCtaAction({required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;
}

/// Progresso de nível ("Nível X de Y") do [DilettaChatCompletionCard].
class DilettaLevelProgress {
  const DilettaLevelProgress({required this.current, required this.total});
  final int current;
  final int total;
}

/// CPF SEGURO — ChatCompletionCard.
///
/// Card azul gradient de conclusão. Reutilizado em:
/// - Onboarding standalone (com level chip + capabilities + nextLevel)
/// - Migração SDK T5 (só title + CTA)
///
/// Mostra o que precisar, esconde o resto. TUDO opt-in: sem [primary] nem
/// [secondary] o card não renderiza botão (ex.: nível topo, ou fluxo que ainda
/// não libera as ações). [nextLevel] é um slot custom (acima dos botões) pra
/// quem precisa de uma seção de próximo-nível mais rica que o [nextLevelLabel]
/// estático (ex.: expansível do onboarding).
class DilettaChatCompletionCard extends StatelessWidget {
  const DilettaChatCompletionCard({
    super.key,
    required this.title,
    this.primary,
    this.levelChip,
    this.eyebrow,
    this.capabilities,
    this.nextLevelLabel,
    this.nextLevel,
    this.secondary,
    this.footer,
  });

  final String title;
  final DilettaCtaAction? primary;
  final DilettaLevelProgress? levelChip;
  final String? eyebrow;
  final List<DilettaCompletionCapability>? capabilities;
  final String? nextLevelLabel;
  final Widget? nextLevel;
  final DilettaCtaAction? secondary;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Container(
      padding: const EdgeInsets.only(left: DilettaSpacing.s6, right: DilettaSpacing.s6, top: DilettaSpacing.s6, bottom: DilettaSpacing.s4),
      decoration: BoxDecoration(
        gradient: DilettaGradients.brandLiftDe(s.palette),
        borderRadius: DilettaRadius.all24,
        boxShadow: DilettaElevation.brandHighDe(s.palette),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (levelChip != null) _LevelChip(chip: levelChip!),
          if (eyebrow != null) ...[
            if (levelChip != null) const SizedBox(height: 16),
            Text(
              eyebrow!.toUpperCase(),
              style: DilettaType.label.copyWith(
                color: s.palette.primary07,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
          if (levelChip != null || eyebrow != null) const SizedBox(height: 16),
          Text(
            title,
            style: DilettaType.title.copyWith(color: s.palette.white),
          ),
          if (capabilities != null && capabilities!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < capabilities!.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _CapabilityPill(cap: capabilities![i]),
                ],
              ],
            ),
          ],
          // Próximo nível: slot custom [nextLevel] tem prioridade sobre o label
          // estático [nextLevelLabel].
          if (nextLevel != null) ...[
            const SizedBox(height: 16),
            nextLevel!,
          ] else if (nextLevelLabel != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(top: DilettaSpacing.s3),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: DilettaAbsoluteColors.whiteAlpha32, width: 1)),
              ),
              child: Row(
                children: [
                  DilettaIconAccessory(icon: DilettaIcons.angleDownLight, padding: 0, size: 14, color: s.palette.primary07),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      nextLevelLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DilettaType.label.copyWith(
                        color: s.palette.primary07,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Botões só quando há CTA (sem primary/secondary → card sem botão).
          if (primary != null || secondary != null) ...[
            const SizedBox(height: 20),
            if (primary != null) _CtaPrimary(cta: primary!),
            if (secondary != null) ...[
              if (primary != null) const SizedBox(height: 8),
              _CtaSecondary(cta: secondary!),
            ],
          ],
          if (footer != null) Padding(padding: const EdgeInsets.only(top: DilettaSpacing.s1), child: footer!),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.chip});
  final DilettaLevelProgress chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s3, vertical: DilettaSpacing.s1),
      decoration: BoxDecoration(
        color: DilettaAbsoluteColors.whiteAlpha24,
        border: Border.all(color: DilettaAbsoluteColors.whiteAlpha38, width: 1),
        borderRadius: DilettaRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nível ${chip.current} de ${chip.total}',
            style: DilettaType.label.copyWith(color: DilettaAbsoluteColors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          for (var i = 0; i < chip.total; i++) ...[
            if (i > 0) const SizedBox(width: 3),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < chip.current ? DilettaAbsoluteColors.white : DilettaAbsoluteColors.whiteAlpha38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CapabilityPill extends StatelessWidget {
  const _CapabilityPill({required this.cap});
  final DilettaCompletionCapability cap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: DilettaSpacing.s3, right: DilettaSpacing.s4, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: DilettaAbsoluteColors.whiteAlpha24,
        border: Border.all(color: DilettaAbsoluteColors.whiteAlpha38, width: 1),
        borderRadius: DilettaRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaIconAccessory(icon: cap.icon, padding: 0, size: 14, color: DilettaAbsoluteColors.white),
          const SizedBox(width: 8),
          // FLEXIBLE, e não `Text` solto: a pílula é `mainAxisSize.min`, então um rótulo
          // longo pedia mais largura do que o card tem e estourava o layout. Componente
          // da linguagem não pode depender do texto ser curto — quem escreve o rótulo é
          // o produto, e um filho em outro idioma tem rótulo maior.
          Flexible(
            child: Text(
              cap.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DilettaType.subheading
                  .copyWith(color: DilettaAbsoluteColors.white, letterSpacing: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaPrimary extends StatelessWidget {
  const _CtaPrimary({required this.cta});
  final DilettaCtaAction cta;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaTappable(
      onTap: cta.onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: s.palette.white,
          borderRadius: DilettaRadius.all24,
        ),
        child: Text(
          cta.label,
          // Botão branco SOBRE o gradiente de marca: a tinta é o acento do filho.
          style: DilettaType.button.copyWith(color: s.primary),
        ),
      ),
    );
  }
}

class _CtaSecondary extends StatelessWidget {
  const _CtaSecondary({required this.cta});
  final DilettaCtaAction cta;

  @override
  Widget build(BuildContext context) {
    return DilettaTappable(
      onTap: cta.onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: DilettaAbsoluteColors.whiteAlpha38, width: 1),
          borderRadius: DilettaRadius.all24,
        ),
        child: Text(
          cta.label,
          style: DilettaType.button.copyWith(color: DilettaAbsoluteColors.white),
        ),
      ),
    );
  }
}
