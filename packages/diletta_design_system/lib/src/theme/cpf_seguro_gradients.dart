import 'package:flutter/widgets.dart';

import 'cpf_seguro_palette.dart';

/// CPF SEGURO — Gradients (degrades).
///
/// Todo degrade do DS mora aqui. Paridade 1:1 com o React
/// (~/Desktop/cpf-seguro-app/src/styles/theme.css: `--banner-gradient`,
/// `--screen-bg`, `--card-pv-bg`).
///
/// Convenção: sempre `LinearGradient` const, com stops explícitos.
/// Uso: `BoxDecoration(gradient: DilettaGradients.screenBg)`.
class DilettaGradients {
  DilettaGradients._();

  // ─── Brand (azul escuro → azul claro) ─────────────────────────────────────

  /// Degrade principal do brand — banner "PARA VOCÊ", ChatCompletionCard.
  /// Escuro (primary-03, topo-esq) → claro (primary-05, baixo-dir).
  /// Escala escuro → claro na leitura visual, começa profundo e "abre" pro
  /// azul mais luminoso.
  // As três `const` (brandLift/screenBg/cardPv) moravam aqui, geradas do DTCG com
  // os hexes do CPF SEGURO — nome do pai, valor de filho. Foram pro filho
  // (`CpfSeguroGradients`), onde o app e o catálogo acham elas pelo mesmo nome.
  //
  // O que fica aqui é a FORMA: mesmos ângulos, mesmos stops, cor vinda da paleta.

  // ═══════════════════════════════════════════════════════════════════════════
  // DERIVADOS DA PALETA — é isto que faz o gradiente ser do FILHO
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Os três acima são constantes com os hexes do CPF SEGURO. Isso significa que um
  // DS-filho com identidade verde receberia um card com gradiente AZUL — a marca
  // vazando por um caminho que ninguém olha. Achado pelo `segundo_filho_do_ds_test`
  // do catálogo.
  //
  // As versões abaixo montam o MESMO gradiente a partir dos degraus da paleta. Pro
  // flavor CPF o resultado é idêntico ao constante (primary03 → primary05, branco →
  // primary08/09), então nenhum pixel muda; pra outro flavor, acompanha a identidade.
  //
  // ─── CLARO/ESCURO: a regra, medida (2026-07-29) ─────────────────────────
  //
  // O item ficou anos como "decisão aberta". Medindo os três usos, ele se parte em dois e cada
  // metade já está resolvida:
  //
  // 1. **gradiente de MARCA** (`brandLift` — botão, banner de status, card de conclusão) NÃO reage
  //    ao tema, igual um logo não muda de cor no escuro. É a decisão do ADR-003, e ela vale.
  // 2. **gradiente de SUPERFÍCIE** (`screenBg` — fundo de tela) NÃO É USADO no escuro: o
  //    `DilettaSurface` troca por cor sólida (`s.bg`). Superfície reage ao tema, e a forma de
  //    reagir é deixar de ser gradiente — um degradê que termina em branco viraria um facho de luz
  //    numa tela escura.
  // 3. `cardPv` não é aplicado por componente NENHUM: é token em vitrine. Enquanto não tiver
  //    consumidor, não há decisão a tomar — e inventar uma agora seria decidir por um caso que não
  //    existe.
  //
  // O segundo filho deu um segundo caso pro item, e ele não muda nenhuma das duas regras: o que ele
  // pediu de verdade eram as SUPERFÍCIES do escuro (feito na v0.1.9) e o tinte do vidro.
  //
  // Derivar da paleta e reagir ao tema são coisas diferentes: derivar é o que torna o gradiente do
  // FILHO; reagir é o que torna a superfície do TEMA.

  /// [brandLift] a partir de [p]. Card e banner de marca.
  static LinearGradient brandLiftDe(DilettaPalette p) => LinearGradient(
        begin: const Alignment(-0.5, -1),
        end: const Alignment(1, 0.5),
        stops: const [0.0425, 0.8665],
        colors: [p.primary03, p.primary05],
      );

  /// [screenBg] a partir de [p]. Fundo de tela full-screen.
  static LinearGradient screenBgDe(DilettaPalette p) => LinearGradient(
        begin: const Alignment(0, -1),
        end: const Alignment(0, 1),
        colors: [p.white, p.primary08],
      );

  /// [cardPv] a partir de [p]. Degrade quase invisível de card.
  static LinearGradient cardPvDe(DilettaPalette p) => LinearGradient(
        begin: const Alignment(-0.62, -0.78),
        end: const Alignment(0.62, 0.78),
        colors: [p.white, p.primary09],
      );
}
