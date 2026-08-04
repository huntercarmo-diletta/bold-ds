# RELEASE · `walletSolid` já estava no seu bundle e não tinha nome — e 6 arquivos saíram

- **pai**: ds-diletta **v0.45.0**
- **é bloqueante?**: não. Um token novo (aditivo) e 6 arquivos removidos que **nenhuma fonte sua
  referencia** — medido nome por nome antes de sair.

## O que entrou

**`DilettaIcons.walletSolid`.** O arquivo `Wallet-solid.svg.vec` embarcava no seu bundle desde a
**v0.7.0**: glifo 18×18 monocromático, o par sólido exato de `wallet-light`. Nunca teve token, então
você pagava o peso e não tinha como pedir.

A causa vale mais que o conserto: ele foi separado da linguagem pela **CAIXA da primeira letra**. Os
351 nomes são minúsculos, o `W` maiúsculo o jogou no balde de "export cru do Figma" junto de `Cover`
e `Vector`, e a linha do cabeçalho que dizia *"7 exports crus ficaram de fora"* passou seis dias
sendo lida como verdade. **Quinta vez que caixa alta esconde a mesma classe de coisa neste DS.**

Das 6 famílias `light` sem `solid`, `wallet` era a **única** cujo arquivo sólido existia no disco —
as outras 5 não têm arte. Não era gosto local, era buraco.

## O que saiu, e por que não te alcança

6 exports crus do Figma: `Cover` (509KB de arte), `Vector`, `Vector-2`, `Vector-3`, `Vector-4`,
`Proximity profile`. **Nenhum símbolo público sai** — eles nunca tiveram token. Medi cada nome contra
a sua fonte antes de remover: os únicos acertos eram manifesto de build listando o asset porque ele
embarca. Sai peso, não API.

> Se você referencia um desses por string crua em algum lugar que eu não alcancei, o `DilettaIcon`
> cai num fallback em silêncio — vale um `grep` de 10 segundos antes de subir de versão.

## O gate que faltava, e ele é o motivo dos 7 terem sobrevivido

O teste que existia olhava **do nome pro arquivo**: todo token tem `.vec` no disco. A direção
contrária — todo arquivo que embarca tem nome — não era medida por ninguém, e era exatamente onde os
7 moravam. Agora mede as duas.

**Efeito colateral que é o ponto:** `assets/icons` e `DilettaIcons.all` passaram a ser o mesmo
**352**. Antes eram 358 no disco e 351 nomeáveis, e nenhum dos dois números era o que a doc dizia.

Se você tem um seletor de ícone que enumera `DilettaIcons.all`, ele ganha `walletSolid` sozinho.

## Uma coisa que talvez te sirva

O alias depreciado `sendCpfSeguro` continua fora do mapa `all` de propósito, e o teste novo passa por
isso: ele aponta pra um arquivo que um token de verdade também nomeia. Depreciado não polui o
vocabulário enumerável.

## Como subir

`ref: v0.45.0`. Se ícone novo do pai "não existir" no seu teste, é o cache de manifesto de assets:
`flutter clean`. `pub get` não basta, e a falha aparece só nos arquivos novos.
