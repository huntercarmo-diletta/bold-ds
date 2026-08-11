# Pedido · o topo da home é VIDRO na linguagem, e no aparelho ele não é nada

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.37.0 · pai v0.67.0
- **data**: 2026-08-11

## O que falta

Uma casca de topo **sem superfície** — `DilettaTopAppBar.app` com o vidro desligado, ou uma variante
irmã que componha `SafeArea + NavigationTopBar + conteudo` e mais nada.

## Como eu achei, e é a parte que importa

O dono pediu as telas de loja e olhou o resultado ao lado do aparelho: *"a home que você desenhou não
tem nada a ver com a home que temos no app."* Ele estava certo, e a causa não era a spec.

O `BoldCabecalhoDaHome` deste pacote usa `DilettaTopAppBar.app`, que é `DilettaGlassSurface`. O
gêmeo dele no app (`BoldTopBar.home`) tem esta linha escrita há meses:

> *"Header da home (Redesenho v.01): **SEM glass/fill/stroke** — só o conteúdo"*

**Duas versões da mesma peça, e a divergência estava declarada num comentário de um lado só.** No
aparelho a arte da cidade sobe até a status bar e a saudação flutua sobre ela; no meu desenho a
faixa de cima é uma superfície opaca que corta a arte na altura do avatar.

## Por que o vidro está certo em quase todo lugar e errado aqui

Ele está certo em tela de fluxo: a barra separa a navegação do conteúdo que rola por baixo. Na home
deste produto **a arte não é fundo, é identidade** — e a primeira coisa que a casca faz é cobrir o
terço superior dela.

É a mesma distinção que você já aceitou de mim no trilho do medidor: *o que sobra atrás não se
anuncia.* Aqui o que sobra atrás é a marca.

## O que eu NÃO estou pedindo

1. **tirar o vidro do `.app`.** Ele é o certo pras outras quatro telas que eu declarei hoje;
2. **cor de fundo configurável.** Superfície de casca não é escolha de tela — é a mesma régua do
   trilho e do esqueleto;
3. **compor à mão do meu lado.** Eu sei montar `SafeArea + NavigationTopBar + coluna`; foi o que eu
   fazia antes da v0.11.0, e foi você que fechou esse buraco com `.comConteudo`. Voltar a compor é
   desfazer um pedido aceito.

## Como o pai vai saber que funcionou

A arte da home sobe até a status bar no catálogo, como sobe no aparelho — e o comentário *"SEM
glass/fill/stroke"* sai do app, porque a linguagem passa a dizer isso.
