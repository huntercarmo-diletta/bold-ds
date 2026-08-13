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
/// Antes: 15 entradas à mão, 60 linhas de `if`. Agora: **46 dos 56 blocos declaram `ctor`** (42 com
/// `args`, medido em 2026-08-06) e a tabela lê todos eles; as quatro entradas acima são as que ela não
/// tem como cobrir.
///
/// **Cada `if` aqui era DUAS chamadas** (`ehCtor(expr, 'ds.X') || ehCtor(expr, 'X')`), porque a versão
/// antiga do `ehCtor` cravava o prefixo. Desde a v0.30.1 ele aceita as duas formas sozinho — medido nas
/// quatro combinações — e as cinco duplicatas saíram. A auditoria de arquitetura foi quem apontou: este
/// arquivo era o único com cadeia de decisão por tipo, com 10 comparações.
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

/// A expressão do `child:`, com os parênteses equilibrados.
///
/// O motor tem `argString` e `primeiraListaDeChildren`, e nenhum dos dois serve: o primeiro devolve
/// literal e o segundo devolve LISTA. Aqui o filho é UM widget aninhado, então quem conta os
/// parênteses é esta função — parar na primeira vírgula pegaria metade de um construtor.
String? _filhoDe(String expr) {
  final m = RegExp(r'\bchild:\s*').firstMatch(expr);
  if (m == null) return null;
  var nivel = 0;
  for (var i = m.end; i < expr.length; i++) {
    final c = expr[i];
    if (c == '(' || c == '[') nivel++;
    if (c == ')' || c == ']') {
      if (nivel == 0) return expr.substring(m.end, i).trim();
      nivel--;
    }
    if (c == ',' && nivel == 0) return expr.substring(m.end, i).trim();
  }
  return expr.substring(m.end).trim();
}

/// O ENVELOPE DE ALINHAMENTO, desembrulhado antes de tudo.
///
/// O motor emite o `crossAlign` como um widget POR FORA do bloco — `Align(alignment: …)` pros
/// extremos e `Center` pro meio —, e o meu leitor lia só o de dentro. Resultado: quem mudava o
/// alinhamento no compositor via a escolha sumir na volta, **sem nada falhar**.
///
/// Quem achou foi a checagem `alinhamento-nao-volta` do motor (v0.104.0), na primeira execução dela
/// contra este filho. Eu não tinha como achar: nenhuma das minhas telas declara alinhamento, então
/// o defeito só existia no caminho que ninguém tinha andado ainda.
///
/// ## A ordem dos testes é o aviso que veio junto, e ele evita um terceiro valor errado
///
/// `AlignmentDirectional.centerEnd` **contém a palavra `center`**. Testar `center` primeiro devolve
/// `center` pra uma coisa que é `end` — não é falha, é resposta errada, que é pior. Então os
/// extremos vêm antes, e as duas grafias (`Alignment` e `AlignmentDirectional`) são lidas pelo mesmo
/// padrão porque a segunda é a que o motor VAI emitir quando o eixo de direção fechar.
({String align, String dentro})? _envelopeDeAlinhamento(String expr) {
  if (ehCtor(expr, 'Align')) {
    final m = RegExp(r'Alignment(?:Directional)?\.(\w+)').firstMatch(expr);
    final nome = m?.group(1) ?? '';
    // Extremos ANTES do meio — ver o `///`.
    final align = nome.contains('Right') || nome.contains('End')
        ? 'end'
        : (nome.contains('Left') || nome.contains('Start') ? 'start' : null);
    if (align == null) return null;
    final dentro = _filhoDe(expr);
    if (dentro == null) return null;
    return (align: align, dentro: dentro);
  }
  if (ehCtor(expr, 'Center')) {
    final dentro = _filhoDe(expr);
    if (dentro == null) return null;
    return (align: 'center', dentro: dentro);
  }
  return null;
}

Block _bloco(String expr) {
  // O envelope primeiro: o alinhamento é um widget POR FORA, e sem desembrulhar nada aqui reconhece
  // o construtor de dentro.
  final envelope = _envelopeDeAlinhamento(expr);
  if (envelope != null) {
    final dentro = _bloco(semConst(envelope.dentro.trim()));
    return Block(
      id: dentro.id,
      type: dentro.type,
      props: dentro.props,
      slots: dentro.slots,
      bindings: dentro.bindings,
      listBindings: dentro.listBindings,
      visibleBinding: dentro.visibleBinding,
      fill: dentro.fill,
      fixedMain: dentro.fixedMain,
      pin: dentro.pin,
      sticky: dentro.sticky,
      crossAlign: envelope.align,
    );
  }

  // 1 · A TABELA primeiro: 42 dos 56 blocos declaram `ctor` + `args` (46 declaram `ctor`), e o motor
  // lê os dois lados com a mesma declaração — inclusive aceitando o construtor sem o prefixo `ds.`,
  // que é como código colado por alguém costuma chegar.
  final daTabela = leBlocoDaTabela(expr, Ds.blocos, novoId: _novoId);
  if (daTabela != null) return daTabela;

  // 2 · A LISTA: aninhamento de verdade, e o único caso deste leitor que RECURSA. A coleção não cabe
  // na tabela (ela não tem prop nenhuma no código — tem filhos), então quem lê os itens é a mesma
  // função que lê a tela: cada item volta por `_bloco`, inclusive pela tabela.
  for (final idioma in const ['carded', 'plain', 'menu']) {
    if (!ehCtor(expr, 'ds.DilettaAppList.$idioma')) continue;
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

  // 2a · A GRADE, que é o outro container com filhos. Ela tem DUAS formas no código — `.column` de
  // `Row`s (colunas fixas) e `.row` direto (fileira) — e a volta distingue pela presença do
  // `Expanded`, que é o que a forma de colunas usa e a fileira não.
  if (ehCtor(expr, 'ds.DilettaFrame.column') || ehCtor(expr, 'ds.DilettaFrame.row')) {
    final fileira = ehCtor(expr, 'ds.DilettaFrame.row');
    final colunas = fileira
        ? 'fileira'
        : '${'Expanded(child:'.allMatches(expr).length ~/ _linhasNoCodigo(expr)}';
    return Block(
      id: _novoId(),
      type: 'grade',
      props: {
        'colunas': colunas,
        'vao': RegExp(r'DilettaSpacing\.(s\d)').firstMatch(expr)?.group(1) ?? 's4',
      },
      slots: {
        'itens': [
          for (final item in _dentroDosExpanded(expr))
            if (item.isNotEmpty) _bloco(item),
        ],
      },
    );
  }

  // 2a-bis · A LINHA DE VALOR, que saiu da tabela quando parou de emitir a fábrica do pai.
  //
  // Ela compõe TRÊS acessórios (`spotIcon` + `titleSubtitleSubtitle` + `amount`), e a tabela lê
  // `Ctor(args)` — composição de acessórios não cabe. A volta lê cada um pelo argumento dele, e o
  // sinal de entrada/saída vem do MEMBRO do `DilettaAmount`, que é onde ele mora no código.
  if (ehCtor(expr, 'ds.DilettaAppListRow') &&
      expr.contains('titleSubtitleSubtitle') &&
      expr.contains('DilettaAmount')) {
    return Block(id: _novoId(), type: 'linhaDeValor', props: {
      'icone': RegExp(r'DilettaIcons\.(\w+)').firstMatch(expr)?.group(1) ?? 'pixLight',
      // `argStringEm` ancora no nome do ARGUMENTO e não no do construtor — ele procura
      // `\bnome\s*:`. Então a âncora é `middle:` e `right:`, que são os acessórios, e não
      // `titleSubtitleSubtitle` ou `DilettaAmount`. Foi o que me custou uma rodada aqui.
      //
      // `subtitle` não casa dentro de `accessorySubtitle` porque o `\b` exige fronteira de palavra
      // antes, e ali vem uma letra.
      'titulo': argStringEm(expr, 'middle', 'title') ?? '',
      'hora': argStringEm(expr, 'middle', 'subtitle') ?? '',
      'origem': argStringEm(expr, 'middle', 'accessorySubtitle') ?? '',
      'valor': argStringEm(expr, 'right', 'value') ?? '',
      // O sinal mora no MEMBRO do amount (`cashOut`/`cashIn`), que é onde ele vive no código.
      'saida': expr.contains('cashOut'),
    });
  }

  // 2a-quinquies · O CARTÃO PROMOCIONAL, que saiu da tabela quando a arte entrou: a ilustração é um
  // WIDGET aninhado, e a tabela só lê valor literal. A volta lê o TOKEN de dentro do acessório, que é
  // onde ele mora no código; sem acessório declarado, a arte fica vazia e o cartão cai no placeholder.
  if (ehCtor(expr, 'ds.BoldCartaoPromocional')) {
    return Block(id: _novoId(), type: 'cartaoPromocional', props: {
      'titulo': argString(expr, 'titulo') ?? '',
      'subtitulo': argString(expr, 'subtitulo') ?? '',
      'ilustracao':
          RegExp(r'DilettaIllustration\.(\w+)').firstMatch(expr)?.group(1) ?? '',
      // `aoFechar` presente é o X do canto: o componente esconde o botão quando o callback é nulo, e
      // é essa presença que o bloco guarda como booleano.
      'fecha': expr.contains('aoFechar'),
    });
  }

  // 2a-quater · A NAV FLUTUANTE, que tem lista de filhos e por isso não cabe na tabela. Os itens não
  // são blocos (são `BoldItemDeNav`, dado), então a volta os lê como o texto `Rótulo:icone` — o mesmo
  // idioma em que eles foram escritos.
  if (ehCtor(expr, 'ds.BoldNavFlutuante')) {
    final pares = RegExp(r"BoldItemDeNav\(\s*icone:\s*ds\.DilettaIcons\.(\w+)\s*,"
            r"\s*rotulo:\s*'([^']*)'")
        .allMatches(expr)
        .map((m) => '${m.group(2)}:${m.group(1)}')
        .join(', ');
    return Block(id: _novoId(), type: 'navFlutuante', props: {
      'abas': pares,
      'abaAtiva': RegExp(r'ativo:\s*(\d+)').firstMatch(expr)?.group(1) ?? '0',
    });
  }

  // 2a-ter · A LINHA DE ESCOLHA, pela mesma razão da de valor: composição de três acessórios não cabe
  // na tabela de `Ctor(args)`.
  //
  // A assinatura dela é o `title` sozinho no meio — as outras duas linhas põem subtítulo lá. Por isso a
  // ordem importa e esta vem DEPOIS da linha de valor: `AppListRow` é o mesmo construtor nos três, e
  // quem separa é o acessório. A escolha é lida pela PRESENÇA do check à direita, que é onde ela mora
  // no código: linha não escolhida não tem `right:` nenhum.
  if (ehCtor(expr, 'ds.DilettaAppListRow') &&
      expr.contains('MiddleAccessory.title(')) {
    return Block(id: _novoId(), type: 'linhaDeEscolha', props: {
      'icone': RegExp(r'DilettaIcons\.(\w+)').firstMatch(expr)?.group(1) ?? 'sunLight',
      'titulo': argStringEm(expr, 'middle', 'title') ?? '',
      'escolhido': expr.contains('circleCheckSolid'),
    });
  }

  // 2b · O GRUPO DO DIA, que é a segunda coleção com filhos deste vocabulário. Mesma razão da lista e
  // mesma recursão: os lançamentos voltam por `_bloco`, então a `linhaDeValor` é lida pela tabela de
  // graça. O que ele tem a mais é o acessório — que no código é um `DilettaText` inteiro, e volta
  // como o texto dele.
  if (ehCtor(expr, 'ds.BoldGrupoDoDia')) {
    final itens = primeiraListaDeChildren(expr);
    return Block(
      id: _novoId(),
      type: 'grupoDoDia',
      props: {
        'rotulo': argString(expr, 'rotulo') ?? '',
        'acessorio': argStringEm(expr, 'DilettaText', '') ?? '',
      },
      slots: {
        'itens': [
          for (final item in separaNoTopo(itens ?? ''))
            if (semConst(item.trim()).isNotEmpty) _bloco(semConst(item.trim())),
        ],
      },
    );
  }

  // A FILEIRA DE AVATARES: três listas paralelas de literais, e a tabela lê argumento escalar. Mesmo
  // caso das abas e dos segmentos, três vezes — por isso `_rotulos` ganhou o parâmetro do argumento
  // em vez de continuar pegando o PRIMEIRO `[...]` da expressão, que aqui seria sempre as iniciais.
  if (ehCtor(expr, 'ds.BoldFileiraDeAvatares')) {
    return Block(id: _novoId(), type: 'fileiraDeAvatares', props: {
      'iniciais': _rotulos(expr, argumento: 'iniciais'),
      'rotulos': _rotulos(expr, argumento: 'rotulos'),
      'subrotulos': _rotulos(expr, argumento: 'subrotulos'),
      'adiciona': expr.contains('aoAdicionar'),
    });
  }

  // 3 · Os dois blocos cujo DADO não cabe em argumento literal:
  //
  // - a escada recebe uma lista de degraus, que no código gerado é uma variável da tela (`degrausDaAlcada`).
  //   Ler de volta devolve o bloco com os degraus de exemplo — o mesmo contrato do visor de código, e o
  //   motor sabe disso: prop de PREVIEW não é prop de código;
  // - o prazo recebe `Duration`, e `Arg` não tem kind de duração. O bloco declara HORAS e o codegen monta
  //   o `Duration`, então a volta desmonta.
  if (ehCtor(expr, 'ds.BoldEscadaDeAlcadas')) {
    return Block(id: _novoId(), type: 'escadaDeAlcadas', props: {
      ...Ds.blocos['escadaDeAlcadas']!.defaults(),
      'densa': argBool(expr, 'densa') ?? false,
    });
  }
  if (ehCtor(expr, 'ds.BoldPrazoDaPendencia')) {
    return Block(id: _novoId(), type: 'prazoDaPendencia', props: {
      'horas': argNumeroComoTexto(expr, 'hours') ?? '',
      'idade': argString(expr, 'idade') ?? '',
    });
  }

  // Os segmentos: lista curta de rótulos, que a tabela não declara (mesmo caso das abas). O bloco lê
  // os rótulos de volta do próprio literal.
  if (ehCtor(expr, 'ds.BoldSegmentos')) {
    return Block(id: _novoId(), type: 'segmentos', props: {
      'segmentos': _rotulos(expr),
      'selecionado': argNumeroComoTexto(expr, 'indiceSelecionado') ?? '0',
    });
  }

  // O ESQUELETO: virou PAR na v0.10.0 (`Shimmer(child: Skeleton.box)`) porque a forma do pai não anima
  // sozinha, e o board mostrava caixa cinza parada onde o app mostra a varredura. Aninhamento de dois
  // níveis não cabe na tabela, então a volta é lida à mão — e as duas medidas vêm do construtor de
  // DENTRO, que é onde elas moram.
  if (ehCtor(expr, 'ds.DilettaShimmer')) {
    return Block(id: _novoId(), type: 'esqueleto', props: {
      'largura': argNumeroComoTexto(expr, 'width') ?? '180',
      'altura': argNumeroComoTexto(expr, 'height') ?? '16',
    });
  }

  // A CASCA DE TOPO: aninha casca → barra → acessório, e a tabela não cobre aninhamento. O acessório
  // esquerdo volta pelo NOME do construtor dele, que é o único sinal disponível no código.
  if (ehCtor(expr, 'ds.DilettaTopAppBar.defaultVariant')) {
    return Block(id: _novoId(), type: 'cascaDeTopo', props: {
      'titulo': argString(expr, 'title') ?? '',
      'esquerda': expr.contains('LeftAccessory.close')
          ? 'fechar'
          : expr.contains('LeftAccessory.back')
              ? 'voltar'
              : 'nada',
    });
  }

  // 4 · A forma irregular, que fica fora da tabela por decisão do motor: o rótulo mora três níveis
  // abaixo do construtor, e é o próprio pai que diz que tabela não cobre aninhamento.
  if (ehCtor(expr, 'ds.DilettaBottomApp.button')) {
    return Block(id: _novoId(), type: 'barraDeBaixo', props: {
      'label': argStringEm(expr, 'DilettaNavigationAction', 'label') ?? '',
      'labelSecundario': '',
    });
  }

  // 5 · O divisor, que virou UNIÃO de três formas. Fica fora da tabela pelo mesmo motivo da barra de
  // baixo: dois dos três emitidos não são `Ctor(args)` — um é construtor NOMEADO (`.dashed()`) e o
  // outro vem aninhado num `SizedBox` que dá o eixo. A ordem importa: `.dashed`/`.vertical` antes do
  // liso, senão o prefixo `ds.DilettaDivider` casa os três e toda forma volta como linha.
  if (ehCtor(expr, 'ds.DilettaDivider.dashed')) {
    return Block(id: _novoId(), type: 'divisor', props: {'forma': 'tracejado'});
  }
  if (expr.contains('ds.DilettaDivider.vertical')) {
    return Block(id: _novoId(), type: 'divisor', props: {'forma': 'vertical'});
  }
  if (ehCtor(expr, 'ds.DilettaDivider')) {
    return Block(id: _novoId(), type: 'divisor', props: {'forma': 'linha'});
  }

  // 5 · Desconhecido: bloco cru com o código dentro. A tela aparece, e o pedaço que ninguém
  // declarou fica VISÍVEL como código à mão — que é o sinal certo pra declarar o bloco que falta,
  // em vez de o pedaço desaparecer em silêncio.
  return Block(id: _novoId(), type: 'cru', props: {'codigo': expr});
}

/// Quantas `Row` a grade tem no código — o denominador de "quantos `Expanded` por linha".
///
/// Zero vira 1 de propósito: a divisão por zero de uma grade sem linha nenhuma daria erro, e o que
/// se quer dali é uma coluna, não uma exceção.
int _linhasNoCodigo(String expr) {
  final quantas = 'Row(children:'.allMatches(expr).length;
  return quantas == 0 ? 1 : quantas;
}

/// Os blocos de dentro dos `Expanded` (forma de colunas) ou os filhos diretos (fileira).
///
/// A célula vazia do fim (`const Expanded(child: SizedBox())`) sai aqui: ela é preenchimento de
/// grade, não item — devolvê-la faria a volta ganhar um bloco que ninguém declarou.
List<String> _dentroDosExpanded(String expr) {
  final lista = primeiraListaDeChildren(expr) ?? '';
  final itens = <String>[];
  for (final bruto in separaNoTopo(lista)) {
    var item = semConst(bruto.trim());
    if (item.isEmpty) continue;
    if (item.startsWith('SizedBox(width:') || item.startsWith('SizedBox(height:')) continue;
    if (item.startsWith('Row(')) {
      itens.addAll(_dentroDosExpanded(item));
      continue;
    }
    if (item.startsWith('Expanded(')) {
      final dentro = RegExp(r'^Expanded\(child:\s*(.*)\)$', dotAll: true)
          .firstMatch(item)
          ?.group(1)
          ?.trim();
      if (dentro == null || dentro == 'SizedBox()') continue;
      item = semConst(dentro);
    }
    itens.add(item);
  }
  return itens;
}

/// Os rótulos de uma lista curta (`const ['a', 'b']`) de volta como texto separado por vírgula, que é
/// como o editor guarda. Vale pras abas, pros segmentos e pras três listas da fileira de avatares.
///
/// Sem [argumento] pega a PRIMEIRA lista da expressão, que é o que abas e segmentos precisam — eles
/// têm uma só. Com ele, pega a lista daquele argumento nomeado: a fileira tem três, e a primeira
/// seria sempre as iniciais.
String _rotulos(String expr, {String? argumento}) {
  final padrao = argumento == null
      ? RegExp(r'\[(.*?)\]', dotAll: true)
      : RegExp('$argumento:\\s*(?:const\\s*)?\\[(.*?)\\]', dotAll: true);
  final lista = padrao.firstMatch(expr)?.group(1) ?? '';
  return RegExp(r"'([^']*)'")
      .allMatches(lista)
      .map((m) => m.group(1)!)
      .join(', ');
}
