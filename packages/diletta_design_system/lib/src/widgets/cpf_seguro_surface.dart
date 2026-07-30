import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';

/// CPF SEGURO — Surface.
///
/// O primitivo de composição da **gramática** do DS: toda superfície (screen,
/// modal, bottomsheet) se monta navegando por três regiões —
/// **top · content · bottom**.
///
/// - `top` — barra superior (ex: [DilettaTopAppBar] / NavigationTopBar).
/// - `content` — região principal, rolável por default.
/// - `bottom` — slot inferior (ex: [DilettaBottomApp]: nav, botão, teclado…).
///
/// Não é a raiz do sistema — é um primitivo (cobre ~80-90% das telas). Layouts
/// que fogem de 3 fatias (hero full-bleed, split, web com side-nav) usam outros
/// primitivos. Ver `DS_LANGUAGE.md` §2.
///
/// ## Glass-scroll (variante padrão)
///
/// Na variante padrão o `content` é **edge-to-edge** e **rola por trás do
/// glass** do top bar e do bottom bar (assinatura CPF, herdada do app real
/// `GlassScreenScaffold`). Internamente é um [Stack]: o conteúdo ocupa a tela
/// inteira num scroll com padding = `contentPadding` **+ altura do `top` no
/// topo + altura do `bottom` embaixo**, e as barras ficam sobrepostas fixas
/// (`Positioned`). No estado default a tela parece igual (conteúdo entre as
/// barras); a diferença é que agora ele desliza por baixo do glass em vez de
/// ficar clipado numa faixa do meio.
///
/// A `.sheet` **não** usa glass-scroll: é opaca, curta e mantém o layout em
/// [Column] com cantos arredondados.
///
/// ```dart
/// DilettaSurface(
///   top: DilettaTopAppBar.defaultVariant(navBar: nav),
///   content: DilettaFrame.column(children: [...]),
///   bottom: DilettaBottomApp.button(button: cta),
/// )
///
/// // sheet: mesma gramática, cantos arredondados, sobre surface
/// DilettaSurface.sheet(
///   top: DilettaTopAppBar.bottomsheet(navBar: nav),
///   content: DilettaFrame.column(children: [...]),
///   bottom: DilettaBottomApp.button(button: cta),
/// )
/// ```
///
/// O `content`/`top`/`bottom` são slots de composição (aceitam qualquer widget),
/// mas o idiomático é montar o `content` com [DilettaFrame], não `Column` cru.
///
/// **Requisito:** tela com CAMPO ([DilettaInput], [DilettaOtpInput],
/// [DilettaSearchInput]) precisa de ancestral `Material` — a Surface não
/// fornece. Na prática o app já satisfaz (`Scaffold(body: DilettaSurface(...))`);
/// só quebra se alguém pendurar a Surface direto no `MaterialApp.home`.

/// Fundo da [DilettaSurface], por token de tema (não `Decoration` cru).
/// `null` = automático: `screen` na variante padrão, `surface` na `.sheet`.
enum DilettaSurfaceBackground { screen, surface }

class DilettaSurface extends StatefulWidget {
  const DilettaSurface({
    super.key,
    this.top,
    required this.content,
    this.bottom,
    this.scrollableContent = true,
    this.contentPaddingH,
    this.contentPaddingV,
    this.background,
  }) : _sheet = false;

  /// Superfície de sheet/modal: cantos superiores arredondados (r24) e fundo
  /// sólido de surface (sem gradient de tela).
  const DilettaSurface.sheet({
    super.key,
    this.top,
    required this.content,
    this.bottom,
    this.scrollableContent = true,
    this.contentPaddingH,
    this.contentPaddingV,
    this.background,
  }) : _sheet = true;

  /// Região superior. Omitir = sem top.
  final Widget? top;

  /// Região principal.
  final Widget content;

  /// Região inferior. Omitir = sem bottom.
  final Widget? bottom;

  /// Content rolável (default true). False = content estático (o próprio
  /// widget controla o layout).
  final bool scrollableContent;

  /// Padding horizontal do content, por token de espaçamento. Default s6.
  final double? contentPaddingH;

  /// Padding vertical do content, por token de espaçamento. Default s4.
  final double? contentPaddingV;

  /// Fundo, por token de tema (não `Decoration` cru). `null` = automático
  /// (screen na variante padrão; surface na `.sheet`).
  final DilettaSurfaceBackground? background;

  final bool _sheet;

  @override
  State<DilettaSurface> createState() => _CpfSeguroSurfaceState();
}

class _CpfSeguroSurfaceState extends State<DilettaSurface> {
  /// Alturas medidas das barras (topo/base), usadas como inset do conteúdo
  /// pra ele nascer entre as barras e rolar por trás do glass. Fallback 0 até
  /// o primeiro frame medir.
  double _topInset = 0;
  double _bottomInset = 0;

  void _setTopInset(double h) {
    if (!mounted || _topInset == h) return;
    setState(() => _topInset = h);
  }

  void _setBottomInset(double h) {
    if (!mounted || _bottomInset == h) return;
    setState(() => _bottomInset = h);
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final pad = EdgeInsets.symmetric(
      horizontal: widget.contentPaddingH ?? DilettaSpacing.s6,
      vertical: widget.contentPaddingV ?? DilettaSpacing.s4,
    );

    final bg = widget.background ??
        (widget._sheet
            ? DilettaSurfaceBackground.surface
            : DilettaSurfaceBackground.screen);
    final decoration = switch (bg) {
      DilettaSurfaceBackground.surface => BoxDecoration(color: s.surface),
      DilettaSurfaceBackground.screen => s.isDark
          ? BoxDecoration(color: s.bg)
          : BoxDecoration(gradient: DilettaGradients.screenBgDe(s.palette)),
    };

    // .sheet — preserva o layout antigo (Column, opaco, cantos arredondados).
    if (widget._sheet) {
      final middle = widget.scrollableContent
          ? SingleChildScrollView(padding: pad, child: widget.content)
          : Padding(padding: pad, child: widget.content);

      Widget column = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.top != null) widget.top!,
          Expanded(child: middle),
          if (widget.bottom != null) widget.bottom!,
        ],
      );

      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: DecoratedBox(decoration: decoration, child: column),
      );
    }

    // Variante padrão — glass-scroll: conteúdo edge-to-edge que rola por trás
    // das barras. Padding = contentPadding + insets medidos das barras.
    final contentPad = EdgeInsets.fromLTRB(
      pad.left,
      pad.top + _topInset,
      pad.right,
      pad.bottom + _bottomInset,
    );

    final contentLayer = widget.scrollableContent
        ? SingleChildScrollView(padding: contentPad, child: widget.content)
        : Padding(padding: contentPad, child: widget.content);

    final stack = Stack(
      children: [
        // Fundo: conteúdo ocupando a tela inteira, rolando atrás do glass.
        Positioned.fill(child: contentLayer),
        // Overlay topo — barra fixa (glass) sobre o conteúdo.
        if (widget.top != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _MeasureSize(onChange: (size) => _setTopInset(size.height), child: widget.top!),
          ),
        // Overlay base — barra fixa (glass) sobre o conteúdo.
        if (widget.bottom != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _MeasureSize(onChange: (size) => _setBottomInset(size.height), child: widget.bottom!),
          ),
      ],
    );

    return DecoratedBox(decoration: decoration, child: stack);
  }
}

typedef _OnSizeChange = void Function(Size size);

/// Mede a altura do `child` e reporta via [onChange] após o layout, sem alterar
/// o tamanho renderizado. Usado pra descobrir a altura das barras (top/bottom)
/// e transformá-la em inset de padding do conteúdo.
class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required Widget super.child});

  final _OnSizeChange onChange;

  @override
  RenderObject createRenderObject(BuildContext context) => _MeasureSizeRender(onChange);

  @override
  void updateRenderObject(BuildContext context, _MeasureSizeRender renderObject) {
    renderObject.onChange = onChange;
  }
}

class _MeasureSizeRender extends RenderProxyBox {
  _MeasureSizeRender(this.onChange);

  _OnSizeChange onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? Size.zero;
    if (_oldSize == newSize) return;
    _oldSize = newSize;
    // Reportar fora do layout: setState durante o layout é proibido.
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}
