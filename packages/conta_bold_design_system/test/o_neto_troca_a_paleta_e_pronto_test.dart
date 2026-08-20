import 'dart:io';

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **SE ESTE DS TIVER UM FILHO, TROCAR OS TOKENS TROCA O APP?**
///
/// A pergunta é do dono do produto, de 19/08, e ela não se responde com o número de adoção. Ela se
/// responde montando um NETO: uma paleta diferente, passada pelo contrato, e medindo o que sai igual.
///
/// Na primeira medição a resposta era **não**. O `BoldScheme` cravava `BoldPalette.bold` por dentro
/// das duas fábricas — então não existia paleta a passar — e escrevia **21 valores** como literal: 8
/// papéis no escuro e 13 no claro. Um neto herdava as superfícies elevadas, as bordas, o scrim, o
/// fluxo secundário e o azul de informação do Bold, e no claro herdava o rosa dele no `primary` e no
/// `danger`.
///
/// O que este teste garante hoje: **42 dos 44 valores** (22 papéis × 2 modos) saem da paleta que foi
/// passada. Os 2 que faltam têm nome, motivo e pedido aberto.
void main() {
  /// A paleta do NETO — e ela não é inventada: é a **paleta de referência do pai**.
  ///
  /// Podia ser um verde qualquer montado aqui. Usar a `DilettaPalette.referencia` é melhor por dois
  /// motivos: ela é mantida pelo pai (então este teste acompanha o contrato dele sem eu copiar campo)
  /// e ela é **realmente outra marca** — outro matiz, outras superfícies, outro `error`.
  ///
  /// O que eu acrescento é só o que um neto acrescentaria: os quatro `papeisExtras`, que são
  /// vocabulário deste produto e não existem na referência.
  final neto = DilettaPalette.referencia.comMaterial(
    papeisExtras: {
      'superficieElevada': const DilettaPapelExtra(
          claro: Color(0xFFFBFFFC),
          escuro: Color(0xFF12271B),
          significado: 'a elevada do neto'),
      'superficiePressionada': const DilettaPapelExtra(
          claro: Color(0xFFE0EFE6),
          escuro: Color(0xFF1D3A2A),
          significado: 'a pressionada do neto'),
      'fluxoSecundario': const DilettaPapelExtra(
          claro: Color(0xFFF2F8F4),
          escuro: Color(0xFF04170D),
          significado: 'o fluxo secundário do neto'),
      'info': const DilettaPapelExtra(
          claro: Color(0xFF7A5AF8),
          escuro: Color(0xFF7A5AF8),
          significado: 'a informação do neto'),
    },
  );

  /// Os 22 papéis, lidos por nome pra a lista não poder ficar incompleta em silêncio.
  Map<String, Color> papeis(BoldScheme s) => {
        'background': s.background,
        'surface': s.surface,
        'surfaceRaised': s.surfaceRaised,
        'surfacePressed': s.surfacePressed,
        'field': s.field,
        'secondaryFlow': s.secondaryFlow,
        'textPrimary': s.textPrimary,
        'textSecondary': s.textSecondary,
        'textMuted': s.textMuted,
        'border': s.border,
        'borderSoft': s.borderSoft,
        'borderStrong': s.borderStrong,
        'overlay': s.overlay,
        'primary': s.primary,
        'onPrimary': s.onPrimary,
        'primaryPressed': s.primaryPressed,
        'primaryWash': s.primaryWash,
        'danger': s.danger,
        'success': s.success,
        'warning': s.warning,
        'info': s.info,
      };

  /// **Igual não é sempre preso**, e separar as duas coisas é o que faz este teste valer.
  ///
  /// Um papel pode sair idêntico nas duas paletas por três razões diferentes, e só uma é dívida:
  ///
  /// 1. **por REGRA** — a regra não depende das rampas de marca. `borderSoft` é a tinta de borda a
  ///    5%, e a tinta de borda é branco ou preto ABSOLUTO: nenhuma paleta muda o branco. O papel
  ///    viaja perfeitamente e o valor é o mesmo, porque a resposta certa é a mesma;
  /// 2. **por CONSEQUÊNCIA** — deriva de um papel que está preso. O `overlay` é o fundo com alpha:
  ///    ele viaja no dia em que o fundo viajar, e não antes;
  /// 3. **por DÍVIDA** — o valor é literal deste pacote e nenhuma paleta alcança. São dois.
  ///
  /// A distinção não é conforto: sem ela, este teste ou reprovaria uma regra correta ou aceitaria uma
  /// dívida nova. As três listas são fechadas, e crescer qualquer uma exige editar este arquivo.
  const porRegra = {
    'surface (claro)',      // branco absoluto nas duas paletas — é o que superfície clara É
    'onPrimary (claro)',    // a tinta assumida deste produto é branco, e branco é absoluto
    'border (escuro)',      // regra do pai: branco a 8%
    'borderSoft (claro)',   // preto a 5%
    'borderSoft (escuro)',  // branco a 7%
    'borderStrong (claro)', // preto a 14%
    'borderStrong (escuro)' // branco a 18%
  };
  const porConsequencia = {'overlay (claro)'};

  /// Os que NÃO viajam, e a lista é a dívida: `background` e `field` no claro.
  ///
  /// A paleta do pai tem os campos de override do ESCURO e ganhou o espelho do claro pro texto e pra
  /// borda na `v0.111.0`; faltou o espelho do claro pras SUPERFÍCIES. Pedido aberto em 19/08.
  ///
  /// **A lista é fechada de propósito.** Se alguém cravar um valor novo aqui dentro, o teste reprova
  /// dizendo o nome — e a dívida não cresce sem alguém decidir que ela cresça.
  const naoViajam = {'background (claro)', 'field (claro)'};

  test('o NETO troca a paleta e recebe o esquema DELE — a dívida são DOIS de 42, e 32 viajam', () {
    var viajaram = 0;
    final iguais = <String>{};
    for (final brilho in [Brightness.light, Brightness.dark]) {
      final meu = papeis(BoldScheme.de(BoldPalette.bold, brilho: brilho));
      final dele = papeis(BoldScheme.de(neto, brilho: brilho));
      final modo = brilho == Brightness.light ? 'claro' : 'escuro';
      meu.forEach((nome, cor) {
        if (cor.toARGB32() == dele[nome]!.toARGB32()) {
          iguais.add('$nome ($modo)');
        } else {
          viajaram++;
        }
      });
    }

    final divida = iguais.difference(porRegra).difference(porConsequencia);
    expect(divida, naoViajam,
        reason: 'papel que não acompanhou a paleta do neto e não tem razão declarada:\n'
            '${divida.difference(naoViajam).join("\n")}\n\n'
            'Se é regra que não depende de marca, entra em `porRegra` com o motivo. Se é dívida '
            'nova, ela precisa de decisão antes de entrar em `naoViajam`.');

    // O outro lado da conta, e ele existe pra a lista de exceções não poder crescer sozinha: se
    // alguém mover um papel de "viaja" pra qualquer das listas, este número cai e o teste diz.
    expect(viajaram, 32,
        reason: 'papéis que acompanham a paleta do neto. Caiu? Um papel deixou de derivar');
  });

  test('e o esquema não escreve UM hex — o tradutor não decide cor', () {
    // A causa raiz, virada mecanismo. Enquanto este arquivo pudesse escrever `Color(0x…)`, qualquer
    // conserto de retema seria desfeito pelo próximo papel que alguém cravasse aqui — e cravar aqui é
    // mais fácil que declarar na paleta, que é o que faz a regra precisar de gate e não de acordo.
    final fonte = const String.fromEnvironment('nao-usado').isEmpty
        ? _leia('lib/src/bold_scheme.dart')
        : '';
    final hex = RegExp(r'Color\(0x[0-9A-Fa-f]{6,8}\)').allMatches(fonte).length;
    expect(hex, 0,
        reason: 'o esquema é o TRADUTOR entre paleta e papel. Valor literal aqui é decisão de cor '
            'no único lugar onde nenhuma paleta alcança — foi assim que 21 valores ficaram presos');
  });

  test('a paleta do Bold declara os quatro papéis que o pai não tem', () {
    // O fallback do `extra()` existe pra uma paleta incompleta desenhar em vez de estourar. Ele não
    // pode virar o caminho normal: sem esta asserção, apagar um extra da paleta passaria calado e o
    // valor voltaria a ser o literal deste pacote.
    for (final nome in ['superficieElevada', 'superficiePressionada', 'fluxoSecundario', 'info']) {
      expect(BoldPalette.bold.papeisExtras[nome], isNotNull,
          reason: '`$nome` saiu da paleta e voltou a ser literal do pacote');
      expect(BoldPalette.bold.papeisExtras[nome]!.significado, isNotEmpty,
          reason: 'papel sem frase é papel que ninguém sabe quando usar');
    }
  });
}

String _leia(String caminho) => File(caminho).readAsStringSync();
