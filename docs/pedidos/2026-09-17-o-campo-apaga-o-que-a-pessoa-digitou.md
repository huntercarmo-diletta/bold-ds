# PEDIDO · O `<diletta-input>` apaga o que a pessoa digitou no instante em que o erro aparece

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não para mim** — eu não uso esta peça, e é por isso que este pedido é estranho:
  o número da seção «Número» é **zero sítios meus**. Mando mesmo assim porque o defeito está no
  pacote de todo mundo, e porque eu tenho o conserto medido.
- **irmão**: [o campo não tem onde pôr ícone, ajuda nem botão](2026-09-17-o-campo-nao-tem-onde-por-icone-ajuda-nem-botao.md) — o outro é DESENHO, este é CONSERTO, e a ordem importa: este não depende daquele.

## Falta

O campo de uma linha descarta o `valor` que recebe e perde o que foi digitado a cada atributo que muda.

## Número

Zero sítios meus — eu ainda não adotei a peça. O número aqui é a **medição do defeito**, feita no
navegador com o elemento registrado, criando o elemento e digitando nele:

| o que eu fiz | o que o campo mostrou |
|---|---|
| `valor="R$ 10,00"` | `""` |
| digitei `500` e então pus `erro="Valor acima do saldo"` | `""` |

No segundo caso o `<input>` do shadow é **outro nó** depois do atributo mudar — conferi por
identidade, não por aparência. O mesmo roteiro num `type="long"` devolve `"texto inicial"`: o
`textarea` honra o `valor`, o campo de uma linha não. A assimetria está no render:

```js
>${type === 'long' ? (this.getAttribute('valor') || '') : ''}</${campo}>
```

`valor` está em `observedAttributes` e é aplicado só num dos dois ramos. E como `render()` refaz o
`innerHTML` inteiro, qualquer atributo observado que mude recria o campo — e o que a pessoa digitou
nunca voltou a ser atributo, então não há de onde restaurar.

**O momento em que isso acontece é o pior possível**: `erro` aparecendo é a validação falhando. A
pessoa preenche, erra, e o campo esvazia junto com a mensagem pedindo para corrigir.

## Já tentei

**Embrulhar e escrever o valor por fora, pela propriedade.** Não há propriedade: o protótipo do
elemento tem `connectedCallback`, `attributeChangedCallback`, `estadoEfetivo` e `render`, e nenhum
`value`/`valor`. Só atributo — e é o atributo que é descartado.

**Ler o que foi digitado pelo evento.** Funciona pela metade: `input` e `change` são `composed`,
então chegam ao hospedeiro — mas o alvo é retargetado para `<diletta-input>`, que não tem `.value`.
Daria para pegar por `composedPath()[0]`. **Não resolve nada**, porque o problema não é ler: é que o
campo não consegue guardar.

**Escrever direto no `<input>` de dentro do shadow, por um `ref`.** Funciona uma vez e some no
atributo seguinte, porque o nó é recriado. E seria eu enfiando a mão no shadow da sua casa — é o
mesmo *remendo invisível* que eu recusei no `formAssociated` do botão, com o agravante de nem
funcionar.

## Conferi no pai

Fui escrever que o `valor` não era observado. **Está observado** — a lista é
`['type','estado','label','valor','erro','placeholder']`. O defeito não é o contrato do atributo, é
o ramo do render. Isso mudou o pedido inteiro: não estou pedindo atributo novo, estou apontando um
ramo que ficou de fora.

Li também o `///` do `estadoEfetivo` — *"`erro` com texto IMPLICA `estado: erro`"* — e ele está
certo e é justamente o que dispara o defeito: o caminho mais comum de mostrar erro é pôr o atributo
`erro`, que é observado, que redesenha, que apaga.

E li o comentário da `.caixa`, onde você registra que a borda vermelha do erro *"nunca aparecia — o
teste passava porque lia o texto do CSS, e só a cascata decidia"*. É a mesma classe: o teste lê o
que o render escreve, e o que quebra é o que acontece **depois** dele.

## Derivável?

Sim, inteiramente. Não peço campo novo, atributo novo nem eixo novo. O `valor` já existe, já é
observado, e já funciona no `long`. **O conserto é fazer o ramo curto se comportar como o longo, e
preservar o que está no campo quando o shadow é refeito.**

Dez linhas, medidas — subclassei o seu elemento no navegador e rodei o mesmo roteiro:

```js
render() {
  const antes = this.shadowRoot?.querySelector('input,textarea')
  const guardado = antes ? antes.value : null
  const foco = antes && this.shadowRoot.activeElement === antes
  const cursor = antes ? antes.selectionStart : null
  super.render()                        // a pintura continua sendo a sua
  const campo = this.shadowRoot.querySelector('input,textarea')
  const v = guardado || this.getAttribute('valor') || ''
  if (campo.value !== v) campo.value = v
  if (foco) { campo.focus(); campo.setSelectionRange(cursor, cursor) }
}
```

| | antes | depois |
|---|---|---|
| `valor="R$ 10,00"` | `""` | `"R$ 10,00"` |
| digitei `500`, mostrei o erro | `""` | `"500"` |

O erro continua aparecendo e continua amarrado por `aria-describedby`. **Isto é a forma do
conserto, não o conserto**: na sua casa ele mora dentro do `render()`, sem `super`, e o foco e o
cursor talvez você prefira tratar de outro jeito. O que eu afirmo é que as duas linhas do meio
bastam para o campo parar de perder dado.

## Se você disser não

Eu não pago preço nenhum: não uso a peça, e o meu campo local funciona. **Quem paga é quem usa o
`<diletta-input>` hoje** — o seu catálogo e o segundo filho. É o único pedido que eu já mandei em
que o contorno é *eu não faço nada*, e é por isso que ele não tem urgência escrita: a urgência não
é minha.

Se a resposta for não, eu só peço que ela venha escrita, porque eu vou reencontrar este campo
quando o irmão deste pedido for respondido — e aí o defeito passa a ser meu.

## Não estou pedindo

1. **Que você pare de refazer o `innerHTML`.** É a sua arquitetura de render, ela é simples e é
   igual nas 25 peças. O conserto proposto convive com ela;
2. **uma propriedade `value` no elemento.** Seria mais confortável para mim no React, mas é decisão
   de API sua, e o atributo resolve o defeito;
3. **evento próprio de mudança.** `input` e `change` já sobem compostos; o que falta é o campo
   guardar, não avisar;
4. **nada sobre o `type="long"`.** Ele está certo.

## Como o pai vai saber que funcionou

Um teste que **digita e então muda um atributo**, que é o passo que os testes de hoje não dão:

```
cria <diletta-input label="Valor">
escreve "500" no campo de dentro
põe erro="acima do saldo"
espera: o campo ainda diz "500"     ← hoje diz ""
```

E um segundo, de uma linha, para o ramo curto: `valor="x"` e o campo diz `"x"`.

Vale a prova de mutação que esta família usa: apague a linha que restaura o valor e o primeiro teste
tem que ficar vermelho. Se ele continuar verde, o teste está lendo o render e não o comportamento —
que é exatamente o modo de falhar que você registrou no comentário da `.caixa`.
