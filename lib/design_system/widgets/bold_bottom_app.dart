import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_glass_surface.dart';
import 'bold_home_indicator.dart';
import 'bold_keypad.dart';
import 'bold_navigation_button.dart';

export 'bold_home_indicator.dart';
export 'bold_navigation_button.dart';

/// Um item da nav ([BoldBottomApp.nav]). Passe [icon] pra um glyph Material, ou
/// [iconBuilder] pra um widget custom que recebe a cor resolvida (ex.: a marca
/// PIX oficial).
class BoldTabItem<T> {
  const BoldTabItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconBuilder,
  });

  final T value;
  final String label;
  final IconData? icon;
  final Widget Function(Color color)? iconBuilder;
}

/// Conta BOLD — BottomApp (organismo unificado). ÚNICO ponto de entrada pro
/// slot INFERIOR da tela: comporta navegação, CTAs, teclado e combinações,
/// numa [BoldGlassSurface] com [BoldHomeIndicator]/respiro opcional.
///
/// **Filosofia atomic** — Átomos: [BoldGlassSurface], [BoldHomeIndicator] ·
/// Moléculas: [BoldNavigationButton], [BoldKeypad], nav (tabs) · Organismo: este.
///
/// Variantes:
/// - `.nav(items:, current:, onTap:)`           → barra de navegação (tabs)
/// - `.button(primary:, secondary:, tertiary:)` → 1–3 CTAs empilhados
/// - `.keyboard(onKey:, onDelete:)`             → teclado numérico
/// - `.buttonAndKeyboard(...)`                  → CTA(s) + teclado (ex.: valor)
/// - `.child(child:)`                           → slot custom (escape hatch)
///
/// [homeIndicator] desenha a barra de gesto do iOS (útil em previews/frames);
/// no app real deixe `false` e o [safeBottom] aplica o inset do device.
///
/// ```dart
/// BoldBottomApp.button(
///   primary: BoldNavAction(label: 'Continuar', onPressed: submit),
///   secondary: BoldNavAction(label: 'Cancelar', onPressed: pop),
/// );
/// ```
class BoldBottomApp extends StatelessWidget {
  const BoldBottomApp.child({
    super.key,
    required this.child,
    this.glass = true,
    this.homeIndicator = false,
    this.safeBottom = true,
    this.bare = false,
    this.padding = const EdgeInsets.fromLTRB(
        BoldSpace.x5, BoldSpace.x3, BoldSpace.x5, 0),
  });

  /// Navegação (tabs) — barra flutuante de vidro. Cada tab = ícone + rótulo; a
  /// ativa ganha spot rosa + glyph branco. Traz o próprio vidro + respiro
  /// (é `bare`), então não recebe o envelope glass. Método estático (não
  /// construtor) por causa do genérico `<T>` do value — o uso é idêntico:
  /// `BoldBottomApp.nav<int>(current: tab, onTap: …, items: […])`.
  static Widget nav<T>({
    Key? key,
    required List<BoldTabItem<T>> items,
    required T current,
    required ValueChanged<T> onTap,
  }) =>
      BoldBottomApp.child(
        key: key,
        bare: true,
        glass: false,
        safeBottom: false,
        padding: EdgeInsets.zero,
        child: _BottomNav<T>(items: items, current: current, onTap: onTap),
      );

  /// 1–3 CTAs empilhados ([BoldNavigationButton]).
  BoldBottomApp.button({
    Key? key,
    BoldNavAction? primary,
    BoldNavAction? secondary,
    BoldNavAction? tertiary,
    bool glass = true,
    bool homeIndicator = false,
    bool safeBottom = true,
  }) : this.child(
          key: key,
          glass: glass,
          homeIndicator: homeIndicator,
          safeBottom: safeBottom,
          child: BoldNavigationButton(
              primary: primary, secondary: secondary, tertiary: tertiary),
        );

  /// Teclado numérico ([BoldKeypad]).
  BoldBottomApp.keyboard({
    Key? key,
    required ValueChanged<String> onKey,
    required VoidCallback onDelete,
    bool glass = true,
    bool homeIndicator = false,
    bool safeBottom = true,
  }) : this.child(
          key: key,
          glass: glass,
          homeIndicator: homeIndicator,
          safeBottom: safeBottom,
          padding: const EdgeInsets.fromLTRB(
              BoldSpace.x3, BoldSpace.x2, BoldSpace.x3, 0),
          child: BoldKeypad(onKey: onKey, onDelete: onDelete),
        );

  /// CTA(s) + teclado numérico juntos (ex.: entrada de valor com "Continuar").
  BoldBottomApp.buttonAndKeyboard({
    Key? key,
    BoldNavAction? primary,
    BoldNavAction? secondary,
    BoldNavAction? tertiary,
    required ValueChanged<String> onKey,
    required VoidCallback onDelete,
    bool glass = true,
    bool homeIndicator = false,
    bool safeBottom = true,
  }) : this.child(
          key: key,
          glass: glass,
          homeIndicator: homeIndicator,
          safeBottom: safeBottom,
          padding: const EdgeInsets.fromLTRB(
              BoldSpace.x3, BoldSpace.x2, BoldSpace.x3, 0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            BoldNavigationButton(
                primary: primary, secondary: secondary, tertiary: tertiary),
            const SizedBox(height: BoldSpace.x3),
            BoldKeypad(onKey: onKey, onDelete: onDelete),
          ]),
        );

  final Widget child;
  final bool glass;
  final bool homeIndicator;
  final bool safeBottom;

  /// `true` = o [child] já é a barra completa (traz vidro/respiro próprios) —
  /// build devolve ele cru, sem envelope. Usado pelo `.nav`.
  final bool bare;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (bare) return child;

    final c = BoldColors.of(context);
    final bottomInset =
        safeBottom ? MediaQuery.of(context).padding.bottom : 0.0;

    // Respiro inferior OBRIGATÓRIO do DS: 32 ([BoldSpace.bottomBreath]) — o
    // home indicator (h34) já o cumpre; senão, 32 + safe-area do device.
    final Widget content = Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(padding: padding, child: child),
      if (homeIndicator)
        BoldHomeIndicator(
            color: c.isDark ? BoldColors.white : BoldColors.neutral01)
      else
        SizedBox(height: BoldSpace.bottomBreath + bottomInset),
    ]);

    if (!glass) return content;
    return BoldGlassSurface(child: content);
  }
}

/// Barra de navegação flutuante (vidro) — miolo do [BoldBottomApp.nav]. Traz o
/// próprio vidro + margem + sombra (por isso `.nav` é `bare`).
class _BottomNav<T> extends StatelessWidget {
  const _BottomNav(
      {required this.items, required this.current, required this.onTap});

  final List<BoldTabItem<T>> items;
  final T current;
  final ValueChanged<T> onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final radius = BorderRadius.circular(26);
    final bar = DecoratedBox(
      decoration: BoxDecoration(
        // Vidro ÚNICO do DS: fill branco 26% + stroke branco 30% (token).
        color: BoldGlass.fill(c),
        borderRadius: radius,
        border:
            Border.all(color: BoldGlass.border(c), width: BoldGlass.borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        // Hug: a barra abraça os itens (não fill) e cresce conforme entram
        // mais entradas. Gap fixo entre tabs + respiro de 24 nas laterais.
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: items.map((t) {
            final active = t.value == current;
            // Ativo = spot fill primary-04 + glyph BRANCO; inativo = glyph no
            // ink do tema. Rótulo sempre no ink do tema; só o peso muda.
            final glyphColor = active ? BoldColors.white : c.textPrimary;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(t.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          active ? BoldColors.primary04 : BoldColors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: t.iconBuilder != null
                        ? t.iconBuilder!(glyphColor)
                        : Icon(t.icon, size: 21, color: glyphColor),
                  ),
                  const SizedBox(height: 3),
                  Text(t.label,
                      style: BoldType.monoCaption.copyWith(
                          fontFamily: BoldType.fontFamily,
                          fontSize: 10,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                          color: c.textPrimary)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        // Elevação da nav flutuante (token do DS, effect do CPF Seguro DS).
        // Fica no container EXTERNO (fora do ClipRRect do BackdropFilter), então
        // a sombra não é reamostrada pelo blur (não vira halo — ver BoldGlass).
        decoration: BoxDecoration(
            borderRadius: radius, boxShadow: BoldElevation.nav(dark: c.isDark)),
        child: ClipRRect(
          borderRadius: radius,
          clipBehavior: BoldGlass.frosted ? BoldGlass.clip : Clip.antiAlias,
          child: BoldGlass.frosted
              ? BackdropFilter(filter: BoldGlass.blurFilter, child: bar)
              : bar,
        ),
      ),
    );
  }
}
