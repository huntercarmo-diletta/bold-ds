/// CONTA BOLD — os gradientes da marca, e são DOIS.
///
/// Regra do dono do produto (2026-07-30): **no máximo dois — `primary` e `accent`** — e todo o
/// resto se modula neles.
///
/// A regra saiu de graça, o que é raro. O produto antigo declarava dez, e a medição de uso
/// mostrou que **sete tinham ZERO uso**: `pay`, `ted`, `statement`, `receive`, `charge` (azul,
/// âmbar, verde, azul claro e roxo, uma cor por tipo de transação), `balanceCard` e o alias
/// `primaryButton`. Cinco matizes estrangeiros numa marca rosa que ninguém consumia — token
/// morto, não decisão de design.
///
/// Os três que sobravam já eram estes dois, com um nome a mais:
///
/// | antigo | usos | vira |
/// |---|---|---|
/// | `brand` | 6 | **`primary`** |
/// | `pix` | 4 | **`accent`** |
/// | `primaryButtonShort` | 1 | **`accent`** (mesmas duas cores do `pix`) |
///
/// Então a consolidação não migra nada: renomeia dois e apaga sete.
///
/// ## Por que a forma mora aqui, e por quanto tempo
///
/// O pai sabe COMO se constrói gradiente — as três formas dele (`brandLiftDe`, `screenBgDe`,
/// `cardPvDe`) têm ângulo e stops decididos. Mas elas **derivam a própria cor**
/// (`primary03 → primary05`, cravado), então não há fenda de material: um filho não diz quais
/// cores entram. É a mesma metade-de-peça que o vidro tinha antes da v0.4.0, e existe pedido
/// escrito pra isso.
///
/// Enquanto não houver fenda, este arquivo carrega forma E material. Quando houver, a forma sai
/// e sobram as cores — que é o estado certo.
library;

import 'package:flutter/painting.dart';

import 'bold_palette.dart';

/// As duas cores do gradiente que NÃO são degrau de rampa.
///
/// Elas moram aqui e não na paleta porque o tipo do pai não tem campo pra parada de gradiente
/// — e porque são material de gradiente, não degrau de escala: ninguém pinta um botão de coral.
///
/// Ficam nomeadas em vez de literais dentro do gradiente pelo motivo de sempre: valor sem nome
/// é valor que reaparece em outro lugar sem ninguém notar que é o mesmo.
abstract final class BoldGradientStops {
  /// O coral do meio do pôr do sol. É o que sobrou da rampa `accent`, descontinuada em
  /// 2026-07-16 — os usos funcionais dela migraram pra `primary` e os decorativos pra
  /// `warning`, e este gradiente é o último lugar onde o coral ainda tem trabalho.
  static const Color coral = Color(0xFFFE7B5E);

  /// O amarelo da ponta, que é o realce do "O" do logo.
  static const Color amarelo = Color(0xFFFEED35);

  /// O laranja da ponta do `accent` — um corte mais curto e quente do mesmo pôr do sol.
  static const Color laranja = Color(0xFFFB6A1E);
}

/// Os dois gradientes do Conta BOLD.
abstract final class BoldGradients {
  /// **PRIMARY** — o pôr do sol da marca: rosa → coral → amarelo, tirado do anel do "O" do
  /// logo. É o gradiente de momento herói: saldo, CTA principal, avatar de convite.
  ///
  /// A cor de partida vem da PALETA (`primary04`), não de um literal: é o que faz o gradiente
  /// acompanhar a identidade em vez de congelá-la.
  static LinearGradient get primary => LinearGradient(
        begin: const Alignment(-0.8, -1),
        end: const Alignment(0.8, 1),
        colors: [
          BoldPalette.bold.primary04,
          BoldGradientStops.coral,
          BoldGradientStops.amarelo,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  /// **ACCENT** — o corte curto: rosa → laranja, duas paradas. Para controle pequeno, onde o
  /// pôr do sol inteiro fica agitado: chip de ícone, círculo destacado da navegação, Pix.
  static LinearGradient get accent => LinearGradient(
        begin: const Alignment(-0.7, -1),
        end: const Alignment(0.7, 1),
        colors: [BoldPalette.bold.primary04, BoldGradientStops.laranja],
      );

  /// Os dois, pra quem precisa iterar (o catálogo, e o gate que trava a regra em dois).
  static Map<String, LinearGradient> get todos => {
        'primary': primary,
        'accent': accent,
      };

  /// A cor de conteúdo sobre gradiente — e ela **não é branca**, apesar de o produto antigo
  /// dizer que era.
  ///
  /// Medido, branco sobre cada parada do `primary`: rosa **3.46:1**, coral **2.56:1**, amarelo
  /// **1.21:1**. Nenhuma passa AA de texto (4.5), e o amarelo é praticamente invisível. O ink
  /// escuro resolve o outro lado — amarelo 9.43:1, coral 4.45:1 — e afunda no rosa (3.29:1).
  ///
  /// **Não existe uma tinta legível ao longo do pôr do sol inteiro**, e isso é propriedade de
  /// um gradiente que atravessa rosa e amarelo, não defeito de escolha. A consequência é a
  /// regra abaixo, e ela é de desenho:
  ///
  /// > Gradiente da marca é DECORATIVO. Texto sobre ele só em glifo ou em rótulo grande, e com
  /// > o ink escuro — nunca texto corrido, nunca branco.
  ///
  /// O produto antigo tinha `onGradient = white` e um comentário admitindo que "o branco lava
  /// no amarelo" — as duas coisas no mesmo arquivo. Onde isso já dói hoje: as iniciais do
  /// `avatar_stack` e do `avatar_row` são brancas sobre o meio do gradiente, a 2.56:1.
  static Color get onGradient => BoldPalette.bold.neutral01;
}
