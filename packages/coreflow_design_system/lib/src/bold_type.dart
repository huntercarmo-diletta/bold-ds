/// CONTA BOLD — a ESCALA DE TIPO da marca.
///
/// Terceira coisa a atravessar a fronteira do app pra cá, depois da paleta e das peças. Ela chega
/// por último de propósito: escala de tipo é o token com mais consumidor — **644 sítios do app leem
/// `CoreflowType`** — e mover o que muitos leem é o que menos perdoa erro.
///
/// ## O que deriva e o que é declarado
///
/// Sete degraus são o do pai, medidos um a um em px, altura, peso **e tracking** antes de trocar:
/// `headlineMd` · `headlineSm` · `titleMd` · `bodyLg` · `labelMd` · `bodySm` · `labelSm`. Eles
/// chegam por `DilettaType.X.copyWith(fontFamily: ...)`, e a família é a única coisa que este
/// pacote acrescenta: os degraus do pai **não fixam família de propósito** (herdam do tema), e o
/// produto que consome ainda pode ter um `textTheme` legado dizendo outra coisa.
///
/// Os outros são declarados aqui, e cada um tem razão:
///
/// - **seis têm px que o pai não tem**: `display` 46, `h1` 30, `title` 17, `bodySmall` 13,
///   `mono` 13, `tileLabel` 10;
/// - **cinco têm o px do pai com PESO diferente**: `h2` (22/700 contra o 600 dele), `body`
///   (15/500), `button` (15/700), `label` (12/700 com tracking 1,5) e `monoCaption` (11/400);
/// - **um bate em tudo menos tracking**: `labelLg` é 14/20/500 com **1,4** de tracking, contra
///   **0,1** do `titleSm` do pai. Catorze com 1,4 é outra coisa — é rótulo de seção espaçado, e a
///   diferença aparece em qualquer palavra de quatro letras.
///
/// ## `valorHeroi`, o degrau que nasceu da medição
///
/// Ele existe porque **17 sítios do app cravavam `fontSize` por cima do `display`** — onze com 32 e
/// seis com 34. Nem 32 nem 34 existiam em escada nenhuma, e a divisão entre os dois grupos não era
/// decisão: 34 nas telas de revisar, 32 nas de resultado, dois pixels de diferença que ninguém
/// escolheu. **Um degrau, e ele é 32** — o grupo maior. As seis telas de revisar encolhem 2px, e é
/// isso que faz a escada voltar a ser escada.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/painting.dart';

import 'bold_fonts.dart';

/// ## O PESO é o único eixo que a tela pode sobrescrever — e os outros três não são
///
/// Declarado em 19/08, depois de uma varredura medir 37 sítios de `FontWeight` cru no app. O que ela
/// achou não foram 37 defeitos: foram **23 pedidos da mesma coisa** — o mesmo tamanho, com peso maior
/// — porque esta escada não tem peso 600 abaixo de 24px nem 800 abaixo de 30px.
///
/// | eixo | a tela pode? | por quê |
/// |---|---|---|
/// | `fontWeight` | **pode** | ênfase é decisão de contexto: a mesma linha é rótulo aqui e valor ali |
/// | `fontSize` | **não** | é o degrau. Sobrescrever declara um degrau que ninguém aprovou, e invisível pra quem mede a escada |
/// | `letterSpacing` | **não** | tracking é parte do papel. O `label` tem 1,5 porque é sobrancelha de caixa alta; em frase, o mesmo 1,5 lê como texto espaçado |
/// | `height` | **não** | é o ritmo vertical do degrau, e ele decide onde a linha seguinte cai |
///
/// **Por que o peso é a exceção e não os outros três:** peso não muda geometria. Uma linha em 500 e a
/// mesma em 700 ocupam a mesma caixa, quebram no mesmo ponto e empurram o que vem depois pro mesmo
/// lugar. Tamanho, tracking e altura mudam a caixa — e caixa mudada por fora é a tela redesenhando a
/// escada sem dizer que redesenhou.
///
/// **O que esta decisão NÃO fecha**: o eixo de ênfase nomeado (um `forte` por degrau, que apareceria
/// no catálogo). A demanda medida existe e está escrita — peso 600 ×9, 700 ×9, 800 ×5 — e ela virá com
/// a régua de sempre: quando o mesmo par (tamanho, peso) tiver caso repetido o bastante pra ser
/// vocabulário em vez de escolha de tela.
abstract final class CoreflowType {
  /// A família da UI. `BoldFonts.family` é o nome QUALIFICADO
  /// (`packages/<pacote>/Inter`) — sem o prefixo o Flutter procura no bundle do app e não acha.
  ///
  /// Mutável porque re-skin é uma linha, e porque foi assim que o app pôde trocar a família sem
  /// tocar em 644 sítios.
  static String fontFamily = BoldFonts.family;

  /// Dado técnico (CPF, chave, valor) é a MESMA família, com dígitos tabulares. Código é outra
  /// coisa, e aí o pacote registra o [BoldFonts.monoRaw].
  static String get monoFamily => fontFamily;

  // ── OS SETE QUE DERIVAM DO PAI ────────────────────────────────────────────

  /// 28/36 · 600. O valor do saldo.
  ///
  /// `fontFeatures` explícito é a única diferença contra o degrau do pai, e ela é medida: sem
  /// dígito TABULAR a largura do algarismo muda e o saldo "pula" a cada atualização.
  static TextStyle get headlineMd => DilettaType.headlineMd.copyWith(
        fontFamily: fontFamily,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 24/32 · 600. Título de banner e card grande.
  static TextStyle get headlineSm =>
      DilettaType.headlineSm.copyWith(fontFamily: fontFamily);

  /// 16/24 · 500 · tracking 0,15.
  static TextStyle get titleMd =>
      DilettaType.titleMd.copyWith(fontFamily: fontFamily);

  /// 16/24 · 400 · tracking 0,5.
  static TextStyle get bodyLg =>
      DilettaType.bodyLg.copyWith(fontFamily: fontFamily);

  /// 12/16 · 500 · tracking 0,5.
  static TextStyle get labelMd =>
      DilettaType.labelMd.copyWith(fontFamily: fontFamily);

  /// 12/16 · 400 · tracking 0,4.
  static TextStyle get bodySm =>
      DilettaType.bodySm.copyWith(fontFamily: fontFamily);

  /// 11/16 · 500 · tracking 0,5.
  static TextStyle get labelSm =>
      DilettaType.labelSm.copyWith(fontFamily: fontFamily);

  // ── OS DECLARADOS, COM RAZÃO ──────────────────────────────────────────────

  /// 46 · 800 · tracking -1. O número herói de tela cheia (saldo em destaque).
  static TextStyle get display => TextStyle(
        fontFamily: fontFamily,
        fontSize: 46,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 32 · 800 · tracking -1. **O valor de transação** — revisar, comprovante, resultado.
  ///
  /// Nasceu medindo o app: 17 sítios escreviam `display.copyWith(fontSize: 32 | 34)`. O degrau
  /// existe pra que o décimo oitavo não invente o terceiro número.
  static TextStyle get valorHeroi => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 30 · 800 · tracking -0,5. Título de tela.
  static TextStyle get h1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.1,
      );

  /// 22 · 700. Título de seção. O pai tem 22 em peso 600 (`titleLg`); este produto usa 700.
  static TextStyle get h2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  /// 17 · 700. Título de lista e de card. O pai não tem 17.
  static TextStyle get title => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      );

  /// 15 · 500 · altura 1,6. Corpo de texto.
  static TextStyle get body => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.6,
      );

  /// 13 · 500 · altura 1,5. Apoio menor.
  static TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  /// 15 · 700. Rótulo de botão.
  static TextStyle get button => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      );

  /// 14/20 · 500 · tracking **1,4**. Rótulo de seção espaçado ("Seu saldo", "Menu", "Ver tudo").
  ///
  /// O `titleSm` do pai bate em px, altura e peso, e diverge só no tracking — 0,1 contra 1,4.
  /// Catorze com 1,4 é rótulo espaçado, não título pequeno.
  static TextStyle get labelLg => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
      );

  /// 12 · 700 · tracking 1,5. Sobrancelha em caixa alta.
  static TextStyle get label => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      );

  /// 10/12 · 500 · tracking 0,4. Rótulo de ladrilho de menu.
  static TextStyle get tileLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        height: 12 / 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      );

  /// 13 · 400 tabular. Dado técnico — largura fixa sem trocar de família.
  static TextStyle get mono => TextStyle(
        fontFamily: monoFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 11 · 400 tabular. Legenda técnica.
  static TextStyle get monoCaption => TextStyle(
        fontFamily: monoFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// A escala inteira por nome — pro catálogo iterar e pro gate contar.
  ///
  /// Vocabulário que o consumidor não consegue ENUMERAR é vocabulário pela metade; a lição é do
  /// pai, e ela nasceu do seletor de ícone que expunha 19 de 347.
  static Map<String, TextStyle> get todos => {
        'display': display,
        'valorHeroi': valorHeroi,
        'h1': h1,
        'headlineMd': headlineMd,
        'headlineSm': headlineSm,
        'h2': h2,
        'title': title,
        'titleMd': titleMd,
        'bodyLg': bodyLg,
        'body': body,
        'button': button,
        'labelLg': labelLg,
        'bodySmall': bodySmall,
        'mono': mono,
        'labelMd': labelMd,
        'bodySm': bodySm,
        'label': label,
        'labelSm': labelSm,
        'monoCaption': monoCaption,
        'tileLabel': tileLabel,
      };
}
