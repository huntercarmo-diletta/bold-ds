# Pedido · o frame só aceita fundo de cor plana

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.22.0
- **é bloqueante?**: não. O catálogo fica de pé e as telas aparecem — o que não aparece é o que
  faz o produto ser reconhecível

## O que falta

O plugue não tem fenda pra fundo de tela que não seja uma cor: `fundoDaTela`,
`superficieDaTela` e `fundoImpostoPeloTema` devolvem `Color?`.

## A medição

O fundo deste produto é um componente, não uma cor — e é o **componente mais usado dele**: 114
chamadas, contra 9 do segundo colocado. Ele tem sete variantes, e o usuário escolhe qual quer na
tela de personalização (`BoldBackdrop.values` alimenta a lista):

| fundo | do que é feito | cabe em `Color?` |
|---|---|---|
| sólido | cor plana + brilho radial sutil | **a cor, sim**; o brilho, não |
| imagem | arte de tela cheia + véu | não |
| brilhoRosa · vidroFrio · aurora · porDoSol · gradeTech | 1 a 3 brilhos radiais, e um deles pinta grade num `CustomPainter` | não |

Uso explícito medido no app: **sólido 54 · imagem 10 · os cinco moods 11.**

Liguei o que cabia: o `fundoDaTela` agora devolve a base do backdrop em vez do `bg` do tema, o
que cobre o sólido. Sobram seis dos sete.

E há uma consequência que não é estética. O vidro deste produto é `BackdropFilter` sobre o que
está atrás; **sobre cor lisa ele não desfoca nada visível**. Então no preview do catálogo o vidro
— que é a assinatura do desenho, 18 leituras em 7 componentes — aparece como um retângulo
levemente tingido. Quem abre o catálogo pra decidir uma tela está olhando um material que o
aparelho não vai mostrar assim.

## O que eu faço hoje sem isso, e o que isso me custa

Duas opções, e as duas são ruins de um jeito específico:

1. **embrulhar no gancho `tema`**, que devolve widget. Funciona pro preview de TELA e estraga o
   card de componente: na aba de vocabulário eu quero o componente sobre superfície neutra, não
   sobre a cidade. O gancho é o mesmo pros dois, então não dá pra separar do meu lado;
2. **deixar plano**, que é o que está agora. O catálogo mostra as telas com o fundo certo de cor
   e o vidro sem nada pra desfocar.

Fico na 2. A 1 é o tipo de conserto que sobrevive: alguém acha o vidro bonito no card e o fundo
vira "o jeito novo" sem ninguém decidir.

## Onde eu ACHO que mora

No motor, e como gancho de widget — irmão dos que já existem (`barraDeStatus`, `inspetor`,
`pilhaDeChat` devolvem widget). Algo como "o que vai ATRÁS do conteúdo do frame", que o filho
devolve já resolvido pelo tema e pelo modo.

A ressalva que o formato pede: eu não sei se o frame do board e o card de componente devem
compartilhar esse gancho, e essa é a parte que eu não vejo — só o motor sabe quantos lugares
desenham "tela". Se a resposta for um gancho só, ele provavelmente precisa dizer QUAL contexto
está pedindo.

## Como o pai vai saber que funcionou

O preview de uma tela deste produto mostra a arte de fundo, e o vidro por cima dela desfoca de
verdade. Do meu lado o gate é o que já existe (`o_backdrop_nasce_no_filho_test`, 7 fundos × 2
modos): se o gancho chegar, ele passa a ser exercido pelo catálogo também, e não só pelo teste do
DS.
