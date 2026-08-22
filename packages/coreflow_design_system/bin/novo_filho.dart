import 'dart:io';

/// NOVO FILHO — o produto novo em um comando.
///
/// ```sh
/// dart run coreflow_design_system:novo_filho \
///   --id meuBanco --nome "Meu Banco" --cor '#1B5E20' --saida ../meu_banco_coreflow
/// ```
///
/// O que ele escreve é o MÍNIMO que um produto precisa pra existir nesta linguagem: um pacote com a
/// declaração do produto (uma cor) e o `pubspec` que aponta pra cá. **Não escreve tela, não escreve
/// rota e não escreve app** — quem faz isso é o produto, e um gerador que faz vira andaime que
/// ninguém apaga.
///
/// A prova de que ele funciona não é este arquivo: é `exemplos/filho_do_coreflow/`, que é a SAÍDA
/// dele versionada, com um gate que regenera e compara. Gerador sem saída conferida é template com
/// esperança.
void main(List<String> args) {
  final op = _lerArgumentos(args);
  if (op == null) {
    stderr.writeln('''
uso: dart run coreflow_design_system:novo_filho --id <id> --nome <nome> --cor <#RRGGBB> [--saida <dir>]

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

  File('${op.saida}/pubspec.yaml').writeAsStringSync(pubspecDe(op));
  File('${op.saida}/lib/${_arquivo(op.id)}.dart').writeAsStringSync(produtoDe(op));
  File('${op.saida}/README.md').writeAsStringSync(leiameDe(op));

  stdout.writeln('''
escrito em ${op.saida}

  1. aponte o `path:` do pubspec pra onde este DS mora (ou troque por `git:` + `ref:` numa tag);
  2. `flutter pub get`
  3. no app: `MaterialApp(theme: ${op.id}.materialClaro, darkTheme: ${op.id}.materialEscuro,
     builder: (_, f) => DilettaThemeScope(theme: ${op.id}.claro, child: f!))`

o logo ainda é o do Conta BOLD, de propósito: ele existe pra a primeira tela desenhar. Declare o seu
em `assets/logos/` e passe `marcaVisual:` — produto que vai pra loja com o logo do vizinho é produto
que não declarou a marca.''');
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

  # O DS. Em desenvolvimento vale `path:`; pra valer, troque por `git:` numa TAG — entrega sem
  # versão é entrega que ninguém consegue voltar atrás.
  coreflow_design_system:
    path: ../conta-bold-ds/packages/coreflow_design_system

flutter:
  assets:
    - assets/logos/
''';

String produtoDe(Opcoes op) => '''
import 'package:coreflow_design_system/coreflow_design_system.dart';
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
  // O logo ainda é o do Conta BOLD. Declare o seu e passe aqui:
  //
  //   marcaVisual: const DilettaBrand(
  //     pacote: '${_arquivo(op.id)}_coreflow',
  //     logo: 'assets/logos/${_arquivo(op.id)}.svg',
  //     logoFull: 'assets/logos/${_arquivo(op.id)}.svg',
  //     logoTingePorCurrentColor: true,
  //   ),
);
''';

String leiameDe(Opcoes op) => '''
# ${op.nome} — um produto do Coreflow

Gerado por `dart run coreflow_design_system:novo_filho`. O que existe aqui é a IDENTIDADE:
uma cor, um nome e (quando você declarar) o logo. O resto — componentes, papéis de cor, tema
Material — vem do DS.

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
| discordar de um degrau derivado | `.comMaterial(...)` sobre a paleta |
| um papel que só este produto tem | `papeisExtras` da paleta |
| um componente que só este produto tem | nasce aqui; sobe pro DS quando um SEGUNDO produto pedir |

## O que NÃO se decide aqui

Erro, aviso, sucesso e a rampa neutra. Cor semântica é invariante nesta linguagem: vermelho de erro
derivado da sua marca daria um produto que não sabe dizer que algo deu errado.
''';
