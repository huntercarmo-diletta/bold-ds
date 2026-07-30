/// A VOLTA — ler o código de uma tela do Bold de novo como spec.
///
/// Depois da v0.30.0 do motor, este arquivo é quase só a chamada da TABELA. O bloco declara
/// `ctor` + `args` no registro, e o motor emite e lê com a mesma declaração: a volta deixou de
/// ser artefato, porque é a ida invertida.
///
/// **Sobraram DUAS entradas**, e as duas são a mesma razão: ANINHAMENTO, que a tabela não cobre por
/// decisão do motor.
///
/// - `barraDeBaixo` aninha três níveis (`BottomApp(button: NavigationButton(primary:
///   NavigationAction(label:)))`) — o rótulo mora lá embaixo;
/// - `lista` tem FILHOS em vez de props, e é a única que recursa: cada item volta por `_bloco`, então a
///   linha de menu e a linha de valor são lidas pela tabela, de graça.
///
/// Chegaram a ser quatro por um defeito do motor — `texto` e `ritmo` recebem o conteúdo POSICIONAL e a
/// tabela só sabia emitir `nome: valor`. A v0.33.1 trouxe `Arg.textoPosicional`, e os dois voltaram.
///
/// Antes: 15 entradas à mão, 60 linhas de `if`. Agora: a tabela mais dois casos de aninhamento.
library;

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

/// Lê uma tela inteira. O motor entrega o código e o nome; a gente devolve a spec.
ScreenSpec lerTelaDoBold(String codigo, String nome) {
  final blocos = <Block>[];
  final lista = primeiraListaDeChildren(codigo);
  if (lista != null) {
    for (final item in separaNoTopo(lista)) {
      final expr = semConst(item.trim());
      // Vírgula final é idiomática em Dart, e o separador devolve item VAZIO por causa dela. Sem
      // este descarte, toda tela lida ganhava um bloco fantasma no fim.
      if (expr.isEmpty) continue;
      blocos.add(_bloco(expr));
    }
  }
  return ScreenSpec(name: nome, blocks: blocos);
}

var _id = 0;
String _novoId() => 'lido-${_id++}';

Block _bloco(String expr) {
  // 1 · A TABELA primeiro: 15 dos 17 blocos declaram `ctor` + `args`, e o motor lê os dois lados
  // com a mesma declaração — inclusive aceitando o construtor sem o prefixo `ds.`, que é como
  // código colado por alguém costuma chegar.
  final daTabela = leBlocoDaTabela(expr, Ds.blocos, novoId: _novoId);
  if (daTabela != null) return daTabela;

  // 2 · A LISTA: aninhamento de verdade, e o único caso deste leitor que RECURSA. A coleção não cabe
  // na tabela (ela não tem prop nenhuma no código — tem filhos), então quem lê os itens é a mesma
  // função que lê a tela: cada item volta por `_bloco`, inclusive pela tabela.
  for (final idioma in const ['carded', 'plain', 'menu']) {
    if (!ehCtor(expr, 'ds.DilettaAppList.$idioma') &&
        !ehCtor(expr, 'DilettaAppList.$idioma')) {
      continue;
    }
    final itens = primeiraListaDeChildren(expr);
    return Block(
      id: _novoId(),
      type: 'lista',
      props: {'titulo': argString(expr, 'title') ?? '', 'idioma': idioma},
      slots: {
        'itens': [
          for (final item in separaNoTopo(itens ?? ''))
            if (semConst(item.trim()).isNotEmpty) _bloco(semConst(item.trim())),
        ],
      },
    );
  }

  // 3 · A forma irregular, que fica fora da tabela por decisão do motor: o rótulo mora três níveis
  // abaixo do construtor, e é o próprio pai que diz que tabela não cobre aninhamento.
  if (ehCtor(expr, 'ds.DilettaBottomApp.button') ||
      ehCtor(expr, 'DilettaBottomApp.button')) {
    return Block(id: _novoId(), type: 'barraDeBaixo', props: {
      'label': argStringEm(expr, 'DilettaNavigationAction', 'label') ?? '',
      'labelSecundario': '',
    });
  }

  // 4 · Desconhecido: bloco cru com o código dentro. A tela aparece, e o pedaço que ninguém
  // declarou fica VISÍVEL como código à mão — que é o sinal certo pra declarar o bloco que falta,
  // em vez de o pedaço desaparecer em silêncio.
  return Block(id: _novoId(), type: 'cru', props: {'codigo': expr});
}
