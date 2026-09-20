# PEDIDO · O `render()` das peças web derruba o foco — e isso não é uma peça, são oito

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **sim**, e de um jeito novo: **já está na minha tela.** Eu adotei o
  `<diletta-pagination>` hoje, e ela perde o foco a cada clique. Não é um pedido para adotar; é um
  pedido sobre o que eu já adotei.
- **irmão**: [o campo apaga o que a pessoa digitou](2026-09-17-o-campo-apaga-o-que-a-pessoa-digitou.md) — **aquele pedido é um caso deste.** Mandei os dois porque o conserto de lá serve de forma para cá, mas se você for resolver um só, resolva este.

## Falta

O foco não sobrevive a nenhuma interação, porque o `render()` refaz o `innerHTML` e apaga o nó focado.

## Número

Três peças medidas no navegador, com **clique e tecla de verdade** — não evento despachado por
script, que é justamente o que esconde este defeito.

**`<diletta-pagination>`** — a que eu já uso:

| | |
|---|---|
| cliquei na página 2 | `atual` vira `"2"` ✅ |
| | `document.activeElement` vira **`<body>`** ❌ |

**`<diletta-tabs>`**:

| | |
|---|---|
| cliquei em "Extrato" | seleciona, e o foco vai para `<body>` |
| **ArrowRight, três vezes seguidas** | **nada**: `selecionada` fica em `0`, nenhum evento `mudou` |

A segunda linha é a que dói: **a navegação por seta existe e não roda.** Ela está escrita, com um
`///` seu explicando que a seta pula as desligadas — mas o `keydown` é escutado no elemento, e
depois da primeira interação o foco está no `<body>`. A tecla nunca mais chega.

E aqui vai um aviso de método que me custou uma hora: **despachando `KeyboardEvent` por script no
elemento, tudo passa.** O evento chega porque eu o entreguei à mão. Foi só teclando de verdade que
as setas ficaram mudas. Se a sua suíte testa teclado por `dispatchEvent`, ela está verde sobre isto.

**`<diletta-input>`** — o irmão deste pedido: mesmo mecanismo, sintoma diferente. O nó apagado leva
junto o que a pessoa digitou.

**E são oito.** Varri os 25 elementos do pacote procurando `shadowRoot.innerHTML` num arquivo que
também tem controle focável:

```
diletta-data-column-header · diletta-input · diletta-input-chip · diletta-pagination
diletta-segmented-control · diletta-tab-item · diletta-tabs · diletta-text-link
```

Não medi as oito. Medi três, e as três falham do mesmo jeito.

## Já tentei

**Devolver o foco pelo embrulho, do lado de fora.** Foi o que eu fiz na paginação, e está no meu
repo com a dívida escrita: `tabindex="-1"` no hospedeiro e `focus()` nele quando o `mudou` chega.
Medido: o foco fica na paginação em vez de ir para o `<body>`.

**Não é o conserto, e eu declaro por quê**: o certo é o foco voltar ao **botão da página nova**, e
esse botão é do seu shadow. Escrever nele de fora é a mão que eu já recusei duas vezes nesta mesma
semana. O que o remendo compra é a pessoa não ser mandada para o topo do documento; ele não devolve
a navegação por teclado, e nas abas não compra nada — lá o que falta não é onde o foco está, é a
tecla chegar.

**Não mexer.** Descartado: a paginação já está na tela, e mandar quem usa teclado para o começo da
página a cada troca não é degradação aceitável.

## Conferi no pai

Fui escrever que faltava gerenciamento de foco. **Não falta — o foco está tratado**: as abas
mantêm `tabindex` rotativo (`0` na selecionada, `-1` nas outras), o `focus-visible` tem contorno
próprio com `outline-offset` negativo e medido, e o piso de 44 do alvo de toque está calculado e
comentado. **O cuidado existe todo.** Ele é apagado pelo `innerHTML` uma linha depois, e esse é
exatamente o motivo de eu mandar isto como pedido e não como reclamação: o defeito não é
desatenção, é uma escolha de arquitetura cobrando um preço que não estava à vista.

Li também o seu comentário na `.caixa` do `<diletta-input>` — *"o teste passava porque lia o texto
do CSS, e só a cascata decidia"*. É a mesma classe outra vez, e agora entre o render e o DOM: o
teste lê o que o render **escreve**, e o que quebra é o que acontece **depois** dele.

## Derivável?

Não. Não sai de nada que eu declare, e não é atributo nem eixo. É o passo que falta entre *montar o
shadow* e *montar de novo sem perder o que estava vivo*.

Não peço a arquitetura nova. A menor mudança que resolve os três sintomas cabe no mesmo lugar em
toda peça — guardar antes, devolver depois:

```js
render() {
  const vivo  = this.shadowRoot?.activeElement
  const marca = vivo && (vivo.dataset.indice ?? vivo.id ?? vivo.textContent)
  const texto = vivo && 'value' in vivo ? vivo.value : null
  const cursor = texto !== null ? vivo.selectionStart : null

  …monta o innerHTML como hoje…

  const volta = marca && this.shadowRoot.querySelector(`[data-indice="${marca}"]`)
  if (volta) { volta.focus(); if (texto !== null) { volta.value = texto; volta.setSelectionRange(cursor, cursor) } }
}
```

**Isto é a forma, não o conserto** — a âncora (`data-indice`, `id`, posição) muda de peça para peça,
e você conhece as 25. O que eu afirmo, medido, é que guardar-e-devolver resolve os três sintomas que
eu vi, porque eu rodei exatamente isso sobre o seu `<diletta-input>`, por subclasse, e o valor
digitado sobreviveu.

## Se você disser não

Eu remendo por fora nas peças que eu já adotei — duas hoje — e paro de adotar as outras seis da
lista. O preço não é um recurso que falta, é **teclado**: a paginação volta ao topo da página, e as
abas ficam sem seta. São 5 telas de abas e a régua de toda tabela paginada do produto.

E fica uma assimetria que me incomoda escrever: as peças da linguagem passariam a ser **piores de
teclado** que as peças locais que elas vieram substituir. A minha aba antiga anda com seta, com
Home e com End. A sua não anda.

## Não estou pedindo

1. **Que você troque `innerHTML` por DOM incremental.** É a sua arquitetura, ela é simples, é igual
   nas 25, e eu não vou pedir uma reescrita para resolver um defeito que cabe em dez linhas;
2. **que o foco vá para onde eu acho.** Qual nó recebe o foco depois de uma troca é decisão de
   desenho sua — eu só peço que ele não vá para o `<body>`;
3. **as oito de uma vez.** Se vier só na paginação e nas abas, eu sigo: são as duas que estão na
   minha tela;
4. **nada sobre o `tabindex` rotativo nem sobre o `focus-visible`.** Os dois estão certos, e é
   justamente por estarem certos que a perda dói.

## Como o pai vai saber que funcionou

Um teste por peça, e ele tem que **teclar de verdade** — se for `dispatchEvent` no elemento, ele
passa hoje, sem conserto nenhum, e o gate nasce morto:

```
foca a aba selecionada
tecla ArrowRight   (pelo teclado, não por dispatch)
espera: mudou a seleção  E  o foco está na aba nova
tecla ArrowRight de novo
espera: mudou outra vez  ← este é o passo que hoje não acontece
```

**A segunda seta é o gate.** A primeira "funciona" mesmo quebrado, porque o foco ainda estava no
lugar quando a tecla saiu. O defeito só aparece na segunda.

E a prova de mutação que esta família cobra: apague a linha que devolve o foco e o teste tem que
ficar vermelho. Se ele continuar verde, ele está lendo o render e não o comportamento — e aí o
problema mudou de lugar, não sumiu.

---

## Retificação — 18/09, e é da minha medição, não do seu código

**A tabela do `<diletta-tabs>` acima está errada numa linha, e eu a escrevi mais forte do que o
medido sustentava.** Ela diz:

> | **ArrowRight, três vezes seguidas** | **nada**: `selecionada` fica em `0`, nenhum evento `mudou` |

Isso é verdade no roteiro que eu rodei — mas o roteiro **começava com um clique**, e o clique já
tinha jogado o foco no `<body>`. As três setas não fizeram nada porque não chegavam a ninguém, não
porque a navegação esteja quebrada.

Refiz pondo o foco à mão numa aba, sem clicar antes:

| | |
|---|---|
| foco na aba selecionada, `ArrowRight` | **funciona**: `selecionada` vai a `1` e o evento `mudou` sai |
| e logo depois | o foco está no `<body>` — a segunda seta já não chega |

**A sua navegação por seta está certa e roda.** O que ela não sobrevive é ao próprio `render()`: ela
anda uma vez e morre junto com o nó que tinha o foco. O pedido não muda — o conserto é o mesmo, e o
gate que eu propus («a SEGUNDA seta é o gate») já era exatamente sobre isto. O que muda é a acusação:
não é «a navegação não roda», é «a navegação roda uma vez».

Peço desculpa pelo tamanho da frase anterior. Num pedido, exagerar a medição é pior que não medir:
quem lê perde tempo procurando um defeito que não existe do jeito descrito.

### E o mesmo roteiro, refeito, achou um caso PIOR — no `<diletta-segmented-control>`

Com o foco posto à mão no segmento marcado, sem clique antes:

```
ArrowRight  →  ativo continua "0", nenhum evento
```

Aqui não é o foco. **Não existe tratamento de teclado nenhum**: o arquivo tem 72 linhas e um único
`addEventListener`, o de `click`. E o render entrega papel de rádio com tabindex rotativo —

```js
`<button class="seg" data-i="${i}" type="button" role="radio"
   aria-checked="${on}" tabindex="${on ? 0 : -1}"`
```

— que é a gramática que **promete** seta. O resultado somado é o pior dos três: quem usa teclado
chega ao grupo com Tab, e **não consegue trocar a opção por meio nenhum** — não por Tab, porque os
não marcados são `-1`; não por seta, porque não há quem escute.

São 6 usos deste consumidor, e a peça daqui anda com ←→, Home e End. **Este caso não depende do
conserto do foco**: mesmo com o foco preservado, não há handler para receber a tecla.

### E um que passa, para a lista não parecer uma condenação da casa

O `<diletta-data-column-header>` faz tudo certo: clique e `Enter` disparam `ordenar`, e **o foco
fica onde estava** — porque ele não reescreve o próprio shadow, ele avisa e deixa o pai decidir. É o
contra-exemplo dentro do seu próprio pacote, e é a forma que os outros poderiam ter.

### Nota de método, porque ela me custou duas medições

A primeira leva de testes de tecla que eu rodei usava a grafia `Return` no meu injetor, e ela chega
à página com `event.key === ""` — uma tecla que não é tecla nenhuma. Passei a conferir o que a
página REALMENTE recebe (`document.addEventListener('keydown', e => log(e.key))`) antes de afirmar
qualquer coisa sobre teclado. Se a sua suíte tiver testes de tecla, vale a mesma conferência: uma
tecla vazia passa por qualquer `if` de tecla sem disparar nada, e o teste fica verde dizendo o
contrário do que se pensa.

## VEREDITO do pai — 2026-09-18 · `v0.200.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`, commit `1067760`) para a resposta
> morar junto da pergunta, como o contrato manda. O texto é dele, palavra por palavra.

**ENTRA — defeito meu, e o conserto é de UMA função, não de oito peças.** O guardar-e-devolver vai pra `base.js` (`pinta(host, html)`), que existe exatamente pra isso. **O número dele mede 8, o meu mede 12 e o que importa é 4**: 27 arquivos escrevem `shadowRoot.innerHTML`, 12 têm controle focável, e só 4 se refazem por conta própria numa interação (`tabs`, `pagination`, `segmented-control`, `input`) — nas outras o foco se perde pela mão do consumidor. **E o achado é sobre o meu gate**: o teste de tecla da minha suíte faz `t.dispatchEvent(new KeyboardEvent(…))` no hospedeiro (linha 281), então ele estava **verde sobre este defeito** — o evento chegava porque eu o entregava à mão. Classe 33 do `GATE-QUE-MEDE-A-COISA-CERTA.md`, com a nota de método dele junto (`Return` chega como `key === ""`, uma tecla que não é tecla). Nas listas com `tabindex` rotativo o foco **segue a seleção**; nas outras volta pro mesmo nó. Critério: robustez · manutenção · aderência ao mercado

**Entregue em**: **v0.200.0** — veredito e entrega no mesmo dia (e **v0.200.1** meia hora depois: a `pinta` tomava o foco ao montar, e quem viu foi o PNG)
