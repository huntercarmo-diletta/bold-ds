# RELEASE · o board tem BANDAS, as setas pararam de passar por cima, e o movimento saiu do fluxo

- **pai**: `catalogo-diletta` **v0.95.0**
- **é bloqueante?**: não. Um dos três **muda o que você vê sem você declarar nada** — o de baixo.

## 1 · As setas CONTORNAM as telas (chega sozinho)

Era um arco cúbico com `90 × salto` de desvio: uma seta pulando três telas ganhava 270px de barriga e
passava **por cima** dos frames do meio. Agora, quando há algo no caminho, a rota sai na horizontal,
desce pro corredor (o vão abaixo da fileira), corre, e sobe — cantos arredondados de 10.

Isso saiu de olhar imagem de board de verdade, e o achado é categórico: **nos quadros de referência
(Overflow, wireflow do NN/g) nenhum conector cruza um frame.**

Os seus fluxos são curtos, então na prática você vai notar em uma coisa só: seta que **pula** telas
agora passa por baixo em vez de por cima. Se algum board seu ficar pior com isso, é caso medido e eu
quero.

## 2 · `HandoffGroup.secoes` — bandas nomeadas (você declara, se quiser)

```dart
HandoffGroup(
  title: 'Área Pix',
  screens: [...],
  secoes: {0: 'Entrada', 4: 'Confirmação'},   // índice da primeira tela → nome da banda
)
```

A fileira quebra ali, e o nome aparece numa **coluna à esquerda** da banda — é a forma do board do
Overflow, onde o nome do subfluxo mora no vão esquerdo e não como cabeçalho em cima. Cabeçalho em
cima empurraria a primeira tela pra baixo e desalinharia as bandas entre si.

**Vazio é o board de antes, pixel a pixel**, e isso está no teste. Você provavelmente não precisa
disto hoje — o outro filho tem 41 telas numa fileira só. Fica declarado pra quando um fluxo seu
crescer, e pra você saber que existe antes de partir o fluxo em dois grupos, que era a única saída
que o motor oferecia.

## 3 · Modo ANIMAÇÃO na barra do board

A etiqueta da seta trazia `push · 400ms` na primeira linha e o gatilho na segunda — **duas camadas
empilhadas em toda seta**:

| camada | responde | quem lê |
|---|---|---|
| **fluxo** | pra onde vai, via o quê, sob que condição | quem desenha e revisa |
| **animação** | com que movimento, em quanto tempo, com que curva | quem implementa a transição |

Agora a pílula **Animação** troca uma pela outra, e a de animação traz a **curva** junto — que é o que
quem implementa precisa e o que ninguém lendo fluxo quer ver em 55 etiquetas. Nenhum dos quatro
quadros de referência põe motion na linha: **movimento não é topologia.**

O default não mudou: a etiqueta fala de fluxo, como sempre falou.

## O que você faz

`ref: v0.95.0`. O item 1 chega sozinho; os itens 2 e 3 são seus quando precisar.
