import 'package:flutter/widgets.dart';

/// **CoreflowDisco** — o círculo que SEGURA alguma coisa, com anel opcional.
///
/// Ele não é o [CoreflowSpot] e não é o `CoreflowPonto`, e a diferença entre os três é o que eles
/// carregam:
///
/// | peça | o que tem dentro |
/// |---|---|
/// | `CoreflowPonto` | **nada** — é um sinal, e o rótulo ao lado diz o quê |
/// | `CoreflowSpot` | um **glifo**, e o tom vem de uma escada semântica com piso de contraste |
/// | `CoreflowDisco` | **qualquer coisa** — número, tique, spinner, avatar |
///
/// ## Por que ele existe, medido
///
/// Seis sítios deste produto desenhavam esta forma à mão, e nenhum cabia nas outras duas:
///
/// | onde | Ø | preenchimento | anel | dentro |
/// |---|---|---|---|---|
/// | nó do trilho de aprovações | 34 | tom @16/34 | tom @90/200, 1,4 | glifo |
/// | nó do trilho do MED | 26 | tom ou nada | tom, 1,5 | glifo **ou número** |
/// | selo da câmera no avatar | 26 | marca | **cor do FUNDO**, 2 | glifo ou spinner |
/// | selo da seta na notificação | 18 | tom | **cor da SUPERFÍCIE**, 2 | glifo |
/// | passo numerado do Pix automático | 24 | sucesso @16 | — | **número** |
/// | anel do radar de vizinhos | — | — | tom @25, 1 | **avatar** |
///
/// **A divergência está nos NÚMEROS, e número é parâmetro.** Foi essa a pergunta que fez a peça
/// nascer: os dois trilhos são componentes diferentes (um conta quem aprovou, o outro onde está a
/// disputa) e por isso não viraram uma peça só — mas o nó dos dois é o mesmo objeto, e ele estava
/// desenhado quatro vezes além deles.
///
/// ## O anel na cor do que está ATRÁS
///
/// Dois dos seis pintam o anel com a cor do fundo ou da superfície, e o `///` de um deles já dizia
/// por quê: *"sem ela os dois círculos se fundem num borrão colorido"*. Não é decoração — é o que
/// separa um selo do que ele marca. Por isso [anel] recebe COR e não um booleano: quem sabe o que
/// está atrás é a tela.
class CoreflowDisco extends StatelessWidget {
  const CoreflowDisco({
    super.key,
    this.tamanho,
    this.preenchimento,
    this.anel,
    this.larguraDoAnel = 1,
    this.child,
  });

  /// O diâmetro. Livre, e os seis sítios medidos pedem 18, 24, 26, 26 e 34 — cinco valores em seis
  /// lugares é ausência de escada, não escada faltando. Ver a mesma decisão no `CoreflowPonto`.
  ///
  /// **`null` dimensiona pelo FILHO**, e esse caso não é teórico: o anel do radar de vizinhos
  /// envolve o avatar, e quem sabe o tamanho do avatar é o avatar. Exigir o número ali obrigaria a
  /// tela a repetir uma medida que ela não é dona.
  final double? tamanho;

  /// O fundo. `null` deixa vazado — é o nó do trilho que ainda não chegou.
  final Color? preenchimento;

  /// A cor do anel. `null` não desenha anel.
  final Color? anel;

  final double larguraDoAnel;

  /// O que ele segura: glifo, número, tique, spinner, avatar. `null` é um disco chapado — e aí
  /// `CoreflowPonto` provavelmente é a peça certa.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final caixa = DecoratedBox(
      decoration: BoxDecoration(
        color: preenchimento,
        shape: BoxShape.circle,
        border:
            anel == null ? null : Border.all(color: anel!, width: larguraDoAnel),
      ),
          // `Center` e não `alignment:` do Container: o filho pode ser texto, e texto sem centro
          // explícito assenta na baseline — que num disco de 18 é a diferença entre centrado e
          // encostado embaixo.
      // O `Center` só entra quando há diâmetro: sem ele o texto assenta na baseline, e num disco
      // de 18 isso é a diferença entre centrado e encostado embaixo. **Com `tamanho` nulo ele não
      // pode entrar** — `Center` expande pro espaço disponível, e o disco que devia medir o avatar
      // passaria a medir a tela inteira. Medido: 800 × 600 em vez de 48.
      child: child == null || tamanho == null ? child : Center(child: child),
    );
    if (tamanho == null) return caixa;
    return SizedBox(width: tamanho, height: tamanho, child: caixa);
  }
}
