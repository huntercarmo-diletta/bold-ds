import 'package:diletta_design_system/diletta_design_system.dart'
    show
        DilettaButton,
        DilettaButtonSize,
        DilettaButtonState,
        DilettaButtonType,
        DilettaTheme;
import 'package:flutter/material.dart';


/// Conta BOLD — Button. **CASCA do `DilettaButton` do pai.**
///
/// Eram 300 linhas de desenho próprio (quatro braços de pintura, spec de
/// densidade, glow, opacidade de desabilitado) pra uma peça que o pacote entrega
/// desde sempre. O que sobra aqui é o que é DO PRODUTO: o vocabulário de variante
/// que 107 call sites falam, e a trava de reentrada assíncrona. **Zero exceção** —
/// a que existiu por um dia (o "link branco") era leitura minha e não lacuna do pai:
/// a tinta branca existe em DOIS tipos dele, e o que eu queria era branco sem
/// moldura, que é forma e não cor.
///
/// **Por que casca e não renomear 107 chamadas**: a casca é o que faz a próxima
/// mudança do pai chegar nos 50 arquivos sem tocar em nenhum. Foi ela que
/// absorveu, sem commit de tela, o traço de home descendo 10,5px e o glifo da
/// volta andando 20 (ds v0.47.0).
///
/// ## O mapa, e ele é a parte que decide
///
/// | daqui | vira lá | nota |
/// |---|---|---|
/// | `primary` | `primary` | sólido da marca, raio 16 declarado na paleta (`raioDeBotao`) |
/// | `secondary` no ESCURO | `secondaryWhite` | outline branco sem fill — é o que a tela sobre arte pede |
/// | `secondary` no CLARO | `secondary` | outline cinza sem fill |
/// | `text` no CLARO | `tertiaryPrimary` | texto na cor da marca, sem fundo |
/// | `text` no ESCURO | `tertiaryWhite` | tinta branca, fill translúcido 14%, fio 38% |
/// | `destructive` | `state: error` + `tertiary` (link) ou `primary` (`filled: true`) | |
/// | `white` | `white` | fill branco + texto primary |
/// | `error: true` | `state: error` mantendo o peso da variante | |
/// | `size.lg` (default) | `lg` | 56 nos dois |
/// | `size.sm` | **`md`** | os dois dão 40 — o `sm` do pai é 32, e trocar mudaria pixel |
/// | `size.md` · `size.xs` | `md` · `sm` | zero uso hoje, mapeados pra não deixar buraco |
///
/// ## O que MUDA de pixel, e está declarado porque muda
///
/// O `loading` do pai é `_ThreeBounce` (três pontos), e o daqui era spinner mais
/// a palavra "Carregando". São **10 call sites** e a palavra sai. O tempo de
/// espera passa a falar a língua da família em vez da desta casa — que é o
/// motivo de adotar.
///
/// E os **5** `text` do escuro ganham o fill de 14% e o fio de 38% do `tertiaryWhite`:
/// eram texto solto. É o terceiro nível da família ficando com a forma da família.
enum CoreflowVarianteDeBotao { primary, secondary, text, destructive, white }

/// Densidade. O `xs` (28h) nunca teve uso; ficou pra não quebrar assinatura.
enum CoreflowTamanhoDeBotao { xs, sm, md, lg }

class CoreflowBotao extends StatefulWidget {
  const CoreflowBotao(
    this.label, {
    super.key,
    this.onPressed,
    this.onPressedAsync,
    this.variant = CoreflowVarianteDeBotao.primary,
    this.size = CoreflowTamanhoDeBotao.lg,
    this.glyph,
    this.trailingGlyph,
    this.loading = false,
    this.expand = true,
    this.filled = false,
    this.error = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Ação ASSÍNCRONA com trava embutida: enquanto o Future não resolve, o
  /// botão fica em loading e ignora novos toques.
  ///
  /// **Fica no produto de propósito.** É comportamento, não desenho, e o pai já
  /// respondeu sobre ele: eram 2 usos e o pedido não foi feito. A razão de existir
  /// é dura — `onPressed` é `VoidCallback`, então método `async` ali compila e o
  /// Future é DESCARTADO: dois toques viram duas requisições, e em tela de
  /// dinheiro isso é pagamento duplicado.
  final Future<void> Function()? onPressedAsync;
  final CoreflowVarianteDeBotao variant;
  final CoreflowTamanhoDeBotao size;

  /// Glifo na frente (nome do SVG). O `icon:` de `IconData` SAIU: eram 2 sítios,
  /// os dois `Icons.add_rounded`, e o pai só nomeia glifo — ícone de fonte do
  /// Material dentro de botão do DS é vocabulário de fora entrando pela janela.
  final String? glyph;

  /// Glifo atrás do label (ex.: `chevron-right-light`).
  final String? trailingGlyph;
  final bool loading;

  /// Estica pra largura disponível (default). false = inline.
  final bool expand;

  /// Só pra [CoreflowVarianteDeBotao.destructive]: pill vermelho sólido em vez de link.
  final bool filled;

  /// Adota a paleta destrutiva mantendo o peso da variante — ex.: retry de
  /// operação falha.
  final bool error;

  @override
  State<CoreflowBotao> createState() => _CoreflowBotaoState();
}

class _CoreflowBotaoState extends State<CoreflowBotao> {
  /// Ação assíncrona em voo. Fonte da trava e do loading.
  bool _running = false;

  bool get _loading => widget.loading || _running;

  VoidCallback? get _onPressed {
    if (_running) return null; // trava de reentrada
    if (widget.onPressedAsync != null) return _dispararAssincrona;
    return widget.onPressed;
  }

  Future<void> _dispararAssincrona() async {
    if (_running) return;
    setState(() => _running = true);
    try {
      await widget.onPressedAsync!();
    } finally {
      // `mounted` porque a ação normalmente navega: o botão pode já ter saído
      // da árvore quando o Future resolve.
      if (mounted) setState(() => _running = false);
    }
  }

  DilettaButtonSize get _tamanho => switch (widget.size) {
        CoreflowTamanhoDeBotao.lg => DilettaButtonSize.lg,
        // Os dois dão 40. O `sm` do pai é 32.
        CoreflowTamanhoDeBotao.sm => DilettaButtonSize.md,
        CoreflowTamanhoDeBotao.md => DilettaButtonSize.md,
        CoreflowTamanhoDeBotao.xs => DilettaButtonSize.sm,
      };

  @override
  Widget build(BuildContext context) {
    final escuro = DilettaTheme.schemeOf(context).isDark;

    final (DilettaButtonType tipo, DilettaButtonState estado) = _resolve(escuro);

    return DilettaButton(
      label: widget.label,
      onPressed: _loading ? null : _onPressed,
      type: tipo,
      size: _tamanho,
      state: estado,
      leadIcon: widget.glyph,
      trailIcon: widget.trailingGlyph,
      isLoading: _loading,
      fullWidth: widget.expand,
    );
  }

  (DilettaButtonType, DilettaButtonState) _resolve(bool escuro) {
    final erro = widget.error || widget.variant == CoreflowVarianteDeBotao.destructive;
    final estado = erro ? DilettaButtonState.error : DilettaButtonState.normal;

    // Com erro o PESO manda: variante leve (text/secondary) vira link vermelho,
    // variante de peso vira pill vermelho. É a mesma regra de antes, dita com os
    // tipos do pai em vez de com dois métodos de pintura.
    if (erro) {
      final leve = widget.variant == CoreflowVarianteDeBotao.text ||
          widget.variant == CoreflowVarianteDeBotao.secondary ||
          (widget.variant == CoreflowVarianteDeBotao.destructive && !widget.filled);
      return (
        leve ? DilettaButtonType.tertiary : DilettaButtonType.primary,
        estado
      );
    }

    return switch (widget.variant) {
      CoreflowVarianteDeBotao.primary => (DilettaButtonType.primary, estado),
      CoreflowVarianteDeBotao.secondary => (
          escuro ? DilettaButtonType.secondaryWhite : DilettaButtonType.secondary,
          estado
        ),
      // TEXT é o terceiro nível, e o pai tem os dois: no claro `tertiaryPrimary`
      // (tinta da marca), no escuro `tertiaryWhite` (tinta BRANCA). O que eu chamei
      // de lacuna ontem era outra coisa — a tinta branca sempre existiu, em dois
      // tipos; o que não existe é branco SEM moldura, e isso é forma, não cor.
      //
      // `tertiaryWhite` e não `secondaryWhite` porque nível importa: o primeiro
      // filho usa o `secondaryWhite` pro "Agora não"/"Continuar depois", que é
      // dispensa ao lado do CTA. Aqui, na folha de filtro, o `Limpar filtros` fica
      // EMBAIXO de um `Cancelar` que já é outline branco — dois outlines empilhados
      // leem como o mesmo peso, e o terciário existe pra não ler.
      CoreflowVarianteDeBotao.text => (
          escuro ? DilettaButtonType.tertiaryWhite : DilettaButtonType.tertiaryPrimary,
          estado
        ),
      CoreflowVarianteDeBotao.white => (DilettaButtonType.white, estado),
      // `destructive` sem erro não existe: ele JÁ é erro, tratado acima.
      CoreflowVarianteDeBotao.destructive => (DilettaButtonType.primary, estado),
    };
  }

}
