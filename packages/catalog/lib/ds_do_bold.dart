/// O PLUGUE DO DS — o vocabulário do Conta BOLD para o motor do catálogo.
///
/// O motor não conhece componente nenhum: ele conhece `BlockDef`. Quem sabe quais
/// componentes existem, quais props aceitam e como se compõem é o DS — então é o DS que
/// entrega isto, e **declarar é publicar**: bloco novo aqui aparece no catálogo sem
/// ninguém tocar no catálogo.
///
/// ## Escopo, e ele CRESCEU por medição — a contagem viva é `Ds.blocos.length`
///
/// **Hoje são 56 blocos** (medido em 2026-08-06; a contagem que vale é a do registro, e os gates
/// derivam dela em vez de repeti-la). A primeira versão declarava **12**, e a frase que a justificava
/// segue de pé: um vocabulário pequeno e CERTO vale mais que 100 entradas escritas às cegas — cada
/// `BlockDef` carrega props, defaults, render e codegen, e errar o codegen produz código que compila e
/// não usa o design system, que é o furo mais perigoso do plugue porque nada falha.
///
/// Os 12 do começo cobriam a gramática de uma tela de verdade do Bold: barra, título, texto, ação,
/// campo, valor, selo, aviso, ritmo, divisor, ícone e barra de baixo. O resto entrou como estava
/// escrito que entraria: por medição, tela a tela.
library;

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/widgets.dart';

import 'leitor_do_bold.dart';
import 'telas_do_bold.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// 1 · OS BLOCOS
// ═══════════════════════════════════════════════════════════════════════════════

/// Nomes de preset de texto que o editor oferece. Só os que uma tela usa de verdade —
/// oferecer 28 estilos num seletor é oferecer nenhum.
const _presetsDeTexto = ['displaySm', 'headlineSm', 'titleMd', 'bodyMd', 'bodySm', 'label'];

TextStyle _estiloDe(String preset) => _daOpcao(preset, const {
      'displaySm': DilettaType.displaySm,
      'headlineSm': DilettaType.headlineSm,
      'titleMd': DilettaType.titleMd,
      'bodyMd': DilettaType.bodyMd,
      'bodySm': DilettaType.bodySm,
      'label': DilettaType.label,
    }, DilettaType.bodyMd);

/// O conteúdo deste componente é POSICIONAL (`ds.DilettaText('oi')`), e isso saiu da tabela e voltou:
/// declarar o nome vazio emitia `ds.DilettaText(: 'oi')`, que não compila. A v0.33.1 do motor trouxe
/// `Arg.textoPosicional()`, e com ela o bloco volta pra tabela — e o motor ainda garante o que eu não
/// tinha pedido: posicional sai ANTES dos nomeados, porque é o que o Dart exige e a ordem do mapa não
/// garante. `docs/pedidos/2026-07-30-a-tabela-nao-declara-argumento-posicional.md`.
BlockDef _texto() => BlockDef(
      type: 'texto',
      ctor: 'ds.DilettaText',
      args: const {
        'conteudo': Arg.textoPosicional(),
        'preset': Arg.enumeracao('style', 'ds.DilettaType'),
      },
      label: 'Texto',
      props: const {
        'conteudo': PropDef('multiline', bindable: true, dartType: 'String'),
        'preset': PropDef('enum', options: _presetsDeTexto),
      },
      defaults: () => {'conteudo': 'Texto de apoio.', 'preset': 'bodyMd'},
      build: (p) => DilettaText('${p['conteudo']}', style: _estiloDe('${p['preset']}')),
      codegen: (p) =>
          "ds.DilettaText(${_str(p['conteudo'])}, style: ds.DilettaType.${p['preset']})",
    );

BlockDef _tituloDaPagina() => BlockDef(
      type: 'tituloDaPagina',
      ctor: 'ds.DilettaPageTitle',
      args: const {'titulo': Arg.texto('title'), 'subtitulo': Arg.texto('subtitle')},
      label: 'Título da página · PageTitle',
      props: const {
        'titulo': PropDef('text', bindable: true, dartType: 'String'),
        'subtitulo': PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {'titulo': 'Abrir sua conta', 'subtitulo': 'Leva menos de 5 minutos.'},
      build: (p) => DilettaPageTitle(
        title: '${p['titulo']}',
        subtitle: _vazio(p['subtitulo']) ? null : '${p['subtitulo']}',
      ),
      codegen: (p) => 'ds.DilettaPageTitle(title: ${_str(p['titulo'])}'
          '${_vazio(p['subtitulo']) ? '' : ', subtitle: ${_str(p['subtitulo'])}'})',
    );

/// Os TIPOS de botão que este produto usa, e é um SUBCONJUNTO declarado dos oito do pai.
///
/// A lista cresceu de três pra quatro quando eu fui medir o app por causa da checagem 9 da auditoria, e
/// a contagem é o argumento:
///
/// | variante do app | usos | tipo do pai |
/// |---|---|---|
/// | `secondary` | 49 | `secondary` |
/// | `destructive` | 16 | **não é tipo** — é `DilettaButtonState.error`, e virou a prop `estado` |
/// | `text` | 10 | `tertiary` |
/// | `white` | 5 | `white` — **faltava aqui**, e é o botão de cima de fundo colorido |
/// | `primary` | 5 explícitos (mais o default) | `primary` |
///
/// As quatro que sobram do pai (`secondaryPrimary`, `tertiaryPrimary`, `secondaryWhite`, `tertiaryWhite`)
/// têm ZERO uso no app, e por isso não entram: seletor com opção que ninguém escolhe é seletor que pede
/// leitura antes de cada escolha. Se alguma aparecer numa tela nova, é uma linha aqui.
const _tiposDeBotao = ['primary', 'secondary', 'tertiary', 'white'];

BlockDef _botao() => BlockDef(
      type: 'botao',
      acoes: const {'onPressed': 'aoContinuar'},
      ctor: 'ds.DilettaButton',
      args: const {'label': Arg.texto('label'), 'tipo': Arg.enumeracao('type', 'ds.DilettaButtonType'), 'tamanho': Arg.enumeracao('size', 'ds.DilettaButtonSize'), 'estado': Arg.enumeracao('state', 'ds.DilettaButtonState'), 'larguraTotal': Arg.bool('fullWidth')},
      label: 'Botão · Button',
      props: {
        'label': const PropDef('text', bindable: true, dartType: 'String'),
        'tipo': const PropDef('enum', options: _tiposDeBotao),
        'tamanho': PropDef('enum', options: DilettaButtonSize.values.map((e) => e.name).toList()),
        // O DESTRUTIVO do app são 16 sítios, e ele não é um tipo: é o estado `error`, que troca a paleta
        // sem mudar a estrutura. Como tipo eu nunca poderia oferecê-lo — como estado, ele combina com
        // qualquer um dos quatro, que é o que a tela de revogar acesso faz (secundário + destrutivo).
        'estado': PropDef('enum', options: DilettaButtonState.values.map((e) => e.name).toList()),
        'larguraTotal': const PropDef('bool'),
      },
      defaults: () => {
        'label': 'Continuar',
        'tipo': 'primary',
        'tamanho': 'lg',
        'estado': 'normal',
        'larguraTotal': true,
      },
      build: (p) => _botaoWidget(p, aoTocar: null),
      codegen: (p) => 'ds.DilettaButton(label: ${_str(p['label'])}, onPressed: aoContinuar'
          ', type: ds.DilettaButtonType.${p['tipo']}'
          ', size: ds.DilettaButtonSize.${p['tamanho']}'
          '${p['estado'] == 'normal' ? '' : ', state: ds.DilettaButtonState.${p['estado']}'}'
          '${p['larguraTotal'] == true ? ', fullWidth: true' : ''})',
    );

Widget _botaoWidget(Map<String, dynamic> p, {VoidCallback? aoTocar}) => DilettaButton(
      label: '${p['label']}',
      onPressed: aoTocar ?? () {},
      // Os três mapas escritos à mão saíram: `_porNome` lê o enum do pai, e o subconjunto de tipos é
      // filtrado pelo `options` do prop — não por uma segunda lista que envelhece sozinha.
      type: _daOpcao(p['tipo'], _porNome(DilettaButtonType.values), DilettaButtonType.primary),
      size: _daOpcao(p['tamanho'], _porNome(DilettaButtonSize.values), DilettaButtonSize.lg),
      state: _daOpcao(p['estado'], _porNome(DilettaButtonState.values), DilettaButtonState.normal),
      fullWidth: p['larguraTotal'] == true,
    );

BlockDef _campo() => BlockDef(
      type: 'campo',
      ctor: 'ds.DilettaInput',
      args: const {'rotulo': Arg.texto('label'), 'placeholder': Arg.texto('placeholder'), 'ajuda': Arg.texto('helper'), 'erro': Arg.texto('error'), 'desabilitado': Arg.bool('disabled')},
      label: 'Campo de texto · Input',
      props: const {
        'rotulo': PropDef('text'),
        'placeholder': PropDef('text'),
        'ajuda': PropDef('text'),
        'erro': PropDef('text'),
        'desabilitado': PropDef('bool'),
      },
      defaults: () => {
        'rotulo': 'CPF',
        'placeholder': '000.000.000-00',
        'ajuda': '',
        'erro': '',
        'desabilitado': false,
      },
      build: (p) => DilettaInput(
        label: '${p['rotulo']}',
        placeholder: '${p['placeholder']}',
        helper: _vazio(p['ajuda']) ? null : '${p['ajuda']}',
        error: _vazio(p['erro']) ? null : '${p['erro']}',
        disabled: p['desabilitado'] == true,
      ),
      codegen: (p) => 'ds.DilettaInput(label: ${_str(p['rotulo'])}'
          ', placeholder: ${_str(p['placeholder'])}'
          '${_vazio(p['ajuda']) ? '' : ', helper: ${_str(p['ajuda'])}'}'
          '${_vazio(p['erro']) ? '' : ', error: ${_str(p['erro'])}'}'
          '${p['desabilitado'] == true ? ', disabled: true' : ''})',
    );

BlockDef _valor() => BlockDef(
      type: 'valor',
      ctor: 'ds.DilettaAmountDisplay',
      args: const {'valor': Arg.texto('value'), 'rotulo': Arg.texto('label'), 'carimbo': Arg.texto('timestamp'), 'heroi': Arg.bool('hero')},
      label: 'Valor (saldo) · AmountDisplay',
      props: const {
        'valor': PropDef('text', bindable: true, dartType: 'String'),
        'rotulo': PropDef('text', bindable: true, dartType: 'String'),
        'carimbo': PropDef('text', bindable: true, dartType: 'String'),
        'heroi': PropDef('bool'),
      },
      defaults: () => {
        'valor': 'R\$ 1.240,00',
        'rotulo': 'Saldo disponível',
        'carimbo': '',
        'heroi': true,
      },
      build: (p) => DilettaAmountDisplay(
        value: '${p['valor']}',
        label: _vazio(p['rotulo']) ? null : '${p['rotulo']}',
        timestamp: _vazio(p['carimbo']) ? null : '${p['carimbo']}',
        hero: p['heroi'] == true,
      ),
      codegen: (p) => 'ds.DilettaAmountDisplay(value: ${_str(p['valor'])}'
          '${_vazio(p['rotulo']) ? '' : ', label: ${_str(p['rotulo'])}'}'
          '${_vazio(p['carimbo']) ? '' : ', timestamp: ${_str(p['carimbo'])}'}'
          '${p['heroi'] == true ? ', hero: true' : ''})',
    );

/// DERIVADO do enum do pai, e antes era uma lista de seis nomes escrita à mão.
///
/// A checagem 9 da auditoria (`vocabulario_cravado`, v0.21.3 do DS) achou: era o único lugar deste
/// registro que copiava um enum do pai em vez de lê-lo — quinze outros blocos já usavam `_porNome`. Batia
/// hoje, e é justamente o que faz a classe ser difícil de ver: tom novo no pai não apareceria no seletor,
/// e nada falharia.
List<String> get _tons => DilettaStatusTone.values.map((e) => e.name).toList();

DilettaStatusTone _tomDe(String t) => _daOpcao(t, _porNome(DilettaStatusTone.values),
    DilettaStatusTone.neutral);

BlockDef _selo() => BlockDef(
      type: 'selo',
      ctor: 'ds.DilettaStatusTag',
      args: const {'label': Arg.texto('label'), 'tom': Arg.enumeracao('tone', 'ds.DilettaStatusTone')},
      label: 'Selo de status · StatusTag',
      // Sem `const` no mapa: `options` agora é derivado do enum do pai, e derivado não é constante.
      props: {
        'label': const PropDef('text', bindable: true, dartType: 'String'),
        'tom': PropDef('enum', options: _tons),
      },
      defaults: () => {'label': 'Aprovado', 'tom': 'success'},
      build: (p) => DilettaStatusTag(label: '${p['label']}', tone: _tomDe('${p['tom']}')),
      codegen: (p) => 'ds.DilettaStatusTag(label: ${_str(p['label'])}'
          ', tone: ds.DilettaStatusTone.${p['tom']})',
    );

BlockDef _aviso() => BlockDef(
      type: 'aviso',
      ctor: 'ds.DilettaNoticeBanner',
      args: const {'titulo': Arg.texto('title'), 'descricao': Arg.texto('description'), 'ilustracao': Arg.enumeracao('illustration', 'ds.DilettaIllustration')},
      label: 'Aviso com ilustração · NoticeBanner',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'descricao': const PropDef('multiline', bindable: true, dartType: 'String'),
        // As opções SÃO os tokens de ilustração do pai. Lista derivada, não escrita à
        // mão: lista à mão apodrece e o designer descobre que "a ilustração não existe"
        // quando ela existe.
        'ilustracao': PropDef('enum', options: _nomesDeIlustracao),
      },
      defaults: () => {
        'titulo': 'Ative sua chave Pix',
        'descricao': 'Receba transferências com o seu CPF.',
        'ilustracao': _nomesDeIlustracao.first,
      },
      build: (p) => DilettaNoticeBanner(
        title: '${p['titulo']}',
        description: '${p['descricao']}',
        illustration: _ilustracaoDe('${p['ilustracao']}'),
      ),
      codegen: (p) => 'ds.DilettaNoticeBanner(title: ${_str(p['titulo'])}'
          ', description: ${_str(p['descricao'])}'
          ', illustration: ds.DilettaIllustration.${p['ilustracao']})',
    );

/// O espaço recebe o token POSICIONAL (`ds.DilettaGap.h(ds.DilettaSpacing.s4)`) — mesmo caso do
/// `texto`, mesma volta pra tabela na v0.33.1.
BlockDef _ritmo() => BlockDef(
      type: 'ritmo',
      ctor: 'ds.DilettaGap.h',
      args: const {'tamanho': Arg.enumeracaoPosicional('ds.DilettaSpacing')},
      label: 'Espaço · Gap',
      props: const {'tamanho': PropDef('spacingToken', options: ['s2', 's3', 's4', 's6', 's8'])},
      defaults: () => {'tamanho': 's4'},
      build: (p) => DilettaGap.h(_espaco('${p['tamanho']}')),
      codegen: (p) => 'ds.DilettaGap.h(ds.DilettaSpacing.${p['tamanho']})',
    );

/// AS TRÊS FORMAS do divisor, e antes eu expunha UMA.
///
/// O tracejado ganhou palavra pública na `ds v0.39.0` — era classe privada dentro
/// de um card, e o pai escreveu a razão: *"componente que existe e não tem palavra
/// pública não é vocabulário"*. A recíproca é minha: **palavra pública que o board
/// não expõe também não é vocabulário** pra quem monta tela aqui. É a mesma
/// cobrança que ele me fez na barra de baixo, onde eu mostrava 1 de 7.
///
/// O `vertical` entra junto porque ele já existia e eu também não mostrava.
BlockDef _divisor() => BlockDef(
      type: 'divisor',
      label: 'Divisor · Divider',
      props: const {'forma': PropDef('enum', options: _formasDoDivisor)},
      defaults: () => {'forma': 'linha'},
      build: (p) => switch ('${p['forma']}') {
        'tracejado' => const DilettaDivider.dashed(),
        'vertical' => const SizedBox(height: 24, child: DilettaDivider.vertical()),
        // Sem `_ =>`: a forma é fechada, e forma nova tem que aparecer aqui.
        'linha' => const DilettaDivider(),
        _ => throw ArgumentError('forma de divisor desconhecida: ${p['forma']}'),
      },
      codegen: (p) => switch ('${p['forma']}') {
        'tracejado' => 'ds.DilettaDivider.dashed()',
        // O vertical precisa de altura de quem o hospeda: sozinho ele não tem
        // eixo. E o `SizedBox` é do Flutter, não do DS — o gate me pegou emitindo
        // `ds.SizedBox`, que não existe em pacote nenhum.
        'vertical' => 'const SizedBox(height: 24, child: ds.DilettaDivider.vertical())',
        'linha' => 'ds.DilettaDivider()',
        _ => throw ArgumentError('forma de divisor desconhecida: ${p['forma']}'),
      },
    );

/// As três formas que o pai expõe. Lista fechada de propósito: o gate
/// `o_emitido_compila` compila cada opção, então forma que ele remover reprova.
const List<String> _formasDoDivisor = ['linha', 'tracejado', 'vertical'];

/// O cabeçalho de seção, e o `verTodos` que ele não tinha.
///
/// O acessório à direita apareceu medindo as telas de loja: a home usa cabeçalho com *"Ver todos"*
/// em **duas** seções (`Enviar para`, `Menu`) e a Área Pix numa terceira. O bloco só expunha o
/// rótulo, então as três seções desenhavam sem a saída — e um cabeçalho que promete uma coleção sem
/// dizer onde ela continua é meia informação.
///
/// É prop e não bloco novo: `trailing` já existe no cabeçalho do pai, e o `DilettaSeeAllLink` é a
/// peça dele. O que faltava era declarar.
BlockDef _cabecalhoDeSecao() => BlockDef(
      type: 'cabecalhoDeSecao',
      ctor: 'ds.DilettaSectionHeader',
      args: const {'rotulo': Arg.texto('label')},
      label: 'Cabeçalho de seção · SectionHeader',
      props: const {
        'rotulo': PropDef('text', bindable: true, dartType: 'String'),
        'verTodos': PropDef('bool'),
      },
      defaults: () => {'rotulo': 'DETALHES', 'verTodos': false},
      build: (p) => DilettaSectionHeader(
        label: '${p['rotulo']}',
        trailing: p['verTodos'] == true
            ? DilettaSeeAllLink(onPressed: () {})
            : null,
      ),
      codegen: (p) => 'ds.DilettaSectionHeader(label: ${_str(p['rotulo'])}'
          '${p['verTodos'] == true ? ', trailing: ds.DilettaSeeAllLink(onPressed: aoVerTodos)' : ''})',
    );

/// A LINHA de menu — o `preset` mais comum deste app, medido: `spotIcon + titleSubtitle + chevron`
/// aparece 109 vezes nas telas, e 39 delas já usam a fábrica direto.
///
/// Bloco de tabela, não de `if`: os três argumentos são literais, então o motor emite e lê com a
/// mesma declaração. O `icone` sai como `ds.DilettaIcons.x` porque a constante do pai É o nome do
/// arquivo — a mesma forma do bloco `icone`.
BlockDef _linha() => BlockDef(
      type: 'linha',
      acoes: const {'onTap': 'aoTocarNaLinha'},
      ctor: 'ds.DilettaAppListRow.menuItem',
      args: const {
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'titulo': Arg.texto('title'),
        'subtitulo': Arg.texto('subtitle'),
      },
      label: 'Linha de menu · AppListRow',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'subtitulo': const PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {
        'icone': 'userLight',
        'titulo': 'Dados pessoais',
        'subtitulo': 'Nome, CPF e contato',
      },
      build: (p) => DilettaAppListRow.menuItem(
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        title: '${p['titulo']}',
        subtitle: _vazio(p['subtitulo']) ? null : '${p['subtitulo']}',
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaAppListRow.menuItem('
          'icon: ds.DilettaIcons.${p['icone']}'
          ', title: ${_str(p['titulo'])}'
          '${_vazio(p['subtitulo']) ? '' : ', subtitle: ${_str(p['subtitulo'])}'}'
          ', onTap: aoTocarNaLinha)',
    );

/// A LINHA DE VALOR — a do extrato e a do comprovante: ícone, título, origem, hora e o valor com
/// sinal. Separada da linha de menu porque o acessório da direita é outro (valor, não seta), e o pai
/// já expõe as duas como fábricas distintas.
/// A LINHA DE VALOR do extrato — e ela emitia uma fábrica que o app NÃO usa.
///
/// Achado comparando o desenho com o print do aparelho: o app escreve `06:12 • Pix` e este bloco
/// desenhava `Pix • 06:12`. A causa não era ordem de prop, era **composição**: o bloco emitia
/// `DilettaAppListRow.transactionItem`, e o `grep` de `transactionItem` neste produto dá **zero**.
///
/// O extrato compõe a linha genérica do pai com três acessórios:
///
/// - **esquerda** `spotIcon` na variante `outline`, e não o ícone cheio da fábrica;
/// - **meio** `titleSubtitleSubtitle`, com a HORA no subtítulo e o método no acessório — que é o que
///   inverte a leitura. A razão é do produto e está escrita lá: *"título = quem enviou/recebeu; linha
///   de baixo = hora • método"*, e sem contraparte a linha mostra só a hora;
/// - **direita** `DilettaRightAccessory.amount` com os membros `cashIn`/`cashOut` do `DilettaAmount`,
///   que é o vocabulário de valor do pai — o chip verde da entrada e o menos neutro da saída.
///
/// **Uma fábrica com zero uso no produto é uma fábrica que o catálogo estava ensinando errado.** O
/// bloco perdeu o `ctor`/`args` (a tabela do motor lê `Ctor(args)`, e isto é composição de três
/// acessórios) e ganhou entrada no leitor, como a lista e a grade.
BlockDef _linhaDeValor() => BlockDef(
      type: 'linhaDeValor',
      acoes: const {'onTap': 'aoTocarNaLinha'},
      label: 'Linha de valor · AppListRow',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'origem': const PropDef('text', bindable: true, dartType: 'String'),
        'hora': const PropDef('text', bindable: true, dartType: 'String'),
        'valor': const PropDef('text', bindable: true, dartType: 'String'),
        'saida': const PropDef('bool'),
      },
      defaults: () => {
        'icone': 'pixLight',
        'titulo': 'Ana Maria Silva',
        'origem': 'Pix',
        'hora': '14:32',
        'valor': r'R$ 120,00',
        'saida': true,
      },
      build: (p) => DilettaAppListRow(
        left: DilettaLeftAccessory.spotIcon(
          type: DilettaSpotType.outline,
          icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        ),
        middle: DilettaMiddleAccessory.titleSubtitleSubtitle(
          title: '${p['titulo']}',
          subtitle: '${p['hora']}',
          accessorySubtitle: _vazio(p['origem']) ? null : '${p['origem']}',
        ),
        right: DilettaRightAccessory.amount(
          p['saida'] == true
              ? DilettaAmount.cashOut(value: '${p['valor']}')
              : DilettaAmount.cashIn(value: '${p['valor']}'),
        ),
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaAppListRow('
          'left: ds.DilettaLeftAccessory.spotIcon('
          'type: ds.DilettaSpotType.outline'
          ', icon: ds.DilettaIcons.${p['icone']})'
          ', middle: ds.DilettaMiddleAccessory.titleSubtitleSubtitle('
          'title: ${_str(p['titulo'])}, subtitle: ${_str(p['hora'])}'
          '${_vazio(p['origem']) ? '' : ', accessorySubtitle: ${_str(p['origem'])}'})'
          ', right: ds.DilettaRightAccessory.amount('
          '${p['saida'] == true ? 'ds.DilettaAmount.cashOut' : 'ds.DilettaAmount.cashIn'}'
          '(value: ${_str(p['valor'])}))'
          ', onTap: aoTocarNaLinha)',
    );

/// A LINHA DE ESCOLHA — a de Aparência: ícone, título, e o CHECK no lugar da seta.
///
/// Ela não é o `linha`, e a diferença é a única que importa numa lista de escolha: o `menuItem` do pai
/// termina em `chevron`, que promete *"toca e vai pra outra tela"*. Aqui o toque **decide ali** e a
/// direita diz qual é a atual. Seta numa lista de escolha é a mesma classe de defeito do botão cinza
/// desabilitado: ela oferece um caminho que não existe.
///
/// Composição, e não fábrica — como o `linhaDeValor`. O pai não tem `DilettaAppListRow.choiceItem`, e
/// os três acessórios existem: `spotIcon` em `outline` com estado `primary` à esquerda, `title` no
/// meio, e o `iconAccessory` do check à direita. Aquele acessório nasceu no pai **exatamente** pra
/// substituir o `custom(Icon(...))` que esta tela do app tinha — o tom é papel (`primary`), não uma cor.
///
/// A linha NÃO escolhida não tem acessório nenhum. Marcar as duas pontas (check verde na atual,
/// círculo vazio nas outras) é o que o app não faz, e o print concorda: numa lista de três, o silêncio
/// das outras duas já é a informação.
BlockDef _linhaDeEscolha() => BlockDef(
      type: 'linhaDeEscolha',
      acoes: const {'onTap': 'aoTocarNaLinha'},
      label: 'Linha de escolha · AppListRow',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'escolhido': const PropDef('bool'),
      },
      defaults: () => {
        'icone': 'sunLight',
        'titulo': 'Claro',
        'escolhido': true,
      },
      build: (p) => DilettaAppListRow(
        left: DilettaLeftAccessory.spotIcon(
          type: DilettaSpotType.outline,
          icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
          state: DilettaSpotState.primary,
        ),
        middle: DilettaMiddleAccessory.title(title: '${p['titulo']}'),
        right: p['escolhido'] == true
            ? const DilettaRightAccessory.iconAccessory(
                icon: DilettaIcons.circleCheckSolid,
                tone: DilettaStatusTone.primary,
                size: 20)
            : null,
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaAppListRow('
          'left: ds.DilettaLeftAccessory.spotIcon('
          'type: ds.DilettaSpotType.outline'
          ', icon: ds.DilettaIcons.${p['icone']}'
          ', state: ds.DilettaSpotState.primary)'
          ', middle: ds.DilettaMiddleAccessory.title(title: ${_str(p['titulo'])})'
          '${p['escolhido'] == true ? ', right: const ds.DilettaRightAccessory.iconAccessory('
              'icon: ds.DilettaIcons.circleCheckSolid'
              ', tone: ds.DilettaStatusTone.primary, size: 20)' : ''}'
          ', onTap: aoTocarNaLinha)',
    );

const _idiomasDeLista = ['carded', 'plain', 'menu'];

/// A LISTA — o bloco mais usado deste app (172 linhas em 87 grupos) e o primeiro deste filho com
/// SLOT: as linhas são blocos filhos de verdade, não texto separado por vírgula.
///
/// A escolha do slot em vez de um campo de texto é medida contra o `abas`: lá são três rótulos e um
/// controle de lista seria motor novo pra um caso; aqui cada item tem cinco props, é vinculável a
/// dado, e a lista É o que se edita numa tela. Slot também é o que o motor já oferece
/// (`slotsBuild`/`slotsCodegen`), então não é peça nova — é gancho que estava sem uso neste filho.
///
/// A coleção é dona ÚNICA do separador (regra do pai), então o `idioma` é o que muda: `carded` tem
/// stroke externo, `plain` não, `menu` põe divisor sob cada linha.
BlockDef _lista() => BlockDef(
      type: 'lista',
      label: 'Lista · AppList',
      props: const {
        'titulo': PropDef('text'),
        'idioma': PropDef('enum', options: _idiomasDeLista),
      },
      defaults: () => {'titulo': '', 'idioma': 'carded'},
      slots: const {
        'itens': SlotDef(
            list: true, accepts: ['linha', 'linhaDeValor', 'linhaDeEscolha']),
      },
      build: (p) => _listaWidget(p, const []),
      slotsBuild: (p, filhos) => _listaWidget(p, filhos['itens'] ?? const []),
      slotsCodegen: (p, codigos) {
        final itens = codigos['itens'] ?? const [];
        return 'ds.DilettaAppList.${p['idioma']}('
            '${_vazio(p['titulo']) ? '' : 'title: ${_str(p['titulo'])}, '}'
            'children: [${itens.join(', ')}])';
      },
      // Nunca chamado (o motor prefere `slotsCodegen` quando ele existe), e declarado porque o
      // contrato exige: uma lista sem item nenhum é o card vazio, que é o que o preview mostra.
      codegen: (p) => 'ds.DilettaAppList.${p['idioma']}(children: const [])',
    );

Widget _listaWidget(Map<String, dynamic> p, List<Widget> itens) {
  final titulo = _vazio(p['titulo']) ? null : '${p['titulo']}';
  return switch (p['idioma']) {
    'plain' => DilettaAppList.plain(title: titulo, children: itens),
    'menu' => DilettaAppList.menu(title: titulo, children: itens),
    // Sem `_ =>`: o idioma é fechado e enum novo tem que aparecer aqui. O default fica explícito.
    'carded' => DilettaAppList.carded(title: titulo, children: itens),
    _ => throw ArgumentError('idioma de lista desconhecido: ${p['idioma']}'),
  };
}

BlockDef _icone() => BlockDef(
      type: 'icone',
      ctor: 'ds.DilettaIcon',
      args: const {'nome': Arg.enumeracao('name', 'ds.DilettaIcons'), 'tamanho': Arg.numero('size')},
      label: 'Ícone · Icon',
      props: {
        'nome': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'tamanho': const PropDef('enum', options: ['16', '20', '24', '32']),
      },
      defaults: () => {'nome': 'bellLight', 'tamanho': '24'},
      build: (p) =>
          _desenhaIcone('${p['nome']}', tamanho: double.parse('${p['tamanho']}')),
      codegen: (p) => "ds.DilettaIcon(name: ds.DilettaIcons.${p['nome']}"
          ', size: ${p['tamanho']})',
    );

BlockDef _barraDeStatusBloco() => BlockDef(
      type: 'barraDeStatus',
      label: 'Barra de status',
      props: const {},
      defaults: () => {},
      build: (p) => const DilettaStatusBar(),
      // Chrome de APARELHO não vai pro código gerado: emitir fazia o dev colar uma
      // barra de status falsa dentro da tela, dois relógios na mesma janela. O motor
      // sabe disso por `tiposDeChromeDeDispositivo`; o codegen aqui nunca é chamado.
      codegen: (p) => '',
    );

BlockDef _barraDeBaixo() => BlockDef(
      type: 'barraDeBaixo',
      label: 'Barra de baixo · BottomApp',
      // AS CINCO VARIANTES, e antes era UMA.
      //
      // Cobrança do pai (motor v0.77.0), medida por ele comparando as duas árvores: o
      // `DilettaBottomApp` tem SETE factories, eu expunha só a `.button`, e o outro filho expõe as sete.
      // O dono do produto escolheu as cinco sem chat — *"pro bold só não a com o chat pq não precisa"* —,
      // e a razão é a mesma que rege este registro: variante que produto nenhum usa é desenho
      // especulativo.
      //
      // Bloco de UNIÃO, não cinco blocos: a peça do pai é uma só, e cinco tipos na paleta obrigariam
      // quem procura "barra de baixo" a escolher antes de ver. O `visibleProps` é o que faz a união não
      // virar ruído — cada variante mostra só as props que ela usa.
      props: const {
        'variante': PropDef('enum', options: _variantesDaBarra),
        'label': PropDef('text', bindable: true, dartType: 'String'),
        'labelSecundario': PropDef('text'),
        // As abas da variante `nav`, no mesmo idioma do bloco `abas`: rótulos separados por vírgula, e o
        // ícone declarado depois de `:` quando existe. Sem ícone o item cai no ponto neutro do pai —
        // inventar glifo por posição seria desenho meu passando por linguagem.
        'abas': PropDef('text'),
        'abaAtiva': PropDef('number'),
      },
      defaults: () => {
        'variante': 'button',
        'label': 'Continuar',
        'labelSecundario': '',
        // A medição do app: a home tem três abas (a terceira é condicional por feature flag).
        'abas': 'Início:houseLight, Câmera:cameraLight, Lia:sparklesLightFull',
        'abaAtiva': '0',
      },
      // O inspetor mostra só o que a variante usa. Sem isto, escolher `keyboard` deixava dois campos de
      // rótulo na tela sem nenhum efeito — prop que não faz nada é prop que ensina errado.
      visibleProps: (p) => switch ('${p['variante']}') {
        'nav' => const ['variante', 'abas', 'abaAtiva'],
        'button' || 'buttonAndKeyboard' => const ['variante', 'label', 'labelSecundario'],
        _ => const ['variante'],
      },
      build: (p) => _barraDeBaixoWidget(p, aoTocar: null),
      // A barra é um CONTAINER: o texto mora no botão de navegação dentro dela. Por isso o codegen
      // aninha em vez de passar `label:` — é a forma que o pai expõe, e aplainar aqui geraria código que
      // não compila no app.
      codegen: (p) => switch ('${p['variante']}') {
        'defaultVariant' => 'ds.DilettaBottomApp.defaultVariant()',
        'nav' => _navNoCodigo(p),
        'keyboard' => 'ds.DilettaBottomApp.keyboard(keyboard: ds.DilettaKeyboard('
            'onKey: aoTeclar, onBackspace: aoApagar))',
        'buttonAndKeyboard' => 'ds.DilettaBottomApp.buttonAndKeyboard('
            'button: ${_botaoDeNavegacaoNoCodigo(p)}'
            ', keyboard: ds.DilettaKeyboard(onKey: aoTeclar, onBackspace: aoApagar))',
        _ => 'ds.DilettaBottomApp.button(button: ${_botaoDeNavegacaoNoCodigo(p)})',
      },
    );

/// As cinco factories que este produto usa. As duas de chat ficam fora por decisão do dono: o Bold não
/// tem chat, e variante sem uso é desenho especulativo.
const List<String> _variantesDaBarra = [
  'defaultVariant',
  'nav',
  'button',
  'keyboard',
  'buttonAndKeyboard',
];

/// Um item da barra de navegação declarado no texto: `Rótulo` ou `Rótulo:iconeDoPai`.
typedef _ItemDeNav = ({String rotulo, String? icone});

List<_ItemDeNav> _itensDeNav(Object? cru) => [
      for (final parte in '${cru ?? ''}'.split(','))
        if (parte.trim().isNotEmpty)
          if (parte.contains(':'))
            (
              rotulo: parte.split(':').first.trim(),
              // Ícone que não existe no conjunto do pai é ícone que desenha caixa vazia. Cai pra nulo, e
              // o item fica com o ponto neutro em vez de um buraco.
              icone: DilettaIcons.all.containsKey(parte.split(':').last.trim())
                  ? parte.split(':').last.trim()
                  : null,
            )
          else
            (rotulo: parte.trim(), icone: null),
    ];

int _indiceDeAba(Map<String, dynamic> p) {
  final total = _itensDeNav(p['abas']).length;
  final pedido = int.tryParse('${p['abaAtiva']}') ?? 0;
  // Índice fora da lista é `RangeError` no aparelho. Cravar no último é a leitura mais próxima do que
  // quem digitou quis dizer.
  return total == 0 ? 0 : pedido.clamp(0, total - 1);
}

/// A barra de NAVEGAÇÃO no código gerado.
///
/// Sai em função separada porque montar identificador de ícone dentro de interpolação aninhada é como se
/// escreve string quebrada sem perceber — o analisador pegou na primeira tentativa.
String _navNoCodigo(Map<String, dynamic> p) {
  final itens = _itensDeNav(p['abas']).map((i) {
    final icone = i.icone == null ? "''" : 'ds.DilettaIcons.${i.icone}';
    return 'ds.DilettaNavItem(icon: $icone, label: ${_str(i.rotulo)})';
  }).join(', ');
  return 'ds.DilettaBottomApp.nav(nav: ds.DilettaNav.items('
      'items: const [$itens]'
      ', activeIndex: ${_indiceDeAba(p)}'
      ', onIndexChanged: aoTrocarAba))';
}

String _botaoDeNavegacaoNoCodigo(Map<String, dynamic> p) =>
    'ds.DilettaNavigationButton(primary: ds.DilettaNavigationAction('
    'label: ${_str(p['label'])}, onPressed: onContinuar)'
    '${_vazio(p['labelSecundario']) ? '' : ', secondary: ds.DilettaNavigationAction('
        'label: ${_str(p['labelSecundario'])}, onPressed: onVoltar)'}'
    ')';

Widget _barraDeBaixoWidget(Map<String, dynamic> p, {VoidCallback? aoTocar}) {
  DilettaNavigationButton botao() => DilettaNavigationButton(
        primary: DilettaNavigationAction(
          label: '${p['label']}',
          onPressed: aoTocar ?? () {},
        ),
        secondary: _vazio(p['labelSecundario'])
            ? null
            : DilettaNavigationAction(label: '${p['labelSecundario']}', onPressed: () {}),
      );
  DilettaKeyboard teclado() => DilettaKeyboard(onKey: (_) {}, onBackspace: () {});

  return switch ('${p['variante']}') {
    'defaultVariant' => const DilettaBottomApp.defaultVariant(),
    'nav' => DilettaBottomApp.nav(
        nav: DilettaNav.items(
          items: [
            for (final i in _itensDeNav(p['abas']))
              DilettaNavItem(
                icon: i.icone == null ? '' : DilettaIcons.all[i.icone]!,
                label: i.rotulo,
              ),
          ],
          activeIndex: _indiceDeAba(p),
          onIndexChanged: (_) {},
        ),
      ),
    'keyboard' => DilettaBottomApp.keyboard(keyboard: teclado()),
    'buttonAndKeyboard' =>
      DilettaBottomApp.buttonAndKeyboard(button: botao(), keyboard: teclado()),
    _ => DilettaBottomApp.button(button: botao()),
  };
}

/// O selo quântico — o primeiro bloco que vem de um componente NASCIDO no filho, e não da
/// linguagem do pai. Declarar é publicar: ele aparece na paleta do compositor sem ninguém tocar
/// no catálogo.
/// O visor do leitor de código. Bloco de TELA CHEIA: ele é overlay, então no canvas ele ocupa a
/// área inteira em vez de entrar na coluna como um item.
BlockDef _cabecalhoDaHome() => BlockDef(
      type: 'cabecalhoDaHome',
      ctor: 'ds.CoreflowCabecalhoDaHome',
      args: const {
        'nome': Arg.texto('nome'),
        'conta': Arg.texto('conta'),
      },
      label: 'Cabeçalho da home',
      props: const {
        'nome': PropDef('text', bindable: true, dartType: 'String'),
        'conta': PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {'nome': 'Ana', 'conta': 'Conta PF'},
      build: (p) => CoreflowCabecalhoDaHome(
        nome: '${p['nome']}',
        conta: _vazio(p['conta']) ? null : '${p['conta']}',
        aoAbrirPerfil: () {},
        aoTrocarConta: () {},
        icones: const [
          CoreflowIconeDoCabecalho(
              icone: DilettaIcons.bellLight, rotulo: 'Notificações', marcador: true),
        ],
      ),
      codegen: (p) => '',
    );

/// O resumo do comprovante. Ele é CONTEÚDO e não tela: o organismo do app era o `Scaffold` inteiro,
/// e bloco que já é a tela não compõe com nada no compositor.
BlockDef _resumoDaTransacao() => BlockDef(
      type: 'resumoDaTransacao',
      ctor: 'ds.CoreflowResumoDaTransacao',
      args: const {
        'titulo': Arg.texto('titulo'),
        'valor': Arg.texto('valor'),
        'quando': Arg.texto('quando'),
        'estado': Arg.enumeracao('estado', 'ds.CoreflowEstadoDaTransacao'),
      },
      label: 'Resumo da transação',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'valor': const PropDef('text', bindable: true, dartType: 'String'),
        'quando': const PropDef('text', bindable: true, dartType: 'String'),
        'estado': PropDef('enum',
            options: CoreflowEstadoDaTransacao.values.map((e) => e.name).toList()),
      },
      defaults: () => {
        'titulo': 'Pix enviado',
        'valor': 'R\$ 120,00',
        'quando': '30 de julho · 14:32',
        'estado': 'concluida',
      },
      build: (p) => CoreflowResumoDaTransacao(
        titulo: '${p['titulo']}',
        valor: '${p['valor']}',
        quando: '${p['quando']}',
        estado: CoreflowEstadoDaTransacao.values.firstWhere((e) => e.name == p['estado']),
      ),
      codegen: (p) => 'ds.CoreflowResumoDaTransacao(titulo: ${_str(p['titulo'])}'
          ', valor: ${_str(p['valor'])}'
          ', quando: ${_str(p['quando'])}'
          ', estado: ds.CoreflowEstadoDaTransacao.${p['estado']})',
    );

/// A escada de alçadas. Os degraus vêm como TEXTO de uma linha por faixa (`5.000 | 0` …), pelo mesmo
/// motivo das abas: é o controle que o editor tem pra lista curta, e a alternativa (slot com bloco de
/// degrau) seria um bloco que nunca é usado sozinho. A lista de verdade tem 2 ou 3 itens.
BlockDef _escadaDeAlcadas() => BlockDef(
      type: 'escadaDeAlcadas',
      label: 'Escada de alçadas',
      props: const {
        'degraus': PropDef('multiline'),
        'densa': PropDef('bool'),
      },
      defaults: () => {
        'degraus': 'R\$ 5.000,00 | 0\n| 2 master',
        'densa': true,
      },
      build: (p) => CoreflowEscadaDeAlcadas(
        degraus: _degraus(p['degraus']),
        densa: p['densa'] == true,
      ),
      codegen: (p) => 'ds.CoreflowEscadaDeAlcadas(degraus: degrausDaAlcada'
          '${p['densa'] == true ? ', densa: true' : ''})',
    );

/// Uma linha por degrau: `<teto> | <aprovações> [master]`. Teto vazio = faixa terminal.
List<CoreflowDegrauDeAlcada> _degraus(Object? v) {
  final saida = <CoreflowDegrauDeAlcada>[];
  for (final linha in '$v'.split('\n')) {
    if (linha.trim().isEmpty) continue;
    final partes = linha.split('|');
    final teto = partes.first.trim();
    final direita = partes.length > 1 ? partes[1].trim() : '0';
    saida.add(CoreflowDegrauDeAlcada(
      ate: teto.isEmpty ? null : teto,
      aprovacoes: int.tryParse(direita.split(' ').first) ?? 0,
      exigeMaster: direita.contains('master'),
    ));
  }
  return saida;
}

BlockDef _progressoDeAprovacao() => BlockDef(
      type: 'progressoDeAprovacao',
      ctor: 'ds.CoreflowProgressoDeAprovacao',
      args: const {
        'colhidas': Arg.numero('colhidas'),
        'exigidas': Arg.numero('exigidas'),
        'exigeMaster': Arg.bool('exigeMaster'),
        'compacto': Arg.bool('compacto'),
      },
      label: 'Progresso de aprovação',
      props: const {
        'colhidas': PropDef('number', bindable: true, dartType: 'int'),
        'exigidas': PropDef('number', bindable: true, dartType: 'int'),
        'exigeMaster': PropDef('bool'),
        'compacto': PropDef('bool'),
      },
      defaults: () => {'colhidas': '1', 'exigidas': '2', 'exigeMaster': false, 'compacto': false},
      build: (p) => CoreflowProgressoDeAprovacao(
        colhidas: int.tryParse('${p['colhidas']}') ?? 0,
        exigidas: int.tryParse('${p['exigidas']}') ?? 0,
        exigeMaster: p['exigeMaster'] == true,
        compacto: p['compacto'] == true,
      ),
      codegen: (p) => 'ds.CoreflowProgressoDeAprovacao(colhidas: ${p['colhidas']}'
          ', exigidas: ${p['exigidas']})',
    );

/// O prazo. `restante` é `Duration`, e `Arg` não tem kind de duração — então o bloco declara as HORAS
/// e o codegen monta o `Duration`. Fora da tabela por isso, com entrada no leitor.
BlockDef _prazoDaPendencia() => BlockDef(
      type: 'prazoDaPendencia',
      label: 'Prazo da pendência',
      props: const {
        'horas': PropDef('number'),
        'idade': PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {'horas': '3', 'idade': ''},
      build: (p) => CoreflowPrazoDaPendencia(
        restante: _horas(p['horas']),
        idade: _vazio(p['idade']) ? null : '${p['idade']}',
      ),
      codegen: (p) => _horas(p['horas']) == null
          ? 'ds.CoreflowPrazoDaPendencia(idade: ${_str(p['idade'])})'
          : 'ds.CoreflowPrazoDaPendencia(restante: '
              'Duration(hours: ${int.tryParse('${p['horas']}') ?? 0}))',
    );

/// Horas como `Duration`; vazio ou não-número ⇒ nulo, que é "o servidor não informou prazo".
Duration? _horas(Object? v) {
  final n = int.tryParse('$v'.trim());
  return n == null ? null : Duration(hours: n);
}

// ═══════════════════════════════════════════════════════════════════════════════
// 1b · OS RENAMES — componentes do PAI que o app do Bold usa
//
// Estes não nascem aqui: são a linguagem, e o bloco só declara COMO o compositor os oferece.
// A ordem em que entraram é a de USO MEDIDO no app, não a de facilidade: o toast tem 174
// ocorrências, a casca de topo 109, o comprovante 69. Os que têm ZERO uso ficaram de fora —
// `tooltip`, `stepper`, `bannerPromo`, `barraDeProgresso`, `folhaDeSenha`, `otp`, `linhaDeDetalhe`
// —, pela mesma razão que sete dos dez gradientes não foram portados: declarar código morto
// parece progresso e não é.
// ═══════════════════════════════════════════════════════════════════════════════

BlockDef _toast() => BlockDef(
      type: 'toast',
      ctor: 'ds.DilettaToast',
      args: const {
        'titulo': Arg.texto('title'),
        'subtitulo': Arg.texto('subtitle'),
        'estado': Arg.enumeracao('state', 'ds.DilettaToastState'),
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
      },
      label: 'Toast',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'subtitulo': const PropDef('text', bindable: true, dartType: 'String'),
        'estado': PropDef('enum',
            options: DilettaToastState.values.map((e) => e.name).toList()),
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
      },
      defaults: () => {
        'titulo': 'Pix enviado',
        'subtitulo': 'O comprovante está no extrato.',
        'estado': 'success',
        'icone': 'circleCheckLight',
      },
      build: (p) => DilettaToast(
        title: '${p['titulo']}',
        subtitle: _vazio(p['subtitulo']) ? null : '${p['subtitulo']}',
        state: _daOpcao(p['estado'], _porNome(DilettaToastState.values), DilettaToastState.normal),
        icon: DilettaIcons.all['${p['icone']}'],
      ),
      codegen: (p) => 'ds.DilettaToast(title: ${_str(p['titulo'])}'
          '${_vazio(p['subtitulo']) ? '' : ', subtitle: ${_str(p['subtitulo'])}'}'
          ', state: ds.DilettaToastState.${p['estado']}'
          ', icon: ds.DilettaIcons.${p['icone']})',
    );

BlockDef _esqueleto() => BlockDef(
      type: 'esqueleto',
      // SEM `ctor`, e por isso fica fora da tabela: o bloco emite um PAR.
      //
      // O esqueleto do pai é a FORMA e não anima sozinho — o `///` dele diz *"embrulhe num
      // DilettaShimmer pra ganhar o brilho"*. Eu declarava só a forma, então o catálogo mostrava uma
      // caixa cinza parada enquanto o app mostrava a varredura. Board que mostra a peça sem o movimento
      // dela ensina o movimento errado: quem copia o código leva a caixa parada.
      //
      // Achado pelo dono do produto, e do jeito mais direto: *"o skeleton tem um shimmer rosinha, agora
      // só é o frame cinza"*. O rosa é declaração deste produto (`brilhoDoEsqueleto`, ds v0.34.0).
      label: 'Esqueleto · Skeleton com Shimmer',
      props: const {
        'largura': PropDef('number'),
        'altura': PropDef('number'),
      },
      defaults: () => {'largura': '180', 'altura': '16'},
      build: (p) => DilettaShimmer(
        child: DilettaSkeleton.box(
          width: double.tryParse('${p['largura']}'),
          height: double.tryParse('${p['altura']}'),
        ),
      ),
      codegen: (p) => 'ds.DilettaShimmer(child: ds.DilettaSkeleton.box('
          'width: ${p['largura']}, height: ${p['altura']}))',
    );

BlockDef _botaoDeIcone() => BlockDef(
      type: 'botaoDeIcone',
      acoes: const {'onPressed': 'aoTocar'},
      ctor: 'ds.DilettaIconButton',
      args: const {
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'rotulo': Arg.texto('semanticLabel'),
        'tipo': Arg.enumeracao('type', 'ds.DilettaIconButtonType'),
        'tamanho': Arg.enumeracao('size', 'ds.DilettaIconButtonSize'),
        'marcador': Arg.bool('badge'),
      },
      label: 'Botão de ícone · IconButton',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'rotulo': const PropDef('text'),
        'tipo': PropDef('enum',
            options: DilettaIconButtonType.values.map((e) => e.name).toList()),
        'tamanho': PropDef('enum',
            options: DilettaIconButtonSize.values.map((e) => e.name).toList()),
        'marcador': const PropDef('bool'),
      },
      defaults: () => {
        'icone': 'bellLight',
        'rotulo': 'Notificações',
        'tipo': 'secondary',
        'tamanho': 'md',
        'marcador': false,
      },
      build: (p) => DilettaIconButton(
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        semanticLabel: '${p['rotulo']}',
        type: _daOpcao(p['tipo'], _porNome(DilettaIconButtonType.values),
            DilettaIconButtonType.secondary),
        size: _daOpcao(p['tamanho'], _porNome(DilettaIconButtonSize.values),
            DilettaIconButtonSize.md),
        badge: p['marcador'] == true,
        onPressed: () {},
      ),
      codegen: (p) => 'ds.DilettaIconButton(icon: ds.DilettaIcons.${p['icone']}'
          ', semanticLabel: ${_str(p['rotulo'])}'
          ', type: ds.DilettaIconButtonType.${p['tipo']}'
          ', size: ds.DilettaIconButtonSize.${p['tamanho']}'
          '${p['marcador'] == true ? ', badge: true' : ''}'
          ', onPressed: aoTocar)',
    );

BlockDef _avatar() => BlockDef(
      type: 'avatar',
      ctor: 'ds.DilettaAvatar',
      args: const {
        'iniciais': Arg.texto('initials'),
        'variante': Arg.enumeracao('variant', 'ds.DilettaAvatarVariant'),
        'tamanho': Arg.numero('size'),
      },
      label: 'Avatar',
      props: {
        'iniciais': const PropDef('text', bindable: true, dartType: 'String'),
        'variante': PropDef('enum',
            options: DilettaAvatarVariant.values.map((e) => e.name).toList()),
        'tamanho': const PropDef('enum', options: ['32', '40', '56']),
      },
      defaults: () => {'iniciais': 'AM', 'variante': 'outlined', 'tamanho': '40'},
      build: (p) => DilettaAvatar(
        initials: '${p['iniciais']}',
        variant: _daOpcao(p['variante'], _porNome(DilettaAvatarVariant.values),
            DilettaAvatarVariant.outlined),
        size: double.tryParse('${p['tamanho']}') ?? 40,
      ),
      codegen: (p) => 'ds.DilettaAvatar(initials: ${_str(p['iniciais'])}'
          ', variant: ds.DilettaAvatarVariant.${p['variante']}'
          ', size: ${p['tamanho']})',
    );

BlockDef _interruptor() => BlockDef(
      type: 'interruptor',
      acoes: const {'onChanged': 'aoTrocar'},
      ctor: 'ds.DilettaToggleSwitch',
      args: const {
        'ligado': Arg.bool('value'),
        'tamanho': Arg.enumeracao('size', 'ds.DilettaToggleSize'),
        'desabilitado': Arg.bool('disabled'),
        'rotulo': Arg.texto('semanticLabel'),
      },
      label: 'Interruptor · ToggleSwitch',
      props: {
        'ligado': const PropDef('bool'),
        'tamanho': PropDef('enum',
            options: DilettaToggleSize.values.map((e) => e.name).toList()),
        'desabilitado': const PropDef('bool'),
        'rotulo': const PropDef('text'),
      },
      defaults: () => {
        'ligado': true,
        'tamanho': 'md',
        'desabilitado': false,
        'rotulo': 'Notificações por push',
      },
      build: (p) => DilettaToggleSwitch(
        value: p['ligado'] == true,
        onChanged: (_) {},
        size: _daOpcao(p['tamanho'], _porNome(DilettaToggleSize.values), DilettaToggleSize.md),
        disabled: p['desabilitado'] == true,
        semanticLabel: '${p['rotulo']}',
      ),
      codegen: (p) => 'ds.DilettaToggleSwitch(value: ${p['ligado'] == true}'
          ', onChanged: aoTrocar'
          ', size: ds.DilettaToggleSize.${p['tamanho']}'
          '${p['desabilitado'] == true ? ', disabled: true' : ''}'
          ', semanticLabel: ${_str(p['rotulo'])})',
    );

BlockDef _campoDeBusca() => BlockDef(
      type: 'campoDeBusca',
      acoes: const {'onChanged': 'aoBuscar'},
      ctor: 'ds.DilettaSearchInput',
      args: const {'placeholder': Arg.texto('placeholder')},
      label: 'Campo de busca · SearchInput',
      props: {
        'placeholder': const PropDef('text'),
        // A AÇÃO À DIREITA, medida em dois sítios: o QR da Área Pix e o filtro do extrato. Nos dois
        // a busca ocupa a linha e o botão vive AO LADO dela — não é bloco vizinho, é a mesma linha,
        // e declarar como dois blocos empilharia um sobre o outro. Vazio = sem ação.
        'acaoDireita': PropDef('enum', options: ['', ...DilettaIcons.all.keys]),
      },
      defaults: () => {'placeholder': 'Buscar contato ou chave', 'acaoDireita': ''},
      build: (p) => _campoDeBuscaWidget(p),
      codegen: (p) => _vazio(p['acaoDireita'])
          ? 'ds.DilettaSearchInput(placeholder: ${_str(p['placeholder'])}'
              ', onChanged: aoBuscar)'
          : 'ds.DilettaFrame.row(gap: ds.DilettaSpacing.s3, children: ['
              'Expanded(child: ds.DilettaSearchInput(placeholder: ${_str(p['placeholder'])}'
              ', onChanged: aoBuscar))'
              ', ds.DilettaIconButton(icon: ds.DilettaIcons.${p['acaoDireita']}'
              ", semanticLabel: 'Ação da busca'"
              ', type: ds.DilettaIconButtonType.secondary, onPressed: aoFiltrar)])'
    );

/// A busca sozinha, ou a busca com o botão ao lado. Uma função porque `build` e `codegen`
/// precisam concordar, e duas cópias do mesmo `if` divergem no primeiro conserto.
Widget _campoDeBuscaWidget(Map<String, Object?> p) {
  final campo = DilettaSearchInput(placeholder: '${p['placeholder']}');
  if (_vazio(p['acaoDireita'])) return campo;
  return Row(children: [
    Expanded(child: campo),
    const SizedBox(width: DilettaSpacing.s3),
    DilettaIconButton(
      icon: DilettaIcons.all['${p['acaoDireita']}'] ?? '${p['acaoDireita']}',
      semanticLabel: 'Ação da busca',
      type: DilettaIconButtonType.secondary,
      onPressed: () {},
    ),
  ]);
}

BlockDef _girando() => BlockDef(
      type: 'girando',
      ctor: 'ds.DilettaLoadingSpinner',
      args: const {'tamanho': Arg.enumeracao('size', 'ds.DilettaSpinnerSize')},
      label: 'Carregando · LoadingSpinner',
      props: {
        'tamanho': PropDef('enum',
            options: DilettaSpinnerSize.values.map((e) => e.name).toList()),
      },
      defaults: () => {'tamanho': 'md'},
      build: (p) => DilettaLoadingSpinner(
        size: _daOpcao(p['tamanho'], _porNome(DilettaSpinnerSize.values), DilettaSpinnerSize.md),
      ),
      codegen: (p) => 'ds.DilettaLoadingSpinner(size: ds.DilettaSpinnerSize.${p['tamanho']})',
    );

BlockDef _ilustracao() => BlockDef(
      type: 'ilustracao',
      ctor: 'ds.DilettaIllustrationAccessory',
      args: const {
        'arte': Arg.enumeracao('illustration', 'ds.DilettaIllustration'),
        'tamanho': Arg.enumeracao('size', 'ds.DilettaIllustrationSize'),
      },
      label: 'Ilustração · Illustration',
      props: {
        'arte': PropDef('enum', options: _nomesDeIlustracao),
        'tamanho': PropDef('enum',
            options: DilettaIllustrationSize.values.map((e) => e.name).toList()),
      },
      defaults: () => {'arte': _nomesDeIlustracao.first, 'tamanho': 'md'},
      build: (p) => DilettaIllustrationAccessory(
        illustration: _ilustracaoDe('${p['arte']}'),
        size: _daOpcao(p['tamanho'], _porNome(DilettaIllustrationSize.values),
            DilettaIllustrationSize.md),
      ),
      codegen: (p) => 'ds.DilettaIllustrationAccessory('
          'illustration: ds.DilettaIllustration.${p['arte']}'
          ', size: ds.DilettaIllustrationSize.${p['tamanho']})',
    );

BlockDef _estadoVazio() => BlockDef(
      type: 'estadoVazio',
      acoes: const {'onAction': 'aoTocar'},
      ctor: 'ds.DilettaEmptyState',
      args: const {
        'titulo': Arg.texto('title'),
        'legenda': Arg.texto('caption'),
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'acao': Arg.texto('actionLabel'),
      },
      label: 'Estado vazio · EmptyState',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'legenda': const PropDef('multiline', bindable: true, dartType: 'String'),
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'acao': const PropDef('text'),
      },
      defaults: () => {
        'titulo': 'Nenhuma transação por aqui',
        'legenda': 'Quando você movimentar a conta, o extrato aparece aqui.',
        'icone': 'arrowRotateLeftLight',
        'acao': 'Atualizar',
      },
      build: (p) => DilettaEmptyState(
        title: '${p['titulo']}',
        caption: '${p['legenda']}',
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        actionLabel: _vazio(p['acao']) ? null : '${p['acao']}',
        onAction: _vazio(p['acao']) ? null : () {},
      ),
      codegen: (p) => 'ds.DilettaEmptyState(title: ${_str(p['titulo'])}'
          ', caption: ${_str(p['legenda'])}'
          ', icon: ds.DilettaIcons.${p['icone']}'
          '${_vazio(p['acao']) ? '' : ', actionLabel: ${_str(p['acao'])}, onAction: aoTocar'})',
    );

BlockDef _logo() => BlockDef(
      type: 'logo',
      ctor: 'ds.DilettaLogo',
      args: const {
        'variante': Arg.enumeracao('variant', 'ds.DilettaLogoVariant'),
        'tamanho': Arg.numero('size'),
      },
      label: 'Logo',
      props: {
        'variante': PropDef('enum',
            options: DilettaLogoVariant.values.map((e) => e.name).toList()),
        'tamanho': const PropDef('enum', options: ['24', '40', '64']),
      },
      defaults: () => {'variante': 'full', 'tamanho': '40'},
      build: (p) => DilettaLogo(
        variant: _daOpcao(p['variante'], _porNome(DilettaLogoVariant.values),
            DilettaLogoVariant.mark),
        size: double.tryParse('${p['tamanho']}') ?? 40,
      ),
      codegen: (p) => 'ds.DilettaLogo(variant: ds.DilettaLogoVariant.${p['variante']}'
          ', size: ${p['tamanho']})',
    );

BlockDef _chipDeInfo() => BlockDef(
      type: 'chipDeInfo',
      ctor: 'ds.DilettaInfoChip',
      args: const {
        'label': Arg.texto('label'),
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'tom': Arg.enumeracao('tone', 'ds.DilettaInfoChipTone'),
      },
      label: 'Chip de informação',
      props: {
        'label': const PropDef('text', bindable: true, dartType: 'String'),
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'tom': PropDef('enum',
            options: DilettaInfoChipTone.values.map((e) => e.name).toList()),
      },
      defaults: () => {'label': 'Conta PJ', 'icone': 'piggyBankLight', 'tom': 'light'},
      build: (p) => DilettaInfoChip(
        label: '${p['label']}',
        icon: DilettaIcons.all['${p['icone']}'],
        tone: _daOpcao(p['tom'], _porNome(DilettaInfoChipTone.values), DilettaInfoChipTone.light),
      ),
      codegen: (p) => 'ds.DilettaInfoChip(label: ${_str(p['label'])}'
          ', icon: ds.DilettaIcons.${p['icone']}'
          ', tone: ds.DilettaInfoChipTone.${p['tom']})',
    );

BlockDef _chipDeEntrada() => BlockDef(
      type: 'chipDeEntrada',
      acoes: const {'onTap': 'aoFiltrar'},
      ctor: 'ds.DilettaInputChip',
      args: const {
        'label': Arg.texto('label'),
        'preenchido': Arg.bool('filled'),
        'icone': Arg.enumeracao('leadIcon', 'ds.DilettaIcons'),
      },
      label: 'Chip de filtro',
      props: {
        'label': const PropDef('text', bindable: true, dartType: 'String'),
        'preenchido': const PropDef('bool'),
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
      },
      // `barsFilterLight` e não `filterLight`: o segundo não existe no conjunto do pai, e eu o inventei
      // ao escrever o bloco. Nenhum gate viu — o `build` recebia `null` (sem assert, porque o argumento
      // é opcional) e o codegen emitia `ds.DilettaIcons.filterLight`, que não compila. Achado pelo gate
      // de compilação.
      defaults: () => {'label': 'Entradas', 'preenchido': true, 'icone': 'barsFilterLight'},
      build: (p) => DilettaInputChip(
        label: '${p['label']}',
        filled: p['preenchido'] == true,
        leadIcon: DilettaIcons.all['${p['icone']}'],
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaInputChip(label: ${_str(p['label'])}'
          '${p['preenchido'] == true ? ', filled: true' : ''}'
          ', leadIcon: ds.DilettaIcons.${p['icone']}'
          ', onTap: aoFiltrar)',
    );

BlockDef _cartaoDeAcesso() => BlockDef(
      type: 'cartaoDeAcesso',
      acoes: const {'onTap': 'aoTocar'},
      ctor: 'ds.DilettaQuickAccessCard',
      args: const {
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'label': Arg.texto('label'),
        'estado': Arg.enumeracao('state', 'ds.DilettaQuickAccessState'),
      },
      label: 'Cartão de acesso rápido · QuickAccessCard',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'label': const PropDef('text', bindable: true, dartType: 'String'),
        'estado': PropDef('enum',
            options: DilettaQuickAccessState.values.map((e) => e.name).toList()),
      },
      defaults: () => {'icone': 'pixLight', 'label': 'Área Pix', 'estado': 'active'},
      build: (p) => DilettaQuickAccessCard(
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        label: '${p['label']}',
        state: _daOpcao(p['estado'], _porNome(DilettaQuickAccessState.values),
            DilettaQuickAccessState.active),
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaQuickAccessCard(icon: ds.DilettaIcons.${p['icone']}'
          ', label: ${_str(p['label'])}'
          ', state: ds.DilettaQuickAccessState.${p['estado']}'
          ', onTap: aoTocar)',
    );

BlockDef _caixaDeSelecao() => BlockDef(
      type: 'caixaDeSelecao',
      acoes: const {'onChanged': 'aoMarcar'},
      ctor: 'ds.DilettaCheckbox',
      args: const {
        'marcado': Arg.bool('checked'),
        'label': Arg.texto('label'),
        'descricao': Arg.texto('description'),
        'variante': Arg.enumeracao('variant', 'ds.DilettaCheckboxVariant'),
      },
      label: 'Caixa de seleção · Checkbox',
      props: {
        'marcado': const PropDef('bool'),
        'label': const PropDef('text'),
        'descricao': const PropDef('text'),
        'variante': PropDef('enum',
            options: DilettaCheckboxVariant.values.map((e) => e.name).toList()),
      },
      defaults: () => {
        'marcado': true,
        'label': 'Li e aceito os termos',
        'descricao': '',
        'variante': 'primary',
      },
      build: (p) => DilettaCheckbox(
        checked: p['marcado'] == true,
        label: _vazio(p['label']) ? null : '${p['label']}',
        description: _vazio(p['descricao']) ? null : '${p['descricao']}',
        variant: _daOpcao(p['variante'], _porNome(DilettaCheckboxVariant.values),
            DilettaCheckboxVariant.primary),
        onChanged: (_) {},
      ),
      codegen: (p) => 'ds.DilettaCheckbox(checked: ${p['marcado'] == true}'
          '${_vazio(p['label']) ? '' : ', label: ${_str(p['label'])}'}'
          '${_vazio(p['descricao']) ? '' : ', description: ${_str(p['descricao'])}'}'
          ', variant: ds.DilettaCheckboxVariant.${p['variante']}'
          ', onChanged: aoMarcar)',
    );

// ── o lote de FORMA IRREGULAR: quem recebe lista, widget ou runtime ──────────────
//
// Estes não caberiam na tabela antes da v0.35.0 (`acoes`), e é ela que os traz: o argumento vem de um
// IDENTIFICADOR do código gerado, não de um literal. Sem isso, cada um seria `codegen` à mão mais uma
// entrada no leitor — e o leitor voltaria de 2 pra 10 entradas.

BlockDef _comprovante() => BlockDef(
      type: 'comprovante',
      ctor: 'ds.DilettaReceipt',
      args: const {
        'titulo': Arg.texto('title'),
        'carimbo': Arg.texto('timestamp'),
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'idDaTransacao': Arg.texto('transactionId'),
      },
      // As linhas e as seções vêm de dado: um comprovante é o que o backend devolveu.
      acoes: const {'rows': 'linhasDoComprovante', 'sections': 'secoesDoComprovante'},
      label: 'Comprovante · Receipt',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'carimbo': const PropDef('text', bindable: true, dartType: 'String'),
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'idDaTransacao': const PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {
        'titulo': 'Comprovante de pagamento',
        'carimbo': '30/07/2026 às 14:32',
        'icone': 'circleCheckLight',
        'idDaTransacao': 'E1234567890',
      },
      build: (p) => DilettaReceipt(
        title: '${p['titulo']}',
        timestamp: '${p['carimbo']}',
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        transactionId: _vazio(p['idDaTransacao']) ? null : '${p['idDaTransacao']}',
        rows: const [
          DilettaReceiptRow(label: 'Valor', value: 'R\$ 120,00'),
          DilettaReceiptRow(label: 'Para', value: 'Ana Maria Silva'),
        ],
        sections: const [
          DilettaReceiptSection(
            icon: 'clipboardListCheckLight',
            title: 'Origem',
            rows: [DilettaReceiptRow(label: 'Instituição', value: 'Conta BOLD')],
          ),
        ],
      ),
      codegen: (p) => 'ds.DilettaReceipt(title: ${_str(p['titulo'])}'
          ', timestamp: ${_str(p['carimbo'])}'
          ', rows: linhasDoComprovante, sections: secoesDoComprovante)',
    );

/// A FOLHA, e ela deixou de receber o conteúdo como DADO DE RUNTIME.
///
/// O `codegen` emitia `child: conteudoDaFolha` — um campo que a tela gerada tem que fornecer. Funcionava
/// pra integrar e **não dava pra montar**: no compositor ninguém conseguia pôr blocos dentro de uma folha,
/// e era por isso que a caixa âmbar da Gramática tinha 54 de 56 (a resposta que eu dei ao pai).
///
/// Slot agora, com o mesmo raciocínio que decidiu o slot da `lista`: **o conteúdo de uma folha É o que se
/// edita.** Uma folha de confirmação é título + linhas + botão, e cada um deles já é bloco deste registro.
///
/// `list: true` e `accepts` aberto: uma folha aceita qualquer bloco de conteúdo, e restringir aqui seria
/// gramática inventada — eu não tenho medição de "que blocos podem estar numa folha". O que eu tenho é a
/// medição do app: 34 folhas genéricas, com conteúdo variado.
BlockDef _folha() => BlockDef(
      type: 'folha',
      // `ctor` e `args` FICAM, e a razão veio de dois testes vermelhos: eles não servem só pra emitir.
      //
      // O mapa de contratos é DERIVADO do `ctor` (`_contratosDosBlocos`), e o leitor de código usa a tabela
      // pra fazer a VOLTA. Tirando os dois, a folha perdeu o contrato e passou a abrir como código à mão —
      // duas regressões que o `slotsCodegen` não compensa, porque ele só cobre a ida.
      //
      // O que SAIU foi o `acoes: {'child': 'conteudoDaFolha'}`: o filho agora vem do slot, e declarar as
      // duas coisas faria o emitido ter conteúdo por dois caminhos.
      ctor: 'ds.DilettaSheetOverlay',
      args: const {'aberta': Arg.bool('open')},
      acoes: const {'onScrimTap': 'aoFechar'},
      label: 'Folha (overlay)',
      props: const {'aberta': PropDef('bool')},
      defaults: () => {'aberta': true},
      slots: const {'conteudo': SlotDef(list: true)},
      build: (p) => _folhaWidget(p, const []),
      slotsBuild: (p, filhos) => _folhaWidget(p, filhos['conteudo'] ?? const []),
      slotsCodegen: (p, codigos) {
        final filhos = codigos['conteudo'] ?? const [];
        return 'ds.DilettaSheetOverlay(open: ${p['aberta'] == true}, onScrimTap: aoFechar'
            ', child: ds.DilettaFrame.column(children: [${filhos.join(', ')}]))';
      },
      // Nunca chamado (o motor prefere `slotsCodegen`), e obrigatório pelo contrato: folha sem filho é a
      // casca vazia, que é o que o preview de um slot recém-arrastado mostra.
      codegen: (p) => 'ds.DilettaSheetOverlay(open: ${p['aberta'] == true}'
          ', onScrimTap: aoFechar, child: const ds.DilettaFrame.column(children: []))',
    );

/// A folha com os filhos que o slot deu — ou o exemplo, quando ela está vazia.
///
/// O exemplo NÃO é decoração: folha vazia é um retângulo cinza no catálogo, e quem arrasta o bloco pela
/// primeira vez não descobre o que ele é. Com filho no slot o exemplo sai.
Widget _folhaWidget(Map<String, dynamic> p, List<Widget> filhos) => DilettaSheetOverlay(
      open: p['aberta'] == true,
      onScrimTap: () {},
      child: DilettaFrame.column(
        padding: const EdgeInsets.all(DilettaSpacing.s5),
        gap: DilettaSpacing.s3,
        children: filhos.isNotEmpty
            ? filhos
            : [
                const DilettaPageTitle(
                    title: 'Confirmar envio', subtitle: 'Revise antes de enviar.'),
                DilettaButton(label: 'Confirmar', onPressed: () {}, fullWidth: true),
              ],
      ),
    );

BlockDef _dialogo() => BlockDef(
      type: 'dialogo',
      ctor: 'ds.DilettaDialog',
      args: const {'titulo': Arg.texto('title'), 'mensagem': Arg.texto('message')},
      label: 'Diálogo',
      props: const {
        'titulo': PropDef('text', bindable: true, dartType: 'String'),
        'mensagem': PropDef('multiline', bindable: true, dartType: 'String'),
      },
      defaults: () => {
        'titulo': 'Encerrar a conta?',
        'mensagem': 'Isso não pode ser desfeito, e o saldo precisa estar zerado.',
      },
      // As AÇÕES são blocos, e o slot aceita só `botao`: aqui a gramática existe de verdade — um diálogo
      // tem botões no rodapé, e nada mais. É o oposto do slot da folha, que é aberto porque o conteúdo
      // dela varia.
      slots: const {'acoes': SlotDef(list: true, accepts: ['botao'])},
      build: (p) => _dialogoWidget(p, const []),
      slotsBuild: (p, filhos) => _dialogoWidget(p, filhos['acoes'] ?? const []),
      slotsCodegen: (p, codigos) {
        final acoes = codigos['acoes'] ?? const [];
        return 'ds.DilettaDialog(title: ${_str(p['titulo'])}'
            '${_vazio(p['mensagem']) ? '' : ', message: ${_str(p['mensagem'])}'}'
            ', actions: [${acoes.join(', ')}])';
      },
      codegen: (p) => 'ds.DilettaDialog(title: ${_str(p['titulo'])}'
          '${_vazio(p['mensagem']) ? '' : ', message: ${_str(p['mensagem'])}'}'
          ', actions: const [])',
    );

/// O diálogo com as ações do slot — ou o par canônico, quando ele está vazio.
Widget _dialogoWidget(Map<String, dynamic> p, List<Widget> acoes) => DilettaDialog(
      title: '${p['titulo']}',
      message: _vazio(p['mensagem']) ? null : '${p['mensagem']}',
      actions: acoes.isNotEmpty
          ? acoes
          : [
              DilettaButton(
                  label: 'Cancelar', onPressed: () {}, type: DilettaButtonType.secondary),
              DilettaButton(label: 'Encerrar', onPressed: () {}),
            ],
    );

BlockDef _listaDeRadio() => BlockDef(
      type: 'listaDeRadio',
      ctor: 'ds.DilettaRadioList',
      args: const {'titulo': Arg.texto('title'), 'escolhido': Arg.texto('value')},
      acoes: const {'options': 'opcoesDoRadio', 'onChanged': 'aoEscolher'},
      label: 'Lista de escolha',
      props: const {
        'titulo': PropDef('text'),
        'opcoes': PropDef('text'),
        'escolhido': PropDef('text'),
      },
      defaults: () => {
        'titulo': 'Tipo de conta',
        'opcoes': 'Corrente, Poupança',
        'escolhido': 'Corrente',
      },
      build: (p) => DilettaRadioList(
        title: _vazio(p['titulo']) ? null : '${p['titulo']}',
        options: [
          for (final o in _listaDeAbas(p['opcoes']))
            DilettaRadioOption(value: o, label: o),
        ],
        value: '${p['escolhido']}',
        onChanged: (_) {},
      ),
      codegen: (p) => 'ds.DilettaRadioList(options: opcoesDoRadio'
          ', value: ${_str(p['escolhido'])}, onChanged: aoEscolher'
          '${_vazio(p['titulo']) ? '' : ', title: ${_str(p['titulo'])}'})',
    );

BlockDef _criterios() => BlockDef(
      type: 'criterios',
      ctor: 'ds.DilettaCriteriaList',
      acoes: const {'items': 'criteriosDaSenha'},
      label: 'Critérios · CriteriaList',
      props: const {'itens': PropDef('multiline')},
      defaults: () => {
        'itens': 'ok | Mínimo 8 caracteres\nok | Uma letra maiúscula\npending | Um número',
      },
      build: (p) => DilettaCriteriaList(items: _criteriosDe(p['itens'])),
      codegen: (p) => 'ds.DilettaCriteriaList(items: criteriosDaSenha)',
    );

/// Uma linha por critério: `<estado> | <texto>`. Estado desconhecido cai em `pending` com assert.
List<DilettaCriteriaItem> _criteriosDe(Object? v) {
  final saida = <DilettaCriteriaItem>[];
  for (final linha in '$v'.split('\n')) {
    if (linha.trim().isEmpty) continue;
    final partes = linha.split('|');
    final estado = partes.first.trim();
    saida.add(DilettaCriteriaItem(
      label: partes.length > 1 ? partes[1].trim() : estado,
      status: _daOpcao(estado, _porNome(DilettaCriteriaStatus.values),
          DilettaCriteriaStatus.pending),
    ));
  }
  return saida;
}

BlockDef _dropdown() => BlockDef(
      type: 'dropdown',
      ctor: 'ds.DilettaDropdown',
      args: const {
        'rotulo': Arg.texto('label'),
        'placeholder': Arg.texto('placeholder'),
        'escolhido': Arg.texto('value'),
        'erro': Arg.texto('error'),
      },
      acoes: const {'items': 'opcoesDoCampo', 'onChanged': 'aoEscolher'},
      label: 'Campo de seleção',
      props: const {
        'rotulo': PropDef('text'),
        'placeholder': PropDef('text'),
        'opcoes': PropDef('text'),
        'escolhido': PropDef('text'),
        'erro': PropDef('text'),
      },
      defaults: () => {
        'rotulo': 'Banco',
        'placeholder': 'Escolha o banco',
        'opcoes': 'Conta BOLD, Itaú, Nubank',
        'escolhido': '',
        'erro': '',
      },
      build: (p) => DilettaDropdown(
        label: _vazio(p['rotulo']) ? null : '${p['rotulo']}',
        placeholder: _vazio(p['placeholder']) ? null : '${p['placeholder']}',
        items: _listaDeAbas(p['opcoes']),
        value: _vazio(p['escolhido']) ? null : '${p['escolhido']}',
        error: _vazio(p['erro']) ? null : '${p['erro']}',
        onChanged: (_) {},
      ),
      codegen: (p) => 'ds.DilettaDropdown(items: opcoesDoCampo, onChanged: aoEscolher'
          '${_vazio(p['rotulo']) ? '' : ', label: ${_str(p['rotulo'])}'})',
    );

BlockDef _expansivel() => BlockDef(
      type: 'expansivel',
      ctor: 'ds.DilettaExpansionTile',
      args: const {'titulo': Arg.texto('title'), 'aberto': Arg.bool('initiallyExpanded')},
      label: 'Expansível · ExpansionTile',
      props: const {
        'titulo': PropDef('text'),
        'conteudo': PropDef('multiline'),
        'aberto': PropDef('bool'),
      },
      defaults: () => {
        'titulo': 'Como funciona a alçada?',
        'conteudo': 'Cada faixa de valor exige um número de assinaturas.',
        'aberto': true,
      },
      slots: const {'conteudo': SlotDef(list: true)},
      build: (p) => _expansivelWidget(p, const []),
      slotsBuild: (p, filhos) => _expansivelWidget(p, filhos['conteudo'] ?? const []),
      slotsCodegen: (p, codigos) {
        final filhos = codigos['conteudo'] ?? const [];
        return 'ds.DilettaExpansionTile(title: ${_str(p['titulo'])}'
            ', children: [${filhos.join(', ')}]'
            '${p['aberto'] == true ? ', initiallyExpanded: true' : ''})';
      },
      codegen: (p) => 'ds.DilettaExpansionTile(title: ${_str(p['titulo'])}'
          ', children: const []'
          '${p['aberto'] == true ? ', initiallyExpanded: true' : ''})',
    );

/// O expansível com os filhos do slot — ou o texto da prop `conteudo`, que é o caso simples.
///
/// A prop `conteudo` FICA, e não é redundância com o slot: a pergunta "como funciona a alçada?" tem uma
/// resposta de um parágrafo, e obrigar a arrastar um bloco de texto pra dentro pra escrever uma frase é
/// atrito sem ganho. Slot vazio ⇒ o parágrafo; slot com filho ⇒ os filhos.
Widget _expansivelWidget(Map<String, dynamic> p, List<Widget> filhos) => DilettaExpansionTile(
      title: '${p['titulo']}',
      initiallyExpanded: p['aberto'] == true,
      children: filhos.isNotEmpty
          ? filhos
          : [DilettaText('${p['conteudo']}', style: DilettaType.bodySm)],
    );

BlockDef _cartaoDeDestaque() => BlockDef(
      type: 'cartaoDeDestaque',
      ctor: 'ds.DilettaFeatureCard',
      args: const {
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'titulo': Arg.texto('title'),
        'descricao': Arg.texto('description'),
        'acao': Arg.texto('actionLabel'),
      },
      // A cor da marca do cartão é do PRODUTO, e vem como identificador do tema no código gerado.
      acoes: const {'brandColor': 'corDaMarca'},
      label: 'Cartão de destaque · FeatureCard',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'descricao': const PropDef('multiline', bindable: true, dartType: 'String'),
        'acao': const PropDef('text'),
      },
      defaults: () => {
        'icone': 'piggyBankLight',
        'titulo': 'Conta PJ',
        'descricao': 'Alçadas, operadores e aprovação em duas mãos.',
        'acao': 'Conhecer',
      },
      build: (p) => DilettaFeatureCard(
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        title: '${p['titulo']}',
        description: '${p['descricao']}',
        brandColor: BoldPalette.bold.primary04,
        actionLabel: _vazio(p['acao']) ? null : '${p['acao']}',
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaFeatureCard(icon: ds.DilettaIcons.${p['icone']}'
          ', title: ${_str(p['titulo'])}, description: ${_str(p['descricao'])}'
          ', brandColor: corDaMarca, onTap: aoTocar)',
    );

// ── os cinco que a medição apontou como FALTANDO com uso real ────────────────────
//
// Pergunta do dono do produto: "o catálogo já tem todos os itens do pai que você usa?" A medição disse
// NÃO — cinco componentes com uso no app não tinham bloco, e a casca de topo é o maior buraco do
// vocabulário inteiro: **109 usos**. Os outros oito que faltam têm ZERO uso, e continuam de fora.

/// A CASCA DE TOPO genérica — o bloco de 109 usos.
///
/// O `cabecalhoDaHome` já usa a variante `.comConteudo` por dentro, mas ele é a home. Toda OUTRA tela
/// deste produto usa a casca com barra de navegação simples: voltar (ou fechar) e título.
BlockDef _cascaDeTopo() => BlockDef(
      type: 'cascaDeTopo',
      label: 'Casca de topo · TopAppBar',
      props: const {
        'titulo': PropDef('text', bindable: true, dartType: 'String'),
        'esquerda': PropDef('enum', options: ['voltar', 'fechar', 'nada']),
        // OS ÍCONES DA DIREITA, separados por vírgula. Medidos no extrato (exportar + olho) e na
        // aba Pix. A barra do pai aceita 1, 2 ou 3 e é ela que espaça — o que faltava era declarar.
        'direita': PropDef('text'),
      },
      defaults: () => {'titulo': 'Enviar Pix', 'esquerda': 'voltar', 'direita': ''},
      build: (p) => DilettaTopAppBar.defaultVariant(
        navBar: DilettaNavigationTopBar(
          title: _vazio(p['titulo']) ? null : '${p['titulo']}',
          right: _vazio(p['direita'])
              ? null
              : DilettaNavigationRightAccessory.icons(
                  icons: [
                    for (final nome in _emLista(p['direita']))
                      DilettaNavRightIcon(
                        icon: DilettaIcons.all[nome] ?? nome,
                        semanticLabel: nome,
                        type: DilettaIconButtonType.tertiary,
                        onPressed: () {},
                      ),
                  ],
                ),
          left: switch (p['esquerda']) {
            'fechar' => DilettaNavigationLeftAccessory.close(onPressed: () {}),
            'nada' => null,
            // Sem `_ =>`: o default é EXPLÍCITO, e opção nova aparece aqui em vez de virar "voltar".
            'voltar' => DilettaNavigationLeftAccessory.back(onPressed: () {}),
            _ => throw ArgumentError('acessório esquerdo desconhecido: ${p['esquerda']}'),
          },
        ),
      ),
      // Aninha dois níveis (casca → barra → acessório), então fica fora da tabela por decisão do motor,
      // com entrada no leitor.
      codegen: (p) => 'ds.DilettaTopAppBar.defaultVariant(navBar: ds.DilettaNavigationTopBar('
          '${_vazio(p['titulo']) ? '' : 'title: ${_str(p['titulo'])}, '}'
          '${_vazio(p['direita']) ? '' : 'right: ds.DilettaNavigationRightAccessory.icons(icons: ['
              '${_emLista(p['direita']).map((n) => 'ds.DilettaNavRightIcon('
                  'icon: ds.DilettaIcons.$n, semanticLabel: ${_str(n)}'
                  ', type: ds.DilettaIconButtonType.tertiary, onPressed: aoTocar)').join(', ')}'
              ']), '}'
          // Os DOIS lados deste bloco decidem igual, e antes não decidiam: o `build` estourava em valor
          // desconhecido e o `codegen` emitia `back` calado. A auditoria achou pelo `_ =>`, e a
          // assimetria é o defeito — quem lê o codegen aprendia "desconhecido vira voltar", que era
          // regra de um lado só.
          'left: ${switch (p['esquerda']) {
            'fechar' => 'ds.DilettaNavigationLeftAccessory.close(onPressed: aoFechar)',
            'nada' => 'null',
            'voltar' => 'ds.DilettaNavigationLeftAccessory.back(onPressed: aoVoltar)',
            _ => throw ArgumentError('acessório esquerdo desconhecido: ${p['esquerda']}'),
          }}))',
    );

/// A BARRA DE NAVEGAÇÃO sozinha — 13 usos, e existe separada porque ela também entra em folha e em
/// cabeçalho, onde a casca de topo não vai.
BlockDef _barraDeNavegacao() => BlockDef(
      type: 'barraDeNavegacao',
      ctor: 'ds.DilettaNavigationTopBar',
      args: const {'titulo': Arg.texto('title')},
      label: 'Barra de navegação',
      props: const {'titulo': PropDef('text', bindable: true, dartType: 'String')},
      defaults: () => {'titulo': 'Minhas chaves'},
      build: (p) => DilettaNavigationTopBar(
        title: '${p['titulo']}',
        left: DilettaNavigationLeftAccessory.back(onPressed: () {}),
      ),
      codegen: (p) => 'ds.DilettaNavigationTopBar(title: ${_str(p['titulo'])})',
    );

BlockDef _bannerDeStatus() => BlockDef(
      type: 'bannerDeStatus',
      ctor: 'ds.DilettaStatusBanner',
      args: const {
        'sobrescrito': Arg.texto('eyebrow'),
        'titulo': Arg.texto('title'),
        'subtitulo': Arg.texto('subtitle'),
        'nota': Arg.texto('footnote'),
      },
      label: 'Banner de status',
      props: const {
        'sobrescrito': PropDef('text'),
        'titulo': PropDef('text', bindable: true, dartType: 'String'),
        'subtitulo': PropDef('text', bindable: true, dartType: 'String'),
        'nota': PropDef('text'),
      },
      defaults: () => {
        'sobrescrito': 'CONTA PJ',
        'titulo': 'Operando como Diletta Solutions',
        'subtitulo': 'CNPJ 12.345.678/0001-90',
        'nota': '',
      },
      build: (p) => DilettaStatusBanner(
        eyebrow: _vazio(p['sobrescrito']) ? null : '${p['sobrescrito']}',
        title: _vazio(p['titulo']) ? null : '${p['titulo']}',
        subtitle: _vazio(p['subtitulo']) ? null : '${p['subtitulo']}',
        footnote: _vazio(p['nota']) ? null : '${p['nota']}',
      ),
      codegen: (p) => 'ds.DilettaStatusBanner(title: ${_str(p['titulo'])}'
          ', subtitle: ${_str(p['subtitulo'])})',
    );

BlockDef _calendario() => BlockDef(
      type: 'calendario',
      ctor: 'ds.DilettaCalendar',
      acoes: const {'onDateSelected': 'aoEscolherData', 'selectedDate': 'dataEscolhida'},
      label: 'Calendário',
      props: const {},
      defaults: () => {},
      build: (p) => DilettaCalendar(onDateSelected: (_) {}),
      codegen: (p) =>
          'ds.DilettaCalendar(onDateSelected: aoEscolherData, selectedDate: dataEscolhida)',
    );

BlockDef _teclado() => BlockDef(
      type: 'teclado',
      ctor: 'ds.DilettaKeyboard',
      acoes: const {'onKey': 'aoTeclar', 'onBackspace': 'aoApagar'},
      label: 'Teclado numérico · Keyboard',
      props: const {},
      defaults: () => {},
      build: (p) => DilettaKeyboard(onKey: (_) {}, onBackspace: () {}),
      codegen: (p) => 'ds.DilettaKeyboard(onKey: aoTeclar, onBackspace: aoApagar)',
    );

BlockDef _visorDeCodigo() => BlockDef(
      type: 'visorDeCodigo',
      // Só `ctor`, sem `args`: os props deste bloco são de PREVIEW — no código gerado, alvo e fase
      // vêm de dado em tempo de execução. Bloco sem prop declarada continua legível pelo
      // construtor, e foi um dos três defeitos que o gate do pai achou no próprio pai.
      ctor: 'ds.CoreflowVisorDeCodigo',
      // Os três argumentos deste bloco vêm de RUNTIME (a câmera), e dois são obrigatórios. Sem isto a
      // tabela emitia `const ds.CoreflowVisorDeCodigo()` — que não compila, e era o que o `codegen` à mão
      // já resolvia antes de a tabela passar a vencer.
      acoes: const {
        'alvos': 'alvosDetectados',
        'fase': 'faseDaVarredura',
        'tamanhoDaImagem': 'tamanhoDoFrame',
      },
      label: 'Visor de código',
      props: {
        'estado': PropDef('enum',
            options: CoreflowAlvoEstado.values.map((e) => e.name).toList()),
        'rotulo': const PropDef('text'),
      },
      defaults: () => {'estado': 'analisando', 'rotulo': 'LENDO CÓDIGO'},
      build: (p) => CoreflowVisorDeCodigo(
        alvos: [
          CoreflowAlvo(
            area: const Rect.fromLTWH(80, 120, 140, 140),
            estado: CoreflowAlvoEstado.values
                .firstWhere((e) => e.name == p['estado']),
            rotulo: '${p['rotulo']}',
            centralizado: true,
          ),
        ],
        // Fase fixa no preview: o visor não anima sozinho (quem anima é o app), e um preview
        // parado num ponto legível mostra o rastro melhor que um parado no zero.
        fase: 0.45,
      ),
      codegen: (p) => 'ds.CoreflowVisorDeCodigo(alvos: alvosDetectados'
          ', fase: faseDaVarredura'
          ', tamanhoDaImagem: tamanhoDoFrame)',
    );

BlockDef _copiar() => BlockDef(
      type: 'copiar',
      ctor: 'ds.CoreflowCopiar',
      args: const {'texto': Arg.texto('texto'), 'rotulo': Arg.texto('rotuloDeAcessibilidade')},
      label: 'Copiar',
      props: const {
        'texto': PropDef('text', bindable: true, dartType: 'String'),
        'rotulo': PropDef('text'),
      },
      defaults: () => {'texto': 'chave-pix-exemplo', 'rotulo': 'Copiar chave'},
      build: (p) => CoreflowCopiar(
        texto: '${p['texto']}',
        rotuloDeAcessibilidade: '${p['rotulo']}',
      ),
      codegen: (p) => 'ds.CoreflowCopiar(texto: ${_str(p['texto'])}'
          ', rotuloDeAcessibilidade: ${_str(p['rotulo'])})',
    );

BlockDef _abas() => BlockDef(
      type: 'abas',
      // `abas` é uma LISTA obrigatória, que a tabela não declara — e `acoes` resolve, porque
      // mecanicamente ele é "argumento → identificador", não só "argumento → handler". O nome do campo
      // é mais estreito que o mecanismo, e isso está anotado no pedido.
      acoes: const {'abas': 'rotulosDasAbas', 'aoTrocar': 'aoTrocarAba'},
      ctor: 'ds.CoreflowAbas',
      args: const {'selecionada': Arg.numero('indiceSelecionado')},
      label: 'Abas',
      props: const {
        'abas': PropDef('text'),
        'selecionada': PropDef('number'),
      },
      defaults: () => {'abas': 'Tudo, Entradas, Saídas', 'selecionada': '0'},
      build: (p) => CoreflowAbas(
        abas: _listaDeAbas(p['abas']),
        indiceSelecionado: int.tryParse('${p['selecionada']}') ?? 0,
        aoTrocar: (_) {},
      ),
      codegen: (p) => 'ds.CoreflowAbas(abas: const ['
          '${_listaDeAbas(p['abas']).map((a) => "'$a'").join(', ')}]'
          ', indiceSelecionado: ${int.tryParse('${p['selecionada']}') ?? 0}'
          ', aoTrocar: aoTrocarAba)',
    );

/// As abas vêm como texto separado por vírgula: é o controle que o editor tem pra lista curta, e
/// inventar um controle de lista pra três rótulos seria motor novo pra um caso.
List<String> _listaDeAbas(Object? v) => '$v'
    .split(',')
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .toList();

/// Os segmentos. Mesmo controle de lista curta das abas (texto separado por vírgula), e pelo mesmo
/// motivo: são dois ou três rótulos.
BlockDef _segmentos() => BlockDef(
      type: 'segmentos',
      label: 'Segmentos',
      props: const {
        'segmentos': PropDef('text'),
        'selecionado': PropDef('number'),
      },
      defaults: () => {'segmentos': 'Claro, Escuro, Sistema', 'selecionado': '0'},
      build: (p) => CoreflowSegmentos(
        segmentos: _listaDeAbas(p['segmentos']),
        indiceSelecionado: int.tryParse('${p['selecionado']}') ?? 0,
        aoTrocar: (_) {},
      ),
      codegen: (p) => 'ds.CoreflowSegmentos(segmentos: const ['
          '${_listaDeAbas(p['segmentos']).map((a) => "'$a'").join(', ')}]'
          ', indiceSelecionado: ${int.tryParse('${p['selecionado']}') ?? 0}'
          ', aoTrocar: aoTrocarSegmento)',
    );

BlockDef _pontosDePagina() => BlockDef(
      type: 'pontosDePagina',
      ctor: 'ds.CoreflowPontosDePagina',
      args: const {
        'total': Arg.numero('total'),
        'ativo': Arg.numero('indiceAtivo'),
      },
      label: 'Pontos de página',
      props: const {
        'total': PropDef('number'),
        'ativo': PropDef('number', bindable: true, dartType: 'int'),
      },
      defaults: () => {'total': '4', 'ativo': '0'},
      build: (p) => CoreflowPontosDePagina(
        total: int.tryParse('${p['total']}') ?? 0,
        indiceAtivo: int.tryParse('${p['ativo']}') ?? 0,
      ),
      codegen: (p) => 'ds.CoreflowPontosDePagina(total: ${p['total']}'
          ', indiceAtivo: ${p['ativo']})',
    );

BlockDef _saldo() => BlockDef(
      type: 'saldo',
      acoes: const {'aoAbrirExtrato': 'abrirExtrato'},
      ctor: 'ds.CoreflowSaldo',
      args: const {'valor': Arg.texto('valor'), 'entradas': Arg.texto('entradas'), 'saidas': Arg.texto('saidas'), 'oculto': Arg.bool('oculto')},
      label: 'Saldo (home)',
      props: const {
        'valor': PropDef('text', bindable: true, dartType: 'String'),
        'entradas': PropDef('text', bindable: true, dartType: 'String'),
        'saidas': PropDef('text', bindable: true, dartType: 'String'),
        'oculto': PropDef('bool'),
        // O ATALHO é prop porque ele SOME numa tela: no extrato o card não tem "Extrato ›", e a
        // razão é do produto — quem já está no extrato não tem pra onde ir. O componente já sabia
        // fazer isso (`aoAbrirExtrato` nulo esconde o atalho, e é requisito escrito no contrato);
        // o que faltava era o bloco declarar. Ele cravava o callback e o board mostrava um link
        // que o aparelho não mostra.
        'atalhoDoExtrato': PropDef('bool'),
      },
      defaults: () => {
        'valor': 'R\$ 2.912,47',
        'entradas': 'R\$ 300,00',
        'saidas': 'R\$ 120,00',
        'oculto': false,
        'atalhoDoExtrato': true,
      },
      build: (p) => CoreflowSaldo(
        valor: '${p['valor']}',
        entradas: _vazio(p['entradas']) ? null : '${p['entradas']}',
        saidas: _vazio(p['saidas']) ? null : '${p['saidas']}',
        oculto: p['oculto'] == true,
        aoAbrirExtrato: p['atalhoDoExtrato'] == false ? null : () {},
      ),
      codegen: (p) => 'ds.CoreflowSaldo(valor: ${_str(p['valor'])}'
          '${_vazio(p['entradas']) ? '' : ', entradas: ${_str(p['entradas'])}'}'
          '${_vazio(p['saidas']) ? '' : ', saidas: ${_str(p['saidas'])}'}'
          '${p['oculto'] == true ? ', oculto: true' : ''}'
          '${p['atalhoDoExtrato'] == false ? '' : ', aoAbrirExtrato: abrirExtrato'})',
    );

BlockDef _seloQuantico() => BlockDef(
      type: 'seloQuantico',
      ctor: 'ds.BoldSeloQuantico',
      args: const {'estado': Arg.enumeracao('estado', 'ds.BoldSeloEstado'), 'tamanho': Arg.numero('tamanho'), 'rotulo': Arg.bool('mostrarRotulo')},
      label: 'Selo quântico',
      props: {
        'estado': PropDef('enum',
            options: BoldSeloEstado.values.map((e) => e.name).toList()),
        'tamanho': const PropDef('enum', options: ['120', '160', '200']),
        'rotulo': const PropDef('bool'),
      },
      defaults: () => {'estado': 'autorizado', 'tamanho': '160', 'rotulo': true},
      build: (p) => BoldSeloQuantico(
        estado: BoldSeloEstado.values.firstWhere((e) => e.name == p['estado']),
        tamanho: double.parse('${p['tamanho']}'),
        mostrarRotulo: p['rotulo'] == true,
      ),
      codegen: (p) => 'ds.BoldSeloQuantico('
          'estado: ds.BoldSeloEstado.${p['estado']}'
          ', tamanho: ${p['tamanho']}'
          '${p['rotulo'] == true ? '' : ', mostrarRotulo: false'})',
    );

BlockDef _indicadorDeHome() => BlockDef(
      type: 'indicadorDeHome',
      label: 'Home indicator',
      props: const {},
      defaults: () => {},
      build: (p) => const DilettaBottomHomeIndicator(),
      codegen: (p) => '',
    );

// ─────────────────────────────────────────────────────────────────────────────
// AS SEIS QUE ATRAVESSARAM A FRONTEIRA
//
// Elas entraram no mesmo dia e pela mesma causa: o dono pediu quatro telas de loja em alta
// fidelidade, e as quatro paravam em peças que só existiam dentro do aparelho.
//
// Quatro eram LACUNA no inventário de adoção — peça que desenha sozinha, sem par na linguagem:
// ladrilho de menu (alcance 4), chip de filtro (3), linha de aviso (2) e cartão promocional (2).
// Duas já eram ADOTADAS e estavam do lado errado da fronteira: a fileira de avatares e o grupo do
// dia moravam em `app-newbold/lib/design_system/`, e o catálogo consome o PACOTE, nunca o app.
//
// A régua que saiu daqui: **adotada e alcançável não são a mesma coisa.** O inventário media a
// primeira e ninguém media a segunda — e o sintoma das duas é o mesmo, peça que não dá pra desenhar
// em lugar nenhum.
// ─────────────────────────────────────────────────────────────────────────────

/// O ladrilho do menu — a maior lacuna que restava, e três telas dependiam dele.
BlockDef _ladrilhoDeMenu() => BlockDef(
      type: 'ladrilhoDeMenu',
      acoes: const {'aoTocar': 'aoTocar'},
      ctor: 'ds.CoreflowLadrilhoDeMenu',
      args: const {
        'icone': Arg.enumeracao('icone', 'ds.DilettaIcons'),
        'rotulo': Arg.texto('rotulo'),
        'porte': Arg.enumeracao('porte', 'ds.CoreflowPorteDoLadrilho'),
      },
      label: 'Ladrilho de menu · MenuTile',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'rotulo': const PropDef('text', bindable: true, dartType: 'String'),
        'porte': PropDef('enum',
            options: CoreflowPorteDoLadrilho.values.map((e) => e.name).toList()),
      },
      defaults: () => {'icone': 'pixLight', 'rotulo': 'Área Pix', 'porte': 'largo'},
      build: (p) => CoreflowLadrilhoDeMenu(
        icone: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        rotulo: '${p['rotulo']}',
        porte: _daOpcao(p['porte'], _porNome(CoreflowPorteDoLadrilho.values),
            CoreflowPorteDoLadrilho.largo),
        aoTocar: () {},
      ),
      codegen: (p) => 'ds.CoreflowLadrilhoDeMenu(icone: ds.DilettaIcons.${p['icone']}'
          ', rotulo: ${_str(p['rotulo'])}'
          ', porte: ds.CoreflowPorteDoLadrilho.${p['porte']}'
          ', aoTocar: aoTocar)',
    );

/// A NAV FLUTUANTE — a pílula da home, e ela existe porque o board mostrava a barra do PAI.
///
/// O print do dono: *"a navbar da home tá diferente, parece que você redesenhou do zero."* Não era
/// redesenho — era a peça errada. A `nav` do `barraDeBaixo` emite `DilettaBottomApp.nav`, que é barra
/// ANCORADA full-width com o traço de home por dentro; a home deste app usa **pílula flutuante** com hug
/// e margem de 16. A diferença estava escrita no `///` do `BoldBottomApp` do app desde antes, e nenhum
/// gate media isso: os dois desenhos são válidos, e escolher o outro não falha em lugar nenhum.
///
/// Bloco SEPARADO e não sexta variante da união: a união é das factories do pai, e esta peça não é dele.
///
/// Os itens usam o mesmo idioma do `abas` e da `nav` — `Rótulo:icone`, separados por vírgula. Aqui o
/// ícone NÃO é opcional: a pílula é ícone em cima e rótulo embaixo, e item sem glifo deixa um buraco
/// redondo no lugar em que a fila tem um spot.
BlockDef _navFlutuante() => BlockDef(
      type: 'navFlutuante',
      acoes: const {'aoTrocar': 'aoTrocarAba'},
      label: 'Nav flutuante · pílula da home',
      props: const {
        'abas': PropDef('text'),
        'abaAtiva': PropDef('number'),
      },
      defaults: () => {
        'abas': 'Início:houseLight, Câmera:cameraLight, Letti:sparklesLightFull',
        'abaAtiva': '0',
      },
      build: (p) => CoreflowNavFlutuante(
        itens: _itensDaPilula(p['abas']),
        ativo: _indiceDeAba(p),
        aoTrocar: (_) {},
      ),
      codegen: (p) => 'ds.CoreflowNavFlutuante(itens: const ['
          '${_itensDaPilula(p['abas']).map((i) => 'ds.CoreflowItemDeNav('
              'icone: ds.DilettaIcons.${_chaveDoIcone(i.icone)}'
              ', rotulo: ${_str(i.rotulo)})').join(', ')}]'
          ', ativo: ${_indiceDeAba(p)}'
          ', aoTrocar: aoTrocarAba)',
    );

/// Os itens da pílula, no idioma `Rótulo:icone` — e o ícone cai na CASA quando o nome não existe no
/// conjunto do pai. A `nav` do pai cai pro ponto neutro dela; aqui não há ponto neutro, então o
/// fallback é a casa: um glifo errado é mais fácil de ver que um vazio redondo.
List<CoreflowItemDeNav> _itensDaPilula(Object? cru) => [
      for (final i in _itensDeNav(cru))
        CoreflowItemDeNav(
          icone: DilettaIcons.all[i.icone] ?? DilettaIcons.houseLight,
          rotulo: i.rotulo,
        ),
    ];

/// O caminho de volta do ARQUIVO pra CHAVE (`house-light` → `houseLight`), que é o que o código gerado
/// escreve. Sem isto o codegen emitiria `ds.DilettaIcons.house-light`, que não é identificador.
String _chaveDoIcone(String arquivo) => DilettaIcons.all.entries
    .firstWhere((e) => e.value == arquivo,
        orElse: () => const MapEntry('houseLight', ''))
    .key;

/// A AMOSTRA DE FUNDO — o retrato de um dos sete moods, no seletor de Aparência.
///
/// Ela entra pelo mesmo motivo das seis de 11/08: era classe PRIVADA dentro de uma tela do app, e
/// classe privada é invisível pra varredura de adoção. A diferença é o que ela desenha — um TOKEN
/// deste DS. Fundo com sete valores e nenhuma vitrine é o caso em que o catálogo não conseguia mostrar
/// a própria linguagem.
BlockDef _amostraDeFundo() => BlockDef(
      type: 'amostraDeFundo',
      acoes: const {'aoTocar': 'aoTocar'},
      ctor: 'ds.CoreflowAmostraDeFundo',
      args: const {
        'estilo': Arg.enumeracao('estilo', 'ds.CoreflowBackdrop'),
        'rotulo': Arg.texto('rotulo'),
        'escolhido': Arg.bool('escolhido'),
      },
      label: 'Amostra de fundo · BackdropSwatch',
      props: {
        'estilo': PropDef('enum',
            options: CoreflowBackdrop.values.map((e) => e.name).toList()),
        'rotulo': const PropDef('text', bindable: true, dartType: 'String'),
        'escolhido': const PropDef('bool'),
      },
      defaults: () => {'estilo': 'imagem', 'rotulo': 'Cidade', 'escolhido': true},
      build: (p) => CoreflowAmostraDeFundo(
        estilo: _daOpcao(p['estilo'], _porNome(CoreflowBackdrop.values),
            CoreflowBackdrop.imagem),
        rotulo: '${p['rotulo']}',
        escolhido: p['escolhido'] == true,
        aoTocar: () {},
      ),
      codegen: (p) => 'ds.CoreflowAmostraDeFundo(estilo: ds.CoreflowBackdrop.${p['estilo']}'
          ', rotulo: ${_str(p['rotulo'])}'
          ', escolhido: ${p['escolhido'] == true}'
          ', aoTocar: aoTocar)',
    );

/// A linha de aviso da home — a das *Autorizações*, com a contagem.
BlockDef _linhaDeAviso() => BlockDef(
      type: 'linhaDeAviso',
      acoes: const {'aoTocar': 'aoTocar'},
      ctor: 'ds.CoreflowLinhaDeAviso',
      args: const {
        'icone': Arg.enumeracao('icone', 'ds.DilettaIcons'),
        'titulo': Arg.texto('titulo'),
        'subtitulo': Arg.texto('subtitulo'),
      },
      label: 'Linha de aviso · NoticeRow',
      props: {
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'subtitulo': const PropDef('text', bindable: true, dartType: 'String'),
        'contagem': const PropDef('number', bindable: true, dartType: 'int'),
      },
      defaults: () => {
        'icone': 'paperPlaneLight',
        'titulo': 'Autorizações',
        'subtitulo': 'Veja o que está esperando você.',
        'contagem': '2',
      },
      build: (p) => CoreflowLinhaDeAviso(
        icone: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        titulo: '${p['titulo']}',
        subtitulo: _vazio(p['subtitulo']) ? null : '${p['subtitulo']}',
        contagem: int.tryParse('${p['contagem']}'),
        aoTocar: () {},
      ),
      codegen: (p) => 'ds.CoreflowLinhaDeAviso(icone: ds.DilettaIcons.${p['icone']}'
          ', titulo: ${_str(p['titulo'])}'
          '${_vazio(p['subtitulo']) ? '' : ', subtitulo: ${_str(p['subtitulo'])}'}'
          ', contagem: ${int.tryParse('${p['contagem']}') ?? 0}'
          ', aoTocar: aoTocar)',
    );

/// O chip de filtro — a pílula que INVERTE quando escolhida.
BlockDef _chipDeFiltro() => BlockDef(
      type: 'chipDeFiltro',
      acoes: const {'aoTocar': 'aoTocar'},
      ctor: 'ds.CoreflowChipDeFiltro',
      args: const {
        'rotulo': Arg.textoPosicional(),
        'escolhido': Arg.bool('escolhido'),
      },
      label: 'Chip de filtro · FilterChip',
      props: const {
        'rotulo': PropDef('text', bindable: true, dartType: 'String'),
        'escolhido': PropDef('bool'),
      },
      defaults: () => {'rotulo': 'Entradas', 'escolhido': false},
      build: (p) => CoreflowChipDeFiltro('${p['rotulo']}',
          escolhido: p['escolhido'] == true, aoTocar: () {}),
      codegen: (p) => 'ds.CoreflowChipDeFiltro(${_str(p['rotulo'])}'
          ', escolhido: ${p['escolhido'] == true}, aoTocar: aoTocar)',
    );

/// O cartão promocional do carrossel — o que se dispensa pelo X.
BlockDef _cartaoPromocional() => BlockDef(
      type: 'cartaoPromocional',
      acoes: const {'aoFechar': 'aoFechar', 'aoTocar': 'aoTocar'},
      // A ARTE ENTRA COMO PROP, e o placeholder de 100×100 morreu com ela.
      //
      // O `///` do componente dizia *"o placeholder ficou porque a arte do carrossel é do app (asset de
      // produto, não do DS)"*. Estava errado por um detalhe medido: o app carrega
      // `illustrations/key_word_{tema}.svg`, e o PAI tem `DilettaIllustration.keyWord` com base
      // `key_word` — **é a mesma arte**, e ela é token da linguagem desde antes. O que faltava era o
      // bloco passar o token; ninguém precisava de asset novo.
      //
      // Foi um print do dono que cobrou: *"a ilustração precisa estar no banner da passkey."* Um
      // quadrado cinza com ícone de imagem no meio da tela de loja passa por decisão de design.
      // ELE SAIU DA TABELA por causa da arte, e a razão é a mesma do `linhaDeValor`.
      //
      // A tabela lê e emite `Ctor(arg: valor)` com valor LITERAL — texto, número, booleano ou
      // `Tipo.membro`. A ilustração não é nenhum dos quatro: ela é um WIDGET aninhado
      // (`ds.DilettaIllustrationAccessory(illustration: …, size: …)`), porque o componente recebe
      // `Widget? ilustracao` e não o token.
      //
      // **E isto era um defeito medido, não uma preferência.** Com `ctor`+`args` declarados o motor
      // prefere a tabela e o `codegen` fica vestigial — então o board desenhava a arte e o código
      // emitido saía SEM ela, em silêncio. É o modo de falha que este repo já nomeou duas vezes: prop
      // ignorada sem erro parece decisão de quem montou a tela.
      //
      // O par disto é a entrada no leitor (`leitor_do_bold.dart`), senão o gate `bloco-sem-leitura`
      // cobra — e cobra certo: sem a volta, a tela colada abre como código cru.
      label: 'Cartão promocional · PromoCard',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'subtitulo': const PropDef('multiline', bindable: true, dartType: 'String'),
        'ilustracao': PropDef('enum', options: ['', ..._nomesDeIlustracao]),
        'fecha': const PropDef('bool'),
      },
      defaults: () => {
        'titulo': 'Habilite sua passkey',
        'subtitulo': 'Login sem senha, resistente a phishing.',
        // `keyWord` é a arte que o app usa neste cartão, medida no `_promos()` da home.
        'ilustracao': 'keyWord',
        'fecha': true,
      },
      build: (p) => CoreflowCartaoPromocional(
        titulo: '${p['titulo']}',
        subtitulo: _vazio(p['subtitulo']) ? null : '${p['subtitulo']}',
        // Vazio continua caindo no placeholder, e isso é o contrato do componente: cartão sem arte
        // declarada é um buraco de 100 sem explicação, e o placeholder é a explicação.
        ilustracao: _vazio(p['ilustracao']) ? null : _arteDoCartao(p['ilustracao']),
        aoFechar: p['fecha'] == true ? () {} : null,
        aoTocar: () {},
      ),
      codegen: (p) => 'ds.CoreflowCartaoPromocional(titulo: ${_str(p['titulo'])}'
          '${_vazio(p['subtitulo']) ? '' : ', subtitulo: ${_str(p['subtitulo'])}'}'
          '${_vazio(p['ilustracao']) ? '' : ', ilustracao: ds.DilettaIllustrationAccessory('
              'illustration: ds.DilettaIllustration.${p['ilustracao']}'
              ', size: ds.DilettaIllustrationSize.sm)'}'
          '${p['fecha'] == true ? ', aoFechar: aoFechar' : ''}'
          ', aoTocar: aoTocar)',
    );

/// A fileira de avatares — o *"Enviar para"*.
///
/// As três listas chegam como texto separado por vírgula, e não como slot. É a mesma escolha do
/// `abas` e do `segmentos`: aqui os itens não são blocos com props próprias, são três strings
/// paralelas de um item só. Slot pra isso obrigaria três blocos filhos por avatar.
BlockDef _fileiraDeAvatares() => BlockDef(
      type: 'fileiraDeAvatares',
      label: 'Fileira de avatares · AvatarRow',
      props: const {
        'iniciais': PropDef('text'),
        'rotulos': PropDef('text'),
        'subrotulos': PropDef('text'),
        'adiciona': PropDef('bool'),
      },
      defaults: () => {
        'iniciais': 'CM, BL, RS',
        'rotulos': 'Carla, Bruno, Rita',
        'subrotulos': 'Nubank, Itaú, BOLD',
        'adiciona': true,
      },
      build: (p) => CoreflowFileiraDeAvatares(
        iniciais: _emLista(p['iniciais']),
        rotulos: _vazio(p['rotulos']) ? null : _emLista(p['rotulos']),
        subrotulos: _vazio(p['subrotulos']) ? null : _emLista(p['subrotulos']),
        aoAdicionar: p['adiciona'] == true ? () {} : null,
        aoTocarNoAvatar: (_) {},
      ),
      codegen: (p) => 'ds.CoreflowFileiraDeAvatares(iniciais: const '
          '${_emLista(p['iniciais']).map(_str).toList()}'
          '${_vazio(p['rotulos']) ? '' : ', rotulos: const ${_emLista(p['rotulos']).map(_str).toList()}'}'
          '${_vazio(p['subrotulos']) ? '' : ', subrotulos: const ${_emLista(p['subrotulos']).map(_str).toList()}'}'
          '${p['adiciona'] == true ? ', aoAdicionar: aoAdicionar' : ''}'
          ', aoTocarNoAvatar: aoTocarNoAvatar)',
    );

/// O grupo do dia do extrato — rótulo da data, saldo do dia à direita, lançamentos com fio.
///
/// Tem SLOT, e é o segundo bloco deste filho com um: os lançamentos são `linhaDeValor` de verdade.
/// O acessório à direita é TEXTO e não slot porque ele é sempre o mesmo — o saldo consolidado —, e
/// slot de um tipo só é slot que só tem uma resposta.
BlockDef _grupoDoDia() => BlockDef(
      type: 'grupoDoDia',
      label: 'Grupo do dia · extrato',
      props: const {
        'rotulo': PropDef('text', bindable: true, dartType: 'String'),
        'acessorio': PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {'rotulo': 'Sexta, 8 de agosto', 'acessorio': r'R$ 2.912,47'},
      slots: const {
        'itens': SlotDef(list: true, accepts: ['linhaDeValor']),
      },
      build: (p) => _grupoDoDiaWidget(p, const []),
      slotsBuild: (p, filhos) => _grupoDoDiaWidget(p, filhos['itens'] ?? const []),
      slotsCodegen: (p, codigos) {
        final itens = codigos['itens'] ?? const [];
        return 'ds.CoreflowGrupoDoDia(rotulo: ${_str(p['rotulo'])}'
            '${_vazio(p['acessorio']) ? '' : ', acessorio: ds.DilettaText(${_str(p['acessorio'])}, style: ds.DilettaType.labelMd)'}'
            ', filhos: [${itens.join(', ')}])';
      },
      codegen: (p) => 'ds.CoreflowGrupoDoDia(rotulo: ${_str(p['rotulo'])}'
          ', filhos: const [])',
    );

Widget _grupoDoDiaWidget(Map<String, Object?> p, List<Widget> itens) =>
    CoreflowGrupoDoDia(
      rotulo: '${p['rotulo']}',
      acessorio: _vazio(p['acessorio'])
          ? null
          : DilettaText('${p['acessorio']}', style: DilettaType.labelMd),
      filhos: itens,
    );

/// Texto separado por vírgula → lista, sem item vazio.
///
/// Mesma leitura do `abas` e do `segmentos`, e ela mora numa função porque três props da fileira de
/// avatares fazem a mesma coisa — três `split` copiados divergem no primeiro conserto.
List<String> _emLista(Object? bruto) => '$bruto'
    .split(',')
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .toList();


/// A GRADE — o container de LINHA que este registro não tinha, e que três telas cobraram.
///
/// A gramática do motor é `top` / `blocks` / `bottom`, e dentro de `blocks` tudo empilha. Isso
/// estava escrito como limite declarado em duas telas: *"no app os dois botões são uma LINHA; aqui
/// eles empilham, e não é preguiça — este registro não tem container de linha"*.
///
/// Ele entra agora porque a medição fechou: **três sítios**, e nenhum deles é o mesmo desenho —
/// o menu 2×2 da home, a grade de 3 colunas da Área Pix e a fileira de chips do extrato. Um caso
/// não vira container; três com formas diferentes viram.
///
/// ## Ele não decide largura, ele decide COLUNAS
///
/// Com `colunas: 0` os itens ficam numa fileira que quebra (`Wrap`), cada um com a largura que
/// pedir — é o caso dos chips e da grade compacta do Pix. Com `colunas: 2` ou `3` eles dividem a
/// largura em partes iguais, que é o menu da home. A diferença não é estética: no primeiro caso o
/// item tem largura própria, no segundo ele herda.
BlockDef _grade() => BlockDef(
      type: 'grade',
      label: 'Grade · Frame',
      props: const {
        'colunas': PropDef('enum', options: ['fileira', 'fluida', '2', '3']),
        'vao': PropDef('enum', options: ['s2', 's3', 's4']),
      },
      defaults: () => {'colunas': '2', 'vao': 's4'},
      slots: const {
        'itens': SlotDef(list: true, accepts: [
          'ladrilhoDeMenu',
          'cartaoDeAcesso',
          'chipDeFiltro',
          'chipDeInfo',
          'botao',
          // A amostra de fundo entra na grade FLUIDA: os cinco retratos têm 64 de largura PRÓPRIA e
          // quebram quando não cabem — o mesmo caso do menu compacto da Área Pix. Em coluna cada um
          // esticaria pra um quinto da tela e o retrato deixaria de ser quadrado.
          'amostraDeFundo',
        ]),
      },
      build: (p) => _gradeWidget(p, const []),
      slotsBuild: (p, filhos) => _gradeWidget(p, filhos['itens'] ?? const []),
      slotsCodegen: (p, codigos) {
        final itens = codigos['itens'] ?? const [];
        final vao = 'ds.DilettaSpacing.${p['vao']}';
        // A fileira é `ds.DilettaFrame.row` e não um `Wrap`: o `Wrap` é do Flutter, e o gate
        // `o_catalogo_do_bold_esta_completo` cobra que todo bloco emita COMPONENTE do DS. A cobrança
        // está certa — bloco que emite widget cru é bloco que ensina a sair da linguagem.
        if ('${p['colunas']}' == 'fileira') {
          return 'ds.DilettaFrame.row(gap: $vao, children: [${itens.join(', ')}])';
        }
        // A FLUIDA é `ds.DilettaFrame.flow`, e ela embrulhava um `Wrap` do Flutter até o pedido
        // entrar (`ds v0.67.0`, no mesmo dia). O que o veredito acrescentou vale reter: o `Wrap`
        // estava listado no `ENCAPSULAMENTO.md` do pai como *deixar cru — sem decisão estética*, e
        // `Row`/`Column`/`Stack` também não carregam estética e têm wrapper. **O que o `DilettaFrame`
        // encapsula nunca foi o eixo, é o RITMO** — e o `Wrap` precisa de DOIS ritmos, então ele era
        // o caso mais forte da regra e não a exceção dela.
        if ('${p['colunas']}' == 'fluida') {
          return 'ds.DilettaFrame.flow(gap: $vao, runGap: $vao'
              ', children: [${itens.join(', ')}])';
        }
        return 'ds.DilettaFrame.column(gap: $vao, children: ['
            '${_emLinhas(itens, int.parse('${p['colunas']}'), vao).join(', ')}])';
      },
      codegen: (p) => 'ds.DilettaFrame.column(gap: ds.DilettaSpacing.${p['vao']}'
          ', children: const [])',
    );

Widget _gradeWidget(Map<String, Object?> p, List<Widget> itens) {
  final vao = _espaco('${p['vao']}');
  final colunas = int.tryParse('${p['colunas']}') ?? 0;
  if ('${p['colunas']}' == 'fluida') {
    return DilettaFrame.flow(gap: vao, runGap: vao, children: itens);
  }
  if (colunas == 0) {
    return DilettaFrame.row(gap: vao, children: itens);
  }
  // As duas metades usam o FRAME do pai, e o espaçador virou `gap` nos dois: espaçador como filho é
  // o que o `DilettaFrame` existe pra apagar, e mantê-lo aqui era o `build` desenhando uma coisa e o
  // `codegen` emitindo outra.
  final linhas = <Widget>[];
  for (var i = 0; i < itens.length; i += colunas) {
    final naLinha = <Widget>[];
    for (var c = 0; c < colunas; c++) {
      // A célula VAZIA no fim é `Expanded(SizedBox)` e não nada: sem ela o último item de uma
      // linha ímpar estica pra largura inteira e a grade deixa de ser grade na última fileira.
      naLinha.add(Expanded(
          child: i + c < itens.length ? itens[i + c] : const SizedBox()));
    }
    linhas.add(DilettaFrame.row(
        gap: vao,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: naLinha));
  }
  return DilettaFrame.column(
      gap: vao,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: linhas);
}

/// Os itens agrupados em `Row`s de [colunas], no CÓDIGO. Mesma regra do `build`, inclusive a
/// célula vazia do fim — os dois lados têm que desenhar a mesma grade.
List<String> _emLinhas(List<String> itens, int colunas, String vao) {
  final linhas = <String>[];
  for (var i = 0; i < itens.length; i += colunas) {
    final celulas = <String>[];
    for (var c = 0; c < colunas; c++) {

      celulas.add(i + c < itens.length
          ? 'Expanded(child: ${itens[i + c]})'
          : 'const Expanded(child: SizedBox())');
    }
    // `ds.DilettaFrame.row` e não `Row`: o `Expanded` dentro dele É a linguagem — o `///` do frame
    // diz com todas as letras que *"um filho fill no eixo principal é um `Expanded` passado como
    // filho"*. O que não é linguagem é o CONTAINER cru, e era ele que estava aqui.
    linhas.add('ds.DilettaFrame.row(gap: $vao, children: [${celulas.join(', ')}])');
  }
  return linhas;
}

/// O CARTÃO DA CONTA — o cabeçalho da tela de Gestão da conta.
BlockDef _cartaoDaConta() => BlockDef(
      type: 'cartaoDaConta',
      ctor: 'ds.CoreflowCartaoDaConta',
      args: const {
        'nomeDaConta': Arg.texto('nomeDaConta'),
        'tipo': Arg.texto('tipo'),
        'numero': Arg.texto('numero'),
        'linhaDeApoio': Arg.texto('linhaDeApoio'),
      },
      label: 'Cartão da conta · header de Conta',
      props: const {
        'nomeDaConta': PropDef('text', bindable: true, dartType: 'String'),
        'tipo': PropDef('text', bindable: true, dartType: 'String'),
        'numero': PropDef('text', bindable: true, dartType: 'String'),
        'linhaDeApoio': PropDef('text', bindable: true, dartType: 'String'),
      },
      defaults: () => {
        'nomeDaConta': 'Minha conta',
        'tipo': 'Conta PF',
        'numero': '12345-6',
        'linhaDeApoio': 'Ag 0001 · 655 – BOLD',
      },
      build: (p) => CoreflowCartaoDaConta(
        nomeDaConta: '${p['nomeDaConta']}',
        tipo: '${p['tipo']}',
        numero: '${p['numero']}',
        linhaDeApoio: '${p['linhaDeApoio']}',
      ),
      codegen: (p) => 'ds.CoreflowCartaoDaConta('
          'nomeDaConta: ${_str(p['nomeDaConta'])}, tipo: ${_str(p['tipo'])}'
          ', numero: ${_str(p['numero'])}, linhaDeApoio: ${_str(p['linhaDeApoio'])})',
    );

/// O CARTÃO DO PEDIDO — a tela de aprovação, vista por quem aprova.
BlockDef _cartaoDePedido() => BlockDef(
      type: 'cartaoDePedido',
      acoes: const {'aoAprovar': 'aoContinuar', 'aoRejeitar': 'aoVoltar'},
      ctor: 'ds.CoreflowCartaoDePedido',
      args: const {
        'quemPediu': Arg.texto('quemPediu'),
        'detalhe': Arg.texto('detalhe'),
        'valor': Arg.texto('valor'),
        'icone': Arg.enumeracao('icone', 'ds.DilettaIcons'),
        'colhidas': Arg.numero('colhidas'),
        'exigidas': Arg.numero('exigidas'),
        'exigeMaster': Arg.bool('exigeMaster'),
        'idade': Arg.texto('idade'),
        'aprovadaPor': Arg.texto('aprovadaPor'),
        'motivo': Arg.texto('motivo'),
        'justificativa': Arg.texto('justificativa'),
        'jaAprovei': Arg.bool('jaAprovei'),
      },
      label: 'Cartão do pedido · aprovação',
      props: {
        'quemPediu': const PropDef('text', bindable: true, dartType: 'String'),
        'detalhe': const PropDef('text', bindable: true, dartType: 'String'),
        'valor': const PropDef('text', bindable: true, dartType: 'String'),
        'icone': PropDef('enum', options: DilettaIcons.all.keys.toList()),
        'colhidas': const PropDef('number', bindable: true, dartType: 'int'),
        'exigidas': const PropDef('number', bindable: true, dartType: 'int'),
        'exigeMaster': const PropDef('bool'),
        'idade': const PropDef('text', bindable: true, dartType: 'String'),
        'aprovadaPor': const PropDef('text', bindable: true, dartType: 'String'),
        'motivo': const PropDef('multiline', bindable: true, dartType: 'String'),
        'justificativa': const PropDef('multiline', bindable: true, dartType: 'String'),
        'jaAprovei': const PropDef('bool'),
      },
      defaults: () => {
        'quemPediu': 'Marcos Almeida',
        'detalhe': 'Pix · para Ana Maria Silva · 14:32',
        'valor': r'R$ 8.400,00',
        'icone': 'pixLight',
        'colhidas': '1',
        'exigidas': '2',
        'exigeMaster': true,
        'idade': 'há 3 horas',
        'aprovadaPor': 'Marcos Almeida',
        'motivo': 'Limite por transação (GLOBAL · 2 aprovações · Master)',
        'justificativa': 'Pagamento do fornecedor de embalagens, NF 4471.',
        'jaAprovei': false,
      },
      build: (p) => CoreflowCartaoDePedido(
        quemPediu: '${p['quemPediu']}',
        detalhe: '${p['detalhe']}',
        valor: '${p['valor']}',
        icone: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        colhidas: int.tryParse('${p['colhidas']}') ?? 0,
        exigidas: int.tryParse('${p['exigidas']}') ?? 1,
        exigeMaster: p['exigeMaster'] == true,
        idade: _vazio(p['idade']) ? null : '${p['idade']}',
        aprovadaPor: _vazio(p['aprovadaPor']) ? null : '${p['aprovadaPor']}',
        motivo: _vazio(p['motivo']) ? null : '${p['motivo']}',
        justificativa:
            _vazio(p['justificativa']) ? null : '${p['justificativa']}',
        jaAprovei: p['jaAprovei'] == true,
        aoAprovar: () {},
        aoRejeitar: () {},
      ),
      codegen: (p) => 'ds.CoreflowCartaoDePedido('
          'quemPediu: ${_str(p['quemPediu'])}, detalhe: ${_str(p['detalhe'])}'
          ', valor: ${_str(p['valor'])}, icone: ds.DilettaIcons.${p['icone']}'
          ', colhidas: ${int.tryParse('${p['colhidas']}') ?? 0}'
          ', exigidas: ${int.tryParse('${p['exigidas']}') ?? 1}'
          '${p['exigeMaster'] == true ? ', exigeMaster: true' : ''}'
          '${_vazio(p['idade']) ? '' : ', idade: ${_str(p['idade'])}'}'
          '${_vazio(p['aprovadaPor']) ? '' : ', aprovadaPor: ${_str(p['aprovadaPor'])}'}'
          '${_vazio(p['motivo']) ? '' : ', motivo: ${_str(p['motivo'])}'}'
          '${_vazio(p['justificativa']) ? '' : ', justificativa: ${_str(p['justificativa'])}'}'
          '${p['jaAprovei'] == true ? ', jaAprovei: true' : ''}'
          ', aoAprovar: aoContinuar, aoRejeitar: aoVoltar)',
    );

// ═══════════════════════════════════════════════════════════════════════════════
// 2 · O PLUGUE
// ═══════════════════════════════════════════════════════════════════════════════

/// O segundo dos quatro plugues.
void configurarDsDoBold() {
  // O mapa de blocos sai pra uma variável porque os CONTRATOS derivam dele. Ler `Ds.blocos` aqui seria
  // o ovo antes da galinha — e o motor falha alto nisso, com a mensagem certa: "nenhum design system
  // plugado". Melhor assim que um mapa vazio em silêncio.
  // ONDE OS ASSETS DO PAI MORAM — uma linha, e sem ela nenhum ícone aparece.
  //
  // `DilettaAssets.assetPackage` nasce `null`, que significa "assets na raiz do bundle". Num app que
  // CONSOME o pacote eles moram em `packages/diletta_design_system/…`, então o `AssetBytesLoader`
  // procurava no lugar errado — e `VectorGraphic` com asset ausente não estoura: desenha uma caixa
  // vazia. TODOS os ícones do catálogo estavam invisíveis por causa disto, e nenhum teste viu porque
  // widget na árvore não é pixel na tela.
  //
  // Fica aqui, no plugue, e não no `main`: é quem liga o DS que sabe onde o DS guarda coisa — e assim
  // todo teste que configura o plugue herda a resolução. O primeiro filho seta no `main` do catálogo
  // dele, e por isso o teste dele não cobre este caso.
  DilettaAssets.assetPackage = DilettaAssets.package;

  final blocos = <String, BlockDef>{
      'barraDeStatus': _barraDeStatusBloco(),
      'tituloDaPagina': _tituloDaPagina(),
      'texto': _texto(),
      'valor': _valor(),
      'selo': _selo(),
      'campo': _campo(),
      'aviso': _aviso(),
      'icone': _icone(),
      'ritmo': _ritmo(),
      'divisor': _divisor(),
      'botao': _botao(),
      'barraDeBaixo': _barraDeBaixo(),
      'seloQuantico': _seloQuantico(),
      'saldo': _saldo(),
      'copiar': _copiar(),
      'abas': _abas(),
      'visorDeCodigo': _visorDeCodigo(),
      'cabecalhoDaHome': _cabecalhoDaHome(),
      'indicadorDeHome': _indicadorDeHome(),
      'cabecalhoDeSecao': _cabecalhoDeSecao(),
      'lista': _lista(),
      'linha': _linha(),
      'linhaDeValor': _linhaDeValor(),
      'linhaDeEscolha': _linhaDeEscolha(),
      'resumoDaTransacao': _resumoDaTransacao(),
      'escadaDeAlcadas': _escadaDeAlcadas(),
      'progressoDeAprovacao': _progressoDeAprovacao(),
      'prazoDaPendencia': _prazoDaPendencia(),
      'segmentos': _segmentos(),
      'pontosDePagina': _pontosDePagina(),
      // Os renames, em ordem de uso medido no app.
      'toast': _toast(),
      'esqueleto': _esqueleto(),
      'botaoDeIcone': _botaoDeIcone(),
      'avatar': _avatar(),
      'interruptor': _interruptor(),
      'campoDeBusca': _campoDeBusca(),
      'girando': _girando(),
      'ilustracao': _ilustracao(),
      'estadoVazio': _estadoVazio(),
      'logo': _logo(),
      'chipDeInfo': _chipDeInfo(),
      'chipDeEntrada': _chipDeEntrada(),
      'cartaoDeAcesso': _cartaoDeAcesso(),
      'caixaDeSelecao': _caixaDeSelecao(),
      // O lote de forma irregular, que a v0.35.0 (`acoes`) tornou declarável.
      'comprovante': _comprovante(),
      'folha': _folha(),
      'dialogo': _dialogo(),
      'listaDeRadio': _listaDeRadio(),
      'criterios': _criterios(),
      'dropdown': _dropdown(),
      'expansivel': _expansivel(),
      'cartaoDeDestaque': _cartaoDeDestaque(),
      // Os cinco que faltavam com uso real, medidos a pedido do dono do produto.
      'cascaDeTopo': _cascaDeTopo(),
      'barraDeNavegacao': _barraDeNavegacao(),
      'bannerDeStatus': _bannerDeStatus(),
      'calendario': _calendario(),
      'teclado': _teclado(),
      // As seis que atravessaram a fronteira — ver o bloco de prosa acima delas.
      'ladrilhoDeMenu': _ladrilhoDeMenu(),
      'amostraDeFundo': _amostraDeFundo(),
      // A pílula da home, que atravessou a fronteira em 13/08 por um print.
      'navFlutuante': _navFlutuante(),
      'linhaDeAviso': _linhaDeAviso(),
      'chipDeFiltro': _chipDeFiltro(),
      'cartaoPromocional': _cartaoPromocional(),
      'fileiraDeAvatares': _fileiraDeAvatares(),
      'grupoDoDia': _grupoDoDia(),
      'grade': _grade(),
      'cartaoDaConta': _cartaoDaConta(),
      'cartaoDePedido': _cartaoDePedido(),
  };

  Ds.configurar(PlugueDoDs(
    blocos: blocos,
    // TODO tipo precisa estar num grupo: a paleta do editor sai daqui, então bloco sem
    // grupo existe e ninguém acha. A conformidade do pai cobra.
    grupos: const {
      'Estrutura': ['barraDeStatus', 'cascaDeTopo', 'barraDeNavegacao', 'tituloDaPagina',
        'indicadorDeHome'],
      'Conteúdo': ['texto', 'valor', 'selo', 'aviso', 'icone', 'cabecalhoDeSecao',
        'ilustracao', 'logo', 'chipDeInfo', 'estadoVazio', 'avatar', 'criterios', 'expansivel',
        'cartaoDeDestaque', 'comprovante', 'bannerDeStatus'],
      // A lista e as duas linhas ficam juntas porque é assim que se usam: a coleção é dona do
      // separador, e linha fora de lista é linha sem vizinhança.
      // O grupo do dia entra aqui e não em "Marca do Bold": ele é o ENVELOPE de uma coleção, e a
      // vizinhança que ensina é a da lista — quem procura "como agrupo lançamentos" procura em Lista.
      'Lista': ['lista', 'linha', 'linhaDeValor', 'linhaDeEscolha', 'grupoDoDia'],
      // Retorno de sistema: o que a tela diz enquanto ou depois de algo acontecer.
      'Retorno': ['toast', 'esqueleto', 'girando'],
      // Camada: o que aparece POR CIMA da tela.
      'Camada': ['folha', 'dialogo'],
      // Grupo próprio porque é o que só o Bold tem: a vizinhança na paleta é decisão de
      // linguagem, e peça de marca não se mistura com vocabulário herdado.
      'Marca do Bold': ['seloQuantico', 'saldo', 'cabecalhoDaHome', 'resumoDaTransacao',
        // As três da HOME que faltavam: o menu, o aviso das autorizações e o cartão do carrossel.
        // Elas eram lacuna do inventário até 11/08 e não existiam em paleta nenhuma.
        'ladrilhoDeMenu', 'linhaDeAviso', 'cartaoPromocional', 'fileiraDeAvatares',
        'cartaoDaConta', 'cartaoDePedido',
        // A amostra de fundo é do Bold e de mais ninguém: ela retrata o `CoreflowBackdrop`, que é token
        // deste produto. Vizinha das outras peças de marca, e não do `chipDeFiltro` em Entrada —
        // apesar de ser escolha, o que ela ensina é o fundo.
        'amostraDeFundo'],
      'Do Bold': ['copiar', 'abas', 'segmentos', 'pontosDePagina'],
      // As três peças da conta PJ: quem pode mandar quanto, falta quanto, e até quando.
      'Alçadas': ['escadaDeAlcadas', 'progressoDeAprovacao', 'prazoDaPendencia'],
      'Leitor de código': ['visorDeCodigo'],
      // O chip de filtro mora em Entrada e não em Conteúdo: ele é escolha, e escolha única numa
      // fila é entrada de dado — o vizinho certo é o `listaDeRadio`, não o `chipDeInfo`.
      'Entrada': ['campo', 'campoDeBusca', 'interruptor', 'caixaDeSelecao', 'chipDeEntrada',
        'chipDeFiltro', 'dropdown', 'listaDeRadio', 'calendario', 'teclado'],
      'Ação': ['botao', 'barraDeBaixo', 'navFlutuante', 'botaoDeIcone', 'cartaoDeAcesso'],
      'Ritmo': ['ritmo', 'divisor', 'grade'],
    },
    tema: (filho, {required escuro}) => DilettaThemeScope(
      theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
      child: filho,
    ),
    spacingTokens: const {
      's1': DilettaSpacing.s1,
      's2': DilettaSpacing.s2,
      's3': DilettaSpacing.s3,
      's4': DilettaSpacing.s4,
      's5': DilettaSpacing.s5,
      's6': DilettaSpacing.s6,
      's8': DilettaSpacing.s8,
      's10': DilettaSpacing.s10,
      's12': DilettaSpacing.s12,
    },
    // O editor oferece TODOS os ícones do DS, não uma lista à mão.
    icones: DilettaIcons.all,
    icone: _desenhaIcone,
    // Papéis da FERRAMENTA (os 12 de `kPapeisDeIcone`), mapeados pra glifos do DS.
    // Papel e não nome de ícone: a barra do board precisa de "editar", e qual glifo
    // representa editar é decisão do DS.
    papeisDeIcone: const {
      'editar': DilettaIcons.penToSquareLight,
      'ver': DilettaIcons.eyeLight,
      'ocultar': DilettaIcons.eyeSlashLightFull,
      'proximo': DilettaIcons.arrowRightLight,
      'anterior': DilettaIcons.arrowLeftLight,
      'avancar': DilettaIcons.angleRightLight,
      'salvar': DilettaIcons.arrowUpFromBracketLight,
      'baixar': DilettaIcons.arrowDownToBracketLight,
      'nota': DilettaIcons.clipboardListCheckLight,
      'spec': DilettaIcons.fileLight,
      'pronto': DilettaIcons.checkLight,
      'subir': DilettaIcons.arrowUpLight,
      // Os seis que a v0.28.0 do motor acrescentou. A razão dele importa: a barra virou de
      // ÍCONE — play, sol, lua e o modo dev perderam o rótulo escrito, então papel sem glifo
      // deixou de ser "perde leitura rápida" e passou a ser botão vazio.
      'reproduzir': DilettaIcons.playSolidFull,
      'claro': DilettaIcons.sunLight,
      'escuro': DilettaIcons.moonStarsLight,
      'codigo': DilettaIcons.codeLight,
      'fechar': DilettaIcons.xmarkLight,
      'setas': DilettaIcons.arrowRightArrowLeftLight,
    },
    tiposDeAcao: const {'botao', 'barraDeBaixo'},
    // QUEM DISPARA A SAÍDA de uma tela, em ordem de hierarquia de ação — e este gancho estava VAZIO.
    //
    // O custo apareceu no board antes de eu medir: as três setas do fluxo de Pix mostravam
    // **"gatilho não documentado"** em vermelho. Com a lista vazia o motor não tem como ancorar a seta
    // num componente, então ela sai da borda do frame e o rótulo denuncia a falta — que é degradação
    // honesta do motor, e era falta MINHA.
    //
    // É lista de CRITÉRIOS e não de tipos porque o rótulo mora em prop diferente em cada peça: na barra
    // ele é o `label` do botão de dentro, e na linha de lista é o `titulo`. A ordem é a que
    // `gatilhoPrincipalDe` usa — barra primeiro, porque a ação ancorada do rodapé é a saída principal de
    // toda tela de fluxo deste produto; a linha por último, porque ela é a saída das telas de MENU (a
    // home sai pelo item "Pix", não por CTA).
    gatilhosDeSaida: [
      (b) => b.type == 'barraDeBaixo' ? '${b.props['label'] ?? 'Continuar'}' : null,
      (b) => b.type == 'botao' ? '${b.props['label'] ?? 'Botão'}' : null,
      (b) => b.type == 'cartaoDeAcesso' ? '${b.props['label'] ?? 'Acesso rápido'}' : null,
      (b) => b.type == 'linha' ? '${b.props['titulo'] ?? 'Linha'}' : null,
      // O LADRILHO e o CARTÃO DO PEDIDO, das telas de loja. O ladrilho é a saída das telas de menu
      // — a home sai por "Área Pix" e a Área Pix sai por "Transferir" —, e o cartão de pedido sai
      // pelas duas ações que ele carrega dentro. Ficam por último pela mesma razão da linha: eles
      // são saída de tela de MENU e de fila, não CTA ancorado de fluxo.
      (b) => b.type == 'ladrilhoDeMenu' ? '${b.props['rotulo'] ?? 'Atalho'}' : null,
      // A LINHA DE VALOR é a saída do extrato: tocar um lançamento abre o detalhe dele. Ela ficou de
      // fora até o extrato existir como tela — o gate `toda tela tem gatilho de saída` foi quem
      // cobrou, e ele cobrou certo: uma tela que não leva a lugar nenhum é uma tela sem seta.
      (b) => b.type == 'linhaDeValor' ? '${b.props['titulo'] ?? 'Lançamento'}' : null,
      (b) => b.type == 'cartaoDePedido'
          ? (b.props['jaAprovei'] == true ? 'Ver pedido' : 'Aprovar')
          : null,
    ],
    acaoInterativa: _acaoInterativa,
    tiposDeChromeDeDispositivo: const {'barraDeStatus', 'indicadorDeHome'},
    // O visor é overlay de tela cheia: sem isto o motor daria a ele o padding e o scroll do
    // frame, e o retículo apareceria deslocado do centro da câmera.
    // TELA CHEIA: quem é OVERLAY. O visor é retículo de câmera; a folha e o diálogo cobrem a tela com
    // scrim. Sem isto o card do catálogo os põe numa coluna de scroll — e a folha, que devolve um
    // `Positioned`, estoura com "Incorrect use of ParentDataWidget" (achado pelo gate de layout).
    tiposDeTelaCheia: const {'visorDeCodigo', 'folha', 'dialogo'},
    barraDeStatus: () => const DilettaStatusBar(),
    inspetor: (filho, {required ligado}) =>
        DilettaDevMode(enabled: ligado, child: filho),
    // O BACKDROP inteiro entra no frame, e são os sete fundos — não só a cor.
    //
    // O `fundoDoFrame` é o gancho que este filho pediu (v0.28.0 do motor) porque `fundoDaTela`
    // devolve `Color?` e um dos sete fundos do produto cabia em cor. O motor pinta este widget
    // em `Positioned.fill` dentro do clip do frame, sob o conteúdo.
    //
    // `SizedBox.expand` como filho porque aqui o backdrop é só fundo: o conteúdo da tela é
    // desenhado pelo motor por cima, não por dentro dele.
    // A ARTE entra pelo SCOPE, que é o contrato do componente: ele não crava caminho de asset, e sem
    // scope o mood `imagem` degrada pro tema com brilho. O catálogo não declarava nada, então o fundo da
    // HOME — 114 usos, o componente mais usado do produto — aparecia sem cidade.
    //
    // A arte é DEMO deste catálogo (cópia reduzida da do app), e está declarada como tal no `pubspec`.
    fundoDoFrame: (ctx) => CoreflowBackdropScope(
      // `estilo` é obrigatório no scope: ele é a personalização que o app faz uma vez. `imagem` é o
      // default do produto e é o fundo da home.
      // O FUNDO É POR TELA, e quem diz qual tela é o `TelaEmFoco` do motor (v0.94.0). A regra e o
      // mapa moram com as telas, não aqui: o plugue sabe DESENHAR fundo, e o registro sabe qual.
      estilo: fundoDaTela(TelaEmFoco.de(ctx)),
      arteClara: const AssetImage('assets/demo/cidade-claro.jpg'),
      arteEscura: const AssetImage('assets/demo/cidade-escuro.jpg'),
      child: const CoreflowBackground(child: SizedBox.expand()),
    ),
    // Fica declarado também: o motor usa o `Color?` quando o widget está ausente, e é o que
    // pinta a cor por trás do próprio backdrop.
    fundoDaTela: (ctx) {
      final s = DilettaTheme.schemeOf(ctx);
      return s.isDark ? BoldPalette.bold.bgEscuro : BoldPalette.bold.primary08;
    },
    superficieDaTela: (ctx) => DilettaTheme.schemeOf(ctx).surface,
    // `margensDoConteudo` (motor v0.83.0) fica NULO de propósito, e o número está medido.
    //
    // O default do gancho é `(lateral: 20, acimaDaCamadaDeBaixo: 8)`, e a grade deste produto é
    // `BoldSpace.x5` = `DilettaSpacing.s5` = **20** — o `///` do app é explícito (*"20 — gutter lateral
    // padrão das telas"*), e é o valor mais usado nas telas dele (10 sítios contra 5 do x6). O motor
    // cravou a grade de um filho e acertou a minha; declarar 20 aqui seria repetir o default pra dizer a
    // mesma coisa.
    //
    // A folga de BAIXO (8) eu não medi — não tenho tela deste produto com conteúdo ancorado no fundo
    // contra a barra, que é o caso em que ela aparece. Declarar sem medir é o que a assimetria do pai
    // existe pra evitar: **ele só abriu o campo que alguém tinha medido.**
    // No claro a tela declara o próprio fundo; no escuro o tema manda, senão cada tela
    // precisaria declarar duas cores.
    fundoImpostoPeloTema: (ctx) {
      final s = DilettaTheme.schemeOf(ctx);
      return s.isDark ? s.bg : null;
    },
    // OS FUNDAMENTOS (v0.43.0 do motor) — a prosa que ENSINA, e a segunda página minha que ele apaga.
    //
    // A do pai viaja no pacote dele (`kDilettaLinguagem`), então o catálogo plunga a linguagem inteira
    // sem copiar uma linha — e copiar era o que faria a prosa envelhecer em dois lugares. As quatro
    // seções deste produto (paleta, gradientes, vidro, tipografia) são as decisões que eu tomei medindo,
    // com os números que as sustentam.
    fundamentos: const {
      'A linguagem (do pai)': kDilettaLinguagem,
      ...kBoldFundamentos,
    },
    // O INVENTÁRIO DE ESTILO (v0.39.0 do motor) — e a aba de Styles deixa de ser escrita à mão.
    //
    // Eu tinha escrito a minha, com tipografia, gradiente e vidro. O motor passou a entregar a página
    // derivada deste inventário, então a minha saiu: **peça que o pai entrega, o filho não reescreve** —
    // é a regra que este repo cobra dos outros e que valia pra mim.
    //
    // O que ficou em Fundamentos é o que o próprio pai diz que é de lá: a DECISÃO (rampa com razão,
    // papéis nos dois modos, os dois gradientes modulados, a receita do vidro, o relatório de adoção).
    // Styles é o inventário que se CONSULTA; Fundamentos é o que se lê uma vez.
    //
    // O movimento entra porque a página TOCA: tabela de duração não é motion — 300ms com `easeOut` e
    // 300ms com `elasticOut` têm a mesma linha na tabela e são coisas diferentes na tela.
    estilos: InventarioDeEstilo(
      cores: _coresDaMarca(),
      // PAPEL SEMÂNTICO (v0.53.0) — e esta seção era MINHA até agora.
      //
      // Eu escrevia as faixas claro/escuro à mão em `styles_do_bold.dart`, e o pai mediu que cada filho
      // tinha metade da página: eu tinha faixa + hex e não tinha significado nem a amostra. As quatro
      // andam juntas agora, então a minha seção saiu — quinta página deste catálogo que um release apaga.
      //
      // Os 21 papéis são os que aparecem em componente deste produto, e não os 53 de cor do esquema
      // (contados por CAMPO em 2026-08-06; eu já disse 17, ~51 e 39 aqui — o 39 saiu de um regex que
      // contava LINHA de declaração): lista longa em catálogo é lista que ninguém lê. Cada um lê `DilettaScheme.light/dark(BoldPalette.bold)`, então
      // valor errado aqui é impossível — não há número digitado.
      papeis: _papeisDoBold(),
      amostraDePapeis: const AmostraDePapeis(
        fundo: 'bg',
        superficie: 'surface',
        texto: 'fg',
        textoSecundario: 'textSecondary',
        primaria: 'primary',
        sobrePrimaria: 'onPrimary',
      ),
      // O USO DE CADA TOKEN (v0.54.0). Sai da prosa que já existia em `kBoldFundamentos` — não é texto
      // novo, é texto que estava numa página e não chegava no degrau que ele descreve.
      descricoesDeToken: const {
        'espaco.s2': 'Respiro mínimo — entre rótulo e campo, entre ícone e texto.',
        'espaco.s3': 'Entre itens de uma mesma lista.',
        'espaco.s4': 'O gap de trabalho: entre campos, padding interno de card.',
        'espaco.s6': 'Entre blocos de uma tela.',
        'espaco.s8': 'Entre seções — o maior respiro que uma tela de telefone aguenta.',
        'tipografia.displaySm': 'O saldo. É o único lugar deste produto com voz de display.',
        'tipografia.headlineLg': 'Título de tela cheia — comprovante, autorização.',
        'tipografia.headlineSm': 'Título de folha e de diálogo.',
        'tipografia.titleMd': 'Título de card e de seção dentro do conteúdo.',
        'tipografia.subheading': 'Rótulo de controle: aba, segmento, botão.',
        'tipografia.bodyMd': 'O corpo. Tudo que se lê em parágrafo.',
        'tipografia.bodySm': 'Apoio: subtítulo de linha, ajuda de campo.',
        'tipografia.label': 'Rótulo de campo e chave de linha de valor.',
        'tipografia.labelSm': 'Sobrescrito de seção e legenda.',
        'tipografia.numeric': 'Dígito que ALINHA em coluna — valor de extrato, código, relógio. '
            'Não é um título pequeno: é outra categoria de voz.',
        'forma.all8': 'Controle pequeno: chip, selo, campo.',
        'forma.all16': 'Card e folha.',
        'forma.all24': 'Superfície grande — o topo de uma folha de tela cheia.',
        'forma.pillAll': 'Pílula: botão, segmento, avatar.',
      },
      // O GRUPO (v0.54.0) — 51 valores em fileira contínua é parede, e a frase é do pai.
      gruposDeToken: const {
        'tipografia': [
          GrupoDeToken('TÍTULOS', ['displaySm', 'headlineLg', 'headlineSm', 'titleMd'],
              descricao: 'Hierarquia de tela. Uma por nível, e nenhuma repete o nível de cima.'),
          GrupoDeToken('CORPO', ['bodyMd', 'bodySm'],
              descricao: 'O que se lê em parágrafo.'),
          GrupoDeToken('UTILITÁRIAS', ['subheading', 'label', 'labelSm', 'numeric'],
              descricao: 'Rótulo, controle e dígito. `numeric` é voz própria, não título pequeno.'),
        ],
      },
      tipos: const {
        'displaySm': DilettaType.displaySm,
        'headlineLg': DilettaType.headlineLg,
        'headlineSm': DilettaType.headlineSm,
        'titleMd': DilettaType.titleMd,
        'subheading': DilettaType.subheading,
        'bodyMd': DilettaType.bodyMd,
        'bodySm': DilettaType.bodySm,
        'label': DilettaType.label,
        'labelSm': DilettaType.labelSm,
        'numeric': DilettaType.numeric,
      },
      raios: {
        'all8': DilettaRadius.all8.topLeft.x,
        'all16': DilettaRadius.all16.topLeft.x,
        'all24': DilettaRadius.all24.topLeft.x,
        'pillAll': DilettaRadius.pillAll.topLeft.x,
      },
      movimentos: const {
        'micro (120ms)': MotionDaTransicao(
            duracao: DilettaMotion.micro, curva: DilettaMotion.enter, token: 'DilettaMotion.micro',
            descricao: 'hover e troca de cor'),
        'short (150ms)': MotionDaTransicao(
            duracao: DilettaMotion.short, curva: DilettaMotion.enter, token: 'DilettaMotion.short',
            descricao: 'pastilha do segmento, thumb do interruptor'),
        'medium (250ms)': MotionDaTransicao(
            duracao: DilettaMotion.medium, curva: DilettaMotion.enter, token: 'DilettaMotion.medium',
            descricao: 'folha, toast, ponto de página'),
        'slow (400ms)': MotionDaTransicao(
            duracao: DilettaMotion.slow, curva: DilettaMotion.standard, token: 'DilettaMotion.slow',
            descricao: 'transição de página'),
      },
    ),
    // COMO ESTE DS MOVE CADA TRANSIÇÃO (gancho `motionDaTransicao`).
    //
    // A vista de Gramática (v0.64.0 do motor) mede isto contra as setas dos fluxos, e ela me mostrou o
    // gancho vazio: **oito tipos de conexão, oito "não declarado"**. Eu já tinha os quatro tokens de
    // movimento em `estilos.movimentos` — mas ali eles são INVENTÁRIO (o que existe), e aqui é a
    // correspondência (qual movimento é qual transição). São perguntas diferentes, e eu tinha só a primeira.
    //
    // Declaro TRÊS dos oito, e a razão de parar em três é que os três saem da minha própria descrição de
    // token, palavra por palavra:
    //
    //   slow (400ms)   → "transição de página"        ⇒ push e voltar
    //   medium (250ms) → "folha, toast, ponto de página" ⇒ sheet
    //
    // Os outros cinco (`estado`, `após espera` e os três de chat) eu NÃO declaro, e não é esquecimento:
    // este produto não tem fluxo de chat, e eu não medi qual token move troca de estado. Chutar aqui
    // encheria a página com número que ninguém verificou — e o board mostraria uma prévia tocando um
    // movimento que o app não faz. Quando a primeira seta desses tipos existir, a vista acende em
    // vermelho ("usado sem token") e aí eu tenho o caso medido.
    motionDaTransicao: (tipo) => switch (tipo) {
      TipoConexao.push || TipoConexao.volta => const MotionDaTransicao(
          duracao: DilettaMotion.slow,
          curva: DilettaMotion.standard,
          token: 'DilettaMotion.slow',
          descricao: 'transição de página'),
      TipoConexao.sheet => const MotionDaTransicao(
          duracao: DilettaMotion.medium,
          curva: DilettaMotion.enter,
          token: 'DilettaMotion.medium',
          descricao: 'a folha sobe'),
      // Sem `_ =>` com valor: tipo novo do pai tem que aparecer aqui como falta, e não herdar o
      // movimento da folha por acidente. O motor já trata `null` como "não declarado", que é a verdade.
      _ => const MotionDaTransicao(),
    },
    // OS CONTRATOS (v0.36.0 do motor) — guideline é parte do contrato do COMPONENTE, não do catálogo
    // que o mostra. Pro componente do PAI o markdown vem do pacote dele (`kDilettaSpecs`), e o mapa
    // abaixo é DERIVADO do `ctor` de cada bloco: escrever a correspondência à mão com 56 blocos e 89
    // specs (77 do pai + 12 meus, medido em 2026-08-06) erra, e o sintoma (bloco sem contrato) é
    // indistinguível de spec que não existe.
    contratos: _contratosDosBlocos(blocos),
    // O CONJUNTO DISPONÍVEL (v0.45.0) — sem ele a aba de Specs só mede metade: "bloco sem contrato".
    // Com ele mede a outra ponta, "contrato sem bloco", que **não é dívida** — é o vocabulário que existe
    // e este produto não usou. Um pai com 77 palavras e um filho com 56 blocos tem palavras de sobra, e
    // isso é o normal: o filho pega o que precisa.
    contratosDisponiveis: const {...kDilettaSpecs, ...kBoldSpecs},
    // A VOLTA: sem isto, tela que só existe como código aparece como código, sem preview — e quem
    // monta tela perde a metade que importa, que é abrir o que já existe.
    leCodigoComoSpec: lerTelaDoBold,
    importNoCodigo:
        "import 'package:coreflow_design_system/coreflow_design_system.dart' as ds;",
    nomesNoCodigo: const NomesNoCodigo(
      coluna: 'ds.DilettaFrame.column',
      superficie: 'ds.DilettaSurface',
      superficieDeFolha: 'ds.DilettaSurface.sheet',
      stickyHeader: 'ds.DilettaStickyHeader',
    ),
  ));
}

/// A variável `fundoDaTelaEmFoco` VIVEU AQUI e morreu no mesmo dia, que era o prazo escrito nela.
///
/// Ela era mutável de biblioteca — exatamente o que este repo evita — e existia porque o gancho do
/// motor não sabia qual tela estava desenhando. O `///` dela dizia: *"ela morre no dia em que o
/// gancho receber a tela."* O gancho recebeu (`TelaEmFoco`, motor v0.94.0), e o veredito registrou o
/// que isso ensina: **escrever o prazo na dívida foi o que impediu ela de virar paisagem.**
///
/// Fica esta lápide no lugar dela, porque a próxima dívida temporária precisa saber que a anterior
/// foi cobrada.

// ═══════════════════════════════════════════════════════════════════════════════
// 3 · OS AUXILIARES
// ═══════════════════════════════════════════════════════════════════════════════

/// O motor pede um ícone por NOME; este DS resolve qual arquivo é.
///
/// Aceita as duas formas, e isso não é conveniência: é a armadilha medida no primeiro
/// filho. `DilettaIcons.all` mapeia CHAVE camelCase → NOME DE ARQUIVO (`angleDownLight`
/// → `angle-down-light`), e `papeisDeIcone` guarda o ARQUIVO como valor, porque
/// `DilettaIcons.penToSquareLight` já É o arquivo. Traduzir duas vezes derruba tudo no
/// fallback, e o resultado foi doze papéis desenhando o mesmo boneco — que passa por
/// decisão de design, porque ícone errado parece intencional.
///
/// Sem fallback de propósito: nome desconhecido falha no `assert` em debug e não desenha
/// em release. Ausência é visível; mentira uniforme não.
Widget _desenhaIcone(String nome, {double tamanho = 16, Color? cor}) {
  final arquivo = DilettaIcons.all[nome] ?? nome;
  assert(
    DilettaIcons.all.containsValue(arquivo),
    'ícone desconhecido: "$nome". Passe a chave (`angleDownLight`) ou o arquivo '
    '(`angle-down-light`) — os dois estão em DilettaIcons.all.',
  );
  return DilettaIcon(name: arquivo, size: tamanho, color: cor);
}

/// CTA com `onPressed` de verdade, pro preview de fluxo andar.
///
/// `build` desenha o componente como ele é — inclusive sem toque. Quem sabe injetar o
/// gesto sem mudar a aparência é o DS.
Widget _acaoInterativa(Block b, VoidCallback aoTocar, {required bool ultima}) {
  final props = {...b.props, 'label': ultima ? 'Reiniciar fluxo' : '${b.props['label']}'};
  return b.type == 'barraDeBaixo'
      ? _barraDeBaixoWidget(props, aoTocar: aoTocar)
      : _botaoWidget(props, aoTocar: aoTocar);
}

/// Os nomes de ilustração do pai, derivados do registro dele.
///
/// Derivado e não escrito à mão porque lista à mão DRIFOU: no primeiro filho o
/// vocabulário do catálogo tinha metade das artes (16 de 32), e duas telas pediam
/// ilustração que ele não conhecia — renderizavam vazias, sem erro nenhum.
final List<String> _nomesDeIlustracao =
    DilettaIllustration.all.map((i) => i.nome).toList();

/// A arte do cartão promocional, no degrau `sm` (100) — que é o quadrado que o componente reserva.
///
/// O app pede 88 e o degrau mais próximo é o 100. Oitenta e oito não é degrau, e a diferença de 12 num
/// quadrado de arte não é vista; degrau fora da escada é.
Widget _arteDoCartao(Object? nome) => DilettaIllustrationAccessory(
      illustration: _ilustracaoDe('$nome'),
      size: DilettaIllustrationSize.sm,
    );

DilettaIllustration _ilustracaoDe(String nome) =>
    DilettaIllustration.all.firstWhere((i) => i.nome == nome);

double _espaco(String token) => _daOpcao(token, const {
      's2': DilettaSpacing.s2,
      's3': DilettaSpacing.s3,
      's4': DilettaSpacing.s4,
      's6': DilettaSpacing.s6,
      's8': DilettaSpacing.s8,
    }, DilettaSpacing.s4);

/// `tipo do bloco → markdown da spec`, derivado do construtor.
///
/// `ds.DilettaIconButton` → `design-system-icon-button` no `kDilettaSpecs` do pai. Bloco de componente
/// nascido AQUI não tem spec do pai e fica de fora — e o cabeçalho degrada pro nome, que é a regra do
/// motor: ausência degrada, não quebra.
///
/// Derivado e não escrito: com 56 blocos e 89 specs, tabela à mão erra e o sintoma (bloco sem contrato)
/// é indistinguível de spec que não existe.
///
/// Os componentes NASCIDOS aqui ainda não têm contrato escrito, e essa dívida é minha: o
/// `COMPONENTE-DO-FILHO.md` do pai passou a pedir contrato como parte do mínimo na v0.16.1.
Map<String, String> _contratosDosBlocos(Map<String, BlockDef> blocos) {
  final mapa = <String, String>{};
  for (final def in blocos.values) {
    final ctor = def.ctor;
    if (ctor == null || !ctor.contains('Diletta')) continue;
    final classe =
        ctor.split('.').firstWhere((p) => p.startsWith('Diletta'), orElse: () => '');
    if (classe.isEmpty) continue;
    final kebab = classe
        .replaceFirst('Diletta', '')
        .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '-${m.group(0)!.toLowerCase()}')
        .replaceFirst(RegExp(r'^-'), '');
    final md = kDilettaSpecs['design-system-$kebab'];
    if (md != null) mapa[def.type] = md;
  }
  // OS CONTRATOS DESTE FILHO: os 12 componentes nascidos aqui, escritos no pacote do DS. O pai não tem
  // como saber deles — `contratos` é `tipo → markdown`, e o markdown do que é meu vem de mim.
  // Filtra sem MUTAR: `kBoldSpecs` é `const`, e `..removeWhere` nele estoura com "cannot modify
  // unmodifiable map" — na carga do teste, antes de qualquer asserção. Cascata em const é armadilha
  // silenciosa até não ser.
  for (final e in kBoldSpecs.entries) {
    if (blocos.containsKey(e.key)) mapa[e.key] = e.value;
  }

  // As EXCEÇÕES, e cada uma tem razão: a convenção classe→slug não cobre quem não é 1:1.
  //
  // A row e a coleção do pai compartilham UMA spec (`app-list`), e é correto — o contrato dele fala da
  // coleção e da linha juntas, porque a coleção é dona do separador. Já `barraDeBaixo` e
  // `indicadorDeHome` não têm `ctor` (o primeiro aninha três níveis, o segundo é chrome de aparelho),
  // então a derivação não os alcança.
  const excecoes = {
    // `DilettaIllustrationAccessory` → a spec é da ILUSTRAÇÃO (`design-system-illustration`, que o pai
    // escreveu na v0.17.0): o acessório é o invólucro de tamanho, e o contrato é da arte.
    'ilustracao': 'design-system-illustration',
    // A casca de topo não tem `ctor` (aninha três níveis), então a derivação não a alcança.
    'cascaDeTopo': 'design-system-top-app-bar',
    'lista': 'design-system-app-list',
    'linha': 'design-system-app-list',
    'linhaDeValor': 'design-system-app-list',
    // A linha de escolha entra na mesma spec pela mesma razão das outras duas: ela é composição de
    // acessórios do PAI (o que muda é a direita, check em vez de seta), e o contrato dele fala da
    // coleção e da linha juntas. Peça deste filho ela não é — nada de novo foi desenhado.
    'linhaDeEscolha': 'design-system-app-list',
    'barraDeBaixo': 'design-system-bottom-app',
    'indicadorDeHome': 'design-system-bottom-home-indicator',
    // O divisor perdeu o `ctor` quando virou UNIÃO de três formas (`DilettaDivider`,
    // `.dashed()`, `.vertical()` dentro de um `SizedBox`): construtor nomeado e aninhamento não caem
    // numa tabela de um `ctor` só. O contrato é o mesmo — a spec do pai fala das três.
    'divisor': 'design-system-divider',
    // O esqueleto perdeu o `ctor` quando virou PAR (`Shimmer(child: Skeleton)`), porque a forma do pai
    // não anima sozinha. O contrato continua sendo o dele — a spec do pai fala das duas peças juntas.
    'esqueleto': 'design-system-skeleton',
  };
  excecoes.forEach((tipo, slug) {
    if (!blocos.containsKey(tipo)) return;
    final md = kDilettaSpecs[slug];
    if (md != null) mapa[tipo] = md;
  });
  return mapa;
}

/// As cores da marca como inventário: nome do token → cor.
///
/// Só as RAMPAS, e não os 53 papéis de cor do esquema: papel é derivado e muda com o modo, então mostrá-lo numa lista sem
/// dizer o modo é meia informação. Papel nos dois modos é Fundamentos, que é a página da decisão.
Map<String, Color> _coresDaMarca() {
  const p = BoldPalette.bold;
  return {
    'primary01': p.primary01, 'primary02': p.primary02, 'primary03': p.primary03,
    'primary04': p.primary04, 'primary05': p.primary05, 'primary06': p.primary06,
    'primary07': p.primary07, 'primary08': p.primary08, 'primary09': p.primary09,
    'success03': p.success03, 'success04': p.success04,
    'warning03': p.warning03, 'warning04': p.warning04,
    'error03': p.error03, 'error04': p.error04,
    'vinho.marca': BoldVinho.marca, 'vinho.ink': BoldVinho.ink,
    'neutral01': p.neutral01, 'neutral05': p.neutral05, 'neutral10': p.neutral10,
    // OS ONZE QUE FALTAVAM, e eles não são gosto: são as entradas pra onde a ORIGEM dos papéis
    // aponta. A checagem `alias-fantasma` do motor (v0.104.0) achou na primeira execução — a página
    // dizia *"`bg` é alias de `white`"* e `white` não estava em lugar nenhum dela.
    //
    // **Link morto numa página de referência é pior que ausência**: quem lê `alias: neutral09`
    // procura o degrau, não acha, e conclui que a rampa é outra. A lista era curta porque eu
    // escolhi por "quais eu uso em componente"; a origem mudou o critério — publicar é obrigação de
    // quem declara alias.
    'white': p.white,
    'neutral02': p.neutral02, 'neutral07': p.neutral07,
    'neutral08': p.neutral08, 'neutral09': p.neutral09,
    'success02': p.success02, 'success05': p.success05,
    'success06': p.success06, 'success07': p.success07,
    'warning05': p.warning05, 'error05': p.error05,
  };
}

bool _vazio(Object? v) => v == null || '$v'.isEmpty;

/// Um enum do pai como mapa nome → valor, pra casar com o que a prop guarda (String).
///
/// Derivado de `values` e não escrito à mão: enum que ganha membro no pai aparece aqui sozinho, e
/// membro que ele remove vira erro de compilação em vez de opção fantasma no editor.
/// OS 21 PAPÉIS que um componente deste produto lê, nos dois modos — e o PAR de tinta onde ele existe.
///
/// `tinta` é o nome do papel usado como texto/ícone em cima deste, e declarar habilita a medição de
/// contraste do pai (WCAG 2.2 SC 1.4.3). Declarado e não adivinhado por nome, que é a regra que o pai
/// escreveu: **convenção não é contrato.**
///
/// ## O par que importava REPROVAVA, e o conserto veio da tinta
///
/// A medição foi a primeira coisa que este gancho me deu, e ela virou pedido no mesmo dia:
///
/// | par | antes (claro) | antes (escuro) | agora |
/// |---|---|---|---|
/// | `primary` × `onPrimary` | **3,46:1** ✕ | **2,73:1** ✕✕ | **6,06** e **7,70** ✓ |
///
/// O conserto é do pai (`ds-diletta` v0.22.0) e não foi pelo caminho que eu propus. Eu pedi que a paleta
/// declarasse o degrau de AÇÃO por modo; ele derivou a **TINTA** em vez do preenchimento, com o argumento
/// que eu não tinha: *razão-com-branco × razão-com-preto ≈ 21 pra qualquer cor*, então quando o branco
/// reprova existe tinta escura que passa — **sem mexer no rosa da marca.**
///
/// > **Tinta é consequência de legibilidade; preenchimento é decisão de marca.**
///
/// E a medição dele mostrou que o caso não era meu: **dois de três** produtos da família reprovavam (o rosa
/// daqui e o âmbar de referência), o que fez a correção subir pra linguagem em vez de virar exceção deste
/// filho.
///
/// ## Três pares que eu declarei e o DS não desenha
///
/// `success`/`warning`/`error` × `onX` ficaram SEM `tinta:`, e a razão é a medição que o pai fez a meu
/// pedido: `onWarning`, `onError` e `onSuccess` têm **zero consumidores** no `lib/src` dele. Eu tinha
/// declarado um par que ninguém pinta, e o resultado eram três ✕ na página sobre desenho que não existe —
/// o falso positivo permanente que ensina a ignorar o vermelho.
///
/// Quem recebe texto em cima é o `subtle` de cada estado, e esses três passam (5,19 · 6,09 · 6,05).
/// Atalho pro gate medir a proporção alias/derivado sem passar pelo plugue.
Map<String, PapelNosDoisModos> papeisDoBoldParaMedir() => _papeisDoBold();

Map<String, PapelNosDoisModos> _papeisDoBold() {
  final c = DilettaScheme.light(BoldPalette.bold);
  final e = DilettaScheme.dark(BoldPalette.bold);
  PapelNosDoisModos p(
    Color Function(DilettaScheme) ler, {
    String? significado,
    String? tinta,
  }) =>
      PapelNosDoisModos(ler(c), ler(e), significado: significado, tinta: tinta);

  /// A ORIGEM de cada papel — alias ou derivação —, e ela vem do pai.
  ///
  /// A pergunta que a página de Styles fazia sem responder: alguém vê `bg` com um hex ao lado e não
  /// sabe **se pode trocá-lo**. Metade dos papéis é uma entrada da minha paleta (troca a entrada e o
  /// papel segue); a outra metade é uma conta do pai que existe justamente pra ninguém escolher.
  ///
  /// A frase do aviso é a régua: **alias é porta, derivação é parede.** Mostrar as duas iguais
  /// convida alguém a trocar `white` esperando mover a tinta de `onPrimary`.
  ({String? alias, String? derivacao})? origem(String papel, {required bool escuro}) {
    final o = origemDoPapel(papel, escuro: escuro);
    return o == null ? null : (alias: o.alias, derivacao: o.derivacao);
  }

  final base = {
    'bg': p((s) => s.bg, significado: 'Fundo geral da tela (scaffold).', tinta: 'fg'),
    'surface': p((s) => s.surface, significado: 'Card, folha, diálogo.', tinta: 'fg'),
    'surfaceMuted': p((s) => s.surfaceMuted,
        significado: 'Trilho e campo — a superfície que afunda.', tinta: 'fg'),
    'fg': p((s) => s.fg, significado: 'Texto principal.'),
    'textSecondary': p((s) => s.textSecondary, significado: 'Apoio, ajuda, chave de linha.'),
    'border': p((s) => s.border, significado: 'Traço de card e de campo.'),
    'divider': p((s) => s.divider, significado: 'Separador dentro de uma coleção.'),
    'primary': p((s) => s.primary,
        significado: 'Ação primária, link, foco. É o rosa da marca.', tinta: 'onPrimary'),
    'onPrimary': p((s) => s.onPrimary, significado: 'Tinta sobre a ação primária.'),
    'primarySubtle': p((s) => s.primarySubtle,
        significado: 'Fundo de destaque da marca — pastilha, degrau de alçada.',
        tinta: 'onPrimarySubtle'),
    'onPrimarySubtle': p((s) => s.onPrimarySubtle, significado: 'Tinta sobre o destaque da marca.'),
    'primaryTrack': p((s) => s.primaryTrack, significado: 'Traço e trilho no tom da marca.'),
    'success': p((s) => s.success, significado: 'Concluído, aprovado.'),
    // As três tintas de estado seguem DECLARADAS como papel (elas existem no esquema e alguém pode
    // procurá-las), mas nenhum estado as aponta em `tinta:` — ver a nota acima. O achado que sobrou dessa
    // volta é do pai e está no anexo do pedido: `tinta:` apontando pra papel inexistente vira `null`, e
    // `null` quer dizer "sem medição" — eu passei dez minutos com as três faixas sem contraste e nada
    // falhando.
    'onSuccess': p((s) => s.onSuccess, significado: 'Tinta sobre o estado concluído (não usada hoje).'),
    'onWarning': p((s) => s.onWarning, significado: 'Tinta sobre o estado pendente (não usada hoje).'),
    'onError': p((s) => s.onError, significado: 'Tinta sobre o estado de falha (não usada hoje).'),
    'successSubtle': p((s) => s.successSubtle,
        significado: 'Fundo de estado concluído.', tinta: 'onSuccessSubtle'),
    'onSuccessSubtle': p((s) => s.onSuccessSubtle, significado: 'Tinta sobre o fundo concluído.'),
    'warning': p((s) => s.warning, significado: 'Pendente, atenção.'),
    'error': p((s) => s.error, significado: 'Falha, destrutivo.'),
    'glassTint': p((s) => s.glassTint, significado: 'O véu do vidro — é a única cor com alfa.'),
  };

  // O `p(...)` recebe VALORES e não o nome do papel, então mudar a assinatura dele custaria ~50
  // chamadas. O motor ganhou `comOrigem` pra a ligação ser uma passada no mapa já montado — o aviso
  // do pai diz isso com todas as letras, e é a diferença entre cinco linhas e uma tarde.
  return base.map((papel, v) => MapEntry(
      papel,
      v.comOrigem(
          clara: origem(papel, escuro: false),
          escura: origem(papel, escuro: true))));
}

Map<String, T> _porNome<T extends Enum>(List<T> valores) =>
    {for (final v in valores) v.name: v};

/// Traduz o valor de uma prop de ENUM (que chega como String) no membro do DS.
///
/// Existe pra matar o `_ =>` das quatro traduções que havia aqui, e a razão é a que a auditoria de
/// arquitetura cobra: **default silencioso faz opção nova se disfarçar de opção antiga.** As opções são
/// declaradas em `PropDef.options`, então valor fora do mapa é erro de declaração — falha no `assert`
/// em debug, e em release cai no [padrao] em vez de deixar o bloco sem desenhar.
///
/// A lição vem do ícone: sem o `assert`, doze papéis desenharam o mesmo boneco e passou por decisão de
/// design.
T _daOpcao<T>(Object? valor, Map<String, T> opcoes, T padrao) {
  final achado = opcoes['$valor'];
  assert(
    achado != null || '$valor' == 'null',
    'valor fora das opções declaradas: "$valor" (conhecidas: ${opcoes.keys.join(', ')})',
  );
  return achado ?? padrao;
}

/// Literal Dart de uma string, ou o IDENTIFICADOR quando a prop está vinculada a um
/// campo da tela gerada. Sem isto, uma prop vinculada sairia como `'nomeDoCampo'` — uma
/// string com o nome da variável, que compila e mostra o texto errado.
String _str(Object? v) => v is BoundRef
    ? v.field
    // `\$` ESCAPADO, e isto é o achado do gate de compilação: `'R\$ 1.240,00'` em Dart é tentativa de
    // interpolação (`\$ ` não é identificador), então toda string de dinheiro emitida virava erro de
    // sintaxe. Num produto bancário isso é o literal mais comum que existe. O motor tem o mesmo furo no
    // `_escapa` dele — pedido escrito.
    : "'${v.toString().replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$')}'";
