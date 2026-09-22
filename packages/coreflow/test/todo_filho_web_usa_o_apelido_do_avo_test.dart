// TODO LADO WEB DE FILHO USA O APELIDO `#avo` — SENÃO ELE NÃO É PUBLICÁVEL.
//
// Em 18/09 o repositório do avô foi trancado: só quem faz DS entra. Um pacote que DECLARE o avô
// como dependência deixa de instalar para a esteira e para o time do produto.
//
// Em 20/09 o `tool/espelha_o_web.sh` passou a EMBUTIR o avô na tag, e o mecanismo tem duas metades:
//
//     no repo   imports: {"#avo": "diletta-design-system-web"}   → a dependência
//     na tag    imports: {"#avo": "./avo/index.js"}              → a cópia embutida
//     index.js  export * from '#avo';                            ← a MESMA linha nos dois lados
//
// **O apelido é o que faz a linha não mudar**, e o espelho o cobra com um assert literal:
// `assert "'#avo'" in (raiz / "index.js").read_text()`.
//
// E O CONSERTO DE 20/09 FOI PARA A INSTÂNCIA E NÃO PARA O MOLDE. Ele entrou no
// `coreflow_design_system_web` e nunca entrou no `novo_filho.dart` — conferido por busca de
// conteúdo no histórico. Resultado: o exemplo versionado e o `norte_benk_coreflow`, os dois
// nascidos do molde, escreviam o nome do pacote direto. **Nenhum filho gerado era publicável**, e
// ninguém soube até alguém perguntar por que o HML da NorteBenk saía com a cor do Bold.
//
// É a classe que esta família já nomeou: «o conserto não é de oito peças, é de uma função». Este
// gate é o que faz o próximo filho nascer certo sem ninguém lembrar.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Os lados WEB de todo filho neste repositório — `packages/*/web/` e o exemplo versionado.
List<Directory> _ladosWeb() {
  final fora = <Directory>[];
  for (final d in Directory('..').listSync().whereType<Directory>()) {
    final web = Directory('${d.path}/web');
    if (web.existsSync() && File('${web.path}/package.json').existsSync()) fora.add(web);
  }
  final exemplo = Directory('../../exemplos/filho_do_coreflow/web');
  if (exemplo.existsSync()) fora.add(exemplo);
  return fora..sort((a, b) => a.path.compareTo(b.path));
}

void main() {
  final lados = _ladosWeb();

  test('a varredura acha lado web de verdade — senão o gate aprova por cegueira', () {
    expect(lados, isNotEmpty, reason: 'nenhum `*/web/` com `package.json` foi encontrado');
    expect(lados.map((d) => d.path).where((p) => p.contains('norte_benk')), isNotEmpty,
        reason: 'a NorteBenk sumiu da varredura — o caminho mudou e este gate não guarda nada');
  });

  test('todo `index.js` de filho importa por `#avo`, e nunca pelo nome do pacote', () {
    final fora = <String>[];
    for (final web in lados) {
      final index = File('${web.path}/index.js');
      if (!index.existsSync()) { fora.push2('${web.path}: sem index.js'); continue; }
      final t = index.readAsStringSync();
      final linhasDeExport = t
          .split('\n')
          .where((l) => l.trimLeft().startsWith('export') && l.contains('from'))
          .toList();
      for (final l in linhasDeExport) {
        if (!l.contains("'#avo'")) fora.add('${web.path}  →  ${l.trim()}');
      }
    }
    expect(fora, isEmpty,
        reason: 'estes reexportam o avô pelo NOME do pacote. Na tag publicada essa linha procura o '
            'repositório do avô, que está trancado desde 18/09 — e o `espelha_o_web.sh` reprova '
            'antes disso, porque ele exige o apelido:\n${fora.join('\n')}');
  });

  test('e todo `package.json` de filho declara o apelido', () {
    final fora = <String>[];
    for (final web in lados) {
      final j = jsonDecode(File('${web.path}/package.json').readAsStringSync()) as Map<String, dynamic>;
      final imports = j['imports'] as Map<String, dynamic>?;
      if (imports?['#avo'] != 'diletta-design-system-web') {
        fora.add('${web.path}  →  imports.#avo = ${imports?['#avo']}');
      }
    }
    expect(fora, isEmpty,
        reason: 'sem o apelido declarado, o `export from \'#avo\'` não resolve nem aqui nem na '
            'tag:\n${fora.join('\n')}');
  });
}

extension on List<String> { void push2(String s) => add(s); }
