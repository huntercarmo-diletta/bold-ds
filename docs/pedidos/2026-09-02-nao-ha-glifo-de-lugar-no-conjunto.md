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

---

## Retificação do pai · a condição de reabrir já estava cumprida quando eu escrevi `ESPERA` — o mérito ENTRA
**pai**: ds-diletta **v0.177.0** · **data**: 2026-09-08

O `ESPERA` acima está errado na parte que era minha de saber. Eu escrevi que a fila reabria com **"o
primeiro sítio medido que precise de PONTO"** — e ele existia desde **14/08**, medido por **outra
casa**, num componente de pé:

> *"o Figma dele usa `location-dot-solid` na linha de onde é o atendimento. Contei o conjunto do pai:
> zero. O que existe perto é `building`, `house`, `store` e `desktop` — todos são **o lugar**, e
> nenhum é **a marcação de lugar**. A diferença importa aqui porque a mesma linha diz `Atendimento
> digital` em metade dos agendamentos: com `building` a linha passa a dizer 'prédio: atendimento
> digital'."*

O contorno dela é o mesmo padrão do seu: um parâmetro com `buildingLight` de default e um `///`
dizendo que é substituto medido. **Duas casas, dois contornos, o mesmo glifo faltando** — e é essa a
régua de promoção desta família: *variante sobe no SEGUNDO pedido*. O segundo era o seu, de 02/09, e
eu respondi como se fosse o primeiro.

**Por que eu não vi, e o conserto não é atenção:** a varredura da família lia só o disco desta
máquina e só os repos que estavam no mapa — e aquela casa **não estava no mapa**. Três pedidos dela,
de 13/08, 14/08 e 23/08, nunca apareceram em varredura nenhuma. Hoje a ferramenta busca o remoto,
grita o repo que tem `docs/pedidos` e não está no mapa, e tem teste pros dois casos. **Régua que não
enxerga um filho responde pelo mundo que ela vê**, e foi o que eu fiz.

O que muda, e o que não muda:

- **o MÉRITO entra**: `location-dot-light` e `location-dot-solid` deixam de ser *um caso, um filho* e
  passam a ser a categoria de lugar que este conjunto não sabe desenhar, com dois sítios medidos em
  duas casas. A sua medição (`zero` em 355 arquivos, 208 famílias) fica de pé como está;
- **a ENTREGA continua parada, e a razão é minha, não sua**: cinco glifos aceitos no mérito e zero
  desenhados, porque não está escrito quem desenha glifo novo nesta família. Isso é dívida do pai, e
  vira linha ABERTA no ledger com esse nome — não condição pra você cumprir;
- **o que você faz continua sendo nada.** O `wave-light` fica onde está e está certo naquela linha.

E a frase que eu escrevi no veredito acima — *"o glifo que faltava dizia o contrário do texto ao lado
dele"* — vale ainda mais com a outra casa junto: lá, o substituto faz a linha dizer *"prédio:
atendimento digital"*. **Duas casas chegando no mesmo absurdo pelo mesmo substituto é a prova de que
a peça falta, e não de que o caso é local.**
