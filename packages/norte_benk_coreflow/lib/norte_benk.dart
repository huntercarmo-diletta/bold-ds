import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Color;

/// Norte Benk — a identidade deste produto, e ela é UMA decisão.
///
/// A rampa de marca inteira deriva desta cor (nove degraus em OKLCH, com o croma limitado ao
/// gamute); a gramática do material — card de vidro, canto do botão, canto da folha, blur — vem do
/// Coreflow; e erro, aviso, sucesso e a rampa neutra vêm da linguagem, porque **cor semântica é
/// invariante**. Nada vem de outro produto.
///
/// Gerado pelo Berço Coreflow em 2026-09-17 (pai coreflow · bold-ds v0.102.1 · avô v0.180.0).
/// A marca entra no degrau 03 da rampa.
/// A marca visual deste produto. Com `logoTingePorCurrentColor`, o arquivo manda na cor: o que ele
/// escreve em `currentColor` o pai tinge por modo (`CoreflowProduto.marcaNo`: preto no claro, branco
/// no escuro) e o que tem cor fixa entra como o designer desenhou. SEM essa chave, o `DilettaLogo`
/// aplica `ColorFilter.srcIn` e pinta o desenho inteiro de uma cor só.
const DilettaBrand _marcaNorteBenk = DilettaBrand(
  pacote: 'norte_benk_coreflow',
  // O SÍMBOLO É A VARIANTE `mark` — o desenho que funciona sem a palavra, e que o avô pede para as top
  // bars densas, o avatar, o comprovante e os cartões de carteira. Seis peças dele o desenham sem
  // passar `variant:`, então este arquivo é o que elas mostram.
  logo: 'assets/logos/norte_benk_simbolo.svg',
  logoFull: 'assets/logos/norte_benk.svg',
  // A VERSÃO POSITIVA/NEGATIVA veio do cliente e viaja em `assets/logos/norte_benk_mono.svg`. Ela é um
  // DESENHO à parte — contraforma que vira traço, símbolo que perde o container —, e não o colorido
  // repintado. O caminho dela no avô é o padrão do `DilettaLogo`: sem `logoTingePorCurrentColor`,
  // `ColorFilter.srcIn` com `corDoLogo`. Só que `DilettaBrand` tem UM `logo`, e ele está com a
  // colorida — as duas ao mesmo tempo estão pedidas em
  // `docs/pedidos/2026-09-14-o-logo-tem-uma-arte-e-a-pagina-tem-duas.md` (bold-ds). Até o pedido
  // entrar, quem monta o app aplica este arquivo à mão onde a colorida não separa do fundo, com a
  // tinta que medir mais contraste ali — o manifesto traz a medição em `marcaVisual.tintaPropostaPorFundo`.
  logoTingePorCurrentColor: true,
  nomeDaMarca: 'Norte Benk',
  proporcaoDoLockup: 2.2892,
  hexesDaArte: DilettaIllustrationBrand.rampaDoPai,
);

/// O filho nasce pelo `daMarca` (rampa, vinho derivado, tinte e traço do vidro, vocabulário do
/// Coreflow) e só então recebe os ajustes que este produto decidiu — `.comMaterial` preserva tudo
/// que não for passado.
final CoreflowProduto _baseNorteBenk = CoreflowProduto.daMarca(
  marca: const Color(0xFF2A57A5),
  id: 'norteBenk',
  nome: 'Norte Benk',
);

final DilettaPalette _paletaNorteBenk = _baseNorteBenk.paleta.comMaterial(
  raioDeBotao: 26,
  raioDeFolha: 32,
);

final norteBenk = CoreflowProduto(
  paleta: _paletaNorteBenk,
  marca: _marcaNorteBenk,
);
