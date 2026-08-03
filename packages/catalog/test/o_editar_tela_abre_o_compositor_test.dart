import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_catalog/telas_do_bold.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// O "✎ EDITAR TELA" ERA UM BOTÃO MORTO — e o modo de falhar dele é o pior que existe.
///
/// Achado clicando, não lendo: o dono do produto abriu a aba Telas, clicou em editar e **nada aconteceu**.
/// Nenhum erro, nada no console, nenhuma aba trocada.
///
/// As duas metades estavam prontas e o fio no meio não existia:
///
/// - o board do pai faz a parte dele — `ComposerInbox.requestEditSpec` guarda a tela e chama `openBuilder`;
/// - `openBuilder` é gancho que a CASCA do filho pluga, porque quem sabe o id da aba do compositor é quem
///   declara as abas. Eu nunca o pluguei, então a caixa de entrada enchia em silêncio.
///
/// É a mesma classe dos 6 campos calados do plugue de conteúdo, um nível acima: **capacidade pronta nos
/// dois lados, sem o fio no meio.** Este gate é o fio, medido de ponta a ponta — pede a edição pelo canal
/// que o board usa e exige que o destino seja uma aba que EXISTE.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  test('pedir edição de tela troca a aba pro compositor, e a aba existe', () {
    final cfg = configDoCatalogoDoBold();
    expect(cfg.navegacao, isNotNull,
        reason: 'sem canal de navegação declarado, o botão do board não tem pra onde pedir');
    expect(ComposerInbox.instance.openBuilder, isNotNull,
        reason: 'o gancho é do filho: o pai não pode saber o id da aba do compositor');

    // O caminho REAL: é isto que o `_editSelected` do board chama.
    ComposerInbox.instance.requestEditSpec(
      name: 'PF1 · Home',
      spec: telasDoBold()[kSlugDaHome]!,
      originId: kSlugDaHome,
      specId: kSlugDaHome,
    );

    final destino = cfg.navegacao!.destino;
    expect(destino, isNotNull, reason: 'o clique não pediu aba nenhuma — é o botão morto de novo');
    expect(cfg.abas.map((a) => a.id), contains(destino),
        reason: 'a casca pede uma aba que não existe: $destino');
    expect(destino, 'montar');

    // E a tela chegou de verdade na caixa, com a spec (não como código cru).
    expect(ComposerInbox.instance.hasPending, isTrue);
    final pendente = ComposerInbox.instance.take();
    expect(pendente?.spec, isNotNull,
        reason: 'edição por SPEC abre a tela real; por código abriria um bloco sem preview');
    expect(pendente?.originId, kSlugDaHome);
    expect(ComposerInbox.instance.hasPending, isFalse, reason: 'a caixa consome o pendente');
  });

  test('toda tela do board declara o specId, e ele existe na FONTE', () {
    // O segundo defeito do mesmo clique: `Anotar` respondia "Selecione uma tela spec-first pra anotar".
    // A nota se guarda por slug, e o board lê o slug do `specId` — que eu não declarava porque usava o
    // `handoffFromSpec`, que monta a tela com spec inline e sem chave.
    //
    // Sem o specId ficam mudos: anotar, o status da tela e o "salvar no repo" (que precisa saber qual
    // entrada do arquivo-fonte a edição substitui).
    final grupos = gruposDeTelasDoBold();
    expect(grupos, isNotEmpty);
    var telas = 0;
    for (final g in grupos) {
      for (final tela in g.screens) {
        telas++;
        expect(tela.specId, isNotNull, reason: '"${tela.label}" sem specId: o board a trata como mock');
        expect(Conteudo.especificacoes.containsKey(tela.specId), isTrue,
            reason: '"${tela.label}" aponta pra ${tela.specId}, que não está no arquivo-fonte');
        // E NÃO tem mock: o preview prefere o `child` à spec, então um snapshot aqui esconderia o que o
        // arquivo diz. Tela spec-first renderiza a fonte.
        expect(tela.child, isNull, reason: '"${tela.label}" tem mock e é spec-first');
      }
    }
    expect(telas, Conteudo.especificacoes.length,
        reason: 'o board mostra menos (ou mais) telas do que a fonte tem');
  });

  test('e o gate SABE reprovar — controle sem o fio plugado', () {
    // Sem o controle, o teste acima passaria se `openBuilder` fosse plugado por acidente em outro lugar.
    final orfa = NavegacaoDoCatalogo();
    expect(orfa.destino, isNull);
    orfa.abrir('montar');
    expect(orfa.destino, 'montar');
    orfa.consumido();
    expect(orfa.destino, isNull);
  });
}
