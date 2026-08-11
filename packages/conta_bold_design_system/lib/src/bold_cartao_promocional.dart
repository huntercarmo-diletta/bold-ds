/// CONTA BOLD — o CARTÃO PROMOCIONAL do carrossel da home. Quarta e última lacuna.
///
/// Vidro, título e subtítulo à esquerda, ilustração de 100 à direita, e um **X** no canto. Sem
/// botão: o cartão inteiro é o alvo.
///
/// ## Por que ele não é o `DilettaPromoBanner`
///
/// O banner do pai tem título, subtítulo, ilustração e um BOTÃO — e não tem como fechar. Este tem
/// como fechar e não tem botão, e as duas metades da diferença são a mesma decisão de produto:
///
/// - o banner do pai é uma **chamada** que espera ser atendida (*"Ative sua conta"* → `Continuar`);
/// - este é uma **sugestão** que espera ser dispensada (*"Habilite sua passkey"* → X).
///
/// Um card que se dispensa sem ação e um card com CTA sem dispensa são peças opostas com a mesma
/// silhueta. Está pedido ao pai como `aoFechar` no banner dele — se entrar, esta peça vira casca e
/// some. Enquanto isso ela mora aqui, com a razão escrita.
///
/// ## O que a mudança de casa alterou
///
/// **O vidro deixou de ser montado à mão.** Eram `ClipRRect` + `BackdropFilter` + `DecoratedBox` com
/// fill, borda e blur lidos de `BoldGlass` — a mesma superfície que o `DilettaGlassSurface` do pai
/// monta, escrita de novo do lado de cá.
///
/// **O placeholder da ilustração ficou.** Ele existe porque a arte do carrossel é do app (asset de
/// produto, não do DS), e um cartão sem arte no catálogo é um buraco de 100×100 sem explicação.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// O cartão de sugestão do carrossel.
class BoldCartaoPromocional extends StatelessWidget {
  const BoldCartaoPromocional({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.ilustracao,
    this.aoFechar,
    this.aoTocar,
  });

  final String titulo;
  final String? subtitulo;

  /// A arte, 100×100. Vem do app — o DS não carrega asset de produto.
  final Widget? ilustracao;

  final VoidCallback? aoFechar;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    Widget cartao = DilettaDevInfo(
      component: 'cartaoPromocional',
      props: {'fecha': '${aoFechar != null}'},
      tokens: const ['radius.all16', 'type.headlineSm', 'type.bodySm'],
      child: DilettaGlassSurface(
        borderRadius: DilettaRadius.all16,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.all(DilettaSpacing.s4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DilettaText(titulo,
                        style: DilettaType.headlineSm.copyWith(color: s.fg)),
                    if (subtitulo != null) ...[
                      DilettaGap.h(DilettaSpacing.s1),
                      DilettaText(subtitulo!,
                          style: DilettaType.bodySm
                              .copyWith(color: s.textSecondary)),
                    ],
                  ],
                ),
              ),
              DilettaGap.w(DilettaSpacing.s3),
              SizedBox(
                width: 100,
                height: 100,
                child: ilustracao ?? const _MolduraSemArte(),
              ),
            ]),
          ),
          if (aoFechar != null)
            Positioned(
              top: 0,
              right: 0,
              // 36×36 de alvo com o glifo a 10 do canto: o X tem 16, e 16 de alvo seria metade do
              // mínimo. O alvo é maior que o desenho, como no chip de filtro.
              child: DilettaTappable(
                onTap: aoFechar,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: DilettaIcon(
                          name: DilettaIcons.xmarkLight,
                          size: 16,
                          color: s.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );

    if (aoTocar != null) cartao = DilettaTappable(onTap: aoTocar, child: cartao);
    return cartao;
  }
}

/// A moldura de 100×100 quando a arte não veio.
class _MolduraSemArte extends StatelessWidget {
  const _MolduraSemArte();

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: s.surfaceLoading,
        borderRadius: DilettaRadius.all16,
        border: Border.all(color: s.border),
      ),
      child: Center(
        child: DilettaIcon(
            name: DilettaIcons.imageLight, size: 34, color: s.textPlaceholder),
      ),
    );
  }
}
