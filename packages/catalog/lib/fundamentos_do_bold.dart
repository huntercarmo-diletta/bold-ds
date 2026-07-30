/// A ABA DE FUNDAMENTOS — os tokens do Conta BOLD, todos DERIVADOS.
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

class AbaDeFundamentos extends StatelessWidget {
  const AbaDeFundamentos({super.key});

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
              Text('Fundamentos', style: CT.tituloGrande),
              SizedBox(height: CM.gapCompacto),
              Text(
                'A identidade deste produto é a PALETA; todo o resto é derivado dela pelo pai. '
                'Os papéis não são escolhidos aqui, e é isso que faz o modo escuro sair de graça.',
                style: CT.corpo.copyWith(color: CC.neutral04),
              ),
              SizedBox(height: CM.gapAmplo),
              const _Secao(
                titulo: 'Rampas da marca',
                nota: 'As cores cruas. É o único lugar onde este filho escreve hexadecimal.',
                child: _Rampas(),
              ),
              const _Secao(
                titulo: 'Papéis, nos dois modos',
                nota: 'Derivados da paleta. Componente nenhum lê rampa: lê papel.',
                child: _Papeis(),
              ),
              const _Secao(
                titulo: 'Gradientes',
                nota: 'Dois, e o resto é modulado neles.',
                child: _Gradientes(),
              ),
              const _Secao(
                titulo: 'Tipografia',
                nota: 'A escala é do pai; o filho escolheu a substituição de cada degrau antigo.',
                child: _Tipografia(),
              ),
              const _Secao(
                titulo: 'Espaço e raio',
                nota: 'Degraus, não números soltos.',
                child: _EspacoERaio(),
              ),
              const _Secao(
                titulo: 'Adoção dos tokens — o relatório do PAI',
                nota: 'Herdado quer dizer: confira contra o produto antigo antes de aceitar.',
                child: _Adocao(),
              ),
              const _Secao(
                titulo: 'Ícones',
                nota: 'Herdados do pai, sem exceção — este filho não declara asset próprio.',
                child: _Icones(),
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

/// As rampas, por família. Cada valor sai do campo da paleta — não há hex repetido aqui.
Map<String, List<(String, Color)>> _rampasDaMarca() {
  const p = BoldPalette.bold;
  return {
    'primary (rosa)': [
      ('01', p.primary01), ('02', p.primary02), ('03', p.primary03), ('04', p.primary04),
      ('05', p.primary05), ('06', p.primary06), ('07', p.primary07), ('08', p.primary08),
      ('09', p.primary09),
    ],
    'neutral': [
      ('01', p.neutral01), ('02', p.neutral02), ('03', p.neutral03), ('04', p.neutral04),
      ('05', p.neutral05), ('06', p.neutral06), ('07', p.neutral07), ('08', p.neutral08),
      ('09', p.neutral09), ('10', p.neutral10),
    ],
    'success': [
      ('01', p.success01), ('02', p.success02), ('03', p.success03), ('04', p.success04),
      ('05', p.success05), ('06', p.success06), ('07', p.success07),
    ],
    'warning': [
      ('01', p.warning01), ('02', p.warning02), ('03', p.warning03), ('04', p.warning04),
      ('05', p.warning05), ('06', p.warning06), ('07', p.warning07),
    ],
    'error': [
      ('01', p.error01), ('02', p.error02), ('03', p.error03), ('04', p.error04),
      ('05', p.error05), ('06', p.error06), ('07', p.error07),
    ],
    'vinho (o polo profundo)': [
      ('marca', BoldVinho.marca), ('ink', BoldVinho.ink),
    ],
  };
}

class _Rampas extends StatelessWidget {
  const _Rampas();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final familia in _rampasDaMarca().entries) ...[
          Text(familia.key, style: CT.rotuloPequeno.copyWith(color: CC.neutral03)),
          const SizedBox(height: 4),
          Row(
            children: [
              for (final (nome, cor) in familia.value)
                Expanded(
                  child: _Amostra(
                    cor: cor,
                    rotulo: nome,
                    hex: '#${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                  ),
                ),
            ],
          ),
          SizedBox(height: CM.gapCompacto),
        ],
      ],
    );
  }
}

class _Amostra extends StatelessWidget {
  const _Amostra({required this.cor, required this.rotulo, required this.hex});

  final Color cor;
  final String rotulo;
  final String hex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: cor,
              borderRadius: CM.raioBotao,
              border: Border.all(color: CC.neutral09),
            ),
          ),
          const SizedBox(height: 2),
          Text(rotulo, style: CT.legenda.copyWith(color: CC.neutral04)),
          Text(hex, style: CT.mono.copyWith(color: CC.neutral06, fontSize: 9)),
        ],
      ),
    );
  }
}

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
          color: cpfSeguroContrastRatio(CC.neutral01, cor) >= 4.5
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

class _Gradientes extends StatelessWidget {
  const _Gradientes();

  @override
  Widget build(BuildContext context) {
    final gradientes = {
      'primary — rosa indo pro laranja': BoldGradients.primary,
      'accent — só laranja': BoldGradients.accent,
    };
    return Column(
      children: [
        for (final g in gradientes.entries)
          Container(
            height: 56,
            margin: const EdgeInsets.only(bottom: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: g.value, borderRadius: CM.raioBotao),
            child: Text(g.key,
                style: CT.rotulo.copyWith(color: BoldGradients.onGradient)),
          ),
      ],
    );
  }
}

class _Tipografia extends StatelessWidget {
  const _Tipografia();

  @override
  Widget build(BuildContext context) {
    final presets = <String, TextStyle>{
      'displaySm': DilettaType.displaySm,
      'headlineLg': DilettaType.headlineLg,
      'headlineSm': DilettaType.headlineSm,
      'titleMd': DilettaType.titleMd,
      'subheading': DilettaType.subheading,
      'bodyMd': DilettaType.bodyMd,
      'bodySm': DilettaType.bodySm,
      'label': DilettaType.label,
      'labelSm': DilettaType.labelSm,
      'numeric': DilettaType.numeric,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in presets.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    // Tamanho e peso lidos do próprio preset: escrever à mão é como a doc começa a
                    // divergir do código.
                    '${p.key} · ${p.value.fontSize?.toInt()}/'
                    '${(p.value.fontWeight?.value ?? 400)}',
                    style: CT.mono.copyWith(color: CC.neutral05, fontSize: 10),
                  ),
                ),
                Expanded(
                  child: Text('Conta BOLD 1234',
                      style: p.value.copyWith(color: CC.neutral01)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EspacoERaio extends StatelessWidget {
  const _EspacoERaio();

  @override
  Widget build(BuildContext context) {
    final espacos = <String, double>{
      's1': DilettaSpacing.s1, 's2': DilettaSpacing.s2, 's3': DilettaSpacing.s3,
      's4': DilettaSpacing.s4, 's5': DilettaSpacing.s5, 's6': DilettaSpacing.s6,
      's8': DilettaSpacing.s8, 's10': DilettaSpacing.s10, 's12': DilettaSpacing.s12,
    };
    final raios = <String, BorderRadius>{
      'all8': DilettaRadius.all8, 'all16': DilettaRadius.all16,
      'all24': DilettaRadius.all24, 'pillAll': DilettaRadius.pillAll,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in espacos.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(children: [
              SizedBox(
                width: 80,
                child: Text('${e.key} · ${e.value.toInt()}',
                    style: CT.mono.copyWith(color: CC.neutral05, fontSize: 10)),
              ),
              Container(width: e.value, height: 12, color: CC.primary04),
            ]),
          ),
        SizedBox(height: CM.gapCompacto),
        Row(children: [
          for (final r in raios.entries)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(children: [
                Container(
                  width: 56,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CC.neutral10,
                    borderRadius: r.value,
                    border: Border.all(color: CC.neutral08),
                  ),
                ),
                const SizedBox(height: 2),
                Text(r.key, style: CT.mono.copyWith(color: CC.neutral05, fontSize: 9)),
              ]),
            ),
        ]),
      ],
    );
  }
}

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

class _Icones extends StatelessWidget {
  const _Icones();

  @override
  Widget build(BuildContext context) {
    // Uma amostra dos que os componentes deste produto usam, e a CONTAGEM do conjunto inteiro —
    // desenhar 358 ícones numa aba é peso sem informação.
    const amostra = [
      DilettaIcons.circleCheckLight, DilettaIcons.calendarLight, DilettaIcons.stampLight,
      DilettaIcons.clockLight, DilettaIcons.pixLight, DilettaIcons.bellLight,
      DilettaIcons.userLight, DilettaIcons.eyeLight, DilettaIcons.eyeSlashLightFull,
      DilettaIcons.piggyBankLight, DilettaIcons.angleDownLight, DilettaIcons.sparklesLightFull,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${DilettaIcons.all.length} glifos no conjunto do pai',
            style: CT.corpoPequeno.copyWith(color: CC.neutral04)),
        SizedBox(height: CM.gapCompacto),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final nome in amostra)
              DilettaIcon(name: nome, size: 22, color: CC.neutral02),
          ],
        ),
      ],
    );
  }
}
