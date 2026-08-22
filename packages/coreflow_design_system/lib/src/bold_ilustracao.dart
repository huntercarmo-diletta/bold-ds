import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// AS ARTES DESTE PRODUTO — 8 nomes, e nenhum deles é nome do pai, claro e escuro, e a cor vem da PALETA.
///
/// Elas moravam no app como SVG cru, carregadas por caminho montado à mão
/// (`'illustrations/${nome}_${escuro ? 'dark' : 'light'}.svg'`) e desenhadas **sem recolor
/// nenhum** — o widget de lá dizia, em comentário, que ilustração é multicor por design e por
/// isso não se recolore.
///
/// A frase está certa e a conclusão estava errada. Multicor não quer dizer *fixa*: o pai já
/// separava, na arte dele, **o que é marca do que é neutro e semântico** — e é só a marca que
/// viaja. Enquanto as 26 artes ficaram no app com o rosa cozido, este produto tinha uma
/// afirmação furada: *"o neto troca a paleta e pronto"* valia pra 35 papéis de cor e não valia
/// pra 403 pinturas de ilustração.
///
/// Aqui elas passam pelo [ColorMapper] do `flutter_svg`, alimentado pela mesma rampa que
/// recolore a arte do pai ([DilettaIllustrationBrand.rampaDe]). Mesma tabela, mesma regra, dois
/// acervos:
///
/// **Cinco saíram na mudança, e as duas saídas tiveram donos diferentes.**
///
/// `online_payment` e `timer_woman` eram o desenho do PAI com um blob rosa por trás — mesma figura,
/// mesma pose, mesmos objetos — e tinham ZERO sítio de uso. Duplicada **e** não usada é a regra do
/// dono pra apagar, e ela se aplica sozinha quando as duas condições batem juntas.
///
/// `internet_off`, `success` e `security_phone` eram a mesma coisa **em 7 telas vivas**, então a
/// regra não bastava: apagar o blob de uma tela em uso é decisão de quem olha a tela. Foi decidido
/// em 20/08, olhando as seis lado a lado renderizadas — **a peça dele nas três**. O que se aceita é
/// o blob sumindo e o acento indo um degrau mais claro (o desenho dele usa o 05 onde a cópia daqui
/// usava o 04); o que se ganha é uma cópia a menos na família e o conserto dele chegando por tag.
///
/// Um dado que entrou na conta e não estava na pergunta: o `internet_off_dark` **daqui** abria com
/// um retângulo preto de canto a canto (o fundo da prancheta, exportado junto) e o dele não tem.
/// Varri as 59 artes do pai: nenhuma pinta a própria página. A cópia carregava um defeito que o
/// original nunca teve, que é o argumento mais forte contra manter cópia.
///
/// ```dart
/// CoreflowIlustracao(CoreflowArte.sucesso, tamanho: 200)
/// ```
///
/// O recolor acontece na hora do PARSE, não em cima da string — então não há cópia do SVG na
/// memória, e a chave de cache do `flutter_svg` já inclui o mapper (por isso [_RampaDaMarca] tem
/// `==` pela paleta: sem isso a primeira paleta ficaria cacheada pras outras).
enum CoreflowArte {
  erro('error'),
  buscaDeArquivos('files_search'),
  arquivoInvalido('invalid_file'),
  estadoInvalido('invalid_state'),
  semArquivos('no_files'),
  semArquivosEmLinha('no_files_line'),
  buscaEmLinha('search_line'),
  sucessoAlternativo('success_alt');

  const CoreflowArte(this.base);

  /// O nome do arquivo sem o sufixo de tema. É o nome que o app usava como string, e ele
  /// continua sendo o nome do arquivo — trocar por um id bonito custaria renomear 26 assets
  /// pra ganhar nada.
  final String base;
}

/// Uma arte deste produto, no tamanho pedido, na cor da paleta ATIVA.
class CoreflowIlustracao extends StatelessWidget {
  const CoreflowIlustracao(this.arte, {super.key, this.tamanho = 300});

  final CoreflowArte arte;

  /// Lado do quadrado. Livre de propósito: as telas deste produto pedem 88, 150 e 200, e
  /// nenhum dos três é degrau canônico do acessório do pai (100/200/300/400).
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final tema = DilettaTheme.of(context);
    final escuro = tema.scheme.brightness == Brightness.dark;
    return Semantics(
      label: arte.base,
      image: true,
      child: SvgPicture.asset(
        'assets/illustrations/${arte.base}_${escuro ? 'dark' : 'light'}.svg',
        package: 'coreflow_design_system',
        width: tamanho,
        height: tamanho,
        fit: BoxFit.contain,
        colorMapper: _RampaDaMarca(tema.palette, tema.brand),
      ),
    );
  }
}

/// Traduz, no parse, todo hex de marca cozido na arte pro degrau da paleta ativa.
///
/// Neutro e semântico passam intactos — a regra é do pai: *"cor de marca troca, erro/aviso e
/// neutro são invariantes"*. Nas 26 artes daqui isso são **403 pinturas de 1751**.
@immutable
class _RampaDaMarca implements ColorMapper {
  _RampaDaMarca(this.paleta, DilettaBrand marca)
      : _de = {
          for (final e in DilettaIllustrationBrand.rampaDe(paleta, marca: marca).entries)
            _hexParaInt(e.key): _hexParaInt(e.value),
        };

  /// Guardada só pra igualdade: é ela que muda quando a paleta muda, e é o que a chave de
  /// cache do `flutter_svg` precisa enxergar.
  final DilettaPalette paleta;

  final Map<int, int> _de;

  static int _hexParaInt(String hex) => 0xFF000000 | int.parse(hex.substring(1), radix: 16);

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    // ignore: deprecated_member_use
    final novo = _de[color.value];
    return novo == null ? color : Color(novo);
  }

  @override
  bool operator ==(Object other) => other is _RampaDaMarca && other.paleta == paleta;

  @override
  int get hashCode => paleta.hashCode;
}
