import 'dart:io';

import 'package:conta_bold_catalog/builder/ligacoes.g.dart';
import 'package:conta_bold_catalog/builder/screen_specs.g.dart';
import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// OS ALVOS DA AUTORIA — e este gate é a dívida que o pai declarou como dele e eu fecho como minha.
///
/// A `v0.76.0` do motor trouxe o servidor de autoria dentro do pacote e a seção que faltava na doc. O
/// último parágrafo dela é o que este arquivo mede:
///
/// > *"O que eu ainda NÃO tenho gate pra pegar, e digo porque é a sua garantia: nada me avisa se você
/// > apontar o caminho pra um arquivo escrito à mão."*
///
/// Ele está certo em não medir: quais arquivos são gerados neste repo é conhecimento daqui. O que se mede:
///
/// 1. os dois caminhos declarados EXISTEM e carregam o cabeçalho `GERADO`;
/// 2. o conteúdo deles é **função pura do estado** — regerar a partir do que eles próprios contêm devolve
///    byte por byte o mesmo arquivo. É o que prova que ninguém editou à mão, e é a única forma de pegar
///    isso sem parser de Dart;
/// 3. o README documenta o servidor com os MESMOS dois caminhos em `--permite`. O servidor não lê o Dart,
///    então esses dois números vivem em lugares diferentes e divergem calados — foi por não bater que o
///    "editar tela" não chegou aqui na primeira vez.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  /// O teste roda com o CWD no pacote (`packages/catalog`), e os caminhos declarados são relativos a ele.
  File arquivo(String caminhoDeclarado) => File(caminhoDeclarado);

  test('os dois caminhos declarados existem, e dizem que são GERADOS', () {
    for (final caminho in [
      Conteudo.caminhoDoArquivoDeSpecs,
      Conteudo.caminhoDoArquivoDeLigacoes,
    ]) {
      expect(caminho, isNotEmpty, reason: 'caminho não declarado: o botão só pode dizer isso');
      final f = arquivo(caminho);
      expect(f.existsSync(), isTrue, reason: '$caminho declarado e inexistente');
      expect(f.readAsStringSync(), startsWith('// GERADO'),
          reason: '$caminho não se anuncia gerado — e a primeira gravação apaga o que houver nele');
    }
  });

  test('as specs são função pura do estado — regerar devolve o MESMO arquivo', () {
    // Decodifica com o vocabulário deste DS e codifica de volta: se alguém tiver escrito JSON à mão ali
    // (uma prop que não existe, uma vírgula a mais, uma indentação própria), o texto regerado difere.
    final regerado = gerarScreenSpecsDart({
      for (final e in kScreenSpecsJson.entries)
        e.key: encodeSpec(decodeSpecCom(e.value, registro: Ds.blocos)),
    });
    expect(regerado, arquivo(Conteudo.caminhoDoArquivoDeSpecs).readAsStringSync(),
        reason: 'o arquivo de specs foi editado à mão, ou o gerador do pai mudou de forma');
  });

  test('as setas também, e com o import que ESTE repo declarou', () {
    final regerado = gerarLigacoesDart(
      kLigacoes,
      importDoTipo: Conteudo.importDoTipoDeLigacao,
    );
    expect(regerado, arquivo(Conteudo.caminhoDoArquivoDeLigacoes).readAsStringSync(),
        reason: 'o arquivo de ligações foi editado à mão, ou o import declarado não é o que está nele');
  });

  test('o README manda rodar o servidor com os MESMOS caminhos', () {
    // O README é a única peça que fala com quem vai rodar o servidor, e o servidor não lê o Dart. Sem
    // esta linha, mudar um caminho no plugue deixa o comando do README apontando pro antigo — e aí o
    // salvar responde 403 sem dizer por quê.
    final readme = File('../../README.md').readAsStringSync();
    expect(readme, contains('diletta_catalog_core:servidor_autoria'));
    for (final caminho in [
      Conteudo.caminhoDoArquivoDeSpecs,
      Conteudo.caminhoDoArquivoDeLigacoes,
    ]) {
      expect(readme, contains('--permite $caminho'),
          reason: 'o README não permite $caminho — o servidor recusaria a gravação');
    }
  });

  test('e o gate SABE reprovar — controle com arquivo escrito à mão', () {
    // Sem o controle, os dois round-trips passariam num arquivo vazio de mudanças por comparar duas
    // strings iguais por construção.
    const aMao = "// escrito à mão\nconst Map<String, String> kScreenSpecsJson = {};\n";
    expect(aMao, isNot(startsWith('// GERADO')));
    expect(gerarScreenSpecsDart(const {}), isNot(aMao));
  });
}
