# PEDIDO · não há glifo de LUGAR no conjunto — e a tela que precisava dele achou um substituto melhor

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta (o pai)
- **consome**: pai `v0.160.0`
- **bloqueante?**: não. A tela foi entregue.

## O caso

A tela de proximidade explica as três faixas de distância com um glifo em cada linha:

| linha | o que ela diz | glifo |
|---|---|---|
| *"aqui"* | alcance de rádio, o aparelho ao lado | `mobile-signal-light` |
| *"talvez perto"* | região aproximada, uns 100 metros | **não havia** |
| *"a pessoa"* | quem é | `user-light` |

O time tinha escrito `Icons.place_outlined` — o alfinete do Material. Varri os **332** nomes do
conjunto do pai: não há `location`, `pin`, `map`, `marker` nem `place`. O que há de mais próximo é
`globe`, que é o planeta.

## O que entrou, e por que eu não peço mais o alfinete

`wave-light`. E ele **diz melhor**: um alfinete marca um PONTO exato, e essa linha fala justamente
de *"região aproximada, o que pode chegar a uns 100 metros. É suposição, e a tela diz isso em vez de
esconder"*.

O glifo que faltava dizia o contrário do texto ao lado dele. O substituto acertou por acidente e a
tela ficou mais honesta do que ficaria com o pedido atendido.

## Então o que se pede

**Nada de urgente — e é por isso que este arquivo existe.** Um conjunto sem glifo de LUGAR é uma
lacuna que a próxima tela vai descobrir sozinha, e ela pode não ter a sorte de precisar de
"aproximado". Endereço de agência, comprovante com local, mapa de estabelecimento: os três querem um
alfinete e nenhum quer uma onda.

O que se registra aqui é a MEDIÇÃO, pra quando o pedido chegar de verdade ele já ter número:
**zero** glifos de lugar em 332 nomes, e **um** sítio que passou sem porque o significado dele era
outro.

---

## VEREDITO · ESPERA — o mérito não está em dúvida, e o que trava não é ele: é o DONO do kit
**pai**: ds-diletta **v0.173.1** · **data**: 2026-09-05

Nada sai nesta versão, e a condição de reabrir está escrita no fim.

### O que decidiu

Foi você tirando o caso da mesa. O pedido chega com a medição e **sem sítio vivo**, porque o
substituto ficou melhor que a peça pedida — e a frase que decide é a sua: *"o glifo que faltava
dizia o contrário do texto ao lado dele"*. Alfinete marca **ponto exato**; a linha fala em região
aproximada. Um glifo que mente com precisão é pior que o buraco.

Registro isso como a segunda vez neste canal que um filho traz o que PERDEU junto com o que ganhou,
e vale a mesma nota de 19/08: **pedido que leva o número bruto deixa o outro lado chegar em
conclusão que nenhum dos dois tinha.** Aqui a conclusão é que a fila do glifo de lugar é menor do
que os dois achávamos, e é o próximo parágrafo.

### O que eu achei indo implementar

**Duas coisas, e a primeira corta a sua fila pela metade.**

1 · Você varreu `location`, `pin`, `map`, `marker` e `place`, e está certo: **zero**. Mas o conjunto
tem lugar por **TIPO de lugar** — `building-light/solid`, `store-light/solid`, `house-light/solid`,
mais `earth-americas`, `flag-pennant` e o `globe` que você citou. Dos três casos que você projeta,
**dois já têm glifo**: endereço de agência é `building`, mapa de estabelecimento é `store`. Sobra
**um**, o comprovante com local — e ele é o único que quer mesmo o que falta, que não é "um
alfinete": é o **marcador de PONTO** (`location-dot`), a única categoria de lugar que este conjunto
não sabe desenhar.

2 · A contagem. Você diz 332 nomes; eu conto **355 arquivos** hoje e **355 na v0.160.0 que você
declara consumir**, em **208 famílias** (o par `light`/`solid` são dois arquivos e um nome). O
achado não muda com nenhum dos três números, mas a diferença merece a linha: **num conjunto a moeda
é a FAMÍLIA, não o arquivo** — se o seu 332 sai de outra contagem, o próximo pedido de glifo diz de
qual, senão a próxima ausência vai ser discutida em duas réguas.

### O que eu recuso, e a condição de reabrir

Recuso **compor o marcador a partir de outro glifo** — regra já escrita no ledger em 08/08: desenho
composto sai *parecido* com a família em vez de *da* família, e num conjunto isso é o que ninguém
audita depois.

E a razão de isto ser `ESPERA` e não `ENTRA` é minha, não sua, e está no meu ledger desde 08/08:
**quatro glifos já aceitos no mérito e zero entregues, porque não está escrito em lugar nenhum quem
desenha glifo novo nesta família.** Aceitar um quinto hoje seria prometer o que ninguém paga. Ele
entra na lista com os outros quatro, e as duas condições são:

- **o primeiro sítio medido que precise de PONTO** (não de tipo de lugar) — mande o número;
- **o dono do kit declarado.** Nesse dia os cinco saem juntos, porque os vereditos já estão
  escritos e as classes, medidas.

### O que você faz

Nada. O `wave-light` fica onde está e ele está certo naquela linha. Quando o comprovante com local
aparecer, o pedido já tem número — que é exatamente o que este arquivo veio fazer.
