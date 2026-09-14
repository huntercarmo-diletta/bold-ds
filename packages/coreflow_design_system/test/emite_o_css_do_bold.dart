// ESCREVE `packages/coreflow_design_system_web/tokens/bold-tokens.css`. **Não é gate** — gate é o
// vizinho `o_css_do_bold_esta_em_dia_test.dart`, que roda na suíte e compara o disco com a fonte.
//
//     flutter test test/emite_o_css_do_bold.dart
//
// Sem `_test` no nome de propósito: `flutter test` não o pega, e emitir arquivo dentro da suíte é
// como um repo começa a ter saída gerada que ninguém sabe quando mudou.
import 'dart:io';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// As TAGS que a instância web registra, lidas do `index.js` do pacote do avô.
///
/// A fonte é o pacote, não uma lista nossa: peça nova na tag dele entra aqui sozinha, e peça que
/// sair para de aparecer. Lista paralela é a forma de ficar para trás sem ninguém ver.
Set<String> tagsDaWeb() {
  final f = File('../coreflow_design_system_web/node_modules/diletta-design-system-web/index.js');
  if (!f.existsSync()) return const {};
  return RegExp(r"^\s*'(diletta-[a-z-]+)',", multiLine: true)
      .allMatches(f.readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();
}

/// As famílias que o produto declara, na ordem em que a cascata precisa delas.
String cssDoBold() => [
      coreflowPapeisCss(BoldPalette.bold, produto: 'Conta BOLD'),
      '\n/* O ESQUEMA DESTE PRODUTO — os papéis que o avô não tem. */\n',
      coreflowEsquemaCss(BoldPalette.bold),
      '\n/* MEDIDA por nome. */\n',
      coreflowMedidasCss(BoldPalette.bold),
      '\n/* A ESCALA DE TIPO DESTE PRODUTO. Seis degraus têm px que o avô não tem — decisão escrita\n'
          '   no `///` do `CoreflowType`, não deriva. Os homônimos SOBRESCREVEM os dele. */\n',
      coreflowTipoCss(_degrausDoBold, familia: "'${BoldFonts.familyRaw}', system-ui, sans-serif"),
      // OS AJUSTES POR COMPONENTE, por último: eles redeclaram papel DENTRO de um elemento, então
      // precisam vir depois das declarações de raiz que sobrescrevem. Hoje este produto não declara
      // nenhum e isto sai vazio — o encanamento existe pra que declarar um não peça mais nada.
      _ajustes(),
    ].join();

String _ajustes() {
  final css = coreflowAjustesCss(ContaBold.produto.ajustesDePapel, tagsWeb: tagsDaWeb());
  return css.isEmpty ? '' : '\n/* AJUSTES DE PAPEL POR COMPONENTE. */\n$css';
}

/// Os 20 degraus do `CoreflowType`, por nome. A tabela é explícita porque `TextStyle` estático não se
/// enumera por reflexão em Dart — e tabela que alguém esquece de atualizar é melhor que reflexão que
/// ninguém entende: o gate conta os degraus e reprova se a classe crescer sem esta lista crescer.
final Map<String, TextStyle> _degrausDoBold = {
  'display': CoreflowType.display, 'valorHeroi': CoreflowType.valorHeroi,
  'h1': CoreflowType.h1, 'h2': CoreflowType.h2,
  'headlineMd': CoreflowType.headlineMd, 'headlineSm': CoreflowType.headlineSm,
  'title': CoreflowType.title, 'titleMd': CoreflowType.titleMd,
  'body': CoreflowType.body, 'bodyLg': CoreflowType.bodyLg,
  'bodySm': CoreflowType.bodySm, 'bodySmall': CoreflowType.bodySmall,
  'button': CoreflowType.button, 'label': CoreflowType.label,
  'labelLg': CoreflowType.labelLg, 'labelMd': CoreflowType.labelMd,
  'labelSm': CoreflowType.labelSm, 'tileLabel': CoreflowType.tileLabel,
  'mono': CoreflowType.mono, 'monoCaption': CoreflowType.monoCaption,
};

void main() {
  test('emite o CSS dos tokens do Bold', () {
    final css = cssDoBold();
    final f = File('../coreflow_design_system_web/tokens/bold-tokens.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final vars = RegExp(r'--cps-[A-Za-z0-9-]+\s*:').allMatches(css).length;
    // Controle negativo: folha curta demais não é erro no navegador, é silêncio.
    expect(vars, greaterThan(250), reason: 'a folha saiu curta demais pra ser as quatro famílias');
    stdout.writeln('escrito: ${f.path} — $vars declarações');
  });
}
