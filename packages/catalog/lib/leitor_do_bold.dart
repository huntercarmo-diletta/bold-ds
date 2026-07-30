/// A VOLTA — ler o código de uma tela do Bold de novo como spec.
///
/// É a quarta fiação do contrato de componente, e a que faltava aqui. Sem ela, tela que só existe
/// como código aparece no catálogo **como código**, sem preview — e quem monta tela perde a metade
/// que importa: abrir o que já existe, mexer, e gerar de volta.
///
/// A divisão: o motor sabe ler expressão Dart (`ehCtor`, `argString`, `argBool`…); o MAPA de
/// construtor → bloco é vocabulário, então é do filho. Só este pacote sabe que
/// `ds.BoldSaldo(...)` é o bloco `saldo`.
///
/// ## O que este leitor NÃO faz, dito claro
///
/// Ele reconhece os 17 blocos do registro, um por um. Construtor que ele não conhece vira bloco
/// CRU — a tela aparece, e o pedaço desconhecido fica visível como código à mão em vez de
/// desaparecer. Preferi isso a tentar adivinhar: preview que erra é pior que preview que declara
/// o que não entendeu.
library;

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

/// Lê uma tela inteira. O motor entrega o código e o nome; a gente devolve a spec.
ScreenSpec lerTelaDoBold(String codigo, String nome) {
  final blocos = <Block>[];
  final lista = primeiraListaDeChildren(codigo);
  if (lista != null) {
    for (final item in separaNoTopo(lista)) {
      final expr = semConst(item.trim());
      // Vírgula final é idiomática em Dart, e o separador devolve um item VAZIO por causa dela.
      // Sem este descarte, toda tela lida ganhava um bloco fantasma no fim — achado por teste, e
      // é o tipo de defeito que na tela apareceria como "um bloco cru que ninguém pôs ali".
      if (expr.isEmpty) continue;
      blocos.add(_bloco(expr));
    }
  }
  return ScreenSpec(name: nome, blocks: blocos);
}

var _id = 0;
Block _mk(String tipo, Map<String, dynamic> props) =>
    Block(id: 'lido-${_id++}', type: tipo, props: props);

/// Construtor → bloco. Um `if` por bloco, e a ordem não importa porque os construtores são
/// distintos.
Block _bloco(String expr) {
  if (ehCtor(expr, 'ds.DilettaText') || ehCtor(expr, 'DilettaText')) {
    return _mk('texto', {
      'conteudo': primeiraStringPosicional(expr) ?? '',
      'preset': membroDeEnum(expr, 'DilettaType') ?? 'bodyMd',
    });
  }
  if (ehCtor(expr, 'ds.DilettaPageTitle') || ehCtor(expr, 'DilettaPageTitle')) {
    return _mk('tituloDaPagina', {
      'titulo': argString(expr, 'title') ?? '',
      'subtitulo': argString(expr, 'subtitle') ?? '',
    });
  }
  if (ehCtor(expr, 'ds.DilettaButton') || ehCtor(expr, 'DilettaButton')) {
    return _mk('botao', {
      'label': argString(expr, 'label') ?? '',
      'tipo': membroDeEnum(expr, 'DilettaButtonType') ?? 'primary',
      'tamanho': membroDeEnum(expr, 'DilettaButtonSize') ?? 'lg',
      'larguraTotal': argBool(expr, 'fullWidth') ?? false,
    });
  }
  if (ehCtor(expr, 'ds.DilettaInput') || ehCtor(expr, 'DilettaInput')) {
    return _mk('campo', {
      'rotulo': argString(expr, 'label') ?? '',
      'placeholder': argString(expr, 'placeholder') ?? '',
      'ajuda': argString(expr, 'helper') ?? '',
      'erro': argString(expr, 'error') ?? '',
      'desabilitado': argBool(expr, 'disabled') ?? false,
    });
  }
  if (ehCtor(expr, 'ds.DilettaAmountDisplay') || ehCtor(expr, 'DilettaAmountDisplay')) {
    return _mk('valor', {
      'valor': argString(expr, 'value') ?? '',
      'rotulo': argString(expr, 'label') ?? '',
      'carimbo': argString(expr, 'timestamp') ?? '',
      'heroi': argBool(expr, 'hero') ?? false,
    });
  }
  if (ehCtor(expr, 'ds.DilettaStatusTag') || ehCtor(expr, 'DilettaStatusTag')) {
    return _mk('selo', {
      'label': argString(expr, 'label') ?? '',
      'tom': membroDeEnum(expr, 'DilettaStatusTone') ?? 'neutral',
    });
  }
  if (ehCtor(expr, 'ds.DilettaNoticeBanner') || ehCtor(expr, 'DilettaNoticeBanner')) {
    return _mk('aviso', {
      'titulo': argString(expr, 'title') ?? '',
      'descricao': argString(expr, 'description') ?? '',
      'ilustracao': membroDeEnum(expr, 'DilettaIllustration') ?? '',
    });
  }
  if (ehCtor(expr, 'ds.DilettaIcon') || ehCtor(expr, 'DilettaIcon')) {
    return _mk('icone', {
      'nome': membroDeEnum(expr, 'DilettaIcons') ?? 'bellLight',
      'tamanho': argNumeroComoTexto(expr, 'size') ?? '24',
    });
  }
  if (ehCtor(expr, 'ds.DilettaGap.h') || ehCtor(expr, 'DilettaGap.h')) {
    return _mk('ritmo', {'tamanho': membroDeEnum(expr, 'DilettaSpacing') ?? 's4'});
  }
  if (ehCtor(expr, 'ds.DilettaDivider') || ehCtor(expr, 'DilettaDivider')) {
    return _mk('divisor', {});
  }
  if (ehCtor(expr, 'ds.DilettaBottomApp.button') || ehCtor(expr, 'DilettaBottomApp.button')) {
    return _mk('barraDeBaixo', {
      // O rótulo mora DENTRO do botão de navegação, então a busca é aninhada — é o mesmo motivo
      // pelo qual o codegen deste bloco aninha.
      'label': argStringEm(expr, 'DilettaNavigationAction', 'label') ?? '',
      'labelSecundario': '',
    });
  }
  // ── os que nasceram neste filho ──
  if (ehCtor(expr, 'ds.BoldSaldo') || ehCtor(expr, 'BoldSaldo')) {
    return _mk('saldo', {
      'valor': argString(expr, 'valor') ?? '',
      'entradas': argString(expr, 'entradas') ?? '',
      'saidas': argString(expr, 'saidas') ?? '',
      'oculto': argBool(expr, 'oculto') ?? false,
    });
  }
  if (ehCtor(expr, 'ds.BoldSeloQuantico') || ehCtor(expr, 'BoldSeloQuantico')) {
    return _mk('seloQuantico', {
      'estado': membroDeEnum(expr, 'BoldSeloEstado') ?? 'autorizado',
      'tamanho': argNumeroComoTexto(expr, 'tamanho') ?? '160',
      'rotulo': argBool(expr, 'mostrarRotulo') ?? true,
    });
  }
  if (ehCtor(expr, 'ds.BoldCopiar') || ehCtor(expr, 'BoldCopiar')) {
    return _mk('copiar', {
      'texto': argString(expr, 'texto') ?? '',
      'rotulo': argString(expr, 'rotuloDeAcessibilidade') ?? '',
    });
  }
  if (ehCtor(expr, 'ds.BoldAbas') || ehCtor(expr, 'BoldAbas')) {
    return _mk('abas', {
      'abas': linhasDeStrings(expr, 'abas')?.replaceAll('\n', ', ') ?? '',
      'selecionada': '${argInt(expr, 'indiceSelecionado') ?? 0}',
    });
  }
  // Desconhecido: vira bloco cru com o código dentro. A tela aparece, e o pedaço que o leitor não
  // entendeu fica VISÍVEL como código à mão — que é o sinal certo pra alguém declarar o bloco que
  // falta, em vez de o pedaço desaparecer em silêncio.
  return _mk('cru', {'codigo': expr});
}
