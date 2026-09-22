import 'dart:math' as math;



import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'coreflow_gradients.dart';
import 'coreflow_scheme.dart';

/// O PREFIXO DAS VARIÁVEIS, e ele é **da linguagem** — não deste filho.
///
/// Era `--cps-` cravado em 22 literais aqui, e isso ficou errado na v0.198.0 do avô, que renomeou
/// tudo para `--diletta-*` **e passou a ler os nomes novos dentro das peças**. A ponte dele aponta
/// `--cps-x → var(--diletta-x)`, o que serve para quem ESCREVE o nome velho na própria folha — um
/// consumidor. Nós não escrevemos: nós SOBRESCREVEMOS, e sobrescrever o nome velho não alcança quem
/// lê o novo.
///
/// Medido num diretório vazio em 17/09, antes de publicar: o `<diletta-button>` desenhou em
/// **#17a37d**, o verde de referência, com a nossa folha declarando `--cps-primary: #f66fa0` ao
/// lado, sem erro nenhum no console. É o modo de falhar que o README deste pacote já descrevia —
/// *«fora de ordem, a referência ganha e a tela sai verde»* — chegando por outra porta.
///
/// Uma constante, e não 22 literais, pela mesma razão que levou o avô a fazer o mesmo: prefixo
/// espalhado é prefixo que se troca pela metade.
const prefixoDaLinguagem = '--diletta-';

/// O prefixo ANTIGO, que este pacote continua emitindo como PONTE para quem já escreveu com ele.
///
/// O Internet Banking tem 2.315 ocorrências de `--cps-*` nas folhas dele. A ponte é o mesmo
/// mecanismo que o avô nos deu, um andar abaixo: alias por `var()`, que não copia valor — então o
/// modo escuro segue o seletor sozinho.
const prefixoDaPonte = '--cps-';

/// A INSTÂNCIA WEB da tinta: os papéis da linguagem, resolvidos com [p], escritos como `--cps-*`.
///
/// Não é uma segunda paleta nem uma segunda derivação. É a MESMA do avô (`dilettaCorDoPapelGen`)
/// rodada com a paleta que chega — por isso nenhum hex é digitado aqui, e por isso papel novo no avô
/// aparece sozinho na próxima emissão.
///
/// Mora no PAI porque todo filho quer isto: quem declara uma cor e recebe os ~59 papéis do lado
/// Flutter tem o mesmo direito do lado web. A função recebe a paleta e não conhece produto nenhum —
/// o gate `o_pacote_nao_crava_a_paleta_do_bold` do filho existe exatamente pra essa linha não voltar.
///
/// O par disto é o `cps-papeis.css` do avô, que tem a MESMA lista de nomes com a tinta de referência.
/// Carregue a dele primeiro e esta depois: `--cps-*` é variável, e variável se sobrescreve. É o white
/// label do lado web, pelo mesmo mecanismo que o Flutter já usa com paleta.
///
/// [produto] entra só no comentário do topo, pra quem abrir o arquivo saber de quem é a tinta.
String coreflowPapeisCss(DilettaPalette p, {required String produto}) {
  final claro = DilettaScheme.light(p);
  final escuro = DilettaScheme.dark(p);

  String bloco(DilettaScheme s, String indent) {
    final linhas = <String>[];
    for (final papel in dilettaNomesDePapelGen) {
      final cor = dilettaCorDoPapelGen(s, papel);
      // Papel sem tinta é ausência declarada (o avô tem dois: `glassStroke`, `skeletonShimmer`), e
      // ausência não vira `--cps-x: ;` — declaração inválida some no navegador sem erro, que é a
      // classe de defeito que o README do pacote web do avô conta ter custado semanas.
      if (cor == null) continue;
      linhas.add('$indent  $prefixoDaLinguagem$papel: ${_hex(cor)};');
    }
    return linhas.join('\n');
  }

  return '/* GERADO — NÃO editar à mão. Os ${dilettaNomesDePapelGen.length} papéis da linguagem, '
          'com a tinta de $produto.\n'
          '   Carregue DEPOIS das folhas do avô: estas mesmas variáveis, com os valores '
          'deste produto. */\n' +
      _tresBlocos(bloco(claro, ''), bloco(escuro, '  '), bloco(escuro, ''));
}

/// A FORMA das três folhas de modo, e ela é a do avô — `:root`, o `@media` com a guarda de
/// `[data-theme="light"]`, e o `[data-theme="dark"]` que deixa o botão de modo ganhar nos dois
/// sentidos. Uma função só porque as três emissões mode-aware daqui têm que sair idênticas: forma
/// divergente entre folhas é a classe de defeito que ninguém vê até o modo escuro de um produto só.
String _tresBlocos(String claro, String escuroMedia, String escuroAttr) => '''
:root {
$claro
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
$escuroMedia
  }
}

:root[data-theme="dark"] {
$escuroAttr
}
''';

/// `#rrggbb` quando opaco, `#rrggbbaa` quando não — a mesma forma que o avô emite, pra que comparar as
/// duas folhas seja `diff` e não conversão.
String _hex(Color c) {
  final argb = c.toARGB32();
  final rgb = argb.toRadixString(16).padLeft(8, '0').substring(2);
  final alfa = (argb >> 24) & 0xFF;
  return alfa == 0xFF ? '#$rgb' : '#$rgb${alfa.toRadixString(16).padLeft(2, '0')}';
}

/// Os papéis do ESQUEMA DO PRODUTO — os que o avô não tem e o `CoreflowScheme` acrescenta —
/// escritos como `--cps-*`, no mesmo namespace e na mesma forma de três blocos.
///
/// Mesmo namespace de propósito: é UMA língua. O que o filho acrescenta entra ao lado do que o avô
/// declara, e o gate `nenhum papel do produto colide com o do avo` prova que nenhum nome é roubado.
String coreflowEsquemaCss(DilettaPalette p) {
  Map<String, Color> papeis(Brightness b) {
    final s = CoreflowScheme.de(p, brilho: b);
    return {
      'background': s.background, 'secondaryFlow': s.secondaryFlow,
      'textPrimary': s.textPrimary, 'border': s.border, 'overlay': s.overlay,
      'primary': s.primary, 'danger': s.danger, 'infoSubtle': s.infoSubtle, 'vinho': s.vinho,
    };
  }

  String bloco(Brightness b, String i) => papeis(b)
      .entries
      .map((e) => '$i  $prefixoDaLinguagem${e.key}: ${_hex(e.value)};')
      .join('\n');

  return _tresBlocos(bloco(Brightness.light, ''), bloco(Brightness.dark, '  '),
      bloco(Brightness.dark, ''));
}

/// As MEDIDAS por nome, com o que ESTE produto declarou — `--cps-*`, com o nome do papel, igual à
/// cor. Peça pede papel, não degrau: a escada de primitivas do avô (`--cps-r8`, `--cps-r16`…) já vem
/// na folha dele e não é isto.
///
/// **As seis FORMAS saem do plugue de medida do avô**, que ganhou as três últimas no veredito de
/// 14/09 (*"a forma sobe por FAMÍLIA e os três viram alias"*). A primeira versão desta função emitia
/// a const de cada uma, e o `///` dizia que quando o pedido entrasse elas viriam por aqui. Entrou;
/// vieram.
///
/// Papel não declarado devolve `null`, e aí vale o que a linguagem desenha — a gramática deste DS.
/// **Nenhum produto move um pixel** por esta tabela existir: quem não declarou recebe o que recebia.
///
/// A PÍLULA não sai como token seu: o veredito a deixou fora das seis de propósito (*999 × qualquer
/// fator continua pílula, e controle é pílula inteira*), e emitir um `--cps-pilula: 999px` ao lado de
/// um `--cps-formaDeBotao: 200px` poria dois números pra mesma forma na mesma folha. Quem quer pílula
/// lê `formaDeBotao` ou `formaDeNav`, que é onde a linguagem a desenha.
///
/// Não é mode-aware, então sai num `:root` só.
String coreflowMedidasCss(DilettaPalette p) {
  // Os GETTERS do avô, não o `medidaDe` cru. Cada um resolve a cadeia inteira — tabela de medidas,
  // depois o campo `raioDeX` que virou alias, depois o desenho da linguagem —, e ler a tabela direto
  // pula o meio: um produto que declare só o alias receberia a pílula em vez do que declarou.
  // Medido num produto desta casa em 14/09, no mesmo dia em que as seis formas entraram.
  final a = DilettaScheme.light(p);
  // A FOLHA é a exceção e é nossa: o esquema deste DS cai em 22 onde o avô cai em 24, pela régua do
  // `CoreflowRadius` — casar por VALOR e nunca por nome.
  final nossa = CoreflowScheme.de(p, brilho: Brightness.light);

  final formas = <String, BorderRadius>{
    DilettaMedida.formaDeBotao: a.formaDoBotao,
    DilettaMedida.formaDeFolha: nossa.formaDaFolha,
    DilettaMedida.formaDeCampo: a.formaDoCampo,
    DilettaMedida.formaDeCartao: a.formaDoCartao,
    DilettaMedida.formaDeVidro: a.formaDoVidro,
    DilettaMedida.formaDeNav: a.formaDaNav,
  };

  final linhas = [
    for (final e in formas.entries) '  $prefixoDaLinguagem${e.key}: ${_px(e.value.topLeft.x)};',
  ];
  return ':root {\n${linhas.join('\n')}\n}\n';
}

/// A ESCALA DE TIPO do produto, na MESMA forma que o avô emite (`-size`, `-weight`, `-line-height`,
/// `-spacing`), pra que um degrau homônimo SOBRESCREVA o dele em vez de conviver com ele.
///
/// [degraus] é `papel -> estilo`, e quem monta é o produto: a escala é dele (seis px que o avô não
/// tem, por decisão escrita no `///` da classe). O `height` do Flutter é multiplicador; aqui vira px,
/// que é o que o CSS do avô já usa — comparar as duas folhas tem que ser `diff`, não conversão.
///
/// **`height` nulo vira `normal`, e NÃO `1 ×` o tamanho.** Nulo no Flutter quer dizer *use a caixa
/// natural da fonte* — a Inter entrega ~1,2 —, e a primeira versão desta função traduzia isso por
/// `1 ×`, que é uma opinião que ninguém declarou. Medido em 15/09 com a Inter carregada: **7 dos 20
/// degraus divergiam**, cinco deles por 2 a 4px POR LINHA (`title` 21×17, `button` 18×15, `label`
/// 15×12, `mono` 16×13, `monoCaption` 13×11) e os dois restantes por fração, que é o Flutter
/// arredondando a caixa pra pixel inteiro. `normal` é a palavra do CSS pra mesma instrução, e faz os
/// dois lados lerem a mesma métrica em vez de dois números escritos por casas diferentes.
///
/// Quem declara altura continua saindo em px: declarado é declarado, e o gate de paridade compara os
/// dois casos separados.
///
/// **NÃO existe gate medindo o PIXEL das duas plataformas, e é decisão.** O que achou isto foi
/// medir a Inter num navegador de verdade contra a Inter num `flutter test` com a fonte carregada
/// — e um gate assim pediria navegador em toda rodada, sobre duas plataformas que não podem
/// empatar (sobra 0,5px de arredondamento, e gate com tolerância é gate que se afrouxa). Varri as
/// outras famílias antes de decidir: cor, medida, tamanho, peso e tracking são CÓPIA de valor; a
/// altura era a única TRADUÇÃO, e é esta linha. Classe de um caso, fechado.
///
/// Condição de reabrir: **a segunda tradução** — outro ponto em que o Flutter diz *natural* e o
/// CSS precise escolher a palavra —, ou uma divergência de desenho medida à mão que o gate de
/// paridade tenha deixado passar.
/// A FAMÍLIA TIPOGRÁFICA, sozinha — e é ela que faltava em todo filho que não é o primeiro.
///
/// No Flutter, um produto que não declara família herda a do app (`CoreflowTipografia.familia` é
/// anulável de propósito). **Na web não existe app para herdar**: `font-family: var(--diletta-font-family)`
/// com a variável ausente não é erro no console — `var()` que não resolve mata a declaração inteira,
/// e o navegador cai no serifado padrão. Medido na Norte Benk em 22/09: a tela inteira em Times,
/// com toda a configuração correta, e uma linha injetada à mão resolveu tudo.
///
/// Por isso a família sai SEMPRE, mesmo para quem herda os degraus do avô — a escala o avô publica,
/// a família não, e não publicar era o buraco.
String coreflowFamiliaCss(String familia) =>
    ':root {\n  ${prefixoDaLinguagem}font-family: $familia;\n}\n';

/// A família DESTE produto como pilha CSS, a partir do que ele declarou em `CoreflowTipografia`.
///
/// **É aqui que um filho troca de fonte**, e a declaração é UMA, servindo Flutter e web:
///
/// ```dart
/// tipografia: CoreflowTipografia.doAvo.copyWith(familia: 'packages/meu_filho/MinhaFonte'),
/// ```
///
/// O nome que o Flutter usa vem qualificado pelo pacote (`packages/<pacote>/<Nome>`), que é sintaxe
/// de Flutter e não de CSS; o prefixo sai aqui. Quem não declara recebe a [familiaDaFamilia] — a
/// Inter que viaja no pacote web, e não uma fonte do sistema.
///
/// **LIMITE, dito em voz alta:** trocar o nome não faz o ARQUIVO da fonte viajar. A folha passa a
/// pedir `MinhaFonte` e o navegador só a desenha se o pacote web daquele filho publicar os arquivos
/// dela, como o do Bold publica os da Inter em `fontes.css`. Nomear sem empacotar é a mesma falha
/// calada de variável sem valor — o nome chega, o desenho não.
String coreflowFamiliaWeb(String? declarada) {
  final crua = declarada == null
      ? familiaDaFamilia
      : (RegExp(r'^packages/[^/]+/(.+)$').firstMatch(declarada)?.group(1) ?? declarada);
  return "'$crua', system-ui, sans-serif";
}

/// A fonte que a família publica, e o padrão de quem não declara outra. É a mesma que viaja no
/// pacote web (`fontes.css` reexporta o `@fontsource/inter`), então nomeá-la aqui é nomear um
/// arquivo que existe.
const String familiaDaFamilia = 'Inter';

String coreflowTipoCss(Map<String, TextStyle> degraus, {required String familia}) {
  final linhas = <String>["  ${prefixoDaLinguagem}font-family: $familia;"];
  for (final e in degraus.entries) {
    final s = e.value;
    final tamanho = s.fontSize;
    if (tamanho == null) continue;
    final altura = s.height == null ? 'normal' : _px(s.height! * tamanho);
    linhas.add('  ${prefixoDaLinguagem}type-${e.key}-size: ${_px(tamanho)};');
    linhas.add('  ${prefixoDaLinguagem}type-${e.key}-line-height: $altura;');
    if (s.fontWeight != null) {
      linhas.add('  ${prefixoDaLinguagem}type-${e.key}-weight: ${s.fontWeight!.value};');
    }
    if (s.letterSpacing != null) {
      linhas.add('  ${prefixoDaLinguagem}type-${e.key}-spacing: ${_px(s.letterSpacing!)};');
    }
  }
  return ':root {\n${linhas.join('\n')}\n}\n';
}

/// `16px`, e `22px` — sem `.0` pendurado, que é o que o CSS do avô escreve.
String _px(double v) => v == v.roundToDouble() ? '${v.round()}px' : '${v}px';

/// Os AJUSTES DE PAPEL POR COMPONENTE, como cascata.
///
/// A linguagem deixa um produto dizer *"neste componente, o papel X passa a ler o Y"*, e do lado
/// Flutter isso é `scheme.comAjustes(...)`. Na web é mais direto do que parece: a peça pinta com
/// `var(--cps-X)`, então redeclarar `--cps-X` DENTRO do elemento muda o que ela lê — e propriedade
/// customizada atravessa shadow DOM, que é onde os custom elements desenham.
///
/// ```css
/// diletta-button { --cps-primary: var(--cps-secure); }
/// ```
///
/// Sai mode-aware de graça: `--cps-secure` já muda por modo, e o alias segue.
///
/// **Ajuste em peça que não tem instância web não sai**, e isso não é perda: peça que não existe na
/// web não desenha nada pra ajustar. O que seria perda é sair calado — por isso o gate de paridade
/// separa os dois casos e só aceita a ausência quando a peça não existe mesmo lá.
///
/// [tagsWeb] é o conjunto de tags que a instância web registra, e ele entra por parâmetro porque
/// quem sabe disso é o pacote web, não o pai.
String coreflowAjustesCss(
  List<DilettaAjusteDePapel> ajustes, {
  required Set<String> tagsWeb,
}) {
  if (ajustes.isEmpty) return '';
  final linhas = <String>[];
  for (final a in ajustes) {
    final tag = tagDaPeca(a.componente);
    if (!tagsWeb.contains(tag)) continue;
    linhas.add('/* ${a.componente}: ${a.de} → ${a.para} — ${a.motivo.name}. ${a.nota} */');
    linhas.add('$tag { $prefixoDaLinguagem${a.de}: var($prefixoDaLinguagem${a.para}); }');
  }
  return linhas.isEmpty ? '' : '${linhas.join('\n')}\n';
}

/// `DilettaButton` → `diletta-button`. A mesma conta que o pacote web usa pra registrar, e por isso
/// ela é pública: o gate de paridade precisa fazer a volta pra saber qual peça tem instância web.
String tagDaPeca(String componente) => componente
    .replaceAllMapped(RegExp('(?<=.)[A-Z]'), (m) => '-${m[0]}')
    .toLowerCase();

/// Os GRADIENTES do produto, como `linear-gradient` — e eles são do FILHO, não da linguagem.
///
/// O `///` do `CoreflowGradients` conta por quê: as paradas saem do arquivo do símbolo, e curva de
/// logo não é rampa — *«forçá-la em `papeisExtras` seria oito entradas fingindo ser papel»*. Os
/// atalhos moravam no pai e mudaram para o pacote do produto: **nome do pai, valor de filho**.
///
/// A falta disto foi medida do lado de fora: o Internet Banking pinta sete peças com o degradê da
/// marca — avatar, botão flutuante, variante de destaque —, e não havia de onde tirá-lo. A saída
/// que sobrava era declarar tinta de marca no repo do consumidor, que é o que a `ADR-007` proíbe.
///
/// O ÂNGULO vira `deg`: o Flutter fala em `Alignment` de canto a canto, o CSS em graus. `(-0.8,-1)`
/// a `(0.8,1)` é o eixo diagonal, e `135deg` é o mesmo traço no sistema do navegador — medido, não
/// convertido de cabeça: `atan2` do vetor entre os dois pontos, com o zero do CSS apontando pra cima.
///
/// A TINTA SOBRE O GRADIENTE sai junto, e não é detalhe: no primeiro produto ela é o vinho-tinta, e
/// a troca dela é o que destravou o lockup — com branco, o amarelo dava **1,21:1**, que é conteúdo
/// que não existe na tela.
/// A RAMPA DE MARCA deste produto, nove degraus, por nome — `--diletta-primary01`…`09`.
///
/// **Constante de marca: sai SEM bloco de modo.** Medido antes de emitir: `primary04` da Norte Benk
/// vale `#1d72ff` no esquema claro e no escuro, o mesmo dos dois lados. A rampa é a identidade da
/// marca; quem inverte por brilho são os PAPÉIS que se derivam dela.
///
/// ## Por que ela faltava, e o que a falta custou
///
/// A web recebia só os papéis semânticos (`primary`, `primaryHover`, `primarySubtle`…). Eles bastam
/// para pintar componente, e não bastam para DESENHAR: quem precisa de dois degraus da rampa para
/// montar um fundo não tem de onde tirá-los.
///
/// O efeito foi medido do lado de fora. Um consumidor web monta os brilhos do fundo com três
/// paradas da curva do LOCKUP do PRIMEIRO produto (`lockup01`, `05`, `08`), porque era o que existia
/// publicado. Só que a curva do lockup é o desenho do símbolo daquele produto — oito paradas
/// varrendo matiz. Quem não desenha curva própria recebe a derivada, de duas
/// (`CoreflowGradients.daPaleta`), e os dois brilhos que faltam morrem calados: `var()` que não
/// resolve mata a declaração inteira.
///
/// Com a rampa publicada, um consumidor desenha fundo com a tinta DA MARCA que está rodando — que é
/// o que o pai já faz do lado Flutter (`coreflow_background.dart` monta os brilhos com
/// `p.primary04`, e nenhuma parada de lockup).
///
/// **Não é atalho para papel.** Papel continua sendo papel: quem quer «a cor de ação» lê `primary`,
/// que inverte por modo. A rampa é para quem precisa do DEGRAU, e a diferença aparece na primeira
/// tela escura.
String coreflowRampaCss(DilettaPalette p) => coreflowConstantesCss({
      'primary01': p.primary01, 'primary02': p.primary02, 'primary03': p.primary03,
      'primary04': p.primary04, 'primary05': p.primary05, 'primary06': p.primary06,
      'primary07': p.primary07, 'primary08': p.primary08, 'primary09': p.primary09,
    });

String coreflowGradientesCss(CoreflowGradients g) {
  String css(LinearGradient lg) {
    final graus = _grausDe(lg.begin, lg.end);
    final paradas = <String>[
      for (var i = 0; i < lg.colors.length; i++)
        lg.stops == null
            ? _hex(lg.colors[i])
            : '${_hex(lg.colors[i])} ${(lg.stops![i] * 100).toStringAsFixed(0)}%',
    ];
    return 'linear-gradient(${graus}deg, ${paradas.join(', ')})';
  }

  final linhas = [
    for (final e in g.todos.entries) '  ${prefixoDaLinguagem}gradiente-${e.key}: ${css(e.value)};',
    '  ${prefixoDaLinguagem}onGradiente: ${_hex(g.tintaSobreOGradiente)};',
  ];
  return ':root {\n${linhas.join('\n')}\n}\n';
}

/// As CONSTANTES DE MARCA por nome — cor que NÃO é papel: não inverte com o modo e não deriva de
/// nenhum dos papéis da linguagem.
///
/// Existe porque um gradiente publicado INTEIRO não serve a quem precisa de UMA parada dele. Medido
/// num produto desta casa em 20/09: a peça de fundo lia o degradê pronto em quatro lugares e, nos
/// dois em que precisava da parada solta, DIGITAVA o hex na folha do componente. Hex digitado em
/// folha de produto é a cópia sem fonte que esta casa passou o mês desfazendo.
///
/// Sai num `:root` só, sem os três blocos de modo, e isso é o ponto: **constante de marca não tem
/// modo**. Um papel inverte com o tema; a parada de um símbolo vale o que o símbolo vale, nos dois.
/// Um brilho que muda de cor com o tema é outro desenho.
///
/// A função não conhece produto nenhum — recebe o mapa que o filho declarou.
String coreflowConstantesCss(Map<String, Color> constantes) {
  if (constantes.isEmpty) return '';
  final linhas = [
    for (final e in constantes.entries) '  $prefixoDaLinguagem${e.key}: ${_hex(e.value)};',
  ];
  return ':root {\n${linhas.join('\n')}\n}\n';
}

/// O ângulo do CSS a partir dos dois cantos do Flutter.
///
/// `Alignment` vai de -1 a 1 com o Y crescendo pra BAIXO; o `deg` do CSS mede a partir do topo, no
/// sentido horário. Converter de cabeça erra o sinal do Y — este é o mesmo cálculo que o
/// `linear-gradient` faz, escrito uma vez.
int _grausDe(AlignmentGeometry begin, AlignmentGeometry end) {
  final a = begin.resolve(TextDirection.ltr), b = end.resolve(TextDirection.ltr);
  final dx = b.x - a.x, dy = b.y - a.y;
  final graus = (math.atan2(dx, -dy) * 180 / math.pi).round();
  return (graus + 360) % 360;
}

/// A PONTE DO NOME ANTIGO — todo `--diletta-x` que esta folha declara ganha um `--cps-x` apontando
/// para ele.
///
/// Derivada da FOLHA, não de uma segunda lista, e a razão tem nome: o avô fez a ponte dele por
/// expressão regular e ela não lia o `_`, então `--diletta-s0_5` e `--diletta-s1_5` ficaram sem
/// alias — dois degraus mudos, achados pelo gate dele e não por olho. Lista paralela e regex estreita
/// são a mesma dívida com roupas diferentes: quem lê a saída não erra o que a saída tem.
///
/// Alias não copia VALOR. `--cps-primary: var(--diletta-primary)` num `:root` único segue o seletor
/// que estiver valendo, então um bloco só cobre claro e escuro — não há par de blocos para
/// dessincronizar.
///
/// Sai quando o consumidor migrar. Enquanto existir, ela é o que deixa 2.315 ocorrências de
/// `--cps-*` no Internet Banking continuarem lendo a tinta deste produto.
String coreflowPonteDoNomeAntigo(String folha) {
  // `[A-Za-z0-9_-]` inclui o `_` DE PROPÓSITO — ver o `///` acima.
  final nomes = RegExp('${RegExp.escape(prefixoDaLinguagem)}([A-Za-z0-9_-]+)\\s*:')
      .allMatches(folha)
      .map((m) => m.group(1)!)
      .toSet()
      .toList()
    ..sort();
  if (nomes.isEmpty) return '';
  final linhas = nomes
      .map((n) => '  $prefixoDaPonte$n: var($prefixoDaLinguagem$n);')
      .join('\n');
  return '\n/* PONTE: os nomes com o prefixo antigo, apontando para os da linguagem.\n'
      '   ${nomes.length} apelidos. Alias não copia valor, então o escuro segue o seletor. */\n'
      ':root {\n$linhas\n}\n';
}
