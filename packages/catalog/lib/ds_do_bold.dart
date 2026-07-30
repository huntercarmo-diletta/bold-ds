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

TextStyle _estiloDe(String preset) => switch (preset) {
      'displaySm' => DilettaType.displaySm,
      'headlineSm' => DilettaType.headlineSm,
      'titleMd' => DilettaType.titleMd,
      'bodySm' => DilettaType.bodySm,
      'label' => DilettaType.label,
      _ => DilettaType.bodyMd,
    };

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
      codegen: (p) => 'ds.DilettaButton(label: ${_str(p['label'])}, onPressed: onContinuar'
          ', type: ds.DilettaButtonType.${p['tipo']}'
          ', size: ds.DilettaButtonSize.${p['tamanho']}'
          '${p['larguraTotal'] == true ? ', fullWidth: true' : ''})',
    );

Widget _botaoWidget(Map<String, dynamic> p, {VoidCallback? aoTocar}) => DilettaButton(
      label: '${p['label']}',
      onPressed: aoTocar ?? () {},
      type: switch (p['tipo']) {
        'secondary' => DilettaButtonType.secondary,
        'tertiary' => DilettaButtonType.tertiary,
        _ => DilettaButtonType.primary,
      },
      size: switch (p['tamanho']) {
        'md' => DilettaButtonSize.md,
        'sm' => DilettaButtonSize.sm,
        _ => DilettaButtonSize.lg,
      },
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

DilettaStatusTone _tomDe(String t) => switch (t) {
      'primary' => DilettaStatusTone.primary,
      'success' => DilettaStatusTone.success,
      'warning' => DilettaStatusTone.warning,
      'danger' => DilettaStatusTone.danger,
      'secure' => DilettaStatusTone.secure,
      _ => DilettaStatusTone.neutral,
    };

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

BlockDef _visorDeCodigo() => BlockDef(
      type: 'visorDeCodigo',
      // Só `ctor`, sem `args`: os props deste bloco são de PREVIEW — no código gerado, alvo e fase
      // vêm de dado em tempo de execução. Bloco sem prop declarada continua legível pelo
      // construtor, e foi um dos três defeitos que o gate do pai achou no próprio pai.
      ctor: 'ds.BoldVisorDeCodigo',
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

BlockDef _saldo() => BlockDef(
      type: 'saldo',
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
  Ds.configurar(PlugueDoDs(
    blocos: {
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
    },
    // TODO tipo precisa estar num grupo: a paleta do editor sai daqui, então bloco sem
    // grupo existe e ninguém acha. A conformidade do pai cobra.
    grupos: const {
      'Estrutura': ['barraDeStatus', 'tituloDaPagina', 'indicadorDeHome'],
      'Conteúdo': ['texto', 'valor', 'selo', 'aviso', 'icone', 'cabecalhoDeSecao'],
      // A lista e as duas linhas ficam juntas porque é assim que se usam: a coleção é dona do
      // separador, e linha fora de lista é linha sem vizinhança.
      'Lista': ['lista', 'linha', 'linhaDeValor'],
      // Grupo próprio porque é o que só o Bold tem: a vizinhança na paleta é decisão de
      // linguagem, e peça de marca não se mistura com vocabulário herdado.
      'Marca do Bold': ['seloQuantico', 'saldo', 'cabecalhoDaHome', 'resumoDaTransacao'],
      'Do Bold': ['copiar', 'abas'],
      // As três peças da conta PJ: quem pode mandar quanto, falta quanto, e até quando.
      'Alçadas': ['escadaDeAlcadas', 'progressoDeAprovacao', 'prazoDaPendencia'],
      'Leitor de código': ['visorDeCodigo'],
      'Entrada': ['campo'],
      'Ação': ['botao', 'barraDeBaixo'],
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
    tiposDeTelaCheia: const {'visorDeCodigo'},
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

double _espaco(String token) => switch (token) {
      's2' => DilettaSpacing.s2,
      's3' => DilettaSpacing.s3,
      's6' => DilettaSpacing.s6,
      's8' => DilettaSpacing.s8,
      _ => DilettaSpacing.s4,
    };

bool _vazio(Object? v) => v == null || '$v'.isEmpty;

/// Literal Dart de uma string, ou o IDENTIFICADOR quando a prop está vinculada a um
/// campo da tela gerada. Sem isto, uma prop vinculada sairia como `'nomeDoCampo'` — uma
/// string com o nome da variável, que compila e mostra o texto errado.
String _str(Object? v) => v is BoundRef ? v.field : "'${v.toString().replaceAll("'", r"\'")}'";
