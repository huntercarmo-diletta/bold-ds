/// CONFORMIDADE DO DS — o pai entrega os testes que validam o filho.
///
/// Ver `docs/ADR-003`. Um DS-filho troca as primitivas de cor pra ter identidade
/// própria; os 66 roles, os componentes e o layout continuam os mesmos. O risco é
/// silencioso: pôr um amarelo em `primary04` quebra o contraste de todo componente
/// que assumia branco em cima, e ninguém descobre até alguém olhar.
///
/// Então a regra é:
///
/// > **Um filho é válido quando passa na conformidade do pai.**
///
/// Isto mora em `lib/` (e não em `test/`) DE PROPÓSITO: `test/` não vai no pacote
/// publicado, então um filho não teria como rodar. As checagens são funções puras
/// que devolvem uma lista de violações — sem `expect`, sem depender de
/// `flutter_test` — e cada projeto chama do seu próprio teste:
///
/// ```dart
/// test('conformidade do DS', () {
///   expect(violacoesDeConformidade(DilettaPalette.minhaMarca), isEmpty);
/// });
/// ```
///
/// As checagens não são teóricas: cada uma cobre um erro que ESTE projeto já
/// pagou. Os comentários dizem qual.
library;

import 'package:flutter/widgets.dart';

import '../theme/cpf_seguro_palette.dart';
import '../theme/cpf_seguro_roles.dart';
import '../theme/cpf_seguro_scheme.dart';

/// Mínimo WCAG pra elemento de UI e texto grande.
const double kConformidadeAALarge = 3.0;

/// Mínimo WCAG pra texto de corpo.
const double kConformidadeAA = 4.5;

/// Uma violação encontrada. `onde` é o par/token, pra o conserto ser acionável.
class ViolacaoDeConformidade {
  const ViolacaoDeConformidade({
    required this.regra,
    required this.onde,
    required this.detalhe,
    required this.porQue,
  });

  /// Slug curto da regra (`contraste-role`, `rampa-neutra`, …).
  final String regra;
  final String onde;
  final String detalhe;

  /// O erro real que esta regra evita. Existe pra ninguém "consertar" afrouxando
  /// o alvo sem saber o que a regra guardava.
  final String porQue;

  @override
  String toString() => '[$regra] $onde — $detalhe\n    evita: $porQue';
}

/// Chave estável de uma violação (`regra|onde`) — é o que entra numa baseline.
String chaveDeViolacao(ViolacaoDeConformidade v) => '${v.regra}|${v.onde}';

/// Roda TODAS as checagens contra [palette], em light e dark.
///
/// [baseline] é a lista de violações JÁ CONHECIDAS e aceitas (chaves de
/// [chaveDeViolacao]). Elas saem do resultado, mas ficam declaradas em quem
/// chama — visíveis e datadas.
///
/// Por que baseline e não afrouxar o mínimo: ligar um gate num sistema que já
/// existe sempre acha dívida. Baixar o alvo esconde; deixar vermelho treina todo
/// mundo a ignorar. Congelar o que existe e falhar no que é NOVO é o que faz o
/// gate valer no primeiro dia. **Filho nasce com baseline vazia** — ninguém herda
/// a nossa dívida sem escolher.
List<ViolacaoDeConformidade> violacoesDeConformidade(
  DilettaPalette palette, {
  Set<String> baseline = const {},
}) =>
    [
      ..._contrasteDosRoles(palette),
      ..._rampaNeutra(palette),
      ..._superficiesDistintas(palette),
      ..._bordaVisivel(palette),
      ..._textoSobrePreenchimentoSutil(palette),
      ..._tracoDeVidroVisivel(palette),
    ].where((v) => !baseline.contains(chaveDeViolacao(v))).toList();

/// TODAS as violações, sem aplicar baseline — pra relatório e pra saber o
/// tamanho da dívida.
List<ViolacaoDeConformidade> todasAsViolacoes(DilettaPalette palette) =>
    violacoesDeConformidade(palette);

double _contraste(Color a, Color b) => cpfSeguroContrastRatio(a, b);

/// 1 · Todo par role/onColor passa AA large, em light e dark.
///
/// É a checagem que já existia como teste do pai (`roles_contrast_test`) e a
/// razão de ela existir: `_bestOn` escolhe branco ou ink pelo maior contraste, mas
/// se a primitiva do filho for clara demais NENHUM dos dois passa.
List<ViolacaoDeConformidade> _contrasteDosRoles(DilettaPalette p) {
  final out = <ViolacaoDeConformidade>[];
  for (final entry in _schemes(p).entries) {
    for (final role in DilettaRoles.all) {
      final st = DilettaRoles.of(entry.value, role);
      final r = _contraste(st.color, st.onColor);
      if (r < kConformidadeAALarge) {
        out.add(ViolacaoDeConformidade(
          regra: 'contraste-role',
          onde: '${role.name} (${entry.key})',
          detalhe: 'color/onColor em ${r.toStringAsFixed(2)}:1 '
              '(mínimo $kConformidadeAALarge)',
          porQue: 'rótulo ilegível dentro de tag, banner e chip do role',
        ));
      }
    }
  }
  return out;
}

/// 2 · A rampa neutra vai de escuro (01) a claro (10), sem inversão.
///
/// Sem isto, um filho que preenche a rampa ao contrário produz tela com texto
/// claro sobre fundo claro — e TODO componente herda o erro, porque o DS assume a
/// direção da rampa (`neutral01` = tinta, `neutral10` = fundo).
List<ViolacaoDeConformidade> _rampaNeutra(DilettaPalette p) {
  final rampa = <String, Color>{
    'neutral01': p.neutral01,
    'neutral02': p.neutral02,
    'neutral03': p.neutral03,
    'neutral04': p.neutral04,
    'neutral05': p.neutral05,
    'neutral06': p.neutral06,
    'neutral07': p.neutral07,
    'neutral08': p.neutral08,
    'neutral09': p.neutral09,
    'neutral10': p.neutral10,
  };
  final out = <ViolacaoDeConformidade>[];
  final chaves = rampa.keys.toList();
  for (var i = 1; i < chaves.length; i++) {
    final ant = rampa[chaves[i - 1]]!;
    final atual = rampa[chaves[i]]!;
    // Contraste contra preto cresce quando a cor CLAREIA.
    const preto = Color(0xFF000000);
    if (_contraste(atual, preto) < _contraste(ant, preto)) {
      out.add(ViolacaoDeConformidade(
        regra: 'rampa-neutra',
        onde: '${chaves[i - 1]} → ${chaves[i]}',
        detalhe: 'a rampa escureceu onde deveria clarear',
        porQue: 'o DS assume neutral01 = tinta e neutral10 = fundo; invertida, '
            'todo componente herda texto claro sobre fundo claro',
      ));
    }
  }
  return out;
}

/// 3 · `surface` e `surfaceMuted` têm que ser DISTINGUÍVEIS.
///
/// Erro real (2026-07-28): o teclado numérico ficou "mal formado" no dark porque
/// a placa usava um valor e a tecla outro que, no escuro, davam 1.19:1 — a tecla
/// desaparecia dentro da placa. Um filho pode reproduzir isso sem perceber.
List<ViolacaoDeConformidade> _superficiesDistintas(DilettaPalette p) {
  final out = <ViolacaoDeConformidade>[];
  for (final entry in _schemes(p).entries) {
    final s = entry.value;
    final r = _contraste(s.surface, s.surfaceMuted);
    if (r < 1.08) {
      out.add(ViolacaoDeConformidade(
        regra: 'superficies-distintas',
        onde: 'surface/surfaceMuted (${entry.key})',
        detalhe: 'contraste de ${r.toStringAsFixed(2)}:1 — praticamente a mesma cor',
        porQue: 'componente empilhado (tecla sobre placa, card sobre fundo) '
            'desaparece; foi o bug do teclado no dark',
      ));
    }
  }
  return out;
}

/// 4 · A borda tem que aparecer sobre a superfície.
///
/// Erro real (2026-07-28): no dark do catálogo eu mapeei a borda pra
/// `surfaceMuted` e ela sumiu — 1.19:1 sobre `surface`. Borda invisível não é
/// borda: é um componente sem limite.
List<ViolacaoDeConformidade> _bordaVisivel(DilettaPalette p) {
  final out = <ViolacaoDeConformidade>[];
  for (final entry in _schemes(p).entries) {
    final s = entry.value;
    // Borda com alpha (o dark usa branco a 8%) precisa ser composta antes de
    // medir — senão o cálculo mede a cor "pura" e mente.
    final borda = Color.alphaBlend(s.border, s.surface);
    final r = _contraste(borda, s.surface);
    if (r < 1.06) {
      out.add(ViolacaoDeConformidade(
        regra: 'borda-visivel',
        onde: 'border/surface (${entry.key})',
        detalhe: 'contraste de ${r.toStringAsFixed(2)}:1',
        porQue: 'borda invisível deixa card, input e chip sem limite',
      ));
    }
  }
  return out;
}

/// 5 · Texto sobre preenchimento SUTIL do role passa AA de corpo.
///
/// O `subtle` é fundo de banner e chip. O texto em cima é o `onSubtle` — que
/// EXISTE por causa desta regra: antes os componentes usavam o próprio `color` do
/// role, e aí a tag de `warning` ficava em 2.16:1 e a de `secure` em 1.79:1.
/// Um token não serve duas exigências de contraste (sólido e sutil) ao mesmo tempo.
List<ViolacaoDeConformidade> _textoSobrePreenchimentoSutil(DilettaPalette p) {
  final out = <ViolacaoDeConformidade>[];
  for (final entry in _schemes(p).entries) {
    for (final role in DilettaRoles.all) {
      final st = DilettaRoles.of(entry.value, role);
      final r = _contraste(st.onSubtle, st.subtle);
      if (r < kConformidadeAA) {
        out.add(ViolacaoDeConformidade(
          regra: 'texto-sobre-sutil',
          onde: '${role.name} onSubtle/subtle (${entry.key})',
          detalhe: 'contraste de ${r.toStringAsFixed(2)}:1 '
              '(mínimo $kConformidadeAA pra texto)',
          porQue: 'banner e chip do role ficam com texto da mesma cor do fundo',
        ));
      }
    }
  }
  return out;
}

/// 6 · Traço de vidro DECLARADO tem que ser visível sobre o tinte dele.
///
/// Entrou por pedido de um segundo filho, e entrou **reformulada** — vale registrar a diferença,
/// porque ela é sobre o que um gate pode saber.
///
/// O pedido era: "superfície glassy sobre o fundo do tema precisa ter limite visível, no mesmo
/// limiar de 1.06:1 da `borda-visivel`". A regra não pode ser essa, por dois motivos que se
/// somam:
///
/// 1. **a paleta não sabe o que está ATRÁS do vidro.** O mesmo branco@80 é correto sobre conteúdo
///    (o limite vem da descontinuidade do blur) e é superfície sem limite sobre um fundo plano
///    claro. Uma regra estática diria "errado" nos dois casos;
/// 2. **o default do pai falharia**, e a saída seria dar traço ao vidro do primeiro filho — o pai
///    mudando o desenho de um produto pra resolver o pedido de outro.
///
/// O que É verificável: se o filho DECLAROU traço, ele tem que aparecer sobre o tinte que ele
/// mesmo declarou. É exatamente o bug que fez o pedido nascer — "a borda branca sumia sobre fundo
/// claro" — e agora ele falha alto em vez de aparecer no aparelho de alguém.
///
/// Fica registrado o que a regra NÃO cobre: vidro sem traço sobre superfície plana clara continua
/// sem limite, e isso é decisão de design de cada filho.
List<ViolacaoDeConformidade> _tracoDeVidroVisivel(DilettaPalette p) {
  final out = <ViolacaoDeConformidade>[];
  for (final entry in _schemes(p).entries) {
    final s = entry.value;
    final traco = s.glassStroke;
    if (traco == null) continue;
    // Traço e tinte quase sempre têm alpha: compõe os dois antes de medir, senão mede cor pura e
    // mente. É a mesma correção que a `borda-visivel` já carregava.
    final fundo = Color.alphaBlend(s.glassTint, s.surface);
    final linha = Color.alphaBlend(traco, fundo);
    final r = _contraste(linha, fundo);
    if (r < 1.06) {
      out.add(ViolacaoDeConformidade(
        regra: 'traco-de-vidro-visivel',
        onde: 'tracoDeVidro/tinte (${entry.key})',
        detalhe: 'contraste de ${r.toStringAsFixed(2)}:1',
        porQue: 'traço declarado e invisível é vidro sem limite com a aparência '
            'de ter limite — foi assim que a borda branca sumia sobre fundo claro',
      ));
    }
  }
  return out;
}

Map<String, DilettaScheme> _schemes(DilettaPalette p) => {
      'light': DilettaScheme.light(p),
      'dark': DilettaScheme.dark(p),
    };
