# PEDIDO · O que a instância web precisa e a derivação do Dart não carrega

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não.** Os dois casos têm contorno, e os dois contornos são
  literal cravado — que é o que esta casa combate. Pedimos antes de cravar.

## A frase

A instância web recebe o que a derivação do Dart **consegue carregar**. O que a web precisa e o Dart
não tem em forma de VALOR fica sem destino, e a peça inventa ou herda.

Você já nomeou a raiz uma vez, no `CHANGELOG` da `v0.194.3`, sobre a paginação:

> *«`tipos` é derivado do Dart, e **peça que só existe na web não tinha onde declarar**»*

Este pedido é essa frase aplicada aos dois casos que sobraram — um de cada lado da causa.

## Caso 1 · As CURVAS de movimento não atravessam

O `DilettaMotion` tem três camadas, e o `///` dele diz qual delas os componentes consomem:

| camada | o quê | atravessa? |
|---|---|---|
| duração | 7 degraus (`micro` 120 … `shimmer` 1500) | **sim** — `--cps-duration-*` |
| curva | 4 semânticas (`enter`, `exit`, `standard`, `emphasized`) | **não** |
| contexto | 6 pares duração+curva (`fade`, `sheet`, `page`, `toast`, `control`, `emphasis`) | **não** |

E o `///` é explícito: *«**contexto** — `DilettaMotionSpec` que amarra duração+curva por caso de
uso.
**É o que os componentes consomem**»*.

Então a web recebe a camada que os componentes **não** consomem, e não recebe a que eles consomem.

**A causa é de forma, não de decisão**: duração é `Duration(150)`, que vira `150ms`. Curva é
`Curves.easeOut`, que é um objeto — não tem número para emitir. O emissor não tinha o que carregar.

### O número que mostra o preço

O IB tem dois tokens de curva, copiados à mão do app:

| no IB | valor | é, na sua linguagem |
|---|---|---|
| `--bold-ease-standard` | `cubic-bezier(0.33, 1, 0.68, 1)` | o seu **`enter`** (easeOut) |
| `--bold-ease-emphasized` | `cubic-bezier(0.65, 0, 0.35, 1)` | o seu **`standard`** (easeInOut) |

**Os dois nomes estão trocados**, e ninguém tinha como ver: copiar à mão acertou as curvas e errou
os nomes. É a mesma classe dos 195 tokens de cor transcritos sem gate que já lhe contamos.

### O que pedimos

As **quatro curvas** como `--cps-ease-*`, com o `cubic-bezier` equivalente de cada `Curves.*`. E, se
couber, os **seis contextos** como par — `--cps-motion-sheet-duration` e `--cps-motion-sheet-ease`
—,
porque é o contexto que a sua própria peça consome, e emitir só as pontas deixa o consumidor web
refazendo a amarração que você já fez.

## Caso 2 · A paginação é web-nativa e não tem degrau em lugar nenhum

A `v0.194.3` deixou a `pagination` sob catraca, e a razão está escrita: o número dela é
`12/400/16/0`
e o ativo `12/700/16/0`; `caption` erra 0,2px de tracking e não há degrau de 12/700 na escada.

**Nós somos o consumidor que faltava.** Decisão de produto tomada hoje: o IB adota a
`diletta-pagination` no lugar da peça local, em 2 jornadas. Não é troca de implementação — é troca
de
desenho, e está declarada como exceção na nossa proposta:

| | a nossa, hoje | a sua |
|---|---|---|
| forma | `← Anterior · "Página 3 de 12" · Próxima →` | `← 1 2 3 … 12 →` |
| clicável | duas setas | **cada número** |
| estado ativo | não existe | o número da página atual |

Adotamos porque a sua é melhor para o caso: uma listagem de lançamentos ou beneficiários tem dezenas
de páginas, e chegar à sétima hoje custa seis cliques. E porque a forma é a que a web pede — o `///`
da peça diz que ela é **web-nativa**: *«no celular a mesma necessidade se resolve por rolagem
infinita, que é outra gramática. Não é falta de paridade»*.

### O que herdamos ao adotar

A `pagination` é **a única das 25 que ainda sai com `font: inherit`** — as outras seis a `v0.194.2`
consertou. Então os números vão pegar o tamanho **e o peso da nossa página** em vez do que a
linguagem declara. É o defeito que você mediu e descreveu, agora com uma casa dentro dele.

### O nosso número, que é o que faltava para decidir

A nossa paginação escreve em **`labelMd` — 12px, peso 500**, tracking 0,5. Ele cai **entre** as suas
duas opções: acima do `caption` (12/400) e abaixo do degrau de 12/700 que não existe.

Não pedimos um degrau novo — a régua desta casa é sua, e um caso não abre escada. Pedimos a
**decisão**, com o nosso número na mesa: se `caption` com o ativo distinguido por cor resolve, nós
adotamos assim e a catraca desce de 1 para 0.

## O que NÃO pedimos

- **Não pedimos token novo por conveniência.** Os dois casos são coisa que a sua linguagem já
decidiu
  e que só não tem como viajar — não é escada nova, é transporte.
- **Não pedimos a paginação no Dart.** Ela é web-nativa por decisão sua, e concordamos.

## Se você disser não

Cravamos: as curvas como `cubic-bezier` literal com o nome da sua camada no comentário, e a
paginação com o degrau que escolhermos, declarado no nosso mapa. Os dois viram dívida nossa, escrita
e medida — e a próxima casa que adotar a web repete a mesma escolha sem saber que já foi feita.

## Como saber que funcionou

O nosso mapa `--bold-* → --cps-*` tem hoje **duas entradas sem destino de linguagem**, das 133. Com
este pedido atendido, ficam zero.
