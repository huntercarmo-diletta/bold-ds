import 'package:flutter/material.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart'
    show
        CoreflowOperatingStrip,
        DilettaNavigationLeftAccessory,
        DilettaNavigationRightAccessory,
        DilettaNavigationTopBar,
        DilettaTheme,
        DilettaTopAppBar,
        DilettaType;
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_radius.dart' show CoreflowRadius;
import 'bold_scheme.dart' show CoreflowScheme;


/// Conta BOLD — TopBar. Único ponto de entrada pro slot superior da tela, e o que ele faz hoje é
/// DELEGAR: a casca é a [DilettaTopAppBar] do pai (`.app` — inset real, não a status bar mock), a
/// linha é a [DilettaNavigationTopBar] dele, e o que fica aqui é o que é do produto:
///
/// - a faixa **"agindo em nome de"**, lida do contexto e injetada em toda variante — 110 telas
///   recebem sem saber que existe;
/// - o **papel primário do título**, licença escrita na spec do pai pra barra que é o único título;
/// - o cabeçalho da home, que tem foto e mini-avatar (o `.home` do pai não tem);
/// - o cabeçalho de bottom sheet, que é superfície interna e não casca de topo.
///
/// **Nada aqui remonta a gramática da casca.** Vidro, inset e respiro saíram na adoção da v0.40.0 do
/// pai; `a_casca_de_topo_e_a_do_pai_test` reprova se voltarem. A cópia custava 10 linhas e não
/// acompanhava: duas versões da casca do pai passaram sem chegar às telas.
///
/// Variantes:
/// - `.page(title, onBack)`      → back + título centrado (+ ação opcional)
/// - `.home(firstName, icons)`   → "Olá, {nome}!" + ícones à direita
/// - `.sheet(title, onClose)`    → cabeçalho de bottom sheet (grip + close)
///
/// ```dart
/// CoreflowBarraDeTopo.page(title: 'Menu completo', onBack: pop);
/// CoreflowBarraDeTopo.home(firstName: 'Ana', icons: [
///   DilettaNavRightIcon(icon: 'bell-light', semanticLabel: 'Notificações', badge: true,
///       type: DilettaIconButtonType.tertiary),
/// ]);
/// ```
class CoreflowBarraDeTopo extends StatelessWidget {
  const CoreflowBarraDeTopo._({
    super.key,
    DilettaNavigationTopBar? navBar,
    Widget? custom,
    bool sheet = false,
    bool safeArea = true,
    bool glass = true,
    VoidCallback? onClose,
    this.title,
  })  : _navBar = navBar,
        _custom = custom,
        _sheet = sheet,
        _safeArea = safeArea,
        _glass = glass,
        _onClose = onClose;

  /// Back + título centrado + ação opcional à direita.
  ///
  /// [left] é escape hatch: quando a tela não volta com uma seta (fecha com X, ou não sai por aqui),
  /// ela declara o acessório. Sem ele e sem [onBack] o slot fica vazio — os 99 usos desta variante
  /// passam `onBack`, então o default não muda pra ninguém.
  factory CoreflowBarraDeTopo.page({
    Key? key,
    required String title,
    VoidCallback? onBack,
    DilettaNavigationRightAccessory? action,
    DilettaNavigationLeftAccessory? left,
    bool glass = true,
  }) {
    final rotulo = title.isEmpty ? null : title;
    return CoreflowBarraDeTopo._(
      key: key,
      glass: glass,
      navBar: DilettaNavigationTopBar(
        left: left ??
            (onBack == null
                ? null
                : DilettaNavigationLeftAccessory.back(onPressed: onBack)),
        title: rotulo,
        titleWidget: _tituloPrimario(rotulo),
        right: action,
      ),
    );
  }

  /// Igual à `.page`, **sem o vidro**: só o conteúdo sobre o fundo da tela.
  ///
  /// Existe porque tela cujo desenho pede fundo limpo — comprovante, editor em
  /// tela cheia, sucesso — vinha montando o próprio cabeçalho à mão. E
  /// cabeçalho à mão não recebe nada do chrome: nem a faixa de "agindo em nome
  /// de", nem o respiro padrão, nem a safe-area resolvida.
  factory CoreflowBarraDeTopo.plain({
    Key? key,
    String title = '',
    VoidCallback? onBack,
    DilettaNavigationRightAccessory? action,
    DilettaNavigationLeftAccessory? left,
  }) {
    // Vazio vira NULO, e não string vazia: 2 das 4 telas desta variante não passam título, e o
    // `title: ''` fazia o pai desenhar um `Text('')` no centro da barra. Não aparecia — mas era um
    // nó de texto com o papel de metadado esperando alguém medir a barra e achar título onde não tem.
    final rotulo = title.isEmpty ? null : title;
    return CoreflowBarraDeTopo._(
      key: key,
      glass: false,
      navBar: DilettaNavigationTopBar(
        left: left ??
            (onBack == null
                ? null
                : DilettaNavigationLeftAccessory.back(onPressed: onBack)),
        title: rotulo,
        titleWidget: _tituloPrimario(rotulo),
        right: action,
      ),
    );
  }

  /// Header da home (Redesenho v.01) — DUAS linhas:
  /// 1. botão de conta (🐷 + nº + ▾) + ícones tertiary à direita;
  /// 2. avatar (stroke primary + mini-avatar) + "Olá, {nome}!".
  ///
  /// [accountLoading] mostra shimmer no lugar do nº enquanto a conta carrega.
  // A fábrica `.home` SAIU em 2026-08-19, junto com o `_HomeHeader` e o `_AccountButton`.
  //
  // Ela era o gêmeo do `CoreflowCabecalhoDaHome` do pacote: mesma aparência, mesma API, dois lugares
  // pra consertar. O que as mantinha vivas era uma coisa só, e estava escrita aqui: a peça do
  // pacote não aceitava a tag do voo do avatar, então convergir apagava a animação.
  //
  // Os dois impedimentos caíram em 19/08. O `heroTag` chegou na `ds v0.115.0` (pedido de 12/08), e
  // o geométrico era o gutter: a peça do pacote alinha em 24, que é o do chrome da linguagem, e a
  // home alinhava em 20. O app passou a ter um gutter só, e aí não sobrou diferença pra defender.


  /// Page + linha de progresso de fluxo (multi-etapa).
  // A fábrica `.stepper` SAIU em 2026-08-10, junto com a peça.
  //
  // Nove telas de onboarding mostram progresso, e nenhuma usava o stepper: elas
  // usam a `OnboardingProgressBar` (barra de 4px). O stepper e esta fábrica
  // estavam vivos **só pelos dois testes que os exercitavam** — e o `///` do
  // `DilettaStepper` do pai já dizia, medido do lado dele: *"o único consumidor
  // real do stepper nos dois filhos é quem pediu a troca"*, que é o filho A.
  //
  // Se um fluxo daqui pedir "Passo X de Y", a peça é a do pai (`DilettaStepper`),
  // e a segunda linha da casca continua aceitando — é o que a faixa usa hoje.

  /// Cabeçalho de bottom sheet: grip + título + close, container branco opaco
  /// (sem glass — o sheet já é sólido atrás).
  factory CoreflowBarraDeTopo.sheet({
    Key? key,
    required String title,
    VoidCallback? onClose,
  }) =>
      CoreflowBarraDeTopo._(key: key, title: title, sheet: true, onClose: onClose);

  final String? title;

  // — composição interna —
  final DilettaNavigationTopBar? _navBar;
  final Widget? _custom;
  final bool _safeArea;
  final bool _glass;
  final bool _sheet;
  final VoidCallback? _onClose;

  @override
  Widget build(BuildContext context) {
    // O sheet é modal e efêmero — não carrega a faixa de contexto (ela já está
    // na tela por baixo, e repetir dentro do sheet vira ruído).
    if (_sheet) return _buildSheet(context);

    // Faixa "agindo em nome de": vem do [CoreflowOperatingContext] publicado no
    // topo da árvore, então aparece em TODA variante de top bar sem a tela
    // precisar saber que existe.
    final strip = CoreflowOperatingStrip.maybeOf(context);

    // Header da home: sem superfície — só o conteúdo sobre o fundo. Safe-area no topo.
    //
    // Isto era uma DIVERGÊNCIA declarada de um lado só, e ela custou caro: o gêmeo desta peça no
    // pacote (`CoreflowCabecalhoDaHome`) usava a casca de vidro do pai, e no catálogo a home aparecia
    // com o terço superior da arte coberto. O dono viu comparando o desenho com o aparelho.
    //
    // Desde a `ds v0.68.0` **a linguagem diz isto**: `DilettaTopAppBar.app(vidro: false)`. E o
    // veredito é mais geral que o caso — *"a superfície da barra existe pra separar a navegação do
    // conteúdo que ROLA por baixo; quando o topo da tela É a identidade, ela não tem trabalho, e o
    // que ela faz é cobrir"*. As sete variantes da casca eram de vidro; o desvio era da casa.
    //
    // O que falta pra estas duas peças virarem uma: a do pacote não aceita `avatarHeroTag`, e é ela
    // que faz o avatar VOAR daqui pro Perfil. Enquanto não aceitar, a convergência apaga a animação.
    if (_custom != null) {
      return Padding(
        padding: EdgeInsets.only(
            top: _safeArea ? MediaQuery.of(context).padding.top : 0,
            bottom: DilettaSpacing.s4),
        child: strip == null
            ? _custom
            : Column(mainAxisSize: MainAxisSize.min, children: [
                _custom,
                Padding(
                  padding: const EdgeInsets.only(top: DilettaSpacing.s3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(CoreflowRadius.pill),
                    child: strip,
                  ),
                ),
              ]),
      );
    }

    // Local pra permitir promotion do nullable (campo de instância não promove).
    final bar = _navBar!;

    // A SEGUNDA LINHA da casca: o que vem depois da barra. Nula quando não há faixa — e a nulidade
    // importa, porque é ela que diz à casca do pai se o respiro do fim existe.
    //
    // Ela já teve DOIS ocupantes (stepper e faixa) e hoje tem um: o stepper saiu em 10/08 porque
    // nenhuma tela o usava. A `Column` fica porque o slot é de LISTA — se voltar a haver dois, é aqui.
    //
    // Faixa DEPOIS da barra, encostada na borda de baixo do vidro: lê como "contexto desta tela" em
    // vez de disputar espaço com o título. Padrão definido na tela de contatos.
    final segundaLinha = strip == null
        ? null
        : Column(mainAxisSize: MainAxisSize.min, children: [strip]);

    // A CASCA É DO PAI. Aqui moravam 10 linhas remontando a gramática dele à mão — vidro, inset da
    // safe-area, respiro — e era a cópia que o `///` do `comConteudo` dele cobra pelo nome: *"cinco
    // linhas copiando a gramática desta casca, que não acompanham quando a gramática muda"*. Elas não
    // acompanhavam: v0.11.0 e v0.40.0 passaram sem chegar aqui.
    //
    // O `.app` é a variante de APP REAL — inset da `SafeArea` em vez da status bar mock 9:41 — e ela
    // só passou a aceitar segunda linha na v0.40.0, que é o veredito deste pedido. Sem ela, stepper e
    // faixa de contexto não teriam onde ir.
    //
    // **O degrau é dele, e ele custou 16px**: a casca do pai fecha o vidro nos 52 da barra, sem os 8
    // acima e os 8 abaixo que esta casa punha por dentro. São 102 telas mais apertadas, e a troca foi
    // decisão do dono do produto — a alternativa era pedir respiro declarável e manter a cópia viva
    // esperando um segundo filho medir o mesmo.
    final casca = _glass
        ? DilettaTopAppBar.app(navBar: bar, conteudo: segundaLinha)
        // Sem vidro não há casca: a molécula do pai direto, e o inset é `SafeArea` de Flutter e nada
        // mais. Sem vidro não existe inset-por-dentro-da-superfície, nem ordem, nem respiro — não há
        // gramática pra copiar aqui, e é por isso que o pai não abriu variante `.semVidro`.
        : SafeArea(
            bottom: false,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              bar,
              if (segundaLinha != null) segundaLinha,
            ]),
          );

    // Respiro OBRIGATÓRIO abaixo da casca: sem ele o conteúdo da tela encosta no vidro e os dois viram
    // um bloco só. É margem POR FORA da superfície, então não é gramática de casca e não muda a altura
    // do vidro — fica desta casa em qualquer cenário. Tela nenhuma precisa lembrar disso.
    return Padding(
      padding: const EdgeInsets.only(bottom: DilettaSpacing.s2),
      child: casca,
    );
  }

  Widget _buildSheet(BuildContext context) {
    final c = CoreflowScheme.of(context);
    return Container(
      decoration: BoxDecoration(
        // Superfície do tema (dark no dark) — branco fixo criava faixa branca
        // no topo do sheet com o título (texto branco) invisível.
        color: c.surface,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(CoreflowRadius.sheet),
            topRight: Radius.circular(CoreflowRadius.sheet)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Grip iOS. **É CÓPIA do [CoreflowFolha], e a nota anterior dizia "fonte única do handle" —
        // não era.** Ficam as duas porque as duas morrem juntas: o pegador do pai entrou na
        // `v0.143.0` com exatamente estes 40 × 4 em `textMuted` (o número saiu do meu pedido), e o
        // que impede este método de virar `DilettaTopAppBar.bottomsheet(navBar:)` é UMA coisa: a
        // variante dele crava `r24` no canto e este produto declara **22**. Pedido de 22/08.
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 10, bottom: 6),
          decoration: BoxDecoration(
              color: c.textMuted.withValues(alpha: 0.5),
              borderRadius: CoreflowRadius.pillR),
        ),
        DilettaNavigationTopBar(
          left: DilettaNavigationLeftAccessory.close(onPressed: _onClose),
          title: title,
          titleWidget: _tituloPrimario(title),
        ),
      ]),
    );
  }
}

/// O TÍTULO com o papel PRIMÁRIO, pelo `titleWidget` — o escape hatch que o pai já tinha.
///
/// O default do pai é `textSecondary`, e ele confirmou que é **escolha**, não descuido: nas telas de
/// onde a linguagem nasceu, o título da barra é RÓTULO DE ETAPA ('Criar conta') e o título da tela é
/// outro texto, maior, no content. Duas hierarquias, e o primário na barra achataria a distinção.
///
/// Aqui a barra é o ÚNICO título — em 110 telas, num app escuro por default, com 48 pontos por canal
/// de diferença. Título de tela é a informação primária dela, e `textSecondary` é papel de metadado.
/// O limite entrou na spec do pai junto com a escolha: *barra que é o único título usa `titleWidget`
/// com o papel primário*. É um caso registrado; se um segundo filho medir a mesma coisa, o papel
/// deixa de ser escape hatch e vira declaração.
///
/// Só a COR muda. O degrau continua o do pai — `heading` (16/w600). O `fontSize: 17` cravado da barra
/// copiada morreu quando ela morreu, e não volta por aqui.
///
/// Nulo quando não há título: `titleWidget` sobrepõe o `title` do pai, então devolver um `Text('')`
/// faria a `.plain()` sem título passar a ocupar o centro com nada.
Widget? _tituloPrimario(String? title) =>
    (title == null || title.isEmpty) ? null : _TituloPrimario(title);

class _TituloPrimario extends StatelessWidget {
  const _TituloPrimario(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        // `maxLines`/`ellipsis` são do default do pai, e o `titleWidget` substitui o Text dele
        // INTEIRO: quem não repete perde o truncamento, e título longo vaza por cima dos acessórios.
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DilettaType.heading
            .copyWith(color: DilettaTheme.schemeOf(context).fg),
      );
}

/// Header da home (2 linhas) — spec Redesenho v.01.
