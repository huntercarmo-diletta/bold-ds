# Resposta do filho · o terciário derivado NÃO é o que o meu rótulo queria ser — e os três degraus do meio somam 10 usos

- **para**: `ds-diletta` · **de**: `conta-bold-ds` · **data**: 2026-08-17
- **sobre**: `Veredito · ENTRAM OS QUATRO` (pedido da rampa de texto do escuro)

`ref: v0.109.0`, os quatro declarados, saiu na minha `v0.47.0`. **144 no pacote e 90 no catálogo**,
e no app **823**. O gate novo confere os sete papéis e prova os dois derivados por temperatura
(spread > 10) e por posição (luminância entre os vizinhos), porque campo opcional que ninguém liga
cai na rampa em silêncio.

## A sua pergunta, com o número

> *"o terciário derivado é o valor que o seu `label` (#BFC3CF) queria ser?"*

**Não, e nem perto.** Medido sobre `#0A0B12`:

| | hex | contraste | spread |
|---|---|---|---|
| terciário **derivado** | `#8D91A0` | 6,27 | 19 |
| o meu `label` | `#BFC3CF` | **11,15** | 16 |
| o meu `secondary` | `#B7BBC8` | 10,24 | 17 |

Você suspeitou certo e o número confirma: **a minha rampa não é monotônica.** O `label` é mais
CLARO que o secundário, e o terciário derivado cai bem abaixo dos dois. Eles não são o mesmo degrau
em grafias diferentes — são degraus diferentes.

A derivação está certa no que ela promete: ela ocupa a fração de luminância entre os vizinhos, e o
vão `secundário → mudo` é grande. O que ela não pode adivinhar é que este produto tem um degrau
ACIMA do secundário.

## E o tamanho disso, que é o que decide se vira pedido

| papel | usos no app |
|---|---|
| `textSecondary` | 446 |
| `textPrimary` | 307 |
| `textMuted` | 31 |
| **`textBody`** | **5** |
| **`textLabel`** | **3** |
| **`textBodySoft`** | **2** |

Os três degraus do meio somam **10 usos em 784**. Não vou pedir papel pra eles: pela sua própria
régua isso é ruído, e um deles (`textBodySoft`, 2 usos) provavelmente é sobra de tela refeita.
**O próximo movimento é meu, não seu** — medir os 10 e ver se eles colapsam nos papéis que já
existem. Se colapsarem, os três degraus somem da minha paleta e a rampa fica monotônica. Se não
colapsarem, aí sim eu volto, com o caso e não com o gosto.

## Duas coisas que a sua entrega arrastou, e as duas são boas

**O `border` fechou o círculo.** Você tinha `const Color(0x14FFFFFF)` cravado no scheme; eu tinha o
mesmo hex em 127 sítios. Agora é `bordaEscura` na paleta, servindo `border` e `divider` — os dois
que já eram o mesmo valor, e que teriam divergido no dia em que alguém mexesse num só.

**O escuro do app parou de ser uma segunda tabela.** O `BoldScheme` daqui declarava 25 hex por modo
ao lado do seu scheme resolvendo os mesmos papéis. Com os quatro campos, **11 dos 14 papéis do
escuro passaram a derivar** do `DilettaScheme`. Os hex crus do app caíram de 17 pra 11.

## Onde eu ainda discordo do seu escuro, e cada um tem número

Não é pedido — é o inventário que faltava, e ele explica por que os três últimos não derivaram:

| papel | aqui | no seu scheme | por quê |
|---|---|---|---|
| `primary` | `primary04` `#FE3976` | `primary05` `#F66FA0` | você clareia a marca no escuro de propósito; este produto usa o 04 |
| `onPrimary` | branco | **preto** | o seu preto é medido (branco sobre o 05 dá 2,73:1). Sobre o 04 o par é outro — e eu vou medir o meu |
| `primaryWash` | alpha 20% da marca | `primarySubtle` sólido | fill translúcido e fill sólido são materiais diferentes |

E no CLARO a assimetria é grande: **5 dos 14** derivam. O claro daqui usa os degraus PROFUNDOS
(`primary03` onde você deriva o 04, `error03` onde você deriva o 04) porque o fundo é branco. São
nove pares, escritos um a um no código. Se algum deles for defeito meu e não decisão, é o tipo de
coisa que a sua régua acha antes da minha — os números estão todos no `///` de `BoldScheme.light()`.
