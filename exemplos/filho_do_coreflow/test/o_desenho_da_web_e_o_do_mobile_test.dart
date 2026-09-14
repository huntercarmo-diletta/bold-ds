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
import 'package:meu_banco_coreflow/meu_banco.dart';
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

void main() {
  final css = cssDoProduto();
  final claro = _vars(css, escuro: false);
  final escuro = _vars(css, escuro: true);
  final p = meuBanco.paleta;

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
      if (semTags && meuBanco.ajustesDePapel.isNotEmpty) {
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
          contains('diletta-button { --cps-primary: var(--cps-primaryPressed); }'),
          reason: 'a web não aplicou o ajuste que o app aplica');
    });

    test('nenhum ajuste DESTE produto fica de fora da folha', () {
      final declarados = meuBanco.ajustesDePapel;
      final css = coreflowAjustesCss(declarados, tagsWeb: tags);
      for (final a in declarados.where((a) => tags.contains(tagDaPeca(a.componente)))) {
        expect(css, contains('${tagDaPeca(a.componente)} { --cps-${a.de}: var(--cps-${a.para}); }'),
            reason: '${a.componente} tem instância web e o ajuste dele não saiu na folha');
      }
    });
  });
}
