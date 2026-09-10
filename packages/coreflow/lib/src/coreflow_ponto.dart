import 'package:flutter/widgets.dart';

/// **CoreflowPonto** — o disco pequeno que marca estado, e nada mais.
///
/// Ele apareceu contando: a varredura de 01/09 nas telas deste produto achou **126
/// `BoxDecoration`**, e o terceiro maior grupo era `círculo · color + shape` — quinze sítios. Abrindo
/// os quinze, três coisas diferentes usavam a mesma forma:
///
/// - **spot com glifo** (40, tinte do tom, ícone dentro) — isso é `DilettaSpotIcon`, e existe;
/// - **disco de seleção** atrás do dia num calendário — isso é o `DilettaCalendar`, e existe;
/// - **o ponto** — 6, 8 ou 10 pixels, cor cheia, sem conteúdo. Não existia.
///
/// O ponto não é um spot pequeno. O spot é um CONTINENTE (tem dentro), e o ponto é um SINAL: ele
/// diz *tem algo aqui* — não lido, em andamento, ativo — ao lado de um rótulo que diz o quê. Por
/// isso ele não tem `child`, e por isso ele é acompanhado: **um ponto sozinho não informa**, e a
/// regra da NN/g que este DS já cita — *cor com ícone, e um indicador* — vale igual pra cor com
/// texto.
///
/// ```dart
/// CoreflowPonto(cor: c.success)              // 8, o mais comum
/// CoreflowPonto(cor: c.primary, tamanho: 10) // o marcador de item escolhido
/// ```
class CoreflowPonto extends StatelessWidget {
  const CoreflowPonto({super.key, required this.cor, this.tamanho = 8});

  /// O DIÂMETRO É LIVRE, e a razão é uma medição que desmentiu a primeira versão desta peça.
  ///
  /// Eu declarei três degraus (6 · 8 · 10) antes de contar, e a contagem veio **3 · 6 · 7 · 7 · 8 ·
  /// 10** nos sítios reais. Snapar os seis numa escada de três mudaria pixel em quatro telas pra
  /// ganhar uma escada que ninguém pediu — e o ponto não é espaço nem tipo, é o diâmetro de um
  /// sinal ao lado de um rótulo, dimensionado pelo peso da linha em que ele vive.
  ///
  /// **Fica declarado como dívida aberta**: se um segundo produto medir a mesma dispersão, aí sim a
  /// escada tem número dos dois lados e vira pedido. Um produto com seis valores é um produto sem
  /// padrão, não uma linguagem sem escada.

  final Color cor;
  final double tamanho;

  @override
  Widget build(BuildContext context) => Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      );
}
