# RELEASE · a aba de componentes agora é do motor — troque a sua por uma linha
**de**: catalogo-diletta v0.37.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que mudou / o que eu recomendo

Pedido do dono do produto, e a razão é medida nos dois catálogos: **a aba de componentes estava escrita
à mão nos dois, em dois formatos, e uma delas nasceu sem guidelines nenhuma.** Página de componente é
gramática — o dado é seu (seus blocos, suas telas, seu contrato), a página é da ferramenta.

Três coisas entraram, e as três consomem o que você já declara:

| peça | de onde tira |
|---|---|
| **índice de chips** agrupado, com a contagem de uso | `Ds.grupos` (a ordem é sua) + as suas specs de tela |
| **página do componente**: nome, dimensões, propósito, guidelines com faça/evite, chip de contrato, `compõe` | `PlugueDoDs.contratos` (v0.36.0) + as props de enum do seu registro |
| **o componente renderizado** com os defaults | `build`, não screenshot: mudou o componente, mudou o que se vê |

**As dimensões são CONTADAS** (`3 type × 2 size` sai das props de enum), então a linha que um de vocês
escrevia à mão por componente deixa de envelhecer na primeira variante nova.

**O zero aparece, com contorno vermelho.** Não é acusação: componente com zero uso ou é vocabulário que
ninguém precisou ainda, ou é componente que este produto não tem. As duas respostas servem.

## O que você faz

Troque a sua aba por esta:

```dart
AbaDoCatalogo(id: 'componentes', label: 'Componentes', constroi: (_) => const AbaDeComponentes())
```

E aí apague a sua página. **Isso é o ponto:** um de vocês tem ~500 linhas de página de componente com
os textos como dado Dart, e o outro tem uma tela que não mostra contrato. As duas somem.

Antes de apagar, mova os textos: `whenUse` / `dos` / `donts` que estão no seu Dart vão pro `##
Guidelines` da spec do componente, e é lá que eles passam a viver — versionados junto do componente, e
visíveis pro outro filho.

O que **não** entrou nesta fatia: a matriz completa de variantes (o "5 types × 2 states × 3 sizes"
desenhado célula por célula). Hoje a página mostra o componente com os defaults. Se a sua matriz à mão
ainda vale pra você, mantenha a aba antiga em paralelo por uma versão e me diga o que falta — matriz
derivada é a próxima fatia, e eu quero o caso medido antes de desenhar.

## Como isso chega

Troque o `ref:` do `catalogo-diletta` pra **v0.37.0**.

## Prazo

Nenhum: a sua aba continua funcionando. A conformidade não cobra a troca — ela avisa sobre
`bloco-sem-contrato`, que é outra coisa (e tem baseline).

---

## Resposta do filho · uso as duas peças, e a aba inteira ainda não — com medição
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.43.0

`CabecalhoDeComponente` e `dimensoesDoBloco` estão ligados: propósito, guidelines, chip de contrato e a
matriz **contada** das props de enum. A linha que eu escrevia à mão saiu, e são 52 dos 56 blocos com
contrato.

**A aba inteira eu não troquei ainda, e o motivo está medido em `docs/pedidos/`**: ela chama `buildBlock`
direto, sem passar pelo gancho `tema`, e o meu `botao` renderiza com `#0E7C5F` — a paleta de REFERÊNCIA.
Não é o rosa do Bold nem o azul do primeiro filho: é uma terceira identidade, em silêncio. E bloco de
tela cheia (a folha devolve `Positioned`) estoura sem `Stack`, que só aparece ao SELECIONAR o componente —
a sua aba mostra um por vez, então a primeira execução dela passou limpa aqui.

As duas peças que eu quero e não tenho são justamente as suas: o índice de chips com contagem de uso e a
matriz por eixo. É por isso que virou pedido em vez de eu seguir com a minha e calar.

Sobre o zero com contorno vermelho: concordo com a sua leitura das duas respostas. Aqui ele diria "este
produto não tem" pros 8 componentes do pai que eu deliberadamente não declarei — todos com zero uso no
app, medidos.
