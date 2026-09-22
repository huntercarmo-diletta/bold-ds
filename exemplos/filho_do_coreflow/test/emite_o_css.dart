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
      coreflowPapeisCss(meuBanco.paleta, produto: 'Meu Banco'),
      '\n/* O ESQUEMA DESTE PRODUTO — os papéis que o avô não tem. */\n',
      coreflowEsquemaCss(meuBanco.paleta),
      '\n/* MEDIDA por nome. */\n',
      coreflowMedidasCss(meuBanco.paleta),
      '\n/* A FAMÍLIA TIPOGRÁFICA. A ESCALA é a do avô — ele publica os degraus dele e este produto\n'
          '   os herda (`CoreflowTipografia.doAvo`), então repetir aqui seria repetir o que não é\n'
          '   nosso. A FAMÍLIA é outra história: no Flutter ela é anulável porque o app empresta a\n'
          '   dele, e NA WEB NÃO HÁ APP. Sem esta linha `var(--diletta-font-family)` não resolve, e\n'
          '   `var()` que não resolve mata a declaração inteira — a tela sai em Times. Aconteceu com\n'
          '   o segundo filho da família, em 22/09, com toda a configuração correta.\n'
          '   ESTE PRODUTO TROCA DE FONTE numa linha só, servindo Flutter e web:\n'
          '     tipografia: CoreflowTipografia.doAvo.copyWith(familia: \'packages/<pacote>/MinhaFonte\'),\n'
          '   ...e os ARQUIVOS da fonte precisam viajar no pacote web, senão a folha nomeia o que o\n'
          '   navegador não tem. Sem declarar, recebe a Inter que a família publica.\n'
          '   A ESCALA PRÓPRIA, se um dia este produto quiser a dele, entra ao lado com\n'
          '   `coreflowTipoCss(meusDegraus, familia: ...)` — e junto com ela o import de\n'
          '   `package:flutter/widgets.dart` (de onde vêm `TextStyle` e `FontWeight`) e a tabela\n'
          '   `_degraus` do `o_desenho_da_web_e_o_do_mobile_test.dart`, senão o gate de lá dorme. */\n',
      coreflowFamiliaCss(coreflowFamiliaWeb(meuBanco.tipografia.familia)),
      '\n/* A RAMPA DE MARCA, nove degraus por nome. Constante de marca — sem bloco de modo:\n'
          '   a rampa É a identidade, e quem inverte por brilho são os papéis derivados dela.\n'
          '   Ela existe para quem precisa DESENHAR com a tinta deste produto (um fundo, um\n'
          '   brilho), e não só pintar componente com papel. */\n',
      coreflowRampaCss(meuBanco.paleta),
      '\n/* O GRADIENTE DESTE PRODUTO, e ele é DERIVADO — não inventado. Quem não desenha curva\n'
          '   própria recebe `CoreflowGradients.daPaleta`: dois degraus da rampa DELE (04 → 05), com\n'
          '   a tinta que a paleta dele declara por cima. */\n',
      coreflowGradientesCss(meuBanco.gradientes),
      '\n/* AS PARADAS DA CURVA, soltas — o degradê inteiro não serve a quem precisa de UMA cor\n'
          '   dele. Saem tantas quantas a curva deste produto tiver: duas, na derivada. Consumidor\n'
          '   que pedir uma parada além dessas está pedindo a curva de OUTRO produto. */\n',
      coreflowConstantesCss(_paradasDoLockup),
      // OS AJUSTES por componente, por último: eles redeclaram papel DENTRO de um elemento, então
      // vêm depois das declarações de raiz que sobrescrevem. Sem ajuste declarado sai vazio.
      _ajustes(),
    ].join();

/// As paradas da curva DESTE produto, nomeadas `lockup01`, `lockup02`… — derivadas do gradiente
/// emitido acima, e não escritas à mão: escrever abriria uma segunda fonte que pode divergir dele.
Map<String, Color> get _paradasDoLockup => {
  for (var i = 0; i < meuBanco.gradientes.paradasDoLockup.length; i++)
    'lockup${(i + 1).toString().padLeft(2, '0')}': meuBanco.gradientes.paradasDoLockup[i],
};

String _ajustes() {
  final css = coreflowAjustesCss(meuBanco.ajustesDePapel, tagsWeb: tagsDaWeb());
  return css.isEmpty ? '' : '\n/* AJUSTES DE PAPEL POR COMPONENTE. */\n$css';
}

void main() {
  test('emite o CSS dos tokens do Meu Banco', () {
    final css = cssDoProduto();
    final f = File('web/tokens/meu_banco-tokens.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final vars = RegExp(r'--diletta-[A-Za-z0-9_-]+\s*:').allMatches(css).length;
    // Controle negativo: folha curta demais não é erro no navegador, é silêncio.
    expect(vars, greaterThan(100), reason: 'a folha saiu curta demais pra ser os papéis');
    stdout.writeln('escrito: ${f.path} — $vars declarações');
  });
}
