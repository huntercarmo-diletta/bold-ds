import 'package:flutter/widgets.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Frame (primitivo de LAYOUT).
///
/// O nó de layout do DS: encapsula `Row`/`Column`/`Stack` crus atrás da fachada
/// do design system. É a base do modelo de árvore de composição de tela
/// (`LayoutNode`, ver `DS_MONTAR_TELA.md` Parte 1) e o substituto do
/// `Column(crossAxisAlignment: stretch)` cru que o codegen empilhava na raiz das
/// telas geradas.
///
/// Dois modos:
///
/// - **flex** (`.row` / `.column`) → `Row`/`Column`. Filhos em fila, com `gap`
///   por token entre eles, alinhamento e `padding`. `scrollable: true` rola na
///   direção do eixo.
/// - **stack** (`.stack`) → `Stack`. Filhos sobrepostos; use [DilettaPinned]
///   pra fixar um filho numa borda (topbar/bottombar/overlays). Quem vem **por
///   último** na lista é desenhado **por cima** — o `content` deve ser o
///   primeiro filho.
///
/// Sizing dos filhos (o conceito `fill`/`hug`/`fixed` do auto-layout do Figma):
/// no modo flex, um filho "hug" é o default (encolhe pro conteúdo); "fill" no
/// eixo principal é um `Expanded`/`Flexible` passado como filho; no eixo cruzado,
/// `crossAxisAlignment: stretch` (default deste Frame) faz o filho preencher.
///
/// ```dart
/// DilettaFrame.column(
///   gap: DilettaSpacing.s4,
///   padding: const EdgeInsets.all(DilettaSpacing.s6),
///   children: [titulo, resumo, botao],
/// )
///
/// // chrome fixo por cima do conteúdo:
/// DilettaFrame.stack(children: [
///   conteudo, // primeiro = fica embaixo, preenche
///   DilettaPinned(top: 0, left: 0, right: 0, respectSafeArea: true, child: topBar),
///   DilettaPinned(bottom: 0, left: 0, right: 0, child: bottomBar),
/// ])
/// ```
enum _FrameMode { flex, stack }

enum _FrameAxis { row, column }

class DilettaFrame extends StatelessWidget {
  /// Frame vertical (`Column`). Default `crossAxisAlignment: stretch` — os
  /// filhos preenchem a largura, evitando o gotcha de `fill` dentro de cadeia
  /// `hug` (ver `DS_MONTAR_TELA.md` Parte 1).
  const DilettaFrame.column({
    super.key,
    this.children = const [],
    this.gap = 0,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.max,
    this.scrollable = false,
  })  : _mode = _FrameMode.flex,
        _axis = _FrameAxis.column,
        stackAlignment = AlignmentDirectional.topStart;

  /// Frame horizontal (`Row`). Default `crossAxisAlignment: center`.
  const DilettaFrame.row({
    super.key,
    this.children = const [],
    this.gap = 0,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.scrollable = false,
  })  : _mode = _FrameMode.flex,
        _axis = _FrameAxis.row,
        stackAlignment = AlignmentDirectional.topStart;

  /// Frame sobreposto (`Stack`). Filhos [DilettaPinned] viram `Positioned`;
  /// os demais ficam no `alignment` do stack.
  const DilettaFrame.stack({
    super.key,
    this.children = const [],
    this.stackAlignment = AlignmentDirectional.topStart,
    this.padding,
  })  : _mode = _FrameMode.stack,
        _axis = _FrameAxis.column,
        gap = 0,
        mainAxisAlignment = MainAxisAlignment.start,
        crossAxisAlignment = CrossAxisAlignment.stretch,
        mainAxisSize = MainAxisSize.max,
        scrollable = false;

  final List<Widget> children;

  /// Espaço entre filhos (modo flex). Use tokens: `DilettaSpacing.sN`.
  final double gap;

  /// Padding interno. Use tokens de espaçamento pra montar o `EdgeInsets`.
  final EdgeInsetsGeometry? padding;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  /// Rola na direção do eixo quando os filhos ultrapassam o espaço (modo flex).
  /// Ver as regras de validação em `DS_MONTAR_TELA.md` Parte 3.
  final bool scrollable;

  /// Alinhamento dos filhos não pinados (modo stack).
  final AlignmentGeometry stackAlignment;

  final _FrameMode _mode;
  final _FrameAxis _axis;

  @override
  Widget build(BuildContext context) {
    final Widget built =
        _mode == _FrameMode.stack ? _buildStack() : _buildFlex();

    final padded =
        padding == null ? built : Padding(padding: padding!, child: built);

    if (!DilettaDevMode.of(context)) return padded;
    return DilettaDevInfo(
      component: 'frame',
      props: {
        'mode': _mode == _FrameMode.stack ? 'stack' : 'flex',
        if (_mode == _FrameMode.flex)
          'direction': _axis == _FrameAxis.row ? 'row' : 'column',
        if (_mode == _FrameMode.flex && gap > 0) 'gap': '${gap.toInt()}px',
        if (scrollable) 'scrollable': 'true',
      },
      tokens: const [],
      child: padded,
    );
  }

  Widget _buildFlex() {
    final direction =
        _axis == _FrameAxis.row ? Axis.horizontal : Axis.vertical;

    // Num frame scrollável o eixo principal é ilimitado — o cross stretch e o
    // mainAxisSize.max não fazem sentido; encolhe pro conteúdo.
    final flex = Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment:
          scrollable ? CrossAxisAlignment.start : crossAxisAlignment,
      mainAxisSize: scrollable ? MainAxisSize.min : mainAxisSize,
      spacing: gap,
      children: children,
    );

    if (!scrollable) return flex;
    return SingleChildScrollView(scrollDirection: direction, child: flex);
  }

  Widget _buildStack() {
    return Stack(
      alignment: stackAlignment,
      children: [
        for (final child in children)
          child is DilettaPinned ? child._positioned() : child,
      ],
    );
  }
}

/// Fixa um filho numa ou mais bordas de um [DilettaFrame.stack] (vira
/// `Positioned`). `null` numa borda = não fixado nela. `respectSafeArea` soma a
/// área segura do dispositivo (status bar, notch, home indicator) nas bordas
/// fixadas, em vez de usar o offset cru.
class DilettaPinned extends StatelessWidget {
  const DilettaPinned({
    super.key,
    required this.child,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.respectSafeArea = false,
  });

  final Widget child;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final bool respectSafeArea;

  @override
  Widget build(BuildContext context) => child; // fora de um stack: transparente

  Widget _positioned() {
    final content = respectSafeArea
        ? SafeArea(
            top: top != null,
            bottom: bottom != null,
            left: left != null,
            right: right != null,
            child: child,
          )
        : child;
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: content,
    );
  }
}
