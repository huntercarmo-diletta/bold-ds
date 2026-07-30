/// A VOLTA — ler o código de uma tela do Bold de novo como spec.
///
/// Depois da v0.30.0 do motor, este arquivo é quase só a chamada da TABELA. O bloco declara
/// `ctor` + `args` no registro, e o motor emite e lê com a mesma declaração: a volta deixou de
/// ser artefato, porque é a ida invertida.
///
/// **Sobraram QUATRO entradas**, e o que elas têm em comum é uma coisa só: o dado do bloco não cabe em
/// argumento literal, que é o que a tabela sabe fazer.
///
/// - `barraDeBaixo` aninha três níveis (`BottomApp(button: NavigationButton(primary:
///   NavigationAction(label:)))`) — o rótulo mora lá embaixo;
/// - `lista` tem FILHOS em vez de props, e é a única que recursa: cada item volta por `_bloco`, então a
///   linha de menu e a linha de valor são lidas pela tabela, de graça;
/// - `escadaDeAlcadas` recebe uma LISTA de degraus, que no código vira variável da tela;
/// - `prazoDaPendencia` recebe um `Duration`, e não há kind de duração no `Arg`.
///
/// Chegaram a ser SEIS por um defeito do motor — `texto` e `ritmo` recebem o conteúdo POSICIONAL e a
/// tabela só sabia emitir `nome: valor`. A v0.33.1 trouxe `Arg.textoPosicional`, e os dois voltaram.
///
/// Antes: 15 entradas à mão, 60 linhas de `if`. Agora: a tabela cobre 20 de 24 blocos, e as quatro que
/// sobram são as que ela não tem como cobrir.
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
  // 1 · A TABELA primeiro: 20 dos 24 blocos declaram `ctor` + `args`, e o motor lê os dois lados
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

  // 3 · Os dois blocos cujo DADO não cabe em argumento literal:
  //
  // - a escada recebe uma lista de degraus, que no código gerado é uma variável da tela (`degrausDaAlcada`).
  //   Ler de volta devolve o bloco com os degraus de exemplo — o mesmo contrato do visor de código, e o
  //   motor sabe disso: prop de PREVIEW não é prop de código;
  // - o prazo recebe `Duration`, e `Arg` não tem kind de duração. O bloco declara HORAS e o codegen monta
  //   o `Duration`, então a volta desmonta.
  if (ehCtor(expr, 'ds.BoldEscadaDeAlcadas') || ehCtor(expr, 'BoldEscadaDeAlcadas')) {
    return Block(id: _novoId(), type: 'escadaDeAlcadas', props: {
      ...Ds.blocos['escadaDeAlcadas']!.defaults(),
      'densa': argBool(expr, 'densa') ?? false,
    });
  }
  if (ehCtor(expr, 'ds.BoldPrazoDaPendencia') || ehCtor(expr, 'BoldPrazoDaPendencia')) {
    return Block(id: _novoId(), type: 'prazoDaPendencia', props: {
      'horas': argNumeroComoTexto(expr, 'hours') ?? '',
      'idade': argString(expr, 'idade') ?? '',
    });
  }

  // Os segmentos: lista curta de rótulos, que a tabela não declara (mesmo caso das abas). O bloco lê
  // os rótulos de volta do próprio literal.
  if (ehCtor(expr, 'ds.BoldSegmentos') || ehCtor(expr, 'BoldSegmentos')) {
    return Block(id: _novoId(), type: 'segmentos', props: {
      'segmentos': _rotulos(expr),
      'selecionado': argNumeroComoTexto(expr, 'indiceSelecionado') ?? '0',
    });
  }

  // 4 · A forma irregular, que fica fora da tabela por decisão do motor: o rótulo mora três níveis
  // abaixo do construtor, e é o próprio pai que diz que tabela não cobre aninhamento.
  if (ehCtor(expr, 'ds.DilettaBottomApp.button') ||
      ehCtor(expr, 'DilettaBottomApp.button')) {
    return Block(id: _novoId(), type: 'barraDeBaixo', props: {
      'label': argStringEm(expr, 'DilettaNavigationAction', 'label') ?? '',
      'labelSecundario': '',
    });
  }

  // 5 · Desconhecido: bloco cru com o código dentro. A tela aparece, e o pedaço que ninguém
  // declarou fica VISÍVEL como código à mão — que é o sinal certo pra declarar o bloco que falta,
  // em vez de o pedaço desaparecer em silêncio.
  return Block(id: _novoId(), type: 'cru', props: {'codigo': expr});
}

/// Os rótulos de uma lista curta (`const ['a', 'b']`) de volta como texto separado por vírgula, que é
/// como o editor guarda. Vale pras abas e pros segmentos.
String _rotulos(String expr) {
  final lista = RegExp(r'\[(.*?)\]', dotAll: true).firstMatch(expr)?.group(1) ?? '';
  return RegExp(r"'([^']*)'")
      .allMatches(lista)
      .map((m) => m.group(1)!)
      .join(', ');
}
