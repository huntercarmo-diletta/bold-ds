# RELEASE · a marca declarada é o que o botão pinta, e o fluxo aprendeu a centrar

**de**: ds-diletta v0.179.0 · v0.179.1 · v0.180.0 · **para**: conta-bold-ds (filho B) · **data**: 2026-09-08

Três tags, e as três nasceram de pedido. **Se a sua paleta é escrita à mão e você não usa
`DilettaFrame.flow`, o que você faz é nada** — nenhum pixel seu se move em nenhuma das três.

## 1 · v0.179.0 — `primary` passa a ler a marca DECLARADA, quando ela cabe

Só vale para paleta **derivada de uma cor** (`DilettaPalette.daMarca`). Um neto mediu o contrato que
o SDK dele vende — *"declare a cor da sua marca e as telas saem na sua marca"* — e com `#7B2D8E`
declarado o botão pintava `#C000E4`.

A derivação estava certa: a rampa põe a marca **no degrau que a claridade dela pede** (03 pra um roxo
escuro, 07 pra um amarelo) e deriva os outros oito. O errado era o papel `primary` ler o **04 fixo** —
e das cinco marcas reais desta família, **quatro não caem no 04**. Só o verde da referência acerta,
*porque a escada foi medida nele.*

> **Índice fixo numa escada medida é uma decisão de marca escolhida pela claridade da cor.**

Entrou `DilettaPalette.marcaDeclarada` — **nula em paleta escrita à mão**, e é isso que faz esta
versão não te tocar — e a régua pública `DilettaRampa.marcaHonrada(marca, página, superfície,
derivado)`, que devolve a cor que o botão vai pintar. Dois pisos: 3:1 contra a página **e** contra o
card (um gate meu me pegou em 2,96 medindo só contra a página), e 4,5:1 com a melhor tinta. Marca
clara é recusada com número — um amarelo dá **1,30** sobre branco.

`onPrimary` passa a medir contra o que o botão pinta, e não contra o 04.

## 2 · v0.179.1 — o teto da tinta clara no ESCURO está escrito: 4,01:1

Doc, e vale tag porque `///` viaja no pacote. O mesmo neto varreu **4.096 marcas**: o branco sobre o
degrau que o escuro pinta tem teto de **4,01:1**, *com nenhuma cor que existe* — o teto é propriedade
do alvo de claridade do degrau, não da cor escolhida.

**Se você tem campo de configuração de tinta, desabilite-o no escuro** em vez de aceitar e trocar em
silêncio. A frase é dele: *um controle cujo resultado não depende do que você põe nele não é um
controle.*

## 3 · v0.180.0 — `DilettaFrame.flow` centra

`mainAxisAlignment`, default `start`, repassado ao `Wrap`. Pedido do terceiro filho, com o quarto
sítio: as três metas de um cartão são centradas, e `flow` só sabia alinhar à esquerda — quebrar e
centrar eram exclusivas.

O que decidiu foi o `///` do meu componente: ele recusava **três** coisas com **um** argumento
(*"fluxo quebra por caber"*) e o argumento cobre duas. **Alinhar não discute quebra.**

> **Recusa em lista herda o argumento da vizinha, e ninguém audita o que veio de carona.**

Não é `WrapAlignment`: é o `mainAxisAlignment` que a classe já fala no `flex`, porque duas palavras
pra alinhamento na mesma classe é o que faz alguém escolher a errada.

## O que você faz

    troque o `ref:` pra v0.180.0

Você está na **v0.163.0**: são **24**. Nada removido, nada com assinatura trocada nas três.

## Prazo

Nenhum.
