/// CONTA BOLD — o GRUPO DO DIA do extrato: o rótulo da data, o saldo consolidado à direita, e os
/// lançamentos daquele dia separados por fio.
///
/// ## O acessório à direita é o que impede a subida pro pai
///
/// O `DilettaAppList` tem `title`, e não tem onde pôr um conteúdo na MESMA linha dele. É a única
/// razão de esta peça existir: ela não é uma lista com outro estilo, é uma lista cujo cabeçalho
/// carrega um valor.
///
/// Ela veio de `app-newbold/lib/design_system/` por causa das telas de loja — o catálogo consome o
/// PACOTE, e o extrato é uma das quatro. Mesmo caso da fileira de avatares: peça adotada do lado
/// errado da fronteira.
///
/// ## A regra do divisor, e o defeito que ela escondia
///
/// **Divisor depois de todo lançamento menos o último — e também no dia de lançamento único**, onde
/// ele não separa dois itens: ele fecha o grupo por baixo.
///
/// A regra estava certa e a COR estava errada: era `Color(0x1FFFFFFF)`, branco a 12% cravado, que no
/// escuro se lê como fio e no claro é branco sobre branco. O extrato ficou sem separação entre
/// lançamentos do mesmo dia até um print do dono mostrar. Agora é o `DilettaDivider`, que tira a cor
/// do tema, e há gate nos dois temas e nos três tamanhos de grupo (1, 2 e 3 lançamentos) — porque um
/// exemplo testa o exemplo, e com dois lançamentos "todos menos o último" e "entre pares" dão o
/// mesmo número.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// O grupo de um dia no extrato.
class BoldGrupoDoDia extends StatelessWidget {
  const BoldGrupoDoDia({
    super.key,
    required this.rotulo,
    required this.filhos,
    this.acessorio,
  });

  /// A data — *"Sexta, 8 de agosto"*.
  final String rotulo;

  /// Os lançamentos do dia.
  final List<Widget> filhos;

  /// Na MESMA linha do rótulo, à direita: o saldo consolidado do dia. É esta prop que impede a
  /// subida pro pai.
  final Widget? acessorio;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    const fio = DilettaDivider();

    return DilettaDevInfo(
      component: 'grupoDoDia',
      props: {'lancamentos': '${filhos.length}'},
      tokens: const ['type.bodySm', 'scheme.textPlaceholder'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(children: [
              DilettaText(rotulo,
                  style:
                      DilettaType.bodySm.copyWith(color: s.textPlaceholder)),
              if (acessorio != null) ...[const Spacer(), acessorio!],
            ]),
          ),
          const SizedBox(height: 4),
          for (var i = 0; i < filhos.length; i++) ...[
            filhos[i],
            // Ver o `///`: o dia de UM lançamento leva fio, e é o oposto do que o nome da regra
            // sugere — ali ele fecha o grupo, não separa.
            if (i < filhos.length - 1 || filhos.length == 1) fio,
          ],
        ],
      ),
    );
  }
}
