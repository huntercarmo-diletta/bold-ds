/// OS FUNDAMENTOS DA DILETTA — a cara do Coreflow: a prosa que ensina, e não o inventário.
///
/// A fronteira é do avô: **Foundations são as DECISÕES, que se leem uma vez; Styles é o INVENTÁRIO,
/// que se consulta.** A aba de Styles do catálogo se deriva sozinha da paleta deste produto; esta não
/// se deriva de token nenhum — é texto, e por isso mora aqui, no pacote de quem decidiu.
///
/// A prosa da LINGUAGEM viaja no pacote do avô (`kDilettaLinguagem`); o que está neste arquivo é só o
/// que é decisão DESTE produto. Os números são os da medição de 09/09, e a régua do pai continua
/// valendo: o único hex de código deste pacote é o de `diletta.dart`. Hex em prosa é citação.
library;

/// `título → markdown`. É o formato que o plugue do catálogo entrega ao motor.
const Map<String, String> kDilettaFundamentos = {
  'A paleta da Diletta': _paleta,
  'O vermelho e o semáforo': _semaforo,
  'O vinho e o vidro, derivados': _vinhoEVidro,
  'A tipografia: Inter': _tipografia,
  'O logo': _logo,
};

const _paleta = r'''
## Este produto declara UMA cor

O `#E60000` do símbolo. Rampa, papéis, vinho, vidro e gradiente derivam dele pela régua do avô
(`DilettaPalette.daMarca`) — a mesma porta pela qual o gerador `novo_filho` faz nascer qualquer produto.
Nada aqui é escolha degrau a degrau: a cor da marca cai no **degrau 04**, e os outros oito saem da
curva de claridade que a linguagem define.

| degrau | valor | contraste com branco | com preto |
|---|---|---|---|
| `primary01` | `#2F0503` | 18,36 | 1,14 |
| `primary02` | `#5A0704` | 14,32 | 1,47 |
| `primary03` | `#920E08` | 9,18 | 2,29 |
| **`primary04`** | **`#E60000`** | **4,81** | 4,36 |
| `primary05` | `#FB5B4A` | 3,14 | 6,70 |
| `primary06` | `#F68C7D` | 2,34 | 8,97 |
| `primary07` | `#E5CAC5` | 1,55 | 13,59 |
| `primary08` | `#F8F0EE` | 1,12 | 18,69 |
| `primary09` | `#FBF8F7` | 1,06 | 19,87 |

## O que a conformidade do avô mediu

Zero violações nos dois modos, e o par que importa passa **AA de texto** sem retoque:

| par | claro | escuro |
|---|---|---|
| `onPrimary` (branco) sobre `primary` | 4,81 | 4,81 |
| `primary` sobre `bg` | 4,81 | 3,71 |
| `onPrimarySubtle` sobre `primarySubtle` | `#920E08` / `#F8F0EE` | `#E5CAC5` / `#920E08` |

O vermelho não muda entre claro e escuro: a régua do avô só troca o degrau de ação quando a cor da
marca reprova com a tinta, e esta não reprova. É a mesma razão pela qual o rosa do primeiro filho fica
igual nos dois modos.

**Rampa não é gosto: é a estrutura que faz o papel derivado ter contraste.** Aqui ela é inteira do
avô — a Diletta não tem um hex de rampa pra defender.
''';

const _semaforo = r'''
## A pergunta certa: o vermelho da marca briga com o vermelho de erro?

Sim, se a cor fosse o único sinal. A medição de 09/09 pôs a marca ao lado do `error` do avô:

| par | contraste entre eles |
|---|---|
| `primary` × `error` (claro, `#B3251D`) | 1,36 |
| `primary` × `error` (escuro, `#D8483F`) | 1,13 |

Dois vermelhos lado a lado não se distinguem por cor. E o WCAG já decide isso por nós: **cor nunca é o
único portador de significado** (SC 1.4.1). Estado se diz por FORMA — ícone, ponto, rótulo, posição —
e a cor reforça. As etiquetas de sucesso, espera e falha vêm da linguagem, não da marca, e são iguais
nas duas marcas da casa.

## O que foi medido antes de decidir manter

Três caminhos pra afastar a marca do semáforo, e nenhum comprou o bastante:

| caminho | o que ganha | o que custa |
|---|---|---|
| escurecer até `#B30000` | branco a **7,20** (AAA) | cai no degrau 03; o 04 recalculado vira `#EB0000`, e o produto passa a ter DOIS vermelhos de marca |
| puxar pro laranja (`#EA4000`) | mais longe do erro | branco a 4,01 — perde AA de texto; e deixa de ser a cor do símbolo |
| puxar pro carmim (`#DB005C`) | branco a 5,04 | se aproxima do rosa do primeiro cliente — troca um vizinho por outro |

A decisão da dona do produto (09/09): **manter o `#E60000`** e resolver o semáforo por forma. A cor
que está no símbolo é a cor que está no botão — e um white label que muda a cor da marca pra caber na
ferramenta inverteu quem serve a quem.
''';

const _vinhoEVidro = r'''
## A Diletta não declara vinho nem vidro — e recebe os dois

O primeiro cliente do Coreflow (o filho de paleta inteira) declarou os três degraus do vinho e os quatro valores do vidro na paleta dele. Este
não declara nenhum, e o pai não empresta o valor de ninguém: quem não declara recebe **a regra sobre a
própria rampa**.

| o que | como deriva |
|---|---|
| vinho da marca | entre `primary02` e `primary03`, em 0,69 |
| lavagem | entre `primary01` e `primary02`, em 0,41 |
| vinho-tinta | entre o preto e `primary01`, em 0,54 |
| tinte do vidro escuro | `primary01` a 50% |
| traço do vidro (claro / escuro) | `primary08` / `primary06` a 30% |

As posições foram medidas na rampa do primeiro cliente, onde reproduzem os hexes dele com erro zero na
terceira casa — e aplicadas a esta rampa dão o vinho DESTA marca. O blur (15), o card de vidro e os
raios são a gramática do Coreflow, iguais em qualquer produto.

A Styles ao lado mostra os valores que saíram dessa conta. Nenhum deles está escrito neste pacote.
''';

const _tipografia = r'''
## Inter, e ela viaja pelo tema

A Inter é fonte do Google, licença OFL (o arquivo `OFL.txt` acompanha os cinco pesos, 400 a 800, em
`assets/fonts/`). É a mesma família do primeiro cliente — a diferença não é a fonte, é **por onde ela
chega**.

Pelo veredito do pai (08/09, decisão 2), a família tipográfica é do produto e viaja pelo `ThemeData`:
`CoreflowTipografia.doAvo.copyWith(familia: 'packages/diletta_coreflow/Inter')`. Os treze degraus da
escala continuam sendo os do avô, sem `fontFamily` em nenhum — quem pinta a família é o tema, uma vez,
e todo texto do produto a herda. O catálogo prova isso no seletor de marca: a peça é a mesma, a fonte
chega com a marca.

O que a Diletta NÃO tem é uma escala própria. O primeiro cliente carrega treze degraus de marca porque
o app dele os pedia; este nasceu depois da decisão e usa a escala da linguagem como ela é.
''';

const _logo = r'''
## Dois arquivos, e as letras seguem o tema

| arquivo | o que é | como pinta |
|---|---|---|
| `diletta-mark.svg` | o símbolo | vermelho fixo — é a única cor do produto, gravada no arquivo |
| `diletta-lockup.svg` | símbolo + DILETTA SOLUTIONS | as dezesseis letras em `currentColor` |

É a convenção dos produtos desta casa: o símbolo é a marca e não muda; as letras são TEXTO e seguem o `fg` do
esquema — pretas no claro, brancas no escuro. Recortado do arquivo oficial da marca, com a proporção do
lockup declarada em `DilettaBrand.proporcaoDoLockup` pra o componente do avô reservar o espaço certo
antes de o SVG carregar.

Aprovado pela dona do produto em 09/09, junto com a cor.
''';
