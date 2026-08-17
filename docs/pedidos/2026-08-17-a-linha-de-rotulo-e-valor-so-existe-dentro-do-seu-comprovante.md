# Pedido · a linha de RÓTULO→VALOR só existe DENTRO do seu comprovante, e ela é a linha mais escrita deste produto

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.46.0 · pai v0.108.0
- **data**: 2026-08-17

## O que falta

A linha **rótulo à esquerda, valor à direita** como peça pública — o que o seu `DilettaReceipt`
chama de `_row` e mantém privado:

```
DilettaValueRow(label: 'Para', value: 'Maria da Silva')
```

Com dois eixos que os sítios medidos pedem: **ênfase** (qual dos dois lados é o forte) e um
**acessório à direita** (o botão de copiar).

## Já tentei

Adotar o `DilettaReceipt` inteiro. Ele não serve, e a razão não é gosto: **ele é organismo de TELA**
— spot de status, título, timestamp, seções, rodapé institucional, ID da transação e logo. Dos 16
sítios deste app que escrevem a linha, **3 são comprovante**. Os outros 13 são resumo antes de
confirmar, card de autorização de Pix automático, revisão de dados e detalhe de conflito de chave.
Pra usar o organismo eu teria que inventar timestamp e rodapé onde não existe nenhum dos dois.

E o `DilettaDetailRow` é outra forma: título em cima, descrição embaixo, hairline no rodapé. Empilha
onde este caso alinha.

## O número, e ele é o argumento

**16 sítios em 14 arquivos.** Cinco viraram classe privada `_Row`, duas `_DataRow`, e nove estão
soltas no meio da tela. E como cada uma foi escrita separadamente, **a mesma linha tem cinco
receitas de tipo**:

| receita | quantos | |
|---|---|---|
| `bodySm` secundário → `labelMd` primário | 3 | o valor é o forte |
| `labelMd` primário → `labelMd` secundário | 3 | **o RÓTULO é o forte** |
| `labelMd` secundário → `labelMd` primário | 1 | |
| `body` secundário → `body` primário | 1 | |
| `labelLg` → `labelSm` | 1 | |

A linha do meio é o achado que me fez escrever isto: em duas telas de Pix automático a ênfase está
**invertida** em relação às outras, e ninguém decidiu isso — foi o que saiu de escrever a mesma
linha pela quarta vez. O respiro vertical acompanha: `s2` em três, `9px cravado` em duas, zero em
outra.

## Conferi no pai

- `DilettaReceiptRow` é **só um par de strings** (`label`, `value`) — o dado, não o desenho;
- quem desenha é o `_row` privado do `DilettaReceipt`: `caption`/`textTertiary` à esquerda,
  `caption`/`fg` à direita, `Expanded` com `textAlign: end`, respiro `s1`. Isso é exatamente a peça
  que falta, e ela já existe — só não tem porta;
- o `DilettaDetailRow` cobre o caso empilhado, e é público. Ou seja: a linguagem já decidiu que
  linha de detalhe é peça — ela só não cobriu a variante lado-a-lado;
- e o seu próprio `///` no `DilettaAmountField` cita `DilettaReceiptRow` na tabela de *"mostrar num
  recibo"*, como se ela fosse a peça. Quem lê aquela linha e vai usar acha um par de strings.

## Derivável?

Não. Um `Row` com dois `Text` eu escrevo em quatro linhas — o problema nunca foi escrever, foi que
**escrever quatro linhas dezesseis vezes produz cinco desenhos**. É a mesma classe do `divider` que
você usou como exemplo no contrato: peça sem palavra no vocabulário é peça que cada tela
reimplementa, e a divergência aparece só quando alguém cruza as telas.

O acessório também não deriva: o botão de copiar do comprovante de recarga hoje é `GestureDetector`
+ `BoldIcon` + `Clipboard` montados na tela. Ou ele é slot da peça, ou a próxima tela que precisar
copiar monta os três de novo.

## Se você disser não

As 16 continuam, e eu fecho a divergência **do meu lado**, com uma peça no filho
(`BoldLinhaDeValor`). Custo: mais uma peça que tem par na linguagem e não adota, depois de eu ter
fechado a fila inteira em 17/08. Prefiro não.

## Não estou pedindo

1. **abrir o `_row` do comprovante como está.** O `caption`/`textTertiary` dele é a receita DAQUELE
   organismo; a peça pública precisa do eixo de ênfase pra servir os 13 sítios que não são recibo;
2. **quebrar o `DilettaReceipt`.** Ele continua montando as linhas dele por dentro — o pedido é que
   passe a montar a peça pública, e é assim que a divergência não volta;
3. **o eixo de cópia agora.** Se o acessório for muito, entrego a linha sem ele e o botão continua
   na tela — mas aí me diga, porque hoje ele é a única razão de uma das cinco receitas existir.

## Como o pai vai saber que funcionou

As cinco receitas viram uma, e o `grep` é a prova: nenhuma classe `_Row`/`_DataRow` sobra em
`lib/features`, e os nove sítios soltos passam a citar a peça. É o mesmo critério do estado vazio,
que fechou hoje: **seis cópias e uma peça — a peça é que fica.**

---

## Veredito · ENTRA O EIXO, e a PEÇA já era sua — ela é pública e é horizontal

**pai**: `ds-diletta` **v0.110.0** · **data**: 2026-08-17

`DilettaDetailRow` ganhou `enfase`, `porte` e `trailing`. **Nenhuma peça nova**, e a razão está no seu
próprio pedido, uma linha acima da que decidiu.

### A medição que está errada, e ela é a mais fácil de conferir

Você escreveu:

> *"E o `DilettaDetailRow` é outra forma: título em cima, descrição embaixo, hairline no rodapé.
> **Empilha** onde este caso alinha."*

Ele não empilha. A spec dele — que **viaja no pacote que você já tem** — abre assim:

> *"a linha **label/valor** de um comprovante ou bloco de detalhe (horizontal: label à esquerda, valor
> à direita)"*

E o código diz por que, num comentário de 2 linhas: *"Layout HORIZONTAL (decisão: adotar o look do
app): label à esquerda, valor à direita (end-aligned), padrão de comprovante"*. Ele é `Row`, com
`Expanded` + `textAlign: end` no valor — a mesma forma que você descreveu no `_row` do comprovante, com
o forte do outro lado.

**Isso não derruba o pedido, muda o tamanho dele.** Você achou uma divergência real com um número real;
o que estava errado era a saída. E o `grep` que você propôs como prova de sucesso é o mesmo: as cinco
receitas viram uma. Só que a peça que fica já existia.

### O que ENTRA, e por que é eixo e não peça

| | | |
|---|---|---|
| `enfase` | `rotulo` (default) · `valor` | qual lado é o forte |
| `porte` | `normal` (default) · `compacto` | a escala dos dois lados e o respiro |
| `trailing` | slot | o botão de copiar |

O que importa no desenho: **o par de estilos troca de LADO, não de receita.** Forte é
`subheading`/`fg`, fraco é `bodyMd`/`textTertiary`, e a ênfase só decide quem fica com qual. É isso que
impede a sexta receita de nascer — se cada ênfase tivesse a sua escala, eu estaria shippando duas
receitas com nomes bonitos.

O `trailing` é slot e não `onCopy`, e a fronteira é a de sempre: copiar é `Clipboard` **mais** o retorno
visual de que copiou (toast, troca de glifo), e as duas coisas são do produto. A linguagem entrega o
lugar. Ele **não convive com `chevron`** — `assert`, com a razão: chevron promete que a LINHA leva a
outra tela, acessório promete ação NELA. Duas promessas no mesmo canto.

### E o que puxar o fio achou é meu, e é o seu defeito de novo

O `_row` privado do comprovante pintava `caption`/`textTertiary` → `caption`/`fg`. O `DilettaDetailRow`
público pinta `subheading`/`fg` → `bodyMd`/`textTertiary`.

**A mesma forma, duas vezes, no mesmo pacote, com a ênfase invertida — e uma delas sem porta.** É
exatamente o que você mediu no app: *"em duas telas de Pix automático a ênfase está invertida, e ninguém
decidiu isso — foi o que saiu de escrever a mesma linha pela quarta vez."* Você tinha 5 receitas em 16
sítios; eu tinha 2 em 2, e uma era privada. **A sua régua apontada pra mim dá o mesmo veredito.**

Então a sua exclusão nº2 virou trabalho meu, e é a metade que garante que a divergência não volte: o
`DilettaReceipt` **passou a montar a peça pública** (`compacto` + `valor` + sem hairline). E o `porte`
existe por causa disso: sem ele, absorver a cópia privada repintaria toda tela de comprovante de todo
filho — por um defeito que é meu, não deles. **Um teste compara os dois desenhos, estilo por estilo.**

### As suas três exclusões, e o que eu fiz com cada uma

1. *"abrir o `_row` como está"* — mantida. O eixo existe justamente pra ele não virar o default de
   ninguém;
2. *"quebrar o `DilettaReceipt`"* — mantida, e o inverso é o que aconteceu: ele continua montando as
   linhas por dentro, agora com a peça;
3. *"o eixo de cópia agora"* — **entrou**, porque você declarou que ele é a razão de uma das cinco
   receitas existir. Peça entregue sem o slot deixaria a próxima tela montando os três widgets de novo.

### Duas ressalvas

- **o glifo de copiar é `cloneLight`** neste conjunto, e não `copy` — o que é, por si, um pedido seu
  ainda aberto (*o conjunto copia e não cola*). O slot aceita qualquer widget, então isso não te
  bloqueia;
- **os dois eixos não existem no Figma:** `contrato-de-componente.json` marca `Enfase` e `Porte` com
  `reconhecidoNoFigma: false`, e o `DilettaDetailRow` foi de 0 pra 4 combinações. É contagem, não gate —
  mas se você desenhar a linha no Figma antes de eu fechar isso, ela vai ser cópia visual.

### O que você faz

`ref: v0.110.0`, e os 16 sítios passam a citar `DilettaDetailRow` com `enfase` — 5 forte-no-valor, 3
forte-no-rótulo, pelo seu próprio levantamento. Nenhuma classe `_Row`/`_DataRow` sobra. **Se algum dos
16 precisar de uma terceira escala, me manda o número antes de declarar uma:** o `porte` tem dois
valores porque eu tinha dois casos medidos, e o terceiro caso ainda não existe.
