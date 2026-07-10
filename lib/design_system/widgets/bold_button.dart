import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_gradients.dart';
import 'bold_icon.dart';

/// Raio dos botões (Redesenho v.01): 16 pra casar com os cards.
const double _kBtnRadius = 16;

/// Conta BOLD — Button (molécula). Pills full-height. O `variant` codifica a
/// intenção, o `size` a densidade (sm 40 · md 48 · lg 56), e há slots de ícone
/// [glyph] (lead) e [trailingGlyph] (trail).
///
/// * [BoldButtonVariant.primary]     — gradiente rosa da marca. "Avançar / enviar".
/// * [BoldButtonVariant.accent]      — gradiente coral. "Confirmar / CTA".
/// * [BoldButtonVariant.secondary]   — outline neutro. Alternativa.
/// * [BoldButtonVariant.text]        — link (coral).
/// * [BoldButtonVariant.destructive] — perigo (link; `filled: true` = pill sólido).
/// * [BoldButtonVariant.white]       — filled branco, texto brandPrincipal (CTA sobre cor).
///
/// **Composição** — BoldIcon (átomo) + tokens (gradientes, tipografia, raio).
///
/// ```dart
/// BoldButton('Entrar', onPressed: _login);
/// BoldButton('Ver mais', size: BoldButtonSize.sm, trailingGlyph: 'chevron-right', onPressed: _open);
/// BoldButton('Cancelar', variant: BoldButtonVariant.secondary, onPressed: _close);
/// BoldButton('Revogar', variant: BoldButtonVariant.destructive, filled: true, onPressed: _revoke);
/// ```
enum BoldButtonVariant { primary, accent, secondary, text, destructive, white }

/// Densidade do [BoldButton] — xs (28h, chips de ação) · sm (40h) · md (48h) · lg (56h).
enum BoldButtonSize { xs, sm, md, lg }

class BoldButton extends StatelessWidget {
  const BoldButton(
    this.label, {
    super.key,
    this.onPressed,
    this.variant = BoldButtonVariant.primary,
    this.size = BoldButtonSize.lg,
    this.icon,
    this.glyph,
    this.trailingGlyph,
    this.loading = false,
    this.expand = true,
    this.filled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final BoldButtonVariant variant;
  final BoldButtonSize size;
  final IconData? icon;

  /// Branded SVG glyph (BoldIcon name) na frente — precede [icon].
  final String? glyph;

  /// Branded SVG glyph atrás do label (ex.: 'chevron-right').
  final String? trailingGlyph;
  final bool loading;

  /// Estica pra largura disponível (default). false = inline.
  final bool expand;

  /// Só pra [BoldButtonVariant.destructive]: pill vermelho sólido em vez de link.
  final bool filled;

  bool get _disabled => onPressed == null && !loading;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final spec = _spec(size);
    switch (variant) {
      case BoldButtonVariant.primary:
        // Cor principal SÓLIDA (primary-04, a mesma do item ativo da navbar) —
        // sem gradiente. Texto branco + glow leve no tom.
        return _solid(BoldColors.primary04, spec, c);
      case BoldButtonVariant.accent:
        return _gradient(BoldGradients.accentButton, spec, c);
      case BoldButtonVariant.secondary:
        // Sobre a imagem escurecida (scheme dark): outline BRANCO sem fill.
        return c.isDark
            ? _outline(BoldColors.white, BoldColors.white,
                BoldColors.transparent, spec)
            : _outline(c.textBody, c.borderStrong,
                c.surface.withValues(alpha: 0.5), spec);
      case BoldButtonVariant.text:
        // Tertiary/ghost: BRANCO sobre a imagem (dark), coral no light.
        return _link(c.isDark ? BoldColors.white : BoldColors.accent, spec);
      case BoldButtonVariant.destructive:
        return filled
            ? _solid(BoldColors.dangerBright, spec, c)
            : _link(BoldColors.danger, spec);
      case BoldButtonVariant.white:
        // Filled branco com texto brandPrincipal — CTA sobre superfície de cor
        // (banner). Radius pill como o resto do DS.
        return _filled(BoldColors.white, BoldColors.brandPrincipal, spec);
    }
  }

  Widget _content(Color fg, _Spec spec) {
    if (loading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: spec.icon,
            height: spec.icon,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(fg),
              backgroundColor: fg.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: 10),
          Text('Carregando',
              style: BoldType.button.copyWith(color: fg, fontSize: spec.font)),
        ],
      );
    }
    final text =
        Text(label, style: BoldType.button.copyWith(color: fg, fontSize: spec.font));
    final Widget? lead = glyph != null
        ? BoldIcon(glyph!, size: spec.icon, color: fg)
        : icon != null
            ? Icon(icon, size: spec.icon, color: fg)
            : null;
    final Widget? trail = trailingGlyph != null
        ? BoldIcon(trailingGlyph!, size: spec.icon, color: fg)
        : null;
    if (lead == null && trail == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (lead != null) ...[lead, const SizedBox(width: 9)],
        text,
        if (trail != null) ...[const SizedBox(width: 9), trail],
      ],
    );
  }

  Widget _wrap(Widget child) =>
      expand ? SizedBox(width: double.infinity, child: child) : child;

  EdgeInsets _pad(_Spec s) =>
      EdgeInsets.symmetric(vertical: s.vpad, horizontal: s.hpad);

  Widget _gradient(Gradient gradient, _Spec spec, BoldScheme c) {
    // Texto adaptativo: branco no escuro, escuro no claro. O gradiente sunset é
    // bem claro (termina em amarelo), então texto branco fica invisível no tema
    // claro — `c.textPrimary` resolve isso. Fundo desabilitado idem (adaptativo).
    return _wrap(Opacity(
      opacity: _disabled ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _disabled ? null : gradient,
          color: _disabled ? c.surfacePressed : null,
          borderRadius: BorderRadius.circular(_kBtnRadius),
        ),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kBtnRadius)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: Padding(
              padding: _pad(spec),
              child: Center(child: _content(c.textPrimary, spec)),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _outline(Color fg, Color border, Color fill, _Spec spec) {
    // O caller manda o fill JÁ com alpha (transparent = sem fundo de verdade;
    // withValues(alpha:) em transparent viraria preto 50%).
    return _wrap(Material(
      color: fill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kBtnRadius), side: BorderSide(color: border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: _pad(spec),
          child: Center(child: _content(fg, spec)),
        ),
      ),
    ));
  }

  Widget _solid(Color color, _Spec spec, BoldScheme c) {
    // Habilitado: fundo sólido colorido (vermelho) → texto branco. Desabilitado:
    // fundo/texto adaptativos (senão texto branco some no tema claro).
    return _wrap(Opacity(
      opacity: _disabled ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _disabled ? c.surfacePressed : color,
          borderRadius: BorderRadius.circular(_kBtnRadius),
          boxShadow: _disabled ? null : BoldElevation.glow(color),
        ),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kBtnRadius)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: Padding(
              padding: _pad(spec),
              child: Center(child: _content(
                  _disabled ? c.textPrimary : BoldColors.textPrimary, spec)),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _filled(Color bg, Color fg, _Spec spec) {
    return _wrap(Opacity(
      opacity: _disabled ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: bg, borderRadius: BoldRadius.pillR),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kBtnRadius)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: Padding(
              padding: _pad(spec),
              child: Center(child: _content(fg, spec)),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _link(Color fg, _Spec spec) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_kBtnRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(_kBtnRadius),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: _content(fg, spec),
        ),
      ),
    );
  }
}

class _Spec {
  const _Spec(this.vpad, this.hpad, this.font, this.icon);
  final double vpad;
  final double hpad;
  final double font;
  final double icon;
}

_Spec _spec(BoldButtonSize size) => switch (size) {
      BoldButtonSize.xs => const _Spec(6, 12, 12, 12),
      BoldButtonSize.sm => const _Spec(10, 16, 13, 16),
      BoldButtonSize.md => const _Spec(13, 20, 14, 18),
      BoldButtonSize.lg => const _Spec(16, 24, 15, 20),
    };
