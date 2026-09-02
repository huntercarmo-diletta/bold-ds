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
/// pasta. Agora a arte entra pelo [CoreflowBackdropScope], que o app já declara uma vez.
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
/// **3 · Os sete moods continuam sete.** Medi antes de cortar: `CoreflowBackdrop.values` alimenta a
/// tela de personalização, então os cinco de gradiente são FEATURE (o usuário escolhe o fundo), e
/// não código morto como foram os sete gradientes. O uso confirma: `solid` 54 referências,
/// `image` 10, os cinco moods 11.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'bold_vinho.dart';
import 'bold_largura.dart' show CoreflowLarguraDeConteudo;

/// Os sete fundos que o produto oferece.
///
/// Enum FECHADO e `switch` exaustivo sem `_ =>` de propósito (exigência 7 do contrato de
/// componente): com o default genérico, um valor novo se disfarçaria de valor antigo e o fundo
/// errado apareceria em silêncio. Sem ele, o compilador aponta o lugar exato que falta tratar.
enum CoreflowBackdrop {
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
class CoreflowBackdropScope extends InheritedWidget {
  const CoreflowBackdropScope({
    super.key,
    this.estilo,
    this.arteClara,
    this.arteEscura,
    required super.child,
  });

  /// O fundo escolhido pela pessoa. **Nulo enquanto ela nunca escolheu** — e a diferença
  /// importa: nulo deixa o default da tela valer, e um valor VENCE o default da tela.
  final CoreflowBackdrop? estilo;

  /// A arte de cada modo. `null` ⇒ o fundo de imagem degrada pro fundo do tema com brilho, em
  /// vez de mostrar um retângulo vazio.
  final ImageProvider? arteClara;
  final ImageProvider? arteEscura;

  static CoreflowBackdropScope? of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<CoreflowBackdropScope>();

  @override
  bool updateShouldNotify(CoreflowBackdropScope old) =>
      old.estilo != estilo ||
      old.arteClara != arteClara ||
      old.arteEscura != arteEscura;
}

/// O backdrop. Envolve o corpo de uma tela.
///
/// ```dart
/// CoreflowBackground(child: conteudo)                              // segue a personalização
/// CoreflowBackground(estilo: CoreflowBackdrop.solido, child: conteudo)  // default da tela
/// CoreflowBackground.fixo(estilo: CoreflowBackdrop.aurora, child: …)  // ESTE mood, sempre
/// ```
class CoreflowBackground extends StatelessWidget {
  const CoreflowBackground(
      {super.key, required this.child, this.estilo, this.limitarConteudo = true})
      : declaradoVence = false;

  /// FIXA o [estilo]: desenha o que foi pedido e ignora a escolha da pessoa.
  ///
  /// A regra "a escolha vence o default da tela" (v0.4.0) está certa pra tela comum e há DOIS lugares
  /// em que ela é errada — e os dois apareceram olhando o app, não medindo:
  ///
  /// 1 · **o SELETOR.** A tela de Aparência desenha as cinco opções com `estilo:` em cada uma, e como a
  ///     escolha vencia, as cinco mostravam o fundo já escolhido. Escolher outro mudava as cinco
  ///     juntas — um seletor em que toda opção parece igual à atual;
  /// 2 · **a tela que não é do usuário.** O login declara `imagem` com a intenção escrita no código
  ///     dele — *"login sempre no fundo de cidade, independente da personalização"* —, e desde a v0.4.0
  ///     ele não conseguia garantir isso: quem tinha um mood salvo via o mood, e a tela de loading (que
  ///     desenha a arte por outro caminho) ficava com fundo diferente da tela de login.
  ///
  /// O nome é `fixo` e não `amostra` porque o conceito é um só: **o declarado vence a escolha.** Amostra
  /// era o primeiro caso que apareceu, e nome de caso vira nome errado no segundo.
  const CoreflowBackground.fixo(
      {super.key,
      required this.child,
      required CoreflowBackdrop this.estilo,
      this.limitarConteudo = true})
      : declaradoVence = true;

  final Widget child;

  /// `null` ⇒ resolve pelo [CoreflowBackdropScope]; sem scope, cai em [CoreflowBackdrop.imagem]. Passar
  /// valor explícito é pra tela que precisa declarar o próprio default.
  final CoreflowBackdrop? estilo;

  /// `true` ⇒ o [estilo] declarado ganha da escolha da pessoa. Ver [CoreflowBackground.fixo].
  final bool declaradoVence;

  /// **A ARTE SANGRA, O CONTEÚDO NÃO** — e este campo é um pedido do time do app, atendido.
  ///
  /// Numa tela larga o conteúdo deste produto para em `CoreflowLargura.teto` (600) e centraliza; a
  /// arte de fundo continua indo de ponta a ponta. Sem separar as duas coisas, capar a largura
  /// deixaria o produto como uma coluna estreita entre duas faixas vazias.
  ///
  /// **Como isso chegou aqui:** entre 27/08 e 01/09 o time do app escreveu, dentro de
  /// `lib/design_system/widgets/`, uma casca que se chamava `CoreflowBackground` e **sombreava esta**
  /// — o barril do app escondia a minha e exportava a dele, e os ~130 sítios ganhavam o teto sem
  /// mudar uma linha. O `///` dela já dizia o que devia acontecer:
  ///
  /// > *"Morre no dia em que o pai aceitar um `limitarConteudo` (pedido a registrar no bold-ds) — aí
  /// > o barrel volta a exportar o do pacote direto."*
  ///
  /// É esse dia. O campo entra com default `true` porque é o que os ~130 sítios querem, e quem
  /// precisa da largura cheia diz `limitarConteudo: false` — que é a mesma forma do
  /// [CoreflowSemTeto], por nome em vez de por acidente.
  final bool limitarConteudo;

  /// O véu sobre a arte. Claro: branco a 20% — a arte é diurna e o ink escuro precisa ler por
  /// cima. Escuro: preto a 8%, porque a arte noturna já é escura.
  ///
  /// Alpha de branco e de preto não é identidade (é ausência e presença de luz), então não é
  /// dívida de paleta — é a mesma leitura que o pai faz dos alphas dele.
  static Color _veu(DilettaScheme s) => s.isDark
      ? s.palette.black.withValues(alpha: 0.08)
      : s.palette.white.withValues(alpha: 0.20);

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final scope = CoreflowBackdropScope.of(context);
    // A ESCOLHA DA PESSOA VENCE O DEFAULT DA TELA, e a ordem inversa é um defeito medido no
    // app: com `estilo ?? scope`, toda tela que declara o próprio fundo ignora a
    // personalização — na Área Pix isso virou o item 72 do QA, porque o hub declarava
    // `solido` e o fundo escolhido em Aparência não aparecia.
    //
    // `scope.estilo` é nulo enquanto ninguém personalizou; aí o default da tela vale, que é
    // o comportamento que a tela espera.
    //
    // O `fixo` inverte a precedência de propósito: ele não é uma tela sob a personalização — é o
    // retrato de um mood no seletor, ou uma tela que não pertence ao usuário (o login).
    final fundo = declaradoVence
        ? estilo!
        : (scope?.estilo ?? estilo ?? CoreflowBackdrop.imagem);

    // No claro, mood de gradiente e sólido ganham base `primary08`: sobre o quase-branco do tema
    // os brilhos desbotavam e mesclavam com o conteúdo.
    final ehMood = fundo != CoreflowBackdrop.imagem && fundo != CoreflowBackdrop.solido;
    // O `_ =>` aqui é o único deste pacote, e ele é seguro POR CONSTRUÇÃO — não por descuido. A
    // auditoria de arquitetura cobra `_ =>` porque tipo novo se disfarça de tipo antigo; aqui um estilo
    // novo cai no ramo de mood, e `ehMood` o classifica por EXCLUSÃO (`!= imagem && != solido`), que é
    // o tratamento certo pra qualquer mood futuro. Escrever os sete casos duplicaria a mesma expressão
    // seis vezes, e aí o risco passa a ser esquecer de mudar uma delas.
    final base = switch (fundo) {
      CoreflowBackdrop.solido =>
        s.isDark ? s.palette.bgEscuro! : s.palette.primary08,
      _ => !s.isDark && ehMood ? s.palette.primary08 : s.bg,
    };

    return DilettaDevInfo(
      component: 'background',
      props: {
        'estilo': fundo.name,
        'arte': scope?.arteClara == null ? 'ausente' : 'declarada',
      },
      tokens: [
        fundo == CoreflowBackdrop.solido ? 'palette.bgEscuro' : 'scheme.bg',
        if (ehMood) 'palette.primary08',
      ],
      child: ColoredBox(
        color: base,
        child: Stack(children: [
          ..._camadas(s, fundo, scope),
          // A arte fica nas camadas acima, em largura cheia; só o CONTEÚDO passa pelo teto.
          limitarConteudo ? CoreflowLarguraDeConteudo(child: child) : child,
        ]),
      ),
    );
  }

  List<Widget> _camadas(
      DilettaScheme s, CoreflowBackdrop fundo, CoreflowBackdropScope? scope) {
    // A paleta vem do ESQUEMA, não da const deste produto. Era `BoldPalette.bold` cravada, e com
    // ela um filho deste DS recebia o fundo inteiro no rosa do Bold depois de declarar a paleta
    // dele — 9 brilhos em 6 modos.
    final p = s.palette;

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
    final k = (!s.isDark && fundo != CoreflowBackdrop.imagem) ? 1.3 : 1.0;

    return switch (fundo) {
      CoreflowBackdrop.imagem => _camadasDeArte(s, scope),
      CoreflowBackdrop.solido => [
          _brilho(const Alignment(0, -1), 1.0, p.primary04.withValues(alpha: 0.10 * k)),
        ],
      CoreflowBackdrop.brilhoRosa => [
          _brilho(const Alignment(0, -1), 1.15, p.primary04.withValues(alpha: 0.34 * k)),
        ],
      CoreflowBackdrop.vidroFrio => [
          _brilho(const Alignment(-0.5, -1), 1.2,
              BoldVinho.marcaDe(p).withValues(alpha: 0.34 * k)),
          _brilho(const Alignment(0.95, -0.6), 1.0,
              p.primary04.withValues(alpha: 0.30 * k)),
        ],
      CoreflowBackdrop.aurora => [
          _brilho(const Alignment(-0.7, -0.8), 0.9,
              p.primary04.withValues(alpha: 0.32 * k)),
          _brilho(const Alignment(0.85, -0.9), 0.85,
              p.warning03.withValues(alpha: 0.30 * k)),
          _brilho(const Alignment(0.5, 0.95), 1.0,
              BoldVinho.marcaDe(p).withValues(alpha: 0.32 * k)),
        ],
      CoreflowBackdrop.porDoSol => [
          _brilho(const Alignment(1, -1), 1.1, p.warning04.withValues(alpha: 0.22 * k)),
          _brilho(const Alignment(0.7, -0.85), 0.9,
              p.warning03.withValues(alpha: 0.26 * k)),
          _brilho(const Alignment(-1, 1), 1.0, p.primary04.withValues(alpha: 0.30 * k)),
        ],
      CoreflowBackdrop.gradeTech => [
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
  List<Widget> _camadasDeArte(DilettaScheme s, CoreflowBackdropScope? scope) {
    final arte = s.isDark ? scope?.arteEscura : scope?.arteClara;
    if (arte == null) {
      return [
        _brilho(const Alignment(0, -1), 1.15,
            s.palette.primary04.withValues(alpha: s.isDark ? 0.22 : 0.28)),
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
        child: const CoreflowBackground(child: SizedBox.expand()),
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
