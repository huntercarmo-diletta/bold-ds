import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAbsoluteColors, DilettaStatusTagPorte, DilettaStatusTone;
import 'bold_icone.dart' show CoreflowIcone;
import 'package:flutter/widgets.dart';
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_radius.dart' show CoreflowRadius;
import 'bold_type.dart' show CoreflowType;
import 'bold_palette.dart' show BoldColors;
import 'bold_scheme.dart' show CoreflowScheme;

// O TOM é o do pai. Ele tinha 5 valores aqui e 7 lá, e os 5 eram os mesmos
// nomes — vocabulário duplicado, não vocabulário próprio. Os dois que faltavam
// (`secure`, `pending`) entram na receita tonal, que é a mesma conta.

/// Conta BOLD — StatusTag (molécula). Spec Redesenho v.01 (Figma):
///
/// - pill **h20 · radius 200 · padding start 4 / end 8**;
/// - fill = gradiente linear `branco@37–42% → wash do tom` (o pill fica
///   levemente translúcido no topo e sólido no wash embaixo);
/// - stroke **0.5px inside** no tom · texto/ícone no tom (11/med/ls.5);
/// - ícone opcional 8px.
///
/// Success/danger vêm 1:1 do Figma; os demais tons replicam a receita.
///
/// [dot] mostra um ponto sólido no tom (●) antes do label — usado nas tags de
/// status (Ativa/Pendente/Rejeitada/Cancelada). Tem precedência sobre [icon].
///
/// ## Por que esta casca não fechou (22/08), e o número dos dois lados
///
/// **A tag tem 4 primitivos por causa de um alfa no topo.** O pedido de 21/08 subiu em duas
/// metades e voltou dividido: o **PONTO entrou** (`DilettaStatusTag(ponto:)`, disco de 6 na tinta
/// do tom, mesmo eixo do `icon`) e o **fill em gradiente ESPERA**.
///
/// A razão da espera é de TIPO e não de gosto: o `DilettaPintura.bg` do pai é `Color`, e **seis
/// peças** leem essa struct — trocar por `Gradient` moveria as seis por um redesenho de um produto
/// só. Reabre no segundo filho que medir fill não-liso em tag, e aí entra como declaração de
/// paleta, no molde do `tinteDeVidro`. **1º caso registrado no ledger dele.**
///
/// O resto já é dele: altura **20**, padding start 4 / end 8, borda **0.5**, rótulo `labelSm` 11 e
/// o enum de tom (`DilettaStatusTone`), que eu consumo desde que existe. O que sobra aqui é o
/// gradiente `branco 37–42% → wash do tom` do Figma Redesenho v.01, e ele é o único motivo de os
/// 5 sítios não delegarem.
///
/// Um custo que o veredito deixou escrito e é meu de pagar quando a casca fechar: no `pending` o
/// disco vence o relógio, e como `pending` e `neutral` pintam igual de propósito, uma fileira toda
/// com disco perde a distinção entre *esperando* e *sem estado*.
///
/// **Composição** — CoreflowIcone (átomo) + tokens (escalas semânticas).
///
/// ```dart
/// CoreflowEtiqueta(label: 'R$ 300,00', icon: 'arrow-trend-up-light',
///     tone: DilettaStatusTone.success);
/// CoreflowEtiqueta(label: 'Ativa', dot: true, tone: DilettaStatusTone.success);
/// ```
class CoreflowEtiqueta extends StatelessWidget {
  const CoreflowEtiqueta({
    super.key,
    required this.label,
    this.tone = DilettaStatusTone.neutral,
    this.porte = DilettaStatusTagPorte.compacta,
    this.icon,
    this.dot = false,
  });

  final String label;
  final DilettaStatusTone tone;
  final String? icon;

  /// Ponto sólido no tom antes do label (●). Precede [icon].
  final bool dot;

  /// O PORTE, e ele entrou no pai na `v0.148.0` respondendo o pedido desta casa: seis pílulas deste
  /// app carregam FRASE e tinham padding vertical de 4 a 8 contra a altura declarada de 20.
  ///
  /// `ampla` = padding `s3`/`s1_5`, `label` 14, glifo 16, **altura pelo conteúdo** — porque com
  /// `label` dentro, altura cravada corta o rótulo quando a pessoa aumenta a fonte do sistema.
  final DilettaStatusTagPorte porte;

  @override
  Widget build(BuildContext context) {
    final t = _toneSpec(tone, CoreflowScheme.of(context));
    final ampla = porte == DilettaStatusTagPorte.ampla;
    return Container(
      // Na AMPLA a altura sai do conteúdo — é a regra do porte no pai, e a razão é a mesma: com
      // `label` 14 dentro, altura cravada corta o rótulo quando a fonte do sistema cresce.
      height: ampla ? null : 20,
      padding: ampla
          ? const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6)
          : EdgeInsetsDirectional.only(start: dot ? 8 : 4, end: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.fill,
        borderRadius: CoreflowRadius.pillR,
        border: Border.all(
          color: t.stroke,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: t.fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ] else if (icon != null) ...[
            CoreflowIcone(icon!, size: ampla ? 16 : 8, color: t.fg),
            const SizedBox(width: DilettaSpacing.s1),
          ],
          Text(label,
              maxLines: 1,
              softWrap: false,
              // Era `bodySmall` (13) reescrito campo a campo até virar 11/16 · 500 · 0,5 —
              // que é exatamente o `labelSm`. Quatro sobrescritas pra chegar num degrau que já
              // existia.
              style: (ampla ? CoreflowType.label : CoreflowType.labelSm)
                  .copyWith(color: t.fg)),
        ],
      ),
    );
  }
}

class _ToneSpec {
  const _ToneSpec({required this.fg, required this.fill, required this.stroke});

  /// Texto + ícone.
  final Color fg;

  /// Fill do pill.
  final Color fill;

  /// Stroke (0.5px inside).
  final Color stroke;
}

// Todas as escalas são theme-aware.
// - Success/danger: vidro branco (cor só no texto/ícone). Dark → fill branco
//   15% / stroke 25% / fg 05; light → fill 40% / stroke 74% / fg 04.
// - Warning/primary/neutral (tons tintados): LIGHT mantém o wash claro do Figma
//   (07/08/10) + fg escuro; DARK usa tinta sutil do tom sobre a surface
//   (alphaBlend 16%) + fg claro (05) — senão o wash claro vira um pill quase
//   branco no dark.
_ToneSpec _toneSpec(DilettaStatusTone t, CoreflowScheme s) {
  final isDark = s.isDark;
  Color glassFill() =>
      DilettaAbsoluteColors.white.withValues(alpha: isDark ? 0.15 : 0.40);
  Color glassStroke() =>
      DilettaAbsoluteColors.white.withValues(alpha: isDark ? 0.25 : 0.74);

  _ToneSpec tinted({
    required Color base, // matiz do fill (dark) + stroke
    required Color washLight, // fill claro do Figma (light)
    required Color fgLight,
    required Color fgDark,
  }) {
    if (isDark) {
      return _ToneSpec(
        fg: fgDark,
        fill: Color.alphaBlend(base.withValues(alpha: 0.16), s.surface),
        stroke: base.withValues(alpha: 0.45),
      );
    }
    return _ToneSpec(fg: fgLight, fill: washLight, stroke: fgLight);
  }

  return switch (t) {
    DilettaStatusTone.success => _ToneSpec(
        fg: isDark ? BoldColors.success05 : BoldColors.success04,
        fill: glassFill(),
        stroke: glassStroke()),
    DilettaStatusTone.danger => _ToneSpec(
        fg: isDark ? BoldColors.error05 : BoldColors.error04,
        fill: glassFill(),
        stroke: glassStroke()),
    DilettaStatusTone.warning => tinted(
        base: BoldColors.warning04,
        washLight: BoldColors.warning07,
        fgLight: BoldColors.warning03,
        fgDark: BoldColors.warning05),
    // O ÚNICO tom que sai da PALETA e não da rampa do Bold, e é a diferença que define filho.
    //
    // Os outros seis são semânticos — sucesso, perigo, aviso, neutro, cofre, espera —, e cor
    // semântica é invariante por regra do pai: um produto novo não inventa outro vermelho de erro.
    // O tom de MARCA é o oposto: se ele ler `BoldColors.primary04`, a etiqueta de marca de qualquer
    // filho sai rosa Bold. Foi assim que o gate deste pacote pegou esta tabela na mudança de casa —
    // ela veio do app, onde a paleta era uma só e a const não mentia.
    DilettaStatusTone.primary => tinted(
        base: s.paleta.primary04,
        washLight: s.paleta.primary08,
        fgLight: s.paleta.primary04,
        fgDark: s.paleta.primary05),
    DilettaStatusTone.neutral => tinted(
        base: BoldColors.neutral05,
        washLight: BoldColors.neutral10,
        fgLight: BoldColors.neutral03,
        fgDark: BoldColors.neutral05),
    DilettaStatusTone.secure => tinted(
        base: BoldColors.secure04,
        washLight: BoldColors.secure07,
        fgLight: BoldColors.secure03,
        fgDark: BoldColors.secure05),
    // `pending` não é cor nova: é o amarelo do aviso com o papel de espera.
    DilettaStatusTone.pending => tinted(
        base: BoldColors.warning04,
        washLight: BoldColors.warning07,
        fgLight: BoldColors.warning03,
        fgDark: BoldColors.warning05),
  };
}
