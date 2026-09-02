import 'package:flutter/material.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'bold_background.dart' show CoreflowBackground;
import 'bold_barra_de_topo.dart' show CoreflowBarraDeTopo;
import 'bold_botao.dart' show CoreflowBotao, CoreflowVarianteDeBotao;
import 'bold_etiqueta.dart' show CoreflowEtiqueta;
import 'bold_busy.dart' show CoreflowBusy;
import 'bold_espaco.dart' show CoreflowEspaco;
import 'bold_scheme.dart' show CoreflowScheme;
import 'bold_largura.dart' show CoreflowLarguraDeConteudo;

/// AS DUAS PÁGINAS DESTE PRODUTO, e o rodapé de ação que elas carregam.
///
/// Vieram de `lib/shared/widgets/bold_scaffold.dart` do app em 01/09. Elas nunca estiveram na pasta
/// `design_system/` de lá — e é por isso que o gate que esvaziou aquela pasta não as via. O que as
/// entrega é o outro lado da mesma régua: **uma classe `Bold*` que estende `Widget` é vocabulário**,
/// e vocabulário com nome de marca é o que impede um filho de existir.
///
/// O par não é claro × escuro, apesar dos nomes antigos (`BoldLightScaffold`/`BoldDarkScaffold`):
/// as duas usam o `CoreflowBackground`, que resolve por tema. **A diferença é o RODAPÉ.**
///
/// - [CoreflowPagina] — 37 sítios. O rodapé fica ABAIXO do conteúdo, e o corpo respeita a safe area
///   embaixo quando não há rodapé;
/// - [CoreflowPaginaComRodapeFlutuante] — 5 sítios. `extendBody: true`: o conteúdo corre POR BAIXO
///   do rodapé, que é o que a nav flutuante deste produto pede.
///
/// As duas travam o corpo quando o rodapé está carregando ([CoreflowBusy]), e isso não é enfeite: um
/// CTA em voo com o formulário ainda editável é o defeito que o `CoreflowBusyScope` existe pra
/// fechar.


/// O rodapé declarou que está carregando? Então o corpo da tela está ocupado.
///
/// Os scaffolds RECEBEM o botão de rodapé como widget, então dá para ler o
/// estado dele e travar o formulário sem a tela repetir o flag. Cobre de uma
/// vez as ~24 telas que usam [CoreflowAcaoDeRodape] — sem isso, cada uma teria que
/// lembrar de envolver o próprio corpo em [CoreflowBusy].
bool _rodapeCarregando(Widget? bottomBar) =>
    bottomBar is CoreflowAcaoDeRodape && bottomBar.loading;

/// Scaffold dark padrão para telas com fundo gradiente (hub, splash, comprovantes)
class CoreflowPaginaComRodapeFlutuante extends StatelessWidget {
  const CoreflowPaginaComRodapeFlutuante({
    super.key,
    required this.body,
    this.title,
    this.backLabel = '← Voltar',
    this.action,
    this.showBackButton = true,
    this.floatingActionButton,
    this.bottomBar,
    this.bottom,
    this.header,
  });

  final Widget  body;
  final String? title;
  final String  backLabel;
  final DilettaNavigationRightAccessory? action;
  final bool    showBackButton;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final PreferredSizeWidget? bottom;
  /// Header fixo abaixo do título (ex.: foto + seletor de conta).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final hasHeader = header != null;
    // Rodapé carregando ⇒ corpo travado. Ver [_rodapeCarregando].
    final corpo = CoreflowBusy(busy: _rodapeCarregando(bottomBar), child: body);
    return Scaffold(
      backgroundColor: DilettaAbsoluteColors.transparent,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: CoreflowBackground(
        child: Column(children: [
          if (hasHeader) ...[
            SafeArea(bottom: false, child: header!),
            _barra(context, title, showBackButton, action, null, bottom),
          ] else
            _barra(context, title, showBackButton, action, null, bottom),
          Expanded(child: corpo),
        ]),
      ),
      floatingActionButton: floatingActionButton,
      // O TETO alcança o rodapé, e não só o corpo: numa tela larga um CTA de ponta a ponta com o
      // conteúdo parado em 600 lê como duas colunas diferentes. Veio do time do app por merge.
      bottomNavigationBar:
          bottomBar == null ? null : CoreflowLarguraDeConteudo(child: bottomBar!),
    );
  }
}

/// Scaffold padrão para telas de formulário e configurações.
/// Usa o mesmo fundo atmosférico dark das demais telas do app.
class CoreflowPagina extends StatelessWidget {
  const CoreflowPagina({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = true,
    this.trailing,
    this.bottom,
    this.bottomBar,
    this.resizeToAvoidBottomInset = true,
    this.header,
    this.onBack,
  });

  final Widget  body;
  final String? title;
  final bool    showBackButton;
  final DilettaNavigationRightAccessory? trailing;
  final PreferredSizeWidget? bottom;
  final Widget? bottomBar;
  final bool    resizeToAvoidBottomInset;
  /// Header fixo abaixo do título (ex.: foto + seletor de conta).
  final Widget? header;
  /// Ação do botão de voltar. Quando nulo, faz `Navigator.maybePop()`. Usado por
  /// telas que são ABAS (sem pilha) para voltar à Home em vez de tentar pop.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final hasHeader = header != null;
    // Rodapé carregando ⇒ corpo travado. Ver [_rodapeCarregando].
    final corpo = CoreflowBusy(busy: _rodapeCarregando(bottomBar), child: body);
    return Scaffold(
      backgroundColor: DilettaAbsoluteColors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: CoreflowBackground(
        child: Column(children: [
          if (hasHeader) SafeArea(bottom: false, child: header!),
          _barra(context, title, showBackButton, trailing, onBack, bottom),
          Expanded(
            child: SafeArea(top: false, bottom: bottomBar == null, child: corpo),
          ),
          if (bottomBar != null) SafeArea(top: false, child: bottomBar!),
        ]),
      ),
    );
  }
}

/// A barra de topo dos scaffolds legados — agora a **CoreflowBarraDeTopo do DS**, não
/// mais um `AppBar` do Material.
///
/// Trocar aqui dentro migrou ~37 telas de uma vez: elas continuam chamando
/// `CoreflowPagina`/`CoreflowPaginaComRodapeFlutuante` com a mesma API e passam a receber o
/// vidro, o respiro e a faixa de "agindo em nome de" do DS. Sem isto, seria
/// tela por tela.
Widget _barra(
  BuildContext context,
  String? title,
  bool showBack,
  DilettaNavigationRightAccessory? action,
  VoidCallback? onBack,
  PreferredSizeWidget? bottom,
) {
  final barra = CoreflowBarraDeTopo.page(
    title: title ?? '',
    onBack: showBack
        ? () {
            // Recolhe o teclado antes de sair (senão a tela some com o
            // teclado aberto e o frame pisca).
            FocusManager.instance.primaryFocus?.unfocus();
            if (onBack != null) {
              onBack();
            } else {
              Navigator.of(context).maybePop();
            }
          }
        : null,
    // Era `Widget?` embrulhado num acessório `.custom`, e a escotilha morreu com
    // ele: medi os 11 chamadores e **os 11 passavam botão de ícone** — 9 o mesmo
    // `xmark` de fechar cadastro, 2 `IconButton` de Material anterior ao DS.
    // Todos cabem no `.icons` do pai, então não houve o que pedir.
    action: action,
  );
  if (bottom == null) return barra;
  return Column(mainAxisSize: MainAxisSize.min, children: [barra, bottom]);
}

class OnboardingPjChip extends StatelessWidget {
  const OnboardingPjChip({super.key});

  @override
  // A etiqueta AMPLA é peça: era wash a 22 com borda a 90 e padding 10/x1, cravados. O glifo de
  // 13 vira o acessório de 16 do porte — 13 não existe na escala.
  Widget build(BuildContext context) => const CoreflowEtiqueta(
        label: 'Abertura de conta PJ',
        tone: DilettaStatusTone.primary,
        icon: 'building-light',
        porte: DilettaStatusTagPorte.ampla,
      );

}

class OnboardingProgressBar extends StatelessWidget
    implements PreferredSizeWidget {
  const OnboardingProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Size get preferredSize => const Size.fromHeight(4);

  @override
  Widget build(BuildContext context) {
    // A barra é a do DS. Era `LinearProgressIndicator` do Material com trilho,
    // tinta e altura escolhidos aqui — e a `.value` do pai é exatamente isto:
    // progresso contínuo 0..1 com a skin de atividade.
    return DilettaProgressBar.value(value: current / total);
  }
}

/// Botão de ação fixo no rodapé (usado em telas de formulário)
class CoreflowAcaoDeRodape extends StatelessWidget {
  const CoreflowAcaoDeRodape({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.enabled = true,
    this.accent = false,
    this.secondaryLabel,
    this.onSecondaryTap,
  });

  final String       label;
  final VoidCallback onTap;
  final bool         loading;
  final bool         enabled;
  /// Era a escolha entre as DUAS cores de CTA do DS antigo (o laranja e o
  /// rosa). Na escala de hoje o CTA é um só, então o que sobrou deste sinalizador
  /// é a trava do loading: nas telas que pediam `accent`, botão em loading não
  /// aceita toque.
  final bool         accent;
  final String?      secondaryLabel;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(CoreflowEspaco.gutter, DilettaSpacing.s4, CoreflowEspaco.gutter, bottomPad + DilettaSpacing.s3),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CoreflowScheme.of(context).textPrimary.withAlpha(30), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loading DESABILITA o toque. Antes, `loading: true` só trocava o
          // rótulo por spinner e o botão continuava clicável — o CTA de rodapé é
          // justamente onde o usuário insiste quando a rede demora, e cada
          // insistência virava outra requisição.
          //
          // O `accent` era a segunda cor do DS antigo (o CTA laranja). Na escala
          // de hoje o CTA é UM, e a diferença que sobrou é só a trava do loading.
          CoreflowBotao(
            label,
            onPressed: (enabled && !(accent && loading)) ? onTap : null,
            loading: loading,
          ),
          if (secondaryLabel != null) ...[
            const SizedBox(height: DilettaSpacing.s2),
            CoreflowBotao(
              secondaryLabel!,
              variant: CoreflowVarianteDeBotao.secondary,
              onPressed: onSecondaryTap,
            ),
          ],
        ],
      ),
    );
  }
}
