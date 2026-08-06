/// O CATÁLOGO DO CONTA BOLD — o filho do `catalogo-diletta`.
///
/// Este arquivo é quase só as quatro chamadas. A barra, o board, o compositor, o codegen
/// e o render são do pai; o filho declara o que tem. Se este arquivo começar a crescer
/// com widget de ferramenta dentro, é sinal de que alguma capacidade está sendo
/// reescrita aqui em vez de pedida ao pai.
///
/// A ORDEM das quatro importa: chrome antes de DS porque a paleta de blocos já lê cor do
/// chrome ao montar; conteúdo antes de `rodarCatalogo` porque a config das abas lê as
/// macros declaradas.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';

import 'adocao_do_bold.g.dart';
import 'chrome_do_bold.dart';
import 'conteudo_do_bold.dart';
import 'ds_do_bold.dart';
import 'medicao_do_bold.dart';
import 'telas_do_bold.dart';

void main() {
  configurarChromeDoBold();
  configurarDsDoBold();
  configurarConteudoDoBold();
  rodarCatalogo(configDoCatalogoDoBold());
}

/// A versão desta build, injetada pelo `build_web.sh` a partir do `pubspec`.
const String _versaoDaBuild = String.fromEnvironment('BOLD_VERSAO');

/// A casca: quais abas existem, e em que ordem.
///
/// O `id` é CONTRATO, não rótulo — ele entra na URL (`#componentes/...`), então mudar
/// quebra link salvo. A ordem da barra é a ordem daqui, e o pai não reorganiza: ele não
/// tem lista de abas, logo não pode mexer na casa do filho num upgrade.
CatalogoConfig configDoCatalogoDoBold() {
  // O CANAL DE NAVEGAÇÃO, e sem ele o "✎ Editar tela" era um botão morto.
  //
  // Achado clicando: o dono do produto abriu a aba Telas, clicou em editar e **nada aconteceu**. O board
  // do pai faz a parte dele — `ComposerInbox.requestEditSpec` guarda a tela e chama `openBuilder`. Só que
  // `openBuilder` é um gancho que a CASCA do filho pluga, e eu nunca o pluguei: a tela ia pra caixa de
  // entrada do compositor e ninguém trocava de aba. A caixa enchia em silêncio.
  //
  // É a mesma classe de falta dos 6 campos calados do plugue de conteúdo, um nível acima: **capacidade
  // pronta nos dois lados e sem o fio no meio.** E o modo de falhar é o pior — nada de erro, nada no
  // console, um clique que não faz nada.
  //
  // O `'montar'` é o id da aba do compositor, declarado logo abaixo. Id é contrato: ele entra na URL, e é
  // por ele que o board pede a aba.
  final nav = NavegacaoDoCatalogo();
  ComposerInbox.instance.openBuilder = () => nav.abrir('montar');

  return CatalogoConfig(
      // A VERSÃO no título, e ela existe por um defeito de duas horas.
      //
      // O dono do produto mandou dois prints seguidos de um bundle velho — o navegador servia cache de um
      // service worker registrado antes de eu tirar o service worker. Os dois prints custaram uma volta cada
      // pra descobrir **qual build estava na tela**, e não havia como saber olhando.
      //
      // Agora a aba do navegador diz. O valor vem do `pubspec` por `--dart-define` no `build_web.sh`, então
      // ele não é digitado aqui e não pode divergir. Vazio (num `flutter run`) some — o título fica o de
      // sempre em vez de dizer "vazio".
      titulo: _versaoDaBuild.isEmpty
          ? 'Conta BOLD · DS Catalog'
          : 'Conta BOLD · DS Catalog $_versaoDaBuild',
      marca: 'BOLD · Design System',
      abaInicial: 'fundamentos',
      navegacao: nav,
      // A FONTE DO PRODUTO no chrome, e ela faltava desde o primeiro dia.
      //
      // `BoldFonts` tinha ZERO consumidores neste repo: o catálogo publicado mostrava um DS cuja
      // tipografia é declarada em Styles renderizada na fonte padrão do navegador. Catálogo que erra a
      // fonte erra a coisa mais visível do produto, e nada falhava — a página de Styles continuava dizendo
      // "Inter" enquanto desenhava outra coisa.
      //
      // O gancho é do pai (`ConfigDoCatalogo.fonte`, *"vem do DS do filho"*) e eu nunca o declarei. Achei
      // medindo por que os meus gates de layout mediam texto 76% mais largo que o real.
      //
      // Com o PREFIXO do pacote, e não `familyRaw`: o arquivo mora no pacote do DS, então pro engine a
      // família é `packages/conta_bold_design_system/Inter`. `Inter` cru só resolveria se o catálogo
      // declarasse as fontes de novo — cópia de asset, que é o que a fronteira existe pra evitar.
      fonte: BoldFonts.family,
      abas: [
        // FUNDAMENTOS antes de componentes, e a ordem é a da leitura: a identidade deste produto é a
        // paleta, e todo componente daqui é ela derivada. Quem abre o catálogo pela primeira vez
        // precisa ver de onde a cor vem antes de ver o que ela pinta.
        // FUNDAMENTOS é do MOTOR desde a v0.43.0: a prosa que ensina, com índice e renderizador de
        // markdown de bloco (tabela inclusive). A minha página visual saiu, e o que era medição dela —
        // o relatório de adoção — foi pra aba de conformidade, e o papel semântico nos dois modos foi
        // pra Styles quando a v0.48.0 deixou compor a página.
        AbaDoCatalogo(
          id: 'fundamentos',
          label: 'Fundamentos',
          constroi: (_) => const AbaDeFundamentos(),
        ),
        // STYLES voltou a ser do MOTOR INTEIRA, e o caminho até aqui tem três degraus:
        //
        //   v0.39.0  a página derivada do `InventarioDeEstilo` — a minha, escrita à mão, saiu
        //   v0.48.0  `SecoesDeEstilo.de()`, e eu compus: as famílias dele + o meu papel semântico
        //   v0.53.0  o PAPEL virou peça dele (com hex, significado, amostra e contraste medido), e a
        //            minha casca virou cartão em cima de cartão — o `PaginaDoCatalogo` já é o chrome
        //
        // Então a composição desapareceu por ter sido atendida, o que é o fim certo pra ela. O que era
        // meu agora é DECLARAÇÃO no plugue (`papeis`, `amostraDePapeis`), e declaração não envelhece
        // como página.
        AbaDoCatalogo(
          id: 'styles',
          label: 'Styles',
          constroi: (_) => const AbaDeStyles(),
        ),
        // COMPONENTES é do MOTOR desde a v0.44.0, quando o `previaDeComponente` passou a envolver no
        // gancho `tema` e a dar `Stack` pro bloco de tela cheia — os dois defeitos que me faziam ficar
        // com a minha. Ela traz o que eu não tinha: índice de chips com contagem de uso e a matriz por
        // eixo. Terceira página minha que um release apaga, e a quarta é a de Specs, logo abaixo.
        AbaDoCatalogo(
          id: 'componentes',
          label: 'Componentes',
          constroi: (_) => const AbaDeComponentes(),
        ),
        // O compositor é do PAI e entra como um widget. É o que dispensa o filho de
        // escrever editor de tela — e é a diferença entre "catálogo" e "ferramenta".
        AbaDoCatalogo(
          id: 'montar',
          label: 'Montar tela',
          constroi: (_) => const BuilderScreen(),
        ),
        // O DICIONÁRIO. Ele só existe desde a v0.16.0 do pai, quando as specs passaram a viajar
        // (eram 64 à época, são 77 hoje)
        // com o pacote — antes moravam na raiz do repo dele e não chegavam a filho nenhum.
        // SPECS é do MOTOR desde a v0.45.0, e ela mede o que a minha media MAIS a outra ponta: contrato
        // sem bloco, que **não é dívida**. Eu tinha feito só o sentido "spec tem bloco?" e chamei a outra
        // metade de "sem bloco aqui" — que é a mesma informação com nome de culpa.
        AbaDoCatalogo(
          id: 'specs',
          label: 'Specs',
          constroi: (_) => const AbaDeSpecs(),
        ),
        // TELAS — e ela só existe desde que existem telas.
        //
        // Ficou de fora por dois dias com a razão certa: aba de telas com zero tela é uma página que diz
        // "não há nada" — o mesmo defeito do selo que diz pronto. Agora são duas, uma de cada eixo macro, e
        // o board dá o que nenhuma outra aba dá: o FLUXO (as setas entre telas), o modal de doc com a
        // montagem, e o código de cada uma pronto pra copiar.
        //
        // Os grupos são derivados do prefixo do slug — não há lista escrita à mão, então tela nova aparece
        // aqui sozinha.
        AbaDoCatalogo(
          id: 'telas',
          label: 'Telas',
          constroi: (_) => HandoffLayout(
            title: 'Telas do Conta BOLD',
            description: 'As telas declaradas deste produto, com o fluxo, a documentação e o código. '
                'Cada uma é uma spec no repo — rascunho no navegador não sobrevive ao deploy.',
            groups: gruposDeTelasDoBold(),
          ),
        ),
        AbaDoCatalogo(
          id: 'conformidade',
          label: 'Conformidade',
          constroi: (_) => const _AbaConformidade(),
        ),
        // ADOÇÃO (motor v0.86.0) — a aba que este catálogo pediu, e o inventário é o
        // do APP, não o deste repo: a pergunta que ela responde ("quanto do produto
        // já é o DS?") só tem número do lado de quem consome.
        //
        // O motor não mede nada, e isso é do pedido: varrer a fonte do app é do app.
        // A lista vem GERADA de lá (`dart run tool/inventario_de_adocao.dart`), e o
        // `medidoPor` viaja com ela pra que o número tenha fonte ao lado.
        AbaDoCatalogo(
          id: 'adocao',
          label: 'Adoção',
          constroi: (_) => const AbaDeAdocao(inventario: inventarioDoBold),
        ),
      ],
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// A aba de COMPONENTES e a de SPECS não moram mais aqui
//
// As duas eram escritas à mão neste arquivo, e as duas foram absorvidas pelo motor (v0.44.0 e v0.45.0) —
// junto com Styles (v0.39.0) e Foundations (v0.43.0). Quatro páginas apagadas por release em um dia, e
// todas as quatro eu tinha escrito à mão horas antes.
//
// Não é desperdício: escrever a minha é o que produziu a medição que o pai usou. A de componentes só pôde
// ser trocada depois de eu medir que a dele desenhava com `#0E7C5F` (a paleta de referência) em vez do
// rosa do Bold, e depois de ele consertar. **A página que o filho escreve é o pedido em forma de código.**
//
// O que continua meu neste arquivo: a config das abas e a aba de conformidade — que é medição DESTE filho,
// e por isso não é derivável de plugue nenhum.
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// A aba de conformidade — a checagem do pai rodando contra este filho
// ═══════════════════════════════════════════════════════════════════════════════

/// Mostra `violacoesDoFilho()` na tela.
///
/// Vem de graça: a conformidade é capacidade que o pai ENTREGA, não auditoria que ele
/// faz. Cada violação diz onde, o quê, e qual erro aquilo evita.
class _AbaConformidade extends StatelessWidget {
  const _AbaConformidade();

  @override
  Widget build(BuildContext context) {
    final v = violacoesDoFilho();
    final erros = v.where((x) => x.gravidade == Gravidade.erro).length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                v.isEmpty
                    ? 'Filho completo'
                    : '${v.length} pendência(s) · $erros erro(s)',
                style: CT.tituloGrande,
              ),
              SizedBox(height: CM.gapCompacto),
              Text(
                v.isEmpty
                    ? 'Nenhuma violação. O pai não tem mais nada a cobrar deste filho.'
                    : 'Erro deixa o catálogo quebrado de um jeito que não aparece como '
                        'falha. Aviso funciona pior, e pode ser escolha consciente.',
                style: CT.corpo.copyWith(color: CC.neutral04),
              ),
              SizedBox(height: CM.gapAmplo),
              for (final x in v) _CardDeViolacao(v: x),
              SizedBox(height: CM.gapAmplo),
              // A MEDIÇÃO deste filho, embaixo da conformidade: papel nos dois modos e o relatório de
              // adoção do pai. Estava na minha aba de Fundamentos, que saiu quando o motor passou a
              // entregar Fundamentos como prosa.
              const PainelDeMedicao(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDeViolacao extends StatelessWidget {
  const _CardDeViolacao({required this.v});

  final ViolacaoDoFilho v;

  @override
  Widget build(BuildContext context) {
    final erro = v.gravidade == Gravidade.erro;
    return Container(
      margin: EdgeInsets.only(bottom: CM.gapCompacto),
      padding: EdgeInsets.all(CM.gapPadrao),
      decoration: BoxDecoration(
        color: erro ? CC.error07 : CC.warning07,
        borderRadius: CM.raioBotao,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${v.gravidade.name.toUpperCase()} · ${v.regra}',
              style: CT.rotuloPequeno
                  .copyWith(color: erro ? CC.error04 : CC.warning04)),
          const SizedBox(height: 4),
          Text('${v.onde} — ${v.detalhe}', style: CT.corpoPequeno),
          const SizedBox(height: 4),
          Text('evita: ${v.porQue}',
              style: CT.legenda.copyWith(color: CC.neutral05)),
        ],
      ),
    );
  }
}
