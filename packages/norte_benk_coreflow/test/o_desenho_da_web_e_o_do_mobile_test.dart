// O QUE A WEB DESENHA É O QUE O MOBILE DESENHA.
//
// Já existe um gate provando que o `.css` no disco é o que o emissor produz. Ele só pega quem edita
// o arquivo à mão. O que ele NÃO pega é o emissor produzir uma coisa e o componente desenhar outra —
// e é essa a classe de defeito que custou caro no primeiro produto desta casa.
//
// Por isso aqui a leitura é pelas MESMAS portas que os widgets usam: `formaDoCartao`,
// `dilettaCorDoPapelGen`. Comparar a saída com a fonte não é o mesmo que comparar a saída com o
// DESENHO.
import 'package:coreflow/coreflow.dart';
import 'package:norte_benk_coreflow/norte_benk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css.dart' show cssDoProduto, tagsDaWeb;

/// As variáveis da folha, por modo. A folha tem vários blocos `:root` — um por família — e varrer
/// por posição pegaria só o primeiro.
Map<String, String> _vars(String css, {required bool escuro}) {
  final fora = <String, String>{};
  var dentro = false;
  var profundidade = 0;
  for (final linha in css.split('\n')) {
    final l = linha.trim();
    if (l.endsWith('{')) {
      profundidade++;
      final sel = l.substring(0, l.length - 1).trim();
      if (sel.isNotEmpty && !sel.startsWith('@')) {
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
    final m = RegExp('${RegExp.escape(prefixoDaLinguagem)}([A-Za-z0-9-]+):\\s*([^;]+);').firstMatch(l);
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

/// QUAIS faces a folha escreve, contra quais o Dart declara.
///
/// Fora do `test` porque o autoteste a alimenta com tabela SINTÉTICA: régua que só sabe rodar contra
/// o produto real só prova os casos que o produto real tem — e um produto recém-nascido não tem
/// nenhum. **A régua chega provada mesmo num produto que ainda não declarou escala.**
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
    // traria a face do vizinho. As faces são quatro e fechadas: casar o nome INTEIRO separa os dois.
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

/// Os degraus que ESTE produto declara, por nome.
///
/// **Nasce vazia de propósito**: um filho recém-nascido não declara escala de tipo — a do avô já vem
/// na folha dele, e emitir de novo seria repetir o que não é nosso. Quando este produto declarar a
/// dele em `tipografia:` e acrescentar o `coreflowTipoCss(...)` em `emite_o_css.dart`, **preencha
/// esta tabela junto**: o gate abaixo reprova se a folha ganhar degrau e esta tabela não.
final _degraus = <String, TextStyle>{};

void main() {
  final css = cssDoProduto();
  final claro = _vars(css, escuro: false);
  final escuro = _vars(css, escuro: true);
  final p = norteBenk.paleta;

  test('a COR de cada papel é a que o componente pinta, nos dois modos', () {
    final divergem = <String>[];
    for (final modo in [
      (nome: 'claro', s: DilettaScheme.light(p), css: claro),
      (nome: 'escuro', s: DilettaScheme.dark(p), css: escuro),
    ]) {
      for (final papel in dilettaNomesDePapelGen) {
        final cor = dilettaCorDoPapelGen(modo.s, papel);
        if (cor == null) continue;
        // Os dois que o esquema do produto sobrescreve de propósito saem com o valor DELE — é assim
        // que o white label acontece na cascata, e a conferência deles é o teste abaixo.
        if (papel == 'primary' || papel == 'border') continue;
        if (modo.css[papel] != _hex(cor)) {
          divergem.add('${modo.nome}/$papel: mobile ${_hex(cor)} × web ${modo.css[papel] ?? "ausente"}');
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
      // Variável e não literal solto: `{` no início de statement o Dart lê como BLOCO, não mapa.
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
    // Forma nova no avô sem entrar na folha é peça web arredondando por conta própria.
    expect(desenho.keys.toSet(), DilettaMedida.formas);
  });

  group('os AJUSTES de papel por componente', () {
    // As tags saem do `node_modules` do pacote web, e uma suíte Dart não pode EXIGIR `npm install`:
    // quem clonar e rodar `flutter test` pegaria vermelho por um passo de outra linguagem. Então:
    // sem tags e sem ajuste declarado, PULA com o motivo escrito; com ajuste declarado, reprova —
    // aí a ausência esconderia a folha saindo sem ele.
    final tags = tagsDaWeb();
    final semTags = tags.isEmpty;
    const porque = 'sem `npm install` em web/ não há lista de tags, e este produto não declara '
        'ajuste — não há o que medir. Rode o install para cobrir.';

    setUp(() {
      if (semTags && norteBenk.ajustesDePapel.isNotEmpty) {
        fail('há ajuste declarado e a lista de tags veio vazia: a folha sairia SEM ele e nada '
            'acusaria. Rode `npm install` em web/.');
      }
    });

    test('o remapeamento da web é o mesmo que o do app', skip: semTags ? porque : null, () {
      // Lista SINTÉTICA de propósito: um gate que só rodasse contra a lista real passaria sem medir
      // nada enquanto este produto não declarar nenhum ajuste.
      const ajustes = [
        DilettaAjusteDePapel(
            componente: 'DilettaButton', de: 'primary', para: 'primaryPressed',
            motivo: MotivoDoAjuste.marca, nota: 'sintético, só para o gate medir'),
      ];
      final base = DilettaScheme.light(p);
      expect(_hex(base.comAjustes(ajustes, 'DilettaButton').primary), _hex(base.primaryPressed),
          reason: 'o app não aplicou o ajuste');
      expect(coreflowAjustesCss(ajustes, tagsWeb: tags),
          contains('diletta-button { ${prefixoDaLinguagem}primary: var(${prefixoDaLinguagem}primaryPressed); }'),
          reason: 'a web não aplicou o ajuste que o app aplica');
    });

    test('nenhum ajuste DESTE produto fica de fora da folha', () {
      final declarados = norteBenk.ajustesDePapel;
      final css = coreflowAjustesCss(declarados, tagsWeb: tags);
      for (final a in declarados.where((a) => tags.contains(tagDaPeca(a.componente)))) {
        expect(css, contains('${tagDaPeca(a.componente)} { ${prefixoDaLinguagem}${a.de}: var(${prefixoDaLinguagem}${a.para}); }'),
            reason: '${a.componente} tem instância web e o ajuste dele não saiu na folha');
      }
    });
  });
  test('a folha não escreve face que o app não declara — nem deixa de escrever a que ele declara',
      () {
    // A GUARDA, e ela é o motivo de este teste existir num produto que ainda não declara escala:
    // com `_degraus` vazia a régua percorreria o nada e aprovaria para sempre — gate que passa sem
    // medir é pior que gate nenhum, porque PARECE proteção. Então, se a folha tem degrau e a tabela
    // não, reprova alto.
    final naFolha = claro.keys.where((k) => k.startsWith('type-')).toSet();
    if (_degraus.isEmpty) {
      expect(naFolha, isEmpty,
          reason: 'a folha emite escala de tipo e a `_degraus` deste gate está vazia — ele está '
              'dormindo sobre ${naFolha.length} declarações. Preencha a tabela com os degraus '
              'que este produto declara.');
      return;
    }
    final erradas = _facesErradas(_degraus, claro);
    expect(erradas, isEmpty,
        reason: 'a folha e o Dart discordam sobre QUAIS faces existem:\n${erradas.join('\n')}\n'
            'Face a mais é opinião que o produto não declarou, e ela silencia o degrau do avô na '
            'cascata. Face a menos é a peça caindo na folha dele sem ninguém saber.');
  });

  group('e a régua acima sabe morder — nas DUAS metades', () {
    // RODAM SEMPRE, inclusive num produto sem escala nenhuma. É exatamente o ponto: a régua chega
    // provada no dia em que o filho nasce, e não no dia em que ele declara a escala dele.
    //
    // Medido no primeiro produto desta casa em 15/09: os 20 degraus dele declaram peso, TODOS. A
    // metade *"não declarou, logo a folha não pode escrever"* nunca foi exercida por produto
    // nenhum — e régua nunca exercida é régua que ninguém sabe se funciona. Aqui ela roda contra
    // tabela sintética com os dois casos, então afrouxá-la reprova mesmo num filho vazio.
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
      // `body` é prefixo de `bodyLg`. Sem casar o nome inteiro, o `bodyLg-size` entraria na conta
      // do `body` e a régua acusaria uma face inventada que não existe.
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
}
