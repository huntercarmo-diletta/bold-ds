/// CONTA BOLD — o CARTÃO DA CONTA: o cabeçalho da tela de Gestão da conta.
///
/// Vidro, ícone de banco + nome da conta + selo do tipo (PF/PJ) na primeira linha, o NÚMERO em
/// tamanho de manchete embaixo, e a agência com o banco numa linha de apoio.
///
/// ## Ele era uma classe PRIVADA dentro da tela
///
/// `_AccountHeader`, em `minha_conta_screen.dart`. Nem o inventário de adoção o via — ele conta peça
/// declarada, e widget privado dentro de uma tela não é peça, é desenho solto com nome.
///
/// É a quarta classe de dívida que este repo achou, e a mais silenciosa: peça órfã, classe pública
/// morta e widget privado não construído aparecem em varredura; **widget privado que a tela CONSTRÓI
/// é invisível pra qualquer gate** — ele funciona, tem uso, e não existe pra ninguém de fora.
///
/// O sintoma foi o mesmo das outras seis: a tela de Gestão da conta não podia ser desenhada no
/// catálogo porque o cabeçalho dela não existia fora daquele arquivo.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// O cabeçalho da tela de conta.
class BoldCartaoDaConta extends StatelessWidget {
  const BoldCartaoDaConta({
    super.key,
    required this.nomeDaConta,
    required this.tipo,
    required this.numero,
    required this.linhaDeApoio,
  });

  /// O apelido da conta. Vazio vira *"Conta"* — o rótulo genérico segura o lugar enquanto a
  /// listagem carrega, em vez de a linha colapsar e a tela pular.
  final String nomeDaConta;

  /// *"Conta PF"* / *"Conta PJ"*. Vai no selo.
  final String tipo;

  /// O número da conta, já com o dígito separado.
  final String numero;

  /// *"Ag 0001 · 655 – BOLD"*.
  final String linhaDeApoio;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    return DilettaDevInfo(
      component: 'cartaoDaConta',
      props: {'tipo': tipo},
      tokens: const ['radius.all24', 'type.headlineLg', 'type.labelMd'],
      child: DilettaGlassSurface(
        borderRadius: DilettaRadius.all24,
        child: Padding(
          padding: EdgeInsets.all(DilettaSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                DilettaIcon(
                    name: DilettaIcons.landmarkLight,
                    size: 18,
                    color: s.textSecondary),
                DilettaGap.w(DilettaSpacing.s2),
                Expanded(
                  child: DilettaText(
                    nomeDaConta.isEmpty ? 'Conta' : nomeDaConta,
                    maxLines: 1,
                    style:
                        DilettaType.labelMd.copyWith(color: s.textSecondary),
                  ),
                ),
                DilettaGap.w(DilettaSpacing.s2),
                DilettaStatusTag(label: tipo, tone: DilettaStatusTone.primary),
              ]),
              DilettaGap.h(DilettaSpacing.s4),
              // O número é o dado que a pessoa veio buscar, e ele ganha espaçamento entre letras:
              // dígito colado se lê errado quando é ditado no telefone.
              DilettaText(numero,
                  style: DilettaType.headlineLg
                      .copyWith(color: s.fg, letterSpacing: 1)),
              const SizedBox(height: 2),
              DilettaText(linhaDeApoio,
                  maxLines: 1,
                  style: DilettaType.bodySm.copyWith(color: s.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
