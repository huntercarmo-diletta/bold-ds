import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ORIGEM DE CADA PAPEL — alias ou derivação —, e por que ela vira gate.
///
/// A página de Styles mostrava hex e não dizia **se dá pra trocar**. Metade dos papéis é uma entrada
/// da minha paleta (troco a entrada e o papel segue); a outra metade é conta do pai, que existe
/// justamente pra ninguém escolher.
///
/// A régua é do aviso: **alias é porta, derivação é parede.** Mostrar as duas iguais convida alguém
/// a trocar `white` esperando mover a tinta de `onPrimary`.
///
/// O gate mede duas coisas, e a segunda é a que costuma quebrar sozinha.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  test('todo papel declara origem nos DOIS modos', () {
    // Sem origem, a célula volta a ser um hex mudo — que é o estado de antes, e ele é indistinguível
    // de "este papel é especial". O silêncio aqui não degrada, ele desinforma.
    final sem = <String>[];
    papeisDoBoldParaMedir().forEach((papel, v) {
      if (v.origemClara == null) sem.add('$papel (claro)');
      if (v.origemEscura == null) sem.add('$papel (escuro)');
    });
    expect(sem, isEmpty,
        reason: 'papel sem origem declarada: ${sem.join(', ')}. O pai devolve a '
            'origem de todos — se algum voltou nulo, o nome do papel mudou de '
            'um lado só');
  });

  test('a proporção é 10 alias para 11 derivados, e o número é a informação', () {
    // A lista não é a informação — a PROPORÇÃO é. Um vocabulário em que quase tudo é derivado é um
    // que eu não consigo mover; um em que quase nada é derivado é um em que o pai não está
    // garantindo contraste nenhum.
    //
    // O número é declarado, e não `greaterThan`: papel que muda de natureza é notícia nos dois
    // sentidos. Se ele mudar de propósito, é esta linha que se atualiza — e aí alguém teve que
    // olhar, que é o ponto.
    var alias = 0;
    var derivado = 0;
    for (final v in papeisDoBoldParaMedir().values) {
      if (v.origemClara?.alias != null) {
        alias++;
      } else {
        derivado++;
      }
    }

    // MUDOU DUAS VEZES, e as duas são a notícia que esta linha existe pra dar.
    //
    // **18/08: 16/5 → 12/9.** Quatro papéis do CLARO deixaram de ser alias de degrau e passaram a
    // sair de campo declarado (`textoClaro` · `textoSecundarioClaro` · `textoMudoClaro` ·
    // `bordaClara`, a `ds v0.111.0`), do mesmo jeito que quatro do escuro dois dias antes.
    //
    // **20/08: 12/9 → 10/11.** Os dois últimos: `bg` e `surfaceMuted` do claro, que agora saem de
    // `bgClaro` e `surfaceMutedClara` (`ds v0.119.0`, pedido deste filho). Eram **os dois únicos
    // papéis que não acompanhavam uma paleta de neto** — o gate `o_neto_troca_a_paleta_e_pronto`
    // media 32 de 42 e passou a medir 35.
    //
    // Ou seja: eu movo MENOS papel trocando a paleta, e é isso que eu queria — o que saiu do alias
    // não foi pra rampa, foi pra uma porta que eu declaro. **O número que encolhe aqui é o número de
    // coisas que dependiam de qual degrau eu apontava**, e ele encolheu até o fim.
    expect(alias, 10, reason: 'quantos papéis eu posso mover trocando a paleta');
    expect(derivado, 11, reason: 'quantos são conta do pai — os que eu NÃO movo');
    expect(alias + derivado, papeisDoBoldParaMedir().length);
  });
}
