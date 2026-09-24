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

---

## VEREDITO · caso 1 ENTRA · caso 2 JÁ EXISTE — e o degrau que você descreveu como inexistente é meu
**pai**: ds-diletta **v0.195.1** · **data**: 2026-09-16

| caso | veredito |
|---|---|
| 1 · as quatro curvas e os seis contextos como `--cps-*` | **ENTRA** |
| 2 · o degrau da paginação | **JÁ EXISTE** — é `labelMd`, e nenhum dos dois lados olhou pra ele |

### O que decidiu — caso 1

A sua frase, e ela é a tese inteira:

> *"A web recebe a camada que os componentes **não** consomem, e não recebe a que eles consomem."*

O `///` do `DilettaMotion` diz, com todas as letras, que **contexto** é o que as peças consomem, e é
justamente o que não atravessa. Emitir duração sem curva é emitir meia instrução: quem monta a
instância web acerta o tempo e inventa o movimento. E isso não é escada nova — é **transporte**, que
é a distinção que você mesmo fez em «O que NÃO pedimos». Entram as quatro `--cps-ease-*` e os seis
contextos como par duração+curva.

### O que eu achei indo implementar — e ele reescreve o seu diagnóstico

Você escreveu que a transcrição do IB *"acertou as curvas e errou os nomes"*. **Fui conferir contra o
SDK, e ela errou as duas coisas.** As quatro que a linguagem declara, lidas em
`flutter/packages/flutter/lib/src/animation/curves.dart`:

| camada | `Curves.*` | o valor real |
|---|---|---|
| `enter` | `easeOut` | `cubic-bezier(0.0, 0.0, 0.58, 1.0)` |
| `exit` | `easeIn` | `cubic-bezier(0.42, 0.0, 1.0, 1.0)` |
| `standard` | `easeInOut` | `cubic-bezier(0.42, 0.0, 0.58, 1.0)` |
| `emphasized` | `easeOutCubic` | `cubic-bezier(0.215, 0.61, 0.355, 1.0)` |

Os seus dois tokens são `cubic-bezier(0.33, 1, 0.68, 1)` e `cubic-bezier(0.65, 0, 0.35, 1)`. **Nenhum
dos dois é nenhuma das quatro** — são o `easeOutCubic` e o `easeInOutCubic` de uma tabela pública de
easings, que tem os mesmos nomes e outros números. Quem transcreveu não copiou do Dart: copiou de
onde os nomes batiam.

Isso **fortalece** o seu pedido em vez de enfraquecê-lo, e muda a classe do dano: transcrição à mão
não erra só o rótulo, ela **troca a fonte** quando a fonte não está emitida. O gate que você propõe
(mapa `--bold-* → --cps-*` com zero entradas sem destino) passa a valer mais que a paridade de nome.

### O que decidiu — caso 2, e o achado é constrangedor dos dois lados

Você escreveu que a sua paginação usa **12px, peso 500, tracking 0,5**, e que esse número *"cai entre
as minhas duas opções"* — acima do `caption` (12/400) e abaixo de um 12/700 que não existe.

**Ele não cai entre nada. Ele É um degrau meu**, e está publicado:

```dart
static const TextStyle labelMd =
    TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12, letterSpacing: 0.5);
```

12 · 500 · 16 · 0,5. O seu número, campo por campo. A catraca da `pagination` ficou de pé porque a
régua comparou a peça contra `caption` e contra um 12/700 imaginário, e **nenhum dos dois é o degrau
de um número clicável** — número clicável é rótulo de controle, e rótulo de controle é `label`.

Então a decisão, e ela não abre escada:

- os números da `pagination` passam a ler **`labelMd`**;
- o **ativo se distingue por PAPEL DE COR**, não por peso. `12/700` não entra na escada por um caso, e
  distinguir estado por cor é o que o resto da linguagem já faz em todo lugar;
- com isso a catraca desce de 1 pra 0, que era o seu pedido de decisão.

### O que eu recusei, e a condição de reabrir

- **Degrau 12/700.** Recusado: um caso não abre escada, e o caso deixou de existir quando o degrau
  certo apareceu. Reabre se um segundo filho medir peso 700 em 12px num sítio que não seja estado de
  item selecionado.
- **`font: inherit` da `pagination`.** Não é recusa, é dívida minha e ela entra junto: a peça é a
  única das 25 que ainda herda tipo da página do consumidor, e você adotando a peça em duas jornadas
  é o segundo sítio medido. Sai na mesma tag do caso 1.

### Os seis critérios

| critério | o que ele disse |
|---|---|
| **manutenção** | **pesou.** O que não é emitido é transcrito à mão, e transcrição à mão não tem gate. Os dois tokens de curva do IB são a prova viva, e eles estavam errados **em valor**, não só em nome |
| escalabilidade | a curva emitida serve toda instância web futura sem uma decisão nova. A segunda casa que adotar não repete a escolha sem saber que já foi feita, que é o risco que você declarou em «Se você disser não» |
| aplicação | o contexto é o que as peças consomem. Emitir duração sem curva entrega meia instrução, e quem monta acerta o tempo e inventa o movimento |
| aderência ao mercado | token de motion com duração **e** easing é o que Material, Carbon e Polaris publicam. Publicar só a duração é a exceção, não a regra |
| robustez | no caso 2, distinguir o ativo por **peso** exigiria um degrau que a escada não tem; distinguir por **papel de cor** usa o que a linguagem já garante e já mede contra piso de contraste |
| **arquitetura limpa** | **decidiu o caso 2.** Um caso não abre escada — e aqui nem precisava: o degrau existia, e o que faltava era a régua olhar para `label` em vez de `caption`. Degrau novo teria sido vocabulário criado para não ler o vocabulário |


### O que você faz

Espere a tag. Quando ela sair: apagar os dois tokens de curva do IB e apontar pro `--cps-ease-*`, e
adotar a `pagination` sem escolher degrau — ela passa a declarar o dela. As duas entradas sem destino
do seu mapa fecham, e o seu próprio critério de pronto (zero de 133) é o gate.
