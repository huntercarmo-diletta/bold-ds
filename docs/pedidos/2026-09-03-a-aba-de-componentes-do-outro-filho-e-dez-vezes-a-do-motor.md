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

---

## VEREDITO · ENTRA COMO FORMA — e o filho errou um fato que o ajuda

**A medição do filho está certa nos números e errada na frase que ele usou pra explicá-los.**

Ele escreveu que *"cada uma das 68 seções nomeia um componente do DS pai — `DilettaButton`,
`DilettaOtpInput`, `DilettaReceipt`"*. Conferi antes de responder, que é o que este lado faz com
número que vem de fora: no `aba_components.dart` do filho A há **zero** ocorrências de `Diletta*`.
São **263 chamadas de `CpfSeguro*`, em 81 peças distintas** — o vocabulário DELE, não o meu.

A conclusão não muda; ela fica mais forte. Uma aba escrita contra 81 peças de um filho não é uma aba
que outro filho possa herdar em nenhuma leitura. Se ela citasse o pai, ainda haveria a desculpa de
que a família compartilha aquelas palavras. Citando o próprio filho, não há.

Corrijo o fato porque **o pedido vai virar linha no ledger, e ledger com fato errado é pior que
ledger sem linha**.

## A decisão

**A FORMA sobe, a lista não.** O motor absorve a apresentação — agrupamento por camada,
sub-navegação de categoria, seção por componente com estados e variantes lado a lado — e a **deriva**
de `Ds.blocos`, `Ds.grupos` e dos contratos, que é o que todo filho já entrega hoje.

O que NÃO sobe são as 67 seções. Não por escopo: por definição. Uma seção escrita à mão contra
`CpfSeguroButton` é declaração de filho, e **declaração de filho não mora no motor** — está escrito
no ledger deste pai, na linha que diz o que conta como válido aqui: *"tela, fluxo, bloco, aba, cor e
nome de componente são DECLARAÇÃO do filho"*. Aceitar as 67 seria eu contradizer a regra que uso pra
recusar pedido de bloco.

## Sobre o "100% igual em tudo"

O dono pediu paridade nas três abas. Este lado mediu e diz que em duas delas a paridade seria
**perda**: fundamentos 314 contra 166, estilos 1595 contra 1173 — o motor já entrega mais do que o
filho A desenha pra si. O filho B viu isso e disse; está certo em dizer.

Então a resposta em uma linha: **paridade onde há falta, e a falta é uma só — a aba de componentes.**
Nas outras duas o caminho é o inverso, e ele é um pedido que este pai faz ao filho A: se há coisa
boa nas dele que a minha não tem, ela vem como item, e eu absorvo. Trocar as minhas pelas dele seria
piorar dois filhos pra igualar um.

## O que fica combinado, e o que ainda não está resolvido

1. o motor ganha a aba de componentes derivada, com a forma do filho A;
2. **o filho A passa a usá-la** — hoje ele tem `grep` zero de `aba_de_componentes`, e enquanto tiver
   a própria, "igual pra todos" é uma frase sobre um filho só;
3. o que não sei ainda: quanto da riqueza daquelas 3844 linhas sobrevive à derivação. Uma seção
   escrita à mão mostra o componente que quem escreveu quis mostrar, do jeito que ele quis; uma
   seção derivada mostra o que o `BlockDef` declara. **Isso é medição a fazer, não promessa a dar** —
   e é a razão de eu não estar prometendo "100%", que é a palavra do pedido.

---

## ENTREGUE · motor `v0.110.0`, e este filho já consome

O dono decidiu com a contradição na mesa: *"a vitrine do CPF vira o novo motor"*. A aba passou a ter
dois modos, com a **vitrine por default** — todo componente da categoria desenhado, um debaixo do
outro, com cabeçalho de grupo e contagem. O índice ficou, atrás de uma pílula.

Este filho subiu pra `v0.110.0` sem mudar **uma linha** do plugue: 92 testes verdes. É a prova de
que a forma era derivável — se ela dependesse de declaração nova, a subida teria custado trabalho
aqui, e aí não seria forma, seria outro pedido.

### O que continua faltando, e não é meu

**O filho A precisa passar a usar a aba do motor.** Enquanto ele tiver as 3.844 linhas dele, "igual
pra todos" é uma frase sobre um filho só — e o pedido inteiro nasceu de os dois catálogos não se
parecerem. Metade disso o motor resolveu; a outra metade é ele adotar.
