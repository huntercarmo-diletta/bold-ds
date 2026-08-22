/// O GANCHO que o `flutter_test` roda antes de tudo.
///
/// As mesmas quatro chamadas do `main()`, e não é redundância: sem isto os testes
/// começam SEM DS plugado, e essa classe de erro não aparece como falha — aparece como
/// golden gravando a ausência do que ele deveria provar.
///
/// ## E a FONTE DE VERDADE, que é a razão mais forte deste arquivo existir
///
/// O `flutter_test` roda com uma fonte de fallback em que **todo glifo é um quadrado de 1em**. Texto fica
/// muito mais largo do que no produto, e quem mede LAYOUT com ela mede uma tela que não existe.
///
/// Isso me pegou de cheio: os meus dois sweeps de largura e o estouro que eu reportei ao pai no
/// `CoreflowSegmentos` foram medidos com a fonte quadrada. **Os números eram um teto, não o produto** — e um
/// gate de layout que exagera acusa componente são, o que ensina a ignorar o vermelho.
///
/// Carregar o Inter aqui vale pra TODOS os testes deste pacote de uma vez, que é o que o gancho existe pra
/// fazer. Se nenhum arquivo aparecer, isto ESTOURA — gate de layout rodando com a fonte errada em silêncio
/// é pior que gate nenhum.
library;

import 'dart:async';
import 'dart:io';

import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// De onde as fontes vêm: o pacote do DS, que é quem as declara no `pubspec`.
///
/// Por caminho de ARQUIVO e não por `rootBundle`: o bundle de um teste não monta o asset de um pacote
/// irmão, e o `cwd` de um teste é a raiz do pacote.
const _pastaDasFontes = '../coreflow_design_system/assets/fonts';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A família com o PREFIXO do pacote (`packages/coreflow_design_system/Inter`), que é o nome pelo qual
  // o `DilettaText` a pede. Registrar como `Inter` cru carrega uma família que ninguém consome: o load
  // funciona, e o texto continua saindo na fonte quadrada — a falha mais silenciosa possível num gate de
  // layout, porque tudo fica verde e os números continuam errados.
  //
  // Registro os DOIS nomes: quem aplica a família é o `ThemeData` do app hospedeiro (`familyRaw`), e o
  // caminho com prefixo é o que um `TextStyle` com `package:` pediria. Um só dos dois deixa metade do
  // texto na fonte quadrada, dependendo de quem escreveu o estilo.
  var carregadas = 0;
  final loaders = [FontLoader(BoldFonts.familyRaw), FontLoader(BoldFonts.family)];
  for (final arquivo in const [
    'Inter-Regular.ttf',
    'Inter-Medium.ttf',
    'Inter-SemiBold.ttf',
    'Inter-Bold.ttf',
    'Inter-ExtraBold.ttf',
  ]) {
    final f = File('$_pastaDasFontes/$arquivo');
    if (!f.existsSync()) continue;
    for (final l in loaders) {
      l.addFont(f.readAsBytes().then((b) => ByteData.sublistView(b)));
    }
    carregadas++;
  }
  if (carregadas == 0) {
    throw StateError(
        'nenhuma fonte carregada de $_pastaDasFontes — todo gate de layout deste pacote passaria a '
        'medir com a fonte quadrada do flutter_test, que é bem mais larga que a real');
  }
  for (final l in loaders) {
    await l.load();
  }

  configurarChromeDoBold();
  configurarDsDoBold();
  configurarConteudoDoBold();
  await testMain();
}
