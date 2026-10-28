// O `primary` DO ESQUEMA LEVA A TINTA DELE — na folha web, `onPrimary` se lê sobre `primary`.
//
// No claro, o `primary` do esquema é o degrau profundo (`primary03`), escolhido como tinta sobre a
// página branca. Na web ele vira `--diletta-primary`, que o avô também usa como PREENCHIMENTO: o botão
// primário, a bolha, o passo atual. A tinta por cima vinha da paleta, derivada da cor de marca no degrau
// 05 — e quando a marca é CLARA as duas não casam.
//
// Medido do lado de fora, no Internet Banking, em 27/10: a BluOn (`#1F91FF`) saiu com `#14181a` sobre
// `#084d8e`, 2,10:1, em sete pares do gate de contraste de lá. Na Norte Benk e no Conta BOLD a marca é
// escura, a tinta da paleta já é branca, e por isso ninguém tinha visto.
import 'dart:math' as math;

import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_test/flutter_test.dart';

/// Os papéis do PRIMEIRO bloco do esquema (`:root`, o claro), por nome.
Map<String, String> _claro(String css) {
  final bloco = RegExp(r':root \{([^}]*)\}').firstMatch(css)!.group(1)!;
  return {
    for (final m in RegExp(r'--diletta-([A-Za-z0-9]+):\s*(#[0-9a-f]{6,8});').allMatches(bloco))
      m.group(1)!: m.group(2)!,
  };
}

Color _cor(String hex) => Color(int.parse('ff${hex.substring(1, 7)}', radix: 16));

double _contraste(String a, String b) {
  final la = _cor(a).computeLuminance(), lb = _cor(b).computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

String _hex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

void main() {
  test('marca CLARA: a tinta do esquema passa AA sobre o primary dele', () {
    final p = CoreflowProduto.daMarca(marca: const Color(0xFF1F91FF), id: 'clara', nome: 'Clara').paleta;
    final claro = _claro(coreflowEsquemaCss(p));
    expect(claro['onPrimary'], isNotNull, reason: 'o esquema não emitiu a tinta do primary dele');
    expect(_contraste(claro['primary']!, claro['onPrimary']!), greaterThanOrEqualTo(4.5),
        reason: '${claro['onPrimary']} sobre ${claro['primary']}');
    // Controle: é exatamente o caso que estava quebrado — a tinta da paleta NÃO passa aqui.
    expect(_contraste(claro['primary']!, _hex(DilettaScheme.light(p).onPrimary)), lessThan(4.5));
  });

  test('marca ESCURA: a tinta é a mesma da paleta — nenhum produto que passava muda', () {
    final p = CoreflowProduto.daMarca(marca: const Color(0xFF2A57A5), id: 'escura', nome: 'Escura').paleta;
    final claro = _claro(coreflowEsquemaCss(p));
    expect(claro['onPrimary'], _hex(DilettaScheme.light(p).onPrimary));
  });
}
