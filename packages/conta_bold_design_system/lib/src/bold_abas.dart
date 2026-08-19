/// CONTA BOLD — as ABAS sublinhadas.
///
/// 3 usos. O pai não tinha abas segmentadas em lugar nenhum — e o chrome do próprio catálogo teve
/// que inventar as dele, o que é o primeiro sinal de vocabulário faltando. Nasceu aqui, e a frase
/// que estava escrita nesta linha era *"candidata clara a subir quando um segundo filho medir a
/// mesma falta"*.
///
/// ## A condição disparou em 12/08, e ela não disparou por mim
///
/// O pai cruzou os DOIS DS que a linguagem serve — 216 nomes de componente — e a interseção virou
/// regra: **o que está nos dois é vocabulário da categoria**. `DilettaTabs` nasceu daí (`ds
/// v0.87.0`).
///
/// **Eu escrevi a condição e não tinha como verificá-la**: eu vejo um produto. A lição que fica pras
/// próximas peças que nascerem aqui é escrever a promessa como uma CONSULTA que alguém consegue
/// rodar, e não como uma intenção.
///
/// ## E ela não foi adotada, por 113 pixels
///
/// A do pai é `MainAxisSize.min` com cada aba do tamanho do rótulo; esta reparte a largura em fatias
/// iguais. Com `Pendentes · Histórico · Minhas` em 353 de largura — a tela de Autorizações — a dele
/// **estoura por 113px**. Com rótulos curtos (`Tudo · Entradas · Saídas`) cabe.
///
/// As duas estão certas em contextos diferentes, e a razão de repartir está três parágrafos abaixo:
/// **fatia desigual faz o alvo de toque mudar de tamanho a cada troca de tela.** Está pedido como
/// variante (`larguraIgual`), com o número medido; enquanto não vier, esta peça é a única deste
/// produto com par na linguagem que não adota — e isso está declarado em vez de silencioso.
///
/// ## O que mudou
///
/// **Rótulo longo não estoura mais o layout, ele encurta.** O `ellipsis` já estava lá e era código
/// morto: sem `Expanded`, cada aba recebia largura infinita e nada nunca apertava o texto. Agora o
/// `Expanded` é de todas — exigência 10 do contrato (texto longo não estoura).
///
/// **Fatia igual é escolha, e o custo é declarado:** a aba de rótulo comprido corta enquanto a curta
/// sobra espaço. É o certo AQUI porque barra de navegação ocupa a largura toda por contrato, e fatia
/// desigual faz o alvo de toque mudar de tamanho a cada troca de tela. Quem hoje HUGA é a pílula dos
/// `BoldSegmentos`, que mora ao lado de um rótulo — e por isso ela resolve largura de outro jeito
/// (`FittedBox`, e a razão está escrita lá).
///
/// **A área de toque é a da ABA, não a do texto.** O `InkWell` estava dentro do `Expanded` e o
/// padding era do container interno, então a faixa vertical acima e abaixo do rótulo não
/// respondia. Exigência 10 outra vez, do outro lado: hit area de 16px é o defeito que só aparece
/// no aparelho de alguém.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Abas sublinhadas — **e desde a `v0.53.0` elas são as do pai.**
///
/// Esta peça existia porque a fila do pai ABRAÇAVA o rótulo e a deste produto REPARTE a largura, e
/// aba de navegação que abraça sobra à direita. O pedido de 13/08 levou o número —
/// `Pendentes · Histórico · Minhas` em 353 **estoura por 113px** — e o veredito
/// (`ds v0.115.0`) foi `DilettaTabs.larguraIgual`. Com o eixo, não sobra desenho pra manter aqui.
///
/// **O que a troca custou, com o número, porque um pixel que muda em silêncio é pior que um pixel
/// feio:** o sublinhado ativo era **2** aqui e é **3** no pai. Três é o número dele, e adotar é
/// seguir o traço da linguagem — o inativo continua 1 dos dois lados, e a diferença entre ativo e
/// inativo (que é o que faz a seleção não depender só de cor) continua existindo, maior.
///
/// **E a fatia estreita passa a cortar com reticências.** Aqui o `ellipsis` já existia e fazia o
/// mesmo; o que o veredito acrescentou foi a razão escrita: quem reparte aceita que a aba comprida
/// corte enquanto a curta sobra.
///
/// A API não mudou — os três nomes (`abas`, `indiceSelecionado`, `aoTrocar`) são os que as telas
/// falam, e é pra isso que a casca fica.
class BoldAbas extends StatelessWidget {
  const BoldAbas({
    super.key,
    required this.abas,
    required this.indiceSelecionado,
    required this.aoTrocar,
  });

  final List<String> abas;
  final int indiceSelecionado;
  final ValueChanged<int> aoTrocar;

  @override
  Widget build(BuildContext context) => DilettaTabs(
        abas: abas,
        selecionada: indiceSelecionado,
        onSelecionar: aoTrocar,
        // O eixo que o pedido de 13/08 comprou. Sem ele a fila abraça o rótulo e sobra à direita,
        // que é o desenho errado pra uma barra de navegação — e é o que estourava por 113px.
        larguraIgual: true,
      );
}
