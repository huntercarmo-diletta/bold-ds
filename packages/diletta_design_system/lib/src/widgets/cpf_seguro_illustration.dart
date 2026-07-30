import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'cpf_seguro_assets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_palette.dart';

/// CPF SEGURO — Illustration token.
///
/// Cada ilustração é um **token semântico** (um NOME) com variantes de tema —
/// `Theme=Light`, `Theme=Dark` (e um futuro `Theme3`). O consumidor referencia
/// PELO NOME e o tema ativo escolhe a variante do asset. Isso facilita a troca
/// dark/light: o arquivo nunca é trocado na mão, o token resolve sozinho.
///
/// Convenção da pasta `assets/illustrations/`:
/// - com tema: `{base}_light.svg` + `{base}_dark.svg`
/// - sem tema: `{base}.svg`
///
/// Pra POPULAR: solte os SVGs seguindo a convenção e adicione UMA linha no
/// registry. O catálogo ainda tem poucas — a estrutura já suporta os pares.
class DilettaIllustration {
  const DilettaIllustration._(this.nome, this.base, {this.themed = true});

  /// Identificador do token — o nome pelo qual um catálogo, uma spec de tela ou um
  /// arquivo de handoff se referem a esta arte.
  ///
  /// Existe porque o catálogo montava o vocabulário dele à MÃO, e a lista drifou: metade
  /// das artes (16 de 32) não aparecia no compositor, e duas telas pediam ilustração que
  /// o vocabulário não tinha — renderizavam vazias, sem erro nenhum.
  ///
  /// A saída óbvia seria o filho derivar o nome de [base] convertendo `snake_case` pra
  /// `camelCase`. Medi: erra em dois casos (`phone-approach` usa hífen,
  /// `save_quick_on_boarding` viraria `saveQuickOnBoarding`). Identificador é DADO, não
  /// resultado de cirurgia de string — então o pai declara.
  final String nome;

  final String base;
  final bool themed;

  // ── Registry ──────────────────────────────────────────────────────────
  // Sem par de tema (asset único):
  static const fingerprint = DilettaIllustration._('fingerprint', 'fingerprint', themed: false);
  static const phoneApproach = DilettaIllustration._('phoneApproach', 'phone-approach', themed: false);
  static const saveQuickOnboarding = DilettaIllustration._('saveQuickOnboarding', 'save_quick_on_boarding', themed: false);
  static const sadFaceFlatline = DilettaIllustration._('sadFaceFlatline', 'sad_face_flatline', themed: false);
  static const securityPhoneFlat = DilettaIllustration._('securityPhoneFlat', 'security_phone_flat', themed: false);

  // Pares light/dark (trazidos do app real — assets/illustrations/{base}_{light|dark}.svg).
  static const authentication = DilettaIllustration._('authentication', 'authentication');
  static const config = DilettaIllustration._('config', 'config');
  static const dataAnalysis = DilettaIllustration._('dataAnalysis', 'data_analysis');
  static const fileNotFound = DilettaIllustration._('fileNotFound', 'file_not_found');
  static const graphics = DilettaIllustration._('graphics', 'graphics');
  static const internetOff = DilettaIllustration._('internetOff', 'internet_off');
  static const keyWord = DilettaIllustration._('keyWord', 'key_word');
  static const moneyJar = DilettaIllustration._('moneyJar', 'money_jar');
  static const noData = DilettaIllustration._('noData', 'no_data');
  static const noFile = DilettaIllustration._('noFile', 'no_file');
  static const noFileFlatline = DilettaIllustration._('noFileFlatline', 'no_file_flatline');
  static const noFileFound = DilettaIllustration._('noFileFound', 'no_file_found');
  static const onlinePayment = DilettaIllustration._('onlinePayment', 'online_payment');
  static const pageNotFound = DilettaIllustration._('pageNotFound', 'page_not_found');
  static const pageNotFoundFlat = DilettaIllustration._('pageNotFoundFlat', 'page_not_found_flat');
  static const pix = DilettaIllustration._('pix', 'pix');
  static const sadFace = DilettaIllustration._('sadFace', 'sad_face');
  static const search = DilettaIllustration._('search', 'search');
  static const searchEngine = DilettaIllustration._('searchEngine', 'search_engine');
  static const securityPhone = DilettaIllustration._('securityPhone', 'security_phone');
  static const success = DilettaIllustration._('success', 'success');
  static const successFlatline = DilettaIllustration._('successFlatline', 'success_flatline');
  static const timerWoman = DilettaIllustration._('timerWoman', 'timer_woman');
  static const unavailableFile = DilettaIllustration._('unavailableFile', 'unavailable_file');
  static const unavailableFileFlatline = DilettaIllustration._('unavailableFileFlatline', 'unavailable_file_flatline');
  static const unavailableState = DilettaIllustration._('unavailableState', 'unavailable_state');
  static const withFiles = DilettaIllustration._('withFiles', 'with_files');

  static const List<DilettaIllustration> all = [
    fingerprint,
    phoneApproach,
    saveQuickOnboarding,
    sadFaceFlatline,
    securityPhoneFlat,
    authentication,
    config,
    dataAnalysis,
    fileNotFound,
    graphics,
    internetOff,
    keyWord,
    moneyJar,
    noData,
    noFile,
    noFileFlatline,
    noFileFound,
    onlinePayment,
    pageNotFound,
    pageNotFoundFlat,
    pix,
    sadFace,
    search,
    searchEngine,
    securityPhone,
    success,
    successFlatline,
    timerWoman,
    unavailableFile,
    unavailableFileFlatline,
    unavailableState,
    withFiles,
  ];

  String assetPath({required bool isDark}) => themed
      ? 'assets/illustrations/${base}_${isDark ? 'dark' : 'light'}.svg'
      : 'assets/illustrations/$base.svg';
}

/// CPF SEGURO — recolor brand token-driven das ilustrações.
///
/// As artes foram desenhadas na família de azul **brand** do flavor CPF. Este
/// mapa liga cada hex baked ao step `primary` correspondente (snap ao mais
/// próximo, pois a arte tem 10 azuis e o scale primary ~5). Trocar o flavor =
/// apontar estes `primaryNN` pra paleta do flavor ativo — a arte recolore sem
/// tocar no asset. Cinzas/brancos (neutros) e salmão/amarelo (semânticos) NÃO
/// entram: cor de marca troca, erro/aviso e neutro são invariantes.
class DilettaIllustrationBrand {
  const DilettaIllustrationBrand._();

  static String _hx(Color c) {
    int ch(double v) => (v * 255).round().clamp(0, 255);
    String h(int v) => v.toRadixString(16).padLeft(2, '0');
    return '#${h(ch(c.r))}${h(ch(c.g))}${h(ch(c.b))}';
  }

  /// Hex BAKED no SVG → degrau equivalente da paleta ATIVA.
  ///
  /// As ilustrações vêm do Figma com o azul do CPF SEGURO cozido dentro do arquivo.
  /// Este mapa é o que faz elas virarem a cor de outra marca — então ele é função
  /// da PALETA, não uma tabela fixa.
  ///
  /// Era `static final` lendo `CpfSeguroColors`: qualquer filho recebia ilustração
  /// azul-CPF, e era o maior bolso de dívida que restava (10 de 12 leituras). A
  /// chave continua sendo o hex original do arquivo — é ele que existe no SVG.
  static Map<String, String> rampaDe(DilettaPalette p) => {
    '#002999': _hx(p.primary03),
    '#003be0': _hx(p.primary04),
    '#003de6': _hx(p.primary04),
    '#255df9': _hx(p.primary05),
    '#3369ff': _hx(p.primary05),
    '#2861ff': _hx(p.primary05),
    '#668fff': _hx(p.primary06),
    '#99b4ff': _hx(p.primary06),
    '#b8caff': _hx(p.primary07),
    '#ccdaff': _hx(p.primary07),
  };

  static final RegExp _colorRe = RegExp(r'(fill|stroke)="(#[0-9a-fA-F]{6})"');

  /// Aplica o recolor de marca sobre o SVG cru. Idempotente e barato
  /// (microssegundos): só troca hexes de marca conhecidos, resto passa direto.
  static String apply(String svg, DilettaPalette p) {
    final rampa = rampaDe(p);
    return svg.replaceAllMapped(_colorRe, (m) {
      final rep = rampa[m[2]!.toLowerCase()];
      return rep == null ? m[0]! : '${m[1]}="$rep"';
    });
  }
}

/// CPF SEGURO — tamanhos canônicos da ilustração (px).
///
/// O accessory **só dimensiona** — e só nestes degraus. Sem `double` livre: a
/// escala é fixa (consistência > flexibilidade), igual em espírito à escala do
/// [DilettaIconAccessory]. `sm` empty-state compacto, `xl` hero de tela cheia.
enum DilettaIllustrationSize {
  sm(100),
  md(200),
  lg(300),
  xl(400);

  const DilettaIllustrationSize(this.px);

  /// Lado do quadrado em px.
  final double px;
}

/// CPF SEGURO — IllustrationAccessory (átomo STANDALONE).
///
/// Análogo do [DilettaIconAccessory]: a **ilustração pura é o token**
/// ([DilettaIllustration] — um NOME, resolve tema sozinho) e este átomo
/// apenas a **dimensiona**. Por encapsular, tem acesso a TODAS as ilustrações
/// do registry — não existe escape hatch de asset cru; se falta uma arte,
/// adiciona-se o token, não se passa um caminho solto.
///
/// Internamente carrega o SVG multi-cor e **recolore a família de marca por
/// token** ([DilettaIllustrationBrand]) — trocar o flavor recolore a arte sem
/// trocar asset; neutros/semânticos ficam intactos. Load cacheado
/// (`DilettaAssets`) + `SvgPicture.string`.
///
/// ```dart
/// DilettaIllustrationAccessory(illustration: DilettaIllustration.fingerprint),          // lg (300)
/// DilettaIllustrationAccessory(illustration: DilettaIllustration.pix, size: DilettaIllustrationSize.sm),
/// ```
class DilettaIllustrationAccessory extends StatefulWidget {
  const DilettaIllustrationAccessory({
    super.key,
    required this.illustration,
    this.size = DilettaIllustrationSize.lg,
  });

  /// Token da ilustração (obrigatório — o átomo consome, não cria).
  final DilettaIllustration illustration;

  /// Único knob: qual degrau canônico dimensionar.
  final DilettaIllustrationSize size;

  @override
  State<DilettaIllustrationAccessory> createState() =>
      _CpsIllustrationState();
}

class _CpsIllustrationState extends State<DilettaIllustrationAccessory> {
  String? _asset;
  String? _svg;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tema = DilettaTheme.of(context);
    final isDark = tema.scheme.isDark;
    final asset = widget.illustration.assetPath(isDark: isDark);
    if (asset == _asset) return;
    _asset = asset;

    // Recolor de marca é sync/barato; o load (via resolver com fallback
    // packages/) é a única parte async e é cacheado em DilettaAssets.
    final cachedRaw = DilettaAssets.cachedSvg(asset);
    if (cachedRaw != null) {
      _svg = DilettaIllustrationBrand.apply(cachedRaw, tema.palette);
      return;
    }
    _svg = null;
    DilettaAssets.loadSvg(DefaultAssetBundle.of(context), asset).then((raw) {
      if (!mounted || _asset != asset) return;
      setState(() => _svg = DilettaIllustrationBrand.apply(raw, tema.palette));
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.illustration.base;
    final px = widget.size.px;
    return DilettaDevInfo(
      component: 'DilettaIllustrationAccessory',
      props: {'name': label, 'size': widget.size.name},
      tokens: [
        widget.illustration.themed
            ? 'asset: ${label}_{light|dark}.svg (tema resolve)'
            : 'asset: $label.svg',
        'brand recolor: primary token-driven',
      ],
      child: _svg == null
          ? _Placeholder(size: px)
          : SvgPicture.string(
              _svg!,
              width: px,
              height: px,
              placeholderBuilder: (_) => _Placeholder(size: px),
            ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DilettaTheme.schemeOf(context).surfaceSubtle,
        borderRadius: DilettaRadius.all8,
      ),
      child: Text('?',
          style: DilettaType.caption.copyWith(color: DilettaTheme.schemeOf(context).textMuted)),
    );
  }
}
