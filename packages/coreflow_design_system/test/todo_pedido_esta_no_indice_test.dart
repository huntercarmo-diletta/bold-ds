// TODO PEDIDO ESTÁ NO ÍNDICE, E TODA LINHA DO ÍNDICE APONTA PRA UM PEDIDO.
//
// O `docs/PEDIDOS.md` abre dizendo a que veio: *«existe pra uma pergunta que não deveria custar uma
// busca: o que ainda está aberto?»*. Uma resposta incompleta é pior que nenhuma, porque parece
// resposta.
//
// Em 21/09 havia **15 arquivos em `docs/pedidos/` sem linha no índice** — de 17/08 a 18/09, um
// deles com veredito **MORA NO SEU DS** escrito dentro. O sintoma apareceu do jeito que essas
// coisas aparecem: alguém procurou no índice, não achou, e quase concluiu que não havia veredito.
//
// Este gate fecha nos DOIS sentidos, e é isso que o torna catraca:
//   · arquivo sem linha reprova — o índice para de ficar para trás;
//   · linha sem arquivo reprova — o índice para de apontar para o que não existe.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _indice = File('../../docs/PEDIDOS.md');
final _pasta = Directory('../../docs/pedidos');

/// Os que NÃO entram no índice, e o motivo de cada um. Lista fechada: sem motivo, não há exceção.
///
/// **Duas delas estão à espera de uma DECISÃO, e não de um conserto.** O índice tem três seções —
/// linguagem, ferramenta, e o que os pais mandaram — e nenhuma serve para o que vai à DONA DO
/// PRODUTO. Criar a quarta é decisão de quem toca o processo, e ela foi levada ao time em 21/09.
/// Enquanto não volta, os dois ficam fora COM endereço: é o que separa «pendente» de «esquecido».
const _foraDoIndice = <String, String>{
  '2026-08-17-o-gradiente-da-marca-tem-tres-stops-no-app-e-dois-aqui.md':
      'vai à DONA DO PRODUTO, e é NOTA, não pedido — o índice não tem seção para isso. '
      'À espera da decisão do time sobre criar a quarta seção (21/09).',
  '2026-09-01-a-selecao-engrossa-a-borda-em-cinco-telas-com-quatro-espessuras.md':
      'vai à DONA DO PRODUTO, e tem VEREDITO DELA de 02/09 («vamos manter tudo no DS»). '
      'Mesma espera da linha acima.',
  '2026-09-18-o-fundo-padrao-e-do-cliente-e-o-filho-nasce-sem-ele.md':
      'NÃO é pedido: quem pede é o app e quem responde é esta casa. O próprio arquivo traz a nota '
      'da rotina `atualizacoes-ds` (21/09) dizendo que está na pasta errada, e ele é carregado '
      'na `FILA-DOS-CHATS.md` como item.',
};

void main() {
  final pedidos = _pasta
      .listSync()
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last)
      .where((n) => n.endsWith('.md'))
      .toList()
    ..sort();
  final indice = _indice.readAsStringSync();

  test('a varredura lê arquivos de verdade — senão o gate aprova por cegueira', () {
    expect(_indice.existsSync(), isTrue, reason: 'o índice sumiu');
    expect(pedidos.length, greaterThan(100),
        reason: 'a pasta de pedidos veio quase vazia: o caminho mudou e este gate não guarda nada');
  });

  test('todo pedido tem linha no índice', () {
    final fora = pedidos
        .where((n) => !indice.contains(n) && !_foraDoIndice.containsKey(n))
        .toList();
    expect(fora, isEmpty,
        reason: 'estes pedidos não aparecem no índice. Quem procurar «o que está aberto?» vai '
            'receber uma resposta incompleta com cara de completa. Indexe, ou declare o motivo '
            'em `_foraDoIndice`:\n${fora.join('\n')}');
  });

  test('toda linha do índice aponta pra um arquivo que existe', () {
    final citados = RegExp(r'\(pedidos/([^)]+\.md)\)')
        .allMatches(indice)
        .map((m) => m.group(1)!)
        .toSet();
    expect(citados, isNotEmpty, reason: 'a expressão não achou link nenhum — o formato mudou');
    final mortos = citados.where((n) => !pedidos.contains(n)).toList()..sort();
    expect(mortos, isEmpty,
        reason: 'o índice cita arquivos que não existem — link morto num documento cuja função é '
            'responder rápido:\n${mortos.join('\n')}');
  });

  test('e toda exceção tem endereço vivo — permissão esquecida é permissão', () {
    // O inverso: se o arquivo for indexado (ou apagado), a linha de exceção tem que sair junto.
    final obsoletas = _foraDoIndice.keys
        .where((n) => !pedidos.contains(n) || indice.contains(n))
        .toList();
    expect(obsoletas, isEmpty,
        reason: 'estas exceções não valem mais — o arquivo foi indexado ou sumiu. Apague a '
            'linha:\n${obsoletas.join('\n')}');
    // e nenhuma exceção sem motivo escrito
    for (final e in _foraDoIndice.entries) {
      expect(e.value.trim().length, greaterThan(40),
          reason: '${e.key}: exceção sem motivo é permissão em branco');
    }
  });
}
