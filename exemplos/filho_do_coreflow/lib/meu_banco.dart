import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Color;

/// Meu Banco — a identidade deste produto, e ela é UMA decisão.
///
/// A rampa de marca inteira deriva desta cor (nove degraus em OKLCH, com o croma limitado ao
/// gamute); a gramática do material — card de vidro, canto do botão, canto da folha, blur — vem do
/// Coreflow; e erro, aviso, sucesso e a rampa neutra vêm da linguagem, porque **cor semântica é
/// invariante**.
///
/// Discordar de um degrau é legítimo e tem lugar: `.comMaterial(...)` sobre a paleta. O que não se
/// faz é declarar 60 hexes à mão — foi o que este comando existe pra não deixar acontecer.
final meuBanco = CoreflowProduto.daMarca(
  marca: const Color(0xFF1B5E20),
  id: 'meuBanco',
  nome: 'Meu Banco',
  // Sem marca declarada, `DilettaBrand.nenhuma`: os componentes desenham, e os que precisam de um
  // arquivo de marca somem em vez de quebrar. Declare o seu e passe aqui:
  //
  //   marcaVisual: const DilettaBrand(
  //     pacote: 'meu_banco_coreflow',
  //     logo: 'assets/logos/meu_banco.svg',
  //     logoFull: 'assets/logos/meu_banco.svg',
  //     logoTingePorCurrentColor: true,
  //   ),
  //
  // Sem tipografia declarada, a escala é a da linguagem e a família é a do app. A sua entra aqui:
  //
  //   tipografia: CoreflowTipografia(familia: 'packages/meu_banco_coreflow/MinhaFonte', ...),
);
