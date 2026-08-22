/// CONTA BOLD — a LINHA DE AVISO da home. Segunda das quatro lacunas.
///
/// É a linha das *Autorizações*: vidro de largura cheia, ladrilho quadrado da marca com o glifo
/// branco, título e subtítulo empilhados, e a CONTAGEM à direita quando há o que contar.
///
/// ## Ela não é uma linha de lista, e a diferença é a contagem
///
/// A tentação era `DilettaAppListRow.menuItem`, que tem ícone, título, subtítulo e seta. Mas o que
/// esta peça carrega é um NÚMERO — *"8 esperando você"* — e número à direita numa linha de menu lê
/// como valor, não como fila. O acessório da direita do pai é seta, ícone ou ação; nenhum é
/// contador.
///
/// E o ladrilho do ícone aqui é **cheio da marca**, não o spot tonal da lista. É o que separa
/// "isto está esperando por você" de "isto é mais um item do menu" na mesma dobra da home.
///
/// ## O que a mudança de casa alterou
///
/// **O ladrilho perdeu o `Color(0xFF90093A)` cravado** e passou a ser `BoldVinho.marca`, que é o
/// mesmo valor com dono. O branco do glifo virou `s.palette.white`.
///
/// **O badge virou um `DilettaStatusTag`?** Não — e a razão é medida: o selo do pai tem tom, borda e
/// respiro de pílula, e aqui é um disco de 24 com um número dentro. Continua composto, mas com os
/// tokens do pai em vez de números soltos.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'bold_vinho.dart';

/// A linha-aviso da home.
class CoreflowLinhaDeAviso extends StatelessWidget {
  const CoreflowLinhaDeAviso({
    super.key,
    required this.icone,
    required this.titulo,
    this.subtitulo,
    this.contagem,
    this.aoTocar,
    this.linhasDoSubtitulo = 2,
  });

  /// Nome do glifo no conjunto do pai — branco sobre o ladrilho da marca.
  final String icone;

  final String titulo;
  final String? subtitulo;

  /// Duas por padrão: os subtítulos deste produto ("Aponte para QR, boleto ou código de
  /// autorização") truncavam em uma.
  final int linhasDoSubtitulo;

  /// Some quando nulo ou zero — fila vazia não se anuncia com um zero.
  final int? contagem;

  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    Widget linha = DilettaDevInfo(
      component: 'linhaDeAviso',
      props: {'icone': icone, 'contagem': '${contagem ?? 0}'},
      tokens: const ['radius.all16', 'type.labelMd', 'type.bodySm'],
      child: DilettaGlassSurface(
        borderRadius: DilettaRadius.all16,
        child: Padding(
          padding: EdgeInsets.all(DilettaSpacing.s3),
          child: Row(children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BoldVinho.marcaDe(s.palette),
                borderRadius: DilettaRadius.all8,
              ),
              child: DilettaIcon(
                  name: icone, size: 18, color: s.palette.white),
            ),
            DilettaGap.w(DilettaSpacing.s3),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DilettaText(titulo,
                      maxLines: 1,
                      style: DilettaType.labelMd.copyWith(color: s.fg)),
                  if (subtitulo != null)
                    DilettaText(subtitulo!,
                        maxLines: linhasDoSubtitulo,
                        style: DilettaType.bodySm
                            .copyWith(color: s.textSecondary)),
                ],
              ),
            ),
            if (contagem != null && contagem! > 0) ...[
              DilettaGap.w(DilettaSpacing.s2),
              _Contador(contagem!),
            ],
          ]),
        ),
      ),
    );

    if (aoTocar != null) linha = DilettaTappable(onTap: aoTocar, child: linha);
    return linha;
  }
}

/// O disco com o número. Marca cheia, texto branco.
class _Contador extends StatelessWidget {
  const _Contador(this.quantas);

  final int quantas;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      padding: EdgeInsets.symmetric(horizontal: DilettaSpacing.s1 + 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: BoldVinho.marcaDe(s.palette),
        shape: BoxShape.circle,
      ),
      child: DilettaText('$quantas',
          style: DilettaType.labelMd.copyWith(
              color: s.palette.white, fontWeight: FontWeight.w600)),
    );
  }
}
