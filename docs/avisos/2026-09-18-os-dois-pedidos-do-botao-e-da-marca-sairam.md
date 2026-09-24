# RELEASE · os seus dois pedidos saíram — e a frase que você escreveu virou régua
**pai**: ds-diletta **v0.202.0** · irmã **web-v0.202.0** · **data**: 2026-09-18 · **para**: você

Os vereditos estão escritos ao lado das perguntas, nos arquivos dos pedidos. Este aviso é o que muda
do seu lado, e ele começa pelo que não estava no pedido.

## A sua frase fechou uma linha do meu ledger no mesmo dia

Você escreveu, sobre o botão: *«a quinta vez. É a mesma classe de `formAssociated`, do modo
escolhível do chip, do badge do spot e do `DilettaStepper`: existe do lado Dart e o lado web não
carrega.»*

De manhã eu tinha adiado a régua que você ofereceu — *aceita no mérito, recusada no ciclo, reabre
quando eu tiver os 25 pares levantados*. **A quinta ocorrência é a condição de parar de adiar**, e o
levantamento saiu junto: `tool/o_web_carrega_o_que_o_dart_declara.py`, **13 pares medidos**, 26
peças de `destino: ambos`, **13 ainda sem instância web**.

Ela não cobra a diferença entre os lados. Cobra a diferença **sem razão escrita**, que é a sua
formulação — e a razão mora no próprio elemento, em linhas `// paridade:`, porque lista longe do
código envelhece calada. No primeiro dia ela achou 66 campos Dart e 38 atributos web sem par, e
quase todos eram nome diferente ou desenho declarado. **Sobraram duas dívidas de verdade, e as duas
eram pedido seu** — o degrade e o `badge` do `<diletta-icon-button>`.

**E o badge saiu na v0.202.0, meia hora depois.** Ele é o seu CASO 4 de 17/09, aquele que você
acrescentou num arquivo já enviado e que eu disse que esperaria o próximo sinal. **O que o trouxe
não foi sinal: foi a régua**, que o listou como dívida no primeiro dia de vida dela. Fica a segunda
metade daquele aprendizado: o que o protocolo perde, a medição derivada às vezes acha.

## O que você faz

| peça | o que mudou | o que você faz |
|---|---|---|
| `<diletta-button>` | eixo `carregando`: pontos, trava de clique, `aria-busy` | os **29** botões de ação assíncrona trocam o `BoldButton` local pela peça |
| `DilettaBrand` | ganhou `copyWith` com os **14** campos | `CoreflowProduto.marcaNo` vira `marca.copyWith(corDoLogo: …)`, e as doze linhas saem |
| `<diletta-icon-button>` | eixo `badge`: 11px, `error`, anel branco **pra dentro** | apague o `.ponto` da sua folha e passe `badge` no sino — as suas duas divergências (9px e `primary`) somem juntas |
| o seu gate da marca | — | **apague a prova 2**, como você mesmo escreveu. A contagem passou a ser minha, e a minha lê o meu arquivo |

**A largura não muda na espera** — é o critério que você mais queria, e virou a asserção 1 do gate:
o rótulo continua na árvore e some por `visibility`, com os pontos por cima. E **a pintura não vira
a de desligado**, porque o `///` do Dart diz *«mantendo a cor do tipo»*: botão que empalidece ao ser
tocado se lê como recusa, não como espera.

O `three-bounce` veio medido, e não por gosto — você disse que não estava pedindo a forma. Ela já
estava no `_ThreeBounce`: ponto **4,8px**, vão **1,92px**, volta **1400ms**, escada de **0,25 de
ciclo**, atrasos negativos pra fila nascer no meio da onda como lá.

## O degrade: a sua suspeita estava errada, e a razão te interessa

Você perguntou se o degrade era tinta sua. **Não é.** `DilettaGradients.brandLiftDe(p)` **deriva da
paleta** — `primary03 → primary05` —, e essa derivação existe por um defeito medido: as três versões
anteriores eram `const` com os hexes do primeiro filho, e **um DS-filho de identidade verde recebia
um card com gradiente AZUL**.

Então o seu `--cps-gradiente-primary` é o mesmo defeito escrito à mão do lado de fora. **Entra como
linguagem, e não nesta tag**: falta a variável CSS emitida, e ela tem que sair dos DOIS emissores —
o meu e o seu `emite_o_css_do_bold.dart` —, senão o seu produto recebe o degradê da paleta de
REFERÊNCIA em silêncio. Uma coisa a seu favor que eu achei medindo: **o `papeis.json` já carrega os
três gradientes resolvidos** (`brandLift`, `screenBg`, `cardPv`), com hex e posição. A perna que
falta é menor do que parecia.

Os três botões ficam locais até lá, com a razão escrita. É mais barato que uma variável emitida com
pressa — e essa frase é da sua casa, não da minha.

## Prazo

Nada aqui é bloqueante seu. O `ref:` sobe quando você quiser; o CHANGELOG da `v0.201.0` tem o resto.
