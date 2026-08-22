/// CONTA BOLD — operar EM NOME DE outra conta, e a regra veio do app em 21/08.
///
/// Ficou no app com a razão `deliberado` *"a regra de operar em nome de outra conta, que o pai não
/// tem como saber"*. O pai não tem mesmo como saber — e daí não se conclui que a peça mora no app:
/// **regra deste produto é vocabulário DESTE produto, e o pacote é o DS dele.** Terceira peça a
/// mudar de casa pela mesma frase relida, depois do logo e das 16 ilustrações.
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';

import 'bold_type.dart';

/// **CoreflowOperatingContext** — declara, uma vez só no topo da árvore, que o
/// usuário está agindo em nome de OUTRA conta.
///
/// Existe para o aviso não depender de cada tela lembrar de exibi-lo: quem
/// monta o app publica o contexto aqui, e toda [BoldTopBar] passa a mostrar a
/// faixa sozinha. Sem contexto publicado, nada muda em lugar nenhum.
class CoreflowOperatingContext extends InheritedWidget {
  const CoreflowOperatingContext({
    super.key,
    required this.accountName,
    this.role,
    this.onTap,
    required super.child,
  });

  /// Nome da conta em que se está agindo.
  final String accountName;

  /// Papel do usuário nela ("Operador"). Opcional.
  final String? role;

  /// Normalmente abre a troca de conta.
  final VoidCallback? onTap;

  static CoreflowOperatingContext? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CoreflowOperatingContext>();

  @override
  bool updateShouldNotify(CoreflowOperatingContext old) =>
      accountName != old.accountName || role != old.role;
}

/// A faixa em si: uma linha discreta, largura toda, que mora **dentro** da
/// top bar. Pequena de propósito — precisa estar sempre presente sem competir
/// com o conteúdo da tela.
///
/// Normalmente não se usa direto: [BoldTopBar] a insere quando existe um
/// [CoreflowOperatingContext] acima na árvore.
class CoreflowOperatingStrip extends StatelessWidget {
  const CoreflowOperatingStrip({
    super.key,
    required this.accountName,
    this.role,
    this.onTap,
  });

  final String        accountName;
  final String?       role;
  final VoidCallback? onTap;

  /// Lê o contexto publicado e devolve a faixa, ou nada.
  static Widget? maybeOf(BuildContext context) {
    final ctx = CoreflowOperatingContext.of(context);
    if (ctx == null || ctx.accountName.isEmpty) return null;
    return CoreflowOperatingStrip(
      accountName: ctx.accountName,
      role: ctx.role,
      onTap: ctx.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = DilettaTheme.schemeOf(context);
    return Material(
      color: Color(0x00000000),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: DilettaSpacing.s5, vertical: DilettaSpacing.s1),
          color: c.primary.withValues(alpha: 0.14),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            DilettaIcon(name: 'users-light', size: 12, color: c.primary),
            const SizedBox(width: DilettaSpacing.s2),
            Flexible(
              child: Text(
                  role == null
                      ? 'Usando a conta de $accountName'
                      : 'Usando a conta de $accountName · $role',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CoreflowType.labelSm.copyWith(color: c.primary)),
            ),
            if (onTap != null) ...[
              const SizedBox(width: DilettaSpacing.s2),
              DilettaIcon(name: 'chevron-right', size: 11, color: c.primary),
            ],
          ]),
        ),
      ),
    );
  }
}


/// Slot da faixa para telas com **cabeçalho próprio** (comprovante, sucesso,
/// editores em tela cheia) — as que não usam [BoldTopBar] e, por isso, não
/// ganhariam o contexto de graça.
///
/// Renderiza a faixa quando há contexto publicado, e nada quando não há. Uma
/// linha na tela, sem `if` do lado de quem chama.
class CoreflowOperatingSlot extends StatelessWidget {
  const CoreflowOperatingSlot({super.key, this.safeTop = false});

  /// Some o padding da status bar quando a tela ainda não tratou a safe-area.
  final bool safeTop;

  @override
  Widget build(BuildContext context) {
    final strip = CoreflowOperatingStrip.maybeOf(context);
    if (strip == null) return const SizedBox.shrink();
    if (!safeTop) return strip;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: strip,
    );
  }
}
