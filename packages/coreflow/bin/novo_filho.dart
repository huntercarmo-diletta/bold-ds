import 'dart:io';

/// NOVO FILHO — o produto novo em um comando.
///
/// ```sh
/// dart run coreflow:novo_filho \
///   --id meuBanco --nome "Meu Banco" --cor '#1B5E20' --saida ../meu_banco_coreflow
/// ```
///
/// O que ele escreve é o MÍNIMO que um produto precisa pra existir nesta linguagem: um pacote com a
/// declaração do produto (uma cor) e o `pubspec` que aponta pro PAI (`coreflow`). **Não escreve tela,
/// não escreve rota e não escreve app** — quem faz isso é o produto, e um gerador que faz vira andaime
/// que ninguém apaga.
///
/// Mora no pai desde 08/09 (fase 3 de `docs/2026-09-04-adr-o-coreflow-e-o-pai.md`): quem gera filho é
/// quem tem filhos, e o filho gerado não depende de produto nenhum — só da linguagem. Um filho de UMA
/// cor é uma porta; um produto que já tem paleta desenhada entra pela outra, `CoreflowProduto(paleta:)`.
///
/// A prova de que ele funciona não é este arquivo: é `exemplos/filho_do_coreflow/`, que é a SAÍDA
/// dele versionada, com um gate que regenera e compara. Gerador sem saída conferida é template com
/// esperança.
void main(List<String> args) {
  final op = _lerArgumentos(args);
  if (op == null) {
    stderr.writeln('''
uso: dart run coreflow:novo_filho --id <id> --nome <nome> --cor <#RRGGBB> [--saida <dir>]

  --id     identificador Dart do produto (ex.: meuBanco)
  --nome   como a marca se escreve na tela (ex.: "Meu Banco")
  --cor    a cor da marca, e é a ÚNICA decisão de cor que este comando pede
  --saida  onde escrever (default: ../<id>_coreflow)
''');
    exitCode = 64;
    return;
  }

  final dir = Directory(op.saida);
  if (dir.existsSync() && dir.listSync().isNotEmpty) {
    stderr.writeln('a pasta ${op.saida} já existe e não está vazia — não vou sobrescrever.');
    exitCode = 73;
    return;
  }
  Directory('${op.saida}/lib').createSync(recursive: true);
  Directory('${op.saida}/assets/logos').createSync(recursive: true);
  Directory('${op.saida}/test').createSync(recursive: true);
  Directory('${op.saida}/web/tokens').createSync(recursive: true);

  File('${op.saida}/pubspec.yaml').writeAsStringSync(pubspecDe(op));
  File('${op.saida}/lib/${_arquivo(op.id)}.dart').writeAsStringSync(produtoDe(op));
  File('${op.saida}/README.md').writeAsStringSync(leiameDe(op));
  // O LADO WEB, e ele nasce junto porque um produto desta casa é mobile E web. Até 14/09 o gerador
  // entregava só o Flutter, e o segundo filho teria que montar a instância web olhando a do
  // primeiro — copiando. Copiar é o que esta casa passou o mês combatendo.
  File('${op.saida}/test/emite_o_css.dart').writeAsStringSync(emissorDe(op));
  File('${op.saida}/test/o_css_esta_em_dia_test.dart').writeAsStringSync(gateDoCssDe(op));
  File('${op.saida}/web/package.json').writeAsStringSync(packageJsonDe(op));
  File('${op.saida}/web/index.js').writeAsStringSync(indexJsDe(op));
  File('${op.saida}/web/README.md').writeAsStringSync(leiameWebDe(op));
  File('${op.saida}/test/o_desenho_da_web_e_o_do_mobile_test.dart')
      .writeAsStringSync(gateDeParidadeDe(op));
  File('${op.saida}/web/tokens/.gitkeep').writeAsStringSync('');

  stdout.writeln('''
escrito em ${op.saida}

  1. aponte o `path:` do pubspec pra onde este DS mora (ou troque por `git:` + `ref:` numa tag);
  2. `flutter pub get`
  3. no app: `MaterialApp(theme: ${op.id}.materialClaro, darkTheme: ${op.id}.materialEscuro,
     builder: (_, f) => DilettaThemeScope(theme: ${op.id}.claro, child: f!))`

o lado WEB nasceu junto, em `web/`:

  4. `flutter test test/emite_o_css.dart` escreve `web/tokens/${_arquivo(op.id)}-tokens.css`
  5. `cd web && npm install`
  6. a fonte: `web/` não declara nenhuma, porque este produto ainda não declarou a dele. Quando
     declarar em `tipografia:`, acrescente o `@fontsource/<sua-fonte>` e um `fontes.css` — o
     `web/README.md` mostra como.

sem marca declarada, os componentes desenham e os que precisam de um arquivo de marca (logo) somem em
vez de quebrar. Declare o seu em `assets/logos/` e passe `marcaVisual:`; a família tipográfica e os
degraus da escala entram por `tipografia:` — sem eles, a escala é a da linguagem e a fonte é a do app.''');
}

/// As quatro decisões que o comando aceita. Uma delas é cor; as outras três são nome.
class Opcoes {
  Opcoes({required this.id, required this.nome, required this.cor, required this.saida});
  final String id;
  final String nome;
  final String cor;
  final String saida;

  /// `#1B5E20` → `0xFF1B5E20`.
  String get corDart => '0xFF${cor.replaceAll('#', '').toUpperCase()}';
}

Opcoes? _lerArgumentos(List<String> args) {
  final mapa = <String, String>{};
  for (var i = 0; i < args.length - 1; i += 2) {
    if (!args[i].startsWith('--')) return null;
    mapa[args[i].substring(2)] = args[i + 1];
  }
  final id = mapa['id'], nome = mapa['nome'], cor = mapa['cor'];
  if (id == null || nome == null || cor == null) return null;
  if (!RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(id)) {
    stderr.writeln('o --id tem que ser um identificador Dart em lowerCamelCase: $id');
    return null;
  }
  if (!RegExp(r'^#?[0-9A-Fa-f]{6}$').hasMatch(cor)) {
    stderr.writeln('a --cor tem que ser #RRGGBB: $cor');
    return null;
  }
  return Opcoes(
      id: id, nome: nome, cor: cor, saida: mapa['saida'] ?? '../${_arquivo(id)}_coreflow');
}

String _arquivo(String id) =>
    id.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

String pubspecDe(Opcoes op) => '''
name: ${_arquivo(op.id)}_coreflow
description: A identidade do ${op.nome} — um produto do Coreflow.
publish_to: none
version: 0.1.0

environment:
  sdk: ^3.9.0

dependencies:
  flutter:
    sdk: flutter

  # O PAI da linguagem — e só ele: um filho não depende de outro produto. Em desenvolvimento vale
  # `path:`; pra valer, troque por `git:` numa TAG — entrega sem versão é entrega que ninguém consegue
  # voltar atrás.
  coreflow:
    path: ../conta-bold-ds/packages/coreflow

dev_dependencies:
  # O emissor do CSS e o gate dele rodam como teste de widget — é assim que a linguagem resolve a
  # paleta sem subir um app.
  flutter_test:
    sdk: flutter

flutter:
  assets:
    - assets/logos/
''';

String produtoDe(Opcoes op) => '''
import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Color;

/// ${op.nome} — a identidade deste produto, e ela é UMA decisão.
///
/// A rampa de marca inteira deriva desta cor (nove degraus em OKLCH, com o croma limitado ao
/// gamute); a gramática do material — card de vidro, canto do botão, canto da folha, blur — vem do
/// Coreflow; e erro, aviso, sucesso e a rampa neutra vêm da linguagem, porque **cor semântica é
/// invariante**.
///
/// Discordar de um degrau é legítimo e tem lugar: `.comMaterial(...)` sobre a paleta. O que não se
/// faz é declarar 60 hexes à mão — foi o que este comando existe pra não deixar acontecer.
final ${op.id} = CoreflowProduto.daMarca(
  marca: const Color(${op.corDart}),
  id: '${op.id}',
  nome: '${op.nome}',
  // Sem marca declarada, `DilettaBrand.nenhuma`: os componentes desenham, e os que precisam de um
  // arquivo de marca somem em vez de quebrar. Declare o seu e passe aqui:
  //
  //   marcaVisual: const DilettaBrand(
  //     pacote: '${_arquivo(op.id)}_coreflow',
  //     logo: 'assets/logos/${_arquivo(op.id)}.svg',
  //     logoFull: 'assets/logos/${_arquivo(op.id)}.svg',
  //     logoTingePorCurrentColor: true,
  //   ),
  //
  // Sem tipografia declarada, a escala é a da linguagem e a família é a do app. A sua entra aqui:
  //
  //   tipografia: CoreflowTipografia(familia: 'packages/${_arquivo(op.id)}_coreflow/MinhaFonte', ...),
  //
  // AJUSTE DE PAPEL POR COMPONENTE — adaptação limitada, não slot livre. Serve pra dizer "neste
  // componente, o papel X passa a ler o Y", com `de` e `para` da MESMA família e um motivo fechado
  // (`marca` ou `contraste`). Existe porque mexer no papel muda 36 peças de uma vez; isto muda uma.
  // O que você declarar aqui chega no Flutter E na folha da web, e um gate cobra que os dois
  // apliquem o mesmo:
  //
  //   ajustesDePapel: const [
  //     DilettaAjusteDePapel(
  //       componente: 'DilettaProgressBar', de: 'primaryTrack', para: 'primarySubtle',
  //       motivo: MotivoDoAjuste.marca, nota: 'o trilho some sobre a superfície do parceiro'),
  //   ],
);
''';

String leiameDe(Opcoes op) => '''
# ${op.nome} — um produto do Coreflow

Gerado por `dart run coreflow:novo_filho`. O que existe aqui é a IDENTIDADE: uma cor, um nome e
(quando você declarar) o logo e a tipografia. O resto — componentes, papéis de cor, tema Material —
vem do Coreflow, e nada vem de outro produto.

## Montar

```dart
import 'package:${_arquivo(op.id)}_coreflow/${_arquivo(op.id)}.dart';

MaterialApp(
  theme: ${op.id}.materialClaro,
  darkTheme: ${op.id}.materialEscuro,
  builder: (_, filho) => DilettaThemeScope(theme: ${op.id}.claro, child: filho!),
);
```

## O que decidir depois, e onde

| decisão | onde |
|---|---|
| o logo e o mapa da arte | `marcaVisual:` no `${_arquivo(op.id)}.dart` |
| a família tipográfica e os degraus da escala | `tipografia:` no `${_arquivo(op.id)}.dart` (`CoreflowTipografia`) |
| discordar de um degrau derivado | `.comMaterial(...)` sobre a paleta |
| um papel que só este produto tem | `papeisExtras` da paleta |
| um componente que só este produto tem | nasce aqui; sobe pro DS quando um SEGUNDO produto pedir |

## O que NÃO se decide aqui

Erro, aviso, sucesso e a rampa neutra. Cor semântica é invariante nesta linguagem: vermelho de erro
derivado da sua marca daria um produto que não sabe dizer que algo deu errado.
''';

/// A TAG DO PACOTE WEB DO AVÔ que um filho novo recebe. É a irmã da que o `coreflow` pina em Dart:
/// o avô publica `vX` para o pacote Dart e `web-vX` para o web, no mesmo repo, sob o mesmo número.
///
/// Fica aqui como constante porque o gerador escreve JSON, não `pubspec`. O gate
/// `o_filho_gerado_recebe_o_mesmo_avo_test` prova que este número é o mesmo que o `pubspec` do pai
/// declara — duas tags diferentes seriam duas versões da linguagem no mesmo produto.
const tagWebDoAvo = 'web-v0.194.3';

String emissorDe(Opcoes op) => '''
// ESCREVE `web/tokens/${_arquivo(op.id)}-tokens.css`. **Não é gate** — gate é o vizinho
// `o_css_esta_em_dia_test.dart`, que roda na suíte e compara o disco com a fonte.
//
//     flutter test test/emite_o_css.dart
//
// Sem `_test` no nome de propósito: `flutter test` não o pega, e emitir arquivo dentro da suíte é
// como um repo começa a ter saída gerada que ninguém sabe quando mudou.
import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:${_arquivo(op.id)}_coreflow/${_arquivo(op.id)}.dart';
import 'package:flutter_test/flutter_test.dart';

/// As TAGS que a instância web registra, lidas do `index.js` do pacote do avô — a fonte é o pacote e
/// não uma lista nossa, porque peça nova na tag dele tem que entrar sozinha.
Set<String> tagsDaWeb() {
  final f = File('web/node_modules/diletta-design-system-web/index.js');
  if (!f.existsSync()) return const {};
  return RegExp(r"^\\s*'(diletta-[a-z-]+)',", multiLine: true)
      .allMatches(f.readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();
}

/// As famílias que este produto declara, na ordem em que a cascata precisa delas. Nenhum hex é
/// escrito aqui: tudo sai da paleta, pela derivação da linguagem.
String cssDoProduto() => [
      coreflowPapeisCss(${op.id}.paleta, produto: '${op.nome}'),
      '\\n/* O ESQUEMA DESTE PRODUTO — os papéis que o avô não tem. */\\n',
      coreflowEsquemaCss(${op.id}.paleta),
      '\\n/* MEDIDA por nome. */\\n',
      coreflowMedidasCss(${op.id}.paleta),
      // A ESCALA DE TIPO entra quando este produto declarar a dele em `tipografia:`. Sem declaração,
      // a escala é a do avô e ela já vem na folha dele — emitir de novo seria repetir o que não é
      // nosso. Quando declarar, acrescente aqui:
      //
      //   coreflowTipoCss(meusDegraus, familia: "'MinhaFonte', system-ui, sans-serif"),
      // OS AJUSTES por componente, por último: eles redeclaram papel DENTRO de um elemento, então
      // vêm depois das declarações de raiz que sobrescrevem. Sem ajuste declarado sai vazio.
      _ajustes(),
    ].join();

String _ajustes() {
  final css = coreflowAjustesCss(${op.id}.ajustesDePapel, tagsWeb: tagsDaWeb());
  return css.isEmpty ? '' : '\\n/* AJUSTES DE PAPEL POR COMPONENTE. */\\n\$css';
}

void main() {
  test('emite o CSS dos tokens do ${op.nome}', () {
    final css = cssDoProduto();
    final f = File('web/tokens/${_arquivo(op.id)}-tokens.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final vars = RegExp(r'--cps-[A-Za-z0-9-]+\\s*:').allMatches(css).length;
    // Controle negativo: folha curta demais não é erro no navegador, é silêncio.
    expect(vars, greaterThan(100), reason: 'a folha saiu curta demais pra ser os papéis');
    stdout.writeln('escrito: \${f.path} — \$vars declarações');
  });
}
''';

String gateDoCssDe(Opcoes op) => '''
// O GATE QUE LIGA A FOLHA À FONTE.
//
// Sem ele, o CSS vira uma transcrição que ninguém sabe se ainda bate — e a casa já viu esse filme:
// um produto web desta família manteve ~270 tokens copiados à mão do Dart, com zero gates ligando
// os dois, e a pergunta "isto ainda é a nossa cor?" não tinha resposta.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css.dart' show cssDoProduto;

void main() {
  test('o CSS emitido é o que está no disco', () {
    final f = File('web/tokens/${_arquivo(op.id)}-tokens.css');
    expect(f.existsSync(), isTrue,
        reason: 'o CSS não existe — rode `flutter test test/emite_o_css.dart`');
    expect(
      f.readAsStringSync(),
      cssDoProduto(),
      reason: 'o CSS do disco divergiu da fonte. Alguém editou à mão, ou a paleta mudou e ninguém '
          'reemitiu: `flutter test test/emite_o_css.dart`',
    );
  });
}
''';

String packageJsonDe(Opcoes op) => '''
{
  "name": "${_arquivo(op.id).replaceAll('_', '-')}-web",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "description": "A INSTÂNCIA WEB do ${op.nome}: os custom elements da linguagem, com a tinta deste produto.",
  "main": "./index.js",
  "exports": {
    ".": "./index.js",
    "./tokens.css": "./tokens/${_arquivo(op.id)}-tokens.css"
  },
  "files": [
    "index.js",
    "tokens/"
  ],
  "dependencies": {
    "diletta-design-system-web": "bitbucket:diletta/ds-diletta#$tagWebDoAvo"
  }
}
''';

String indexJsDe(Opcoes op) => '''
// A ENTRADA da instância WEB do ${op.nome}.
//
//     import '${_arquivo(op.id).replaceAll('_', '-')}-web';             // registra os elementos
//     import '${_arquivo(op.id).replaceAll('_', '-')}-web/tokens.css';  // e pinta com a nossa cor
//
// Este pacote NÃO reimplementa componente. Ele reexporta os custom elements da linguagem e
// acrescenta a TINTA deste produto — `--cps-*` é variável CSS, e variável se sobrescreve. A mesma
// peça, a nossa cor: é o white label do lado web, com o mesmo mecanismo que o Flutter usa com paleta.
//
// A ORDEM das folhas importa e é a única pegadinha: as duas do avô primeiro, a nossa por último.
// Fora de ordem, a tinta de referência ganha e a tela sai na cor de ninguém — sem erro no console.
export * from 'diletta-design-system-web';
export { elementos, prontos } from 'diletta-design-system-web';
''';

String leiameWebDe(Opcoes op) => '''
# ${op.nome} na web

Os custom elements da linguagem, com a tinta deste produto. **Nenhum componente é reimplementado
aqui**: a folha de CSS é a diferença inteira entre um produto e outro.

## Como usar

```html
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-tokens.css">
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-papeis.css">
<link rel="stylesheet" href=".../${_arquivo(op.id).replaceAll('_', '-')}-web/tokens/${_arquivo(op.id)}-tokens.css">
```

As duas primeiras são do avô, na tinta de REFERÊNCIA. A terceira é a nossa, com os mesmos nomes e os
nossos valores. **Fora de ordem, a referência ganha.**

```js
import '${_arquivo(op.id).replaceAll('_', '-')}-web';
```

Numa página sem bundler, nome de pacote não resolve — declare um `<script type="importmap">`.

## De onde vem a folha

```sh
flutter test test/emite_o_css.dart     # na raiz do pacote Dart
```

Ela sai da paleta deste produto pela derivação do avô. **Nenhum hex é digitado**, e
`o_css_esta_em_dia_test.dart` roda na suíte comparando o arquivo com a fonte, byte a byte.

## A fonte

Este produto ainda não declarou tipografia, então a folha não declara família e o navegador usa a do
app. Quando declarar em `tipografia:`:

1. `npm i @fontsource/<sua-fonte>`;
2. um `fontes/fontes.css` com um `@import` por peso que a sua escala usa;
3. `"./fontes.css"` nos `exports` e `"fontes/"` nos `files`;
4. acrescente o `coreflowTipoCss(...)` no `test/emite_o_css.dart`.

O nome sem o arquivo é falha silenciosa: a folha pede a fonte e o navegador cai no fallback.

## Como este pacote sai daqui

O `npm` não tem o `path:` do `pub` — subpasta de repo não se instala. Quem consumir precisa de uma
**tag órfã** cuja raiz seja este diretório. O padrão está no `conta-bold-ds`
(`tool/espelha_o_web.sh`), e o avô fez igual.
''';

/// O GATE DE PARIDADE do filho: o que a web desenha é o que o mobile desenha.
///
/// Nasce junto porque a alternativa é o produto descobrir sozinho — e a casa já pagou por isso. O
/// irmão mais velho levou dois defeitos da mesma classe em um dia, os dois passando por um gate que
/// só comparava o arquivo com o gerador: o gerador é que mentia. Por isso este lê pelas MESMAS portas
/// que os widgets leem, e nunca pelo caminho que o emissor usou.
String gateDeParidadeDe(Opcoes op) => '''
// O QUE A WEB DESENHA É O QUE O MOBILE DESENHA.
//
// Já existe um gate provando que o `.css` no disco é o que o emissor produz. Ele só pega quem edita
// o arquivo à mão. O que ele NÃO pega é o emissor produzir uma coisa e o componente desenhar outra —
// e é essa a classe de defeito que custou caro no primeiro produto desta casa.
//
// Por isso aqui a leitura é pelas MESMAS portas que os widgets usam: `formaDoCartao`,
// `dilettaCorDoPapelGen`. Comparar a saída com a fonte não é o mesmo que comparar a saída com o
// DESENHO.
import 'package:coreflow/coreflow.dart';
import 'package:${_arquivo(op.id)}_coreflow/${_arquivo(op.id)}.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css.dart' show cssDoProduto, tagsDaWeb;

/// As variáveis da folha, por modo. A folha tem vários blocos `:root` — um por família — e varrer
/// por posição pegaria só o primeiro.
Map<String, String> _vars(String css, {required bool escuro}) {
  final fora = <String, String>{};
  var dentro = false;
  var profundidade = 0;
  for (final linha in css.split('\\n')) {
    final l = linha.trim();
    if (l.endsWith('{')) {
      profundidade++;
      final sel = l.substring(0, l.length - 1).trim();
      if (sel.isNotEmpty && !sel.startsWith('@')) {
        dentro = escuro ? sel == ':root[data-theme="dark"]' : sel == ':root';
      }
      continue;
    }
    if (l == '}') {
      profundidade--;
      if (profundidade <= 0) dentro = false;
      continue;
    }
    if (!dentro) continue;
    final m = RegExp(r'--cps-([A-Za-z0-9-]+):\\s*([^;]+);').firstMatch(l);
    if (m != null) fora[m.group(1)!] = m.group(2)!.trim();
  }
  return fora;
}

String _hex(Color c) {
  final argb = c.toARGB32();
  final rgb = argb.toRadixString(16).padLeft(8, '0').substring(2);
  final a = (argb >> 24) & 0xFF;
  return a == 0xFF ? '#\$rgb' : '#\$rgb\${a.toRadixString(16).padLeft(2, '0')}';
}

String _px(double v) => v == v.roundToDouble() ? '\${v.round()}px' : '\${v}px';

void main() {
  final css = cssDoProduto();
  final claro = _vars(css, escuro: false);
  final escuro = _vars(css, escuro: true);
  final p = ${op.id}.paleta;

  test('a COR de cada papel é a que o componente pinta, nos dois modos', () {
    final divergem = <String>[];
    for (final modo in [
      (nome: 'claro', s: DilettaScheme.light(p), css: claro),
      (nome: 'escuro', s: DilettaScheme.dark(p), css: escuro),
    ]) {
      for (final papel in dilettaNomesDePapelGen) {
        final cor = dilettaCorDoPapelGen(modo.s, papel);
        if (cor == null) continue;
        // Os dois que o esquema do produto sobrescreve de propósito saem com o valor DELE — é assim
        // que o white label acontece na cascata, e a conferência deles é o teste abaixo.
        if (papel == 'primary' || papel == 'border') continue;
        if (modo.css[papel] != _hex(cor)) {
          divergem.add('\${modo.nome}/\$papel: mobile \${_hex(cor)} × web \${modo.css[papel] ?? "ausente"}');
        }
      }
    }
    expect(divergem, isEmpty, reason: 'a web pinta diferente do app:\\n\${divergem.join('\\n')}');
  });

  test('os papéis do ESQUEMA do produto também, e são eles que ganham na cascata', () {
    for (final modo in [
      (nome: 'claro', b: Brightness.light, css: claro),
      (nome: 'escuro', b: Brightness.dark, css: escuro),
    ]) {
      final s = CoreflowScheme.de(p, brilho: modo.b);
      // Variável e não literal solto: `{` no início de statement o Dart lê como BLOCO, não mapa.
      final esperado = {
        'background': s.background, 'secondaryFlow': s.secondaryFlow,
        'textPrimary': s.textPrimary, 'border': s.border, 'overlay': s.overlay,
        'primary': s.primary, 'danger': s.danger, 'infoSubtle': s.infoSubtle, 'vinho': s.vinho,
      };
      esperado.forEach((papel, cor) {
        expect(modo.css[papel], _hex(cor),
            reason: '\${modo.nome}/\$papel: a web não pinta o que o esquema do produto diz');
      });
    }
  });

  test('a FORMA de cada família é a que o componente arredonda', () {
    final a = DilettaScheme.light(p);
    final nosso = CoreflowScheme.de(p, brilho: Brightness.light);
    final desenho = {
      DilettaMedida.formaDeBotao: a.formaDoBotao,
      DilettaMedida.formaDeFolha: nosso.formaDaFolha,
      DilettaMedida.formaDeCampo: a.formaDoCampo,
      DilettaMedida.formaDeCartao: a.formaDoCartao,
      DilettaMedida.formaDeVidro: a.formaDoVidro,
      DilettaMedida.formaDeNav: a.formaDaNav,
    };
    desenho.forEach((papel, raio) {
      expect(claro[papel], _px(raio.topLeft.x),
          reason: '\$papel: o app arredonda \${_px(raio.topLeft.x)} e a web diz \${claro[papel]}');
    });
    // Forma nova no avô sem entrar na folha é peça web arredondando por conta própria.
    expect(desenho.keys.toSet(), DilettaMedida.formas);
  });

  group('os AJUSTES de papel por componente', () {
    // As tags saem do `node_modules` do pacote web, e uma suíte Dart não pode EXIGIR `npm install`:
    // quem clonar e rodar `flutter test` pegaria vermelho por um passo de outra linguagem. Então:
    // sem tags e sem ajuste declarado, PULA com o motivo escrito; com ajuste declarado, reprova —
    // aí a ausência esconderia a folha saindo sem ele.
    final tags = tagsDaWeb();
    final semTags = tags.isEmpty;
    const porque = 'sem `npm install` em web/ não há lista de tags, e este produto não declara '
        'ajuste — não há o que medir. Rode o install para cobrir.';

    setUp(() {
      if (semTags && ${op.id}.ajustesDePapel.isNotEmpty) {
        fail('há ajuste declarado e a lista de tags veio vazia: a folha sairia SEM ele e nada '
            'acusaria. Rode `npm install` em web/.');
      }
    });

    test('o remapeamento da web é o mesmo que o do app', skip: semTags ? porque : null, () {
      // Lista SINTÉTICA de propósito: um gate que só rodasse contra a lista real passaria sem medir
      // nada enquanto este produto não declarar nenhum ajuste.
      const ajustes = [
        DilettaAjusteDePapel(
            componente: 'DilettaButton', de: 'primary', para: 'primaryPressed',
            motivo: MotivoDoAjuste.marca, nota: 'sintético, só para o gate medir'),
      ];
      final base = DilettaScheme.light(p);
      expect(_hex(base.comAjustes(ajustes, 'DilettaButton').primary), _hex(base.primaryPressed),
          reason: 'o app não aplicou o ajuste');
      expect(coreflowAjustesCss(ajustes, tagsWeb: tags),
          contains('diletta-button { --cps-primary: var(--cps-primaryPressed); }'),
          reason: 'a web não aplicou o ajuste que o app aplica');
    });

    test('nenhum ajuste DESTE produto fica de fora da folha', () {
      final declarados = ${op.id}.ajustesDePapel;
      final css = coreflowAjustesCss(declarados, tagsWeb: tags);
      for (final a in declarados.where((a) => tags.contains(tagDaPeca(a.componente)))) {
        expect(css, contains('\${tagDaPeca(a.componente)} { --cps-\${a.de}: var(--cps-\${a.para}); }'),
            reason: '\${a.componente} tem instância web e o ajuste dele não saiu na folha');
      }
    });
  });
}
''';
