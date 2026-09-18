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
  // A NEGATIVA DO LOCKUP, na página escura. O pedido entrou: o avô a entregou na `v0.196.0`
  // (`logoEscuro`/`logoFullEscuro`, veredito de 16/09), e a porta deste lado abriu em 18/09 —
  // `CoreflowProduto.marcaNo` copiava 12 dos 14 campos do plugue e o par não atravessava o tema.
  //
  // **Ela é o par do `logoFull`, e não do `logo`, porque é o LOCKUP** — medido nos arquivos, não
  // deduzido do nome: `norte_benk_mono.svg` tem `viewBox 0 0 380 166` e 7 paths, os mesmos do
  // `norte_benk.svg`; o símbolo é `0 0 197 84` e 2 paths. Declará-la no slot do símbolo poria a palavra
  // de volta nas seis peças que desenham só a marca.
  //
  // O arquivo já vem BRANCO (7 `fill="white"`, nenhum `currentColor`), que é o que o negativo é. Medido
  // contra as páginas deste produto: **17,87:1 na escura (`#14181A`) e 1,00:1 na clara** — ele só pode
  // ser a arte do escuro, e é exatamente o slot em que entra. O que ele conserta tem número: o azul da
  // marca (`#2A57A5`) dá **2,56:1** na página escura, abaixo do piso gráfico de 3:1.
  //
  // O par declarado DESLIGA o `srcIn` no avô (`pinta = color != null || !temPar`), então nada repinta
  // esta arte — é o desenho do cliente, como ele o entregou.
  logoFullEscuro: 'assets/logos/norte_benk_mono.svg',
  // NÃO existe `logoEscuro` AQUI, e a ausência é declarada em vez de improvisada: **o cliente não
  // mandou negativa do SÍMBOLO**, e o avô não deriva desenho (*«tinta se deriva, desenho não se
  // deriva»*, veredito de 16/09). Sem o campo, `null` ⇒ o símbolo colorido vale nos dois brilhos, que é
  // o comportamento de antes — mas as seis peças que o desenham sem passar `variant:` (top bar densa,
  // avatar, comprovante, cartões de carteira) seguem com o azul a 2,56:1 na página escura. **É pedido
  // ao dono da marca, e o lugar de pedir é o Berço**, na etapa do logo, ao lado do lockup negativo.
  // Enquanto não chega, quem precisar da marca sobre fundo escuro passa `color:` no sítio — chamada
  // vence marca e arquivo, que é a precedência escrita no `///` do avô.
  //
  // Esta chave continua e é carga estrutural: sem ela o `DilettaLogo` aplica `ColorFilter.srcIn` com a
  // `corDoLogo` que o `marcaNo` preenche (preto no claro, branco no escuro) e pinta o lockup COLORIDO
  // de uma cor só. Os três arquivos não têm `currentColor`, então ela não tinge nada — ela impede.
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
