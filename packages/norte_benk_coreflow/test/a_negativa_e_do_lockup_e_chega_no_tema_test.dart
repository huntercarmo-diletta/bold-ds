// A NEGATIVA É DO LOCKUP, E ELA CHEGA NO TEMA.
//
// O arquivo mono deste produto é a arte da página escura, e ele entrou em `logoFullEscuro` em 18/09,
// depois que o avô entregou o par por brilho na `v0.196.0` e que o `CoreflowProduto.marcaNo` passou a
// copiá-lo. Duas coisas podem quebrar isso sem ninguém ver, e cada uma tem um teste aqui:
//
// 1. **o slot errado.** `logoEscuro` e `logoFullEscuro` são campos vizinhos de nome quase igual, e
//    trocá-los põe a palavra de volta nas seis peças que desenham só a marca — no escuro, e só no
//    escuro. A prova não confia no nome do arquivo: ela lê o `viewBox` dos SVG, que é medida do
//    desenho. O mono casa com o LOCKUP (`380×166`, 7 paths) e não com o símbolo (`197×84`, 2 paths);
// 2. **a porta.** `marcaNo` reconstrói o plugue campo a campo, e um campo fora da lista volta ao
//    default no tema, calado. Já aconteceu duas vezes — com o `nomeDaMarca` e com este par. O gate da
//    classe mora no `coreflow`; aqui fica a prova do CASO, que é a que mede o que a tela mostra.
//
// A ausência também é testada: este produto NÃO tem negativa do símbolo, e `logoEscuro` tem que
// continuar nulo. Preenchê-lo com o mono seria derivar desenho, que é o que o veredito de 16/09
// recusou por escrito.
import 'dart:io';

import 'package:flutter/widgets.dart' show Brightness;
import 'package:flutter_test/flutter_test.dart';
import 'package:norte_benk_coreflow/norte_benk.dart';

/// O `viewBox` do arquivo, como quatro números. É a medida do desenho — o nome do arquivo é opinião.
List<double> _viewBox(String caminho) {
  final svg = File(caminho).readAsStringSync();
  final m = RegExp(r'viewBox="([^"]+)"').firstMatch(svg);
  expect(m, isNotNull, reason: 'sem viewBox em $caminho não dá para dizer que desenho é este');
  return m!.group(1)!.trim().split(RegExp(r'[\s,]+')).map(double.parse).toList();
}

void main() {
  final marca = norteBenk.marca;

  /// O caminho da negativa, com a ausência falando em vez de estourar. Sem isto, trocar o slot faria
  /// os testes de baixo caírem num `null` cru — e gate que morre sem dizer o motivo ensina menos que
  /// gate nenhum.
  String aNegativa() {
    final caminho = marca.logoFullEscuro;
    expect(caminho, isNotNull,
        reason: 'a negativa do lockup sumiu de `logoFullEscuro`. Se ela foi para `logoEscuro`, está '
            'no slot do SÍMBOLO — ver o primeiro teste deste arquivo');
    return caminho!;
  }

  test('a negativa é o par do LOCKUP, e o slot do símbolo fica vazio', () {
    expect(marca.logoFullEscuro, isNotNull,
        reason: 'a negativa do lockup é o que o cliente mandou, e é a arte da página escura');
    expect(marca.logoEscuro, isNull,
        reason: 'o cliente NÃO mandou negativa do símbolo. Repetir o lockup aqui seria derivar '
            'desenho — o veredito de 16/09 recusou isso por escrito: «tinta se deriva, desenho não '
            'se deriva». Quando a arte chegar, este teste é o lugar de trocar a expectativa');

    // O casamento medido: a negativa tem a caixa do lockup, e não a do símbolo.
    final negativa = _viewBox(aNegativa());
    expect(negativa, _viewBox('${marca.logoFull}'),
        reason: 'a negativa e o lockup positivo têm que ser o MESMO desenho em outra tinta');
    expect(negativa, isNot(_viewBox('${marca.logo}')),
        reason: 'se a negativa casa com a caixa do SÍMBOLO, ela está no slot errado');
  });

  test('a negativa é branca de arquivo — nada a repinta', () {
    final svg = File(aNegativa()).readAsStringSync();
    expect(svg.contains('currentColor'), isFalse,
        reason: 'negativa com currentColor seria repintada pela corDoLogo, e o desenho do cliente '
            'deixaria de ser o que ele entregou');
    expect(RegExp(r'fill="(white|#[Ff]{3,6})"').hasMatch(svg), isTrue,
        reason: 'o negativo é BRANCO: é o que dá 17,87:1 na página escura deste produto');
  });

  test('os três arquivos existem no pacote', () {
    for (final caminho in [marca.logo, marca.logoFull, aNegativa()]) {
      expect(File(caminho).existsSync(), isTrue,
          reason: 'caminho de asset que não existe falha em RUNTIME, no aparelho, calado');
    }
  });

  group('o par atravessa o tema — a porta que se fechou duas vezes', () {
    for (final brilho in Brightness.values) {
      test('no ${brilho.name}', () {
        final noTema = norteBenk.marcaNo(brilho);
        expect(noTema.logoFullEscuro, marca.logoFullEscuro,
            reason: 'sem a cópia em `CoreflowProduto.marcaNo` o par não chega ao tema, e o '
                'DilettaLogo mostra o lockup COLORIDO na página escura — sem erro e sem teste '
                'vermelho. Foi o que aconteceu entre 16/09 e 18/09');
        expect(noTema.logoEscuro, isNull);
        // O que a peça do avô faz com isso: par declarado desliga o `srcIn`, então a arte entra como
        // o designer a desenhou. A `corDoLogo` abaixo continua sendo preenchida pelo `marcaNo` e
        // deixa de alcançar o lockup no escuro — não é contradição, é a precedência dele.
        expect(noTema.nomeDaMarca, 'Norte Benk',
            reason: 'o outro campo que já se perdeu nesta mesma cópia');
      });
    }
  });
}
