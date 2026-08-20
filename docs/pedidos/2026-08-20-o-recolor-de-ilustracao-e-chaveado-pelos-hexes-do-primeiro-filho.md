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
