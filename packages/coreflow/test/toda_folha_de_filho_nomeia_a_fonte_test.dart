// TODA FOLHA DE FILHO DECLARA A FAMÍLIA TIPOGRÁFICA — SENÃO A TELA SAI EM TIMES.
//
// No Flutter, um produto que não declara família herda a do app: `CoreflowTipografia.familia` é
// anulável de propósito, e o avô NÃO emite família nenhuma. Isso está certo lá.
//
// **Na web não existe app para herdar.** A folha do IB escreve `font-family:
// var(--diletta-font-family)`, e variável que não resolve não é erro no console: `var()` sem valor
// mata a declaração inteira, em silêncio. O navegador cai no serifado padrão.
//
// Foi o que aconteceu com o SEGUNDO filho da família. Em 22/09 o IB passou a carregar a folha da
// Norte Benk — cor certa, marca certa, domínio certo — e a tela inteira saiu em Times, com toda a
// configuração correta. Uma linha injetada à mão no navegador resolveu tudo.
//
// A escala não é o problema e nunca foi: o avô publica os 92 tokens `--diletta-type-*` dele, e quem
// herda os degraus recebe todos. Era UM nome faltando, e ele não tinha dono — o avô não o declara
// por decisão, e o filho não o emitia por esquecimento do molde.
//
// Este gate é o dono. Ele não olha QUAL fonte: um filho troca a dele numa linha
// (`CoreflowTipografia.doAvo.copyWith(familia: ...)`) e isto continua verde. Ele olha se ALGUMA foi
// declarada, que é o que separa a tela desenhada da tela em Times.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// As folhas de token de todo filho — `packages/*/web/tokens/*.css` e a do exemplo versionado.
/// Varredura, e não lista: filho novo entra sozinho, que é o ponto do gate.
List<File> _folhasDosFilhos() {
  final fora = <File>[];
  void colher(Directory tokens) {
    if (!tokens.existsSync()) return;
    fora.addAll(tokens
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('-tokens.css')));
  }

  for (final d in Directory('..').listSync().whereType<Directory>()) {
    colher(Directory('${d.path}/web/tokens'));
    // E O PRIMEIRO FILHO, que não segue o padrão dos gerados: o lado web dele é um PACOTE à parte
    // (`coreflow_design_system_web`), nascido antes do molde existir. Sem esta linha o gate cobriria
    // só os filhos novos e deixaria de fora justamente o que todo mundo olha.
    colher(Directory('${d.path}/tokens'));
  }
  colher(Directory('../../exemplos/filho_do_coreflow/web/tokens'));
  return fora..sort((a, b) => a.path.compareTo(b.path));
}

void main() {
  final folhas = _folhasDosFilhos();

  test('a varredura acha folha de verdade — senão o gate aprova por cegueira', () {
    // Controle negativo. Sem ele, um dia em que a varredura pare de achar qualquer coisa — pasta
    // renomeada, sufixo mudado — vira aprovação silenciosa de todos os filhos de uma vez.
    expect(folhas, isNotEmpty, reason: 'nenhuma `*/web/tokens/*-tokens.css` foi encontrada');
    expect(folhas.where((f) => f.path.contains('norte_benk')), isNotEmpty,
        reason: 'a folha do segundo filho sumiu da varredura — é ela que deu origem a este gate');
    expect(folhas.where((f) => f.path.contains('filho_do_coreflow')), isNotEmpty,
        reason: 'a folha do exemplo gerado sumiu — é ela que prova o MOLDE, e não só as instâncias');
    expect(folhas.where((f) => f.path.contains('bold-tokens')), isNotEmpty,
        reason: 'a folha do primeiro filho sumiu da varredura — ela mora fora do padrão e é a que '
            'mais gente olha');
  });

  for (final folha in folhas) {
    // Pelo NOME DO ARQUIVO, e não pela pasta: o lado web do primeiro filho mora numa profundidade
    // diferente da dos gerados, e contar pastas dava `..` como nome do produto.
    final nome = folha.uri.pathSegments.last;
    test('$nome declara a família tipográfica', () {
      final css = folha.readAsStringSync();
      final decl = RegExp(r'--diletta-font-family:\s*([^;]+);').firstMatch(css);
      expect(decl, isNotNull,
          reason: 'a folha ${folha.path} não declara `--diletta-font-family`. Na web ninguém mais a '
              'declara — nem o avô, por decisão —, então a tela deste produto sai em Times. O '
              'emissor deste filho precisa de `coreflowFamiliaCss(coreflowFamiliaWeb(...))`.');
      // E o valor não pode ser vazio: declarar `--diletta-font-family: ;` passaria o teste de
      // presença e falharia na tela exatamente igual.
      expect(decl!.group(1)!.trim(), isNotEmpty,
          reason: 'a família saiu declarada e VAZIA em ${folha.path} — o navegador cai no mesmo '
              'serifado de quando ela não existe');
    });
  }
}
