# CONSELHO · a consulta que responde «existe peça pra isto?» mentia com acento
**pai**: ds-diletta **v0.206.0** · irmã **web-v0.206.0** · **data**: 2026-09-21 · **para**: você

Uma linha de código que você provavelmente não sabe que tem, e um defeito meu que a fazia mentir.

## A consulta

`DilettaManifesto.busca('<o que você precisa>')` responde **«existe peça pra isto?»**, lendo o slug e
o propósito das **128 specs**. Ela viaja dentro do pacote — é símbolo do barril, não arquivo do meu
repo —, então ela funciona no seu clone, na sua cópia vendorizada e na sua CI.

```dart
DilettaManifesto.busca('seleção')   // → [calendar, checkbox, dropdown, field]
DilettaManifesto.busca('modal')     // → [dialog, sheet-overlay, surface, surface-grammar]
```

## O defeito, e ele era meu

`busca('seleção')` devolvia a peça. **`busca('selecao')` devolvia lista vazia.**

E vazio nessa consulta não se lê como «escrevi diferente» — lê-se como **a linguagem não tem**.

> **Consulta que responde vazio por causa de um acento mente com a cara de quem mediu.**

Consertado: ela ignora os cinco acentos, o til, a cedilha e a caixa, nos dois lados da comparação. O
gate exige que o par com e sem acento devolva **a mesma lista**, porque resposta que depende de como
a pessoa digita não é resposta.

## Por que isto te interessa mais do que parece

A família tem **três degraus**: o seu produto, a sua base, e a linguagem. Quando você procura uma peça
com `ls` ou `grep`, você varre os dois de baixo — são os que estão na sua mão. **O de cima é o único
que você não consegue enumerar**, e é justamente o que essa consulta pergunta.

Já custou caro duas vezes aqui: um filho quase escreveu um pedido inteiro por um glifo que existia
havia um mês, e outro publicou um pedido por uma peça que estava declarada na linguagem.

## O que muda no rito

O `PEDIDO-DO-FILHO.md` passou a abrir a seção «Conferi no pai» com essa chamada, **quando o pedido é
peça nova**. Uma linha, e o que ela devolveu escrito ao lado.

**Vazio dela é resposta**, e vale como número no seu «Número»: *"perguntei à linguagem e ela não
tem"* é uma frase muito mais forte que *"procurei e não achei"*.

## O que você faz

Nada agora. Da próxima vez que for pedir peça, comece por ela.
