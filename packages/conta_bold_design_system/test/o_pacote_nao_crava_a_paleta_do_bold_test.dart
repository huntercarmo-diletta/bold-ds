import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O PACOTE NÃO CRAVA A PALETA DO BOLD — e este é o ratchet da porta.
///
/// A pergunta que produziu este gate foi do dono: *"qual a fricção de um novo filho do Bold?"*.
/// Medida, ela não era conceitual: eram **22 leituras congeladas** espalhadas por 7 arquivos, todas
/// da mesma forma — o código com a paleta do produto na mão lendo `BoldPalette.bold` ou uma const de
/// `BoldColors` em vez dela.
///
/// Nenhuma dessas 22 pintava errado no Conta BOLD, e é por isso que ficaram: **um valor congelado no
/// produto certo é indistinguível de um valor correto.** Só aparece quando existe um segundo produto,
/// e aí aparece como *"declarei a paleta inteira e metade da tela continua rosa"*.
///
/// O que este gate cobra é o caminho, não o valor: quem precisa da paleta **recebe** a paleta.
void main() {
  /// Os três arquivos que PODEM nomear o Bold, e por quê.
  const podem = {
    // A definição. É onde a paleta do Bold é escrita.
    'bold_palette.dart',
    // O produto default. Ele existe pra dizer "o Bold é esta paleta com esta marca".
    'bold_produto.dart',
    // As duas fábricas `light()`/`dark()` e a declaração `BoldGradients.bold` — atalhos nomeados do
    // produto, não leitores anônimos.
    'bold_scheme.dart',
    'bold_gradients.dart',
    // Não é código: é a DOCUMENTAÇÃO dos fundamentos, escrita em `r'''…'''` e servida ao catálogo.
    // A varredura é por linha e não distingue string de expressão; distinguir custaria um parser
    // pra ganhar um arquivo. Fica declarado, que é a forma barata de não mentir.
    'bold_fundamentos.dart',
  };

  test('só a declaração nomeia BoldPalette.bold — o resto recebe a paleta', () {
    final infratores = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final nome = f.uri.pathSegments.last;
      if (podem.contains(nome)) continue;
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        final l = linhas[i].trim();
        // Comentário e doc citam o nome ao contar a história — e contar a história é o ponto.
        if (l.startsWith('//') || l.startsWith('///')) continue;
        if (l.contains('BoldPalette.bold')) infratores.add('$nome:${i + 1}  $l');
      }
    }
    expect(infratores, isEmpty,
        reason: 'código lendo a paleta do Bold em vez de receber a que veio — um produto novo '
            'declara a paleta dele e recebe estes valores assim mesmo:\n${infratores.join("\n")}');
  });

  test('e nenhum degrau de MARCA entra por const fora da declaração', () {
    // `BoldColors.primary04` e as 8 paradas do lockup são const: elas não acompanham paleta
    // nenhuma. Semântico e neutro ficam de fora da varredura — a regra do pai diz que são
    // invariantes, e cobrar aqui seria inventar dívida que o contrato não reconhece.
    final infratores = <String>[];
    final marca = RegExp(r'BoldColors\.(primary|primaryState|lockup)[A-Za-z0-9]*');
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final nome = f.uri.pathSegments.last;
      if (podem.contains(nome)) continue;
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        final l = linhas[i].trim();
        if (l.startsWith('//') || l.startsWith('///')) continue;
        final m = marca.firstMatch(l);
        if (m != null) infratores.add('$nome:${i + 1}  ${m.group(0)}');
      }
    }
    expect(infratores, isEmpty,
        reason: 'degrau de marca congelado fora da declaração:\n${infratores.join("\n")}');
  });

  test('e o gate SABE ver uma leitura congelada voltar', () {
    // Controle. A varredura acima é de ausência, e asserção de ausência passa sozinha quando a
    // busca está errada — foi o que aconteceu com o gate do quadrado preto, que pedia
    // `width >= viewBox` num rect dois pixels menor e ficou verde na frente do defeito.
    const linha = '      color: BoldPalette.bold.primary04,';
    expect(linha.trim().startsWith('//'), isFalse);
    expect(linha.contains('BoldPalette.bold'), isTrue,
        reason: 'a expressão que a varredura procura deixou de casar com a forma que ela procura');
  });
}
