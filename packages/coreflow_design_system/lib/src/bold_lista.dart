import 'package:diletta_design_system/diletta_design_system.dart'
    show
        DilettaDivider,
        DilettaListTile,
        DilettaSpotForma,
        DilettaSpotIcon,
        DilettaSpotState,
        DilettaSpotType;
import 'package:flutter/material.dart';
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_type.dart' show CoreflowType;
import 'bold_cartao.dart' show CoreflowCartao;
import 'bold_icone.dart' show CoreflowIcone;
import 'bold_scheme.dart' show CoreflowScheme;


/// Conta BOLD — list primitives (portados do "App list" do cpf-seguro).
///
/// [CoreflowGrupoDeLista] é o card que empilha [CoreflowLinhaDeLista]s com hairline; cada tile
/// é `leading + título/subtítulo + trailing`. Leading típico: [CoreflowSpot].
/// Trailing típico: chevron (default com onTap), [BoldListTime],
/// [BoldListTimeStatus], [BoldListAmount] ou uma [CoreflowEtiqueta].

/// Tom do [CoreflowSpot]. Semânticos usam as escalas (wash 07/08 + base 04).
/// `secure` = ouro de blindagem (CPF Seguro / selo quântico).
enum CoreflowTomDoSpot { primary, neutral, success, warning, danger, secure }

/// Conta BOLD — SpotIcon. **CASCA desde 21/08**: o desenho é o `DilettaSpotIcon` do pai.
///
/// Os cinco eixos batem um a um — `filled` ↔ `type` (fill/outline), `tone` ↔ `state`, `size` ↔
/// `size` —, e o que a troca paga é a TABELA: eram 12 pares de degrau escritos aqui (04 sólido com
/// glifo branco no filled; wash 07/08 no claro e tinte 20% no escuro no outline), contra os PAPÉIS
/// do pai (`s.primary` × `s.onPrimary`, `s.surfaceMuted` × `s.textTertiary`). Os papéis dele
/// passaram por gate de contraste — o `///` da peça conta que o gate reprovou três dos cinco no
/// escuro, onde as cores semânticas clareiam e branco sobre âmbar claro não alcança 3:1.
///
/// **Três props saíram por não ter chamador**: `badge`, `disabled` e `loading` — zero sítios nos 3
/// consumidores reais (`bold_alert` aqui, e duas folhas da Letti). As três existem no pai
/// (`DilettaBadge`, `state.disabled`, `state.loading`) e voltam por repasse no dia em que uma tela
/// pedir. O `loading` não voltaria igual, e isso é o que decidiu: o do pai é ESTADO TONAL, não
/// spinner — repassar o nome com outro comportamento seria a peça mentindo.
///
/// O nome de ícone é traduzido pelo mapa do [CoreflowIcone]: os apelidos deste app (`'pix'`, `'sparkle'`)
/// viram o nome do arquivo do conjunto do pai, que é o mesmo conjunto (medido: 310 dos 354 nomes).
///
/// ```dart
/// CoreflowSpot('pix', tone: CoreflowTomDoSpot.primary);
/// CoreflowSpot('circle-check-light', tone: CoreflowTomDoSpot.success, filled: true);
/// ```
class CoreflowSpot extends StatelessWidget {
  const CoreflowSpot(
    this.icon, {
    super.key,
    this.tone = CoreflowTomDoSpot.neutral,
    this.filled = false,
    this.forma = DilettaSpotForma.circulo,
    this.size = 38,
  });

  /// Nome do ícone: apelido do [CoreflowIcone] ou o nome cru do arquivo.
  final String icon;
  final CoreflowTomDoSpot tone;

  /// `true` = disco sólido no papel do tom + glifo no `on` dele; `false` = wash tonal.
  final bool filled;

  /// Disco ou LADRILHO (quadrado arredondado). O eixo entrou no pai na `v0.145.0`, respondendo o
  /// pedido desta casa: o ladrilho existia lá e só tinha nome dentro do banner. O raio sai da
  /// escala dele — `all8` abaixo de 44, `all16` a partir.
  final DilettaSpotForma forma;

  final double size;

  @override
  Widget build(BuildContext context) => DilettaSpotIcon(
        icon: CoreflowIcone.alias[icon] ?? icon,
        type: filled ? DilettaSpotType.fill : DilettaSpotType.outline,
        forma: forma,
        state: switch (tone) {
          CoreflowTomDoSpot.primary => DilettaSpotState.primary,
          CoreflowTomDoSpot.neutral => DilettaSpotState.normal,
          CoreflowTomDoSpot.success => DilettaSpotState.success,
          CoreflowTomDoSpot.warning => DilettaSpotState.warning,
          CoreflowTomDoSpot.danger => DilettaSpotState.error,
          CoreflowTomDoSpot.secure => DilettaSpotState.secure,
        },
        size: size,
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// Acessórios de trailing (moléculas) — hora, hora+status, valor
// ═══════════════════════════════════════════════════════════════════════════

/// Uma row de lista: `leading + título (+ subtítulo) + trailing`. Componha
/// dentro de um [CoreflowGrupoDeLista]. Com [onTap], um chevron aparece por default;
/// passe [trailing] custom ([BoldListTime], [BoldListTimeStatus],
/// [BoldListAmount], [CoreflowEtiqueta], "Em breve"…) pra sobrepor, e
/// [enabled] = false pra esmaecer.
class CoreflowLinhaDeLista extends StatelessWidget {
  const CoreflowLinhaDeLista({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    // O DESENHO É DO PAI (`DilettaListTile`): os cinco campos batem nome por nome.
    //
    // Duas coisas ficam aqui, e as duas são do produto:
    // - o CHEVRON por default quando há `onTap`. O pai não põe seta sozinho, e essa
    //   é a convenção desta casa desde o Redesenho — quem toca vê pra onde vai;
    // - o `enabled: false`, que esmaece a linha inteira. O pai não tem estado
    //   desabilitado na linha, e são poucos sítios: um `Opacity` resolve sem pedir.
    final trail = trailing ??
        (onTap != null
            ? CoreflowIcone('chevron-right', size: 16, color: c.textMuted)
            : null);
    final linha = DilettaListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trail,
      onTap: enabled ? onTap : null,
    );
    return enabled ? linha : Opacity(opacity: 0.5, child: linha);
  }
}

/// Card arredondado que empilha [CoreflowLinhaDeLista]s com hairline entre elas —
/// mesma superfície branca translúcida do DS. [title] opcional = label de
/// seção uppercase acima.
class CoreflowGrupoDeLista extends StatelessWidget {
  const CoreflowGrupoDeLista({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        // O DIVISOR É O DO PAI. Era `Divider` do Material com
        // `BoldColors.hairline` — token, mas token FIXO (neutral-09): a linha
        // não virava com o tema, e sobre o card de vidro claro ela é cinza-claro
        // sobre branco.
        //
        // Mesmo defeito que o do grupo de dia do extrato, achado no mesmo dia:
        // lá era branco a 12% cravado, invisível no claro. **Cor de divisor é
        // papel, não degrau.**
        rows.add(const DilettaDivider());
      }
      rows.add(children[i]);
    }
    final card = CoreflowCartao(
      glass: true,
      radius: 20,
      padding:
          const EdgeInsets.symmetric(horizontal: DilettaSpacing.s4, vertical: 2),
      child: Column(children: rows),
    );
    if (title == null) return card;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: DilettaSpacing.s1, bottom: 10),
        child: Text(title!.toUpperCase(),
            // Sobrancelha em caixa alta: o degrau é `labelSm` (11), e peso e tracking são
            // ênfase. Antes era `label` (12) empurrado pra 11.
            style: CoreflowType.labelSm.copyWith(
                color: c.textMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 1)),
      ),
      card,
    ]);
  }
}
