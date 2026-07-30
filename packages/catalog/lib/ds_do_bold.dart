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

BlockDef _texto() => BlockDef(
      type: 'texto',
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

BlockDef _ritmo() => BlockDef(
      type: 'ritmo',
      label: 'Espaço',
      props: const {'tamanho': PropDef('spacingToken', options: ['s2', 's3', 's4', 's6', 's8'])},
      defaults: () => {'tamanho': 's4'},
      build: (p) => DilettaGap.h(_espaco('${p['tamanho']}')),
      codegen: (p) => 'ds.DilettaGap.h(ds.DilettaSpacing.${p['tamanho']})',
    );

BlockDef _divisor() => BlockDef(
      type: 'divisor',
      label: 'Divisor',
      props: const {},
      defaults: () => {},
      build: (p) => const DilettaDivider(),
      codegen: (p) => 'ds.DilettaDivider()',
    );

BlockDef _icone() => BlockDef(
      type: 'icone',
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
BlockDef _seloQuantico() => BlockDef(
      type: 'seloQuantico',
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
      'indicadorDeHome': _indicadorDeHome(),
    },
    // TODO tipo precisa estar num grupo: a paleta do editor sai daqui, então bloco sem
    // grupo existe e ninguém acha. A conformidade do pai cobra.
    grupos: const {
      'Estrutura': ['barraDeStatus', 'tituloDaPagina', 'indicadorDeHome'],
      'Conteúdo': ['texto', 'valor', 'selo', 'aviso', 'icone'],
      // Grupo próprio porque é o que só o Bold tem: a vizinhança na paleta é decisão de
      // linguagem, e peça de marca não se mistura com vocabulário herdado.
      'Marca do Bold': ['seloQuantico'],
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
