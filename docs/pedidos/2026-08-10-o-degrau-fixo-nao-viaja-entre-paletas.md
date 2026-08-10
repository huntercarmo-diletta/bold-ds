# Pedido · o DEGRAU não viaja entre paletas — o mesmo `warning03` dá 4,80 aí e 2,85 aqui

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.33.0 · pai v0.64.0
- **data**: 2026-08-10

## O que eu fiz, que foi o que você mandou

> *"`ref: v0.64.0`, e rode `violacoesDeConformidade(BoldPalette.bold)`. Ele mede o par da sua paleta e
> diz o número, sem eu ter que adivinhar."*

Rodei. **Três violações**, e elas dizem uma coisa só:

```
[trilho-do-medidor] normal/trilhoDeMedidor (light)      — 2,93:1   piso 3,0
[trilho-do-medidor] warning/trilhoDeMedidor (light)     — 2,85:1   piso 3,0
[trilho-do-medidor-invisivel] trilhoDeMedidor/bg (dark) — 1,08:1   piso 1,1
```

O escuro do par tinta×trilho **passou** — o seu conserto funcionou. O que sobrou é outra coisa.

## O achado: você aplicou a sua própria regra na MEDIÇÃO e não na DERIVAÇÃO

Você escreveu, ontem, a frase que fecha este pedido:

> *"eu publiquei 1,17 na minha paleta, você mediu 1,04 na sua, e **contraste não se herda de outra
> paleta**."*

E aí derivou os dois papéis novos por **degrau fixo**: `trilhoDeMedidor = neutral09` (claro) e
`surfaceEscura` (escuro), `warningGrafico = warning03` (claro). **Degrau fixo é exatamente o que não
viaja.** A prova é o mesmo número que você publicou:

| | referência | Bold |
|---|---|---|
| `warningGrafico` = `warning03` contra o trilho | **4,80** | **2,85** |

Mesmo degrau, mesma regra, mesmo piso — **1,95 de diferença**, porque as duas rampas não têm o mesmo
espaçamento. O `warning03` daqui (`#C47C0A`) é mais claro que o seu, e o `neutral09` daqui (`#ECECEC`)
é mais claro que o seu. Os dois erros andam na mesma direção e se somam.

## Onde eu ACHO que mora: derivar por CONTRASTE, não por degrau

O papel gráfico não é *"o degrau 03 da família"*. Ele é **o primeiro degrau da família que alcança 3:1
contra o trilho**. Isso é regra que viaja; número de degrau não é.

```dart
// hoje
warningGrafico: p.warning03,
// pedido
warningGrafico: primeiroQueAlcanca(3.0, contra: trilhoDeMedidor,
                                   na: [p.warning04, p.warning03, p.warning02]),
```

Medi na minha rampa qual degrau fecharia, pra o pedido vir com alvo e não só com queixa:

| papel | degrau de hoje | contraste aqui | primeiro degrau que fecha | contraste |
|---|---|---|---|---|
| `warningGrafico` | `warning03` | 2,85 | **`warning02`** | **5,54** |
| `normal` (a barra usa `primary`) | `primary04` | 2,93 | **`primary03`** | **6,79** |

E note o segundo: **o `normal` reprovou e ele nem tem papel gráfico.** A barra em estado normal usa
`s.primary` direto, então o mesmo problema existe fora do âmbar — só que sem papel pra consertar.

## O escuro é outro defeito, e a causa é diferente

`trilhoDeMedidor/bg (dark)` dá **1,08** contra o piso de 1,1: o trilho quase some contra a página. Aqui
não é rampa desalinhada — é que `surfaceEscura` (`#14151F`) é praticamente o `bg` deste app
(`#0A0B12`). Você escolheu a superfície escura porque na sua paleta ela destaca; na minha, ela **é** o
fundo.

O que fecha aqui, medido:

| trilho no escuro | vs página | `warning05` | `primary05` | `error05` |
|---|---|---|---|---|
| `surfaceEscura` (hoje) | **1,08** | 6,15 | 4,03 | 3,38 |
| **`neutral01`** (`#3D3939`) | **1,72** | 6,39 | 4,18 | 3,51 |

`neutral01` passa nos quatro. E ele não é escolha minha: é **o primeiro neutro que se separa da página**
— a mesma regra derivada, aplicada ao outro lado.

## O que eu NÃO estou pedindo

1. **mudar a minha rampa.** `#ECECEC` e `#C47C0A` são a identidade desta marca, e o veredito de ontem
   já disse que identidade não paga o piso — *"regra que nenhuma paleta válida passa é muro, não regra"*;
2. **`trackColor` por consumidor.** Continua valendo o que você aceitou de mim: contraste não é escolha
   de tela;
3. **um papel `primaryGrafico`** só porque o `normal` reprovou. Se a derivação por contraste entrar, ela
   resolve os dois sem papel novo — e papel especulativo é o que este repo recusa.

## O que eu já fiz do meu lado

A baseline **não** ficou vazia, e não escondi: o teste da conformidade lista **as três violações uma a
uma**, com este pedido no nome. Uma a uma, e não por contagem, porque baseline com número esconde troca
— uma sai, outra entra, e o total não se mexe.

## Como o pai vai saber que funcionou

`violacoesDeConformidade(BoldPalette.bold)` volta **vazia**, e a lista do meu teste some junto — sem eu
mexer num hex.
