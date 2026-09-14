// ESCREVE `web/tokens/meu_banco-tokens.css`. **Não é gate** — gate é o vizinho
// `o_css_esta_em_dia_test.dart`, que roda na suíte e compara o disco com a fonte.
//
//     flutter test test/emite_o_css.dart
//
// Sem `_test` no nome de propósito: `flutter test` não o pega, e emitir arquivo dentro da suíte é
// como um repo começa a ter saída gerada que ninguém sabe quando mudou.
import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:meu_banco_coreflow/meu_banco.dart';
import 'package:flutter_test/flutter_test.dart';

/// As famílias que este produto declara, na ordem em que a cascata precisa delas. Nenhum hex é
/// escrito aqui: tudo sai da paleta, pela derivação da linguagem.
String cssDoProduto() => [
      coreflowPapeisCss(meuBanco.paleta, produto: 'Meu Banco'),
      '\n/* O ESQUEMA DESTE PRODUTO — os papéis que o avô não tem. */\n',
      coreflowEsquemaCss(meuBanco.paleta),
      '\n/* MEDIDA por nome. */\n',
      coreflowMedidasCss(meuBanco.paleta),
      // A ESCALA DE TIPO entra quando este produto declarar a dele em `tipografia:`. Sem declaração,
      // a escala é a do avô e ela já vem na folha dele — emitir de novo seria repetir o que não é
      // nosso. Quando declarar, acrescente aqui:
      //
      //   coreflowTipoCss(meusDegraus, familia: "'MinhaFonte', system-ui, sans-serif"),
    ].join();

void main() {
  test('emite o CSS dos tokens do Meu Banco', () {
    final css = cssDoProduto();
    final f = File('web/tokens/meu_banco-tokens.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final vars = RegExp(r'--cps-[A-Za-z0-9-]+\s*:').allMatches(css).length;
    // Controle negativo: folha curta demais não é erro no navegador, é silêncio.
    expect(vars, greaterThan(100), reason: 'a folha saiu curta demais pra ser os papéis');
    stdout.writeln('escrito: ${f.path} — $vars declarações');
  });
}
