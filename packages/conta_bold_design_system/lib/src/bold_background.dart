/// CONTA BOLD — o BACKDROP das telas, e o componente mais usado do produto.
///
/// 114 chamadas no app antigo, contra 9 do segundo colocado. Ele é o que faz o vidro do Bold
/// parecer vidro: sem algo atrás, `BackdropFilter` desfoca o nada.
///
/// ## O que mudou na adaptação, e por quê
///
/// **1 · A arte deixou de morar aqui.** A versão antiga cravava `assets/images/bg_city_*.jpg`
/// dentro do widget — caminho de asset do APP dentro do DS. Isso faz o componente não renderizar
/// fora do app: o catálogo mostraria um retângulo vazio, e outro consumidor teria que replicar a
/// pasta. Agora a arte entra pelo [BoldBackdropScope], que o app já declara uma vez.
///
/// Sem arte declarada, o backdrop de imagem **degrada** pro fundo do tema com o brilho da marca
/// em vez de quebrar — é o mesmo desenho que o pai usa pra marca ausente (um filho sem logo
/// simplesmente não desenha o logo).
///
/// **2 · Quatro literais de cor viraram um.** Os brilhos eram `#FE3976`, `#FE7B5E`, `#FEED35` e
/// `#7B3FF2` cravados. Os três primeiros são rampa: rosa é `primary04`, e coral e amarelo saem
/// de `warning03`/`warning04` — a mesma modulação que os gradientes levaram, e pelo mesmo motivo
/// (valor fora da paleta é valor que o rebrand não alcança).
///
/// **E o quarto morreu também.** O violeta `#7B3FF2` sustentava os dois moods frios e não
/// pertencia a rampa nenhuma deste produto. O dono do produto resolveu com o VINHO, que faz o
/// mesmo trabalho — dar um polo frio e profundo contra o rosa — com cor que é da marca. Então
/// este componente passou a ter **zero** valor de cor solto: tudo sai da paleta ou de
/// [BoldVinho].
///
/// **3 · Os sete moods continuam sete.** Medi antes de cortar: `BoldBackdrop.values` alimenta a
/// tela de personalização, então os cinco de gradiente são FEATURE (o usuário escolhe o fundo), e
/// não código morto como foram os sete gradientes. O uso confirma: `solid` 54 referências,
/// `image` 10, os cinco moods 11.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'bold_palette.dart';
import 'bold_vinho.dart';

/// Os sete fundos que o produto oferece.
///
/// Enum FECHADO e `switch` exaustivo sem `_ =>` de propósito (exigência 7 do contrato de
/// componente): com o default genérico, um valor novo se disfarçaria de valor antigo e o fundo
/// errado apareceria em silêncio. Sem ele, o compilador aponta o lugar exato que falta tratar.
enum BoldBackdrop {
  /// Arte de fundo + véu + brilho da marca. O mais literalmente "vidro". É o default.
  imagem,

  /// Cor sólida plana + brilho sutil — os FLUXOS SECUNDÁRIOS (telas empurradas). O mais usado.
  solido,

  /// Um brilho rosa sobre base limpa. Mínimo.
  brilhoRosa,

  /// Vinho + rosa. Mais frio, e o vinho é o polo profundo da marca.
  vidroFrio,

  /// Rosa + laranja + vinho. Vívido, usa os dois eixos da marca.
  aurora,

  /// O pôr do sol da marca sangrando de um canto. Quente — e depois da modulação dos gradientes,
  /// é o mood que carrega o que era o gradiente de três paradas.
  porDoSol,

  /// Grade técnica sutil + brilho rosa.
  gradeTech,
}

/// Carrega, pela árvore, o fundo escolhido e a ARTE que o desenha.
///
/// O app declara uma vez (é o que ele já fazia com o estilo); o DS não sabe onde a arte mora,
/// só que ela existe ou não.
class BoldBackdropScope extends InheritedWidget {
  const BoldBackdropScope({
    super.key,
    this.estilo,
    this.arteClara,
    this.arteEscura,
    required super.child,
  });

  /// O fundo escolhido pela pessoa. **Nulo enquanto ela nunca escolheu** — e a diferença
  /// importa: nulo deixa o default da tela valer, e um valor VENCE o default da tela.
  final BoldBackdrop? estilo;

  /// A arte de cada modo. `null` ⇒ o fundo de imagem degrada pro fundo do tema com brilho, em
  /// vez de mostrar um retângulo vazio.
  final ImageProvider? arteClara;
  final ImageProvider? arteEscura;

  static BoldBackdropScope? of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<BoldBackdropScope>();

  @override
  bool updateShouldNotify(BoldBackdropScope old) =>
      old.estilo != estilo ||
      old.arteClara != arteClara ||
      old.arteEscura != arteEscura;
}

/// O backdrop. Envolve o corpo de uma tela.
///
/// ```dart
/// BoldBackground(child: conteudo)                              // segue a personalização
/// BoldBackground(estilo: BoldBackdrop.solido, child: conteudo)  // default da tela
/// BoldBackground.amostra(estilo: BoldBackdrop.aurora, child: …) // ESTE mood, sempre
/// ```
class BoldBackground extends StatelessWidget {
  const BoldBackground({super.key, required this.child, this.estilo})
      : amostra = false;

  /// AMOSTRA de um mood: desenha o [estilo] pedido e ignora a escolha da pessoa.
  ///
  /// Existe porque a regra "a escolha vence o default da tela" está certa pra TELA e errada pro
  /// SELETOR: a tela de Aparência desenha as cinco opções com `BoldBackground(estilo: cada uma)`, e
  /// como a escolha vencia, **as cinco amostras mostravam o fundo já escolhido**. Escolher outro
  /// mudava as cinco juntas — um seletor em que toda opção parece igual à atual.
  ///
  /// Visto no app, não medido aqui: nenhum teste falha quando cinco amostras concordam.
  const BoldBackground.amostra({super.key, required this.child, required BoldBackdrop this.estilo})
      : amostra = true;

  final Widget child;

  /// `null` ⇒ resolve pelo [BoldBackdropScope]; sem scope, cai em [BoldBackdrop.imagem]. Passar
  /// valor explícito é pra tela que precisa declarar o próprio default.
  final BoldBackdrop? estilo;

  /// `true` ⇒ o [estilo] declarado ganha da escolha da pessoa. Só amostra de seletor.
  final bool amostra;

  /// O véu sobre a arte. Claro: branco a 20% — a arte é diurna e o ink escuro precisa ler por
  /// cima. Escuro: preto a 8%, porque a arte noturna já é escura.
  ///
  /// Alpha de branco e de preto não é identidade (é ausência e presença de luz), então não é
  /// dívida de paleta — é a mesma leitura que o pai faz dos alphas dele.
  static Color _veu(DilettaScheme s) => s.isDark
      ? BoldPalette.bold.black.withValues(alpha: 0.08)
      : BoldPalette.bold.white.withValues(alpha: 0.20);

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final scope = BoldBackdropScope.of(context);
    // A ESCOLHA DA PESSOA VENCE O DEFAULT DA TELA, e a ordem inversa é um defeito medido no
    // app: com `estilo ?? scope`, toda tela que declara o próprio fundo ignora a
    // personalização — na Área Pix isso virou o item 72 do QA, porque o hub declarava
    // `solido` e o fundo escolhido em Aparência não aparecia.
    //
    // `scope.estilo` é nulo enquanto ninguém personalizou; aí o default da tela vale, que é
    // o comportamento que a tela espera.
    //
    // A AMOSTRA inverte a precedência de propósito, e é o único caso: ela não é uma tela sob a
    // personalização, ela é o retrato de um mood ao lado dos outros quatro.
    final fundo =
        amostra ? estilo! : (scope?.estilo ?? estilo ?? BoldBackdrop.imagem);

    // No claro, mood de gradiente e sólido ganham base `primary08`: sobre o quase-branco do tema
    // os brilhos desbotavam e mesclavam com o conteúdo.
    final ehMood = fundo != BoldBackdrop.imagem && fundo != BoldBackdrop.solido;
    // O `_ =>` aqui é o único deste pacote, e ele é seguro POR CONSTRUÇÃO — não por descuido. A
    // auditoria de arquitetura cobra `_ =>` porque tipo novo se disfarça de tipo antigo; aqui um estilo
    // novo cai no ramo de mood, e `ehMood` o classifica por EXCLUSÃO (`!= imagem && != solido`), que é
    // o tratamento certo pra qualquer mood futuro. Escrever os sete casos duplicaria a mesma expressão
    // seis vezes, e aí o risco passa a ser esquecer de mudar uma delas.
    final base = switch (fundo) {
      BoldBackdrop.solido =>
        s.isDark ? BoldPalette.bold.bgEscuro! : BoldPalette.bold.primary08,
      _ => !s.isDark && ehMood ? BoldPalette.bold.primary08 : s.bg,
    };

    return DilettaDevInfo(
      component: 'background',
      props: {
        'estilo': fundo.name,
        'arte': scope?.arteClara == null ? 'ausente' : 'declarada',
      },
      tokens: [
        fundo == BoldBackdrop.solido ? 'palette.bgEscuro' : 'scheme.bg',
        if (ehMood) 'palette.primary08',
      ],
      child: ColoredBox(
        color: base,
        child: Stack(children: [..._camadas(s, fundo, scope), child]),
      ),
    );
  }

  List<Widget> _camadas(
      DilettaScheme s, BoldBackdrop fundo, BoldBackdropScope? scope) {
    final p = BoldPalette.bold;

    // Saturação dos brilhos. No claro SOBE **só onde a base é `primary08`** — que é o caso dos moods:
    // sobre aquele rosa quase-branco os brilhos mesclavam com o conteúdo e precisavam de corpo.
    //
    // O `imagem` NÃO tem essa base: ele assenta na arte. Aplicar o mesmo +30% ali é reforçar rosa sobre
    // uma foto que já tem a cor toda — e foi o que o dono do produto viu no claro, *"o rosa do degradê
    // tá muito forte, tem que ficar mais clarinho"*, com o brilho de topo pintando por cima do skyline.
    //
    // A condição é a MESMA que decide a base, lá no `build`: no claro, mood **e sólido** assentam em
    // `primary08`; só o `imagem` assenta na arte. Ela estava escrita no comentário e não na expressão —
    // `s.isDark ? 1.0 : 1.3` boostava os sete estilos por causa da razão de seis.
    final k = (!s.isDark && fundo != BoldBackdrop.imagem) ? 1.3 : 1.0;

    return switch (fundo) {
      BoldBackdrop.imagem => _camadasDeArte(s, scope),
      BoldBackdrop.solido => [
          _brilho(const Alignment(0, -1), 1.0, p.primary04.withValues(alpha: 0.10 * k)),
        ],
      BoldBackdrop.brilhoRosa => [
          _brilho(const Alignment(0, -1), 1.15, p.primary04.withValues(alpha: 0.34 * k)),
        ],
      BoldBackdrop.vidroFrio => [
          _brilho(const Alignment(-0.5, -1), 1.2,
              BoldVinho.marca.withValues(alpha: 0.34 * k)),
          _brilho(const Alignment(0.95, -0.6), 1.0,
              p.primary04.withValues(alpha: 0.30 * k)),
        ],
      BoldBackdrop.aurora => [
          _brilho(const Alignment(-0.7, -0.8), 0.9,
              p.primary04.withValues(alpha: 0.32 * k)),
          _brilho(const Alignment(0.85, -0.9), 0.85,
              p.warning03.withValues(alpha: 0.30 * k)),
          _brilho(const Alignment(0.5, 0.95), 1.0,
              BoldVinho.marca.withValues(alpha: 0.32 * k)),
        ],
      BoldBackdrop.porDoSol => [
          _brilho(const Alignment(1, -1), 1.1, p.warning04.withValues(alpha: 0.22 * k)),
          _brilho(const Alignment(0.7, -0.85), 0.9,
              p.warning03.withValues(alpha: 0.26 * k)),
          _brilho(const Alignment(-1, 1), 1.0, p.primary04.withValues(alpha: 0.30 * k)),
        ],
      BoldBackdrop.gradeTech => [
          Positioned.fill(
            child: CustomPaint(
              painter: _Grade(s.border.withValues(alpha: s.isDark ? 0.6 : 1)),
            ),
          ),
          _brilho(const Alignment(0, -1), 1.1, p.primary04.withValues(alpha: 0.32 * k)),
        ],
    };
  }

  /// A arte do modo atual, com o véu por cima. Sem arte declarada, cai no brilho de marca — o
  /// fundo fica pobre e a tela funciona, que é a degradação certa.
  List<Widget> _camadasDeArte(DilettaScheme s, BoldBackdropScope? scope) {
    final arte = s.isDark ? scope?.arteEscura : scope?.arteClara;
    if (arte == null) {
      return [
        _brilho(const Alignment(0, -1), 1.15,
            BoldPalette.bold.primary04.withValues(alpha: s.isDark ? 0.22 : 0.28)),
      ];
    }
    return [
      Positioned.fill(
        child: Image(
          image: arte,
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
          // A arte costuma vir no tamanho LÓGICO da tela; num aparelho 3x isso é upscale de 3×,
          // e o bilinear padrão vira ruído na borda dos prédios. Cúbico segura melhor.
          // Atenua, não resolve: interpolação não inventa detalhe.
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
      Positioned.fill(child: ColoredBox(color: _veu(s))),
    ];
  }

  Widget _brilho(Alignment centro, double escala, Color cor) => Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: centro,
              radius: escala,
              colors: [cor, cor.withValues(alpha: 0)],
            ),
          ),
        ),
      );

  /// Repinta o backdrop recortado à faixa da status bar, pra mascarar o conteúdo que rola por
  /// baixo do notch. Segue o fundo escolhido, então a pintura bate com o que está atrás mesmo
  /// quando o usuário troca de fundo na personalização.
  static Widget veuDaStatusBar(BuildContext context) {
    final altura = MediaQuery.sizeOf(context).height;
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: altura,
        maxHeight: altura,
        child: const BoldBackground(child: SizedBox.expand()),
      ),
    );
  }
}

class _Grade extends CustomPainter {
  const _Grade(this.cor);

  final Color cor;

  /// Passo da grade. Único número geométrico do componente, e ele é a arte — não é espaçamento
  /// de layout, então não sai da escala de spacing.
  static const double _passo = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final tinta = Paint()
      ..color = cor
      ..strokeWidth = 0.5;
    for (var x = 0.0; x < size.width; x += _passo) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), tinta);
    }
    for (var y = 0.0; y < size.height; y += _passo) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), tinta);
    }
  }

  @override
  bool shouldRepaint(_Grade old) => old.cor != cor;
}
