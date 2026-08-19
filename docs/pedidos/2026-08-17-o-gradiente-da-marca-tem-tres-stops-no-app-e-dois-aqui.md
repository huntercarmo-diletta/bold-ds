# Nota do filho · o gradiente da marca tem TRÊS stops no app e DOIS aqui, e a diferença é o amarelo do lockup

- **para**: quem cuida da marca do Conta BOLD (dono do produto)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.46.0
- **data**: 2026-08-17

Não é pedido ao pai: gradiente de marca é meu. É uma decisão que eu não tomo sozinho, achada
fechando a dívida de token do app.

## Os dois, medidos

| | stops | fim |
|---|---|---|
| `BoldGradients.brand` do **app** | `#FE3976` → `#FE7B5E` → `#FEED35` | amarelo neon |
| `BoldGradients.primary` do **pacote** | `primary04` → `warning03` | âmbar queimado |

O do app é a leitura do lockup CONTA BOLD — rosa, coral, amarelo, com o amarelo na cauda. O do
pacote nasceu da paleta, com dois degraus que já existem, e traz a pior parada medida: **3.37:1**
contra branco.

## Por que eu não troquei sozinho

Trocar repinta dois sítios: a barra de topo sem vidro (`BoldAppBar`) e o cartão de escolha de tipo
de conta no onboarding. São poucos, e é justamente por isso que a troca não se justifica por
mecânica: **o que muda não é onde aparece, é o que a marca diz.** O amarelo é a cauda do lockup; sem
ele o gradiente vira "rosa pro laranja", que é a leitura do `accent`.

E na direção contrária: o amarelo `#FEED35` era, até hoje, o único uso de um token que eu apaguei do
app por não ter consumidor (`brandYellow`). Ele sobrevive só dentro deste gradiente. Um valor de
marca que existe em um lugar só é exatamente o que a paleta deveria declarar.

## As três saídas

1. **O pacote ganha o terceiro stop** — `primary` passa a rosa → coral → amarelo, e o app deriva.
   Custa remedir contraste: o amarelo neon contra branco é pior que o âmbar;
2. **O app adota os dois stops do pacote** — a marca fica mais escura no fim, e o lockup passa a ser
   o único lugar com amarelo;
3. **São dois gradientes diferentes com nomes diferentes** — `marca` (três stops, lockup) e
   `primary` (dois, superfície). Aí o app deriva o primeiro e o pacote declara os dois.

A terceira é a que eu escolheria se fosse minha: os dois já existem de fato, e hoje eles têm o
mesmo papel com desenhos diferentes, que é a definição de divergência.

## Enquanto isso

O `brand` do app fica declarado com os três hex e a razão escrita no `///`. Os outros **nove**
gradientes daquele arquivo saíram no mesmo dia — `primaryButton`, `primaryButtonShort`, `pix`,
`pay`, `ted`, `statement`, `receive`, `charge` e `balanceCard` tinham zero consumidores.

---

## Nota do pai · não é pedido a mim, e a sua saída 3 é a que a linguagem já diz
**pai**: ds-diletta **v0.115.0** · **data**: 2026-08-19

**Fora do canal, e de propósito.** Você endereçou ao dono do produto e escreveu por quê — *"gradiente de
marca é meu"*. Está certo, e eu não decido isto. Entra no ledger como **fora do canal** pra não ficar
parecendo pedido ignorado.

Três coisas que **são** minhas e cabem em resposta:

**1 · A sua saída 3 é a que a linguagem já separa, e ela tem nome aqui.** `marca` (três stops, a leitura
do lockup) e `primary` (dois, superfície) não são o mesmo papel com dois desenhos: são **arte** e
**superfície**, e esta casa já divide os dois em toda decisão de cor — *tinta é consequência de
legibilidade; preenchimento é decisão de marca*. Gradiente de lockup é arte: ele responde ao logo e a
ninguém mais. Gradiente de superfície tem coisa em cima, então ele responde a contraste. **Dois nomes é o
que impede a próxima pessoa de trocar um pelo outro por parecer.**

**2 · O 3,37:1 é o número que decide onde cada um pode aparecer, não qual é mais bonito.** Se o gradiente
de superfície tem texto ou glifo em cima, a pior parada dele é o que vale — e 3,37 passa objeto gráfico
(3:1) e reprova texto (4,5). O amarelo neon na cauda piora essa conta, o que é exatamente por que ele
serve arte e não superfície. **Isso não é argumento contra o amarelo: é o mapa de onde ele pode ir.**

**3 · O `brandYellow` sobrevivendo só dentro do gradiente é sinal, e você já leu certo.** *"Um valor de
marca que existe em um lugar só é exatamente o que a paleta deveria declarar."* Concordo — e a paleta é a
**sua**. Se o amarelo é o terceiro stop do lockup, ele é entrada da sua paleta com nome e razão, não hex
enterrado num gradiente.

### Sobre os nove que morreram no mesmo dia

`primaryButton`, `primaryButtonShort`, `pix`, `pay`, `ted`, `statement`, `receive`, `charge`,
`balanceCard` — **nove gradientes com zero consumidores.** Não é comentário lateral: gradiente de nome de
FUNÇÃO (`pix`, `ted`, `charge`) é vocabulário de produto virando token, e é a classe que eu recuso aqui
desde que `DilettaWalletCard.cpfSeguro` saiu. Você apagou antes de alguém pedir. Fica no ledger como o
que é: **limpeza de token com número.**

Nada a adotar. Quando o dono decidir, se a decisão criar necessidade minha (um gradiente de superfície com
piso declarado, por exemplo), aí vira pedido e eu julgo.
