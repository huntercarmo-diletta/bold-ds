import 'package:flutter/widgets.dart';

import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaIconButton, DilettaIconButtonSize, DilettaIconButtonType, DilettaSpacing;

import 'bold_pegador.dart' show CoreflowPegador;
/// **O CABEÇALHO DE UMA FOLHA** — o pegador, o fechar e o título, escritos pelo time do app.
///
/// Chegou por merge em 02/09, de `lib/design_system/widgets/bold_sheet_header.dart`. E ele traz uma
/// coincidência que vale registrar: **o `BoldSheetGrip` do time e o `CoreflowPegador` desta casa são
/// a mesma peça, extraída no mesmo dia, dos mesmos cinco sítios, com a mesma tinta**
/// (`textMuted` a 50%) e o mesmo `pillR`.
///
/// Dois lados chegando ao mesmo pixel sem combinar é a melhor evidência que este DS já teve de que
/// a peça estava faltando. O `CoreflowPegador` fica; o nome do time some.

/// Conta BOLD — peças canônicas do TOPO de uma gaveta (bottom sheet): o grip
/// iOS e o botão de fechar.
///
/// Regra do DS (única, sem exceção): **toda gaveta fecha pelo canto superior
/// DIREITO, num círculo cinza com um xis no meio** (`CoreflowFecharFolha`). Antes
/// cada gaveta resolvia isso do seu jeito — X solto à esquerda no
/// `BoldTopBar.sheet`, X solto à direita no `BoldSheet`, e nada em quem montou
/// o container à mão.
///
/// Quem abre pelo `BoldSheet`/`BoldTopBar.sheet` já recebe tudo isto de graça.
/// Estas peças existem para as gavetas que **não** passam por eles — as que
/// precisam de container próprio (`DraggableScrollableSheet`, altura fixa,
/// lista com controller) — poderem ter o MESMO topo com uma linha.



/// Grip iOS do topo da gaveta (40×4, cantos redondos). Fonte única: [BoldSheet],
/// [BoldTopBar.sheet] e as gavetas de container próprio desenham este.
/// Fechar canônico de gaveta: círculo cinza chapado (32) + xis no meio, sempre
/// no canto superior DIREITO.
///
/// ```dart
/// CoreflowFecharFolha(onPressed: () => Navigator.of(ctx).pop());
/// ```
class CoreflowFecharFolha extends StatelessWidget {
  const CoreflowFecharFolha({
    super.key,
    this.onPressed,
    this.semanticLabel = 'Fechar',
  });

  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    // `BoldIconButton` virou `DilettaIconButton` na B2; o `neutralFill` do filho
    // morreu com ele — o disco cinza do pai é o `secondary` (surfaceMuted + traço).
    // Nome do PAI (não o apelido `close`): `DilettaIconButton` não conhece o
    // mapa de apelidos do app — apelido aqui desenha NADA.
    return DilettaIconButton(
      icon: 'xmark-light',
      semanticLabel: semanticLabel,
      type: DilettaIconButtonType.secondary,
      size: DilettaIconButtonSize.sm,
      onPressed: onPressed,
    );
  }
}

/// Faixa superior de uma gaveta montada à mão: grip centrado + [CoreflowFecharFolha]
/// à direita, na mesma altura que o [BoldSheet] reserva.
///
/// Substitui o par "grip desenhado na mão + nenhum fechar" que cada gaveta de
/// container próprio repetia:
///
/// ```dart
/// child: Column(children: [
///   BoldSheetHeader(onClose: () => Navigator.of(ctx).pop()),
///   ... // título e conteúdo da gaveta
/// ]),
/// ```
class CoreflowCabecalhoDeFolha extends StatelessWidget {
  const CoreflowCabecalhoDeFolha({
    super.key,
    this.onClose,
    this.padding = const EdgeInsets.only(right: DilettaSpacing.s3),
  });

  /// Sem `onClose` a faixa vira só o grip (gaveta que não pode ser dispensada).
  final VoidCallback? onClose;

  /// Respiro do fechar até a borda da gaveta. Passe [EdgeInsets.zero] quando a
  /// faixa já está DENTRO do padding horizontal do container — senão o círculo
  /// afasta duas vezes da borda.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 44 = o mesmo que o [BoldSheet] gasta entre o topo do painel e o começo
      // do conteúdo (grip 10+4+6 + linha do título com o botão de 32).
      height: 44,
      child: Padding(
        padding: padding,
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: CoreflowPegador(),
              ),
            ),
            if (onClose != null)
              Positioned(
                right: 0,
                top: 6,
                child: CoreflowFecharFolha(onPressed: onClose),
              ),
          ],
        ),
      ),
    );
  }
}
