import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;

/// **CoreflowEspaco** — os dois respiros que este produto DECIDIU, e que a grade do pai não decide.
///
/// A grade é a dele (`DilettaSpacing`, 4-based). O que mora aqui não é um degrau novo: é o degrau
/// que ganhou NOME porque uma pergunta do produto foi respondida nele.
///
/// A diferença importa, e ela custou um gate vermelho pra ficar clara. Na passada de 01/09 os dois
/// nomes viraram o número da grade (`gutter` → `DilettaSpacing.s6`), e o gate
/// `o gutter das telas é um` reprovou na hora: **`s6` e `gutter` valem 24 e não dizem a mesma
/// coisa.** Um é um degrau; o outro é a resposta a *"qual é a margem lateral de uma tela deste
/// produto?"*. Trocar o nome pelo valor apaga a resposta e deixa a próxima tela livre pra escolher
/// 20 de novo — que é exatamente o empate que existia antes da decisão.
class CoreflowEspaco {
  CoreflowEspaco._();

  /// A MARGEM LATERAL DE UMA TELA: 24.
  ///
  /// Decisão do dono em 19/08, e ela desempatou uma medição: dos sítios de padding horizontal de
  /// tela, **38 usavam 20 e 38 usavam 24**, com cara de família (entrada em 24, transacional em 20).
  /// Não havia padrão, havia dois. O 24 ganhou porque é o gutter do CHROME da linguagem — barra de
  /// topo, barra de baixo e status bar usam `s6` as três —, e com o conteúdo em 20 todo cabeçalho
  /// ficava 4px pra dentro do que vinha embaixo dele.
  static const double gutter = DilettaSpacing.s6;

  /// O respiro do RODAPÉ: 32. O fim da rolagem de uma tela longa, pra o último item não encostar na
  /// barra de baixo.
  static const double respiroDoRodape = DilettaSpacing.s8;
}
