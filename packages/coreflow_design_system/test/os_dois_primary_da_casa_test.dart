import 'dart:io';
import 'dart:math' as math;

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **ESTA CASA TEM DOIS `primary`, E ELES NÃO SÃO O MESMO ROSA NO CLARO.**
///
/// | esquema | claro | escuro |
/// |---|---|---|
/// | `DilettaTheme.schemeOf` (o pai) | `#fe3976` — o rosa da MARCA | `#f66fa0` |
/// | `CoreflowScheme.of` (este produto) | `#9e1241` — o degrau PROFUNDO | `#f66fa0` |
///
/// Não é defeito: são dois PAPÉIS. O profundo existe pra ser tinta sobre claro — foi escolhido pra
/// passar contraste —, e o da marca existe pra ser pintura. **No escuro os dois são o mesmo hex**, e
/// é por isso que uma troca errada aqui sobrevive: ela só aparece num modo.
///
/// Em 02/09 a varredura achou **cinco** peças deste pacote lendo `primary` do pai. Quatro estavam
/// certas — pintura, anel sobre foto, barra cheia, ponto de página, tudo objeto grande ou fundo. Uma
/// estava errada, e o erro era grosso: a faixa de contexto de operação escrevia `labelSm` com o rosa
/// da MARCA sobre a lavagem dele mesmo, **2,63:1**, abaixo dos dois pisos.
void main() {
  double _lum(Color c) {
    double canal(double v) =>
        v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
  }

  double contraste(Color a, Color b) {
    final x = _lum(a), y = _lum(b);
    return ((x > y ? x : y) + 0.05) / ((x < y ? x : y) + 0.05);
  }

  Color sobre(Color frente, Color fundo) =>
      Color.lerp(fundo, frente.withValues(alpha: 1), frente.a)!;

  testWidgets('a faixa de contexto escreve com o degrau PROFUNDO, e passa', (t) async {
    for (final escuro in [false, true]) {
      late Color tinta, lavagem, fundo;
      await t.pumpWidget(MaterialApp(
        key: ValueKey(escuro),
        theme: escuro ? CoreflowTemaMaterial.escuro : CoreflowTemaMaterial.claro,
        home: Builder(builder: (ctx) {
          final c = CoreflowScheme.of(ctx);
          tinta = c.primary;
          lavagem = c.paleta.primary04.withValues(alpha: 0.14);
          fundo = c.background;
          return const SizedBox();
        }),
      ));
      final papel = sobre(lavagem, fundo);
      final r = contraste(tinta, papel);
      expect(r, greaterThanOrEqualTo(4.5),
          reason: 'a faixa é TEXTO pequeno sobre a lavagem dela mesma, e o piso é 4,5. '
              '${escuro ? "escuro" : "claro"}: ${r.toStringAsFixed(2)}:1');
    }
  });

  testWidgets('e escrever com o rosa da MARCA reprovaria — o controle', (t) async {
    // Sem este par, o teste acima passaria com qualquer rosa escuro e não diria nada sobre a
    // ESCOLHA. Ele existe pra provar que o piso é apertado o bastante pra pegar o defeito real.
    late Color marca, lavagem, fundo;
    await t.pumpWidget(MaterialApp(
      theme: CoreflowTemaMaterial.claro,
      home: Builder(builder: (ctx) {
        final c = CoreflowScheme.of(ctx);
        marca = c.paleta.primary04;
        lavagem = c.paleta.primary04.withValues(alpha: 0.14);
        fundo = c.background;
        return const SizedBox();
      }),
    ));
    expect(contraste(marca, sobre(lavagem, fundo)), lessThan(3),
        reason: 'era o que estava no ar até 02/09');
  });

  test('quem lê o `primary` do PAI está declarado, e o quinto tem que se explicar', () {
    // Os quatro legítimos, e o que os torna legítimos é o mesmo: nenhum deles é TINTA sobre claro.
    const legitimos = {
      'lib/src/bold_autorizacao.dart': 'o tom da barra de progresso — superfície CHEIA, e o que '
          'precisa de contraste é o que vai por cima dela, não ela contra o fundo.',
      'lib/src/bold_cabecalho_da_home.dart': 'o anel do avatar quando há foto. O contraste é contra '
          'a FOTO, que é conteúdo arbitrário: nenhum dos dois rosas ganha essa por número.',
      'lib/src/bold_nav_flutuante.dart': 'o preenchimento da aba ativa — pintura, e a marca é o que '
          'ela tem que dizer.',
      'lib/src/bold_pontos_de_pagina.dart': 'o ponto da página atual. Objeto gráfico, piso 3,0, e o '
          'rosa da marca dá 3,46:1 sobre branco.',
    };
    final lendo = <String>{};
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final s = f.readAsStringSync();
      final vars = RegExp(r'final\s+(\w+)\s*=\s*DilettaTheme\.scheme\w*\(')
          .allMatches(s)
          .map((m) => m.group(1)!)
          .toSet();
      for (final v in vars) {
        if (RegExp('\\b$v\\.primary\\b').hasMatch(s)) lendo.add(f.path);
      }
      if (RegExp(r'DilettaTheme\.scheme\w*\([^)]*\)\.primary\b').hasMatch(s)) lendo.add(f.path);
    }
    expect(lendo.difference(legitimos.keys.toSet()), isEmpty,
        reason: 'peça nova lendo o `primary` do PAI. Se ela PINTA, declare aqui com a razão; se ela '
            'escreve, o `primary` é o daqui — o profundo — e o gate de contraste acima é o motivo.');
    expect(legitimos.keys.toSet().difference(lendo), isEmpty,
        reason: 'declarado aqui e não lê mais — razão escrita sobre peça que mudou é documentação '
            'mentindo');
  });

  test('todo glifo que este pacote pede do PAI existe no pai', () {
    // Duas portas, e só uma tem tradutor. `CoreflowIcone` passa pelo mapa de apelidos deste produto
    // (`chevron-right` → `angle-right-light`); `DilettaIcon` fala com o pai DIRETO.
    //
    // A faixa de contexto pedia `chevron-right` pelo `DilettaIcon`, e o pai foi buscar
    // `assets/icons/chevron-right.svg.vec`, que não existe. **A seta não desenhava — sem erro, sem
    // log.** A affordância de "isto é tocável" era invisível, e nenhum teste via, porque widget que
    // não pinta ainda está lá na árvore.
    final cfg = File('.dart_tool/package_config.json');
    final raiz = cfg.absolute.uri.resolve(
        '${RegExp(r'"name":"diletta_design_system","rootUri":"([^"]+)"').firstMatch(cfg.readAsStringSync().replaceAll(RegExp(r'\s+'), ''))!.group(1)}/');
    final noPai = Directory.fromUri(raiz.resolve('assets/icons/'))
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last.replaceAll('.svg.vec', ''))
        .toSet();
    expect(noPai, isNotEmpty, reason: 'não achei os glifos do pai — a régua está medindo o vazio');

    final fonteDoApelido = File('lib/src/bold_icone.dart').readAsStringSync();
    final apelidos = RegExp(r"'([a-z0-9-]+)':\s*'[a-z0-9-]+'")
        .allMatches(fonteDoApelido)
        .map((m) => m.group(1)!)
        .toSet();

    final quebrados = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final s = f.readAsStringSync();
      for (final m in RegExp(r"DilettaIcon\(\s*name:\s*'([a-z0-9-]+)'").allMatches(s)) {
        if (!noPai.contains(m.group(1))) {
          quebrados.add('${f.path}: DilettaIcon(\'${m.group(1)}\') — o pai não tem esse asset');
        }
      }
      for (final m in RegExp(r"CoreflowIcone\(\s*'([a-z0-9-]+)'").allMatches(s)) {
        final n = m.group(1)!;
        if (!noPai.contains(n) && !apelidos.contains(n)) {
          quebrados.add('${f.path}: CoreflowIcone(\'$n\') — nem asset do pai, nem apelido do mapa');
        }
      }
    }
    expect(quebrados, isEmpty, reason: quebrados.join('\n'));
  });
}
