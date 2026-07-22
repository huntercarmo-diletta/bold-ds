// Smoke test do catálogo do Design System do Conta BOLD.
//
// Monta o app do catálogo e confirma que a barra de topo (com as abas) renderiza.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conta_bold_ds/main.dart';

void main() {
  testWidgets('Catálogo monta e mostra a barra de topo', (tester) async {
    await tester.pumpWidget(const BoldCatalogApp());
    await tester.pump();

    expect(find.text('Conta BOLD · Design System'), findsOneWidget);
    expect(find.text('Foundations'), findsOneWidget);
    expect(find.text('Integração'), findsOneWidget);
    // Components é a aba default: aparece na barra E como título da tela.
    expect(find.text('Components'), findsWidgets);
  });
}
