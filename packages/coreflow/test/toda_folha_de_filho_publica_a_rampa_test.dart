// TODA FOLHA DE FILHO PUBLICA A RAMPA DE MARCA — os nove degraus, por nome.
//
// Papel semântico (`primary`, `primaryHover`, `primarySubtle`) basta para PINTAR componente e não
// basta para DESENHAR. Quem monta um fundo, um brilho, uma malha precisa do DEGRAU, e até 22/09 a
// web não tinha de onde tirá-lo.
//
// O efeito foi medido do lado de fora, no Internet Banking. O `BoldBackdrop` monta três brilhos com
// três paradas da curva do LOCKUP do Conta BOLD (`lockup01`, `05`, `08`) — porque era o que existia
// publicado. Só que a curva do lockup é o desenho do símbolo DELE: oito paradas varrendo matiz, de
// rosa a amarelo. Quem não desenha curva própria recebe a derivada, de DUAS
// (`CoreflowGradients.daPaleta`), e os dois brilhos que faltam morrem calados — `var()` que não
// resolve mata a declaração inteira, sem erro no console.
//
// Do lado Flutter o pai nunca teve esse problema: `coreflow_background.dart` monta os brilhos com
// `p.primary04` da rampa do próprio filho, e nenhuma parada de lockup. A web é que estava sem a
// peça, e quem precisou dela foi buscar o que havia.
//
// A rampa sai SEM BLOCO DE MODO, e isso é medido, não suposto: `primary04` da Norte Benk vale
// `#1d72ff` no esquema claro e no escuro. A rampa é a identidade da marca; quem inverte por brilho
// são os papéis derivados dela.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Os nove degraus, pelo nome com que saem no CSS.
const _degraus = [
  'primary01', 'primary02', 'primary03', 'primary04', 'primary05',
  'primary06', 'primary07', 'primary08', 'primary09',
];

/// As folhas de token de todo filho. Varredura, e não lista: filho novo entra sozinho.
List<File> _folhasDosFilhos() {
  final fora = <File>[];
  void colher(Directory tokens) {
    if (!tokens.existsSync()) return;
    fora.addAll(tokens.listSync().whereType<File>().where((f) => f.path.endsWith('-tokens.css')));
  }

  for (final d in Directory('..').listSync().whereType<Directory>()) {
    colher(Directory('${d.path}/web/tokens'));
    // O primeiro filho guarda o lado web num pacote IRMÃO, e não dentro do seu — nasceu antes do
    // molde existir. Sem esta linha o gate cobriria só os gerados.
    colher(Directory('${d.path}/tokens'));
  }
  colher(Directory('../../exemplos/filho_do_coreflow/web/tokens'));
  return fora..sort((a, b) => a.path.compareTo(b.path));
}

void main() {
  final folhas = _folhasDosFilhos();

  test('a varredura acha folha de verdade — senão o gate aprova por cegueira', () {
    expect(folhas, isNotEmpty, reason: 'nenhuma `*/web/tokens/*-tokens.css` foi encontrada');
    expect(folhas.where((f) => f.path.contains('norte_benk')), isNotEmpty);
    expect(folhas.where((f) => f.path.contains('bold-tokens')), isNotEmpty);
    expect(folhas.where((f) => f.path.contains('filho_do_coreflow')), isNotEmpty,
        reason: 'a folha do exemplo gerado sumiu — é ela que prova o MOLDE, e não só as instâncias');
  });

  for (final folha in folhas) {
    final nome = folha.uri.pathSegments.last;
    test('$nome publica os nove degraus da rampa', () {
      final css = folha.readAsStringSync();
      final faltando = _degraus.where((d) => !css.contains('--diletta-$d:')).toList();
      expect(faltando, isEmpty,
          reason: 'a folha ${folha.path} não publica estes degraus da rampa. Sem eles, um consumidor '
              'que precise DESENHAR com a tinta desta marca não tem de onde tirá-la, e vai buscar o '
              'que houver — foi assim que o fundo do IB acabou montado sobre a curva do lockup de '
              'OUTRO produto:\n  ${faltando.join('\n  ')}');
    });
  }

  test('e a rampa não inverte por modo — constante de marca não tem bloco de brilho', () {
    // A régua que separa rampa de papel. Se um degrau aparecer dentro de um bloco escuro, ele
    // deixou de ser identidade e virou papel — e quem o lê como identidade passa a ver a marca
    // mudar de cor com o tema, que é a classe de defeito que o `BoldBackdrop` já documentou.
    for (final folha in folhas) {
      final css = folha.readAsStringSync();
      // Os blocos de modo deste DS: `@media (prefers-color-scheme: dark)` e `[data-theme="dark"]`.
      final blocos = RegExp(r'(@media[^{]*prefers-color-scheme:\s*dark[^{]*\{|\[data-theme="dark"\][^{]*\{)');
      for (final m in blocos.allMatches(css)) {
        final depois = css.substring(m.end, (m.end + 4000).clamp(0, css.length));
        final ateOFim = depois.split('\n}').first;
        final dentro = _degraus.where((d) => ateOFim.contains('--diletta-$d:')).toList();
        expect(dentro, isEmpty,
            reason: 'degrau da rampa declarado dentro de um bloco de modo em ${folha.path} — a rampa '
                'é constante de marca:\n  ${dentro.join('\n  ')}');
      }
    }
  });
}
