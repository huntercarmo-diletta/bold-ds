/// CONTA BOLD — a AMOSTRA DE FUNDO: o retrato de um mood, com rótulo e marca de escolha.
///
/// Ela nasce aqui porque o `CoreflowBackground.fixo` já nasceu pra ela: o `///` daquele construtor cita
/// *"o SELETOR — a tela de Aparência desenha as cinco opções com `estilo:` em cada uma"* como o
/// primeiro dos dois casos em que o declarado tem que vencer a escolha da pessoa. O fundo era peça da
/// linguagem e o seletor dele era classe PRIVADA dentro de uma tela do app (`_BgOption` + `_Swatch`
/// em `aparencia_screen.dart`) — a mesma classe de dívida que trouxe o `cartaoDaConta` e o
/// `cartaoDePedido` pra cá, e a mais silenciosa delas: widget privado é invisível pra qualquer
/// varredura de adoção.
///
/// **Um sítio no app, e ele é o único que pode existir.** A medição que este repo exige normalmente
/// pergunta "quantas telas usam?"; aqui a resposta certa é outra — quem escolhe o fundo é a tela de
/// Aparência, e ter dois seletores do mesmo token seria o defeito. O que justifica a peça é o
/// SUJEITO: ela desenha um token do DS, e token que só o app sabe mostrar é token sem vitrine.
///
/// ## Os dois números que saíram do aparelho e viraram degrau
///
/// O app desenha o quadrado com **raio 11** e o anel com `CoreflowRadius.fieldR` (16). Onze não é degrau
/// da escada do pai, e o vizinho é o `r8` — que é o que ficou. O anel segue em `all16`, e a diferença
/// entre os dois raios é o que faz o anel LER como anel: mesmo raio nos dois deixa o quadrado
/// encostado na borda por dentro.
///
/// O rótulo era `CoreflowType.labelSm` com `fontSize: 10` cravado por cima. Dez não existe na escada, e
/// esse `copyWith` era o mesmo atalho que o ladrilho de menu já pagou quando mudou de casa: fica
/// `DilettaType.labelSm` (11/16), sem sobrescrita.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'bold_anel_de_escolha.dart';
import 'bold_scheme.dart';
import 'bold_background.dart';

/// O retrato de um [CoreflowBackdrop] no seletor de Aparência.
class CoreflowAmostraDeFundo extends StatelessWidget {
  const CoreflowAmostraDeFundo({
    super.key,
    required this.estilo,
    required this.rotulo,
    required this.escolhido,
    this.aoTocar,
  });

  /// O mood retratado. Vai por `CoreflowBackground.fixo`, então ele ignora a escolha da pessoa — é a
  /// razão daquele construtor existir.
  final CoreflowBackdrop estilo;

  final String rotulo;
  final bool escolhido;
  final VoidCallback? aoTocar;

  /// 64 de largura e 52 de quadrado são do aparelho. A largura é maior que o quadrado porque quem
  /// mede a coluna é o RÓTULO ("Brilho rosa" em duas linhas), não o retrato.
  static const double _larguraDaColuna = 64;
  static const double _ladoDoRetrato = 52;

  @override
  Widget build(BuildContext context) {
    // O esquema é o DESTE pacote e não o do pai, e a diferença é visível: no CLARO os dois têm um
    // `primary` e eles não são o mesmo rosa — 0,620/0,071 aqui contra 0,996/0,224 lá. Enquanto o
    // anel desta peça era pintado à mão com o rosa do pai, o vizinho não existia pra comparar;
    // desde que ele virou `CoreflowAnelDeEscolha` (que lê o esquema daqui), a peça teria o anel de
    // um rosa e o visto de dentro dele de outro.
    final s = CoreflowScheme.of(context);

    Widget amostra = DilettaDevInfo(
      component: 'amostraDeFundo',
      props: {'estilo': estilo.name, 'escolhido': '$escolhido'},
      tokens: const ['radius.all16', 'radius.all8', 'type.labelSm', 'scheme.primary'],
      child: SizedBox(
        width: _larguraDaColuna,
        child: Column(children: [
          // O ANEL saiu daqui em 02/09 e virou `CoreflowAnelDeEscolha`: a mesma forma estava escrita
          // aqui e no seletor de avatar do Letti, e a varredura dos jeitos de dizer "escolhido"
          // achou as duas cópias no mesmo dia. O que se perdeu foi o respiro de 2 entre o anel e a
          // arte — o anel agora corre POR CIMA da borda do retrato, que é como o do Letti já era.
          CoreflowAnelDeEscolha(
            escolhido: escolhido,
            raio: 12,
            child: ClipRRect(
              borderRadius: DilettaRadius.all8,
              child: SizedBox(
                width: _ladoDoRetrato,
                height: _ladoDoRetrato,
                child: Stack(fit: StackFit.expand, children: [
                  CoreflowBackground.fixo(estilo: estilo, child: const SizedBox()),
                  if (escolhido)
                    Center(
                      child: DilettaIcon(
                        name: DilettaIcons.checkLight,
                        size: _ladoDoRetrato / 2,
                        color: s.primary,
                      ),
                    ),
                ]),
              ),
            ),
          ),
          DilettaGap.h(DilettaSpacing.s1),
          DilettaText(
            rotulo,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: DilettaType.labelSm.copyWith(
              color: escolhido ? s.primary : s.textMuted,
              fontWeight: escolhido ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ]),
      ),
    );

    if (aoTocar != null) {
      amostra = DilettaTappable(onTap: aoTocar, child: amostra);
    }
    return amostra;
  }
}
