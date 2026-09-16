// O QUE A WEB DESENHA É O QUE O MOBILE DESENHA.
//
// Este é o gate que faltava, e a falta foi medida duas vezes no mesmo dia. Já existe um gate
// provando que o `.css` no disco é o que o emissor produz — mas isso só pega quem edita o arquivo à
// mão. O que ele NÃO pega é o emissor produzir uma coisa e o componente desenhar outra, que é
// exatamente o que aconteceu:
//
//   1. `coreflowMedidasCss` lia a const `CoreflowRadius.sheet`. Um produto declarando 8 veria a
//      folha do app em 8 e a da web em 22;
//   2. depois, lia `medidaDe` cru, que consulta só a tabela de medidas e pula o alias `raioDeX`. O
//      produto desta casa declara `raioDeBotao: 16` e a web emitia a pílula.
//
// As duas passaram pelo gate do disco: o arquivo batia com o emissor, e o emissor é que estava
// errado. **Comparar a saída com a fonte não é o mesmo que comparar a saída com o DESENHO.**
//
// Por isso este arquivo lê pelas MESMAS APIs que os widgets leem — `formaDoCartao`,
// `dilettaCorDoPapelGen`, `CoreflowType.x` — e não pelo caminho que o emissor usou.
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css_do_bold.dart' show cssDoBold, tagsDaWeb;

/// As variáveis da folha, por MODO.
///
/// A folha tem vários blocos `:root` — um por família (cor, esquema, medida, tipo) — e três
/// seletores de modo. Varrer por posição pegaria só o primeiro, que foi o defeito da primeira versão
/// deste gate: ele reprovou tudo e a culpa era da leitura, não da folha.
///
/// [escuro] junta o que está em `:root[data-theme="dark"]`; [claro] junta o que está em `:root`
/// simples, que é onde as famílias sem modo (medida, tipo) também moram.
Map<String, String> _vars(String css, {required bool escuro}) {
  final fora = <String, String>{};
  final linhas = css.split('\n');
  var dentro = false;
  var profundidade = 0;
  for (final linha in linhas) {
    final l = linha.trim();
    if (l.endsWith('{')) {
      profundidade++;
      final sel = l.substring(0, l.length - 1).trim();
      if (sel.isNotEmpty && !sel.startsWith('@')) {
        // `:root` simples é o claro; `:root[data-theme="dark"]` é o escuro declarado. O
        // `:root:not([data-theme="light"])` dentro do `@media` é o MESMO escuro, e fica de fora pra
        // não contar duas vezes — o gate mede o que o seletor declara, não a preferência do sistema.
        dentro = escuro ? sel == ':root[data-theme="dark"]' : sel == ':root';
      }
      continue;
    }
    if (l == '}') {
      profundidade--;
      if (profundidade <= 0) dentro = false;
      continue;
    }
    if (!dentro) continue;
    final m = RegExp(r'--cps-([A-Za-z0-9-]+):\s*([^;]+);').firstMatch(l);
    if (m != null) fora[m.group(1)!] = m.group(2)!.trim();
  }
  return fora;
}

String _hex(Color c) {
  final argb = c.toARGB32();
  final rgb = argb.toRadixString(16).padLeft(8, '0').substring(2);
  final a = (argb >> 24) & 0xFF;
  return a == 0xFF ? '#$rgb' : '#$rgb${a.toRadixString(16).padLeft(2, '0')}';
}

String _px(double v) => v == v.roundToDouble() ? '${v.round()}px' : '${v}px';

/// QUAIS faces a folha escreve, contra quais o Dart declara — a régua, fora do `test`.
///
/// Fora porque o autoteste precisa alimentá-la com uma tabela SINTÉTICA: régua que só sabe rodar
/// contra o produto real só prova os casos que o produto real tem.
///
/// [folha] é o mapa de variáveis do CSS, com as chaves como saem do seletor (`type-<degrau>-<face>`).
List<String> _facesErradas(Map<String, TextStyle> degraus, Map<String, String> folha) {
  const faces = ['size', 'weight', 'line-height', 'spacing'];
  final erradas = <String>[];
  for (final e in degraus.entries) {
    // `size` e `line-height` saem SEMPRE — tamanho é obrigatório e altura nula vira `normal`, que é
    // instrução e não invenção (veja o `///` do `coreflowTipoCss`). As outras duas saem se, e
    // somente se, o Dart as declarar.
    final esperadas = {
      '${e.key}-size',
      '${e.key}-line-height',
      if (e.value.fontWeight != null) '${e.key}-weight',
      if (e.value.letterSpacing != null) '${e.key}-spacing',
    };
    // Nome de degrau é prefixo de nome de degrau (`body` está em `bodyLg`), então casar por começo
    // traria a face do vizinho. As faces são quatro e fechadas: casar o nome INTEIRO separa
    // `body-size` de `bodyLg-size` sem depender da ordem em que a folha foi escrita.
    final naFolha = {
      for (final f in faces)
        if (folha.containsKey('type-${e.key}-$f')) '${e.key}-$f',
    };
    for (final a in naFolha.difference(esperadas)) {
      erradas.add('$a: a folha escreve e o app NÃO declara');
    }
    for (final f in esperadas.difference(naFolha)) {
      erradas.add('$f: o app declara e a folha NÃO escreve');
    }
  }
  return erradas;
}

/// Os 20 degraus do produto, por nome — a MESMA tabela para os dois testes de tipo.
///
/// Fora do `test` porque dois testes a leem: o que confere VALOR e o que confere QUAIS FACES saem.
/// Duas cópias divergiriam no primeiro degrau novo, e a divergência entre gate e gate é a que
/// ninguém percebe.
final _degraus = <String, TextStyle>{
  'display': CoreflowType.display, 'valorHeroi': CoreflowType.valorHeroi,
  'h1': CoreflowType.h1, 'h2': CoreflowType.h2,
  'headlineMd': CoreflowType.headlineMd, 'headlineSm': CoreflowType.headlineSm,
  'title': CoreflowType.title, 'titleMd': CoreflowType.titleMd,
  'body': CoreflowType.body, 'bodyLg': CoreflowType.bodyLg,
  'bodySm': CoreflowType.bodySm, 'bodySmall': CoreflowType.bodySmall,
  'button': CoreflowType.button, 'label': CoreflowType.label,
  'labelLg': CoreflowType.labelLg, 'labelMd': CoreflowType.labelMd,
  'labelSm': CoreflowType.labelSm, 'tileLabel': CoreflowType.tileLabel,
  'mono': CoreflowType.mono, 'monoCaption': CoreflowType.monoCaption,
};

void main() {
  final css = cssDoBold();
  final claro = _vars(css, escuro: false);
  final escuro = _vars(css, escuro: true);
  const p = BoldPalette.bold;

  test('a COR de cada papel é a que o componente pinta, nos dois modos', () {
    final divergem = <String>[];
    for (final modo in [
      (nome: 'claro', s: DilettaScheme.light(p), css: claro),
      (nome: 'escuro', s: DilettaScheme.dark(p), css: escuro),
    ]) {
      for (final papel in dilettaNomesDePapelGen) {
        final cor = dilettaCorDoPapelGen(modo.s, papel);
        if (cor == null) continue;
        final naWeb = modo.css[papel];
        // Os dois papéis que o esquema do produto sobrescreve de propósito saem com o valor DELE,
        // e é assim que o white label acontece na cascata — a conferência deles é o teste abaixo.
        if (papel == 'primary' || papel == 'border') continue;
        if (naWeb != _hex(cor)) {
          divergem.add('${modo.nome}/$papel: mobile ${_hex(cor)} × web ${naWeb ?? "ausente"}');
        }
      }
    }
    expect(divergem, isEmpty, reason: 'a web pinta diferente do app:\n${divergem.join('\n')}');
  });

  test('os papéis do ESQUEMA do produto também, e são eles que ganham na cascata', () {
    for (final modo in [
      (nome: 'claro', b: Brightness.light, css: claro),
      (nome: 'escuro', b: Brightness.dark, css: escuro),
    ]) {
      final s = CoreflowScheme.de(p, brilho: modo.b);
      final esperado = {
        'background': s.background, 'secondaryFlow': s.secondaryFlow,
        'textPrimary': s.textPrimary, 'border': s.border, 'overlay': s.overlay,
        'primary': s.primary, 'danger': s.danger, 'infoSubtle': s.infoSubtle, 'vinho': s.vinho,
      };
      esperado.forEach((papel, cor) {
        expect(modo.css[papel], _hex(cor),
            reason: '${modo.nome}/$papel: a web não pinta o que o esquema do produto diz');
      });
    }
  });

  test('a FORMA de cada família é a que o componente arredonda', () {
    final a = DilettaScheme.light(p);
    final nosso = CoreflowScheme.de(p, brilho: Brightness.light);
    // As mesmas APIs que os widgets chamam. Ler por aqui é o que faz este gate valer: o emissor
    // errou duas vezes justamente por ler por outro caminho.
    final desenho = {
      DilettaMedida.formaDeBotao: a.formaDoBotao,
      DilettaMedida.formaDeFolha: nosso.formaDaFolha,
      DilettaMedida.formaDeCampo: a.formaDoCampo,
      DilettaMedida.formaDeCartao: a.formaDoCartao,
      DilettaMedida.formaDeVidro: a.formaDoVidro,
      DilettaMedida.formaDeNav: a.formaDaNav,
    };
    desenho.forEach((papel, raio) {
      expect(claro[papel], _px(raio.topLeft.x),
          reason: '$papel: o app arredonda ${_px(raio.topLeft.x)} e a web diz ${claro[papel]}');
    });
    // E o conjunto FECHADO: forma nova no avô sem entrar na folha é peça web que arredonda por
    // conta própria. Este número sobe por veredito, como todo campo do plugue.
    expect(desenho.keys.toSet(), DilettaMedida.formas,
        reason: 'o avô tem forma que a folha não emite, ou a folha emite uma que ele não tem');
  });

  test('o TIPO de cada degrau é o que o componente escreve', () {
    final divergem = <String>[];
    _degraus.forEach((nome, e) {
      final tamanho = e.fontSize!;
      final conferir = {
        '$nome-size': _px(tamanho),
        // ALTURA NULA É `normal`, NÃO `1 ×`. Nulo no Flutter quer dizer *a caixa natural da fonte*,
        // e a primeira versão daqui — e do emissor — traduzia por `1 ×`. Medido em 15/09 com a Inter
        // carregada dos dois lados: cinco degraus saíam 2 a 4px mais apertados na web POR LINHA
        // (`title` 21×17, `button` 18×15, `label` 15×12, `mono` 16×13, `monoCaption` 13×11). Com
        // `normal` a maior diferença que sobra é 0,5px, e ela é o Flutter arredondando a caixa pra
        // pixel inteiro onde o navegador guarda a fração — conferido no navegador, degrau a degrau.
        '$nome-line-height': e.height == null ? 'normal' : _px(e.height! * tamanho),
        if (e.fontWeight != null) '$nome-weight': '${e.fontWeight!.value}',
        if (e.letterSpacing != null) '$nome-spacing': _px(e.letterSpacing!),
      };
      conferir.forEach((chave, valor) {
        if (claro['type-$chave'] != valor) {
          divergem.add('$chave: app $valor × web ${claro['type-$chave'] ?? "ausente"}');
        }
      });
    });
    expect(divergem, isEmpty, reason: 'a web escreve diferente do app:\n${divergem.join('\n')}');
  });

  test('a folha não escreve face que o app não declara — nem deixa de escrever a que ele declara', () {
    // O IRMÃO do teste acima, e a falta dele foi medida em 15/09. Aquele anda as faces que o Dart
    // DECLARA e confere o valor de cada uma; o que ele não faz é olhar o caminho de volta — **o que
    // a folha escreveu e o Dart não pediu**.
    //
    // Provado na travessura: fiz o emissor escrever `spacing` para todo degrau (`letterSpacing ?? 0`),
    // reemiti a folha como faria quem fez a mudança de boa-fé, e **7 trackings inventados entraram
    // com as 220 verificações verdes**. Um `0px` inventado não é inofensivo: onde o app não declara
    // tracking, quem manda é o degrau homônimo do avô por cascata, e um `0` nosso o silencia.
    //
    // É a mesma classe do defeito do dia — ali o emissor inventou `1 ×` onde o Dart não declarava
    // altura. A diferença é a face: aquele inventava valor ERRADO numa face declarada, este inventa
    // uma face INTEIRA. Um gate que só confere o declarado nunca vê o segundo.
    //
    // `size` e `line-height` saem SEMPRE — tamanho é obrigatório e altura nula vira `normal`, que é
    // instrução e não invenção (veja o `///` do `coreflowTipoCss`). `weight` e `spacing` saem se, e
    // somente se, o Dart os declarar.
    final erradas = _facesErradas(_degraus, claro);
    expect(erradas, isEmpty,
        reason: 'a folha e o Dart discordam sobre QUAIS faces existem:\n${erradas.join('\n')}\n'
            'Face a mais é opinião que o produto não declarou, e ela silencia o degrau do avô na '
            'cascata. Face a menos é a peça caindo na folha dele sem ninguém saber.');
  });

  test('o GRADIENTE da web é a mesma curva que o app desenha', () {
    // A curva sai do ARQUIVO DO SÍMBOLO, parada por parada, e o `///` do `CoreflowGradients` conta o
    // preço de errá-la: as paradas foram declaradas sem offset um dia, o Flutter as distribuiu
    // igualmente, e o coral foi parar em 0,5 quando no símbolo ele está em 0,60 — a curva da UI e a
    // do logo ficaram diferentes no mesmo dia em que alguém disse que tinham voltado a ser a mesma.
    //
    // A falta da emissão foi medida no consumidor: o IB pinta SETE peças com o degradê da marca, e
    // não havia de onde tirá-lo. A saída que sobrava era declarar tinta de marca no repo de quem
    // consome, que é o que a ADR-007 proíbe.
    final css = coreflowGradientesCss(ContaBold.gradientes);
    final g = ContaBold.gradientes;

    // TODA parada do app aparece na folha, na ordem e com o offset dela.
    for (var i = 0; i < g.primary.colors.length; i++) {
      final cor = _hex(g.primary.colors[i]);
      final pct = (g.primary.stops![i] * 100).round();
      expect(css, contains('$cor $pct%'),
          reason: 'a parada $i da curva do símbolo não saiu na folha');
    }
    expect(g.primary.colors, hasLength(g.primary.stops!.length),
        reason: 'parada sem offset é o defeito de 20/08 voltando: o navegador distribui igual');

    // E a TINTA que vai por cima, que é o que destravou o lockup.
    expect(css, contains('--cps-onGradiente: ${_hex(g.tintaSobreOGradiente)}'));
  });

  test('o ÂNGULO do CSS é o mesmo traço do Flutter, e os dois eixos continuam DIFERENTES', () {
    // `Alignment` vai de -1 a 1 com o Y crescendo pra BAIXO; o `deg` do CSS mede do topo, no sentido
    // horário. Converter de cabeça erra o sinal do Y — e erro de sinal num gradiente diagonal é a
    // curva espelhada, que ninguém percebe olhando um quadrado pequeno.
    //
    // O eixo é CRAVADO na classe (o construtor recebe só as paradas), então não dá para montar um
    // gradiente vertical de controle. O controle que serve é outro, e é melhor: **os dois
    // gradientes têm eixos diferentes no Dart** — `primary` vai de (-0,8,-1) a (0,8,1) e `accent` de
    // (-0,7,-1) a (0,7,1). Um conversor quebrado que devolvesse constante daria o MESMO número para
    // os dois, e passaria por qualquer teste que olhasse um só.
    final css = coreflowGradientesCss(ContaBold.gradientes);
    final graus = RegExp(r'gradiente-(\w+): linear-gradient\((\d+)deg')
        .allMatches(css)
        .map((m) => (nome: m.group(1)!, g: int.parse(m.group(2)!)))
        .toList();
    expect(graus, hasLength(2));
    for (final x in graus) {
      // Descendo da esquerda-alta para a direita-baixa: mais de 90° e menos de 180° no CSS.
      expect(x.g, greaterThan(90), reason: '${x.nome} aponta para cima — o sinal do Y inverteu');
      expect(x.g, lessThan(180), reason: '${x.nome} passou da vertical');
    }
    expect(graus[0].g, isNot(graus[1].g),
        reason: 'os dois eixos são diferentes no Dart e saíram iguais: o conversor virou constante');
  });

  group('e a régua acima sabe morder — nas DUAS metades', () {
    // A REGRA TEM DUAS METADES, e o PESO exercita só uma. Medido em 15/09: os 20 degraus do Bold
    // declaram peso, todos. O `spacing` tem os dois casos (13 declaram, 7 não) e por isso a régua
    // rodando contra o produto já o cobre — provado por mutação, 7 acusações. O `weight` não tem o
    // segundo caso neste produto.
    //
    // **E isso não é ponto cego: é ausência de caso.** Conferi antes de afirmar. Mandei o emissor
    // escrever peso sempre (`fontWeight ?? w400`) e a folha saiu **byte a byte idêntica**, 284
    // declarações — com os vinte declarando peso, o `??` nunca dispara. Não havia o que acusar, e o
    // verde estava certo. A primeira leitura que eu fiz disso foi "o gate tem uma porta aberta", e
    // ela estava errada: o que a mutação provou é que ela era inerte, não que o gate era cego.
    //
    // O que ESTE grupo protege não é o Bold — é o PRÓXIMO produto. Um filho com um degrau sem peso
    // declarado cai numa metade da régua que nenhum produto desta casa jamais exerceu, e régua nunca
    // exercida é régua que ninguém sabe se funciona. Aqui ela roda contra uma tabela sintética com
    // os dois casos: afrouxar `_facesErradas` reprova mesmo que o Bold siga declarando peso nos 20.
    const semPeso = TextStyle(fontSize: 12);
    const comPeso = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);

    test('face a MAIS: o app não declara peso e a folha escreve um', () {
      expect(
        _facesErradas({'sintetico': semPeso}, {
          'type-sintetico-size': '12px',
          'type-sintetico-line-height': 'normal',
          'type-sintetico-weight': '400',
        }),
        ['sintetico-weight: a folha escreve e o app NÃO declara'],
      );
    });

    test('face a MENOS: o app declara peso e a folha não escreve', () {
      expect(
        _facesErradas({'sintetico': comPeso},
            {'type-sintetico-size': '12px', 'type-sintetico-line-height': 'normal'}),
        ['sintetico-weight: o app declara e a folha NÃO escreve'],
      );
    });

    test('e o caso limpo não acusa nada — senão a régua gritaria sempre', () {
      expect(
        _facesErradas({'sintetico': semPeso},
            {'type-sintetico-size': '12px', 'type-sintetico-line-height': 'normal'}),
        isEmpty,
      );
    });

    test('o vizinho de nome mais longo não conta como face deste', () {
      // `body` é prefixo de `bodyLg`. Sem casar o nome inteiro, o `bodyLg-size` da folha entraria na
      // conta do `body` e a régua acusaria uma face inventada que não existe.
      expect(
        _facesErradas({'body': semPeso}, {
          'type-body-size': '15px',
          'type-body-line-height': 'normal',
          'type-bodyLg-size': '16px',
          'type-bodyLg-line-height': '24px',
          'type-bodyLg-weight': '500',
        }),
        isEmpty,
      );
    });
  });

  group('os AJUSTES de papel por componente', () {
    // AS TAGS VÊM DO `node_modules` do pacote web, e uma suíte Dart não pode EXIGIR `npm install`:
    // quem clonar o repo e rodar `flutter test` pegaria vermelho por um passo de outra linguagem,
    // que não tem a ver com o que veio fazer.
    //
    // Então a régua é a estreita: **sem as tags, pula — a não ser que haja ajuste declarado.** Com
    // ajuste declarado e sem tags, a emissão sairia vazia e o gate aprovaria em silêncio, que é
    // exatamente a falha que ele existe pra impedir. Aí reprova, e reprova alto.
    final tags = tagsDaWeb();
    final semTags = tags.isEmpty;
    const semTagsPorque = 'sem `npm install` em coreflow_design_system_web não há lista de tags. '
        'Este produto não declara ajuste, então não há o que medir — rode o install para cobrir.';

    setUp(() {
      if (semTags && ContaBold.produto.ajustesDePapel.isNotEmpty) {
        fail('há ajuste declarado e a lista de tags veio vazia: a folha sairia SEM ele e nada '
            'acusaria. Rode `npm install` em coreflow_design_system_web.');
      }
    });
    // O eixo que deixa um produto dizer "neste componente, o papel X passa a ler o Y", com `de` e
    // `para` da mesma família e um motivo declarado. No Flutter é `scheme.comAjustes(...)`; na web é
    // cascata dentro do elemento. Os dois têm que remapear a MESMA coisa.
    //
    // Este produto declara ZERO ajustes hoje, por decisão medida e escrita
    // (`docs/avisos/2026-08-12-o-ajuste-de-papel-RESPOSTA.md`: sem parceiro, não há caso de `marca`;
    // e o único caso de `contraste` a casa já decidiu ao contrário). Um gate que só rodasse contra a
    // lista real passaria sem medir nada — por isso o primeiro teste usa uma lista SINTÉTICA.

    test('o remapeamento da web é o mesmo que o do app', skip: semTags ? semTagsPorque : null, () {
      const ajustes = [
        DilettaAjusteDePapel(
            componente: 'DilettaButton',
            de: 'primary',
            para: 'primaryPressed',
            motivo: MotivoDoAjuste.marca,
            nota: 'sintético, só para o gate medir'),
      ];
      final base = DilettaScheme.light(p);
      final comAjuste = base.comAjustes(ajustes, 'DilettaButton');

      // MOBILE: no componente ajustado, `primary` passa a valer o que `primaryPressed` vale.
      expect(_hex(comAjuste.primary), _hex(base.primaryPressed),
          reason: 'o app não aplicou o ajuste — o eixo do Flutter parou de funcionar');
      // E fora dele, nada muda. Ajuste é por componente, não global.
      expect(_hex(base.primary), isNot(_hex(base.primaryPressed)));

      // WEB: a mesma troca, como alias dentro da tag. Alias e não cor: a folha tem que seguir
      // `primaryPressed` quando ele mudar, e cor copiada aqui divergiria na próxima paleta.
      final css = coreflowAjustesCss(ajustes, tagsWeb: tags);
      expect(css, contains('diletta-button { --cps-primary: var(--cps-primaryPressed); }'),
          reason: 'a web não aplicou o ajuste que o app aplica');
    });

    test('ajuste em peça sem instância web não some calado — some por não existir lá',
        skip: semTags ? semTagsPorque : null, () {
      // `CoreflowSaldo` é do pai e só tem lado Flutter. Ajustar nela não tem o que emitir, e isso
      // não é divergência: é peça que não existe na web. O que seria divergência é uma peça QUE
      // EXISTE ficar de fora — e é isso que a conta abaixo separa.
      const ajustes = [
        DilettaAjusteDePapel(
            componente: 'CoreflowSaldo',
            de: 'surface',
            para: 'surfaceMuted',
            motivo: MotivoDoAjuste.marca,
            nota: 'sintético'),
      ];
      expect(tags.contains(tagDaPeca('CoreflowSaldo')), isFalse);
      expect(coreflowAjustesCss(ajustes, tagsWeb: tags), isEmpty);
    });

    test('nenhum ajuste DESTE produto fica de fora da folha', () {
      // A catraca de verdade: roda contra a lista real. Hoje ela é vazia e isto passa de graça — e
      // no dia em que alguém declarar um ajuste numa peça que EXISTE na web, este teste é o que
      // cobra a folha acompanhar.
      final declarados = ContaBold.produto.ajustesDePapel;
      final deveriamSair =
          declarados.where((a) => tags.contains(tagDaPeca(a.componente))).toList();
      final css = coreflowAjustesCss(declarados, tagsWeb: tags);
      for (final a in deveriamSair) {
        expect(css, contains('${tagDaPeca(a.componente)} { --cps-${a.de}: var(--cps-${a.para}); }'),
            reason: '${a.componente} tem instância web e o ajuste dele não saiu na folha');
      }
    });
  });
}
