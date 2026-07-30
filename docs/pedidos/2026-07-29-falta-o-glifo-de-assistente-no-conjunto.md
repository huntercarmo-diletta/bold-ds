# Pedido · falta o glifo de assistente de IA no conjunto de ícones

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.4.0
- **é bloqueante?**: não (funciona hoje com ícone do Material cru, e o custo é esse)

## O que falta

O conjunto de 354 ícones não tem sparkle — o glifo que hoje significa "assistente de IA" em
qualquer produto.

## A medição

Varri o conjunto do pai por `sparkle`, `magic`, `wand` e `awesome`: **zero resultados.**

Neste produto o glifo aparece em **3 lugares** e representa a assistente (Lia):

| onde | como |
|---|---|
| `home_flat_nav.dart` | item da navegação inferior |
| `perfil_tab_redesign.dart` | linha de acesso na aba de perfil |
| `login_recorrente_screen.dart` | tile de entrada |

E em **1 lugar ele ainda é `Icons.auto_awesome_rounded` cru** (`pix_chaves_screen.dart`), que
é o estado anterior: ícone do Material dentro de tela do DS, fora do token, fora do dev mode.
Os 3 primeiros já viraram asset justamente pra sair disso; o quarto é a dívida que sobrou.

Os dois arquivos que este filho desenhou, contra as regras de formato do pai:

| regra do pai | os arquivos |
|---|---|
| quadrado | **ok** — `viewBox="0 0 18 18"` nos dois |
| monocromático (pra o `ColorFilter` pintar) | **ok** — geometria toda em `fill="black"`; o único `fill="white"` é o rect de máscara dentro do `<clipPath>`, resto de export do Figma, e não é geometria |
| dois pesos (light/solid) | **ok** — `sparkles-light-full` e `sparkles-solid-full`, que é a convenção `-full` que o pai já usa em 27 ícones |
| `.svg.vec` pré-compilado | **falta** — os meus são `.svg` cru. A compilação é do pipeline do pai (`vector_graphics_compiler`), não deste repo |

## O que eu faço hoje sem isso, e o que isso me custa

Hoje eu tenho os dois `.svg` no meu conjunto próprio e um mapa de apelido no meu widget de
ícone (`'sparkle'` → `sparkles-light-full`).

O custo é a decisão que isso desfaz: eu tinha acabado de medir que **herdo o conjunto do pai
inteiro** — 310 dos 354 nomes já eram idênticos, e os 44 restantes eram duplicata com sufixo
`" 1"` do export. Manter dois ícones próprios me obriga a manter um conjunto próprio, e um
conjunto próprio me obriga a cobrir os **46 nomes** que os componentes do pai referenciam por
nome — dos quais 6 quebrariam em silêncio pelo sufixo. Ou seja: dois arquivos custam o
contrato inteiro de assets, e o defeito que aparece é ícone errado, que passa por decisão de
design.

## Onde eu ACHO que mora

No pai. A tabela de governança dele já responde: "um ícone novo no conjunto → **pai**, é
vocabulário herdável". E o teste é o de sempre: outro produto ia querer isso? Assistente de IA
não é vocabulário deste produto, é da década.

Se entrar, eu apago os dois arquivos e o apelido, e volto a herdar tudo — o que era a decisão
antes deste caso aparecer.

## Como o pai vai saber que funcionou

Os dois nomes existem em `DilettaIcons.all` e o `minimo_de_assets_test` continua verde (todo
token tem arquivo). Do meu lado, o gate é a ausência: eu deixo de declarar assets próprios, e
o teste que já existe aqui (`o Bold HERDA os ícones do pai sem configurar nada`, que checa
`DilettaAssets.package == 'diletta_design_system'`) continua passando com o glifo em uso.

Anexo: os dois arquivos estão em `conta-bold-ds`, em
`lib/design_system/assets/icons/sparkles-{light,solid}-full.svg`.
