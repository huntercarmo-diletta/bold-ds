import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Color;

/// Banco Fibra — a identidade deste produto, e ela é UMA decisão.
///
/// A rampa de marca inteira deriva desta cor (nove degraus em OKLCH, com o croma limitado ao
/// gamute); a gramática do material — card de vidro, canto do botão, canto da folha, blur — vem do
/// Coreflow; e erro, aviso, sucesso e a rampa neutra vêm da linguagem, porque **cor semântica é
/// invariante**. Nada vem de outro produto.
///
/// Gerado pelo Berço Coreflow em 2026-10-28 (pai coreflow · bold-ds v0.127.0 · avô v3.24.0).
/// A marca entra no degrau 02 da rampa.
/// A marca visual deste produto. Com `logoTingePorCurrentColor`, o arquivo manda na cor: o que ele
/// escreve em `currentColor` o pai tinge por modo (`CoreflowProduto.marcaNo`: preto no claro, branco
/// no escuro) e o que tem cor fixa entra como o designer desenhou. SEM essa chave, o `DilettaLogo`
/// aplica `ColorFilter.srcIn` e pinta o desenho inteiro de uma cor só.
const DilettaBrand _marcaBancoFibra = DilettaBrand(
  pacote: 'banco_fibra_coreflow',
  // O SÍMBOLO É A VARIANTE `mark` — o desenho que funciona sem a palavra, e que o avô pede para as top
  // bars densas, o avatar, o comprovante e os cartões de carteira. Seis peças dele o desenham sem
  // passar `variant:`, então este arquivo é o que elas mostram.
  logo: 'assets/logos/banco_fibra_simbolo.svg',
  logoFull: 'assets/logos/banco_fibra.svg',
  // O LOCKUP DA PÁGINA ESCURA VEIO DO CLIENTE — a versão do manual dele para fundo escuro, desenhada
  // para ela (pode ter mais de uma cor; não é a positiva/negativa). O avô a aceita desde a v0.196.0:
  // par declarado desliga o `srcIn`, e a arte entra como foi desenhada. Conferida no Berço contra a
  // página e a superfície escuras, na proporção do lockup claro e na forma de lockup.
  logoFullEscuro: 'assets/logos/banco_fibra_escuro.svg',
  // O SÍMBOLO DA PÁGINA ESCURA VEIO DO CLIENTE. É ele que as seis peças que desenham só a marca (top
  // bar densa, avatar, comprovante, cartões de carteira) mostram no escuro.
  logoEscuro: 'assets/logos/banco_fibra_simbolo_escuro.svg',
  logoTingePorCurrentColor: true,
  nomeDaMarca: 'Banco Fibra',
  proporcaoDoLockup: 3.4378,
  hexesDaArte: DilettaIllustrationBrand.rampaDoPai,
);

/// O filho nasce pelo `daMarca` (rampa, vinho derivado, tinte e traço do vidro, vocabulário do
/// Coreflow) e só então recebe os ajustes que este produto decidiu — `.comMaterial` preserva tudo
/// que não for passado.
final CoreflowProduto _baseBancoFibra = CoreflowProduto.daMarca(
  marca: const Color(0xFF0D1882),
  id: 'bancoFibra',
  nome: 'Banco Fibra',
);

final DilettaPalette _paletaBancoFibra = _baseBancoFibra.paleta.comMaterial(
  raioDeBotao: 4,
  raioDeFolha: 8,
  // A FORMA DA MARCA INTEIRA — «Formal», cantos quase retos. Seis papéis de medida, pelo nome
  // (`DilettaMedida`, avô ≥ v0.194.0): é por aqui que cartão, campo, vidro e nav recebem o canto que o
  // cliente escolheu; `raioDeBotao`/`raioDeFolha` acima continuam como alias, e a tabela vence.
  medidas: const {
    DilettaMedida.formaDeBotao: 4,
    DilettaMedida.formaDeFolha: 8,
    DilettaMedida.formaDeCampo: 6,
    DilettaMedida.formaDeCartao: 8,
    DilettaMedida.formaDeVidro: 6,
    DilettaMedida.formaDeNav: 10,
  },
);

final bancoFibra = CoreflowProduto(
  paleta: _paletaBancoFibra,
  marca: _marcaBancoFibra,
);
