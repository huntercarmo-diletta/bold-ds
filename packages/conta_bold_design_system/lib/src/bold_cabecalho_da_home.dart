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
class BoldIconeDoCabecalho {
  const BoldIconeDoCabecalho({
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
class BoldCabecalhoDaHome extends StatelessWidget {
  const BoldCabecalhoDaHome({
    super.key,
    required this.nome,
    this.conta,
    this.carregandoConta = false,
    this.aoAbrirPerfil,
    this.aoTrocarConta,
    this.icones = const [],
    this.foto,
  });

  /// Primeiro nome. Vazio cai em `?` no avatar, em vez de quebrar.
  final String nome;

  /// Conta ativa ("Conta PF"). Nulo ⇒ a linha de cima só tem os ícones.
  final String? conta;

  /// Skeleton no lugar do rótulo enquanto a conta carrega — evita o pop-in.
  final bool carregandoConta;

  final VoidCallback? aoAbrirPerfil;

  /// Nulo ⇒ sem chevron: rótulo estático que parece clicável é pior que rótulo sem afordância.
  final VoidCallback? aoTrocarConta;

  final List<BoldIconeDoCabecalho> icones;

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
          padding: EdgeInsets.symmetric(horizontal: DilettaSpacing.s6),
          child: Row(children: [
            _AvatarComSaudacao(
              nome: nome,
              foto: foto,
              aoAbrirPerfil: aoAbrirPerfil,
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
  });

  final String nome;
  final ImageProvider? foto;
  final VoidCallback? aoAbrirPerfil;

  static const double _lado = 40;
  static const double _ladoDoMini = 16;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    final avatar = SizedBox(
      width: _lado,
      height: _lado,
      child: Stack(clipBehavior: Clip.none, children: [
        if (foto != null)
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: s.primary, width: 1),
              image: DecorationImage(image: foto!, fit: BoxFit.cover),
            ),
            child: const SizedBox(width: _lado, height: _lado),
          )
        else
          DilettaAvatar(
            initials: nome.isEmpty ? '?' : nome[0].toUpperCase(),
            size: _lado,
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
        DilettaGap.w(DilettaSpacing.s4),
        DilettaText(
          'Olá, $nome!',
          style: DilettaType.titleMd
              .copyWith(fontWeight: FontWeight.w700, color: s.fg),
        ),
      ],
    );
  }
}

