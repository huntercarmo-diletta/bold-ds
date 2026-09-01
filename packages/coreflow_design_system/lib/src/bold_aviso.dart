import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaInlineAlert, DilettaToast, DilettaToastState;
import 'package:flutter/material.dart';

/// Conta BOLD — a INTENÇÃO do aviso, e ela é o que sobrou deste arquivo.
///
/// O `CoreflowAviso` era uma peça de 75 linhas com receita de cor própria; virou casca do
/// `DilettaInlineAlert` em 22/08. O que fica aqui é o nome que as 30 telas escrevem e este enum de
/// quatro, que mapeia no `DilettaToastState` do pai — `info` → `normal`.
///
/// A quarta intenção é a razão de o enum não ter morrido junto: o pai chama de `normal` o que este
/// produto chama de `info`, e trocar o nome nas 30 telas pra economizar um `switch` de quatro linhas
/// é migração de vocabulário sem ninguém pedindo.
///
/// ```dart
/// CoreflowAviso(
///   intent: CoreflowIntencao.error,
///   title: 'Não foi possível enviar o Pix',
///   message: 'Saldo insuficiente para esta transferência.',
/// );
/// CoreflowAviso(intent: CoreflowIntencao.success, title: 'PIX enviado');
/// ```
enum CoreflowIntencao { error, warning, success, info }

// A RECEITA DE COR E O GLIFO SAÍRAM DAQUI em 22/08, com o `DilettaInlineAlert`.
//
// Eram 75 linhas: o `_IntentSpec` (glifo + tom por intenção), o `_AlertColors` e o `_colorsFor`,
// que montava o par superfície↔texto com `Color.alphaBlend(base @ 14%, surface)` no escuro e um
// wash declarado no claro. A conta era boa e o par passava AA — o que não era meu é a DECISÃO: o
// glifo do aviso é do tom, e o tom é do pai. Enquanto morava aqui, este arquivo era a terceira
// casa da mesma escolha (toast dele, alerta meu, spot dele).

// Spec do TOAST — espelha 1:1 o CpfSeguroToast: glyphs check/xmark/triangle/
// hand-wave, spot filled 34, radius 8, e o estado neutro (info) em neutral10/08
// (o CPF não tem toast rosa/primary). Separado do _spec do CoreflowAviso de propósito
// (o alert inline mantém o visual próprio).
// A RECEITA DO TOAST SAIU DAQUI em 2026-08-07: ela é a do pai (`DilettaToast`), e
// batia campo por campo com a dele — vidro, radius 8, spot filled, subheading,
// padding 12/8 — porque as duas nasceram da mesma spec.
//
// Uma coisa não batia, e é o que a cópia custava: o blur estava CRAVADO em 10 aqui,
// e esta paleta declara 15 (`blurDeVidro`). Todo vidro do produto usava 15 menos
// este. É o defeito que o pai consertou no lado dele com a frase que virou regra da
// família: **a receita é do filho, a construção é do pai**.
class CoreflowAviso extends StatelessWidget {
  const CoreflowAviso({
    super.key,
    required this.intent,
    required this.title,
    this.message,
  });

  final CoreflowIntencao intent;
  final String title;
  final String? message;

  /// **CASCA desde 22/08**: a caixa é o `DilettaInlineAlert` do pai, que entrou na `v0.143.0`
  /// respondendo o pedido desta peça — *"a linguagem tem TOAST que some e não tem AVISO que fica"*,
  /// com os 30 sítios daqui como número.
  ///
  /// O que muda de dono, e é o que o pedido dizia: a caixa (fundo, borda, raio), o glifo — que
  /// passa a vir do TOM e não deste arquivo, pela regra da NN/g que ele cita: *cor com ícone, e UM
  /// indicador* — e a tipografia do par título/mensagem.
  ///
  /// O `onClose` saiu junto: **zero sítios** nos 30, medido com parênteses balanceados. Era o
  /// terceiro caso do mesmo padrão em dois dias (as props `gradient`/`shadow` do `CoreflowCartao` e as
  /// três do `CoreflowSpot`), e a peça do pai não tem esse eixo — o aviso que fica sai quando a
  /// razão dele sai, não quando alguém fecha.
  ///
  /// A quarta intenção deste app é `info`, e ela mapeia no `normal` dele. O `///` da peça conta que
  /// o glifo do `normal` mudou de propósito: o toast cumprimenta com `hand-wave`, e cumprimento é
  /// gesto de quem chega e vai embora — uma informação que FICA pede o disco de informação.
  @override
  Widget build(BuildContext context) => DilettaInlineAlert(
        titulo: title,
        mensagem: message,
        state: switch (intent) {
          CoreflowIntencao.error => DilettaToastState.error,
          CoreflowIntencao.warning => DilettaToastState.warning,
          CoreflowIntencao.success => DilettaToastState.success,
          CoreflowIntencao.info => DilettaToastState.normal,
        },
      );
}

/// Toast flutuante pós-ação. Renderiza via [Overlay] (root), então aparece
/// sobre QUALQUER tela — inclusive rotas sem Scaffold (perfil, hubs pushados),
/// onde o SnackBar do ScaffoldMessenger ficaria preso na fila. Mesma paleta do
/// [CoreflowAviso]: superfície + neutral, glyph no tom.
class CoreflowToast {
  CoreflowToast._();

  static OverlayEntry? _current;

  /// [onTap] torna o toast ACIONÁVEL (usado pelo aviso de push recebido com o
  /// app aberto: tocar abre a notificação). Sem ele o toast segue
  /// transparente ao toque, como antes.
  static void show(
    BuildContext context, {
    required String message,
    String? description,
    CoreflowIntencao intent = CoreflowIntencao.success,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _current?.remove();
    _current = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _VistaDoToast(
        message: message,
        description: description,
        intent: intent,
        duration: duration,
        onTap: onTap,
        onDismissed: () {
          if (_current == entry) _current = null;
          entry.remove();
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }
}

class _VistaDoToast extends StatefulWidget {
  const _VistaDoToast({
    required this.message,
    required this.description,
    required this.intent,
    required this.duration,
    required this.onDismissed,
    this.onTap,
  });
  final String message;
  final String? description;
  final CoreflowIntencao intent;
  final Duration duration;
  final VoidCallback onDismissed;
  final VoidCallback? onTap;

  @override
  State<_VistaDoToast> createState() => _VistaDoToastState();
}

class _VistaDoToastState extends State<_VistaDoToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 240));
  late final Animation<double> _anim =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _c.reverse();
    if (!mounted) return;
    widget.onDismissed();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    // O que fica aqui é APRESENTAÇÃO, e ela não é desenho: overlay na raiz (pra
    // aparecer sobre rota sem Scaffold, onde o SnackBar ficaria preso na fila),
    // instância única, entrada em slide + fade, duração e o toque opcional.
    final toast = DilettaToast(
      title: widget.message,
      subtitle: widget.description,
      state: switch (widget.intent) {
        CoreflowIntencao.success => DilettaToastState.success,
        CoreflowIntencao.error => DilettaToastState.error,
        CoreflowIntencao.warning => DilettaToastState.warning,
        CoreflowIntencao.info => DilettaToastState.normal,
      },
    );
    return Positioned(
      left: 20,
      right: 20,
      top: safeTop + 12,
      // Só ignora o toque quando NÃO há ação — com [onTap] o toast é clicável.
      child: IgnorePointer(
        ignoring: widget.onTap == null,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, child) => Opacity(
            opacity: _anim.value.clamp(0.0, 1.0),
            child: Transform.translate(
                offset: Offset(0, (1 - _anim.value) * -12), child: child),
          ),
          // Material ancestral: o toast vive no Overlay raiz (sem Scaffold), e
          // sem Material o texto ganha o sublinhado amarelo de debug do Flutter.
          child: Material(
            type: MaterialType.transparency,
            child: widget.onTap == null
                ? toast
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onTap!();
                      _dismiss();
                    },
                    child: toast,
                  ),
          ),
        ),
      ),
    );
  }
}
