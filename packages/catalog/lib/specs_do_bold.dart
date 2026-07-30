/// A ABA DE SPECS — o dicionário da linguagem: o do PAI e o DESTE FILHO, na mesma página.
///
/// **Ela listava só as do pai, e isso era um defeito meu.** Relatado duas vezes pelo dono do produto
/// ("suas specs não renderizam"), e na primeira eu respondi que os componentes do Bold não tinham
/// contrato — o que era verdade naquele momento. Escrevi os doze, e continuou não aparecendo: **a aba
/// percorria `kDilettaSpecs.keys` e nada mais.** Os contratos existiam, alimentavam o cabeçalho da aba de
/// componentes, e nunca entraram no dicionário.
///
/// A lição é a de sempre nesta sessão, e desta vez foi contra mim duas vezes seguidas: **a primeira
/// explicação plausível não é a medição.** Eu tinha o teste da aba passando com 69 cards e ele nunca
/// perguntou "e os meus doze?".
///
/// As 64 specs moravam em `specs/` na RAIZ do repo do pai, e o que viaja é o pacote — então elas nunca
/// chegavam. Agora chegam como `kDilettaSpecs` (mapa `slug → markdown`), Dart gerado e não asset: asset
/// exigiria `rootBundle`, que é assíncrono e não existe em teste sem bundle.
///
/// ## O que esta aba faz, e o que ela recusa fazer
///
/// Ela **não copia** spec nenhuma pro repo. O aviso do pai é explícito e a limpa concorda: cópia de
/// dicionário envelhece calada. O que ela faz é o cruzamento que só o filho pode fazer —
///
/// **ligar cada spec do pai ao BLOCO que a implementa aqui.** O pai não sabe quais componentes este
/// produto declarou; eu sei. Então a lista mostra, por spec, se o vocabulário do Bold já a usa, e é isso
/// que transforma 64 documentos numa medida de cobertura.
///
/// O renderizador é deliberadamente pequeno — título, requisito, texto, código, lista. Markdown completo
/// é biblioteca, e nada nesta aba pede mais que isso.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';

/// O slug da spec derivado do nome do componente: `DilettaButton` → `design-system-button`.
///
/// Derivado e não escrito à mão: com 64 specs e 43 blocos, uma tabela de correspondência à mão erra e
/// ninguém percebe — a spec simplesmente aparece como "sem bloco".
String _slugDe(String classe) {
  final semPrefixo = classe.replaceFirst(RegExp(r'^(ds\.)?Diletta'), '');
  final kebab = semPrefixo
      .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '-${m.group(0)!.toLowerCase()}')
      .replaceFirst(RegExp(r'^-'), '');
  return 'design-system-$kebab';
}

/// Spec → blocos deste catálogo que a implementam. Vazio = a linguagem tem o contrato e este produto
/// ainda não usa.
Map<String, List<String>> _blocosPorSpec() {
  final mapa = <String, List<String>>{};
  for (final def in Ds.blocos.values) {
    final ctor = def.ctor;
    if (ctor == null || !ctor.contains('Diletta')) continue;
    // Construtor nomeado (`ds.DilettaAppListRow.menuItem`) aponta pra a spec da CLASSE.
    final classe = ctor.split('.').where((p) => p.startsWith('Diletta')).first;
    (mapa[_slugDe(classe)] ??= []).add(def.type);
  }
  return mapa;
}

class AbaDeSpecs extends StatelessWidget {
  const AbaDeSpecs({super.key});

  @override
  Widget build(BuildContext context) {
    final porSpec = _blocosPorSpec();
    final doPai = kDilettaSpecs.keys.toList()..sort();
    final doFilho = kBoldSpecs.keys.toList()..sort();
    final comBloco = doPai.where((s) => porSpec.containsKey(s)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Specs da linguagem', style: CT.tituloGrande),
              SizedBox(height: CM.gapCompacto),
              Text(
                '${kDilettaSpecs.length} contratos do PAI (lidos do pacote, nenhum copiado) e '
                '${kBoldSpecs.length} escritos NESTE filho, pros componentes que só o Bold tem. '
                'Do vocabulário do pai, ${comBloco.length} já têm bloco aqui.',
                style: CT.corpo.copyWith(color: CC.neutral04),
              ),
              SizedBox(height: CM.gapAmplo),
              // OS DESTE FILHO PRIMEIRO, e não por vaidade: são os que ninguém mais tem, e são os que
              // alguém abre o catálogo do Bold pra ler. O dicionário do pai é consulta; este é decisão
              // deste produto.
              Text('DESTE PRODUTO', style: CT.sobrescrito.copyWith(color: CC.primary04)),
              SizedBox(height: CM.gapCompacto),
              for (final tipo in doFilho)
                _CardDeSpec(
                  slug: tipo,
                  markdown: kBoldSpecs[tipo]!,
                  blocos: Ds.blocos.containsKey(tipo) ? [tipo] : const [],
                  doFilho: true,
                ),
              SizedBox(height: CM.gapAmplo),
              Text('DA LINGUAGEM', style: CT.sobrescrito.copyWith(color: CC.neutral05)),
              SizedBox(height: CM.gapCompacto),
              for (final slug in doPai)
                _CardDeSpec(
                  slug: slug,
                  markdown: kDilettaSpecs[slug]!,
                  blocos: porSpec[slug] ?? const [],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDeSpec extends StatefulWidget {
  const _CardDeSpec({
    required this.slug,
    required this.markdown,
    required this.blocos,
    this.doFilho = false,
  });

  final String slug;
  final String markdown;
  final List<String> blocos;

  /// Contrato escrito NESTE repo. Muda o chip: o do pai é "tem bloco aqui?"; o do filho é sempre sim (ele
  /// existe porque o componente existe), então o chip diz de onde vem.
  final bool doFilho;

  @override
  State<_CardDeSpec> createState() => _CardDeSpecState();
}

class _CardDeSpecState extends State<_CardDeSpec> {
  bool _aberto = false;

  /// Só os requisitos (`### Requirement:`), que é o que se consulta. O corpo inteiro fica atrás do
  /// toque: 64 specs abertas de uma vez é uma parede de texto que ninguém lê.
  List<String> get _requisitos => widget.markdown
      .split('\n')
      .where((l) => l.startsWith('### Requirement:'))
      .map((l) => l.replaceFirst('### Requirement:', '').trim())
      .toList();

  @override
  Widget build(BuildContext context) {
    final temBloco = widget.blocos.isNotEmpty;
    return Container(
      margin: EdgeInsets.only(bottom: CM.gapCompacto),
      decoration: BoxDecoration(
        color: CC.white,
        borderRadius: CM.raioPainel,
        border: Border.all(color: CC.neutral09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _aberto = !_aberto),
            borderRadius: CM.raioPainel,
            child: Padding(
              padding: EdgeInsets.all(CM.gapPadrao),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.slug.replaceFirst('design-system-', ''),
                            style: CT.rotulo.copyWith(color: CC.neutral02)),
                        const SizedBox(height: 2),
                        Text('${_requisitos.length} requisito(s)',
                            style: CT.legenda.copyWith(color: CC.neutral05)),
                      ],
                    ),
                  ),
                  // O cruzamento que só o filho pode fazer: o pai não sabe o que este produto declarou.
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: widget.doFilho
                          ? CC.primary08
                          : (temBloco ? CC.success07 : CC.neutral10),
                      borderRadius: CM.raioBotao,
                    ),
                    child: Text(
                      widget.doFilho
                          ? 'nasceu aqui'
                          : (temBloco ? widget.blocos.join(' · ') : 'sem bloco aqui'),
                      style: CT.rotuloPequeno.copyWith(
                          color: widget.doFilho
                              ? CC.primary04
                              : (temBloco ? CC.success04 : CC.neutral05)),
                    ),
                  ),
                  SizedBox(width: CM.gapCompacto),
                  Icon(_aberto ? Icons.expand_less : Icons.expand_more,
                      size: 18, color: CC.neutral05),
                ],
              ),
            ),
          ),
          if (_aberto) ...[
            Container(height: 1, color: CC.neutral09),
            Padding(
              padding: EdgeInsets.all(CM.gapPadrao),
              child: _Markdown(texto: widget.markdown),
            ),
          ],
        ],
      ),
    );
  }
}

/// Renderizador MÍNIMO de markdown: cabeçalho, bloco de código, item de lista e parágrafo.
///
/// Deliberadamente pequeno. Markdown completo é biblioteca, e o que estas specs usam é isto — medido
/// abrindo as 64: nenhuma tem tabela, imagem ou HTML embutido.
class _Markdown extends StatelessWidget {
  const _Markdown({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final linhas = texto.split('\n');
    final saida = <Widget>[];
    var emCodigo = false;
    final codigo = <String>[];

    void despejaCodigo() {
      if (codigo.isEmpty) return;
      saida.add(Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(CM.gapCompacto),
        decoration: BoxDecoration(color: CC.neutral10, borderRadius: CM.raioBotao),
        child: Text(codigo.join('\n'),
            style: CT.mono.copyWith(color: CC.neutral02, fontSize: 11)),
      ));
      codigo.clear();
    }

    for (final l in linhas) {
      if (l.trimLeft().startsWith('```')) {
        emCodigo = !emCodigo;
        if (!emCodigo) despejaCodigo();
        continue;
      }
      if (emCodigo) {
        codigo.add(l);
        continue;
      }
      final t = l.trim();
      if (t.isEmpty) continue;
      if (t.startsWith('### ')) {
        saida.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 2),
          child: Text(t.substring(4),
              style: CT.rotulo.copyWith(color: CC.primary03)),
        ));
      } else if (t.startsWith('## ')) {
        saida.add(Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(t.substring(3).toUpperCase(),
              style: CT.sobrescrito.copyWith(color: CC.neutral05)),
        ));
      } else if (t.startsWith('- ')) {
        saida.add(Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 2),
          child: Text('· ${_semMarcas(t.substring(2))}',
              style: CT.corpoPequeno.copyWith(color: CC.neutral03)),
        ));
      } else {
        saida.add(Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(_semMarcas(t),
              style: CT.corpoPequeno.copyWith(color: CC.neutral03)),
        ));
      }
    }
    despejaCodigo();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: saida);
  }

  /// Tira as marcas de ênfase e de link, mantendo o texto. Não é parser: é o suficiente pra a linha não
  /// aparecer poluída de asteriscos e colchetes.
  static String _semMarcas(String s) => s
      .replaceAll('**', '')
      .replaceAll('`', '')
      .replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^)]*\)'), (m) => m.group(1)!);
}
