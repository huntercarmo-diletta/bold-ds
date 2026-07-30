import 'dart:ui';
import 'dart:io';

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A FRONTEIRA ENTRE A LINGUAGEM E A IDENTIDADE — agora garantida pelo COMPILADOR.
///
/// Este arquivo mudou de trabalho quando o design system se partiu em dois pacotes, e
/// vale registrar o antes e o depois: é a diferença entre uma regra que se verifica e
/// uma regra que se obedece.
///
/// - **antes**: pai e filho num pacote só. A fronteira existia na cabeça de quem
///   escrevia, e um teste varria os arquivos procurando `CpfSeguroColors` e
///   companhia. Ele funcionava — e a fronteira vazou duas vezes de qualquer forma:
///   `onPartner: CpfSeguroColors.partnerOnPrimary` dentro do `scheme`, e
///   `DilettaTheme.of()` caindo em `cpfLight` quando não havia scope. Nenhum dos dois
///   quebrava nada visível;
/// - **agora**: `diletta_design_system` não declara dependência nenhuma pro filho.
///   Escrever `CpfSeguroColors` aqui não passa do compilador — o nome não existe.
///
/// Então o que sobrou pra este teste é exatamente o que o compilador NÃO garante.
///
/// ## A dívida que motivou isso, pra quem for ler depois
///
/// A medição inicial foi **382 usos de primitiva crua em 65 dos 100 componentes** —
/// componente lendo o VALOR de uma marca em vez do papel semântico. Duas
/// consequências, uma causa: a identidade de um filho não chegava no componente, e o
/// dark mode não o alcançava, porque primitiva é fixa.
///
/// Foi 382 → 112 → 62 → 0. O terceiro salto não foi trabalho de componente: foi
/// separar cor-que-ninguém-é-dono (branco, sombras) de valor-de-marca, porque a
/// contagem misturada não respondia nada — parte dela nunca ia cair. E o último foi
/// derrubar um piso que eu mesmo havia declarado: escrevi que 10–20 casos eram
/// impossíveis por serem construtores de valor estáticos "sem acesso ao tema".
/// Construtor de valor devolve um WIDGET, e widget tem `build` —
/// [DilettaTheme.comEsquema] resolveu os quatro.
///
/// O gate que media aquilo saiu de cena quando os pacotes se separaram: medir por
/// regex o que o compilador proíbe é cerimônia.
void main() {
  test('o PAI não depende de nenhum filho', () {
    // O gate mais importante deste arquivo, e o único que o compilador não dá: nada
    // impede alguém de ADICIONAR a dependência. No dia em que isso acontecer, todo
    // `CpfSeguroColors` volta a compilar aqui dentro e a fronteira acaba sem barulho.
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final deps = pubspec.split('dev_dependencies:').first;
    final suspeitas =
        ['cpf_seguro', 'bold', 'conta_bold'].where(deps.contains).toList();
    expect(suspeitas, isEmpty,
        reason: 'a linguagem passou a depender de um produto: $suspeitas.\n'
            'O fluxo é o contrário — o filho depende do pai. Se o pai precisa de algo '
            'que só o filho tem, isso é PLUGUE (ver DilettaBrandAssets), não '
            'dependência.');
  });

  test('o default da linguagem não é a marca de ninguém', () {
    // `resolve()` sem argumento e `of()` sem scope caíam no tema do CPF SEGURO. Um
    // filho que esquecesse de envolver uma tela receberia a marca do PRIMEIRO filho,
    // e a tela renderizaria bonita — então ninguém descobriria.
    expect(DilettaTheme.resolve().palette.id, 'referencia');
    expect(DilettaTheme.referenciaLight.palette.id, 'referencia');
  });

  test('a paleta de REFERÊNCIA existe e não é marca de produto', () {
    // Ela é o que torna verificável a frase "a linguagem serve qualquer marca": uma
    // rampa coerente e de ninguém. É com ela que o catálogo mede vazamento de marca.
    const r = DilettaPalette.referencia;
    expect(r.id, 'referencia');
    expect(r.primary04, isNot(const Color(0xFF003BE0)),
        reason: 'a referência não pode ser o azul do CPF SEGURO — senão o teste de '
            'vazamento do catálogo não mede nada');

    // AS SUPERFÍCIES DO ESCURO entram na lista, e a razão é a cicatriz: elas ficaram cravadas em
    // hex no `DilettaScheme.dark` e o teste de vazamento não olhava pra lá — a lista tinha só as
    // cores de MARCA, e superfície não é marca até alguém escolher um navy.
    const superficiesDoPrimeiroFilho = [0xFF0B1020, 0xFF161C2E, 0xFF212A42];
    final escuro = DilettaScheme.dark(r);
    for (final cor in [escuro.bg, escuro.bgMenu, escuro.surface, escuro.surfaceMuted]) {
      expect(superficiesDoPrimeiroFilho.contains(cor.toARGB32()), isFalse,
          reason: 'superfície do escuro voltou a ser hex de um filho');
    }
  });

  test('as SUPERFÍCIES do escuro e o tinte do vidro vêm da paleta', () {
    // Sem declarar, saem da rampa neutra — neutro e serve. Declarado, a marca decide: o navy do
    // primeiro filho e o wine-ink do segundo são decisões de design, não default de motor. Antes o
    // pai escolhia por todos, em hex.
    const p = DilettaPalette.referencia;
    final escuro = DilettaScheme.dark(p);
    expect(escuro.bg, p.neutral01);
    expect(escuro.surface, p.neutral02);
    expect(escuro.surfaceMuted, p.neutral03);
    expect(escuro.glassTint, p.neutral01.withValues(alpha: 0.8),
        reason: 'o vidro do segundo filho é tingido de vinho, e com o literal do pai saía neutro');
    expect(DilettaScheme.light(p).glassTint, p.white.withValues(alpha: 0.8));
  });

  test('o dado TÉCNICO tem degrau pequeno, e todos são tabulares', () {
    // Promoção por evidência de dois filhos: dado técnico (CPF, chave, valor) é a fonte da marca com
    // dígitos tabulares, não outra família. O pai só tinha o degrau de 22; sem 13 e 11 o segundo
    // filho recriaria o estilo dentro dele, e a família se partiria em duas.
    for (final estilo in [DilettaType.numeric, DilettaType.numericSm, DilettaType.numericXs]) {
      expect(estilo.fontFeatures, contains(const FontFeature.tabularFigures()),
          reason: 'numa lista, dígito de largura variável faz a coluna dançar');
    }
    expect(DilettaType.numericSm.fontSize, 13);
    expect(DilettaType.numericXs.fontSize, 11);
  });

  test('o tema da linguagem vem SEM marca', () {
    // Se a marca tivesse default, o default só poderia ser o de um filho — e aí o pai
    // trataria o segundo filho como exceção.
    //
    // Ela é um VALOR no tema, e não um singleton com `configurar()`. A primeira versão
    // era singleton, e o teste que eu escrevi pra ela falhou: `static final` em Dart
    // inicializa uma vez, então depois de um reset o filho não reinstalava e o
    // resultado passava a depender da ordem de execução. Identidade viaja no scope,
    // como a paleta sempre viajou.
    expect(DilettaTheme.resolve().brand.instalada, isFalse);
    expect(DilettaTheme.referenciaLight.brand.logoParceiro, isNull,
        reason: 'logo de parceiro é do produto; o pai não tem um padrão');
  });
}
