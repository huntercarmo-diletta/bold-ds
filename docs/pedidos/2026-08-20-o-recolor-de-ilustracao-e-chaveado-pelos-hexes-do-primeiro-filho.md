# PEDIDO · o recolor de ilustração existe, e a CHAVE dele é o hex do primeiro filho

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.115.0 · DS filho v0.56.0
- **bloqueante?**: não pro Bold. **Bloqueante pro neto do Bold** — mesma forma do pedido do espelho do claro.

## Falta

`DilettaIllustrationBrand.rampaDe` receber o mapa hex→degrau de **quem desenhou a arte**, em vez de
tê-lo cravado com os hexes do primeiro filho.

## Número

Este produto tem **77 arquivos** de ilustração. Medi todo `fill` e `stroke` deles contra a minha
paleta:

| | pinturas | leitura |
|---|---|---|
| em degrau da paleta | **2.480** | acompanhariam a paleta, se o mapa as conhecesse |
| fora da paleta | 1.361 | e a maior parte disso é invariante por regra SUA |

Dentro dos 2.480, o que importa é a **marca**: `primary01..09` aparecem **971 vezes** em 7 degraus —
`#fe3976` (343), `#ff87ab` (244), `#f66fa0` (159), `#ffb6cb` (121), `#600627` (73), `#300313` (27),
`#fff6fa` (4). O resto é neutro (1.364 em 9 degraus) e semântico, e a sua regra já diz que eles **não
entram**: *"cinzas/brancos e salmão/amarelo NÃO entram: cor de marca troca, erro/aviso e neutro são
invariantes"*.

**E o `rampaDe` de hoje acerta ZERO das minhas 971**, porque as chaves dele são `#003be0`, `#255df9`,
`#99b4ff` — o azul do primeiro filho.

## Já tentei

**1 · Passar a minha paleta pro `rampaDe`.** É o que a assinatura pede, e não resolve: ele mapeia
`'#003be0' → primary04`. Com a minha paleta ele traduz o azul-CPF pro meu rosa — e as minhas artes não
têm azul-CPF, têm o meu rosa já cozido. Nenhuma chave casa, o `apply` passa reto, e a arte não
recolore.

**2 · Repintar as 77 artes no azul do primeiro filho** pra elas entrarem no mapa. Absurdo, e eu
escrevo pra ficar registrado que eu considerei: seria desenhar na marca de outro produto pra poder ser
retematizado de volta pra minha.

**3 · Escrever o meu próprio `apply` com o meu mapa.** Funciona hoje e eu **não quero**: seriam duas
funções fazendo a mesma substituição, e a de vocês tem o `RegExp`, a idempotência e a nota de custo
(*"microssegundos"*) que eu ia copiar. Duas cópias divergem no primeiro conserto — a sua frase.

## Conferi no pai

O `///` do `rampaDe` **já diz que ele é isto**: *"as ilustrações vêm do Figma com o azul do primeiro
filho cozido dentro do arquivo. Este mapa é o que faz elas virarem a cor de outra marca — então ele é
função da PALETA, não uma tabela fixa"*.

Ele é função da paleta no **valor** e tabela fixa na **chave**. E o histórico está lá: era
`static final` lendo `<Filho>Colors`, e você chamou de *"o maior bolso de dívida que restava (10 de 12
leituras)"*. Este pedido é a metade que sobrou do mesmo conserto — **o valor virou função da paleta e a
chave não.**

## Derivável?

Não do que eu declaro hoje. E é declaração minha por natureza: os hexes cozidos são dado de quem
exportou o arquivo. O lugar natural é o plugue de marca — as artes já viajam com o filho, o mapa delas
também deveria.

## Se você disser não

As minhas 77 artes ficam como estão: **corretas pro Bold e congeladas pro neto dele.** Um neto herda a
arte rosa e não tem onde dizer que a marca dele é outra — o mesmo formato do que já está escrito no
pedido do espelho do claro, e a mesma resposta aceitável: 
*é escolha, não limite da arquitetura, e ela não pode ser silenciosa.*

## Não estou pedindo

1. **mudar a regra do que entra.** Neutro e semântico ficam fora, e a sua razão está medida — dos meus
   3.841 `fill`, só 971 são marca;
2. **hospedar as minhas artes.** Elas são minhas, como o logo;
3. **um `apply` por filho.** É o contrário: eu quero UM `apply`, o seu, com a chave vindo de fora.

## Como o pai vai saber que funcionou

Uma arte do Bold renderizada com a paleta de referência sai AZUL, e com a minha sai rosa — o mesmo
arquivo, dois temas. E o gate que eu proponho é o do pior caso, não o do caso feliz: **nenhuma pintura
de marca sobra com o hex original** depois do `apply`, em nenhuma das duas paletas.

---

## Veredito · ENTRA — a chave é de quem desenhou, e a tabela antiga ganhou data de morte
**pai**: ds-diletta **v0.120.0** · **data**: 2026-08-20

`DilettaBrand.hexesDaArte` (`hex → NOME do degrau`) · `rampaDe(p, marca:)` · `apply(svg, p, marca:)`.

### O que decidiu

Uma frase sua, e ela é o defeito inteiro:

> *"Ele é função da paleta no **valor** e tabela fixa na **chave**."*

Eu escrevi o `///` que diz *"então ele é função da PALETA, não uma tabela fixa"* e **entreguei metade**. O
conserto de 29/07 tirou `<Filho>Colors` do valor, eu chamei aquilo de *"o maior bolso de dívida que
restava"*, e a chave — que é a metade que decide se a tradução acontece — ficou com os dez hexes de um
produto. **971 pinturas suas, zero casadas.** Não há mérito a julgar: é a regra 1 desta casa (*nenhum valor
de marca aqui, nem como default nem como exemplo*) sendo violada por um mapa que eu mesmo declarei como
consertado.

E o seu «Já tentei» 2 é o que mostra o tamanho do absurdo, escrito por quem ia pagar a conta:

> *"Repintar as 77 artes no azul do primeiro filho pra elas entrarem no mapa. Absurdo, e eu escrevo pra
> ficar registrado que eu considerei: seria desenhar na marca de outro produto pra poder ser retematizado
> de volta pra minha."*

**O valor é o NOME e não a cor** (`'#fe3976': 'primary04'`), e essa é a única decisão de forma que é minha:
nome sobrevive à troca de paleta, cor não. Se a chave fosse hex→hex, o mapa envelheceria na primeira vez
que você mexesse num degrau — e você não saberia, porque o recolor não erra alto.

Critérios: **manutenção** (um mapa, no plugue, junto da arte que ele traduz) e **escalabilidade** — é o
mesmo argumento do seu pedido do espelho, e é literalmente o mesmo beneficiário: o neto.

### A tabela do primeiro filho FICA, com data escrita: 2026-09-20

Isto é ressalva, não meia-medida. Removê-la hoje pararia o recolor das artes dele **sem erro nenhum**: o
`apply` troca o que conhece e deixa passar o que não conhece, então a arte sairia azul-original e nada
acusaria. Degradação calada é o defeito que esta casa persegue — eu não pago a minha dívida de regra 1
criando um defeito silencioso na casa de outro filho.

Então: **PEDIDO DO PAI escrito pra ele hoje** (declarar `hexesDaArte` com os dez hexes que já são dele), e
a tabela sai na primeira release depois de 20/09. Está no `///` da função, com a data, pra não depender de
alguém lembrar.

### O que eu achei indo implementar

**1 · O gate que você propôs virou três, e todos são sobre SILÊNCIO.** Você pediu *"nenhuma pintura de
marca sobra com o hex original"* — isso está no meu teste. Mas indo escrever ele, o que me preocupou foi o
mapa mal declarado, porque o recolor não tem como reclamar. `violacoesDoMapaDaArte`:

| regra | o que ela pega |
|---|---|
| `mapa-da-arte-com-degrau-inexistente` | `'primary44'` — a pintura fica com o hex ORIGINAL e a arte sai na cor de outra marca |
| `mapa-da-arte-com-familia-invariante` | `'neutral01'` — recolorir cinza é repintar a SOMBRA da arte com a paleta do produto |
| `mapa-da-arte-com-chave-que-nunca-casa` | `'#fff'` — o `RegExp` só casa `#rrggbb`, então a linha é decorativa e **conta como coberta** |

A terceira é a que eu não teria achado sem escrever o teste: uma chave de três dígitos não erra, ela
simplesmente nunca dispara. **Cobertura falsa é pior que cobertura ausente.**

**2 · A sua regra do que entra fica intacta, e o seu número a confirma.** *"Dos meus 3.841 `fill`, só 971
são marca"* — 25%. A regra escrita antes deste campo (*cinzas/brancos e salmão/amarelo não entram*) é
justamente o que faz o mapa ser pequeno e auditável; se ela caísse, você teria 2.480 linhas pra declarar.

**3 · O `==` do `DilettaBrand` não via `selosDeLoja`** — achado somando os campos novos, contado no
veredito do seu pedido do logo. O mapa que eu esqueci é do mesmo tipo dos dois que eu ia somar.

### O que eu recusei, e a condição de reabrir

- **um `apply` por filho.** Você não pediu (item 3) e eu registro: continua UM, com o `RegExp`, a
  idempotência e a nota de custo. Foi o seu «Já tentei» 3 que fechou isso — *"duas cópias divergem no
  primeiro conserto"*, que é a minha frase de volta;
- **hospedar as suas artes**, que você já não pediu. As 77 continuam suas, como o logo;
- **derivar o mapa por proximidade de cor** (achar o degrau mais próximo do hex automaticamente). Recusado,
  e essa foi uma tentação real: pareceria eliminar a declaração, e produziria tradução que ninguém pediu —
  o `#600627` da sua lista (73 pinturas) é sombra de marca, e um snap automático poderia mandá-lo pro `01`
  ou pro `02` conforme a rampa do neto. **Aproximação silenciosa dentro de arte é a pior classe de defeito
  desta lista.** Reabre se alguém trouxer arte com 200 hexes de marca, onde declarar à mão é o gargalo — e
  aí a resposta provavelmente é ferramenta que GERA o mapa e o commita, não derivação em runtime;
- **mudar a regra do que entra** (item 1 seu): neutro e semântico continuam fora.

### O que você faz

`ref: v0.120.0`

1. na sua `DilettaBrand`, declare os **7 degraus** que você mediu:

   ```dart
   hexesDaArte: const {
     '#fe3976': 'primary04',   // 343
     '#ff87ab': 'primary06',   // 244
     '#f66fa0': 'primary05',   // 159
     '#ffb6cb': 'primary07',   // 121
     '#600627': 'primary02',   // 73
     '#300313': 'primary01',   // 27
     '#fff6fa': 'primary09',   // 4
   },
   ```

   Os nomes de degrau acima são o meu palpite a partir da sua lista ordenada — **o mapa é seu, então quem
   decide qual hex é qual degrau é você**, e o gate acusa se algum nome não existir na paleta;
2. as chamadas passam a `DilettaIllustrationBrand.apply(svg, paleta, marca: tema.brand)`;
3. rode `violacoesDoMapaDaArte(marca, paleta)` no seu gate — ele é barato e mede o que o recolor engole;
4. o seu gate do pior caso (*nenhuma pintura de marca sobra*) vale mais que o meu, porque você tem as 77
   artes de verdade. Se ele achar hex de marca que não está nos 7, **é o oitavo degrau** e ele vira linha no
   seu mapa, não pedido pra mim;
5. e me diga o número final: **971 de 971**, ou o que sobrar. É a medição que fecha isto.


## Resposta do filho · declarado na v0.57.0, e a peça não passa a marca
**data**: 2026-08-20

Declarei os 7 degraus com o valor em NOME, e a sua decisão de forma vale a nota: eu teria escrito
hex→hex sem pensar duas vezes, e o mapa envelheceria na primeira vez que eu mexesse num degrau — sem
avisar, porque **o recolor não erra alto**.

**Mas a arte ainda não recolore**, e não é o mapa: `DilettaIllustration` chama
`apply(raw, tema.palette)` nos dois sítios, sem o `marca:` que você abriu. O `hexesDaArte` cai no
`?? const {}` e a tabela usada continua a do primeiro filho. Nota separada enviada, com os dois
números de linha.

Os seus testes passam porque chamam a função direta — é a peça SOLTA verde com a MONTADA quebrada, a
mesma classe do stepper. E ela é mais silenciosa aqui do que lá, pelo motivo que você mesmo usou hoje
pra manter a tabela viva até 20/09: o `apply` deixa passar o que não conhece.

**Ressalva minha, e ela é a parte que ainda não está resolvida do meu lado:** as minhas 77 artes moram
no APP, não neste pacote. Mesmo com a peça consertada, elas não passam pelo `DilettaIllustration` até
mudarem de casa — e isso é trabalho meu, não seu. Está medido: 3.841 pinturas, 971 de marca.
