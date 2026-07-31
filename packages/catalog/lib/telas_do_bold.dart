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
    };
