import 'package:flutter/widgets.dart';

import '../theme/cpf_seguro_icon_tokens.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_icon.dart';

/// MOLDURA DE CAPTURA — onde a pessoa encaixa o documento, o rosto ou o código.
///
/// Nasceu de MEDIÇÃO, não de vontade: cinco telas do primeiro filho desenhavam a mesma moldura à
/// mão (documento 260×168, rosto 200 redondo, código 240 com cantos de mira), cada uma com o
/// próprio `Container` + `BoxDecoration`. Todas usavam os mesmos papéis (`primarySubtle` de fundo,
/// `primary` de borda), e nenhuma tinha estado de erro coerente — a de documento ilegível empilhava
/// um ícone de alerta por cima.
///
/// Cinco cópias do mesmo desenho é o sinal de palavra faltando no vocabulário, e o custo aparecia
/// no board: as cinco telas viravam BLOCO CRU, porque código à mão não é componente.
///
/// ## O vocabulário é FECHADO
///
/// Três formas e dois estados, e o ícone vem DA FORMA — não é parâmetro. Quem captura documento não
/// escolhe o ícone: a moldura de documento tem cara de documento, e é isso que faz a pessoa entender
/// o que fazer antes de ler a instrução.
///
/// A instrução (título e subtítulo) fica FORA: ela é da tela, e cada uma diz uma coisa diferente.
class DilettaCaptureFrame extends StatelessWidget {
  const DilettaCaptureFrame({
    super.key,
    this.forma = DilettaCaptureForma.documento,
    this.estado = DilettaCaptureEstado.aguardando,
  });

  final DilettaCaptureForma forma;
  final DilettaCaptureEstado estado;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final erro = estado == DilettaCaptureEstado.erro;
    final ok = estado == DilettaCaptureEstado.reconhecido;
    // A COR É PAPEL, e o papel muda com o estado: aguardando é a cor de ação (é um convite pra
    // fazer algo), erro é a de erro, reconhecido é a de sucesso.
    final traco = erro
        ? s.error
        : ok
            ? s.success
            : s.primary;
    final fundo = erro
        ? s.errorSubtle
        : ok
            ? s.successSubtle
            : s.primarySubtle;

    final medida = switch (forma) {
      DilettaCaptureForma.documento => const Size(260, 168),
      DilettaCaptureForma.rosto => const Size(200, 200),
      DilettaCaptureForma.codigo => const Size(240, 240),
    };
    final icone = switch (forma) {
      DilettaCaptureForma.documento => DilettaIcons.idCardClipLight,
      DilettaCaptureForma.rosto => DilettaIcons.userViewfinderLightFull,
      DilettaCaptureForma.codigo => DilettaIcons.qrcodeLight,
    };

    return DilettaDevInfo(
      component: 'DilettaCaptureFrame',
      props: {'forma': forma.name, 'estado': estado.name},
      tokens: const ['fundo: primarySubtle/errorSubtle · borda 2 · ícone 72 (rosto/código 96)'],
      child: SizedBox(
        width: medida.width,
        height: medida.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fundo,
                  // O CÓDIGO não leva borda contínua: quem marca o enquadramento são os quatro
                  // cantos de mira. Borda inteira competiria com eles e a moldura ficaria pesada.
                  border: forma == DilettaCaptureForma.codigo
                      ? null
                      : Border.all(color: traco, width: 2),
                  borderRadius: forma == DilettaCaptureForma.documento
                      ? DilettaRadius.all16
                      : forma == DilettaCaptureForma.codigo
                          ? DilettaRadius.all24
                          : null,
                  shape: forma == DilettaCaptureForma.rosto
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                ),
              ),
            ),
            Center(
              child: DilettaIcon(
                name: icone,
                size: forma == DilettaCaptureForma.documento ? 72 : 96,
                color: traco,
              ),
            ),
            if (forma == DilettaCaptureForma.codigo)
              ..._cantos(traco),
            // O SELO de estado fica no canto, não sobre o ícone: sobre o ícone ele esconde
            // justamente a pista de o que fazer. Na tela de documento ilegível, o alerta empilhado
            // no meio deixava a moldura ilegível também.
            if (erro || ok)
              Positioned(
                right: 8,
                bottom: 8,
                child: DilettaIcon(
                  name: erro
                      ? DilettaIcons.triangleExclamationLight
                      : DilettaIcons.circleCheckLight,
                  size: 24,
                  color: traco,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Os quatro cantos de mira do enquadramento (dois traços em L por canto).
  List<Widget> _cantos(Color cor) => [
        for (final canto in const [
          (Alignment.topLeft, true, true),
          (Alignment.topRight, true, false),
          (Alignment.bottomLeft, false, true),
          (Alignment.bottomRight, false, false),
        ])
          Align(
            alignment: canto.$1,
            child: _CantoDeMira(cor: cor, topo: canto.$2, esquerda: canto.$3),
          ),
      ];
}

/// O que se está capturando. Fechado de propósito: forma nova entra quando existir a segunda tela
/// pedindo, e não antes.
enum DilettaCaptureForma {
  /// Documento (RG, CNH): retângulo deitado 260×168.
  documento,

  /// Rosto (selfie, liveness): círculo de 200.
  rosto,

  /// Código (QR): quadrado de 240 com cantos de mira.
  codigo,
}

/// Em que ponto a captura está.
enum DilettaCaptureEstado {
  /// Esperando o enquadramento. É o convite: cor de ação.
  aguardando,

  /// Não deu (documento ilegível, rosto não reconhecido).
  erro,

  /// Reconhecido.
  reconhecido,
}

class _CantoDeMira extends StatelessWidget {
  const _CantoDeMira({required this.cor, required this.topo, required this.esquerda});
  final Color cor;
  final bool topo;
  final bool esquerda;

  @override
  Widget build(BuildContext context) {
    final lado = BorderSide(color: cor, width: 3);
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: topo ? lado : BorderSide.none,
          bottom: topo ? BorderSide.none : lado,
          left: esquerda ? lado : BorderSide.none,
          right: esquerda ? BorderSide.none : lado,
        ),
      ),
    );
  }
}
