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
