import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/diletta_absolute_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_palette.dart';

/// CPF SEGURO — Dev Inspect (infra de handoff, estilo Figma dev mode).
///
/// Com o [DilettaDevMode] habilitado, todo widget do DS embrulhado em
/// [DilettaDevInfo] ganha hover: outline primary no componente + painel
/// escuro seguindo o cursor com TUDO que o dev precisa pra reproduzir —
/// nome do component, props, tokens de cor/typo/radius e icons.
///
/// Quando componentes se aninham (Icon dentro de Button dentro de Banner),
/// o MAIS INTERNO vence — decidido pela profundidade do RenderObject.
class DilettaDevMode extends InheritedWidget {
  const DilettaDevMode({super.key, required this.enabled, required super.child});

  final bool enabled;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DilettaDevMode>()?.enabled ?? false;

  @override
  bool updateShouldNotify(DilettaDevMode old) => old.enabled != enabled;
}

/// Nome do token de cor pra um [Color] — DERIVADO da paleta ativa.
///
/// O inspetor mostra "primary-04" em vez de "#003BE0", e é o que faz a ferramenta
/// ensinar o vocabulário em vez de só exibir cor.
///
/// ## Era um mapa escrito à mão, e ele JÁ tinha mentido
///
/// A versão anterior era `const Map<int, String>` com os hexes do CPF SEGURO
/// cravados — 30 linhas mantidas na mão, ao lado de uma paleta que muda. Duas
/// consequências, e as duas aconteceram:
///
/// 1. **valor de filho dentro do pai**: qualquer outro filho veria o inspetor
///    chamando as cores dele de "não sei" enquanto reconhecia as do CPF;
/// 2. **divergência silenciosa**: o mapa dizia que `neutral-04` era `#8F8F8F`, e
///    `neutral04` é `#808080`. Alguém mudou a paleta e o inspetor continuou
///    ensinando o valor antigo. Ninguém tinha como notar: é texto de debug.
///
/// Agora o mapa é o INVERSO da paleta que está no tema. Não tem como divergir, e
/// funciona pra qualquer filho.
String nomeDoToken(BuildContext context, Color? c) =>
    nomeDoTokenNaPaleta(DilettaTheme.of(context).palette, c);

/// Versão sem `context`, pra quem já tem a paleta na mão.
String nomeDoTokenNaPaleta(DilettaPalette p, Color? c) {
  if (c == null) return 'herdada';
  final nome = _reverso(p)[c.toARGB32()];
  if (nome != null) return nome;
  return '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
}

/// Cacheado por `palette.id`: o inverso é estável por paleta, e o inspetor chama
/// isto a cada `build` de componente com dev mode ligado.
final Map<String, Map<int, String>> _reversoCache = {};

Map<int, String> _reverso(DilettaPalette p) => _reversoCache[p.id] ??= {
      for (final e in <String, Color>{
        'primary-01': p.primary01, 'primary-02': p.primary02,
        'primary-03': p.primary03, 'primary-04': p.primary04,
        'primary-05': p.primary05, 'primary-06': p.primary06,
        'primary-07': p.primary07, 'primary-08': p.primary08,
        'primary-09': p.primary09, 'primary-selected': p.primaryStateSelected,
        'primary-hover': p.primaryStateHover, 'on-primary': p.onPrimary,
        'partner-primary': p.partnerPrimary, 'partner-on-primary': p.partnerOnPrimary,
        'partner-surface': p.partnerSurface,
        'neutral-01': p.neutral01, 'neutral-02': p.neutral02,
        'neutral-03': p.neutral03, 'neutral-04': p.neutral04,
        'neutral-05': p.neutral05, 'neutral-06': p.neutral06,
        'neutral-07': p.neutral07, 'neutral-08': p.neutral08,
        'neutral-09': p.neutral09, 'neutral-10': p.neutral10,
        'error-01': p.error01, 'error-02': p.error02, 'error-03': p.error03,
        'error-04': p.error04, 'error-05': p.error05, 'error-06': p.error06,
        'error-07': p.error07, 'error-banner': p.errorBanner,
        'warning-01': p.warning01, 'warning-02': p.warning02,
        'warning-03': p.warning03, 'warning-04': p.warning04,
        'warning-05': p.warning05, 'warning-06': p.warning06,
        'warning-07': p.warning07,
        'success-01': p.success01, 'success-02': p.success02,
        'success-03': p.success03, 'success-04': p.success04,
        'success-05': p.success05, 'success-06': p.success06,
        'success-07': p.success07,
        'secure-02': p.secure02, 'secure-03': p.secure03, 'secure-04': p.secure04,
        'secure-05': p.secure05, 'secure-07': p.secure07, 'secure-08': p.secure08,
        // Absolutos: do pai, iguais em todo filho.
        'white': DilettaAbsoluteColors.white,
        'black': DilettaAbsoluteColors.black,
        'transparent': DilettaAbsoluteColors.transparent,
      }.entries)
        e.value.toARGB32(): e.key,
    };

class _Candidate {
  _Candidate({required this.id, required this.depth, required this.component, required this.props, required this.tokens});
  final int id;
  final int depth;
  final String component;
  final Map<String, String> props;
  final List<String> tokens;
}

/// Controller global — mantém os candidatos sob o cursor e mostra o painel
/// do mais profundo (mais interno) num OverlayEntry que segue o mouse.
class _Inspector {
  static final Map<int, _Candidate> _candidates = {};
  static final ValueNotifier<int?> topId = ValueNotifier<int?>(null);
  static OverlayEntry? _entry;
  static Offset _cursor = Offset.zero;

  static void enter(BuildContext context, _Candidate c) {
    _candidates[c.id] = c;
    _refresh(context);
  }

  static void move(Offset globalPos) {
    _cursor = globalPos;
    _entry?.markNeedsBuild();
  }

  static void exit(BuildContext context, int id) {
    _candidates.remove(id);
    _refresh(context);
  }

  static void _refresh(BuildContext context) {
    if (_candidates.isEmpty) {
      topId.value = null;
      _entry?.remove();
      _entry = null;
      return;
    }
    final top = _candidates.values.reduce((a, b) => a.depth >= b.depth ? a : b);
    topId.value = top.id;
    if (_entry == null) {
      _entry = OverlayEntry(builder: (_) => _panel());
      Overlay.of(context, rootOverlay: true).insert(_entry!);
    } else {
      _entry!.markNeedsBuild();
    }
  }

  static Widget _panel() {
    final id = topId.value;
    final c = id == null ? null : _candidates[id];
    if (c == null) return const SizedBox.shrink();
    return Positioned(
      left: _cursor.dx + 16,
      top: _cursor.dy + 16,
      child: IgnorePointer(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(DilettaSpacing.s3),
          decoration: BoxDecoration(
            color: DilettaAbsoluteColors.debugSurface,
            borderRadius: DilettaRadius.all8,
            boxShadow: DilettaElevation.overlayLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                c.component,
                style: const TextStyle(
                  color: DilettaAbsoluteColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              for (final e in c.props.entries)
                Text(
                  '${e.key}: ${e.value}',
                  style: const TextStyle(
                    color: DilettaAbsoluteColors.debugMuted,
                    fontSize: 11,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              if (c.tokens.isNotEmpty) ...[
                const SizedBox(height: 6),
                for (final t in c.tokens)
                  Text(
                    '· $t',
                    style: const TextStyle(
                      color: DilettaAbsoluteColors.debugAccent,
                      fontSize: 11,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Embrulha um widget do DS com metadata de inspeção. Sem dev mode, é
/// transparente (retorna o child direto).
class DilettaDevInfo extends StatefulWidget {
  const DilettaDevInfo({
    super.key,
    required this.component,
    this.props = const {},
    this.tokens = const [],
    required this.child,
  });

  final String component;
  final Map<String, String> props;
  final List<String> tokens;
  final Widget child;

  @override
  State<DilettaDevInfo> createState() => _CpfSeguroDevInfoState();
}

class _CpfSeguroDevInfoState extends State<DilettaDevInfo> {
  static int _nextId = 0;
  final int _id = _nextId++;
  bool _inside = false;

  @override
  void deactivate() {
    if (_inside) {
      _Inspector.exit(context, _id);
      _inside = false;
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (!DilettaDevMode.of(context)) return widget.child;

    return MouseRegion(
      onEnter: (e) {
        _inside = true;
        _Inspector.move(e.position);
        _Inspector.enter(
          context,
          _Candidate(
            id: _id,
            depth: (context as Element).depth,
            component: widget.component,
            props: widget.props,
            tokens: widget.tokens,
          ),
        );
      },
      onHover: (e) => _Inspector.move(e.position),
      onExit: (_) {
        _inside = false;
        _Inspector.exit(context, _id);
      },
      child: ValueListenableBuilder<int?>(
        valueListenable: _Inspector.topId,
        builder: (_, top, __) => Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            if (top == _id)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: DilettaAbsoluteColors.debugAccent, width: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Nome do preset de tipografia do DS pra um [TextStyle] — match por
/// fontSize + fontWeight (fallback = "custom Npx/weight"). Usado pelo
/// [DilettaText] pra o dev saber EXATAMENTE qual estilo reproduzir.
String cpfSeguroTypeToken(TextStyle? s) {
  if (s == null) return 'herdada';
  const presets = <(String, double, int)>[
    ('displayLg', 57, 400), ('displayMd', 45, 400), ('displaySm', 36, 400),
    ('headlineLg', 32, 400), ('headlineMd', 28, 400), ('headlineSm', 24, 400),
    ('headline', 22, 600), ('titleLg', 22, 500),
    ('chatCompletionTitle', 26, 600),
    ('titleMd', 16, 500), ('bodyLg', 16, 400),
    ('labelLg', 14, 600), ('titleSm', 14, 500), ('bodyMd', 14, 400), ('body', 14, 400),
    ('chatButtonLabel', 15, 600),
    ('chatBubble', 13, 700),
    ('labelMd', 12, 500), ('bodySm', 12, 400),
    ('eyebrow', 11, 600), ('labelSm', 11, 500),
  ];
  final size = s.fontSize;
  // `.index` está depreciado; `.value` é o peso real (100..900) e dispensa a conta.
    final w = s.fontWeight?.value;
  for (final (name, ps, pw) in presets) {
    if (size == ps && w == pw) return name;
  }
  final wStr = w == null ? '' : '/$w';
  return size == null ? 'custom' : 'custom ${size.toInt()}px$wStr';
}
