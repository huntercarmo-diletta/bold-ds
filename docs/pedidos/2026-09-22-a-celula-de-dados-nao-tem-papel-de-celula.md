# PEDIDO · A `data-cell` não declara `role="cell"` — e a tabela ARIA fica sem células

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **sim** — e é o único pedido nosso desta série que bloqueia de verdade.
  A adoção da família `data-*` no webadmin está **parada** por causa dele: trocar hoje
  seria sair de um `<table>` nativo e completo para uma tabela ARIA com a estrutura
  inválida. Acessibilidade é a coisa que não cede à régua de «a linguagem ganha sempre».

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), preparando a troca do
> `WaDataTable` (49 usos, 475 linhas de CSS) pela família `data-*`. A designer pediu a
> troca; ao medir o contrato antes de fazer, apareceu isto, e a troca não saiu.

## O caso, em uma linha

Quatro das cinco peças da família declaram o papel ARIA delas. A célula não.

## Medido, nas três camadas

Na fonte dos elementos instalados:

```
diletta-data-list.js           role="table"         ✅   (+ role="rowgroup")
diletta-data-header-row.js     role="row"           ✅
diletta-data-column-header.js  role="columnheader"  ✅   (+ aria-sort)
diletta-data-row.js            role="row"           ✅
diletta-data-cell.js           role=                ❌   ZERO ocorrências
```

E **ninguém supre por fora**: a `data-row` não tem um único `setAttribute`, a `data-list`
também não. Montado no navegador, com o pacote instalado, o shadow da célula sai assim:

```html
<div class="celula " part="celula"><span class="principal">Ana Souza</span></div>
```

Sem papel, sem `aria-*`, nada.

## Por que isso quebra a tabela inteira, e não só a célula

`role="table"` e `role="row"` têm **elementos filhos obrigatórios** (*required owned
elements*): os filhos de uma `row` precisam ser `cell`, `columnheader` ou `rowheader`. Uma
`row` cujos filhos são `div` genéricos não é uma linha de tabela — é um contêiner com
texto dentro.

O efeito para quem usa leitor de tela: perde-se o anúncio de posição («coluna 2 de 5»), a
associação entre a célula e o cabeçalho da coluna dela, e a navegação por célula. O
cabeçalho continua sendo anunciado como `columnheader`, o que piora a leitura em vez de
melhorar — a tabela promete estrutura e não entrega.

## Por que este é o pedido mais grave dos quatro que abrimos esta semana

**A `data-cell` é, segundo a própria spec, a peça mais usada do BackOffice: 502 instâncias
visíveis, 1.150 usos.** Se a instância web está em produção em alguma dessas telas, são
502 células sem papel — e o defeito não aparece em teste nenhum, porque a tela desenha
certo. Só aparece para quem depende do leitor.

Não medimos o BackOffice; não temos acesso a ele. O que sabemos é que a spec o cita como
consumidor e que o elemento web não declara o papel.

## O conserto é uma linha

```js
<div class="celula" part="celula" role="cell">
```

Duas observações de quem foi montar:

1. **`gridcell` não serve aqui.** A `data-list` declara `role="table"`, não `grid`, e
   `cell` é o papel certo para tabela estática. Se um dia a lista virar `grid` (células
   focáveis, navegação por seta), aí o papel muda junto — mas é outra peça.
2. **A primeira célula de cada linha talvez queira `rowheader`.** No nosso caso a coluna
   1 é sempre o nome do registro, que é o cabeçalho de linha natural. Isso é eixo novo
   (`cabecaDeLinha`, ou reuso de `conteudo`), e não faz parte deste pedido — o pedido é
   só o papel que falta. Fica dito para não virar um segundo pedido em uma semana.

## O que o consumidor está fazendo enquanto isso

**Parando, e é uma decisão de desenho que custa caro.** O `WaDataTable` continua sendo um
`<table>` nativo, com `<caption>` e `scope="col"` — semântica que o navegador dá de graça
e que a família ARIA teria de reproduzir. São 49 usos e 475 linhas de CSS que não vão
sumir enquanto isso.

Nós NÃO vamos remendar com `role="cell"` por fora: o papel é do elemento, e escrevê-lo no
consumidor é a cópia que a adoção inteira existiu para apagar.
