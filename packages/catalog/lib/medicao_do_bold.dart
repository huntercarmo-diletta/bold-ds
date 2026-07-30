/// A MEDIÇÃO DESTE FILHO — papéis nos dois modos e o relatório de adoção do pai.
///
/// Isto era a minha aba de Fundamentos, e ela saiu: a v0.43.0 do motor entrega Fundamentos como a PROSA
/// que ensina (índice + markdown), e a prosa deste produto virou `kBoldFundamentos` no pacote do DS.
///
/// O que sobrou aqui não é prosa nem inventário: é **medição deste filho**. Papel nos dois modos é o que
/// prova que o escuro sai de graça; o relatório de adoção é o que diz quais famílias de token eu declarei
/// e quais estou herdando. Os dois moram na aba de conformidade, que é onde medição deste filho mora.
///
/// A fronteira com Styles é do pai, e ele a escreveu melhor do que eu: **Styles é o inventário que se
/// CONSULTA; Fundamentos são as decisões que se leem uma vez.** A minha aba de Styles (tipografia,
/// gradiente, vidro) saiu na v0.39.0 do motor, que passou a entregar a página derivada do
/// `InventarioDeEstilo` — inclusive com o movimento TOCANDO, que uma tabela de duração não mostra.
///
/// O que sobra aqui é o que é decisão e não inventário: a rampa com a razão dela, os papéis NOS DOIS
/// MODOS (papel é derivado, e mostrá-lo sem o modo é meia informação), os dois gradientes modulados, a
/// receita do vidro e o relatório de adoção do pai.
///
/// Nada aqui é lista escrita à mão, e a razão é medida: no primeiro filho o vocabulário de ilustrações
/// do catálogo tinha metade das artes (16 de 32), duas telas pediam arte que ele não conhecia, e elas
/// renderizavam vazias sem erro nenhum. Lista à mão apodrece em silêncio.
///
/// Então:
///
/// - as **rampas** saem de `BoldPalette.bold`, campo por campo;
/// - os **papéis** saem de `DilettaScheme.light/dark(paleta)` — os dois modos, lado a lado;
/// - a **tipografia** sai dos presets do pai, com tamanho e peso lidos do próprio `TextStyle`;
/// - **espaço, raio e ícones** saem dos tokens;
/// - o **relatório de adoção** é do PAI (`relatorioDeAdocao`): ele diz, família por família, se este
///   filho DECLAROU o token ou se está herdando o valor de referência. É onde a estética escorrega sem
///   ninguém ver, e não é coisa que o filho deva escrever sozinho.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';

class PainelDeMedicao extends StatelessWidget {
  const PainelDeMedicao({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Medição deste filho', style: CT.tituloGrande),
              SizedBox(height: CM.gapCompacto),
              Text(
                'As decisões estão em Fundamentos e os valores em Styles. Aqui ficam as duas coisas '
                'que só se medem NESTE repo: o papel derivado nos dois modos, e o que eu declarei '
                'contra o que estou herdando do pai.',
                style: CT.corpo.copyWith(color: CC.neutral04),
              ),
              SizedBox(height: CM.gapAmplo),
              const _Secao(
                titulo: 'Papéis, nos dois modos',
                nota: 'Derivados da paleta. Componente nenhum lê rampa: lê papel.',
                child: _Papeis(),
              ),
              const _Secao(
                titulo: 'Adoção dos tokens — o relatório do PAI',
                nota: 'Herdado quer dizer: confira contra o produto antigo antes de aceitar.',
                child: _Adocao(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  const _Secao({required this.titulo, required this.nota, required this.child});

  final String titulo;
  final String nota;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: CM.gapAmplo),
      padding: EdgeInsets.all(CM.gapPadrao),
      decoration: BoxDecoration(
        color: CC.white,
        borderRadius: CM.raioPainel,
        border: Border.all(color: CC.neutral09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo.toUpperCase(),
              style: CT.sobrescrito.copyWith(color: CC.neutral05)),
          const SizedBox(height: 2),
          Text(nota, style: CT.legenda.copyWith(color: CC.neutral05)),
          SizedBox(height: CM.gapPadrao),
          child,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Rampas
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// Papéis
// ═══════════════════════════════════════════════════════════════════════════════

/// Os papéis que uma tela usa de verdade, nos dois modos. Não são todos os ~51: são os que aparecem
/// em componente deste produto — lista longa em catálogo é lista que ninguém lê.
List<(String, Color Function(DilettaScheme))> get _papeis => [
      ('bg', (s) => s.bg),
      ('surface', (s) => s.surface),
      ('surfaceMuted', (s) => s.surfaceMuted),
      ('fg', (s) => s.fg),
      ('textSecondary', (s) => s.textSecondary),
      ('border', (s) => s.border),
      ('divider', (s) => s.divider),
      ('primary', (s) => s.primary),
      ('primarySubtle', (s) => s.primarySubtle),
      ('onPrimarySubtle', (s) => s.onPrimarySubtle),
      ('primaryTrack', (s) => s.primaryTrack),
      ('success', (s) => s.success),
      ('successSubtle', (s) => s.successSubtle),
      ('onSuccessSubtle', (s) => s.onSuccessSubtle),
      ('warning', (s) => s.warning),
      ('error', (s) => s.error),
      ('glassTint', (s) => s.glassTint),
    ];

class _Papeis extends StatelessWidget {
  const _Papeis();

  @override
  Widget build(BuildContext context) {
    final claro = DilettaScheme.light(BoldPalette.bold);
    final escuro = DilettaScheme.dark(BoldPalette.bold);
    return Column(
      children: [
        for (final (nome, ler) in _papeis)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 160,
                  child: Text(nome, style: CT.mono.copyWith(color: CC.neutral03)),
                ),
                Expanded(child: _Faixa(cor: ler(claro), rotulo: 'claro')),
                const SizedBox(width: 6),
                Expanded(child: _Faixa(cor: ler(escuro), rotulo: 'escuro')),
              ],
            ),
          ),
      ],
    );
  }
}

class _Faixa extends StatelessWidget {
  const _Faixa({required this.cor, required this.rotulo});

  final Color cor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: CM.raioBotao,
        border: Border.all(color: CC.neutral09),
      ),
      child: Text(
        '$rotulo · #${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
        style: CT.mono.copyWith(
          fontSize: 9,
          // Tinta escolhida pelo contraste com a própria amostra: rótulo ilegível em cima da cor é
          // exatamente o defeito que este catálogo existe pra mostrar.
          color: dilettaContrastRatio(CC.neutral01, cor) >= 4.5
              ? CC.neutral01
              : CC.white,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Gradientes · tipografia · espaço · raio · adoção · ícones
// ═══════════════════════════════════════════════════════════════════════════════

/// A ESCALA TIPOGRÁFICA saiu daqui, e o motivo é a fronteira: a lista de degraus é INVENTÁRIO, e
/// inventário é Styles — a aba do motor a desenha derivada do `InventarioDeEstilo`.
///
/// O que era decisão nesta página — qual degrau do pai substitui cada preset ANTIGO do Bold — não é
/// tabela de tela: é o mapa fixado por `test/o_mapa_da_tipografia_test.dart` no DS e explicado no
/// `ADOCAO.md`. Ele falha se o pai mover tamanho ou peso de algum degrau escolhido, que é a única coisa
/// que uma página não pode fazer.

class _Adocao extends StatelessWidget {
  const _Adocao();

  @override
  Widget build(BuildContext context) {
    final itens = relatorioDeAdocao(BoldPalette.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final i in itens)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: EdgeInsets.all(CM.gapCompacto),
            decoration: BoxDecoration(
              color: switch (i.estado) {
                EstadoDeAdocao.declarado => CC.success07,
                EstadoDeAdocao.herdado => CC.warning07,
                EstadoDeAdocao.naoDeclaravel => CC.neutral10,
              },
              borderRadius: CM.raioBotao,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i.estado.name.toUpperCase()} · ${i.familia}',
                    style: CT.rotuloPequeno.copyWith(color: CC.neutral02)),
                const SizedBox(height: 2),
                Text('vale: ${i.efetivo}', style: CT.corpoPequeno),
                const SizedBox(height: 2),
                Text('confira: ${i.comoConferir}',
                    style: CT.legenda.copyWith(color: CC.neutral05)),
              ],
            ),
          ),
      ],
    );
  }
}

/// A receita do vidro: o trio que este filho declara na paleta.
///
