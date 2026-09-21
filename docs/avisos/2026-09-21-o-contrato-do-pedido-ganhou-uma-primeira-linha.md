# CONTRATO · pedido de peça nova abre com uma pergunta ao degrau de cima — e o instrumento estava quebrado
**avô**: ds-diletta **v0.206.0** · irmã **web-v0.206.0** · **data**: 2026-09-21 · **para**: nós

Nenhuma peça desenha diferente. O que mudou é **como se pede**, e o motivo fomos nós.

## A regra, em uma linha

Pedido de **peça nova** passa a abrir a seção «Conferi no pai» com isto:

```dart
DilettaManifesto.busca('<o que você precisa>')   // e escreva aqui o que ela devolveu
```

Ela viaja **dentro do pacote** — não é arquivo do repo dele, é símbolo exportado pelo barril —,
e responde *«existe peça pra isto?»* lendo o slug e o propósito das **128 specs**.

**Vazio dela é resposta**, e vale como número no «Número» do pedido.

## Por que ela existe, e a razão somos nós

No pedido do campo de seleção, de 21/09, nós escrevemos: *«não existe campo de seleção na
família — nem no Dart, nem na web»*. Medimos os **25 elementos web** e as **61 peças do
`coreflow`**, não achamos nada, e concluímos ausência.

A peça existia. `DilettaDropdown`, na **linguagem**, declarada `destino: ambos`.

Nas palavras dele:

> A família tem três degraus, e varrer o que está à mão responde por um deles. O de baixo é o
> seu produto, o do meio é a sua base, e a linguagem é a de cima. `busca` pergunta ao de cima,
> que é o único que você não pode enumerar com `ls`.

**Nós varremos dois degraus e escrevemos sobre três.** O `ls` alcança o nosso produto e alcança o
pai, porque os dois são pasta no disco. A linguagem chega como pacote instalado, e por isso ela é
a que sai da conta sem ninguém notar que saiu.

## E o instrumento estava quebrado — o que muda a lição

```
busca('seleção')   → design-system-dropdown
busca('selecao')   → []
```

**Mesmo se tivéssemos chamado, poderíamos ter saído com a mesma frase errada.** Consertado na
`v0.206.0`: ela ignora acento e caixa, com prova de mutação. Ele nomeou a classe, e é a terceira
aparição dela na casa dele:

> Zero achados sobre a pergunta errada é ausência de instrumento, não ausência de coisa.

Isso não nos desculpa — nós não chamamos —, mas muda o que aprender. **Não basta usar o
instrumento: uma resposta vazia precisa ser tratada como pergunta, e não como fato.** É irmã da
nossa retratação do mesmo dia, a dos cinco desenhos, onde um número medido com duas variáveis
amarradas não falava de nenhuma das duas.

### E a que nós conseguimos chamar HOJE ainda é a quebrada

Conferido nas tags, no arquivo dele:

```
v0.204.0   busca QUEBRA com acento     ← o nosso pino
v0.205.0   busca QUEBRA com acento
v0.206.0   busca IGNORA acento
```

O `pubspec.yaml` deste repo prende o avô na **`v0.204.0`**. Até subirmos o pino, chamar a `busca`
com acento é o único jeito de ela responder, e um vazio dela **não vale como número** — vale como
«pergunte de novo sem acento». Subir o pino é o que torna a regra segura de seguir, e é trabalho
de uma change nossa, não dele.

## O que veio junto

- **`v0.205.0`** — o `DilettaDropdown` e o `DilettaDialog` atravessaram para a web. As duas peças
  do nosso pedido, entregues.
- **`v0.207.0`** — o botão ganhou `rotulo-acessivel`. Era o nosso bloqueio de adoção, e caiu.
- **RETRATAÇÃO dele**: o `DilettaSheetOverlay` **tem** spec. O que falta é o campo `destino`, e
  falta em **29 das 128** — a maioria primitiva de layout. O nosso índice repetia a ausência como
  fato, e foi corrigido. Ele mediu no arquivo **publicado** e concluiu sobre a **fonte**, e nomeou
  a classe como a mesma que nós retratamos no dia anterior.

## O que fazer com isto

A regra entrou no cabeçalho do [`PEDIDOS.md`](../PEDIDOS.md), que é onde ela vai ser lida na hora
de escrever um pedido — um aviso arquivado não segura a mão de ninguém.
