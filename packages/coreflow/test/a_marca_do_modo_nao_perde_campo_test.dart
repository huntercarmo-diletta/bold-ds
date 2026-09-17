import 'dart:convert';
import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A MARCA DO MODO NÃO PERDE CAMPO — o gate da cópia campo a campo.
///
/// `CoreflowProduto.marcaNo(brilho)` reconstrói o `DilettaBrand` inteiro só para trocar a `corDoLogo`,
/// porque o plugue do avô não tem `copyWith`. O `///` do método já escrevia o preço dessa forma — *"um
/// campo novo do pai que não estiver nesta lista chega no default no tema"* — e em 17/09 o preço foi
/// cobrado: `nomeDaMarca` entrou no plugue depois da lista, ninguém o acrescentou, e todo produto que
/// não declara `corDoLogo` (o Bold inclusive) perdia o nome da marca ao montar o tema.
///
/// O que fazia disso um defeito de tela, e não uma dívida elegante: `nomeDaMarca` é o rótulo de leitor
/// de tela da co-marca, e a peça do avô resolvia a ausência com o nome de OUTRO produto cravado
/// (`?? "CPF Seguro"`, que ele mesmo consertou na `v0.185.0`). Filho sem o nome ⇒ o VoiceOver de um
/// cliente dizia o nome de outro.
///
/// Por isso o gate tem DUAS provas, e a segunda é a que importa:
///
/// 1. **o caso**: uma marca com todo campo em valor não-default atravessa os dois modos inteira;
/// 2. **a classe**: o número de campos do `DilettaBrand` é contado NO ARQUIVO DO AVÔ, e comparado com
///    o que esta casa sabe copiar. Campo novo lá ⇒ este teste falha aqui, no commit em que o `ref:`
///    sobe — e não seis telas depois, em silêncio, como aconteceu com o `nomeDaMarca`.
///
/// Quando o `copyWith` entrar no avô (PEDIDO de 17/09), a prova 2 perde a razão de existir e sai junto
/// com a cópia manual. A prova 1 fica: ela mede o comportamento, não a forma de escrevê-lo.
void main() {
  // Todo campo em valor NÃO-default: um campo esquecido na cópia volta ao default e a asserção pega.
  const marcaCheia = DilettaBrand(
    pacote: 'pacote_do_filho',
    logo: 'assets/logos/simbolo.svg',
    logoFull: 'assets/logos/lockup.svg',
    logoParceiro: 'assets/logos/parceiro.svg',
    bandeiraDoCartao: 'assets/logos/bandeira.svg',
    nomeDaMarca: 'BANCO DE TESTE',
    proporcaoDoLockup: 2.5,
    logoTingePorCurrentColor: true,
    hexesDaArte: {'#ABCDEF': 'primary04'},
  );

  CoreflowProduto produtoCom(DilettaBrand m) =>
      CoreflowProduto(paleta: DilettaPalette.referencia, marca: m);

  group('a marca atravessa o modo inteira', () {
    for (final brilho in Brightness.values) {
      test('nenhum campo declarado se perde no ${brilho.name}', () {
        final antes = marcaCheia;
        final depois = produtoCom(marcaCheia).marcaNo(brilho);

        expect(depois.pacote, antes.pacote);
        expect(depois.logo, antes.logo);
        expect(depois.logoFull, antes.logoFull);
        expect(depois.logoParceiro, antes.logoParceiro);
        expect(depois.bandeiraDoCartao, antes.bandeiraDoCartao);
        expect(depois.carteirasDeSistema, antes.carteirasDeSistema);
        expect(depois.selosDeLoja, antes.selosDeLoja);
        expect(depois.proporcaoDoLockup, antes.proporcaoDoLockup);
        expect(depois.logoTingePorCurrentColor, antes.logoTingePorCurrentColor);
        expect(depois.hexesDaArte, antes.hexesDaArte);

        // O caso que caiu. Fica nomeado, e não diluído na lista acima.
        expect(
          depois.nomeDaMarca,
          antes.nomeDaMarca,
          reason: 'o nome da marca é o rótulo de leitor de tela da co-marca; sem ele a peça do avô '
              'dizia o nome de outro produto',
        );
      });
    }

    test('a corDoLogo é o ÚNICO campo que a regra troca, e só quando o produto não a declarou', () {
      expect(produtoCom(marcaCheia).marcaNo(Brightness.light).corDoLogo,
          DilettaAbsoluteColors.black);
      expect(produtoCom(marcaCheia).marcaNo(Brightness.dark).corDoLogo,
          DilettaAbsoluteColors.white);

      // Produto que declara a cor é devolvido intacto — a regra só preenche ausência.
      const comCor = DilettaBrand(pacote: 'p', nomeDaMarca: 'N', corDoLogo: Color(0xFF00FF00));
      final devolvida = produtoCom(comCor).marcaNo(Brightness.dark);
      expect(identical(devolvida, comCor), isTrue);
    });
  });

  test('campo novo no plugue do avô derruba este gate — a classe, não o caso', () {
    // O ARQUIVO do avô, pelo endereço que o próprio resolvedor de pacotes deu: ler a fonte é o único
    // jeito de contar campos sem espelho (`dart:mirrors` não roda em teste de Flutter).
    final cfg = File('.dart_tool/package_config.json');
    expect(cfg.existsSync(), isTrue,
        reason: 'rode `flutter pub get` antes: este gate lê o plugue na fonte do avô');
    final pacotes = (jsonDecode(cfg.readAsStringSync())['packages'] as List)
        .cast<Map<String, dynamic>>();
    final avo = pacotes.firstWhere((p) => p['name'] == 'diletta_design_system');
    // a barra final não é detalhe: sem ela `resolve` troca o último segmento em vez de descer nele
    final bruto = avo['rootUri'] as String;
    final raiz = cfg.parent.uri.resolve(bruto.endsWith('/') ? bruto : '$bruto/');
    final fonte = File.fromUri(raiz.resolve('lib/src/theme/diletta_brand_assets.dart'));
    expect(fonte.existsSync(), isTrue, reason: 'não achei o plugue de marca em ${fonte.path}');

    // `final <tipo> <nome>;` no corpo da classe. O `///` acima de cada um não casa, e o construtor
    // tampouco — ali os campos aparecem como `this.<nome>`.
    final campos = RegExp(r'^\s{2}final\s+[\w<>?,\s]+\s(\w+);', multiLine: true)
        .allMatches(fonte.readAsStringSync())
        .map((m) => m.group(1)!)
        .toSet();

    // O que esta casa sabe copiar em `CoreflowProduto.marcaNo`. Acrescentar um nome aqui sem
    // acrescentá-lo LÁ não engana o gate: a prova de cima mede o comportamento.
    const copiados = {
      'pacote', 'logo', 'logoFull', 'logoParceiro', 'bandeiraDoCartao', 'carteirasDeSistema',
      'selosDeLoja', 'nomeDaMarca', 'corDoLogo', 'logoTingePorCurrentColor', 'proporcaoDoLockup',
      'hexesDaArte',
    };

    expect(
      campos.difference(copiados),
      isEmpty,
      reason: 'O avô ganhou campo(s) que o `marcaNo` não copia. Acrescente-o(s) à cópia em '
          'lib/src/coreflow_produto.dart e a este gate — ou, melhor, cobre o `copyWith` pedido em '
          'docs/pedidos/2026-09-17-a-copia-campo-a-campo-perde-campo-e-perdeu.md',
    );
    expect(copiados.difference(campos), isEmpty,
        reason: 'esta lista cita campo que não existe mais no plugue do avô');
  });
}
