/// CONTA BOLD — o CABEÇALHO da home, e o que ele destravou.
///
/// Este é o componente que estava atrás do pedido bloqueante da barra de topo. Os acessórios do pai
/// eram `sealed`, então não havia caminho de composição — nem o "compõe com o que existe", que é a
/// resposta que o pai costuma dar. A v0.4.0 abriu
/// `DilettaNavigationLeftAccessory.livre(child:, ocupaALinha:)`, e com isso os **113 usos** da barra
/// de topo deste produto entram na linguagem: 110 eram rename direto e ficavam presos por causa de 3.
///
/// ## Ele é a CASCA, não um acessório — e isso eu descobri medindo
///
/// A minha primeira versão era um acessório `.livre` dentro da barra, e estourou 32px: a
/// `DilettaNavigationTopBar` é `height: 52` cravado (com razão escrita — o `IconButton` 40×40
/// precisa de 40 livres pro clip do pill não virar oval), e este cabeçalho tem **duas linhas**: o
/// botão de conta (28) + gap (16) + o avatar (40) = 84.
///
/// Então ele não é conteúdo da barra: ele é a SEGUNDA LINHA de uma casca de topo, do mesmo tipo que a
/// variante `.stepper` do pai.
///
/// **E ele é a segunda linha de verdade desde a v0.11.0**: eu compunha `GlassSurface + StatusBar +
/// NavigationTopBar + a minha linha` porque a casca do pai só se montava por variante FECHADA, e o
/// pedido entrou como `DilettaTopAppBar.comConteudo(navBar:, conteudo:)`. As cinco linhas que
/// copiavam a gramática da casca (vidro, status bar, coluna, o respiro do fim) saíram — inclusive o
/// respiro, que agora é o do pai e não o meu.
///
/// A observação que fez o pedido entrar foi a que vale reter: **era o mesmo pedido do acessório livre,
/// um nível acima.** Quando uma camada abre e a de cima não, a abertura para na linha de baixo.
///
/// ## E na v0.40.0 do pai ele virou `.app` — porque `.comConteudo` desenhava DOIS RELÓGIOS
///
/// A casca com segunda linha só existia nas variantes de status bar MOCK: `.comConteudo` desenha a
/// `DilettaStatusBar` 9:41, e no app real ela empilha em cima da status bar do sistema. Este
/// componente é a peça da home de um app REAL, então ele nascia inutilizável no próprio produto —
/// e foi essa a evidência que fechou o pedido: *não é uma tela minha, é um componente meu que não
/// podia ser usado no meu app*.
///
/// `DilettaTopAppBar.app(navBar:, conteudo:)` é a mesma gramática (a linha, o respiro de 8) com o
/// **inset real** da `SafeArea`. Nada mais mudou aqui: o `conteudo` é o mesmo.
///
/// A linha de cima USA o acessório livre da v0.4.0 — ela é o botão de conta, que cabe nos 52.
///
/// ## O que mudou na adaptação
///
/// **O mini-avatar de 16px era três `Container` e um branco cravado.** Virou composição com o
/// avatar do pai, e o branco virou `scheme.surface` — no escuro o círculo era branco puro sobre
/// fundo quase preto, o que fazia dele o ponto mais claro da tela inteira.
///
/// **O botão de conta tinha o chevron condicional certo e a razão não escrita.** Ele só aparece
/// quando há troca de conta, senão o rótulo estático parece clicável. Ficou escrito.
///
/// **O nome vem em duas peças por decisão de layout, não de estilo.** A saudação e o botão de conta
/// não são um bloco só: o botão fica ACIMA, alinhado com os ícones da direita, e a saudação abaixo.
/// Empilhar na ordem inversa (como parece natural) faz o avatar disputar espaço com os ícones.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';


/// Um ícone da direita do cabeçalho, com marcador opcional.
///
/// Existe como descritor e não como widget porque a barra do pai recebe uma LISTA — e o pai já tem
/// o `DilettaNavRightIcon` com `badge`, que ele mediu antes de responder o meu pedido. Este tipo é
/// só o atalho pra montar aquele.
class CoreflowIconeDoCabecalho {
  const CoreflowIconeDoCabecalho({
    required this.icone,
    required this.rotulo,
    this.aoTocar,
    this.marcador = false,
  });

  /// Nome do glifo no conjunto do pai.
  final String icone;

  /// O que o leitor de tela anuncia.
  final String rotulo;

  final VoidCallback? aoTocar;

  /// Ponto de "tem coisa nova".
  final bool marcador;

  DilettaNavRightIcon get paraOPai => DilettaNavRightIcon(
        icon: icone,
        semanticLabel: rotulo,
        onPressed: aoTocar,
        badge: marcador,
      );
}

/// O cabeçalho da home: conta ativa e ícones em cima, avatar e saudação embaixo.
class CoreflowCabecalhoDaHome extends StatelessWidget {
  const CoreflowCabecalhoDaHome({
    super.key,
    required this.nome,
    this.conta,
    this.carregandoConta = false,
    this.aoAbrirPerfil,
    this.aoTrocarConta,
    this.icones = const [],
    this.foto,
    this.heroTag,
  });

  /// A IDENTIDADE DE TRANSIÇÃO do avatar — nula por default, e aí nada muda.
  ///
  /// Preenchida, o círculo VOA pra a outra rota que usa a mesma tag: é o gesto de tocar o avatar e ver
  /// ele crescer virando o cabeçalho do Perfil, em vez de a tela trocar por corte.
  ///
  /// **Ela vem de fora e é opcional porque duas `Hero` com a mesma tag na mesma rota derrubam o
  /// Flutter** — e no app deste produto a aba Perfil convive com a home num `IndexedStack`, então só o
  /// Perfil EMPILHADO pode passar a tag. Um avatar não sabe quantas cópias de si existem na árvore.
  ///
  /// Chegou como pedido em 12/08 e o pai entregou na `v0.115.0`: `DilettaAvatar.heroTag`, a primeira
  /// transição declarada da linguagem. Envolver este cabeçalho num `Hero` por fora não serve, e o
  /// número está no teste `o_heroi_por_fora`: voariam **300+ × 100+** (a casca, os ícones, a segunda
  /// linha) onde devem voar **48 × 48**.
  final Object? heroTag;

  /// Primeiro nome. Vazio cai em `?` no avatar, em vez de quebrar.
  final String nome;

  /// Conta ativa ("Conta PF"). Nulo ⇒ a linha de cima só tem os ícones.
  final String? conta;

  /// Skeleton no lugar do rótulo enquanto a conta carrega — evita o pop-in.
  final bool carregandoConta;

  final VoidCallback? aoAbrirPerfil;

  /// Nulo ⇒ sem chevron: rótulo estático que parece clicável é pior que rótulo sem afordância.
  final VoidCallback? aoTrocarConta;

  final List<CoreflowIconeDoCabecalho> icones;

  /// Foto de perfil. Nula ⇒ a inicial.
  final ImageProvider? foto;

  @override
  Widget build(BuildContext context) {
    return DilettaDevInfo(
      component: 'cabecalhoDaHome',
      props: {
        'conta': conta ?? 'ausente',
        'icones': '${icones.length}',
        'foto': foto == null ? 'inicial' : 'imagem',
      },
      tokens: const ['scheme.fg', 'scheme.primary', 'type.titleMd'],
      child: DilettaTopAppBar.app(
        // SEM VIDRO, e a linguagem passou a dizer isso na `ds v0.68.0`.
        //
        // O defeito apareceu comparando o desenho com o APARELHO: aqui a casca cobria o terço
        // superior da arte, e o gêmeo desta peça no app tinha `SEM glass/fill/stroke — só o
        // conteúdo` escrito num comentário há meses. Divergência declarada de um lado só.
        //
        // O veredito do pai é mais geral que o meu pedido, e é a frase que fica: **a superfície da
        // barra existe pra separar a navegação do conteúdo que ROLA por baixo; quando o topo da tela
        // É a identidade, ela não tem trabalho — o que ela faz é cobrir.** É a mesma regra do trilho
        // do medidor noutra peça: o que sobra atrás não se anuncia.
        //
        // E o desvio era da casa, não da minha home: as SETE variantes eram de vidro, enquanto o
        // Material 3 só pinta a barra no estado *scrolled* e a nav bar grande do iOS é transparente
        // até a primeira rolagem. As nossas estavam permanentemente roladas.
        vidro: false,
        // Linha 1: a barra do PAI, com a conta à esquerda no acessório livre e os ícones à direita no
        // acessório dele. Cabe nos 52 — o botão de conta tem 28.
        navBar: DilettaNavigationTopBar(
          left: conta == null
              ? null
              : DilettaNavigationLeftAccessory.livre(
                  child: _BotaoDeConta(
                    rotulo: conta!,
                    carregando: carregandoConta,
                    aoTocar: aoTrocarConta,
                  ),
                ),
          right: icones.isEmpty
              ? null
              : DilettaNavigationRightAccessory.icons(
                  icons: icones.map((i) => i.paraOPai).toList(),
                ),
        ),
        // Linha 2: avatar e saudação. É ela que não cabe na barra, e é por isso que este componente
        // é a segunda linha de uma casca do pai, e não um acessório dentro da barra.
        conteudo: Padding(
          // O GUTTER É `s6` (24), e isso é do CHROME da linguagem — não é escolha deste arquivo.
          //
          // Medido em 19/08 convergindo os gêmeos: a barra de topo, a barra de baixo e a status bar
          // do pai usam `s6` as três. Então 24 aqui é a peça acompanhando o chrome, e a segunda linha
          // ficaria fora de esquadro com a primeira se eu baixasse pra 20.
          //
          // **O que isso descobriu é uma pergunta que não é minha**: as telas deste produto usam 20
          // de gutter de CONTEÚDO. Com o chrome em 24, o cabeçalho fica 4px pra dentro do que vem
          // embaixo dele — e é essa a diferença que impede o app de trocar o gêmeo dele por esta peça
          // sem mexer no alinhamento da home. Quem move (o conteúdo pra 24, ou o chrome virando
          // declarável) é decisão do dono do produto.
          padding: EdgeInsets.symmetric(horizontal: DilettaSpacing.s6),
          child: Row(children: [
            _AvatarComSaudacao(
              nome: nome,
              foto: foto,
              aoAbrirPerfil: aoAbrirPerfil,
              heroTag: heroTag,
            ),
          ]),
        ),
      ),
    );
  }
}

class _BotaoDeConta extends StatelessWidget {
  const _BotaoDeConta({required this.rotulo, this.carregando = false, this.aoTocar});

  final String rotulo;
  final bool carregando;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final tinta = s.fg;

    return DilettaTappable(
      onTap: aoTocar,
      child: DilettaBox(
        height: 28,
        radius: DilettaRadius.all16,
        borderColor: tinta,
        padding: EdgeInsets.symmetric(horizontal: DilettaSpacing.s3),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          DilettaIcon(name: DilettaIcons.piggyBankLight, size: 16, color: tinta),
          DilettaGap.w(DilettaSpacing.s1_5),
          if (carregando)
            DilettaShimmer(child: DilettaSkeleton.box(width: 58, height: 11))
          else
            DilettaText(rotulo, style: DilettaType.labelMd.copyWith(color: tinta)),
          // O chevron só existe quando há troca de conta: rótulo estático com afordância de
          // clique é pior que rótulo sem afordância nenhuma.
          if (aoTocar != null) ...[
            DilettaGap.w(DilettaSpacing.s1_5),
            DilettaIcon(
                name: DilettaIcons.angleDownLight, size: 12, color: tinta),
          ],
        ]),
      ),
    );
  }
}

class _AvatarComSaudacao extends StatelessWidget {
  const _AvatarComSaudacao({
    required this.nome,
    required this.foto,
    required this.aoAbrirPerfil,
    required this.heroTag,
  });

  final String nome;
  final ImageProvider? foto;
  final VoidCallback? aoAbrirPerfil;
  final Object? heroTag;

  // 48 e não 40, e o respiro 12 e não 16: ajuste pedido pelo dono do produto olhando a home —
  // *"o avatar tá menor e um pouco mais longe do Olá, Nome"*. O 40 era o número do Redesenho v.01,
  // desenhado antes de a linha ter foto.
  //
  // 48 cai na MESMA faixa de degrau da inicial do pai (`heading` vale de 40 a 55): o avatar cresce e a
  // letra dentro dele não muda de degrau. Os mesmos dois números estão no gêmeo do app; eles convergem
  // quando o app adotar este componente.
  static const double _lado = 48;
  static const double _ladoDoMini = 16;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    final avatar = SizedBox(
      width: _lado,
      height: _lado,
      child: Stack(clipBehavior: Clip.none, children: [
        // UM avatar do pai pros dois casos, e não um `DecoratedBox` daqui pra foto.
        //
        // O ramo da foto desenhava o círculo à mão — mesma decoração, mesma borda de 1px, mesmo
        // `cover` — porque a peça dele não tinha `image` quando isto foi escrito. Ela tem desde a
        // `v0.36.0`, pedida por um filho.
        //
        // A troca não é só higiene: **o voo mora na peça.** O `flightShuttleBuilder` do
        // `DilettaAvatar` mantém o recorte circular no meio do caminho, e sem ele a foto vira
        // QUADRADO durante a transição — medido pelo pai antes de o campo existir. Um `Hero` em cima
        // de um `DecoratedBox` daqui não teria isso.
        DilettaAvatar(
          initials: nome.isEmpty ? '?' : nome[0].toUpperCase(),
          image: foto,
          size: _lado,
          // A BORDA é do ramo da foto, e só dele. O círculo de iniciais sempre usou o default do pai
          // (`borderSubtle`); passar `s.primary` nos dois teria trocado a borda de todo avatar sem
          // foto — mudança de desenho entrando de carona numa mudança de estrutura, que é o jeito
          // mais barato de um refactor mentir.
          borderColor: foto != null ? s.primary : null,
          heroTag: heroTag,
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: DilettaBox(
            width: _ladoDoMini,
            height: _ladoDoMini,
            radius: DilettaRadius.pillAll,
            // Era `white` cravado. No escuro, um círculo de branco puro sobre fundo quase preto
            // fica sendo o ponto mais claro da tela inteira — e ele é um adorno de 16px.
            color: s.surface,
            borderColor: s.border,
            borderWidth: 0.75,
            alignment: Alignment.center,
            child: DilettaIcon(
                name: DilettaIcons.userLight, size: 8, color: s.textSecondary),
          ),
        ),
      ]),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'Abrir perfil de $nome',
          child: DilettaTappable(onTap: aoAbrirPerfil, child: avatar),
        ),
        DilettaGap.w(DilettaSpacing.s3),
        DilettaText(
          'Olá, $nome!',
          style: DilettaType.titleMd
              .copyWith(fontWeight: FontWeight.w700, color: s.fg),
        ),
      ],
    );
  }
}

