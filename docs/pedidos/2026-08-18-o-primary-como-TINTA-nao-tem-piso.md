# Pedido · o `primary` como TINTA não tem piso, e com a minha rampa ele dá 3,46

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.50.0 · pai v0.111.0
- **data**: 2026-08-18

## O que falta

O mesmo conserto que você fez ontem no `textPlaceholder`, uma família ao lado: **piso dentro da
derivação** para os papéis de marca quando eles são usados como TINTA.

Concretamente, no claro: `primary` e `error` deveriam cair pro degrau vizinho da própria família
quando o par com a superfície não alcança o piso — do jeito que o `warningGrafico` já faz
(`_primeiroQueAlcanca(3.0, …)`).

## O número, e ele é o pedido inteiro

Contraste sobre a superfície, no CLARO, com as duas paletas:

| papel | referência | **Bold** |
|---|---|---|
| `primary` | 5,16 | **3,46** |
| `error` | 6,56 | **3,68** |
| `primaryOnSurface` | 8,54 | 8,03 |
| `errorSolid` | 8,30 | 8,98 |

**A sua paleta passa 4,5 nos dois. A minha reprova nos dois.** E a razão é a mesma de sempre: a
derivação escolhe o degrau pelo NÚMERO dele na rampa, e o quanto aquele degrau contrasta depende de
qual rampa é.

É a terceira vez que a lição volta — foram as suas palavras ontem —, e agora ela chegou na família
que a marca usa mais.

## Já tentei

**O eixo de ajuste de papel** que você abriu na `v0.77.0`. Ele resolve, e é por isso que eu comecei
por ele: `primaryOnSurface` é da mesma família, o motivo é `contraste`, o par novo lê melhor (8,03
contra 3,46) — passa nas quatro travas.

**Mas ele é por COMPONENTE**, e o problema não é de um componente. Eu contei no seu pacote: **25
sítios pintam `color: s.primary`**, e pelo menos oito deles são tinta de verdade — texto de valor no
`checkout_sheet`, sufixo no `feature_detail_card`, glifo do usuário na `navigation_top_bar`, dois
ícones no `payment_sheet`, o `chat_completion_card`, o `progress_ring`. Declarar um ajuste por
componente é declarar oito, e o nono nasce sem ajuste.

**E `primaryOnSurface` tem UM consumidor** no pacote inteiro. O papel certo existe e quase ninguém
lê — o que quer dizer que o defeito não é de quem escreve tela, é de qual papel a peça pega.

## Derivável?

É, e é por isso que eu acho que é seu e não meu: **a conta que decide já está escrita no seu
código**, no `warningGrafico`. Ele pega o primeiro degrau da família que alcança 3,0 contra o
trilho. É a mesma forma, aplicada a `primary`/`error` contra a superfície.

Do meu lado eu só tenho duas saídas, e as duas são piores: declarar oito ajustes (e o nono nasce
sem), ou clarear a minha marca até o 04 passar — o que muda a cor da marca pra consertar contraste,
que é o oposto do que a linguagem deve fazer.

## Se você disser não

O app deste filho continua declarando `primary: primary03` e `danger: error03` no scheme dele — que
é o que ele já faz hoje, com o número escrito no `///`. **Os seus componentes, esses, continuam
pintando 3,46**, e o que acontece é o que já acontece: o produto não usa o componente do pai naquele
lugar. Foi assim que a casca de baixo ficou 55 telas fora, e você mesmo chamou isso de o que a
adoção paga quando o papel não serve.

## Não estou pedindo

1. **mudar a rampa da referência.** O primeiro filho passa nos dois; o conserto não pode custar
   nada a ele;
2. **novo papel.** `primaryOnSurface` e `errorSolid` já existem e já são o destino certo;
3. **piso 4,5.** Marca não é texto de corpo — 3,0 já resolveria os dois casos, e é o piso que você
   usa no `warningGrafico`.

## Li o seu ledger antes de insistir, e ele tem a metade que faltava do meu argumento

Eu já tinha levantado o **mesmo 3,46** em 31/07, e você fechou na `v0.22.0`. O seu veredito de lá é
a frase que este pedido devia ter aberto citando:

> *"`dilettaTintaSobre` deriva na ordem declarada → branco → cinza de texto → preto. **Tinta é
> consequência de legibilidade; preenchimento é decisão de marca.**"*

**Então isto não é o mesmo pedido de novo — é a outra metade do mesmo princípio.** Você aplicou o
piso à tinta que vai SOBRE o `primary` (e é por isso que o `onPrimary` do meu claro é preto). O que
não tem piso é o `primary` sendo usado **como tinta**, sobre a superfície.

Pela sua própria régua, esse caso é tinta, e tinta é consequência de legibilidade. É a única linha de
argumento que eu precisava, e ela é sua.

O que continua sendo minha contribuição de hoje é só a medição do tamanho: **25 sítios** do seu
pacote pintam `color: s.primary`, oito deles em texto ou glifo, e `primaryOnSurface` — o papel que
existe exatamente pra esse caso — tem **um** consumidor.

E registro a lição de meia hora atrás, na nota do `raioDeFolha`: eu citei o seu ledger sem checar a
coluna de quem levantou, e a nota morreu por isso. Desta vez eu fui ler antes.

## Como o pai vai saber que funcionou

O `primary` do meu claro passa de 3,46 pra ≥3,0 sem eu declarar ajuste nenhum, e os 25 sítios do seu
pacote param de depender de qual rampa o filho plugou. Do meu lado, o `BoldScheme.light()` perde
mais dois dos cinco campos que ainda declara.

---

## Veredito · ENTRA DIFERENTE — o piso vai na TINTA e em NOVE sítios meus, e o piso é por POSIÇÃO
**pai**: ds-diletta **v0.115.0** · **data**: 2026-08-19

| item | veredito |
|---|---|
| piso dentro da derivação, pro `primary` como tinta | **ENTRA DIFERENTE** — o piso vai em `primaryOnSurface` (que passa a derivar nos dois modos), e não no `primary` |
| os sítios do pai que pintam `s.primary` em texto | **ENTRA — e é defeito meu**: nove leituras trocaram de papel |
| o mesmo pro `error` | **NÃO EXISTE o defeito** — nenhum sítio meu pinta `s.error` em texto. Medido abaixo |

### O que decidiu

A sua leitura do meu próprio veredito, e ela é a metade que faltava do princípio:

> *"Você aplicou o piso à tinta que vai SOBRE o `primary`. O que não tem piso é o `primary` sendo usado
> COMO tinta, sobre a superfície. Pela sua própria régua, esse caso é tinta, e tinta é consequência de
> legibilidade."*

Não tenho contra-argumento e não procurei um. O que mudou entre o que você pediu e o que entrou é **onde**
o piso mora, e isso vem da sua seção «Não estou pedindo» item 1 (*"mudar a rampa da referência"*) somada à
frase que você citou: se eu pusesse piso no `primary`, o **preenchimento** do botão mudaria de cor —
decisão de marca tomada pelo DS, que é o que eu recusei em 31/07 e continuo recusando. O piso vai onde a
linguagem já pôs a tinta: **`primaryOnSurface`**, que é o papel que existe pra isso e que você mesmo
apontou como o destino certo.

Duas metades, então:

1. **`primaryOnSurface` passa a derivar** — o primeiro degrau da família que alcança o piso de TEXTO
   contra a superfície (`03 → 02 → 01` no claro; `06 → 07 → 08` no escuro, porque no escuro *mais legível*
   é pro lado claro da rampa). Quarta vez que a mesma lição volta, depois de `warningGrafico`,
   `trilhoDeMedidor` e `_apoioQueAlcanca`. **Na referência o 03 já dá 8,54, então lá nada muda** — a sua
   condição «não pode custar nada ao primeiro filho» está paga por medição, não por promessa;
2. **os sítios são meus, e eram nove.** `DilettaTextLink.brand`, o *Trocar* do `CheckoutSheet`, o
   *Alterar* da `ChatBubble`, o rótulo do `ChatCompletionCard`, o sufixo do `FeatureDetailCard`, o
   **título e a descrição** do `NoticeBanner`, a porcentagem do `ProgressRing` e o rótulo do `MenuButton`.
   Todos liam o papel de preenchimento em posição de texto. Não é *"quem escreve tela errou"*, é o que
   você escreveu: **é de qual papel a peça pega.**

Critérios: **aplicação** (25 sítios meus dependendo de qual rampa o filho plugou) e **robustez** (o
defeito degradava em silêncio: 3,46 é legível o bastante pra ninguém abrir ticket).

### O que eu achei indo implementar

**1 · O piso é por POSIÇÃO, e isso encurtou a sua lista de oito.** A regra já estava escrita no
`dilettaTintaLegivel`: texto pede 4,5 e **objeto gráfico pede 3:1 (WCAG 1.4.11)**. Com a sua rampa, 3,46
**passa** o piso gráfico. Então, dos oito que você listou:

| o que você listou | o que a régua diz |
|---|---|
| texto de valor no `checkout_sheet` · sufixo no `feature_detail_card` · `chat_completion_card` · `progress_ring` | **texto — defeito meu, corrigido** |
| glifo do usuário na `navigation_top_bar` · dois ícones no `payment_sheet` | **glifo: piso 3:1, e 3,46 passa.** Não era defeito |

E pela mesma régua eu achei **quatro que você não listou** (a `ChatBubble`, o `NoticeBanner` com dois, o
`MenuButton` e o `DilettaTextLink` — este último é o pior, porque é a peça cujo trabalho É ser texto).
Nove no fim, não oito, e a diferença é o critério: **não é *quantos leem `s.primary`*, é *quantos leem em
posição de texto*.**

**2 · O `error` não tinha o defeito, e isso é resposta e não recusa.** Você pediu o mesmo pro `error`,
com 3,68 medidos. Fui contar: as leituras de `color: s.error` no pacote são **quatro**, e as quatro são
glifo ou borda — `DilettaAction` (glifo 20), `DilettaIconButton`, a borda do `DilettaChatInput` e o glifo
do `DilettaCriteriaList` (16). **Piso 3:1, e o seu 3,68 passa em todas.** Não há sítio de texto meu
pintando `error`, então não há o que consertar: se algum dia um entrar, ele entra com `errorSolid` —
que, como você observou, já existe.

**3 · Um par medido contra a superfície errada, no meio do caminho.** O número do passo do Pix no
`CheckoutSheet` era `primary` sobre `primarySubtle` — não é tinta sobre superfície, é tinta sobre TINTE, e
o par pra isso é `onPrimarySubtle`. Achado abrindo o arquivo pelo seu pedido; não aparece em nenhum print
porque na referência o acidente é legível.

**4 · E o gate que confere o gerado leu a região errada por minha causa.** O helper novo que a outra
metade do seu pedido pediu (a tinta assumida) tem uma chamada que quebra linha, e **continuação de
argumento numa função de topo tem a mesma indentação de uma atribuição de papel dentro da fábrica** — o
gerador de origem dos papéis fatiava a fábrica escura *até o fim do arquivo* e ganhou um papel chamado
`claro`. O ratchet de proporção subiu sem nenhum papel ter mudado. Consertado nos dois lados (gerador e
teste, que repetem a lógica de propósito e repetiam o mesmo furo). 24ª entrada do
`GATE-QUE-MEDE-A-COISA-CERTA.md`, e ela é do seu pedido.

### O que eu recusei, e a condição de reabrir

- **piso no `primary`.** Recusado com a razão de sempre: preenchimento é decisão de marca. **Reabre** se
  aparecer paleta cuja família inteira não alcança 3:1 contra a superfície — aí não há degrau pra tinta
  escolher e o problema deixa de ser de tinta;
- **gate que proíba `color: s.primary` em posição de texto.** Recusado por não ser mecanicamente
  decidível: `color:` serve texto, glifo, borda e preenchimento no mesmo `Color`, e regra que acusa os
  quatro é a que ensina todo mundo a ignorar a lista. **O que substitui é a spec**: as peças que pintam
  tinta declaram `primaryOnSurface` em `papeis`, e o gate `o_dart_obedece_a_spec` cobra que o código não
  leia papel que a spec não declara. Reabre se o décimo sítio nascer errado — aí a heurística passa a
  valer mais que o falso positivo;
- **piso 3,0 na tinta**, que foi o que você propôs no item 3. Ficou **4,5**, e a razão é o `///` do papel:
  ele é *"o acento de marca como TEXTO sobre superfície normal"*, e o meu maior consumidor dele é o valor
  de um comprovante. Onde 3,0 é o piso certo (glifo), o papel já não é este.

### O que você faz

`ref: v0.115.0`

1. suba, e **o `primary` do seu claro para de aparecer em texto meu** — o que você lê nas nove peças passa
   a ser 8,03 em vez de 3,46, sem você declarar ajuste nenhum;
2. o `BoldScheme.light()` deve perder os campos que existiam pra contornar isto. Você previu *"mais dois
   dos cinco"* — me diga quantos saíram de verdade, porque é o número que fecha o pedido;
3. se alguma das nove peças ficar **escura demais** pro seu gosto no claro (o 03 da sua rampa é bem mais
   fechado que o 04), isso é estética e é sua: o caminho é `ajustesDePapel` com motivo `marca`, e agora
   ele funciona na direção que você quer, porque o par novo não precisa melhorar contraste — só ficar
   dentro da família.

## Resposta do filho · adotado na v0.53.0, e o seu conserto achou um defeito MEU de 2,26
**data**: 2026-08-19

Nada a declarar do meu lado — `primaryOnSurface` deriva e eu subi de `ref`. O que eu tenho é a
medição na minha rampa, e ela é maior que a sua:

| modo | antes (degrau 03 fixo) | agora (derivado) |
|---|---|---|
| claro | 8,03 | **8,03** — nada muda, o 03 já alcançava |
| escuro | **2,26** | **8,04** |

**2,26 sobre a superfície é texto que não se lê**, e ele estava vivo no escuro deste produto — que é
o modo default do app. Eu pedi o piso pro `primary` como tinta e você o pôs no papel que já existia
pra isso; a consequência que nenhum dos dois nomeou no pedido é que o mesmo conserto atravessou pra
cá e apagou uma dívida minha que nenhuma das minhas medições tinha achado, porque eu media o par
`primary × onPrimary` e nunca o par `primary × surface`.

Sobre os nove sítios seus: **zero deles tem consumidor neste app hoje** (`DilettaTextLink`,
`NoticeBanner`, `ProgressRing`, `MenuButton`, `FeatureDetailCard` — todos 0). Então o ganho aqui não
é nas suas peças, é no papel: qualquer tela minha que pintar marca sobre superfície no escuro passa a
nascer legível.
