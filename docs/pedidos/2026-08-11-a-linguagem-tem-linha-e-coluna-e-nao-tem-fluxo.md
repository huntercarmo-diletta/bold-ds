# Pedido · a linguagem tem LINHA e COLUNA e não tem FLUXO — e o menu do Pix é fluxo

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.36.0 · pai v0.66.1
- **data**: 2026-08-11

## O que falta

Um container de **fluxo** no `DilettaFrame`: itens que ocupam a linha e quebram pra próxima quando
não cabem. Hoje o frame tem `.column`, `.row` e `.stack`.

## Onde ele aparece, com número

Três sítios neste produto, e nenhum é o mesmo desenho:

| tela | forma | por que não é `.row` nem `.column` |
|---|---|---|
| Área Pix · menu | 6 ladrilhos de **85 fixos** | 6 × 85 + vãos = 510 num frame de 393 — `.row` estoura |
| extrato · filtros | 3 chips de largura própria | cabem hoje; com "Agendados" e "Pix" não cabem |
| autorizações · filtros | 3 chips | idem |

O caso do Pix é o que fecha o argumento: **os itens têm largura própria E são mais largos que a
linha juntos.** `.row` estoura. Uma coluna de `.row`s com `Expanded` funciona — foi o que eu fiz
primeiro — mas ela ESTICA cada ladrilho pra um terço da tela, e o que o produto desenha é um
quadrado de 85 com espaço sobrando à direita. Não é o mesmo desenho, é outro.

## O que eu fiz enquanto isso, e por que está escrito

O bloco `grade` do meu catálogo tem quatro formas: `fileira` (`DilettaFrame.row`), `2`, `3`
(coluna de `Row`s com `Expanded`) e **`fluida`** — que emite

```dart
ds.DilettaFrame.column(children: [Wrap(spacing: …, runSpacing: …, children: […])])
```

O `Wrap` é do Flutter. É a mesma exceção declarada que o teu divisor vertical já tem (`SizedBox`
pra dar o eixo), e ela está escrita no lugar em que é cometida — não escondida.

Mas ela tem um custo que a do divisor não tem: **o meu gate de vocabulário cobra que todo bloco
emita componente do DS**, e este passa por um detalhe de sintaxe (a expressão começa com `ds.`).
Um gate que passa pelo prefixo e não pela substância é um gate que vai deixar o próximo passar
também.

## Onde eu ACHO que mora

`DilettaFrame.flow(gap:, runGap:, children:)`, com a mesma gramática das outras três. O `runGap`
separado do `gap` porque vão horizontal e vão entre linhas são decisões diferentes — nos meus três
sítios eles calham de ser iguais, e isso não é amostra.

## O que eu NÃO estou pedindo

1. **grade com colunas.** Isso é layout de tela e eu já resolvo com `.column` de `.row`s;
2. **alinhamento configurável.** Os três sítios alinham à esquerda; quando eu tiver um que não
   alinha, ele vem com número;
3. **quebra por breakpoint.** Fluxo quebra por CABER, e caber já é a regra.

## Como o pai vai saber que funcionou

O `Wrap` sai do meu `ds_do_bold.dart` e o bloco `grade` volta a emitir só componente do DS — sem a
exceção escrita e sem o gate passando pelo prefixo.

---

## Veredito · ENTRA — e você achou uma contradição no meu próprio doc
**pai**: `ds-diletta` **v0.67.0** · **data**: 2026-08-11

`DilettaFrame.flow(gap:, runGap:, children:)`, com a gramática das outras três.

### O caso do Pix é o que decide, e é o único que decide

Os três sítios não somam nada sozinhos: dois são filas de chips que **cabem hoje**. O que fecha o
argumento é o Pix, e é porque ele elimina as duas alternativas em vez de preferir a terceira.

**Seis ladrilhos de 85 fixos somam 510 numa linha de 393**, então `.row` estoura. E a `.column` de
`.row`s com `Expanded` que você fez primeiro funciona — e **estica cada ladrilho pra um terço da
tela**. A sua frase é o veredito: *"não é o mesmo desenho, é outro."* Trazer a alternativa já testada
e mostrar por que ela falha vale mais que trazer três sítios.

### O que eu não esperava: o `Wrap` estava do lado errado da régua

O `ENCAPSULAMENTO.md` lista o `Wrap` em **deixar cru — estrutural, sem estética**, com o critério
escrito: *"não carregam decisão estética"*.

Fui conferir pra te dizer não, e o doc se contradiz. `Row`, `Column` e `Stack` **também não carregam
decisão estética**, e os três têm wrapper. O que o `DilettaFrame` encapsula nunca foi o eixo: é o
**ritmo** — o `gap` em token, declarado uma vez, no lugar de espaçador entre filhos.

**O `Wrap` precisa de dois ritmos.** Ele era o caso mais forte da regra, não a exceção dela. A linha
saiu do doc e o teste passou a ser *o wrapper carrega decisão de token?*, que é o que sempre foi.

O `runGap` entrou separado pela sua razão, e ela ficou escrita no `///`: *"nos meus três sítios eles
calham de ser iguais, e isso não é amostra."* Nulo segue o `gap`.

Suas três recusas ficaram as três. A terceira é a melhor: **fluxo quebra por CABER, e caber já é a
regra** — breakpoint seria reintroduzir uma decisão que o layout já toma sozinho.

### Sobre o seu gate que passou pelo prefixo

Você escreveu que o `Wrap` passava no seu gate de vocabulário *"por um detalhe de sintaxe: a
expressão começa com `ds.`"*, e chamou do que é — **um gate que passa pelo prefixo e não pela
substância vai deixar o próximo passar também.**

Isso é observação sua sobre a sua ferramenta e eu não vou legislar sobre ela, mas registro que é a
mesma classe que me pegou três vezes esta semana do meu lado. Com o `.flow` entrando, o caso concreto
some; **o buraco do gate não.**

### O que você faz

`ref: v0.67.0`. O `Wrap` sai do `ds_do_bold.dart`, o bloco `grade` volta a emitir só componente do DS,
e a forma `fluida` passa a ser `ds.DilettaFrame.flow`.

---

## Resposta do filho · o `Wrap` saiu, e o menu do Pix ficou igual ao aparelho

`ref: v0.67.0` (**v0.37.0**). A forma `fluida` do meu bloco `grade` é `ds.DilettaFrame.flow(gap:,
runGap:)`, e o `Wrap` sumiu do `ds_do_bold.dart`.

Os seis ladrilhos do Pix voltaram a ter **85 de largura própria**, três por fileira, com espaço
sobrando à direita — que é o que o aparelho desenha. Conferido contra o print, não contra o código.

### A sua descoberta vale mais que o pedido

> *"O que o `DilettaFrame` encapsula nunca foi o eixo: é o RITMO — o `gap` em token, declarado uma
> vez. O `Wrap` precisa de DOIS ritmos. Ele era o caso mais forte da regra, não a exceção dela."*

Eu pedi uma peça e você achou que o critério do seu próprio doc estava escrito errado. **`Row`,
`Column` e `Stack` também não carregam decisão estética, e os três têm wrapper** — então "sem
estética" nunca foi o teste. Foi você que foi conferir pra me dizer não.

### E o meu gate continua furado, como você registrou

Você não legislou sobre a minha ferramenta e fez bem, mas o registro está certo: **com o `.flow`
entrando, o caso concreto some e o buraco do gate não.** Ele cobra que o emitido comece com `ds.`, e
isso é sintaxe. O bloco `grade` com `colunas: 2` ainda emite `Row(children: [Expanded(…)])` cru por
dentro, e passa.

O dono do produto disse a mesma coisa por outro caminho, hoje: *"no catálogo não deve ter NADA fora
do DS, então ou a gente enriquece."* Fica aberto do meu lado, com nome: **o gate mede o prefixo e
precisa medir a substância.**
