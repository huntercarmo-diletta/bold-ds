/// AS TELAS DO BOLD — e até agora eram ZERO.
///
/// O pai mediu a frase que abre este arquivo, na v0.55.0 do motor: *"um filho tem 124 telas, o outro tem
/// ZERO."* Ele está certo, e o custo é o que ele diz na linha seguinte — **todo o pipeline de tela tinha um
/// usuário só**, então cada defeito daquele caminho era invisível por construção deste lado.
///
/// A HOME é a primeira, e a escolha não é por ser fácil: é a tela mais montada deste produto (topo + saldo
/// + duas coleções + destaque + barra), a que mais componentes atravessa, e a única cujo fundo é o mood de
/// imagem — que era o componente mais usado do DS aparecendo degradado no catálogo até anteontem.
///
/// ## Ela é DECLARAÇÃO, e passa pela validação do pai
///
/// O JSON vai por `montaDaAutoria`, que reprova prop inexistente, enum fora do vocabulário, slot que não
/// existe e id repetido — tudo de uma vez. Prop com nome errado é o erro mais barato de cometer e o mais
/// caro de achar, porque ela é **ignorada em silêncio** e a tela renderiza com o valor normal.
///
/// ## Os bindings são o ponto, e não enfeite
///
/// Cinco props saem como `bindings` em vez de texto: saldo, entradas, saídas, nome e conta. A regra do
/// contrato de autoria é dura e está certa — *"placeholder escrito à mão vira mock silencioso: o dev copia o
/// código e leva o texto fixo"*. Com binding, a tela **diz qual dado ela quer**, e a seção CONSOME do
/// contrato responde por ela.
///
/// E isso me deu o que devolver ao pai: a v0.55.0 dele consertou a seção CONSOME, que estava **vazia pra
/// toda tela real** porque a fixture usava a representação que o compositor não produz. Esta tela é escrita
/// na representação do produtor (`bindings` no bloco), então ela é o caso de verdade — e o gate deste repo
/// mede que a seção não volta a esvaziar.
library;

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

/// O slug é a chave estável — é por ele que fluxo, seta e deep-link apontam.
const String kSlugDaHome = 'pf1-home';

/// A segunda tela, e ela é da conta PJ — o outro eixo macro deste produto.
const String kSlugDasAutorizacoes = 'pj1-autorizacoes';

/// A terceira, e a primeira que fica no MESMO fluxo de outra: `pf1-home` → esta.
const String kSlugDoValorDoPix = 'pf2-pix-valor';

/// A HOME da conta PF, medida em `home_tab_redesign.dart`.
///
/// A ordem é a do app: barra de topo com saudação, saldo com entradas e saídas, atalhos, o que precisa de
/// atenção, e o destaque da conta PJ. O `barraDeStatus` e o `indicadorDeHome` são chrome de APARELHO — por
/// contrato eles não saem no código gerado, e existem pra a tela parecer uma tela no board.
///
/// O que eu NÃO reproduzi, e é decisão: o app tem uma fileira de avatares (`BoldAvatarRow`) e um carrossel
/// horizontal de promo. Nenhum dos dois é bloco deste registro, porque nenhum dos dois passou a medição de
/// uso que este DS exige — e inventar bloco pra completar um desenho é a ordem inversa da que este repo
/// segue. A tela declara o que o vocabulário tem; a falta aparece aqui em vez de virar widget solto.
Map<String, dynamic> _homeDaPf() => {
      'slug': kSlugDaHome,
      'name': 'PF1 · Home',
      'form': 'phone',
      'scrollableContent': true,
      'contentGap': 's5',
      'top': [
        {'type': 'barraDeStatus'},
        {
          'type': 'cabecalhoDaHome',
          'bindings': {'nome': 'nomeDoTitular', 'conta': 'rotuloDaConta'},
        },
      ],
      'blocks': [
        {
          'type': 'saldo',
          'bindings': {
            'valor': 'saldoFormatado',
            'entradas': 'entradasDoMes',
            'saidas': 'saidasDoMes',
          },
        },
        {'type': 'cabecalhoDeSecao', 'props': {'rotulo': 'ATALHOS'}},
        {
          'type': 'lista',
          'props': {'idioma': 'menu'},
          'slots': {
            'itens': [
              {'type': 'linha', 'props': {'icone': 'pixLight', 'titulo': 'Pix', 'subtitulo': 'Enviar, receber e cobrar'}},
              {'type': 'linha', 'props': {'icone': 'barcodeLight', 'titulo': 'Pagar', 'subtitulo': 'Boleto, conta e recarga'}},
              {'type': 'linha', 'props': {'icone': 'arrowRightArrowLeftLight', 'titulo': 'Transferir', 'subtitulo': 'TED e entre contas'}},
            ],
          },
        },
        {'type': 'cabecalhoDeSecao', 'props': {'rotulo': 'PRECISA DE VOCÊ'}},
        {
          'type': 'lista',
          'props': {'idioma': 'carded'},
          'slots': {
            'itens': [
              {'type': 'linha', 'props': {'icone': 'clockLight', 'titulo': 'Autorização pendente', 'subtitulo': 'Vence em 2 dias'}},
            ],
          },
        },
        {'type': 'cartaoDeDestaque'},
      ],
      'bottom': [
        {'type': 'barraDeBaixo'},
        {'type': 'indicadorDeHome'},
      ],
      'notes': [
        {
          'kind': 'decisao',
          'text': 'O saldo, o nome e o rótulo da conta são BINDING e não texto. Placeholder escrito à mão '
              'vira mock silencioso — o dev copia o código e leva o valor fixo pro app.',
        },
        {
          'kind': 'regra',
          'text': 'O ritmo é o contentGap (s5). Nenhum bloco de espaçamento na tela: 23% dos blocos das '
              '99 telas do primeiro filho eram só espaço, e é a medição que gerou a regra.',
        },
        {
          'kind': 'borda',
          'text': 'Saldo oculto: a prop `oculto` troca o valor por pontos e o leitor de tela anuncia '
              '"saldo oculto". Sem estado próprio de tela — é a mesma HOME.',
        },
        {
          'kind': 'a11y',
          'text': 'O rótulo do botão primário deste DS está em 3,46:1 (abaixo de AA), e o pedido do papel '
              '`primary` está aberto com o pai. Esta tela não tem botão primário por isso.',
        },
      ],
    };

/// AS AUTORIZAÇÕES da conta PJ, medidas em `autorizacoes_screen.dart` (1.216 linhas no app).
///
/// A segunda tela, e a escolha tem duas razões medidas. A primeira: ela é do **outro eixo macro** (PJ), e
/// com uma tela só de PF o board não tinha o que agrupar. A segunda pesa mais — **ela é a única que usa os
/// três componentes que eu construí pra alçada** (`progressoDeAprovacao`, `prazoDaPendencia`,
/// `escadaDeAlcadas`). Eles existiam com uso medido no app e **zero uso em tela declarada aqui**, que é o
/// caso mais fácil de um componente apodrecer sem ninguém ver.
///
/// ## O que eu mudei do app, e por quê
///
/// No app os dois botões são uma LINHA (`Rejeitar` | `Aprovar`). Aqui eles empilham na base, e não é
/// preguiça: este registro **não tem container de linha** — a gramática de superfície do motor é
/// `top`/`blocks`/`bottom`, e linha de botões seria bloco novo. Empilhar é o que o vocabulário permite hoje,
/// e a diferença fica escrita aqui em vez de virar componente inventado pra fechar um desenho.
///
/// A tela do app também repete o cartão por pedido, num `ListView`. A spec declara **um** — o board mostra
/// a forma da tela, não o volume de dados. Repetição vem de `listBindings` no dia em que eu declarar a
/// lista vinculada, e aí é uma linha.
Map<String, dynamic> _autorizacoesDaPj() => {
      'slug': kSlugDasAutorizacoes,
      'name': 'PJ1 · Autorizações',
      'form': 'phone',
      'scrollableContent': true,
      'contentGap': 's4',
      'top': [
        {'type': 'barraDeStatus'},
        {'type': 'cascaDeTopo', 'props': {'titulo': 'Autorizações', 'esquerda': 'voltar'}},
        {'type': 'abas', 'props': {'abas': 'Pendentes, Histórico, Minhas', 'selecionada': '0'}},
      ],
      'blocks': [
        {
          'type': 'valor',
          'props': {'heroi': false},
          'bindings': {
            'valor': 'valorDoPedido',
            'rotulo': 'nomeDoSolicitante',
            'carimbo': 'criadoEm',
          },
        },
        {
          'type': 'progressoDeAprovacao',
          'props': {'exigeMaster': true, 'compacto': false},
          'bindings': {'colhidas': 'assinaturasColhidas', 'exigidas': 'assinaturasExigidas'},
        },
        {'type': 'prazoDaPendencia', 'bindings': {'idade': 'idadeDaPendencia'}},
        {'type': 'cabecalhoDeSecao', 'props': {'rotulo': 'A ALÇADA DESTA CONTA'}},
        {'type': 'escadaDeAlcadas'},
      ],
      'bottom': [
        {'type': 'botao', 'props': {'label': 'Aprovar', 'larguraTotal': true}},
        {
          'type': 'botao',
          'props': {'label': 'Rejeitar', 'tipo': 'secondary', 'estado': 'error', 'larguraTotal': true},
        },
        {'type': 'indicadorDeHome'},
      ],
      'notes': [
        {
          'kind': 'decisao',
          'text': 'Os dois botões empilham porque este registro não tem container de LINHA. No app eles '
              'são uma linha; inventar o bloco pra fechar o desenho seria a ordem inversa da deste repo.',
        },
        {
          'kind': 'regra',
          'text': 'O destrutivo é o ESTADO `error` sobre o tipo secundário, e não um tipo próprio. É a '
              'medição que o botão ganhou: 16 sítios de destrutivo no app, nenhum deles um tipo.',
        },
        {
          'kind': 'borda',
          'text': 'Sem `expiresAt` no contrato do backend, o prazo mostra a IDADE da pendência em vez de '
              'inventar contagem regressiva. É a decisão que o app já tomou, e ela vem junto.',
        },
        {
          'kind': 'a11y',
          'text': 'O progresso anuncia a frase inteira ("1 de 2 assinaturas, exige master") em vez de dois '
              'números soltos, e a escada usa `onPrimarySubtle`/`onSuccessSubtle` — o par que passa em AA.',
        },
      ],
    };

/// O VALOR DO PIX, medida em `pix_valor_screen.dart`.
///
/// A terceira tela, e a primeira que existe **por causa da seta**: `pf1-home` leva a ela pelo atalho de Pix,
/// e é a primeira vez que este produto tem duas telas no mesmo fluxo. Sem isso, `motionDaTransicao` era
/// declaração sobre nada — eu tinha ligado `push` ao token `slow` e **zero setas** pra provar.
///
/// ## O título vazio da barra é do app, e é decisão
///
/// `pix_valor_screen.dart` passa `title: ''`. Não é esquecimento: o contexto está no corpo (*"Transferir
/// para <nome>"*), e repetir no topo seria o mesmo texto duas vezes na mesma dobra. Declaro vazio porque é
/// o que a tela faz — inventar um título aqui faria a doc divergir do produto no primeiro olhar.
Map<String, dynamic> _valorDoPix() => {
      'slug': kSlugDoValorDoPix,
      'name': 'PF2 · Pix · valor',
      'form': 'phone',
      'scrollableContent': true,
      'contentGap': 's4',
      'top': [
        {'type': 'barraDeStatus'},
        {'type': 'cascaDeTopo', 'props': {'titulo': '', 'esquerda': 'voltar'}},
      ],
      'blocks': [
        {'type': 'texto', 'props': {'conteudo': 'Transferir para', 'preset': 'bodySm'}},
        {
          'type': 'texto',
          'props': {'preset': 'titleMd'},
          'bindings': {'conteudo': 'nomeDoDestinatario'},
        },
        {
          'type': 'campo',
          'props': {
            'rotulo': 'Valor',
            'placeholder': r'R$ 0,00',
            'ajuda': 'O valor sai da sua conta na hora.',
          },
        },
        {
          'type': 'lista',
          'props': {'idioma': 'carded'},
          'slots': {
            'itens': [
              {
                'type': 'linha',
                'props': {'icone': 'walletLight', 'titulo': 'Saldo disponível'},
                'bindings': {'subtitulo': 'saldoFormatado'},
              },
            ],
          },
        },
      ],
      'bottom': [
        {'type': 'botao', 'props': {'label': 'Continuar', 'larguraTotal': true}},
        {'type': 'indicadorDeHome'},
      ],
      'notes': [
        {
          'kind': 'decisao',
          'text': 'A barra de topo não tem título: o contexto está no corpo ("Transferir para <nome>"), e '
              'repetir no topo põe o mesmo texto duas vezes na mesma dobra. É o que o app faz.',
        },
        {
          'kind': 'borda',
          'text': 'Valor acima do saldo: o campo mostra o erro e o CTA desliga. O erro é prop do campo, '
              'não bloco novo — estado de validação mora no componente que valida.',
        },
        {
          'kind': 'a11y',
          'text': 'O teclado numérico abre com a tela (autofocus no app). O CTA fica na base fixa, então '
              'ele não é coberto pelo teclado — é a razão de o contrato mandar CTA pro `bottom`.',
        },
      ],
    };

/// As telas do repo, por slug — em JSON, que é a forma que o plugue de conteúdo pede.
///
/// Uma só, e o número é honesto: declarar 124 de uma vez seria inventar desenho, e este repo mede antes de
/// declarar. A segunda tela vem quando houver a segunda medição.
///
/// O caminho é `autoria → ScreenSpec → encodeSpec`, e não JSON escrito à mão: a autoria valida (ela já me
/// pegou um ícone inventado, `arrowsLeftRightLight`, que é a terceira vez esta semana que eu invento nome de
/// ícone) e o `encodeSpec` produz a forma canônica. JSON escrito à mão pularia a validação — que é a única
/// peça que sabe se uma prop existe.
Map<String, String> telasDoBoldEmJson() => {
      for (final e in telasDoBold().entries) e.key: encodeSpec(e.value),
    };

/// As telas montadas, pra quem precisa da spec e não do texto (os gates deste repo).
Map<String, ScreenSpec> telasDoBold() => {
      kSlugDaHome: montaDaAutoria(_homeDaPf()),
      kSlugDoValorDoPix: montaDaAutoria(_valorDoPix()),
      kSlugDasAutorizacoes: montaDaAutoria(_autorizacoesDaPj()),
    };

/// As telas agrupadas pelo eixo MACRO, que é como o board as mostra.
///
/// O macro sai do prefixo do slug (`pf1-…`, `pj1-…`) e não de um campo novo: o contrato de autoria já manda
/// o slug começar com o prefixo do fluxo, então declarar o macro de novo seria a mesma informação em dois
/// lugares — e duas fontes divergem no primeiro conserto.
List<HandoffGroup> gruposDeTelasDoBold() {
  final porMacro = <String, List<HandoffScreen>>{};
  telasDoBold().forEach((slug, spec) {
    final macro = slug.startsWith('pj') ? 'PJ' : 'PF';
    (porMacro[macro] ??= []).add(handoffFromSpec(spec));
  });
  return [
    for (final e in porMacro.entries)
      HandoffGroup(
        title: e.key == 'PJ' ? 'Conta PJ' : 'Conta PF',
        subtitle: e.key == 'PJ'
            ? 'Alçada, operadores e aprovação em duas mãos.'
            : 'O dia a dia da conta pessoa física.',
        macro: e.key,
        screens: e.value,
      ),
  ];
}
