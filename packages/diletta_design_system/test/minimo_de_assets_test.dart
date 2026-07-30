import 'dart:io';

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// O MÍNIMO DE ASSETS QUE UM DS-FILHO TEM QUE OFERECER — medido, não estimado.
///
/// Regra do dono do produto: **ou o filho herda tudo, ou oferece o mínimo pra herdar.**
/// Se ele troca o conjunto de ícones sem cobrir os nomes que os COMPONENTES usam, a
/// semântica geral quebra — o botão de fechar fica sem X, a linha de lista sem chevron —
/// e quebra silenciosamente, porque o `DilettaIcon` cai num fallback.
///
/// Este teste extrai o mínimo do CÓDIGO, não de uma lista escrita à mão: ele lê quais
/// nomes os componentes referenciam. Lista à mão apodrece; esta acompanha o DS.
///
/// **E ele protege o DS de hoje também**, não só um filho futuro: nome de ícone com erro
/// de digitação dentro de um componente hoje não falha em lugar nenhum — o ícone só não
/// aparece. Aqui falha.
///
/// ## A assimetria com ILUSTRAÇÃO, que a medição mostrou
///
/// Ícone é vocabulário: os componentes dependem de nomes específicos. **Ilustração não**
/// — só três componentes citam uma, e são casos de domínio (`fingerprint`, `keyWord`,
/// `pix`), não estrutura. Então:
///
/// - **ícone: há mínimo obrigatório** (os nomes abaixo);
/// - **ilustração: não há mínimo.** Um filho pode não ter nenhuma, e nada estrutural
///   quebra. Se tiver, só precisa respeitar a convenção de asset.
void main() {
  /// Nomes de ícone que os componentes do DS referenciam diretamente.
  ///
  /// Derivado varrendo `lib/design_system/widgets/`. É a definição operacional de
  /// "mínimo": remover qualquer um destes deixa um componente sem símbolo.
  Set<String> minimoUsadoPorComponentes() {
    final rx = RegExp(r'DilettaIcons\.([a-zA-Z0-9]+)');
    final out = <String>{};
    for (final f in Directory('lib/src/widgets').listSync()) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      for (final m in rx.allMatches(f.readAsStringSync())) {
        final nome = m.group(1)!;
        // `all` é o mapa, não um ícone.
        if (nome != 'all') out.add(nome);
      }
    }
    return out;
  }

  test('todo ícone que um componente usa EXISTE no conjunto', () {
    // Protege o DS de hoje: nome errado dentro de um componente não falha em lugar
    // nenhum — o ícone simplesmente não aparece. Aqui falha.
    final faltando = minimoUsadoPorComponentes()
        .where((n) => !DilettaIcons.all.containsKey(n))
        .toList()
      ..sort();
    expect(faltando, isEmpty,
        reason: 'componente referencia ícone que não está em DilettaIcons.all: '
            '$faltando. Sem ele o componente renderiza sem símbolo, e nada avisa.');
  });

  test('o mínimo é um SUBCONJUNTO pequeno do conjunto — herdar tudo é opcional', () {
    // O número importa pro contrato: um filho que queira trocar de família de ícones
    // precisa cobrir ESTES, não os 347. É a diferença entre "troca viável" e "refaz
    // tudo".
    final minimo = minimoUsadoPorComponentes();
    expect(minimo.length, lessThan(60),
        reason: 'se o mínimo crescer muito, trocar de família de ícones deixa de ser '
            'viável pra um filho — e aí "ou herda ou oferece o mínimo" vira "herda".');
    expect(DilettaIcons.all.length, greaterThan(minimo.length * 3),
        reason: 'o conjunto completo é conveniência; o mínimo é contrato');
  });

  test('todo asset do mínimo existe no disco, no formato do contrato', () {
    // O formato é `.svg.vec` (pré-compilado do `vector_graphics`), monocromático — é o
    // que permite o `ColorFilter` pintar o ícone com a cor do tema. Um filho que
    // entregue SVG colorido respeita o nome e quebra a cor.
    final ausentes = <String>[];
    for (final nome in minimoUsadoPorComponentes()) {
      // O VALOR do mapa é o nome do arquivo (`angle-down-light`), não a chave
      // (`angleDownLight`). A primeira versão deste teste supôs que fossem iguais e
      // acusou 44 ausências que não existiam — a suposição estava errada, não o DS.
      final arquivo = DilettaIcons.all[nome];
      if (arquivo == null) continue;
      if (!File('assets/icons/$arquivo.svg.vec').existsSync()) ausentes.add(nome);
    }
    expect(ausentes, isEmpty,
        reason: 'ícone declarado e sem arquivo: $ausentes');
  });

  test('todo token de ilustração tem NOME único e arquivo no disco', () {
    // O `nome` é o identificador que um catálogo usa pra montar vocabulário. Se dois
    // tokens tiverem o mesmo, um deles fica inalcançável; se um não tiver arquivo, a arte
    // renderiza vazia — e ilustração vazia não lança exceção nenhuma.
    final nomes = DilettaIllustration.all.map((i) => i.nome).toList();
    expect(nomes.toSet().length, nomes.length, reason: 'nome de ilustração repetido');
    expect(nomes.every((n) => n.isNotEmpty), isTrue);

    final semArquivo = <String>[];
    for (final i in DilettaIllustration.all) {
      // Temáticas têm par light/dark; as não-temáticas têm um arquivo só.
      final caminhos = i.themed
          ? ['assets/illustrations/${i.base}_light.svg', 'assets/illustrations/${i.base}_dark.svg']
          : ['assets/illustrations/${i.base}.svg'];
      for (final c in caminhos) {
        if (!File(c).existsSync()) semArquivo.add('${i.nome} → $c');
      }
    }
    expect(semArquivo, isEmpty, reason: 'token de ilustração sem arte: $semArquivo');
  });

  test('ILUSTRAÇÃO não tem mínimo — e isso é achado, não descuido', () {
    // Só três componentes citam ilustração, e as três são de domínio, não de estrutura.
    // Então um filho pode nascer sem ilustração nenhuma. Se este número crescer, a
    // conclusão muda — e o teste avisa.
    final rx = RegExp(r'DilettaIllustration\.([a-zA-Z0-9]+)');
    final usadas = <String>{};
    for (final f in Directory('lib/src/widgets').listSync()) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      for (final m in rx.allMatches(f.readAsStringSync())) {
        usadas.add(m.group(1)!);
      }
    }
    expect(usadas.length, lessThanOrEqualTo(4),
        reason: 'componentes passaram a depender de ilustração ($usadas). Se isso '
            'crescer, ilustração deixa de ser opcional pro filho e vira contrato.');
  });
}
