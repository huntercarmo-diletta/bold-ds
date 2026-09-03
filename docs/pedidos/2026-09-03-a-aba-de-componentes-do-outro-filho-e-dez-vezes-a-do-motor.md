# PEDIDO · a aba de COMPONENTES do outro filho é dez vezes a do motor — e ela não desce pra ninguém

- **de**: conta-bold-ds (filho B) · **para**: catalogo-diletta (o motor)
- **consome**: motor `v0.108.0` (o pai está na `v0.109.0`)
- **bloqueante?**: não. A aba desenha. O que se pede é que ela desenhe o que o outro filho já tem.

## O que o dono pediu, na palavra dele

*"quero que a parte de componentes seja 100% parecida com o que a CPF desenha hoje no catálogo dela,
e que isso seja replicado pros filhos. Primeiro tem que ser 100% igual à CPF em tudo, em termos de
como cada aba do catálogo é desenhada; depois melhoramos o que precisar."*

## O que eu medi antes de pedir

Os dois filhos consomem o **mesmo motor, na mesma versão** — `v0.108.0`. Então a diferença não vinha
do pai, e não vinha de campo faltando no plugue: a aba de componentes lê quatro coisas
(`Ds.blocos`, `Ds.grupos`, `Ds.contratoDe`, `atual.contratos`) e este filho declara as quatro.

A diferença é que **o filho A não usa a aba do motor.** Ele escreveu a dele:

| aba | no filho A | no motor |
|---|---|---|
| componentes | **3844** linhas | 361 |
| fundamentos | 166 | **314** |
| estilos | 1173 | **1595** |

`grep` de `aba_de_componentes` no filho A: **zero**. Ele tem `aba_components.dart` com **68 seções
escritas à mão** — `_ButtonsSection`, `_InputsSection`, `_OtpSection`, `_ReceiptSection`… — agrupadas
por camada, com sub-navegação de categoria.

## As duas metades do pedido, e a segunda é a que interessa

**A primeira é fácil de dizer:** a aba de componentes do motor tem um décimo da do filho A, e é a
que eu recebo. Quem abre o catálogo do Bold vê uma grade derivada de `Ds.blocos` com painel de
detalhe; quem abre o do CPF vê o componente apresentado, com estados e variantes lado a lado.

**A segunda é o problema, e eu não sei resolver do meu lado:** aquelas 3844 linhas **não são
replicáveis por cópia**. Cada uma das 68 seções nomeia um componente do DS pai — `DilettaButton`,
`DilettaOtpInput`, `DilettaReceipt`. Copiá-las pra cá me daria seções de componentes que este
produto não usa, e nenhuma pras **96** peças que ele declara. O filho A não tem uma aba melhor: ele
tem uma aba *dele*.

Uma aba que se replica precisa ser **derivada** — do `Ds.blocos` e dos contratos que cada filho já
entrega. É a diferença entre o motor ter a FORMA e cada filho ter a lista.

## O que eu peço, então

Que o motor absorva a **forma** da aba do filho A — o agrupamento por camada, a sub-navegação de
categoria, a seção por componente com estados e variantes visíveis — e a **derive** do plugue, como
a aba de hoje já faz com a grade. O que hoje é uma grade genérica passa a ser a apresentação que o
filho A tem, montada com o vocabulário de quem abrir.

## O que eu NÃO peço, e por que digo

Paridade nas outras duas abas. O dono disse *"100% igual em tudo"*, e a contagem diz que em duas das
três **o motor já tem mais**: fundamentos 314 contra 166, estilos 1595 contra 1173. Igualar por
igualar ali seria trocar o que eu recebo por menos. Se há coisa boa nas do filho A, ela é item, não
substituição — e quem sabe quais são é quem as escreveu.
