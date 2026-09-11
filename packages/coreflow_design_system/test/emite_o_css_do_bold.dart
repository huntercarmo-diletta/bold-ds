// ESCREVE `packages/coreflow_design_system_web/tokens/bold-papeis.css`. **Não é gate** — gate é o vizinho
// `o_css_do_bold_esta_em_dia_test.dart`, que roda na suíte e compara o disco com a fonte.
//
//     flutter test test/emite_o_css_do_bold.dart
//
// Sem `_test` no nome de propósito: `flutter test` não o pega, e emitir arquivo dentro da suíte é
// como um repo começa a ter saída gerada que ninguém sabe quando mudou.
import 'dart:io';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emite o CSS dos papéis do Bold', () {
    final css = coreflowPapeisCss(BoldPalette.bold, produto: 'Conta BOLD');
    final f = File('../coreflow_design_system_web/tokens/bold-papeis.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final vars = RegExp(r'--cps-[A-Za-z0-9]+\s*:').allMatches(css).length;
    // Controle negativo: se a lista de papéis esvaziar ou o resolvedor parar de achar cor, o arquivo
    // vira uma folha vazia — e folha vazia não é erro no navegador, é silêncio.
    expect(vars, greaterThan(100), reason: 'a folha saiu curta demais pra ser os papéis');
    stdout.writeln('escrito: ${f.path} — $vars declarações');
  });
}
