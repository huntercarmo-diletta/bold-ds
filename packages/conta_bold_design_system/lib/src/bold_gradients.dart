/// CONTA BOLD — os gradientes da marca, e são DOIS.
///
/// Regra do dono do produto (2026-07-30): **no máximo dois — `primary` e `accent`** — e todo o
/// resto se modula neles. O produto antigo declarava dez; sete tinham ZERO uso (`pay`, `ted`,
/// `statement`, `receive`, `charge`, `balanceCard` e um alias), e os três que restavam eram
/// estes dois com um nome a mais.
///
/// ## A modulação, e o que ela ganhou
///
/// A primeira versão destes dois era o pôr do sol de três paradas — rosa → coral → amarelo, do
/// anel do "O" do logo. Ela caiu por duas razões medidas, e a segunda é a que importa:
///
/// **1 · Nenhuma tinta era legível ao longo dele.** Branco sobre as três paradas dava
/// 3.46 · 2.56 · **1.21** — a última é invisível. O ink escuro resolvia o amarelo (9.43) e
/// afundava no rosa (3.29). Não era erro de escolha: é propriedade de um gradiente que atravessa
/// rosa e amarelo.
///
/// **2 · O coral, o amarelo e o laranja não eram degraus de rampa.** Eram três literais de marca
/// morando neste arquivo, porque a paleta não tem campo pra parada de gradiente — três valores
/// que um rebrand não alcança.
///
/// Modulando pra rosa → laranja **dentro das rampas que já existem**, os dois problemas somem
/// juntos: o gradiente fica 100% derivado da paleta (zero literal) e o branco passa a ler nas
/// duas paradas. A rampa `warning` é o lugar certo do laranja por decisão que o próprio produto
/// já tinha registrado: quando a rampa `accent` coral foi descontinuada em 2026-07-16, os usos
/// decorativos dela migraram pra `warning`.
library;

import 'package:flutter/painting.dart';

import 'bold_palette.dart';

/// Os dois gradientes do Conta BOLD, e os dois saem da paleta.
abstract final class BoldGradients {
  static const _p = BoldPalette.bold;

  /// **PRIMARY** — o rosa da marca indo pro âmbar queimado. Gradiente de momento herói: saldo,
  /// avatar de convite, superfície de destaque.
  ///
  /// `primary04 → warning03`. Branco na pior parada: **3.37:1**.
  static LinearGradient get primary => LinearGradient(
        begin: const Alignment(-0.8, -1),
        end: const Alignment(0.8, 1),
        colors: [_p.primary04, _p.warning03],
      );

  /// **ACCENT** — só laranja, e mais fundo: o âmbar descendo pro tostado. Para controle pequeno,
  /// onde o contraste de matiz do primary fica agitado: chip de ícone, círculo destacado da
  /// navegação, Pix.
  ///
  /// `warning03 → warning02`. Branco na pior parada: **3.37:1**; na outra, **6.54:1**.
  static LinearGradient get accent => LinearGradient(
        begin: const Alignment(-0.7, -1),
        end: const Alignment(0.7, 1),
        colors: [_p.warning03, _p.warning02],
      );

  /// Os dois, pra quem precisa iterar — o catálogo, e o gate que trava a regra em dois.
  static Map<String, LinearGradient> get todos => {
        'primary': primary,
        'accent': accent,
      };

  /// Conteúdo sobre gradiente: **branco**, e agora isto é medido em vez de herdado.
  ///
  /// O produto antigo declarava `onGradient = white` e admitia, no mesmo arquivo, que "o branco
  /// lava no amarelo". Com o amarelo fora, o branco volta a ser a escolha certa — mas pelo
  /// número que importa, que é o PIOR caso e não parada a parada.
  ///
  /// Branco: 3.46 · 3.37 · 3.37 · 6.54. Ink: 3.29 · **3.38** · 3.38 · 1.74. No `warning03` o
  /// ink ganha por 0.01, que é empate técnico; o que decide é `warning02`, onde o ink desaba
  /// pra 1.74 e o branco vai a 6.54. Escolhe-se UMA tinta pro gradiente inteiro, e ela é
  /// julgada onde é mais fraca.
  ///
  /// **A regra de uso que os números impõem**, e ela não é opinião: 3.37 passa AA-grande (3.0) e
  /// não passa AA de texto (4.5). Então sobre gradiente vale glifo, e rótulo a partir de
  /// **18.7px em peso 600** — o piso de "texto grande" na WCAG. Rótulo de botão a 15px não cabe:
  /// esse usa o `primary` SÓLIDO do scheme, onde a conformidade do pai já garante o par.
  ///
  /// Conserto que isto deixa pra adoção: as iniciais do `avatar_stack` e do `avatar_row` são
  /// brancas sobre o meio do gradiente antigo, a 2.56:1. Com o primary novo elas vão a 3.37 —
  /// e como iniciais são rótulo curto em peso 700, cabem se o tamanho ficar acima de 18.7px.
  static Color get onGradient => _p.white;
}
