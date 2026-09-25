# PEDIDO · A escala de ilustração não tem meio-passo, e trinta sítios escalam à mão para chegar nele

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` (pino em `packages/coreflow/pubspec.yaml:23`); **medido também na
  `v2.6.0` e na ponta `origin/main`** — e na cópia vendorizada do app, que veio da `v0.204.0`. O
  arquivo é o mesmo nos quatro pontos
- **bloqueante?**: **não** — o produto já chega no número; o que ele não consegue é chegar nele pelo
  nome de um degrau
- **não é peça nova**: o átomo existe, a escala existe. Falta um valor no eixo

## Falta

Um degrau entre `sm` (100) e `md` (200) em `DilettaIllustrationSize`.

## Número

**A escala, e a regra que ela declara** — `packages/diletta_design_system/lib/src/widgets/diletta_illustration.dart:267-277`:

```dart
enum DilettaIllustrationSize { sm(100), md(200), lg(300), xl(400); … }
```

e, três linhas acima (`:264-266`), a razão escrita:

> *«O accessory **só dimensiona** — e só nestes degraus. Sem `double` livre: a escala é fixa
> (consistência > flexibilidade)»*

Byte a byte igual na `v2.5.0`, na `v2.6.0`, na `origin/main` e na cópia que o app vendoriza (avô
`v0.204.0`). **Não existe 150, nem nenhum valor entre 100 e 200.**

**O que o produto pede, contado um a um.** No app do filho B existem **35** sítios que pedem um
tamanho de ilustração. **Nenhum dos 35 nomeia um degrau seu** — os 35 passam um `double` para
`CoreflowIlustracao`, a peça do pai (`packages/coreflow/lib/src/coreflow_ilustracao.dart`), que
embrulha o seu acessório em `SizedBox` + `FittedBox` (`:121-131`) pedindo sempre
`DilettaIllustrationSize.md` (`:128`) e encolhendo por escala.

| número pedido | sítios | é degrau seu? |
|---|---|---|
| **150** | **30**, em **18 arquivos** | **não** |
| 200 | 4 | sim (`md`), escrito como número |
| 88 | 1 | não |
| 100 · 300 · 400 | **0** | sim — e ninguém pede |

Dos 30 sítios em 150, **28 preenchem o slot `illustration:` de um `DilettaEmptyState`**. A sua spec
`design-system-illustration` diz, em «Escolha»:

> *«`Size.lg` — a arte É a mensagem. Tela de estado vazio, de sucesso, de erro sem saída.»*

**O degrau que a sua spec recomenda para estado vazio é usado em zero dos nossos 28 estados vazios.**

**O número não é gosto do filho B: ele mora no PAI.** O 150 está cravado num construtor com nome da
base white-label — `coreflow_ilustracao.dart:103-104`, `CoreflowIlustracao.estadoVazio` → `tamanho = 150` —,
e `CoreflowIlustracao` é o **único** consumidor do `DilettaIllustrationAccessory` em todo o repo do
DS (`grep` em `packages/`: 1 sítio, `:126`). Quem nasce do Coreflow herda o `double` livre: o
`norte_benk_coreflow`, irmão de 17/09, já herdou.

**Dois sítios mostram o nome apertando.** O nome `estadoVazio` é a única porta para o 150, e ele já
mente ou é desviado:

- `parear_dispositivo_screen.dart:704` — usa `.estadoVazio` num **cartaz** (tela 1 de «Novo aparelho
  detectado»), que não é estado vazio nenhum;
- `estados_notificacoes.dart:107` — escreve `tamanho: 150` **cru**, dentro de um `EstadoErro` montado
  à mão, porque ali o nome mentiria.

**E o produto já publicou o 150 como se fosse degrau**: o catálogo do Bold oferece a ilustração com
`PropDef('enum', options: ['150', '200', '300'])` — `packages/catalog/lib/ds_do_bold.dart:2050`. Três
valores, e só um deles é seu.

## Já tentei

1. **O `lg` (300), que é o que a sua spec manda para estado vazio.** Medido na jornada de parear
   aparelho: no primeiro retrato, em 300, os passos 2 e 3 da tela caíam **abaixo da dobra**
   (`parear_dispositivo_screen.dart:803-805`). O desfecho foi mais duro que trocar de degrau — em
   25/09 a arte saiu inteira daquela tela, e com ela o único sítio do app em
   `DilettaIllustration.phoneApproach`.
2. **Dar um nome ao número dentro de casa.** Feito, e é o `.estadoVazio` do pai. A razão escrita na
   peça (`coreflow_ilustracao.dart:100-102`) era *«se ela fosse apagada sem o nome, o 150 se
   espalharia por 11 chamadas e a próxima tela escolheria outro»*. **O nome segurou o espalhamento e
   não segurou o crescimento**: aquele comentário diz 11 telas, e hoje são 30 sítios em 18 arquivos.
3. **O que NÃO tentei, e digo**: o `sm` (100) nos 28 estados vazios. Não foi medido em tela nenhuma.

## Conferi no pai

- `DilettaManifesto.busca(…)`, rodada no pino `v2.5.0`, **com acento**:
  - `busca('ilustração')` → **2**: `design-system-empty-state` e `design-system-illustration`. Li as
    duas: nenhuma tem meio-passo, e a segunda é a que manda `lg` no estado vazio;
  - `busca('tamanho de ilustração')` → **0**; `busca('escala de ilustração')` → **0**;
    `busca('degrau de tamanho')` → **0**; `busca('illustration size')` → **0**.
- **Contrato** de `specs/design-system-illustration/spec.md`: `"eixos": {"Size": {"valores":
  ["sm","md","lg","xl"], "default": "lg"}}`. Idêntico na `v2.5.0` e na `v2.6.0`.
- `DilettaEmptyState` (`diletta_empty_state.dart:40/51/84-85`) recebe `illustration` como `Widget?` —
  **slot livre, sem tamanho**. Quem dimensiona é o chamador, e é por isso que o buraco cai sempre do
  lado de cá.
- As suas próprias peças usam só as pontas: `diletta_promo_banner.dart:114` → `sm`;
  `diletta_notice_banner.dart:59` → `md`; `diletta_sdk_screen.dart:44` → `md` por default. Nenhuma
  pede algo entre os dois — e nenhuma delas é um estado vazio de tela cheia.
- `figma/vocabulario-comum.json:173-190`: `sm`/`lg`/`xl` pareados com `100px`/`300px`/`400px`,
  decidido em 19/08 com a regra *«A moeda do par é o NÚMERO, não o rótulo»*. Um degrau novo entra
  nessa moeda sem inventar convenção.

## Derivável?

**O método, sim — e é seu. O valor, não, e é seu também.**

O meio-passo já é um gesto desta linguagem, e está escrito três vezes em `diletta_metrics.dart`:

| degrau | o que o comentário diz |
|---|---|
| `s0_5 = 2` (`:11-12`) | *«micro (offset de badge, ajuste fino). **Meio-passo**»* |
| `s1_5 = 6` (`:17-18`) | *«gap apertado (entre 4 e 8). **Meio-passo**»* |
| `s14 = 56` (`:44-46`) | *«o degrau entre 48 e 64. **Ele faltava, e um filho escrevia `56.0` cru**»* |
| `s30 = 120` (`:58-60`) | *«Mesma grade, **degrau que faltava** entre 96 e 160»* |

A linha do `s14` é literalmente o nosso caso, com outro número: um filho escrevendo o valor cru
porque o degrau não existe. O que peço é o mesmo movimento, no eixo `Size` da ilustração.

**Agora a parte que enfraquece o meu número, e eu prefiro escrevê-la a deixar você achá-la.** O 150
**não veio de medição**. Rastreei: ele nasce em `lib/design_system/widgets/bold_empty_state.dart:67`
do app — `BoldIllustration(illustration!, size: 150)` —, cravado antes da adoção do DS, e
sobreviveu a três mudanças de casa sem que ninguém o medisse. Ele também **não cai na grade que você
declara**: `diletta_metrics.dart:7` diz *«Base 4 (Material/Apple)»*, e 150 ÷ 4 = 37,5. Os quatro
degraus da escala de ilustração são múltiplos de 4; o meu número não é.

Pela sua própria régua do spot herói (08/08, `v0.61.0`) — *«sem número medido, o número da família
ganha»* —, **o valor é seu para escolher, não meu para trazer**. Se sair 160 (`DilettaSpacing.s40`),
o produto se move: 10 px em 30 sítios é reflow, não redesenho, e eu conto os sítios que quebrarem.
O que o produto não consegue sustentar é o que tem hoje — um `double` livre na base compartilhada,
exatamente o que a sua escala existe para não ter.

## Se você disser não

O `double tamanho` fica em `CoreflowIlustracao` (`:112`), no pai white-label, e todo filho que nascer
do Coreflow nasce com um botão que a sua linguagem decidiu não ter. O `.estadoVazio` continua sendo o
nome de um número, mentindo em 1 dos 30 sítios e sendo desviado em outro. O catálogo do Bold continua
publicando `['150','200','300']` como se fosse escala.

E fica escrito aqui que a divergência é declarada, não descuido: os 28 estados vazios deste produto
não usam o `lg` que a sua spec recomenda, e a razão medida é a dobra.

## Não estou pedindo

1. **`double` livre no acessório** — o oposto. Este pedido existe para que o nosso possa sair.
2. **Os 88 do cartão promocional da home** (`home_tab_redesign.dart:439`) — **um** sítio, sem
   medição, e a sua `DilettaPromoBanner` já resolve aquele bloco em `sm` (100). Um sítio não é
   discordância; se ele voltar acompanhado, é outro pedido.
3. **Mudar a recomendação de `lg` para estado vazio na spec.** Eu trago a medição (28 × 150 contra
   0 × 300, por dobra); qual degrau a spec passa a recomendar é seu.
4. **Arte nova.** Nenhuma ilustração falta neste pedido.
5. **A variante do Figma.** O `vocabulario-comum.json` é o pareamento com o arquivo do filho A, e eu
   não o medi — só cito a regra da moeda.

## Como o pai vai saber que funcionou

Do seu lado: o eixo `Size` do contrato de `design-system-illustration` ganha um valor, o gate da spec
aceita, e o degrau novo entra no `vocabulario-comum.json` pela moeda do número.

Do nosso, e é verificável por `grep`:

- `CoreflowIlustracao` perde o campo `final double tamanho` (`:112`) e os dois defaults `= 300`
  (`:86`, `:94`);
- somem o `SizedBox` + `FittedBox` de `:121-131` — a conversão *«entre uma escada e um número»* que o
  próprio comentário diz não ser desenho;
- os **30** sítios em 150 passam a nomear o degrau, e o `tamanho: 150` cru de
  `estados_notificacoes.dart:107` some;
- os **4** sítios em 200 passam a dizer `md` em vez de repetir o número;
- o `['150','200','300']` de `ds_do_bold.dart:2050` vira o seu enum, e o catálogo volta a publicar a
  escala da linguagem em vez de uma lista do produto.

## Como cheguei aqui

A Agatha pediu a medição em 25/09, a partir da jornada de parear aparelho: o app escalava à mão e o
arquivo do Figma escalava à mão, cada um por conta, para chegar no mesmo número. Fui medir o alcance
e a premissa mudou de forma duas vezes — a tela que originou a pergunta **perdeu a arte** em 25/09, e
o número que eu ia defender como decisão do produto **é herança sem medição**. Os dois fatos estão
escritos acima, porque um pedido que esconde o segundo volta reprovado.

O que sobrou de pé depois da medição é o que está no título: 30 sítios, 18 arquivos, um construtor
com nome no pai e uma lista no catálogo, todos existindo para produzir um número que a escala não
tem.
