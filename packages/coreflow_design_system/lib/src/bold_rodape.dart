import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaArestaDeVidro, DilettaBottomApp, DilettaGlassSurface, DilettaNavigationButton;
import 'package:flutter/material.dart';
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_botoes_de_navegacao.dart' show CoreflowAcaoDeNavegacao, CoreflowAcoesDoPai;
import 'bold_espaco.dart' show CoreflowEspaco;
import 'bold_nav_flutuante.dart' show CoreflowItemDeNav;
import 'bold_nav_flutuante.dart' show CoreflowNavFlutuante;


/// Um item da nav ([CoreflowRodape.nav]): o valor que ele seleciona, o rótulo e o [glifo].
///
/// O ícone era `IconData` ou um `iconBuilder` que recebia a cor resolvida — dois eixos pra dizer a
/// mesma coisa, e os três sítios reais usavam o builder só pra montar um `CoreflowIcone(nome)`. Com a
/// pílula vindo do pacote, o item passa a dizer **o nome do glifo no conjunto do pai**, que é o que
/// a peça de lá pede. O `IconData` do Material saiu junto: ele era a última carona do vocabulário
/// estrangeiro nesta casca.
class CoreflowItemDeAba<T> {
  const CoreflowItemDeAba({
    required this.value,
    required this.label,
    required this.glifo,
  });

  final T value;
  final String label;

  /// Nome do glifo no conjunto do pai (`'house-light'`, `'camera-light'`).
  final String glifo;
}

/// Conta BOLD — BottomApp. ÚNICO ponto de entrada pro slot INFERIOR da tela: navegação, CTAs, teclado
/// e combinações, numa [DilettaGlassSurface] com o respiro de 32 + safe-area.
///
/// Variantes:
/// - `.nav(items:, current:, onTap:)`           → barra de navegação (tabs)
/// - `.button(primary:, secondary:, tertiary:)` → 1–3 CTAs empilhados
/// - `.keyboard(onKey:, onDelete:)`             → teclado numérico
/// - `.buttonAndKeyboard(...)`                  → CTA(s) + teclado (ex.: valor)
/// - `.child(child:)`                           → slot custom (escape hatch)
///
/// ## Por que esta casca ainda NÃO é a do pai, e o topo já é
///
/// O `DilettaBottomApp` tem sete factories e cada uma é **tipada nas moléculas do pai**:
/// `.button` exige um `DilettaNavigationButton`, que exige `DilettaNavigationAction`. E esse descritor
/// não tem como dizer **`loading`** — 13 dos 82 CTAs deste app dizem. O bloqueio é no descritor, não na
/// casca: enquanto ele não souber a rodela, os 55 usos de `.button` não têm como entrar lá.
/// Pedido aberto no pai. A casca de topo não tinha esse problema porque a barra que ela recebe já era
/// a dele.
///
/// A `.nav` é outra história: a do pai é barra ANCORADA full-width, itens em `Expanded`, círculo do
/// ativo estourando a borda de cima, traço de home por dentro. A daqui é **pílula flutuante** com hug e
/// margem de 16. Não é cópia da dele com defeito — é outro desenho, e trocar é decisão de produto.
///
/// ```dart
/// CoreflowRodape.button(
///   primary: CoreflowAcaoDeNavegacao(label: 'Continuar', onPressed: submit),
///   secondary: CoreflowAcaoDeNavegacao(label: 'Cancelar', onPressed: pop),
/// );
/// ```
class CoreflowRodape extends StatelessWidget {
  const CoreflowRodape.child({
    super.key,
    required this.child,
    this.acima,
    this.primary,
    this.secondary,
    this.tertiary,
    this.glass = true,
    this.safeBottom = true,
    this.bare = false,
    this.padding = const EdgeInsets.fromLTRB(
        DilettaSpacing.s5, DilettaSpacing.s3, DilettaSpacing.s5, 0),
  });

  /// Navegação (tabs) — barra flutuante de vidro. Cada tab = ícone + rótulo; a
  /// ativa ganha spot rosa + glyph branco. Traz o próprio vidro + respiro
  /// (é `bare`), então não recebe o envelope glass. Método estático (não
  /// construtor) por causa do genérico `<T>` do value — o uso é idêntico:
  /// `CoreflowRodape.nav<int>(current: tab, onTap: …, items: […])`.
  static Widget nav<T>({
    Key? key,
    required List<CoreflowItemDeAba<T>> items,
    required T current,
    required ValueChanged<T> onTap,
  }) =>
      CoreflowRodape.child(
        key: key,
        bare: true,
        glass: false,
        safeBottom: false,
        padding: EdgeInsets.zero,
        child: _NavDeRodape<T>(items: items, current: current, onTap: onTap),
      );

  /// 1–3 CTAs empilhados — **e o envelope é o do PAI desde 2026-08-07**.
  ///
  /// `DilettaBottomApp.button` traz o vidro com aresta declarada, o padding da
  /// família e o **indicador de home de verdade**: o que recolhe com o teclado
  /// aberto e não desenha pill falso quando o SO já desenha o dele.
  ///
  /// Este arquivo já tinha apagado a própria cópia do indicador (a razão está no
  /// `build`, e era exatamente essa: geometria do pai copiada sem as duas regras
  /// de aparelho). A deleção consertou o defeito; esta linha preenche a ausência
  /// que ela deixou — o respiro virou indicador.
  ///
  /// **Muda pixel em 55 sítios**: com 34 de safe area a barra sai de **134 pra
  /// 122**, porque o respiro de 32 + inset dá lugar ao indicador de 34 e o padding
  /// vertical vai de 12/0 pra 16/16.
  /// [acima] renderiza um widget **colado no CTA**, dentro da mesma barra.
  ///
  /// Escrito pelo time do app e chegado por merge em 02/09, com a razão dele: *"um aviso sobre a
  /// assinatura precisa estar onde a pessoa assina, não no topo da tela onde ela já rolou para
  /// longe"*. O caso é o selo de garantia reduzida do Tier C.
  ///
  /// Nulo — o default — não muda nada pra nenhum chamador. Com conteúdo, a barra usa o vidro
  /// genérico desta casca em vez do envelope de CTA do pai, porque o `.livre` dele exige altura
  /// fixa e não recebe conteúdo além do botão.
  const CoreflowRodape.button({
    super.key,
    this.primary,
    this.secondary,
    this.tertiary,
    this.acima,
  })  : child = const SizedBox.shrink(),
        glass = true,
        safeBottom = true,
        bare = false,
        padding = EdgeInsets.zero;

  // Aqui moravam `.keyboard` e `.buttonAndKeyboard`, os dois envelopes de
  // teclado numérico. Zero consumidores em 2026-08-08 — o único numpad do app
  // vivia num sheet de PIN que ninguém abria. Saíram junto com o `BoldKeypad` e
  // o `BoldPinDots`. Se voltar a existir entrada por numpad, o pai tem
  // `DilettaBottomApp.keyboard` e `DilettaKeyboard` prontos.

  final Widget child;

  /// O widget colado ACIMA do CTA, dentro da mesma barra. Só na variante `.button`. Ver o construtor.
  final Widget? acima;

  /// As três ações do rodapé de CTA. Não-nulas só na variante `.button`, e é a
  /// presença delas que diz ao `build` pra usar o envelope do pai.
  final CoreflowAcaoDeNavegacao? primary;
  final CoreflowAcaoDeNavegacao? secondary;
  final CoreflowAcaoDeNavegacao? tertiary;

  final bool glass;
  final bool safeBottom;

  /// `true` = o [child] já é a barra completa (traz vidro/respiro próprios) —
  /// build devolve ele cru, sem envelope. Usado pelo `.nav`.
  final bool bare;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (primary != null || secondary != null || tertiary != null) {
      if (acima == null) {
        return _RodapeDoPai(
            primary: primary, secondary: secondary, tertiary: tertiary);
      }
      // Com conteúdo acima, o envelope do pai não serve: o `.livre` dele exige altura fixa e não
      // recebe nada além do botão. Cai no vidro genérico desta casca.
      return CoreflowRodape.child(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            acima!,
            const SizedBox(height: DilettaSpacing.s3),
            _RodapeDoPai(
                primary: primary, secondary: secondary, tertiary: tertiary),
          ],
        ),
      );
    }
    if (bare) return child;

    final bottomInset =
        safeBottom ? MediaQuery.of(context).padding.bottom : 0.0;

    // Respiro inferior OBRIGATÓRIO do DS: 32 ([CoreflowEspaco.respiroDoRodape]) + a safe-area do aparelho.
    //
    // Aqui havia um ramo `homeIndicator` que desenhava o pill 134×5 do iOS no lugar do respiro. Ele
    // era CÓPIA da geometria do pai sem as duas regras de aparelho que o pai tem — recolher com o
    // teclado aberto, e não desenhar pill fake quando o SO já desenha o de verdade. Mesmo defeito que
    // o pai achou numa cópia privada dele e consertou por deleção na v0.31.0.
    //
    // Medido antes de trocar pelo dele: `homeIndicator: true` tinha ZERO usos em `lib/` e em `test/`.
    // Era cópia com defeito de aparelho que nenhuma tela instanciava — e defeito em caminho que
    // ninguém instancia é defeito que ninguém mede. Então o conserto foi deleção, não adoção.
    final Widget content = Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(padding: padding, child: child),
      SizedBox(height: CoreflowEspaco.respiroDoRodape + bottomInset),
    ]);

    if (!glass) return content;
    // O vidro é do pai desde 2026-08-17, e o filho já declarava a receita inteira na paleta
    // (`tinteDeVidroClaro/Escuro`, `blurDeVidro`, `tracoDeVidroClaro/Escuro`): tinte a 50%, blur 15,
    // traço rosa no escuro e `primary08` no claro. Trocar a construção não mexeu em nenhum valor.
    //
    // **A ARESTA mudou, e é conserto.** A cópia daqui desenhava o traço EMBAIXO — numa barra
    // ancorada no rodapé, isso põe a linha na borda do aparelho, onde ela não separa nada de nada. A
    // gramática do pai é a forma, não o produto: quem está ancorado embaixo separa por CIMA, que é
    // do lado onde existe conteúdo pra separar.
    return DilettaGlassSurface(
      aresta: DilettaArestaDeVidro.cima,
      child: content,
    );
  }
}

/// A PÍLULA da nav — e desde 17/08 ela é a do PACOTE, não a montada aqui.
///
/// Este miolo remontava a peça inteira à mão: vidro (`BoldGlass.fill` + stroke + `BackdropFilter`),
/// raio 26 em `BorderRadius.circular`, rótulo com `fontSize: 10` cravado, spot do ativo e a elevação
/// por fora do clip. O `CoreflowNavFlutuante` do pacote é essa mesma peça, e ela atravessou a fronteira
/// em 13/08 porque um print achou o que gate nenhum media: o catálogo desenhava a barra ANCORADA do
/// pai no lugar da pílula deste produto.
///
/// **O que a travessia mudou, e cada uma é decisão do DS**: raio 26 → `all24` (26 não é degrau da
/// escada); rótulo 10px → `labelSm` (11/16, e 10 não existe na escada); vão ícone→rótulo 3 → 4; e o
/// vidro do claro volta pros 50% da receita, perdendo o desvio de 75% que só esta peça tinha —
/// vidro com exceção por componente é o começo de dois vidros.
///
/// O que fica aqui é a TRADUÇÃO: a nav do app fala por valor (`T`) e a peça fala por índice.
class _NavDeRodape<T> extends StatelessWidget {
  const _NavDeRodape(
      {required this.items, required this.current, required this.onTap});

  final List<CoreflowItemDeAba<T>> items;
  final T current;
  final ValueChanged<T> onTap;

  @override
  Widget build(BuildContext context) {
    // Índice do ativo, e `-1` quando o valor atual não está na fila. Não é defesa: a nav aparece em
    // tela EMPILHADA sobre a home, onde nenhuma aba é a atual, e a peça trata fora-da-lista como
    // "nenhum acende" — o mesmo comportamento que esta casca já tinha por comparação de valor.
    final ativo = items.indexWhere((t) => t.value == current);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: DilettaSpacing.s4),
        child: CoreflowNavFlutuante(
          ativo: ativo,
          aoTrocar: (i) => onTap(items[i].value),
          itens: [
            for (final t in items)
              CoreflowItemDeNav(icone: t.glifo, rotulo: t.label),
          ],
        ),
      ),
    );
  }
}

/// O RODAPÉ DE CTA, montado com o envelope e o descritor do pai.
///
/// É `Stateful` por um motivo só, e ele é o mesmo que mantém o `onPressedAsync`
/// no botão: **o descritor do pai não tem ação assíncrona.** Ele tem `isLoading`
/// (que entrou pelo pedido desta casa na `ds v0.41.0`), mas quem trava o segundo
/// toque enquanto o Future não resolve é quem guarda o estado — e em rodapé de
/// tela de dinheiro, dois toques são duas requisições.
///
/// Então a trava mora aqui e o que viaja pro pai é o par já resolvido:
/// `onPressed` + `isLoading`.
///
/// A tradução em si saiu deste arquivo em 08/08 e virou o mixin `CoreflowAcoesDoPai`, no
/// `bold_navigation_button.dart` — ela ganhou um segundo consumidor, e tabela de
/// tipo duplicada é o defeito que não erra no dia em que nasce.
class _RodapeDoPai extends StatefulWidget {
  const _RodapeDoPai({this.primary, this.secondary, this.tertiary});

  final CoreflowAcaoDeNavegacao? primary;
  final CoreflowAcaoDeNavegacao? secondary;
  final CoreflowAcaoDeNavegacao? tertiary;

  @override
  State<_RodapeDoPai> createState() => _RodapeDoPaiState();
}

class _RodapeDoPaiState extends State<_RodapeDoPai> with CoreflowAcoesDoPai {
  @override
  Widget build(BuildContext context) => DilettaBottomApp.button(
        button: DilettaNavigationButton(
          primary: acaoDoPai(widget.primary, 0),
          secondary: acaoDoPai(widget.secondary, 1),
          tertiary: acaoDoPai(widget.tertiary, 2),
        ),
      );
}
