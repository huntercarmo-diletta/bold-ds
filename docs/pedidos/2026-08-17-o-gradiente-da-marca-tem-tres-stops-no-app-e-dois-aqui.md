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
