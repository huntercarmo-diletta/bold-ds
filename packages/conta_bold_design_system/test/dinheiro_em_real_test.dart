import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// A DIGITAÇÃO DE DINHEIRO — e as bordas, que são o motivo de isto ser DS e não código de tela.
///
/// Máscara de moeda é a peça que toda tela reimplementa e que difere sempre nas mesmas quatro
/// bordas: o vazio, o primeiro centavo, o milhar e o teto. Este teste fixa as quatro.
void main() {
  TextEditingValue v(String t) => TextEditingValue(text: t);
  final f = BoldDinheiro.formatter();
  String digitar(String texto) =>
      f.formatEditUpdate(const TextEditingValue(), v(texto)).text;

  test('vazio mostra o prefixo, e não um valor', () {
    // `R$ 0,00` parece campo preenchido; `R$ ` parece campo esperando. A diferença aparece na
    // primeira tela de transferência que alguém abre.
    expect(BoldDinheiro.formatar(0), r'R$ ');
    expect(digitar(''), r'R$ ');
  });

  test('digita-se em CENTAVOS: o primeiro dígito é o centavo, não o real', () {
    expect(digitar('1'), r'R$ 0,01');
    expect(digitar('12'), r'R$ 0,12');
    expect(digitar('123'), r'R$ 1,23');
  });

  test('o milhar separa com ponto, e a vírgula é decimal', () {
    expect(digitar('123456'), r'R$ 1.234,56');
    expect(digitar('100000000'), r'R$ 1.000.000,00');
  });

  test('no TETO o valor para de crescer — não desliza', () {
    // Esta é a correção que a adaptação trouxe, e ela veio de medir o comportamento antigo: o
    // formatter cortava pela ESQUERDA, então o 11º dígito empurrava o primeiro fora e
    // `R$ 99.999.999,99` + `1` virava `R$ 99.999.999,91`. O usuário via o valor mudar no meio.
    const cheio = '9999999999'; // 10 dígitos
    expect(digitar(cheio), r'R$ 99.999.999,99');

    final estavaCheio = v(r'R$ 99.999.999,99');
    final tentandoOnze = v(r'R$ 99.999.999,991');
    expect(f.formatEditUpdate(estavaCheio, tentandoOnze).text, estavaCheio.text,
        reason: 'passar do teto tem que ignorar a tecla, não deslizar o valor');
  });

  test('o cursor fica no fim, porque o texto é reescrito inteiro', () {
    final r = f.formatEditUpdate(const TextEditingValue(), v('123'));
    expect(r.selection.baseOffset, r.text.length);
  });

  test('a volta é em CENTAVOS, e em reais só pra exibir', () {
    // Dinheiro se guarda em inteiro: ponto flutuante é como se perde um centavo por
    // arredondamento, e num extrato isso aparece.
    expect(BoldDinheiro.centavosDe(r'R$ 2.500,00'), 250000);
    expect(BoldDinheiro.emReais(r'R$ 2.500,00'), 2500.0);
    expect(BoldDinheiro.centavosDe('texto sem número'), 0);
    expect(BoldDinheiro.centavosDe(''), 0);
  });

  test('ida e volta fecham em qualquer valor', () {
    for (final centavos in [1, 99, 100, 12345, 999999999]) {
      expect(BoldDinheiro.centavosDe(BoldDinheiro.formatar(centavos)), centavos);
    }
  });
}
