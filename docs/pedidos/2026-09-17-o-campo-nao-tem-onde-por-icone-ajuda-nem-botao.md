# PEDIDO · Cinco coisas que o `DilettaInput` do Dart tem e o `<diletta-input>` da web não — e elas são 34 dos meus 50 campos

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **sim, para a adoção**. É a segunda peça mais usada do produto, e sem estas
  cinco eu não tenho como trocar 34 dos 50 campos.
- **irmão**: [o campo apaga o que a pessoa digitou](2026-09-17-o-campo-apaga-o-que-a-pessoa-digitou.md) — aquele é CONSERTO e não depende deste. Este não fica de pé sem aquele: um campo com ícone que continua apagando o valor não me serve.

## A tabela de itens

Os cinco são a mesma classe dos pedidos de hoje — **existe no Dart e não atravessa** —, e os
nomes do Dart estão na coluna do meio de propósito: nenhum deles é invenção minha.

| item | o que é | por que agora |
|---|---|---|
| **1 · ajuda** | `helper` — a linha de texto abaixo do campo, que não é erro | 14 campos. Hoje é a única forma de dizer *"sem pontos nem traços"* antes de a pessoa errar |
| **2 · teclado** | `keyboardType` — na web, `inputmode` no `<input>` | 16 campos. É o maior item da lista e o mais barato: um atributo repassado. Sem ele, o celular abre teclado de letras para digitar valor |
| **3 · acessório à esquerda** | `leftAccessory` — um ícone dentro da caixa | 5 campos |
| **4 · acessório à direita** | `rightAccessory` — um **botão de verdade**, com nome acessível: limpar, mostrar/ocultar | 1 campo hoje, e é o que vai crescer: toda senha precisa dele |
| **5 · limite** | `maxLength` | 4 campos |

**Os itens 3 e 4 são uma decisão só, e ela vem antes das outras**: os dois querem *slot*, e o
elemento não tem nenhum. Decidido se o campo aceita conteúdo do filho, os dois saem juntos. Os
itens 1, 2 e 5 são atributos independentes e podem sair sozinhos, em qualquer ordem.

## Falta

O elemento não tem onde pôr ícone, ajuda, botão, teclado nem limite.

## Número

50 usos, em 19 arquivos. Contados com uma varredura que respeita aspas e chaves — a minha primeira
contagem, por `grep -A6`, dizia 51 e inflava o `leading`; esta é a boa:

| o que eu uso | em quantos campos | o elemento tem? |
|---|---|---|
| `inputMode` | 16 | não |
| `hint` | 14 | não |
| `type` | 5 | **sim** |
| `leading` | 5 | não |
| `placeholder` | 4 | **sim** |
| `maxLength` | 4 | não |
| `error` | 2 | **sim** |
| `trailing` | 1 | não |
| `disabled` | 1 | **sim** |

**34 dos 50 campos usam ao menos uma coisa que o elemento não tem.** Os outros 16 atravessariam
hoje — se não fosse o irmão deste pedido.

O elemento observa seis atributos: `type`, `estado`, `label`, `valor`, `erro`, `placeholder`. O
widget Dart recebe vinte, e entre eles estão os cinco desta tabela. Nenhum é caso raro: são o
teclado numérico, o texto de ajuda e o botão de limpar.

## Já tentei

**Pôr o ícone por fora, ao lado do elemento.** Não é a mesma peça: o ícone do desenho mora *dentro*
da caixa, compartilhando a borda e o estado dela. Por fora ele fica numa caixa própria, e no erro a
borda vermelha contorna o campo e deixa o ícone de fora.

**Usar `placeholder` no lugar de `hint`.** Não é a mesma coisa e é pior: o `placeholder` some
quando a pessoa começa a digitar, que é exatamente quando a instrução *"sem pontos nem traços"*
passa a fazer falta. Além de o `placeholder` já ter dono no desenho — ele é exemplo, não
instrução.

**Deixar o teclado errado.** Medi o custo antes de descartar: são 16 campos de valor, CPF, CEP,
agência, conta, código de boleto. No celular, teclado de letras para digitar `1.234,56`. Não é
degradação aceitável, é a tela funcionando mal.

**Pôr slot eu mesmo, embrulhando.** Não existe slot nenhum no shadow — conferi:
`shadowRoot.querySelector('slot')` devolve `null`, e os filhos do shadow são `style`, `label` e o
campo. Sem slot, conteúdo do filho não atravessa: ele fica no DOM claro e não é renderizado.

## Conferi no pai

Fui escrever que a web tinha ficado para trás por descuido. **Não foi descuido, foi eixo**: o seu
`///` abre dizendo que o eixo `Estado` *"ficou invisível para a lei durante todo o tempo em que o
render já o pintava"*, e a lista de `observedAttributes` é exatamente a dos eixos da spec mais o
que a pintura precisa. O elemento implementa **a spec da peça**; o widget Dart implementa **a peça
inteira**. São dois recortes diferentes do mesmo nome, e o segundo tem quinze campos que o primeiro
nunca teve por onde receber.

Isso mudou o pedido: não estou reportando esquecimento, estou perguntando **onde fica a fronteira**.
Se a instância web é a spec e nada além, então os cinco itens não são bug seu — são peça minha, e o
`BoldTextField` fica local para sempre com essa razão escrita. Prefiro ouvir isso a adotar pela
metade.

## Derivável?

Três dos cinco, sim: `helper`, `inputmode` e `maxlength` são atributos que o `<input>` nativo já
entende — o elemento só precisa repassá-los. Não pedem eixo, não pedem pintura, não entram na
tabela de papéis.

Os itens 3 e 4 **não** são deriváveis: exigem slot, e slot é decisão de forma. É aí que eu quero o
seu veredito, não a minha sugestão.

## Se você disser não

O `BoldTextField` fica local, e fica **bem**: ele funciona, tem rótulo amarrado, erro com
`role="alert"`, ajuda descrita, e passa nos gates de contraste e de espaçamento desta casa. O preço
não é a tela, é a **divergência**: a segunda peça mais usada do produto continua sendo desenho meu,
e toda mudança de forma sua nela chega aqui como transcrição à mão — que é a classe de erro que
esta família já registrou quatro vezes este mês.

Se a resposta for *"a instância web é a spec, e acessório não é da spec"*, eu aceito e escrevo isso
no `///` da peça. O que me custa caro não é o não; é o não saber.

## Não estou pedindo

1. **Paridade com o Dart.** Dos vinte campos do widget eu pedi cinco. `inputFormatters`,
   `focusNode`, `textInputAction` e `onTap` são de Flutter e não têm o que fazer aqui;
2. **uma propriedade `value` no elemento** — está no irmão, e lá eu explico por que o atributo
   basta;
3. **que o ícone da esquerda seja do seu conjunto.** Se o slot aceitar qualquer nó, eu ponho o meu
   `BoldIcon` e o problema é meu;
4. **`type="email"`, `type="tel"` e companhia.** O eixo `Type` da spec tem três valores e eu
   concordo com os três — `inputmode` resolve o teclado sem mexer no eixo, e é por isso que eu pedi
   o atributo e não um valor novo;
5. **nada sobre o `estado` forçado.** O `statusForcado` do Dart não me faz falta.

## Como o pai vai saber que funcionou

Para os três atributos, um teste por item, lendo o `<input>` de dentro do shadow:

```
<diletta-input ajuda="sem pontos nem traços">  → existe <p> com o texto, e o campo o descreve
<diletta-input inputmode="decimal">            → o input de dentro tem inputmode="decimal"
<diletta-input maxlength="14">                 → o input de dentro tem maxlength="14"
```

O primeiro merece o laço testado, não só a presença: hoje o `erro` é amarrado por
`aria-describedby` e a ajuda teria de entrar no mesmo laço, **somando** em vez de substituir —
campo com erro *e* ajuda tem que descrever os dois.

Para os slots, o gate que esta casa usa e que eu escreveria de bom grado: um teste que põe um nó no
slot e afirma que ele **é renderizado** — `assignedNodes().length === 1` —, porque o modo de falhar
do slot é silencioso, igual ao da tinta fora de ordem que o seu README conta ter custado semanas.

E um inventário, se você quiser o de fora: uma lista que compare os campos do widget Dart com os
`observedAttributes` do elemento e reprove quando a diferença crescer sem motivo escrito. Este
pedido é o que essa lista teria dito sozinha.

## VEREDITO do pai — 2026-09-18 · `v0.200.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`, commit `1067760`) para a resposta
> morar junto da pergunta, como o contrato manda. O texto é dele, palavra por palavra.

**TRÊS ENTRAM, DOIS ENTRAM DIFERENTE — e a fronteira virou doutrina: a instância web é a PEÇA, não a spec.** A spec declara EIXO (o que nasce de `enum`); se ela fosse a fronteira, `label`, `placeholder` e `erro` estariam fora dela pelo mesmo argumento. O que mede paridade é o widget, que tem **26 campos** — ele pediu cinco. `ajuda`, `inputmode` e `maxlength` entram como atributo repassado (e a ajuda **soma** no `aria-describedby` em vez de substituir o erro, que é divergência deliberada: no Dart o erro sobrepõe a ajuda, e quem tem de alcançar é o Dart). Os acessórios entram como slot `inicio`/`fim`, e **a caixa vira invólucro** — não se põe slot dentro de um `<input>`, e é isso que faz o ícone ficar DENTRO da borda vermelha no erro, que era o argumento dele. **E o item 4 já era meu**: o olho da senha está aberto no meu ledger desde 15/09, então ele nasce embutido em `type="password"` e o slot `fim` preenchido o substitui — precedência copiada do `_passwordEye()` do Dart, não inventada. Critério: aplicação · manutenção · escalabilidade

**Entregue em**: **v0.200.0** — veredito e entrega no mesmo dia (e **v0.200.1** meia hora depois: a `pinta` tomava o foco ao montar, e quem viu foi o PNG)
