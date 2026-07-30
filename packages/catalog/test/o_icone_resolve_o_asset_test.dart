import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// O ÍCONE RESOLVE O ASSET — o gate do defeito que ninguém vê.
///
/// Relatado pelo dono do produto: *"os ícones não estão renderizando"*. E não havia exceção em lugar
/// nenhum: `DilettaAssets.assetPackage` nasce `null` (= assets na raiz do bundle), num app que CONSOME o
/// pacote eles moram em `packages/diletta_design_system/…`, e `VectorGraphic` com asset ausente **desenha
/// uma caixa vazia** em vez de falhar.
///
/// Por que os testes existentes passavam: eles perguntavam "o widget está na árvore?". Widget na árvore
/// com asset inexistente é exatamente o estado do defeito. Este gate pergunta a outra coisa — **os bytes
/// carregam?** — e é a única pergunta que distingue os dois.
void main() {
  setUpAll(configurarDsDoBold);

  testWidgets('os bytes do ícone carregam pelo MESMO caminho que o widget usa', (t) async {
    // Não é `rootBundle.load('caminho que eu escrevi')`: é o loader do pai, com a configuração que o
    // plugue fez. Testar o caminho à mão passaria mesmo com o `assetPackage` errado.
    for (final nome in [
      DilettaIcons.bellLight,
      DilettaIcons.circleCheckLight,
      DilettaIcons.pixLight,
      DilettaIcons.stampLight,
    ]) {
      final loader = DilettaAssets.vecLoader('assets/icons/$nome.svg.vec');
      final bytes = await loader.loadBytes(null);
      expect(bytes.lengthInBytes, greaterThan(0), reason: 'o ícone "$nome" não carregou');
    }
  });

  testWidgets('e o gate SABE falhar — com assetPackage nulo, o asset não existe', (t) async {
    // O controle é o defeito relatado, reconstruído: sem o namespace, o mesmo ícone não é encontrado.
    final anterior = DilettaAssets.assetPackage;
    addTearDown(() => DilettaAssets.assetPackage = anterior);
    DilettaAssets.assetPackage = null;

    // A FUNÇÃO e não o Future: passar o future já iniciado deixa a exceção escapar pro framework antes
    // de o matcher vê-la — o teste falha em vez de passar, e por um motivo que não é o que ele mede.
    await expectLater(
      () => DilettaAssets.vecLoader('assets/icons/${DilettaIcons.bellLight}.svg.vec')
          .loadBytes(null),
      throwsA(anything),
      reason: 'se isto CARREGA, o asset está na raiz e este gate não mede nada',
    );
  });

  testWidgets('o plugue declara o namespace do PAI, não o do filho', (t) async {
    // Os assets são do pacote do pai; o filho re-exporta a API, não os arquivos. Apontar pro pacote do
    // filho é o erro plausível — e ele daria o mesmo sintoma silencioso.
    expect(DilettaAssets.assetPackage, 'diletta_design_system');
    final bytes = await const AssetBundleWrapper()
        .load('packages/diletta_design_system/assets/icons/bell-light.svg.vec');
    expect(bytes.lengthInBytes, greaterThan(0));
  });
}

/// Só pra deixar explícito no teste QUAL caminho é o verdadeiro no bundle.
class AssetBundleWrapper {
  const AssetBundleWrapper();
  Future<ByteData> load(String key) => rootBundle.load(key);
}
