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

### ⚠ PRECISADO em 22/09 — o papel é necessário, e não é suficiente

**O pedido segue de pé e segue bloqueante. O que muda é o que o veredito compra.**

A frase acima dá a entender que o `role="cell"` é o que trava a troca. Fomos medir o
contrato da família depois de escrever o pedido, e não é: com o papel entregue, a
`data-*` ainda não substitui o `WaDataTable` — e o que falta não é ARIA.

Medido na fonte instalada (`avo/src/diletta-data-*.js`, pela `web-v0.114.0`):

| | família `data-*` | `WaDataTable` |
|---|---|---|
| forma por largura | **zero** `ResizeObserver`, `@container`, `matchMedia` | troca de forma em 576px, e a expansão sobrevive à troca |
| estado de carga | **zero** `inert`, `aria-busy`, `carregando` | `inert` discriminado entre `carregando` e `bloqueando` |
| erro da lista | vazio **tem** (slot, `role="status"`); rota não publicada, sem permissão e genérico, não | os quatro, com prioridade declarada |

**O que a família TEM, e é o que quase nos enganou**: eixo de porte na `data-row`
(`tabela 54` · `painel 52` · `historico 64`, e o porte decide a MOLDURA, não só a altura),
porte `regular`/`compacto` no cabeçalho, o estado vazio acima, e tom por linha
(`aviso`/`erro`/`sucesso`). **A família resolve densidade por DECLARAÇÃO; nós resolvemos
forma por MEDIÇÃO.** São eixos diferentes, e é por isso que o porte não destrava a troca.

**E não estamos pedindo nenhuma das três.** A troca de forma passou pela régua da casa
antes de virar pergunta: **uma implementação, num app só** — o `formaDaTabela` é consumido
só pela `WaDataTable`, e o IB, medido hoje, tem **zero** `ResizeObserver` em produção e a
forma de registro como estado NATURAL, não como transformação. Um app não é vocabulário.
Volta a ser pergunta quando um segundo produto da família precisar da mesma troca.

*Escrito aqui porque veredito entregue esperando adoção que não vem ensina errado o que o
veredito compra.*

---

## VEREDITO do pai — 2026-09-22 · `v0.207.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`) para a resposta morar junto da pergunta.

**ENTRA — defeito meu, uma linha, e é o mais grave dos oito desta série.**

### O que decidiu
A sua frase: *«Acessibilidade é a coisa que não cede à régua de a linguagem ganha sempre.»* A régua
realmente perde aqui, e não por concessão — **sair de um `<table>` nativo completo para uma tabela
ARIA inválida é piorar por adoção**, e uma linguagem que obriga a isso está cobrando o preço errado.

Conferi as cinco peças na fonte e o seu número está exato: quatro declaram papel, a célula tem zero
`role=`, e ninguém supre por fora.

Das suas duas observações, as duas ficam de pé: **`gridcell` não serve** (a lista declara `table`,
não `grid`) e o **`rowheader` da primeira coluna é eixo novo**, fora deste pedido. Você o escreveu
*«para não virar um segundo pedido em uma semana»* — é a disciplina que eu queria ver, e o eixo fica
registrado sem consumir este veredito.

### O que eu achei indo implementar
**Pior que o pedido: a família tem cinco peças, quatro sabem o papel delas, e nenhum gate meu
pergunta o papel de nenhuma.** A que faltava não caiu em régua nenhuma porque régua nenhuma existe —
o papel viajou por hábito em quatro peças, e o hábito falhou na quinta. Entra junto a régua: toda
peça cujo contrato declara papel ARIA tem de emiti-lo, medido no elemento montado.

**E o seu `⚠ PRECISADO` de 22/09 vale mais que o conserto.** Você mediu o contrato depois de
escrever o pedido e avisou que o papel entregue **não destrava a troca** — forma por largura, estado
de carga e erro de rota continuam faltando. A frase que fica:

> *Veredito entregue esperando adoção que não vem ensina errado o que o veredito compra.*

Vou anotá-la como régua desta casa. E a decisão de **não** pedir as três está certa pela razão que
você deu: uma implementação, num app só, não é vocabulário — o `formaDaTabela` é consumido só pela
`WaDataTable`, e o IB tem zero `ResizeObserver`. Volta a ser pergunta no segundo produto.

### O que eu recusei, e a condição de reabrir
- **`rowheader` na primeira célula** — fora deste pedido, por sua própria decisão. Reabre quando
  você trouxer o eixo (`cabecaDeLinha` ou reuso de `conteudo`) com os sítios medidos;
- **troca de forma por largura, `aria-busy`/`inert` e os quatro estados de erro** — você não pediu
  e eu não entrego. **Condição escrita: um segundo produto da família precisando da mesma troca.**

### Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | = | uma linha; não há manutenção nova |
| escalabilidade | ↑ | a régua de papel que vai junto cobre a sexta peça da família antes de ela existir |
| aplicação | ↑ | destrava 49 usos parados, e 502 instâncias declaradas no outro consumidor |
| aderência ao mercado | ↑ | *required owned elements* é a especificação ARIA, não gosto meu |
| robustez | ↑ | a ausência passa a falhar alto em vez de desenhar certo e mentir na árvore |
| arquitetura limpa e simples | = | nenhuma peça nova, nenhum eixo novo |

### O que você faz
Quando a tag sair: suba o `ref:` e faça a troca do `WaDataTable` **medindo antes** — o papel é
necessário e, pelo seu próprio levantamento, não é suficiente. Se a troca parar de novo, o que
faltar vira pedido com a medição do segundo produto junto. E você está certo em não remendar com
`role="cell"` por fora: o papel é do elemento.
