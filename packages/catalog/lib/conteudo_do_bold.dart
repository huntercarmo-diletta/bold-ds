/// O CONTEÚDO — as telas do Bold no catálogo.
///
/// Tudo aqui é opcional, e **catálogo vazio é estado de primeira classe**: é assim que
/// um produto começa, com o editor de pé e zero tela — e este começou assim por dois dias. O que não é opcional é a MACRO —
/// publicar sem destino não faz sentido, e o pai tem default de um item justamente pra
/// isso.
///
/// O eixo macro do Bold é a divisão que o produto já tem: a conta PF e a conta PJ são
/// jornadas distintas com telas distintas, e é por aí que alguém procura uma tela. Não é
/// o eixo do primeiro filho (SDK/Standalone/Backoffice) — aquele é a arrumação DELE, e
/// foi justamente o que o pai expulsou do motor.
library;

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

import 'telas_do_bold.dart';

/// O terceiro dos quatro plugues.
void configurarConteudoDoBold() {
  Conteudo.configurar(PlugueDeConteudo(
    macros: const ['PF', 'PJ'],
    // A PRIMEIRA TELA, e ela deixou de ser zero em 2026-07-31.
    //
    // O pai mediu a falta na v0.55.0 do motor (*"um filho tem 124 telas, o outro tem ZERO"*), e a
    // consequência que ele nomeou é a que importa: **todo o pipeline de tela tinha um usuário só**, então
    // defeito daquele caminho era invisível deste lado. A HOME está em `telas_do_bold.dart`, com a razão
    // da escolha e o que dela eu não reproduzi.
    especificacoes: telasDoBoldEmJson(),
    // A PRIMEIRA SETA deste produto, e ela é declarada e não derivada.
    //
    // O board deriva as ligações da ORDEM das telas quando ninguém editou, e é o suficiente pra desenhar.
    // Mas a Gramática de composição lê `ligacoesDeclaradas` — o que foi DECIDIDO —, então com a seta só
    // derivada o painel de movimento mostrava `push: setas=0` e o meu `motionDaTransicao` continuava sendo
    // declaração sobre nada.
    //
    // O `bloco` é o id da LINHA do Pix dentro do slot da lista (`b_4`), e não o da lista: a seta ancora no
    // componente que dispara, então apontar pro container faria o desenho dizer que a lista inteira leva ao
    // Pix. Os ids vêm da autoria, na ordem — não se inventam e não se renumeram.
    ligacoesDeclaradas: const {
      'pf/conta-pf': [
        Ligacao(de: 0, para: 1, tipo: TipoConexao.push, bloco: 'b_4'),
      ],
    },
  ));
}
