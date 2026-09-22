// ESCREVE `web/tokens/norte_benk-tokens.css`. **Não é gate** — gate é o vizinho
// `o_css_esta_em_dia_test.dart`, que roda na suíte e compara o disco com a fonte.
//
//     flutter test test/emite_o_css.dart
//
// Sem `_test` no nome de propósito: `flutter test` não o pega, e emitir arquivo dentro da suíte é
// como um repo começa a ter saída gerada que ninguém sabe quando mudou.
import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:norte_benk_coreflow/norte_benk.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_test/flutter_test.dart';

/// As TAGS que a instância web registra, lidas do `index.js` do pacote do avô — a fonte é o pacote e
/// não uma lista nossa, porque peça nova na tag dele tem que entrar sozinha.
Set<String> tagsDaWeb() {
  final f = File('web/node_modules/diletta-design-system-web/index.js');
  if (!f.existsSync()) return const {};
  return RegExp(r"^\s*'(diletta-[a-z-]+)',", multiLine: true)
      .allMatches(f.readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();
}

/// As famílias que este produto declara, na ordem em que a cascata precisa delas. Nenhum hex é
/// escrito aqui: tudo sai da paleta, pela derivação da linguagem.
String cssDoProduto() => [
      coreflowPapeisCss(norteBenk.paleta, produto: 'Norte Benk'),
      '\n/* O ESQUEMA DESTE PRODUTO — os papéis que o avô não tem. */\n',
      coreflowEsquemaCss(norteBenk.paleta),
      '\n/* MEDIDA por nome. */\n',
      coreflowMedidasCss(norteBenk.paleta),
      '\n/* A FAMÍLIA TIPOGRÁFICA. A ESCALA continua sendo a do avô — ele publica os degraus dele\n'
          '   e este produto os herda (`CoreflowTipografia.doAvo`), então repetir aqui seria repetir\n'
          '   o que não é nosso. A FAMÍLIA é outra história: no Flutter ela é anulável porque o app\n'
          '   empresta a dele, e na web NÃO HÁ APP. Sem esta linha `font-family: var(--diletta-font-family)`\n'
          '   não resolve, e `var()` que não resolve mata a declaração inteira — a tela sai em Times.\n'
          '   Medido no IB em 22/09, antes deste conserto.\n'
          '   ESTE PRODUTO TROCA DE FONTE em `norte_benk.dart`, numa linha só e servindo os dois lados:\n'
          '     tipografia: CoreflowTipografia.doAvo.copyWith(familia: \'packages/norte_benk_coreflow/MinhaFonte\'),\n'
          '   ...e os ARQUIVOS da fonte precisam viajar junto, senão a folha nomeia o que o navegador\n'
          '   não tem. Hoje ele não declara, e recebe a Inter que a família publica. */\n',
      coreflowFamiliaCss(coreflowFamiliaWeb(norteBenk.tipografia.familia)),
      '\n/* O GRADIENTE DESTE PRODUTO, e ele é DERIVADO — não inventado. Quem não desenha curva\n'
          '   própria recebe `CoreflowGradients.daPaleta`: dois degraus da rampa DELE (04 → 05), com\n'
          '   a tinta que a paleta dele declara por cima. Já existia em Dart desde o nascimento; o\n'
          '   que faltava era esta chamada, e por isso o IB lia vazio. */\n',
      coreflowGradientesCss(norteBenk.gradientes),
      '\n/* AS PARADAS DA CURVA, soltas — o degradê inteiro não serve a quem precisa de UMA cor\n'
          '   dele. Saem DUAS, que é o que a curva derivada tem; o Bold tem oito porque desenhou\n'
          '   as oito. Consumidor que pedir `lockup05` está pedindo a curva do Bold, não a da\n'
          '   família. Derivadas da mesma lista do gradiente, então as duas não divergem. */\n',
      coreflowConstantesCss(_paradasDoLockup),
      // OS AJUSTES por componente, por último: eles redeclaram papel DENTRO de um elemento, então
      // vêm depois das declarações de raiz que sobrescrevem. Sem ajuste declarado sai vazio.
      _ajustes(),
    ].join();

/// A folha COM a ponte `--cps-x: var(--diletta-x)` — o que vai para o disco, como no Bold
/// (`3629a23`): quem já escreveu com o nome antigo continua resolvendo.
String cssDoProdutoComPonte() {
  final css = cssDoProduto();
  return css + coreflowPonteDoNomeAntigo(css);
}

/// As paradas da curva DESTE produto, nomeadas `lockup01`, `lockup02`… — derivadas de
/// `norteBenk.gradientes.paradasDoLockup`, e não escritas à mão: escrever seria abrir uma segunda
/// fonte que pode divergir do gradiente emitido logo acima.
Map<String, Color> get _paradasDoLockup => {
  for (var i = 0; i < norteBenk.gradientes.paradasDoLockup.length; i++)
    'lockup${(i + 1).toString().padLeft(2, '0')}': norteBenk.gradientes.paradasDoLockup[i],
};

String _ajustes() {
  final css = coreflowAjustesCss(norteBenk.ajustesDePapel, tagsWeb: tagsDaWeb());
  return css.isEmpty ? '' : '\n/* AJUSTES DE PAPEL POR COMPONENTE. */\n$css';
}

void main() {
  test('emite o CSS dos tokens do Norte Benk', () {
    final css = cssDoProdutoComPonte();
    final f = File('web/tokens/norte_benk-tokens.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final daLinguagem = RegExp(r'--diletta-([A-Za-z0-9_-]+)\s*:').allMatches(css).length;
    Set<String> nomesUnicos(String prefixo) =>
        RegExp('$prefixo([A-Za-z0-9_-]+)\\s*:').allMatches(css).map((m) => m.group(1)!).toSet();
    final nomes = nomesUnicos('--diletta-');
    final apelidos = nomesUnicos('--cps-');
    // Controle negativo: folha curta demais não é erro no navegador, é silêncio.
    expect(daLinguagem, greaterThan(100), reason: 'a folha saiu curta demais pra ser os papéis');
    expect(apelidos, nomes, reason: 'a ponte não cobriu todos os nomes emitidos');
    stdout.writeln('escrito: ${f.path} — ${nomes.length} nomes, $daLinguagem declarações, ${apelidos.length} apelidos');
  });
}
