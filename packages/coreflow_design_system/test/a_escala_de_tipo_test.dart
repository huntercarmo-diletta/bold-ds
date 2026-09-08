import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ESCALA DE TIPO DA MARCA — e o que este gate protege é a ESCADA, não os valores.
///
/// Ela atravessou do app pra cá em 17/08, depois da paleta e das peças, e chegou por último de
/// propósito: é o token com mais consumidor (644 sítios) e o que menos perdoa erro.
void main() {
  test('a família viaja UMA vez — na tipografia do produto, não em cada degrau', () {
    // Até 08/09 cada degrau repetia `fontFamily: fontFamily`, e o `ThemeData` repetia de novo: duas
    // fontes da mesma verdade (veredito do pai, decisão 2). Agora a família entra em
    // `CoreflowType.tipografia.familia`, o `ThemeData(fontFamily:)` a aplica ao `textTheme` inteiro,
    // e os degraus herdam. Os dois `mono` são a exceção declarada: são OUTRA família em potencial.
    expect(CoreflowType.tipografia.familia, CoreflowType.fontFamily);
    expect(CoreflowType.tipografia.familia, startsWith('packages/'),
        reason: 'família sem o prefixo do pacote não resolve no app consumidor');
    for (final e in CoreflowType.todos.entries) {
      if (e.key.startsWith('mono')) {
        expect(e.value.fontFamily, CoreflowType.monoFamily, reason: e.key);
        continue;
      }
      expect(e.value.fontFamily, isNull,
          reason: '${e.key} repete a família — a segunda fonte da mesma verdade voltou');
    }
    // E o ThemeData do Bold entrega a família em todo degrau do textTheme — é o canal.
    final t = CoreflowProduto.bold.materialClaro;
    for (final d in [t.textTheme.displayLarge, t.textTheme.bodyMedium, t.textTheme.labelSmall]) {
      expect(d?.fontFamily, CoreflowType.fontFamily);
    }
  });

  test('os sete que derivam DERIVAM — px, altura, peso e tracking', () {
    void igual(TextStyle a, TextStyle b, String nome) {
      expect(a.fontSize, b.fontSize, reason: '$nome: px');
      expect(a.height, b.height, reason: '$nome: altura');
      expect(a.fontWeight, b.fontWeight, reason: '$nome: peso');
      expect(a.letterSpacing, b.letterSpacing, reason: '$nome: tracking');
    }

    igual(CoreflowType.headlineMd, DilettaType.headlineMd, 'headlineMd');
    igual(CoreflowType.headlineSm, DilettaType.headlineSm, 'headlineSm');
    igual(CoreflowType.titleMd, DilettaType.titleMd, 'titleMd');
    igual(CoreflowType.bodyLg, DilettaType.bodyLg, 'bodyLg');
    igual(CoreflowType.labelMd, DilettaType.labelMd, 'labelMd');
    igual(CoreflowType.bodySm, DilettaType.bodySm, 'bodySm');
    igual(CoreflowType.labelSm, DilettaType.labelSm, 'labelSm');

    // O saldo é o único que acrescenta: sem tabular o dígito muda de largura e o valor pula.
    expect(CoreflowType.headlineMd.fontFeatures, isNotEmpty);
  });

  test('a escada não tem dois degraus no mesmo lugar', () {
    // A REGRA que este arquivo existe pra manter. O app tinha `fontSize: 32` em onze sítios e
    // `34` em seis, e a divisão entre os grupos não era decisão — era o que sobrou de escrever o
    // mesmo número duas vezes. Dois degraus a menos de 2px de distância não se distinguem, e o
    // que eles produzem é a terceira grafia no dia seguinte.
    final porTamanho = <double, List<String>>{};
    for (final e in CoreflowType.todos.entries) {
      porTamanho.putIfAbsent(e.value.fontSize!, () => []).add(e.key);
    }
    final tamanhos = porTamanho.keys.toList()..sort();
    for (var i = 1; i < tamanhos.length; i++) {
      final d = tamanhos[i] - tamanhos[i - 1];
      expect(d, greaterThanOrEqualTo(1.0),
          reason: 'degraus colados: ${porTamanho[tamanhos[i - 1]]} e ${porTamanho[tamanhos[i]]}');
    }

    // Degraus que COMPARTILHAM px existem e são legítimos — o que os separa é peso ou tracking.
    porTamanho.forEach((px, nomes) {
      if (nomes.length < 2) return;
      final assinaturas = nomes
          .map((n) => '${CoreflowType.todos[n]!.fontWeight}/${CoreflowType.todos[n]!.letterSpacing}')
          .toSet();
      expect(assinaturas.length, nomes.length,
          reason: 'em $px há degraus com o MESMO peso e tracking: $nomes');
    });
  });

  test('o valor herói é UM, e ele é 32', () {
    expect(CoreflowType.valorHeroi.fontSize, 32);
    expect(CoreflowType.valorHeroi.fontFeatures, isNotEmpty);
    // Ele não é o `display`: aquele é o saldo de tela cheia, este é o valor da transação.
    expect(CoreflowType.display.fontSize, isNot(CoreflowType.valorHeroi.fontSize));
  });
}
