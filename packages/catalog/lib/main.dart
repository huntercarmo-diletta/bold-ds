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

import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';

import 'chrome_do_bold.dart';
import 'conteudo_do_bold.dart';
import 'ds_do_bold.dart';
import 'medicao_do_bold.dart';

void main() {
  configurarChromeDoBold();
  configurarDsDoBold();
  configurarConteudoDoBold();
  rodarCatalogo(configDoCatalogoDoBold());
}

/// A casca: quais abas existem, e em que ordem.
///
/// O `id` é CONTRATO, não rótulo — ele entra na URL (`#componentes/...`), então mudar
/// quebra link salvo. A ordem da barra é a ordem daqui, e o pai não reorganiza: ele não
/// tem lista de abas, logo não pode mexer na casa do filho num upgrade.
CatalogoConfig configDoCatalogoDoBold() => CatalogoConfig(
      titulo: 'Conta BOLD · DS Catalog',
      marca: 'BOLD · Design System',
      abaInicial: 'fundamentos',
      abas: [
        // FUNDAMENTOS antes de componentes, e a ordem é a da leitura: a identidade deste produto é a
        // paleta, e todo componente daqui é ela derivada. Quem abre o catálogo pela primeira vez
        // precisa ver de onde a cor vem antes de ver o que ela pinta.
        // FUNDAMENTOS é do MOTOR desde a v0.43.0: a prosa que ensina, com índice e renderizador de
        // markdown de bloco (tabela inclusive). A minha página visual saiu, e o que era medição dela —
        // papéis nos dois modos e o relatório de adoção — foi pra aba de conformidade, que é onde
        // medição deste filho mora.
        AbaDoCatalogo(
          id: 'fundamentos',
          label: 'Fundamentos',
          constroi: (_) => const AbaDeFundamentos(),
        ),
        // STYLES é do MOTOR desde a v0.39.0, derivada do `InventarioDeEstilo` que o plugue declara. A
        // minha versão escrita à mão saiu no mesmo commit: peça que o pai entrega, o filho não reescreve.
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
        // O DICIONÁRIO. Ele só existe desde a v0.16.0 do pai, quando as 64 specs passaram a viajar
        // com o pacote — antes moravam na raiz do repo dele e não chegavam a filho nenhum.
        // SPECS é do MOTOR desde a v0.45.0, e ela mede o que a minha media MAIS a outra ponta: contrato
        // sem bloco, que **não é dívida**. Eu tinha feito só o sentido "spec tem bloco?" e chamei a outra
        // metade de "sem bloco aqui" — que é a mesma informação com nome de culpa.
        AbaDoCatalogo(
          id: 'specs',
          label: 'Specs',
          constroi: (_) => const AbaDeSpecs(),
        ),
        AbaDoCatalogo(
          id: 'conformidade',
          label: 'Conformidade',
          constroi: (_) => const _AbaConformidade(),
        ),
      ],
    );

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
