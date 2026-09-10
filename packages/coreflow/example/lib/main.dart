/// O WHITE LABEL RODANDO — um app inteiro vestido com a marca da Diletta, e nenhuma linha dele é da marca.
///
/// É a receita do `///` de `CoreflowProduto`, aplicada à marca da casa: o `ThemeData` claro e escuro
/// saem do MESMO produto (`Diletta.materialClaro/Escuro`), e o `DilettaThemeScope` — o que os
/// componentes do DS leem — segue o brilho que o `MaterialApp` resolveu. A fonte (Inter) chega pelo
/// `ThemeData`, a cor pelo esquema, o logo pela marca declarada; o app só escolhe o modo.
///
/// Rodar: `flutter run` (web, macOS, iOS ou Android). Trocar de modo: os três botões da base.
library;

import 'package:diletta_coreflow/diletta_coreflow.dart';
import 'package:flutter/material.dart';

void main() => runApp(const AppDaDiletta());

class AppDaDiletta extends StatefulWidget {
  const AppDaDiletta({super.key});

  @override
  State<AppDaDiletta> createState() => _AppDaDilettaState();
}

class _AppDaDilettaState extends State<AppDaDiletta> {
  ThemeMode _modo = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diletta',
      debugShowCheckedModeBanner: false,
      theme: Diletta.materialClaro,
      darkTheme: Diletta.materialEscuro,
      themeMode: _modo,
      // O ESCOPO DO DS SEGUE O BRILHO que o MaterialApp resolveu — inclusive em `ThemeMode.system`,
      // em que quem decide é o aparelho. Ler `Theme.of(ctx)` aqui, e não `_modo`, é o que faz os
      // dois (Material e DS) nunca discordarem sobre qual tema está na tela.
      builder: (ctx, filho) {
        final escuro = Theme.of(ctx).brightness == Brightness.dark;
        return DilettaThemeScope(
          theme: escuro ? Diletta.temaEscuro : Diletta.temaClaro,
          child: filho!,
        );
      },
      home: _Vitrine(modo: _modo, aoEscolher: (m) => setState(() => _modo = m)),
    );
  }
}

/// A tela de exemplo do pacote, com a base de troca de modo por baixo.
class _Vitrine extends StatelessWidget {
  const _Vitrine({required this.modo, required this.aoEscolher});

  final ThemeMode modo;
  final ValueChanged<ThemeMode> aoEscolher;

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final c = CoreflowScheme.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: TelaDeExemploDiletta(escuro: escuro),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  DilettaSpacing.s5, DilettaSpacing.s3, DilettaSpacing.s5, DilettaSpacing.s5),
              child: Row(
                children: [
                  for (final (rotulo, m) in const [
                    ('Claro', ThemeMode.light),
                    ('Escuro', ThemeMode.dark),
                    ('Sistema', ThemeMode.system),
                  ]) ...[
                    Expanded(
                      child: CoreflowBotao(
                        rotulo,
                        variant: modo == m
                            ? CoreflowVarianteDeBotao.primary
                            : CoreflowVarianteDeBotao.secondary,
                        onPressed: () => aoEscolher(m),
                      ),
                    ),
                    if (m != ThemeMode.system) SizedBox(width: DilettaSpacing.s3),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
