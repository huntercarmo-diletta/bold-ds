# PEDIDO · O anel de foco do campo não se vê — `primaryTrack` reprova o piso de 3:1

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não para nós** — divergimos, com a razão escrita. Mas quem adotar o
  `<diletta-input>` como ele está entrega um campo cujo foco não se enxerga.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), alinhando o campo de
> seleção local ao `<diletta-input>`. A designer notou que os dois campos da mesma barra
> tinham anéis de cor diferente; ao medir para corrigir, o que apareceu foi isto.

## O caso

O `<diletta-input>` pinta o anel de foco em `primaryTrack`:

```js
.caixa:has(:focus-visible) { outline: 3px solid var(--diletta-primaryTrack); }
```

O `///` explica a escolha, e o argumento de DESENHO é bom:

> *«O ANEL DO CAMPO NAO E O ANEL DO BOTAO, e o Dart ja sabia disso: o `DilettaTappable`
> pinta foco em `primary` (saturado, medido contra `surface` nas oito marcas), mas o
> `DilettaInput` pinta o dele em `primaryTrack`»*

Anel saturado em volta de um campo de fato grita onde bastava indicar. O problema é que o
tom escolhido não indica nada.

## A medição

Piso: **WCAG 2.2 §1.4.11 — Non-text Contrast**, 3:1 para indicador de componente de
interface, medido contra as cores adjacentes.

| tema | anel | contra | razão | |
|---|---|---|--:|:-:|
| claro | `primaryTrack` `#ffb6cb` | `surface` `#ffffff` | **1,64:1** | ❌ |
| claro | `primaryTrack` `#ffb6cb` | `bg` `#f4f3f6` | **1,48:1** | ❌ |
| escuro | `primaryTrack` `#600627` | `surface` `#14151f` | **1,34:1** | ❌ |

Para comparação, o anel do BOTÃO passa nos dois modos — e a medição é do próprio
`DilettaFoco`, citada no `produto.css` do IB: `primary` dá **3,96:1** no claro e **4,42:1**
no escuro, contra 1,17 do `surfaceMuted` que a linguagem usava antes e que reprovava.

**A casa já rejeitou um tom por esse exato motivo, uma vez.** O `surfaceMuted` saiu do anel
porque media 1,17. O `primaryTrack` mede 1,64 — mesma família de defeito, com um número
pouco melhor.

## Por que importa mais num campo do que pareceria

Um anel de foco é a única coisa que diz, a quem navega por teclado, ONDE ele está. Num
formulário com vários campos, um anel invisível não é enfeite perdido: a pessoa deixa de
saber em qual campo vai digitar. É o caso em que o indicador é a informação inteira.

## O que fizemos aqui, e por que estamos contando

Divergimos: o webadmin usa **um anel só**, `primary` a 40%, para botão e campo — que é o
que o IB já fazia. A razão está escrita no `themes/light.css` de lá, com esta medição.

É divergência deliberada da linguagem, e queremos que ela apareça: **acessibilidade não
cede à régua de «a linguagem ganha sempre»**. Preferimos estar divergindo com o número na
mão a estar alinhados com um foco que ninguém vê.

## O pedido

Um tom de anel de campo que passe de 3:1 contra `surface` e `bg`, nos dois modos. O
argumento de desenho do `///` continua válido — o anel do campo pode ser mais discreto que
o do botão sem ser invisível; o que não dá é discrição que custa a indicação.

Se a casa preferir manter `primaryTrack` por coerência com o Dart, vale ao menos medir o
lado Flutter: se lá o anel também for esse tom, o defeito não é da instância web, é da
linguagem, e a correção rende nos dois lados.
