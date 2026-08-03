import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// O ÍCONE DO PAI SÓ RESOLVE SE ALGUÉM DISSER ONDE ELE MORA — e ninguém dizia.
///
/// Chegou como *"os ícones não estão aparecendo no app"*: setas de voltar, ícones da home e o `>` do
/// extrato, todos sumidos ao mesmo tempo, depois de a adoção trocar componentes do app por componentes do
/// pai. **Nada falhou** — nem `analyze`, nem os 414 testes do app, nem o console.
///
/// A mecânica: `DilettaIcon` desenha com `VectorGraphic(loader: AssetBytesLoader(path, packageName:))`, e
/// `DilettaAssets.assetPackage` nasce `null` — "assets na raiz do bundle". Num app CONSUMIDOR eles moram
/// em `packages/diletta_design_system/…`, então o loader procura no lugar errado. E `VectorGraphic` com
/// asset ausente não estoura: **desenha caixa vazia.**
///
/// A linha mora no `BoldTheme` porque quem liga o DS é quem sabe onde o DS guarda coisa. No `main` do app
/// ela seria uma linha que todo app novo precisa lembrar de copiar.
void main() {
  test('tocar no tema já diz onde os assets do pai moram', () {
    // Estado de fábrica: o pacote do pai não assume nada.
    DilettaAssets.assetPackage = null;

    // Nenhuma chamada de configuração: só usar o tema, que é o que qualquer consumidor faz.
    final _ = BoldTheme.light;

    expect(DilettaAssets.assetPackage, DilettaAssets.package,
        reason: 'sem isto o VectorGraphic procura na raiz do bundle e desenha caixa vazia — em silêncio');
    expect(DilettaAssets.package, 'diletta_design_system');
  });

  test('e o escuro também, porque um app pode abrir direto no escuro', () {
    DilettaAssets.assetPackage = null;
    final _ = BoldTheme.dark;
    expect(DilettaAssets.assetPackage, DilettaAssets.package);
  });

  test('não sobrescreve escolha de quem já decidiu', () {
    // Um consumidor que hospede os ícones em outro pacote (o contrato do pai prevê) declara o dele, e o
    // tema não pode pisar por cima.
    DilettaAssets.assetPackage = 'outro_pacote_de_icones';
    final _ = BoldTheme.light;
    expect(DilettaAssets.assetPackage, 'outro_pacote_de_icones');
    DilettaAssets.assetPackage = DilettaAssets.package;
  });
}
