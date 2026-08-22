import 'dart:math' as math;

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// O PISO DE CONTRASTE VALE NOS DOIS MODOS — e este gate nasceu de um defeito que viveu no CLARO.
///
/// Em 17/08 o texto do escuro virou declaração (`ds v0.109.0`, quatro campos), e eu medi o par
/// inteiro pra escrever o pedido. O que eu não tinha medido era o outro lado do interruptor: o
/// `textMuted` do CLARO deste produto está em **2,96** sobre a superfície — abaixo até do piso de
/// texto GRANDE —, enquanto o mesmo papel no escuro está em 3,81, que foi o número que eu defendi
/// no pedido.
///
/// **A régua que eu apontei pro pai acusou o que eu tinha em casa**, e ela só não tinha acusado
/// antes porque a conformidade daqui olhava um modo por vez, papel por papel, sem cobrar o piso do
/// TEXTO nos dois.
///
/// O piso é **3,0** e não 4,5 de propósito: o `mudo` é metadado e é pra ser discreto — 4,5 o
/// transformaria em corpo. O que 3,0 impede é o discreto virar invisível.
void main() {
  double _lin(double c) =>
      c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4) as double;

  double lum(Color c) =>
      0.2126 * _lin(c.r) + 0.7152 * _lin(c.g) + 0.0722 * _lin(c.b);

  double contraste(Color a, Color b) {
    final la = lum(a), lb = lum(b);
    final alto = math.max(la, lb), baixo = math.min(la, lb);
    return (alto + 0.05) / (baixo + 0.05);
  }

  for (final escuro in [true, false]) {
    final modo = escuro ? 'escuro' : 'claro';
    final s = escuro
        ? DilettaScheme.dark(BoldPalette.bold)
        : DilettaScheme.light(BoldPalette.bold);

    test('todo papel de TEXTO passa 3,0 sobre a superfície — $modo', () {
      final papeis = <String, Color>{
        'fg': s.fg,
        'onSurface': s.onSurface,
        'textSecondary': s.textSecondary,
        'textTertiary': s.textTertiary,
        'textMuted': s.textMuted,
        'textPlaceholder': s.textPlaceholder,
      };
      // A EXCEÇÃO DO CLARO MORREU EM 18/08, no dia seguinte ao gate. Ela era o
      // `textPlaceholder` em **2,61** sobre o branco — derivação por degrau fixo com esta rampa —,
      // listada aqui com número em vez de o piso ser afrouxado. O pai fechou o pedido na
      // `v0.111.0`: o piso entrou na própria derivação, nos dois modos, e o `textMuted` que eu
      // tinha em 2,96 passou a ser declarado em 3,54.
      //
      // Nenhuma exceção sobrou, e é por isso que a lista some em vez de esvaziar: lista de exceção
      // vazia é convite pra próxima entrar sem discussão.
      final reprovados = <String, String>{};
      papeis.forEach((nome, cor) {
        final c = contraste(cor, s.surface);
        if (c < 3.0) reprovados[nome] = c.toStringAsFixed(2);
      });
      expect(reprovados, isEmpty,
          reason: 'texto abaixo do piso de 3,0 no $modo — discreto virou invisível:\n'
              '$reprovados');
    });

    test('e o piso vale sobre o FUNDO da tela também — $modo', () {
      // A superfície é o card; o fundo é a página. Um papel pode passar num e falhar no outro,
      // e foi assim que o escuro deste produto quase entregou o mudo em 7,51: eu media contra o
      // fundo e o pai contra a rampa.
      final reprovados = <String, String>{};
      for (final e in {'fg': s.fg, 'textSecondary': s.textSecondary, 'textMuted': s.textMuted}
          .entries) {
        final c = contraste(e.value, s.bg);
        if (c < 3.0) reprovados[e.key] = c.toStringAsFixed(2);
      }
      expect(reprovados, isEmpty, reason: 'texto abaixo de 3,0 sobre o fundo no $modo:\n$reprovados');
    });
  }

  test('e o gate SABE reprovar', () {
    // Controle com um par conhecido: cinza claro sobre branco não passa.
    expect(contraste(const Color(0xFFCCCCCC), const Color(0xFFFFFFFF)), lessThan(3.0));
    expect(contraste(const Color(0xFF000000), const Color(0xFFFFFFFF)), greaterThan(3.0));
  });
}
