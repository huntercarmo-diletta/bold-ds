/// A MEDIÇÃO DESTE FILHO — o relatório de adoção do pai.
///
/// Isto era a minha aba de Fundamentos, e ela saiu: a v0.43.0 do motor entrega Fundamentos como a PROSA
/// que ensina (índice + markdown), e a prosa deste produto virou `kBoldFundamentos` no pacote do DS.
///
/// O que sobrou aqui não é prosa nem inventário: é **conformidade**. O relatório de adoção diz, família
/// por família, se este filho DECLAROU o token ou está herdando o valor de referência do pai.
///
/// **O papel semântico nos dois modos SAIU daqui na v0.48.0 do motor**, quando `SecoesDeEstilo` passou a
/// deixar compor a página de Styles. Ele estava aqui por uma razão que eu tinha escrito e que não
/// resistia à pergunta certa: *"é medição deste filho"* é verdade, e quem quer saber de que cor é a
/// superfície no escuro procura em **Styles**. Ver `styles_do_bold.dart`.
///
/// A fronteira com Styles é do pai, e ele a escreveu melhor do que eu: **Styles é o inventário que se
/// CONSULTA; Fundamentos são as decisões que se leem uma vez.** A minha aba de Styles (tipografia,
/// gradiente, vidro) saiu na v0.39.0 do motor, que passou a entregar a página derivada do
/// `InventarioDeEstilo` — inclusive com o movimento TOCANDO, que uma tabela de duração não mostra.
///
/// O que sobra aqui é o que é decisão e não inventário: a rampa com a razão dela, os papéis NOS DOIS
/// MODOS (papel é derivado, e mostrá-lo sem o modo é meia informação), os dois gradientes modulados, a
/// receita do vidro e o relatório de adoção do pai.
///
/// Nada aqui é lista escrita à mão, e a razão é medida: no primeiro filho o vocabulário de ilustrações
/// do catálogo tinha metade das artes (16 de 32), duas telas pediam arte que ele não conhecia, e elas
/// renderizavam vazias sem erro nenhum. Lista à mão apodrece em silêncio.
///
/// Então:
///
/// - as **rampas** saem de `BoldPalette.bold`, campo por campo;
/// - os **papéis** saem de `DilettaScheme.light/dark(paleta)` — os dois modos, lado a lado;
/// - a **tipografia** sai dos presets do pai, com tamanho e peso lidos do próprio `TextStyle`;
/// - **espaço, raio e ícones** saem dos tokens;
/// - o **relatório de adoção** é do PAI (`relatorioDeAdocao`): ele diz, família por família, se este
///   filho DECLAROU o token ou se está herdando o valor de referência. É onde a estética escorrega sem
///   ninguém ver, e não é coisa que o filho deva escrever sozinho.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';

class PainelDeMedicao extends StatelessWidget {
  const PainelDeMedicao({super.key});

  @override
  Widget build(BuildContext context) {
    // A CASCA é do motor desde a v0.52.0, e a falta era minha: eu tinha escrito o meu próprio cartão
    // branco com scroll e largura máxima, igual ao que o outro filho escreveu. Peça que todo consumidor
    // embrulha do mesmo jeito é peça que veio sem a casca — e agora que ela existe, cartão meu em volta
    // seria cartão em cima de cartão.
    //
    // 980 de largura em vez de 1.400, e o número é dele com razão medida: linha de 1.400px cansa.
    return const PaginaDoCatalogo(
      titulo: 'Conformidade',
      descricao: 'As decisões estão em Fundamentos, e os valores e papéis em Styles. Aqui fica o que só '
          'é conformidade: o que este filho declarou contra o que está herdando do pai.',
      secoes: [
        SecaoDeDoc(
          titulo: 'Adoção dos tokens — o relatório do PAI',
          explica: 'Herdado quer dizer: confira contra o produto antigo antes de aceitar.',
          primeira: true,
          child: _Adocao(),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Gradientes · tipografia · espaço · raio · adoção · ícones
// ═══════════════════════════════════════════════════════════════════════════════

/// A ESCALA TIPOGRÁFICA saiu daqui, e o motivo é a fronteira: a lista de degraus é INVENTÁRIO, e
/// inventário é Styles — a aba do motor a desenha derivada do `InventarioDeEstilo`.
///
/// O que era decisão nesta página — qual degrau do pai substitui cada preset ANTIGO do Bold — não é
/// tabela de tela: é o mapa fixado por `test/o_mapa_da_tipografia_test.dart` no DS e explicado no
/// `ADOCAO.md`. Ele falha se o pai mover tamanho ou peso de algum degrau escolhido, que é a única coisa
/// que uma página não pode fazer.

class _Adocao extends StatelessWidget {
  const _Adocao();

  @override
  Widget build(BuildContext context) {
    final itens = relatorioDeAdocao(BoldPalette.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final i in itens)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: EdgeInsets.all(CM.gapCompacto),
            decoration: BoxDecoration(
              color: switch (i.estado) {
                EstadoDeAdocao.declarado => CC.success07,
                EstadoDeAdocao.herdado => CC.warning07,
                EstadoDeAdocao.naoDeclaravel => CC.neutral10,
              },
              borderRadius: CM.raioBotao,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i.estado.name.toUpperCase()} · ${i.familia}',
                    style: CT.rotuloPequeno.copyWith(color: CC.neutral02)),
                const SizedBox(height: 2),
                Text('vale: ${i.efetivo}', style: CT.corpoPequeno),
                const SizedBox(height: 2),
                Text('confira: ${i.comoConferir}',
                    style: CT.legenda.copyWith(color: CC.neutral05)),
              ],
            ),
          ),
      ],
    );
  }
}

/// A receita do vidro: o trio que este filho declara na paleta.
///
