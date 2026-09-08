/// CONTA BOLD — a FILEIRA DE AVATARES, o *"Enviar para"* da home e dos contatos da Área Pix.
///
/// Ela já era **adotada** — o círculo é o `DilettaAvatar` do pai desde 08/08, quando a inicial
/// deixou de ser *30% do diâmetro* e passou a sair do degrau que o diâmetro escolhe. O que ficou do
/// lado de cá foi o LAYOUT: a fileira, a célula de 60 com nome e banco, o rolo horizontal e o anel
/// tracejado do "+".
///
/// ## Então por que ela mudou de casa
///
/// Porque adotada e alcançável não são a mesma coisa. Ela morava em `app-newbold/lib/design_system/`,
/// e o catálogo consome o PACOTE — nunca o app. Uma peça que só existe dentro do aparelho não pode
/// ser desenhada, e duas das quatro telas de loja começam com esta fileira.
///
/// É uma classe de defeito diferente da lacuna: lacuna é peça sem par na linguagem; esta tinha par
/// e estava **do lado errado da fronteira**.
///
/// ## As duas formas, e a que existe é a rotulada
///
/// A compacta (só círculos, 4 de vão) e a rotulada (nome + banco embaixo, rolando na horizontal).
/// A home e a Área Pix usam a rotulada; a compacta sobrevive em um sítio.
///
/// O `CoreflowType.tileLabel` (10/12) do banco virou `DilettaType.labelSm`, mesma troca do ladrilho de
/// menu e pela mesma razão: um degrau com um usuário não é degrau.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// A fileira de avatares.
class CoreflowFileiraDeAvatares extends StatelessWidget {
  const CoreflowFileiraDeAvatares({
    super.key,
    required this.iniciais,
    this.rotulos,
    this.subrotulos,
    this.tamanho = 32,
    this.aoTocarNoAvatar,
    this.aoAdicionar,
  });

  final List<String> iniciais;

  /// Primeiro nome sob cada avatar. Passar isto liga a forma ROTULADA.
  final List<String>? rotulos;

  /// Banco, na segunda linha. Só na forma rotulada.
  final List<String>? subrotulos;

  final double tamanho;

  /// Recebe o índice do avatar tocado.
  final ValueChanged<int>? aoTocarNoAvatar;

  /// O "+" tracejado do fim. Some quando nulo.
  final VoidCallback? aoAdicionar;

  bool get _rotulada => rotulos != null;

  Widget _circulo(int i) => DilettaAvatar(
        initials: iniciais[i],
        variant: DilettaAvatarVariant.solid,
        size: tamanho,
      );

  Widget _botaoDeAdicionar(Color cor) => CustomPaint(
        painter: _AnelTracejado(cor),
        child: SizedBox(
          width: tamanho,
          height: tamanho,
          child: Center(
            child: DilettaIcon(
                name: DilettaIcons.plusSolid, size: 14, color: cor),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'fileiraDeAvatares',
      props: {'quantos': '${iniciais.length}', 'rotulada': '$_rotulada'},
      tokens: const ['type.labelSm', 'scheme.fg'],
      child: _rotulada ? _comRotulo(s) : _compacta(s),
    );
  }

  Widget _compacta(DilettaScheme s) {
    final filhos = <Widget>[];
    for (var i = 0; i < iniciais.length; i++) {
      if (i > 0) filhos.add(const SizedBox(width: 4));
      filhos.add(DilettaTappable(
        onTap: aoTocarNoAvatar == null ? null : () => aoTocarNoAvatar!(i),
        child: _circulo(i),
      ));
    }
    if (aoAdicionar != null) {
      if (filhos.isNotEmpty) filhos.add(const SizedBox(width: 4));
      filhos.add(DilettaTappable(
          onTap: aoAdicionar, child: _botaoDeAdicionar(s.fg)));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: filhos);
  }

  Widget _comRotulo(DilettaScheme s) {
    const largura = 60.0;
    final itens = <Widget>[];

    Widget celula({
      required Widget topo,
      String? rotulo,
      String? sub,
      VoidCallback? aoTocar,
    }) =>
        DilettaTappable(
          onTap: aoTocar,
          child: SizedBox(
            width: largura,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              topo,
              const SizedBox(height: 6),
              DilettaText(rotulo ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: DilettaType.labelSm.copyWith(color: s.fg)),
              if (sub != null && sub.isNotEmpty)
                DilettaText(sub,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: DilettaType.labelSm
                        .copyWith(color: s.textPlaceholder)),
            ]),
          ),
        );

    for (var i = 0; i < iniciais.length; i++) {
      if (i > 0) itens.add(const SizedBox(width: 8));
      itens.add(celula(
        topo: _circulo(i),
        rotulo: i < rotulos!.length ? rotulos![i] : '',
        sub: (subrotulos != null && i < subrotulos!.length)
            ? subrotulos![i]
            : null,
        aoTocar: aoTocarNoAvatar == null ? null : () => aoTocarNoAvatar!(i),
      ));
    }
    if (aoAdicionar != null) {
      if (itens.isNotEmpty) itens.add(const SizedBox(width: 8));
      itens.add(celula(
          topo: _botaoDeAdicionar(s.fg),
          rotulo: 'Adicionar',
          aoTocar: aoAdicionar));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: itens),
    );
  }
}

/// O anel tracejado do "+". Traço por dentro, pra não engordar o círculo.
class _AnelTracejado extends CustomPainter {
  const _AnelTracejado(this.cor);

  final Color cor;

  @override
  void paint(Canvas canvas, Size size) {
    final tinta = Paint()
      ..color = cor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    // Meia espessura pra dentro: stroke centrado vazaria meio pixel além do avatar vizinho.
    final raio = size.width / 2 - 0.5;
    final centro = Offset(size.width / 2, size.height / 2);
    const traco = 3.4;
    const vao = 3.0;
    const pi = 3.1415926535;
    final circunferencia = 2 * pi * raio;
    final quantos = (circunferencia / (traco + vao)).floor();
    final passo = 2 * pi / quantos;
    final angulo = passo * traco / (traco + vao);
    for (var i = 0; i < quantos; i++) {
      canvas.drawArc(Rect.fromCircle(center: centro, radius: raio), i * passo,
          angulo, false, tinta);
    }
  }

  @override
  bool shouldRepaint(covariant _AnelTracejado o) => o.cor != cor;
}
