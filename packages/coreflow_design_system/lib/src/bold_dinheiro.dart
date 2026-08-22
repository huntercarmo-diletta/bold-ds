/// CONTA BOLD — a digitação de dinheiro em real.
///
/// Segundo componente que nasce neste filho, e o mais barato de todos: é `TextInputFormatter`,
/// não widget. Não lê tema, não tem variante, não vira `BlockDef` — então das onze exigências do
/// contrato de componente, sobram duas que se aplicam: vocabulário fechado e um teste.
///
/// 8 usos no produto antigo.
///
/// ## Por que ele é do DS, e não da tela
///
/// Porque a regra que ele implementa é a mesma em toda tela onde se digita valor: **digita-se em
/// CENTAVOS e lê-se em reais**. Quem escreve isso na tela escreve a máscara de novo, e a segunda
/// versão sempre difere numa borda — o zero, o milhar, o teto. Foi por isso que o `divider` do
/// primeiro filho virou exemplo no contrato do pai: peça sem palavra no vocabulário é peça que
/// cada tela reimplementa.
///
/// ## O que mudou na adaptação, e é o teto
///
/// A versão antiga travava em **10 dígitos** cortando pela esquerda (`substring`), sem dizer por
/// quê. Medi o efeito: digitar o 11º dígito não era ignorado — ele **empurrava o primeiro fora**,
/// então `R$ 99.999.999,99` mais um `1` virava `R$ 99.999.999,91`. O usuário vê o valor mudar no
/// meio em vez de parar de crescer, que é o comportamento que ele espera de um campo cheio.
///
/// Agora o teto IGNORA o excedente. O limite continua sendo o mesmo, e continua sendo escolha:
/// dez dígitos são R$ 99.999.999,99, que cobre transação de conta digital com folga.
library;

import 'package:flutter/services.dart';

/// Formata a digitação de centavos como moeda brasileira.
///
/// ```dart
/// ds.DilettaInput(
///   keyboardType: TextInputType.number,
///   inputFormatters: [CoreflowDinheiro.formatter()],
/// )
/// ```
abstract final class CoreflowDinheiro {
  /// Máximo de dígitos aceitos: R$ 99.999.999,99.
  static const int digitosMaximos = 10;

  /// [comSimbolo] `false` devolve só o número (`1.234,56`), sem o `R$ `.
  ///
  /// Existe desde a `ds v0.61.0` do pai, e a razão é dele: o `DilettaAmountField` põe o símbolo
  /// num `Text` PRÓPRIO, num degrau menor que o número — *"ele é referência, não valor: o que se
  /// lê primeiro é quanto, não em quê"*. Com o símbolo dentro do texto, ele herdaria o porte do
  /// número e a hierarquia se perderia.
  ///
  /// O default continua `true`: os campos BORDADOS do app (9 pontos) mostram o símbolo dentro,
  /// porque ali não há slot separado pra ele.
  static TextInputFormatter formatter({bool comSimbolo = true}) =>
      comSimbolo ? const _FormatadorDeDinheiro() : const _FormatadorDeDinheiro(simbolo: false);

  /// Centavos → `R$ 1.234,56`. Zero devolve `R$ ` (com o espaço), porque campo de valor vazio
  /// mostra o prefixo e espera a digitação — `R$ 0,00` parece valor preenchido.
  static String formatar(int centavos, {bool comSimbolo = true}) {
    if (centavos == 0) return comSimbolo ? r'R$ ' : '';
    final decimais = (centavos % 100).toString().padLeft(2, '0');
    final inteiros = (centavos ~/ 100).toString();
    final saida = StringBuffer();
    for (var i = 0; i < inteiros.length; i++) {
      if (i > 0 && (inteiros.length - i) % 3 == 0) saida.write('.');
      saida.write(inteiros[i]);
    }
    return comSimbolo ? 'R\$ $saida,$decimais' : '$saida,$decimais';
  }

  /// `R$ 2.500,00` → `250000`. É a forma que se guarda e se manda pra API — ponto flutuante
  /// para dinheiro é como se perde um centavo por arredondamento.
  static int centavosDe(String texto) {
    final digitos = texto.replaceAll(RegExp(r'\D'), '');
    if (digitos.isEmpty) return 0;
    final cortado = digitos.length > digitosMaximos
        ? digitos.substring(0, digitosMaximos)
        : digitos;
    return int.parse(cortado);
  }

  /// `R$ 2.500,00` → `2500.0`. A volta em REAIS, pra quem guarda o valor em `double`.
  ///
  /// Ela já existiu, saiu na auditoria com a justificativa *"zero consumidor — os campos de dinheiro
  /// guardam `_cents` (int)"*, e a medição estava errada: isso vale pro campo de valor grande, e os
  /// campos BORDADOS do app leem o texto do controller de volta. São **9 pontos de uso** (tela de
  /// valor do Pix, os quatro acréscimos da cobrança com vencimento, o valor da cobrança em três
  /// fluxos, os limites), todos com o mesmo `replaceAll(RegExp(r'\D'), '')` na frente.
  ///
  /// Preferir [centavosDe] em código novo: inteiro é como dinheiro se guarda sem perder centavo por
  /// arredondamento. Esta existe porque o modelo de dados de quem chama é `double`, e reescrever a
  /// máscara em nove telas pra evitar uma linha aqui é o defeito que o DS existe pra não ter.
  static double emReais(String texto) => centavosDe(texto) / 100.0;
}

class _FormatadorDeDinheiro extends TextInputFormatter {
  const _FormatadorDeDinheiro({this.simbolo = true});

  final bool simbolo;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue antigo, TextEditingValue novo) {
    final digitos = novo.text.replaceAll(RegExp(r'\D'), '');

    // Passou do teto: devolve o ANTIGO. A versão anterior cortava pela esquerda, e aí o dígito
    // novo empurrava o primeiro fora — o valor mudava no meio em vez de parar de crescer.
    if (digitos.length > CoreflowDinheiro.digitosMaximos) return antigo;

    final texto = CoreflowDinheiro.formatar(digitos.isEmpty ? 0 : int.parse(digitos),
        comSimbolo: simbolo);
    return TextEditingValue(
      text: texto,
      // Cursor sempre no fim: o texto é reescrito inteiro a cada tecla, então qualquer outra
      // posição salta sozinha na próxima digitação.
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
