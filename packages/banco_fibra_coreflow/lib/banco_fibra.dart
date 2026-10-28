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
///
/// **A ARTE NÃO VEIO DO CLIENTE, e é provisória.** Não houve manual nem vetor do banco: o envio do
/// Berço (28/10) foi montado do site público (bancofibra.com.br). Os quatro SVG abaixo são a
/// VETORIZAÇÃO dos PNG de lá — contorno dos pixels, simplificado em polígonos —, todos com cor fixa
/// (nenhum usa `currentColor`):
///
/// - o lockup é o `logo.png` do cabeçalho do site, em `#0D1882`;
/// - o símbolo é o "F" recortado desse mesmo lockup (o favicon de 192 px era borrado demais);
/// - as duas versões escuras são o MESMO desenho pintado de branco, e não uma arte para fundo escuro.
///
/// **Trocar pelo vetor oficial quando o banco mandar** — os quatro arquivos, com os mesmos nomes; a
/// `proporcaoDoLockup` sai do `viewBox` do lockup novo.
const DilettaBrand _marcaBancoFibra = DilettaBrand(
  pacote: 'banco_fibra_coreflow',
  // O SÍMBOLO É A VARIANTE `mark` — o desenho que funciona sem a palavra, e que o avô pede para as top
  // bars densas, o avatar, o comprovante e os cartões de carteira. Seis peças dele o desenham sem
  // passar `variant:`, então este arquivo é o que elas mostram.
  logo: 'assets/logos/banco_fibra_simbolo.svg',
  logoFull: 'assets/logos/banco_fibra.svg',
  // O LOCKUP DA PÁGINA ESCURA NÃO VEIO DO CLIENTE: é o lockup claro vetorizado do site, pintado de
  // branco, porque o azul-marinho some no fundo escuro e o site não publica versão para ele. O avô
  // aceita o par desde a v0.196.0: par declarado desliga o `srcIn`, e a arte entra como está.
  // Conferido no Berço contra a página e a superfície escuras, na proporção do lockup claro.
  // Trocar pela versão para fundo escuro do manual do banco, se ele tiver uma.
  logoFullEscuro: 'assets/logos/banco_fibra_escuro.svg',
  // O SÍMBOLO DA PÁGINA ESCURA também é o "F" do site pintado de branco, não arte do cliente. É ele
  // que as seis peças que desenham só a marca (top bar densa, avatar, comprovante, cartões de
  // carteira) mostram no escuro. Trocar junto com o lockup.
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
  // (`DilettaMedida`, avô ≥ v0.194.0): é por aqui que cartão, campo, vidro e nav recebem o canto;
  // `raioDeBotao`/`raioDeFolha` acima continuam como alias, e a tabela vence. A forma NÃO foi escolha
  // do banco: quem preencheu o Berço a tirou do logo, de cantos retos. Confirmar com o banco.
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
