/// O PLUGUE DO DS — o vocabulário do Conta BOLD para o motor do catálogo.
///
/// O motor não conhece componente nenhum: ele conhece `BlockDef`. Quem sabe quais
/// componentes existem, quais props aceitam e como se compõem é o DS — então é o DS que
/// entrega isto, e **declarar é publicar**: bloco novo aqui aparece no catálogo sem
/// ninguém tocar no catálogo.
///
/// ## Escopo desta primeira versão, dito claro
///
/// São 12 blocos, não os 100 componentes da linguagem. A escolha é deliberada: este
/// arquivo é o contrato entre duas coisas que ainda estão se conhecendo, e um vocabulário
/// pequeno e CERTO vale mais que 100 entradas escritas às cegas — cada `BlockDef` carrega
/// props, defaults, render e codegen, e errar o codegen produz código que compila e não
/// usa o design system, que é o furo mais perigoso do plugue porque nada falha.
///
/// Os 12 cobrem a gramática de uma tela de verdade do Bold: barra, título, texto, ação,
/// campo, valor, selo, aviso, ritmo, divisor, ícone e barra de baixo. O resto entra por
/// medição, tela a tela.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/widgets.dart';

import 'leitor_do_bold.dart';

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
      label: 'Título da página',
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

BlockDef _botao() => BlockDef(
      type: 'botao',
      acoes: const {'onPressed': 'aoContinuar'},
      ctor: 'ds.DilettaButton',
      args: const {'label': Arg.texto('label'), 'tipo': Arg.enumeracao('type', 'ds.DilettaButtonType'), 'tamanho': Arg.enumeracao('size', 'ds.DilettaButtonSize'), 'larguraTotal': Arg.bool('fullWidth')},
      label: 'Botão',
      props: const {
        'label': PropDef('text', bindable: true, dartType: 'String'),
        'tipo': PropDef('enum', options: ['primary', 'secondary', 'tertiary']),
        'tamanho': PropDef('enum', options: ['lg', 'md', 'sm']),
        'larguraTotal': PropDef('bool'),
      },
      defaults: () =>
          {'label': 'Continuar', 'tipo': 'primary', 'tamanho': 'lg', 'larguraTotal': true},
      build: (p) => _botaoWidget(p, aoTocar: null),
      codegen: (p) => 'ds.DilettaButton(label: ${_str(p['label'])}, onPressed: aoContinuar'
          ', type: ds.DilettaButtonType.${p['tipo']}'
          ', size: ds.DilettaButtonSize.${p['tamanho']}'
          '${p['larguraTotal'] == true ? ', fullWidth: true' : ''})',
    );

Widget _botaoWidget(Map<String, dynamic> p, {VoidCallback? aoTocar}) => DilettaButton(
      label: '${p['label']}',
      onPressed: aoTocar ?? () {},
      type: _daOpcao(p['tipo'], const {
        'primary': DilettaButtonType.primary,
        'secondary': DilettaButtonType.secondary,
        'tertiary': DilettaButtonType.tertiary,
      }, DilettaButtonType.primary),
      size: _daOpcao(p['tamanho'], const {
        'lg': DilettaButtonSize.lg,
        'md': DilettaButtonSize.md,
        'sm': DilettaButtonSize.sm,
      }, DilettaButtonSize.lg),
      fullWidth: p['larguraTotal'] == true,
    );

BlockDef _campo() => BlockDef(
      type: 'campo',
      ctor: 'ds.DilettaInput',
      args: const {'rotulo': Arg.texto('label'), 'placeholder': Arg.texto('placeholder'), 'ajuda': Arg.texto('helper'), 'erro': Arg.texto('error'), 'desabilitado': Arg.bool('disabled')},
      label: 'Campo de texto',
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
      label: 'Valor (saldo)',
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

const _tons = ['neutral', 'primary', 'success', 'warning', 'danger', 'secure'];

DilettaStatusTone _tomDe(String t) => _daOpcao(t, const {
      'neutral': DilettaStatusTone.neutral,
      'primary': DilettaStatusTone.primary,
      'success': DilettaStatusTone.success,
      'warning': DilettaStatusTone.warning,
      'danger': DilettaStatusTone.danger,
      'secure': DilettaStatusTone.secure,
    }, DilettaStatusTone.neutral);

BlockDef _selo() => BlockDef(
      type: 'selo',
      ctor: 'ds.DilettaStatusTag',
      args: const {'label': Arg.texto('label'), 'tom': Arg.enumeracao('tone', 'ds.DilettaStatusTone')},
      label: 'Selo de status',
      props: const {
        'label': PropDef('text', bindable: true, dartType: 'String'),
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
      label: 'Aviso com ilustração',
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
      label: 'Espaço',
      props: const {'tamanho': PropDef('spacingToken', options: ['s2', 's3', 's4', 's6', 's8'])},
      defaults: () => {'tamanho': 's4'},
      build: (p) => DilettaGap.h(_espaco('${p['tamanho']}')),
      codegen: (p) => 'ds.DilettaGap.h(ds.DilettaSpacing.${p['tamanho']})',
    );

BlockDef _divisor() => BlockDef(
      type: 'divisor',
      ctor: 'ds.DilettaDivider',
      label: 'Divisor',
      props: const {},
      defaults: () => {},
      build: (p) => const DilettaDivider(),
      codegen: (p) => 'ds.DilettaDivider()',
    );

BlockDef _cabecalhoDeSecao() => BlockDef(
      type: 'cabecalhoDeSecao',
      ctor: 'ds.DilettaSectionHeader',
      args: const {'rotulo': Arg.texto('label')},
      label: 'Cabeçalho de seção',
      props: const {'rotulo': PropDef('text', bindable: true, dartType: 'String')},
      defaults: () => {'rotulo': 'DETALHES'},
      build: (p) => DilettaSectionHeader(label: '${p['rotulo']}'),
      codegen: (p) => 'ds.DilettaSectionHeader(label: ${_str(p['rotulo'])})',
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
      label: 'Linha de menu',
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
BlockDef _linhaDeValor() => BlockDef(
      type: 'linhaDeValor',
      acoes: const {'onTap': 'aoTocarNaLinha'},
      ctor: 'ds.DilettaAppListRow.transactionItem',
      args: const {
        'icone': Arg.enumeracao('icon', 'ds.DilettaIcons'),
        'titulo': Arg.texto('title'),
        'origem': Arg.texto('source'),
        'hora': Arg.texto('time'),
        'valor': Arg.texto('amount'),
        'saida': Arg.bool('negative'),
      },
      label: 'Linha de valor',
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
        'origem': 'Pix enviado',
        'hora': '14:32',
        'valor': 'R\$ 120,00',
        'saida': true,
      },
      build: (p) => DilettaAppListRow.transactionItem(
        icon: DilettaIcons.all['${p['icone']}'] ?? '${p['icone']}',
        title: '${p['titulo']}',
        source: '${p['origem']}',
        time: '${p['hora']}',
        amount: '${p['valor']}',
        negative: p['saida'] == true,
        onTap: () {},
      ),
      codegen: (p) => 'ds.DilettaAppListRow.transactionItem('
          'icon: ds.DilettaIcons.${p['icone']}'
          ', title: ${_str(p['titulo'])}'
          ', source: ${_str(p['origem'])}'
          ', time: ${_str(p['hora'])}'
          ', amount: ${_str(p['valor'])}'
          '${p['saida'] == true ? '' : ', negative: false'}'
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
      label: 'Lista',
      props: const {
        'titulo': PropDef('text'),
        'idioma': PropDef('enum', options: _idiomasDeLista),
      },
      defaults: () => {'titulo': '', 'idioma': 'carded'},
      slots: const {
        'itens': SlotDef(list: true, accepts: ['linha', 'linhaDeValor']),
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
      label: 'Ícone',
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
      label: 'Barra de baixo (CTA)',
      props: const {
        'label': PropDef('text', bindable: true, dartType: 'String'),
        'labelSecundario': PropDef('text'),
      },
      defaults: () => {'label': 'Continuar', 'labelSecundario': ''},
      build: (p) => _barraDeBaixoWidget(p, aoTocar: null),
      // A barra é um CONTAINER: o texto mora no botão de navegação dentro dela. Por isso
      // o codegen aninha em vez de passar `label:` — é a forma que o pai expõe, e
      // aplainar aqui geraria código que não compila no app.
      codegen: (p) => 'ds.DilettaBottomApp.button(button: ds.DilettaNavigationButton('
          'primary: ds.DilettaNavigationAction(label: ${_str(p['label'])}'
          ', onPressed: onContinuar)'
          '${_vazio(p['labelSecundario']) ? '' : ', secondary: ds.DilettaNavigationAction('
              'label: ${_str(p['labelSecundario'])}, onPressed: onVoltar)'}'
          '))',
    );

Widget _barraDeBaixoWidget(Map<String, dynamic> p, {VoidCallback? aoTocar}) =>
    DilettaBottomApp.button(
      button: DilettaNavigationButton(
        primary: DilettaNavigationAction(
          label: '${p['label']}',
          onPressed: aoTocar ?? () {},
        ),
        secondary: _vazio(p['labelSecundario'])
            ? null
            : DilettaNavigationAction(label: '${p['labelSecundario']}', onPressed: () {}),
      ),
    );

/// O selo quântico — o primeiro bloco que vem de um componente NASCIDO no filho, e não da
/// linguagem do pai. Declarar é publicar: ele aparece na paleta do compositor sem ninguém tocar
/// no catálogo.
/// O visor do leitor de código. Bloco de TELA CHEIA: ele é overlay, então no canvas ele ocupa a
/// área inteira em vez de entrar na coluna como um item.
BlockDef _cabecalhoDaHome() => BlockDef(
      type: 'cabecalhoDaHome',
      ctor: 'ds.BoldCabecalhoDaHome',
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
      build: (p) => BoldCabecalhoDaHome(
        nome: '${p['nome']}',
        conta: _vazio(p['conta']) ? null : '${p['conta']}',
        aoAbrirPerfil: () {},
        aoTrocarConta: () {},
        icones: const [
          BoldIconeDoCabecalho(
              icone: DilettaIcons.bellLight, rotulo: 'Notificações', marcador: true),
        ],
      ),
      codegen: (p) => '',
    );

/// O resumo do comprovante. Ele é CONTEÚDO e não tela: o organismo do app era o `Scaffold` inteiro,
/// e bloco que já é a tela não compõe com nada no compositor.
BlockDef _resumoDaTransacao() => BlockDef(
      type: 'resumoDaTransacao',
      ctor: 'ds.BoldResumoDaTransacao',
      args: const {
        'titulo': Arg.texto('titulo'),
        'valor': Arg.texto('valor'),
        'quando': Arg.texto('quando'),
        'estado': Arg.enumeracao('estado', 'ds.BoldEstadoDaTransacao'),
      },
      label: 'Resumo da transação',
      props: {
        'titulo': const PropDef('text', bindable: true, dartType: 'String'),
        'valor': const PropDef('text', bindable: true, dartType: 'String'),
        'quando': const PropDef('text', bindable: true, dartType: 'String'),
        'estado': PropDef('enum',
            options: BoldEstadoDaTransacao.values.map((e) => e.name).toList()),
      },
      defaults: () => {
        'titulo': 'Pix enviado',
        'valor': 'R\$ 120,00',
        'quando': '30 de julho · 14:32',
        'estado': 'concluida',
      },
      build: (p) => BoldResumoDaTransacao(
        titulo: '${p['titulo']}',
        valor: '${p['valor']}',
        quando: '${p['quando']}',
        estado: BoldEstadoDaTransacao.values.firstWhere((e) => e.name == p['estado']),
      ),
      codegen: (p) => 'ds.BoldResumoDaTransacao(titulo: ${_str(p['titulo'])}'
          ', valor: ${_str(p['valor'])}'
          ', quando: ${_str(p['quando'])}'
          ', estado: ds.BoldEstadoDaTransacao.${p['estado']})',
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
      build: (p) => BoldEscadaDeAlcadas(
        degraus: _degraus(p['degraus']),
        densa: p['densa'] == true,
      ),
      codegen: (p) => 'ds.BoldEscadaDeAlcadas(degraus: degrausDaAlcada'
          '${p['densa'] == true ? ', densa: true' : ''})',
    );

/// Uma linha por degrau: `<teto> | <aprovações> [master]`. Teto vazio = faixa terminal.
List<BoldDegrauDeAlcada> _degraus(Object? v) {
  final saida = <BoldDegrauDeAlcada>[];
  for (final linha in '$v'.split('\n')) {
    if (linha.trim().isEmpty) continue;
    final partes = linha.split('|');
    final teto = partes.first.trim();
    final direita = partes.length > 1 ? partes[1].trim() : '0';
    saida.add(BoldDegrauDeAlcada(
      ate: teto.isEmpty ? null : teto,
      aprovacoes: int.tryParse(direita.split(' ').first) ?? 0,
      exigeMaster: direita.contains('master'),
    ));
  }
  return saida;
}

BlockDef _progressoDeAprovacao() => BlockDef(
      type: 'progressoDeAprovacao',
      ctor: 'ds.BoldProgressoDeAprovacao',
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
      build: (p) => BoldProgressoDeAprovacao(
        colhidas: int.tryParse('${p['colhidas']}') ?? 0,
        exigidas: int.tryParse('${p['exigidas']}') ?? 0,
        exigeMaster: p['exigeMaster'] == true,
        compacto: p['compacto'] == true,
      ),
      codegen: (p) => 'ds.BoldProgressoDeAprovacao(colhidas: ${p['colhidas']}'
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
      build: (p) => BoldPrazoDaPendencia(
        restante: _horas(p['horas']),
        idade: _vazio(p['idade']) ? null : '${p['idade']}',
      ),
      codegen: (p) => _horas(p['horas']) == null
          ? 'ds.BoldPrazoDaPendencia(idade: ${_str(p['idade'])})'
          : 'ds.BoldPrazoDaPendencia(restante: '
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
      ctor: 'ds.DilettaSkeleton.box',
      args: const {'largura': Arg.numero('width'), 'altura': Arg.numero('height')},
      label: 'Esqueleto',
      props: const {
        'largura': PropDef('number'),
        'altura': PropDef('number'),
      },
      defaults: () => {'largura': '180', 'altura': '16'},
      build: (p) => DilettaSkeleton.box(
        width: double.tryParse('${p['largura']}'),
        height: double.tryParse('${p['altura']}'),
      ),
      codegen: (p) => 'ds.DilettaSkeleton.box(width: ${p['largura']}, height: ${p['altura']})',
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
      label: 'Botão de ícone',
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
      label: 'Interruptor',
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
      label: 'Campo de busca',
      props: const {'placeholder': PropDef('text')},
      defaults: () => {'placeholder': 'Buscar contato ou chave'},
      build: (p) => DilettaSearchInput(placeholder: '${p['placeholder']}'),
      codegen: (p) => 'ds.DilettaSearchInput(placeholder: ${_str(p['placeholder'])}'
          ', onChanged: aoBuscar)',
    );

BlockDef _girando() => BlockDef(
      type: 'girando',
      ctor: 'ds.DilettaLoadingSpinner',
      args: const {'tamanho': Arg.enumeracao('size', 'ds.DilettaSpinnerSize')},
      label: 'Carregando',
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
      label: 'Ilustração',
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
      label: 'Estado vazio',
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
      label: 'Cartão de acesso rápido',
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
      label: 'Caixa de seleção',
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
      label: 'Comprovante',
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

BlockDef _folha() => BlockDef(
      type: 'folha',
      ctor: 'ds.DilettaSheetOverlay',
      args: const {'aberta': Arg.bool('open')},
      acoes: const {'onScrimTap': 'aoFechar', 'child': 'conteudoDaFolha'},
      label: 'Folha (overlay)',
      props: const {'aberta': PropDef('bool')},
      defaults: () => {'aberta': true},
      build: (p) => DilettaSheetOverlay(
        open: p['aberta'] == true,
        onScrimTap: () {},
        child: DilettaFrame.column(
          padding: const EdgeInsets.all(DilettaSpacing.s5),
          gap: DilettaSpacing.s3,
          children: [
            const DilettaPageTitle(title: 'Confirmar envio', subtitle: 'Revise antes de enviar.'),
            DilettaButton(label: 'Confirmar', onPressed: () {}, fullWidth: true),
          ],
        ),
      ),
      codegen: (p) => 'ds.DilettaSheetOverlay(open: ${p['aberta'] == true}'
          ', onScrimTap: aoFechar, child: conteudoDaFolha)',
    );

BlockDef _dialogo() => BlockDef(
      type: 'dialogo',
      ctor: 'ds.DilettaDialog',
      args: const {'titulo': Arg.texto('title'), 'mensagem': Arg.texto('message')},
      acoes: const {'actions': 'acoesDoDialogo'},
      label: 'Diálogo',
      props: const {
        'titulo': PropDef('text', bindable: true, dartType: 'String'),
        'mensagem': PropDef('multiline', bindable: true, dartType: 'String'),
      },
      defaults: () => {
        'titulo': 'Encerrar a conta?',
        'mensagem': 'Isso não pode ser desfeito, e o saldo precisa estar zerado.',
      },
      build: (p) => DilettaDialog(
        title: '${p['titulo']}',
        message: _vazio(p['mensagem']) ? null : '${p['mensagem']}',
        actions: [
          DilettaButton(label: 'Cancelar', onPressed: () {}, type: DilettaButtonType.secondary),
          DilettaButton(label: 'Encerrar', onPressed: () {}),
        ],
      ),
      codegen: (p) => 'ds.DilettaDialog(title: ${_str(p['titulo'])}'
          ', message: ${_str(p['mensagem'])}, actions: acoesDoDialogo)',
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
      label: 'Critérios',
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
      acoes: const {'children': 'conteudoDoExpansivel'},
      label: 'Expansível',
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
      build: (p) => DilettaExpansionTile(
        title: '${p['titulo']}',
        initiallyExpanded: p['aberto'] == true,
        children: [
          DilettaText('${p['conteudo']}', style: DilettaType.bodySm),
        ],
      ),
      codegen: (p) => 'ds.DilettaExpansionTile(title: ${_str(p['titulo'])}'
          ', children: conteudoDoExpansivel'
          '${p['aberto'] == true ? ', initiallyExpanded: true' : ''})',
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
      label: 'Cartão de destaque',
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

BlockDef _visorDeCodigo() => BlockDef(
      type: 'visorDeCodigo',
      // Só `ctor`, sem `args`: os props deste bloco são de PREVIEW — no código gerado, alvo e fase
      // vêm de dado em tempo de execução. Bloco sem prop declarada continua legível pelo
      // construtor, e foi um dos três defeitos que o gate do pai achou no próprio pai.
      ctor: 'ds.BoldVisorDeCodigo',
      // Os três argumentos deste bloco vêm de RUNTIME (a câmera), e dois são obrigatórios. Sem isto a
      // tabela emitia `const ds.BoldVisorDeCodigo()` — que não compila, e era o que o `codegen` à mão
      // já resolvia antes de a tabela passar a vencer.
      acoes: const {
        'alvos': 'alvosDetectados',
        'fase': 'faseDaVarredura',
        'tamanhoDaImagem': 'tamanhoDoFrame',
      },
      label: 'Visor de código',
      props: {
        'estado': PropDef('enum',
            options: BoldAlvoEstado.values.map((e) => e.name).toList()),
        'rotulo': const PropDef('text'),
      },
      defaults: () => {'estado': 'analisando', 'rotulo': 'LENDO CÓDIGO'},
      build: (p) => BoldVisorDeCodigo(
        alvos: [
          BoldAlvo(
            area: const Rect.fromLTWH(80, 120, 140, 140),
            estado: BoldAlvoEstado.values
                .firstWhere((e) => e.name == p['estado']),
            rotulo: '${p['rotulo']}',
            centralizado: true,
          ),
        ],
        // Fase fixa no preview: o visor não anima sozinho (quem anima é o app), e um preview
        // parado num ponto legível mostra o rastro melhor que um parado no zero.
        fase: 0.45,
      ),
      codegen: (p) => 'ds.BoldVisorDeCodigo(alvos: alvosDetectados'
          ', fase: faseDaVarredura'
          ', tamanhoDaImagem: tamanhoDoFrame)',
    );

BlockDef _copiar() => BlockDef(
      type: 'copiar',
      ctor: 'ds.BoldCopiar',
      args: const {'texto': Arg.texto('texto'), 'rotulo': Arg.texto('rotuloDeAcessibilidade')},
      label: 'Copiar',
      props: const {
        'texto': PropDef('text', bindable: true, dartType: 'String'),
        'rotulo': PropDef('text'),
      },
      defaults: () => {'texto': 'chave-pix-exemplo', 'rotulo': 'Copiar chave'},
      build: (p) => BoldCopiar(
        texto: '${p['texto']}',
        rotuloDeAcessibilidade: '${p['rotulo']}',
      ),
      codegen: (p) => 'ds.BoldCopiar(texto: ${_str(p['texto'])}'
          ', rotuloDeAcessibilidade: ${_str(p['rotulo'])})',
    );

BlockDef _abas() => BlockDef(
      type: 'abas',
      // `abas` é uma LISTA obrigatória, que a tabela não declara — e `acoes` resolve, porque
      // mecanicamente ele é "argumento → identificador", não só "argumento → handler". O nome do campo
      // é mais estreito que o mecanismo, e isso está anotado no pedido.
      acoes: const {'abas': 'rotulosDasAbas', 'aoTrocar': 'aoTrocarAba'},
      ctor: 'ds.BoldAbas',
      args: const {'selecionada': Arg.numero('indiceSelecionado')},
      label: 'Abas',
      props: const {
        'abas': PropDef('text'),
        'selecionada': PropDef('number'),
      },
      defaults: () => {'abas': 'Tudo, Entradas, Saídas', 'selecionada': '0'},
      build: (p) => BoldAbas(
        abas: _listaDeAbas(p['abas']),
        indiceSelecionado: int.tryParse('${p['selecionada']}') ?? 0,
        aoTrocar: (_) {},
      ),
      codegen: (p) => 'ds.BoldAbas(abas: const ['
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
      build: (p) => BoldSegmentos(
        segmentos: _listaDeAbas(p['segmentos']),
        indiceSelecionado: int.tryParse('${p['selecionado']}') ?? 0,
        aoTrocar: (_) {},
      ),
      codegen: (p) => 'ds.BoldSegmentos(segmentos: const ['
          '${_listaDeAbas(p['segmentos']).map((a) => "'$a'").join(', ')}]'
          ', indiceSelecionado: ${int.tryParse('${p['selecionado']}') ?? 0}'
          ', aoTrocar: aoTrocarSegmento)',
    );

BlockDef _pontosDePagina() => BlockDef(
      type: 'pontosDePagina',
      ctor: 'ds.BoldPontosDePagina',
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
      build: (p) => BoldPontosDePagina(
        total: int.tryParse('${p['total']}') ?? 0,
        indiceAtivo: int.tryParse('${p['ativo']}') ?? 0,
      ),
      codegen: (p) => 'ds.BoldPontosDePagina(total: ${p['total']}'
          ', indiceAtivo: ${p['ativo']})',
    );

BlockDef _saldo() => BlockDef(
      type: 'saldo',
      acoes: const {'aoAbrirExtrato': 'abrirExtrato'},
      ctor: 'ds.BoldSaldo',
      args: const {'valor': Arg.texto('valor'), 'entradas': Arg.texto('entradas'), 'saidas': Arg.texto('saidas'), 'oculto': Arg.bool('oculto')},
      label: 'Saldo (home)',
      props: const {
        'valor': PropDef('text', bindable: true, dartType: 'String'),
        'entradas': PropDef('text', bindable: true, dartType: 'String'),
        'saidas': PropDef('text', bindable: true, dartType: 'String'),
        'oculto': PropDef('bool'),
      },
      defaults: () => {
        'valor': 'R\$ 2.912,47',
        'entradas': 'R\$ 300,00',
        'saidas': 'R\$ 120,00',
        'oculto': false,
      },
      build: (p) => BoldSaldo(
        valor: '${p['valor']}',
        entradas: _vazio(p['entradas']) ? null : '${p['entradas']}',
        saidas: _vazio(p['saidas']) ? null : '${p['saidas']}',
        oculto: p['oculto'] == true,
        aoAbrirExtrato: () {},
      ),
      codegen: (p) => 'ds.BoldSaldo(valor: ${_str(p['valor'])}'
          '${_vazio(p['entradas']) ? '' : ', entradas: ${_str(p['entradas'])}'}'
          '${_vazio(p['saidas']) ? '' : ', saidas: ${_str(p['saidas'])}'}'
          '${p['oculto'] == true ? ', oculto: true' : ''}'
          ', aoAbrirExtrato: abrirExtrato)',
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
  // vazia. Os 358 ícones do catálogo estavam invisíveis por causa disto, e nenhum teste viu porque
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
  };

  Ds.configurar(PlugueDoDs(
    blocos: blocos,
    // TODO tipo precisa estar num grupo: a paleta do editor sai daqui, então bloco sem
    // grupo existe e ninguém acha. A conformidade do pai cobra.
    grupos: const {
      'Estrutura': ['barraDeStatus', 'tituloDaPagina', 'indicadorDeHome'],
      'Conteúdo': ['texto', 'valor', 'selo', 'aviso', 'icone', 'cabecalhoDeSecao',
        'ilustracao', 'logo', 'chipDeInfo', 'estadoVazio', 'avatar', 'criterios', 'expansivel',
        'cartaoDeDestaque', 'comprovante'],
      // A lista e as duas linhas ficam juntas porque é assim que se usam: a coleção é dona do
      // separador, e linha fora de lista é linha sem vizinhança.
      'Lista': ['lista', 'linha', 'linhaDeValor'],
      // Retorno de sistema: o que a tela diz enquanto ou depois de algo acontecer.
      'Retorno': ['toast', 'esqueleto', 'girando'],
      // Camada: o que aparece POR CIMA da tela.
      'Camada': ['folha', 'dialogo'],
      // Grupo próprio porque é o que só o Bold tem: a vizinhança na paleta é decisão de
      // linguagem, e peça de marca não se mistura com vocabulário herdado.
      'Marca do Bold': ['seloQuantico', 'saldo', 'cabecalhoDaHome', 'resumoDaTransacao'],
      'Do Bold': ['copiar', 'abas', 'segmentos', 'pontosDePagina'],
      // As três peças da conta PJ: quem pode mandar quanto, falta quanto, e até quando.
      'Alçadas': ['escadaDeAlcadas', 'progressoDeAprovacao', 'prazoDaPendencia'],
      'Leitor de código': ['visorDeCodigo'],
      'Entrada': ['campo', 'campoDeBusca', 'interruptor', 'caixaDeSelecao', 'chipDeEntrada',
        'dropdown', 'listaDeRadio'],
      'Ação': ['botao', 'barraDeBaixo', 'botaoDeIcone', 'cartaoDeAcesso'],
      'Ritmo': ['ritmo', 'divisor'],
    },
    tema: (filho, {required escuro}) => DilettaThemeScope(
      theme: escuro ? BoldTheme.dark : BoldTheme.light,
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
    fundoDoFrame: (ctx) => const BoldBackground(child: SizedBox.expand()),
    // Fica declarado também: o motor usa o `Color?` quando o widget está ausente, e é o que
    // pinta a cor por trás do próprio backdrop.
    fundoDaTela: (ctx) {
      final s = DilettaTheme.schemeOf(ctx);
      return s.isDark ? BoldPalette.bold.bgEscuro : BoldPalette.bold.primary08;
    },
    superficieDaTela: (ctx) => DilettaTheme.schemeOf(ctx).surface,
    // No claro a tela declara o próprio fundo; no escuro o tema manda, senão cada tela
    // precisaria declarar duas cores.
    fundoImpostoPeloTema: (ctx) {
      final s = DilettaTheme.schemeOf(ctx);
      return s.isDark ? s.bg : null;
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
    // OS CONTRATOS (v0.36.0 do motor) — guideline é parte do contrato do COMPONENTE, não do catálogo
    // que o mostra. Pro componente do PAI o markdown vem do pacote dele (`kDilettaSpecs`), e o mapa
    // abaixo é DERIVADO do `ctor` de cada bloco: escrever a correspondência à mão com 43 blocos e 64
    // specs erra, e o sintoma (bloco sem contrato) é indistinguível de spec que não existe.
    contratos: _contratosDosBlocos(blocos),
    // A VOLTA: sem isto, tela que só existe como código aparece como código, sem preview — e quem
    // monta tela perde a metade que importa, que é abrir o que já existe.
    leCodigoComoSpec: lerTelaDoBold,
    importNoCodigo:
        "import 'package:conta_bold_design_system/conta_bold_design_system.dart' as ds;",
    nomesNoCodigo: const NomesNoCodigo(
      coluna: 'ds.DilettaFrame.column',
      superficie: 'ds.DilettaSurface',
      superficieDeFolha: 'ds.DilettaSurface.sheet',
      stickyHeader: 'ds.DilettaStickyHeader',
    ),
  ));
}

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
/// Derivado e não escrito: com 43 blocos e 64 specs, tabela à mão erra e o sintoma (bloco sem contrato)
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
    'lista': 'design-system-app-list',
    'linha': 'design-system-app-list',
    'linhaDeValor': 'design-system-app-list',
    'barraDeBaixo': 'design-system-bottom-app',
    'indicadorDeHome': 'design-system-bottom-home-indicator',
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
/// Só as RAMPAS, e não os ~51 papéis: papel é derivado e muda com o modo, então mostrá-lo numa lista sem
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
  };
}

bool _vazio(Object? v) => v == null || '$v'.isEmpty;

/// Um enum do pai como mapa nome → valor, pra casar com o que a prop guarda (String).
///
/// Derivado de `values` e não escrito à mão: enum que ganha membro no pai aparece aqui sozinho, e
/// membro que ele remove vira erro de compilação em vez de opção fantasma no editor.
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
