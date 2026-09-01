import 'package:diletta_design_system/diletta_design_system.dart'
    show
        DilettaButtonState,
        DilettaButtonType,
        DilettaNavigationAction,
        DilettaNavigationButton;
import 'package:flutter/material.dart';
import 'bold_botao.dart';

/// Descriptor de um CTA no [CoreflowBotoesDeNavegacao].
///
/// **Ele fica, e o motivo é um campo só.** O descritor do pai
/// ([DilettaNavigationAction]) tem hoje tudo que este tem — inclusive o
/// `isLoading`, que entrou pelo pedido desta casa —, menos [onPressedAsync]:
/// ação assíncrona com trava é COMPORTAMENTO do produto, e o pai já respondeu
/// que não é dele. Então este descritor sobrevive como tradutor, e quem
/// desenha é o pai.
class CoreflowAcaoDeNavegacao {
  const CoreflowAcaoDeNavegacao({
    required this.label,
    this.onPressed,
    this.onPressedAsync,
    this.glyph,
    this.loading = false,
    this.variant,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Ação assíncrona com trava embutida. Use quando a ação for de rede ou mudar
  /// estado; dois toques num CTA de rodapé viram duas requisições.
  ///
  /// **É o único campo sem par do outro lado**, e é de propósito: 2 dos 74 CTAs
  /// deste app usam, e o pai decidiu que espera-com-trava é do produto. O que
  /// viaja pra lá é o par já resolvido — `onPressed` + `isLoading`.
  final Future<void> Function()? onPressedAsync;
  final String? glyph;

  /// Rodela no lugar do rótulo enquanto a ação corre. 12 dos 74 CTAs deste app
  /// usam, e ele **já é o do pai**: vira `DilettaNavigationAction.isLoading`.
  final bool loading;

  /// Override do variant do slot (default: primary→primary, secondary→
  /// secondary, tertiary→text).
  final CoreflowVarianteDeBotao? variant;

  // `trailingGlyph` e `filled` MORRERAM aqui: 82 usos medidos, ZERO passavam os dois. Eram a razão
  // pela qual eu ia pedir dois campos ao pai — e a lição é a mesma que já me pegou duas vezes nesta
  // adoção: contar antes de pedir. O `CoreflowBotao` continua tendo os dois; quem precisar usa o botão.
}

/// A TRADUÇÃO de [CoreflowAcaoDeNavegacao] pro descritor do pai, com a trava do assíncrono.
///
/// Ela nasceu dentro do rodapé (`BoldBottomApp`) e mora aqui desde 2026-08-08,
/// porque passou a ter DOIS consumidores: o rodapé, que embrulha em glass, e o
/// [CoreflowBotoesDeNavegacao] solto, que é a mesma coluna sem envelope. Duas cópias
/// da mesma tabela de tipo é como as duas telas de "Colar" acabaram com dois
/// glifos diferentes — a segunda cópia não erra no dia em que nasce.
///
/// É `mixin` sobre `State` e não função pura por um motivo: a trava do
/// [CoreflowAcaoDeNavegacao.onPressedAsync] é ESTADO. Quem guarda o que está em voo é
/// quem sabe redesenhar quando acaba.
mixin CoreflowAcoesDoPai<T extends StatefulWidget> on State<T> {
  /// Qual slot está com ação assíncrona em voo (0 primário · 1 secundário · 2
  /// terciário). Um só de cada vez: rodapé com dois CTAs correndo junto não é
  /// caso deste app, e travar todos é o comportamento seguro.
  int? _correndo;

  DilettaNavigationAction? acaoDoPai(CoreflowAcaoDeNavegacao? a, int slot) {
    if (a == null) return null;
    final rodando = _correndo == slot;
    final travado = _correndo != null && !rodando;
    return DilettaNavigationAction(
      label: a.label,
      leadIcon: a.glyph,
      isLoading: a.loading || rodando,
      disabled: travado,
      type: _tipo(a.variant),
      state: a.variant == CoreflowVarianteDeBotao.destructive
          ? DilettaButtonState.error
          : DilettaButtonState.normal,
      onPressed: (a.loading || rodando || travado)
          ? null
          : (a.onPressedAsync != null
              ? () => _dispara(a.onPressedAsync!, slot)
              : a.onPressed),
    );
  }

  /// `null` deixa o SLOT decidir (primary→primary, secondary→secondary,
  /// tertiary→tertiary), que é o default do pai e o mesmo do descritor daqui.
  /// Só quando a tela declara `variant` é que o tipo vem escrito.
  DilettaButtonType? _tipo(CoreflowVarianteDeBotao? v) {
    if (v == null) return null;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    return switch (v) {
      CoreflowVarianteDeBotao.primary => DilettaButtonType.primary,
      CoreflowVarianteDeBotao.secondary =>
        escuro ? DilettaButtonType.secondaryWhite : DilettaButtonType.secondary,
      CoreflowVarianteDeBotao.text => escuro
          ? DilettaButtonType.tertiaryWhite
          : DilettaButtonType.tertiaryPrimary,
      CoreflowVarianteDeBotao.white => DilettaButtonType.white,
      // `destructive` vira `state: error` acima; o peso segue o do slot.
      CoreflowVarianteDeBotao.destructive => null,
    };
  }

  Future<void> _dispara(Future<void> Function() acao, int slot) async {
    if (_correndo != null) return;
    setState(() => _correndo = slot);
    try {
      await acao();
    } finally {
      // `mounted` porque CTA de rodapé quase sempre navega: o widget pode já ter
      // saído da árvore quando o Future resolve.
      if (mounted) setState(() => _correndo = null);
    }
  }
}

/// Conta BOLD — NavigationButton. Coluna de 1–3 CTAs empilhados. É o CONTEÚDO
/// do rodapé — sem glass nem home indicator (isso é papel do [BoldBottomApp]).
///
/// **CASCA**: o desenho é do [DilettaNavigationButton]. O que fica aqui é a
/// trava do assíncrono, que é comportamento.
///
/// ```dart
/// CoreflowBotoesDeNavegacao(primary: CoreflowAcaoDeNavegacao(label: 'Continuar', onPressed: submit));
/// ```
class CoreflowBotoesDeNavegacao extends StatefulWidget {
  const CoreflowBotoesDeNavegacao({
    super.key,
    this.primary,
    this.secondary,
    this.tertiary,
  });

  final CoreflowAcaoDeNavegacao? primary;
  final CoreflowAcaoDeNavegacao? secondary;
  final CoreflowAcaoDeNavegacao? tertiary;

  @override
  State<CoreflowBotoesDeNavegacao> createState() => _CoreflowBotoesDeNavegacaoState();
}

class _CoreflowBotoesDeNavegacaoState extends State<CoreflowBotoesDeNavegacao>
    with CoreflowAcoesDoPai {
  @override
  Widget build(BuildContext context) => DilettaNavigationButton(
        primary: acaoDoPai(widget.primary, 0),
        secondary: acaoDoPai(widget.secondary, 1),
        tertiary: acaoDoPai(widget.tertiary, 2),
      );
}
