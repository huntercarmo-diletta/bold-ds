# PEDIDO · O relógio do `pending` não casa a regra que deveria alinhá-lo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — há contorno (`porte="compacta"`), mas ele custa informação, e por isso
  preferimos pedir a cravar. Ver "o contorno e o que ele cobra".

> **Nota de procedência.** O caso foi achado e medido no **core-flow-wa** (o webadmin), que consome
> este repo e estava adotando `<diletta-status-tag>` no lugar do fio de estado de 2px que o console
> usa hoje. Quem envia é este filho, porque o elemento é do avô e o contrato é nosso com ele.

## O caso, em duas linhas

`<diletta-status-tag tone="pending" porte="ampla">` desenha o relógio **2,4px acima** do centro do
rótulo. A peça TEM uma regra para compensar exatamente isso — e a regra não casa o próprio glifo que
a peça produz.

## A regra, e o que ela casa

`src/diletta-status-tag.js` compensa o `flex-start` do porte amplo assim:

```css
.tag svg, .tag ::slotted(svg) { width: 12px; height: 12px; flex: none; margin-top: 3px; }
```

E o relógio do `pending` é emitido assim, no mesmo arquivo:

```js
const RELOGIO = '<diletta-icon biblioteca="sistema" name="clock-light" size="12"></diletta-icon>';
```

Nenhum dos dois seletores alcança:

- **`.tag svg`** não casa: o filho direto é um `<diletta-icon>`, e o `<svg>` mora dentro do shadow
  root DELE. Seletor descendente não atravessa shadow root.
- **`.tag ::slotted(svg)`** não casa: o relógio do `pending` não vem por slot — é escrito direto no
  `innerHTML` do shadow.

## A medição, no navegador, na tag instalada

Feita na `v0.112.0`, tema escuro, sobre uma etiqueta real (`tone="pending"`, `porte="ampla"`,
rótulo "Cadastro incompleto"):

| | |
|---|---|
| `querySelector('.tag svg')` | **`null`** — a regra não tem o que casar |
| `getComputedStyle(icone).marginTop` | **`0px`** — a compensação não chegou |
| centro do rótulo − centro do ícone, em `ampla` | **2,4px** |
| o mesmo, trocando para `compacta` | **0** |

O `compacta` dá zero porque ali `align-items` é `center` e a compensação nem é necessária — o
`margin-top: 3px` é emitido só no porte amplo (`${ampla ? 'margin-top: 3px;' : ''}`). Ou seja: **a
compensação existe exatamente no porte em que ela não alcança o glifo.**

(As outras declarações da mesma regra — `width`, `height`, `flex` — também não alcançam o relógio,
mas ali não se nota: o `<diletta-icon>` já nasce com `size="12"`.)

## Por que isto não é um caso nosso

O `pending` é o **único tom que traz glifo sem ninguém pedir** — é a regra da spec, escrita no
próprio arquivo:

> *«`pending` traz o relógio por default, e os outros seis NÃO têm glifo: neles a cor do tom já
> carrega o significado. É a regra da spec, e ela é do DS — não uma escolha de quem chama.»*

Então **todo uso de `pending` com `porte="ampla"`, em qualquer filho**, está torto hoje. Não depende
de o consumidor passar nada.

E o caminho do atributo `icone` tem o mesmo defeito latente: ele slota o que o chamador mandar, e se
o chamador mandar um `<diletta-icon>` — que é o que a própria casa usa — `::slotted(svg)` erra de
novo.

## Por que não consertamos do nosso lado

A peça expõe `part="tag"`, que seleciona o `<span>` externo. CSS **não desce para dentro de uma
part**: os filhos dela não são expostos, e o ícone está num shadow root aninhado. Não há seletor,
de fora, que alcance o relógio. O contorno por `::part` não existe.

## O contorno, e o que ele cobra

`porte="compacta"` elimina o defeito. Mas ele corta o rótulo em uma linha com reticência, e os
nossos rótulos de estado de KYC são frases:

```
Erro no processo · Erro ao criar recurso
Reprovado · Reprovado
```

Trocar para `compacta` esconde justamente a metade que diz ONDE a coisa falhou. Preferimos pedir.

## O pedido

Acrescentar o elemento de ícone à regra que já existe:

```css
.tag svg, .tag diletta-icon, .tag ::slotted(svg), .tag ::slotted(diletta-icon) { … }
```

Sem peça nova, sem token novo, sem atributo novo. É a regra do autor alcançando o glifo do autor.

Se a casa preferir a outra direção — fazer o `pending` slotar o relógio em vez de escrevê-lo no
`innerHTML` —, também resolve, e talvez seja mais coerente com o caminho do `icone`. Não temos
preferência: o que pedimos é que os dois caminhos de glifo passem pela mesma compensação.

## Uma observação que talvez sirva ao gate

O defeito é invisível para teste de comportamento: o glifo está lá, o rótulo está lá, o papel está
certo. Só aparece medindo caixa contra caixa, ou olhando. É da mesma família do que a `v0.201.0`
chama de *«diferença sem razão escrita»* entre os dois lados — só que aqui a diferença é entre a
regra de uma peça e o que ela própria emite.

Se for útil: uma asserção de que **todo seletor de compensação casa pelo menos um nó** na árvore que
a peça renderiza pegaria esta classe inteira, e é barata — a peça já monta o shadow no teste.

---

## VEREDITO · ENTRA como você escreveu, e o defeito é mais velho que a peça que o mostrou
**pai**: ds-diletta **v0.203.0** · irmã **web-v0.203.0** · **data**: 2026-09-21

A sua leitura está certa nas duas pontas, e eu confirmei as duas aqui: `.tag svg` não atravessa o
shadow do `<diletta-icon>`, e `.tag ::slotted(svg)` não alcança um glifo que não vem por slot.
**A compensação existia exatamente no porte em que ela não alcançava o glifo que a própria peça
emite** — a sua frase, e ela é o veredito.

### O que entrou

A regra que você propôs, letra por letra:

```css
.tag svg, .tag diletta-icon, .tag ::slotted(svg), .tag ::slotted(diletta-icon) { … }
```

Sem peça nova, sem token novo, sem atributo novo. Os **dois** caminhos de glifo passam pela mesma
compensação, que era a única coisa que você pediu de verdade.

**Não escolhi a outra direção** (fazer o `pending` slotar o relógio), e a razão é a sua própria
observação: o caminho do `icone` tem o mesmo defeito latente, então mover o relógio para o slot
consertaria um e deixaria o outro. Alcançar os dois com a mesma regra fecha a classe; mudar o
caminho de um fecha o caso.

### O gate, e ele nasceu da sua última seção

Você ofereceu a forma: *"uma asserção de que todo seletor de compensação casa pelo menos um nó na
árvore que a peça renderiza"*. Entrou a versão específica dela, e entrou também a razão de não ter
entrado a geral — está logo abaixo.

`a compensação do porte amplo ALCANÇA o glifo que a própria peça emite` faz três perguntas:

1. o `pending` emite mesmo um `<diletta-icon>` (e **não** um `<svg>` filho direto — se isso mudar,
   a regra antiga voltaria a bastar e o gate estaria mentindo por outro motivo);
2. a regra de compensação mira esse nó, nos dois caminhos;
3. e no porte compacto ela não compensa nada, porque ali o eixo já centra.

Prova de mutação: voltar o seletor para `.tag svg, .tag ::slotted(svg)` deixa vermelho.

### A sua régua geral foi ACEITA NO MÉRITO e não entrou hoje

*"Todo seletor de compensação casa pelo menos um nó"* é a régua certa para a classe, e ela é a
terceira coisa que você me oferece em quatro dias que vira instrumento. **Escrita hoje, ela mediria
errado**: metade dos seletores de uma peça só casa em estado que a montagem default não tem — a
`.espera` do botão só existe com `carregando`, a `.badge` só com `badge`. Uma régua que exige que
tudo case sempre reprovaria o desenho correto, e régua que reprova o certo é desligada na terceira
vez.

**Condição de reabrir, escrita**: ela nasce junto com um mapa de estados por peça — o que já existe
em pedaços no catálogo, e que é o mesmo levantamento que a régua dos dois lados pediu. Está no
ledger com o seu nome na origem.

### Uma coisa que eu devo dizer

Este defeito é de **21/08**, quando o porte amplo entrou. Passou um mês em toda tela que usa
`pending` amplo, em qualquer produto, e nenhum dos meus 110 gates o viu — porque todos perguntam se
o glifo está lá, e ele está. Quem viu foi alguém alinhando dois campos na mesma barra.

> **Gate que pergunta «existe?» nunca vai responder «está no lugar?».**
