/// O CONTEÚDO — as telas do Bold no catálogo.
///
/// Tudo aqui é opcional, e **catálogo vazio é estado de primeira classe**: é assim que
/// um produto começa, com o editor de pé e zero tela. O que não é opcional é a MACRO —
/// publicar sem destino não faz sentido, e o pai tem default de um item justamente pra
/// isso.
///
/// O eixo macro do Bold é a divisão que o produto já tem: a conta PF e a conta PJ são
/// jornadas distintas com telas distintas, e é por aí que alguém procura uma tela. Não é
/// o eixo do primeiro filho (SDK/Standalone/Backoffice) — aquele é a arrumação DELE, e
/// foi justamente o que o pai expulsou do motor.
library;

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

/// O terceiro dos quatro plugues.
void configurarConteudoDoBold() {
  Conteudo.configurar(const PlugueDeConteudo(
    macros: ['PF', 'PJ'],
  ));
}
