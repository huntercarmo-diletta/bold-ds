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

import 'chrome_do_bold.dart';
import 'conteudo_do_bold.dart';
import 'ds_do_bold.dart';
import 'fundamentos_do_bold.dart';
import 'specs_do_bold.dart';

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
        AbaDoCatalogo(
          id: 'fundamentos',
          label: 'Fundamentos',
          constroi: (_) => const AbaDeFundamentos(),
        ),
        AbaDoCatalogo(
          id: 'componentes',
          label: 'Componentes',
          constroi: (_) => const _AbaComponentes(),
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
// A aba de componentes — desenha cada bloco pelo `build` do próprio DS
// ═══════════════════════════════════════════════════════════════════════════════

/// Lista o vocabulário plugado, grupo por grupo.
///
/// Nenhum componente é redesenhado aqui: cada card chama `BlockDef.build` com os
/// defaults do próprio bloco. É o que garante que o catálogo não vire uma segunda
/// implementação do DS — e é o mesmo caminho que o editor e o codegen usam, então o que
/// se vê nesta aba é o que o app recebe.
class _AbaComponentes extends StatelessWidget {
  const _AbaComponentes();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('O vocabulário do Conta BOLD', style: CT.tituloGrande),
              SizedBox(height: CM.gapCompacto),
              Text(
                'Os componentes são da linguagem (ds-diletta); a cor vem da paleta do '
                'Bold; a ferramenta é do catalogo-diletta. Nenhuma das três coisas foi '
                'escrita aqui.',
                style: CT.corpo.copyWith(color: CC.neutral04),
              ),
              SizedBox(height: CM.gapAmplo),
              for (final grupo in Ds.grupos.entries) ...[
                Text(grupo.key.toUpperCase(),
                    style: CT.sobrescrito.copyWith(color: CC.neutral05)),
                SizedBox(height: CM.gapCompacto),
                for (final tipo in grupo.value) _CardDeBloco(tipo: tipo),
                SizedBox(height: CM.gapPadrao),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDeBloco extends StatelessWidget {
  const _CardDeBloco({required this.tipo});

  final String tipo;

  @override
  Widget build(BuildContext context) {
    final def = Ds.blocos[tipo]!;
    final props = def.defaults();
    return Container(
      margin: EdgeInsets.only(bottom: CM.gapPadrao),
      decoration: BoxDecoration(
        color: CC.white,
        borderRadius: CM.raioPainel,
        border: Border.all(color: CC.neutral09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                CM.gapPadrao, CM.gapCompacto, CM.gapPadrao, CM.gapCompacto),
            child: Row(
              children: [
                Expanded(
                  child: Text(def.label,
                      style: CT.rotulo.copyWith(color: CC.neutral02)),
                ),
                Text(tipo, style: CT.mono.copyWith(color: CC.neutral05)),
              ],
            ),
          ),
          Container(height: 1, color: CC.neutral09),
          // O preview vai no TEMA DO PRODUTO, que é o gancho `tema` do plugue. Sem
          // isso o modo noite da ferramenta escorreria pra dentro da tela documentada.
          Padding(
            padding: EdgeInsets.all(CM.gapAmplo),
            child: Ds.tema(
              Builder(
                builder: (ctx) => ColoredBox(
                  color: DilettaTheme.schemeOf(ctx).bg,
                  // NÃO há `Material` embrulhando aqui, e a razão é uma correção de leitura minha: eu
                  // vi "No Material widget found" ao pumpar esta aba num teste e tratei como defeito
                  // do card. Não era — **a casca do pai monta um `Scaffold`**, então tinta funciona
                  // na tela de verdade. O que faltava era o meu harness, que pumpava a aba solta.
                  // Embrulhar aqui seria carregar peça pra sempre por causa de um teste mal montado.
                  child: Padding(
                      padding: EdgeInsets.all(CM.gapPadrao),
                      // Bloco de TELA CHEIA quer o frame inteiro (é overlay), e numa coluna de
                      // scroll isso é altura INFINITA: estourava o layout e chegava a pintar com
                      // `NaN`. Quem sabe quais são é o plugue (`tiposDeTelaCheia`), então o card
                      // pergunta em vez de adivinhar, e dá a ele a proporção de um aparelho.
                    child: Ds.atual.ehTelaCheia(tipo)
                        ? AspectRatio(aspectRatio: 9 / 16, child: def.build(props))
                        : def.build(props),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
