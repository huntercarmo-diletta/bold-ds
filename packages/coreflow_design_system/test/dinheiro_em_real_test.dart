import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// A DIGITAÇÃO DE DINHEIRO — e as bordas, que são o motivo de isto ser DS e não código de tela.
///
/// Máscara de moeda é a peça que toda tela reimplementa e que difere sempre nas mesmas quatro
/// bordas: o vazio, o primeiro centavo, o milhar e o teto. Este teste fixa as quatro.
void main() {
  TextEditingValue v(String t) => TextEditingValue(text: t);
  final f = CoreflowDinheiro.formatter();
  String digitar(String texto) =>
      f.formatEditUpdate(const TextEditingValue(), v(texto)).text;

  test('vazio mostra o prefixo, e não um valor', () {
    // `R$ 0,00` parece campo preenchido; `R$ ` parece campo esperando. A diferença aparece na
    // primeira tela de transferência que alguém abre.
    expect(CoreflowDinheiro.formatar(0), r'R$ ');
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

  test('a volta é em CENTAVOS, e só em centavos', () {
    // Dinheiro se guarda em inteiro: ponto flutuante é como se perde um centavo por
    // arredondamento, e num extrato isso aparece.
    //
    // O `emReais(String) → double` ao lado SAIU na auditoria por "zero consumidor" e VOLTOU na
    // v0.6.0: a medição olhou só o campo de valor grande (que guarda `_cents`) e não os campos
    // bordados, que leem o texto do controller de volta — 10 pontos de uso no app.
    expect(CoreflowDinheiro.centavosDe(r'R$ 2.500,00'), 250000);
    expect(CoreflowDinheiro.centavosDe('texto sem número'), 0);
    expect(CoreflowDinheiro.centavosDe(''), 0);
  });

  test('a volta em reais é a de centavos dividida, e não uma segunda conta', () {
    // Duas contas pro mesmo valor é como as duas divergem numa borda. Esta amarra as duas.
    for (final texto in [r'R$ 2.500,00', r'R$ 0,01', 'texto sem número', '']) {
      expect(CoreflowDinheiro.emReais(texto), CoreflowDinheiro.centavosDe(texto) / 100.0,
          reason: 'emReais tem que ser centavosDe/100, não uma máscara própria');
    }
    expect(CoreflowDinheiro.emReais(r'R$ 2.500,00'), 2500.0);
  });

  test('ida e volta fecham em qualquer valor', () {
    for (final centavos in [1, 99, 100, 12345, 999999999]) {
      expect(CoreflowDinheiro.centavosDe(CoreflowDinheiro.formatar(centavos)), centavos);
    }
  });

  test('sem símbolo, o texto é só o número — e a volta continua fechando', () {
    // O modo nasceu na `ds v0.61.0` do pai: o `DilettaAmountField` põe o `R$` num `Text`
    // próprio, num degrau MENOR que o número. Com o símbolo dentro do texto, ele herdaria o
    // porte do número e a hierarquia (*quanto* antes de *em quê*) se perderia.
    expect(CoreflowDinheiro.formatar(250000, comSimbolo: false), '2.500,00');
    expect(CoreflowDinheiro.formatar(1, comSimbolo: false), '0,01');

    // Vazio é VAZIO, e não `0,00`: campo de valor vazio espera digitação, e um zero
    // formatado parece valor preenchido. É a mesma decisão do modo com símbolo, que
    // devolve `R$ ` e não `R$ 0,00`.
    expect(CoreflowDinheiro.formatar(0, comSimbolo: false), '');

    // A volta não olha o símbolo — ela lê dígito. Se um dia olhar, este teste cai.
    for (final centavos in [1, 99, 100, 12345, 999999999]) {
      expect(
          CoreflowDinheiro.centavosDe(
              CoreflowDinheiro.formatar(centavos, comSimbolo: false)),
          centavos);
    }
  });
}
