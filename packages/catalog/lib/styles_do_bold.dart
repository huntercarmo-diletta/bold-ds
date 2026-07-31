/// STYLES DESTE PRODUTO — o inventário do motor MAIS a família que ele não deriva.
///
/// A página era do motor inteira (`AbaDeStyles`, desde a v0.39.0), e ela continua sendo a base: cor,
/// tipografia, forma, espaço, sombra, degradê e movimento saem do `InventarioDeEstilo` que o plugue
/// declara — nada disso se escreve à mão aqui.
///
/// O que muda na v0.48.0 é que dá pra COMPOR. `SecoesDeEstilo.de()` devolve as seções sem casca, e a
/// regra que o pai escreveu junto é a razão desta página existir:
///
/// > **O motor entrega o que ele DERIVA; a casca é de quem tem a página inteira.**
///
/// ## A família que faltava, e onde ela estava escondida
///
/// **Papel semântico nos dois modos.** É o que traduz a rampa da paleta no nome que componente nenhum
/// pode pular: nenhum componente deste DS lê `primary04`, todos leem `primary`. E papel é DERIVADO do
/// modo — mostrar o valor sem o modo é meia informação, que é justamente por que ele não cabe no
/// inventário do motor (o pai recusou absorver a família por fronteira: papel semântico pede
/// conhecimento de produto, e gancho que pede isso é o motor conhecendo o filho).
///
/// Ela estava na aba de **Conformidade**, e estar lá era um defeito de navegação meu: quem procura "de
/// que cor é a superfície no escuro" procura em Styles. Eu tinha justificado a posição com *"é medição
/// deste filho"* — verdade que não responde a pergunta certa, porque medição de valor de token É
/// inventário. Sobrou em Conformidade o que é conformidade: as violações e o relatório de adoção.
///
/// Ela vem PRIMEIRO, e não depois das famílias do motor, porque as famílias abaixo mostram valores e
/// esta mostra o nome pelo qual o produto os alcança. A posição também não depende da ordem interna de
/// `SecoesDeEstilo.de()`, que é do pai e pode mudar.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';

/// A casca desta página: a do motor, com a minha seção composta dentro.
class AbaDeStylesDoBold extends StatelessWidget {
  const AbaDeStylesDoBold({super.key});

  @override
  Widget build(BuildContext context) {
    final inv = Ds.estilos;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('STYLES',
                  style: CT.rotuloPequeno.copyWith(
                      color: CC.neutral04, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text(
                  'O inventário de valores deste DS — o que se CONSULTA. As decisões por trás deles '
                  'são Foundations, e são outra página.',
                  style: CT.corpoPequeno.copyWith(color: CC.neutral05)),
              const SizedBox(height: 20),
              const SecaoDePapeis(),
              ...SecoesDeEstilo.de(inv),
            ],
          ),
        ),
      ),
    );
  }
}

/// Os papéis que uma tela usa de verdade, nos dois modos.
///
/// Não são todos os ~51: são os que aparecem em componente deste produto — lista longa em catálogo é
/// lista que ninguém lê. Nada aqui é valor escrito à mão: cada linha lê
/// `DilettaScheme.light/dark(BoldPalette.bold)`.
class SecaoDePapeis extends StatelessWidget {
  const SecaoDePapeis({super.key});

  static const _papeis = <(String, Color Function(DilettaScheme))>[
    ('bg', _bg),
    ('surface', _surface),
    ('surfaceMuted', _surfaceMuted),
    ('fg', _fg),
    ('textSecondary', _textSecondary),
    ('border', _border),
    ('divider', _divider),
    ('primary', _primary),
    ('primarySubtle', _primarySubtle),
    ('onPrimarySubtle', _onPrimarySubtle),
    ('primaryTrack', _primaryTrack),
    ('success', _success),
    ('successSubtle', _successSubtle),
    ('onSuccessSubtle', _onSuccessSubtle),
    ('warning', _warning),
    ('error', _error),
    ('glassTint', _glassTint),
  ];

  @override
  Widget build(BuildContext context) {
    final claro = DilettaScheme.light(BoldPalette.bold);
    final escuro = DilettaScheme.dark(BoldPalette.bold);
    return SecaoDoBold(
      titulo: 'Papel semântico, nos dois modos',
      nota: 'Derivados da paleta. Componente nenhum lê rampa: lê papel.',
      child: Column(
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
      ),
    );
  }
}

// Os leitores como função de topo, e não closure na lista: `const` numa lista de tuplas exige que o
// segundo membro seja uma constante, e closure não é.
Color _bg(DilettaScheme s) => s.bg;
Color _surface(DilettaScheme s) => s.surface;
Color _surfaceMuted(DilettaScheme s) => s.surfaceMuted;
Color _fg(DilettaScheme s) => s.fg;
Color _textSecondary(DilettaScheme s) => s.textSecondary;
Color _border(DilettaScheme s) => s.border;
Color _divider(DilettaScheme s) => s.divider;
Color _primary(DilettaScheme s) => s.primary;
Color _primarySubtle(DilettaScheme s) => s.primarySubtle;
Color _onPrimarySubtle(DilettaScheme s) => s.onPrimarySubtle;
Color _primaryTrack(DilettaScheme s) => s.primaryTrack;
Color _success(DilettaScheme s) => s.success;
Color _successSubtle(DilettaScheme s) => s.successSubtle;
Color _onSuccessSubtle(DilettaScheme s) => s.onSuccessSubtle;
Color _warning(DilettaScheme s) => s.warning;
Color _error(DilettaScheme s) => s.error;
Color _glassTint(DilettaScheme s) => s.glassTint;

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
          color: dilettaContrastRatio(CC.neutral01, cor) >= 4.5 ? CC.neutral01 : CC.white,
        ),
      ),
    );
  }
}

/// O cartão de seção das páginas deste filho — título, nota e conteúdo.
///
/// Mora aqui porque é chrome de página e esta é a página composta; a de conformidade importa daqui em
/// vez de ter a segunda cópia. Duas cascas divergiriam no primeiro conserto.
class SecaoDoBold extends StatelessWidget {
  const SecaoDoBold({
    super.key,
    required this.titulo,
    required this.nota,
    required this.child,
  });

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
          Text(titulo.toUpperCase(), style: CT.sobrescrito.copyWith(color: CC.neutral05)),
          const SizedBox(height: 2),
          Text(nota, style: CT.legenda.copyWith(color: CC.neutral05)),
          SizedBox(height: CM.gapPadrao),
          child,
        ],
      ),
    );
  }
}
