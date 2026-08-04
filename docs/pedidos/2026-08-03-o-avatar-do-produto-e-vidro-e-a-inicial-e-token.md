# Pedido · o avatar deste produto é VIDRO, e o tamanho da inicial é TOKEN — as duas medições que você pediu

- **filho**: conta-bold-ds v0.11.0
- **pai**: ds-diletta v0.36.0 (`DilettaAvatar`)
- **é bloqueante?**: **sim para o `AppList`** — a foto destravou 10 dos 11 `custom`, e estes dois são o
  que sobrou entre eles e o `.avatar(...)` do pai

Você pediu o número do `fontSize` (*"com o número, é pedido"*). Ele veio, e no caminho a mesma medição
mostrou uma segunda coisa.

## 1 · O `fontSize` não diverge por RATIO — ele é um TOKEN

Os 8 sítios que passam `fontSize`, medidos contra os seus 40%:

| tamanho do avatar | `fontSize` do app | 40% seriam | sítios |
|---|---|---|---|
| 40 | **15** | 16 | 3 |
| 44 | **15** | 17,6 | 5 |

**O valor é o mesmo nos dois tamanhos.** Não é uma derivação diferente da sua: é o app dizendo que a
inicial é **texto de interface**, e não um glifo que escala com o círculo. 15 é o degrau `labelMd` da
tipografia — os 16 e 17,6 que os 40% produzem não são degrau de escala nenhum.

**Eu não peço o `fontSize` de volta.** Peço o que a medição diz: que a inicial saia de um **papel de
tipografia** e não de uma fração do diâmetro. Se o `DilettaAvatar` escolhesse `label` (ou o degrau que a
sua escala tiver pra isso) em vez de `size * 0.4`, os 8 sítios somem sem prop nenhuma — e o avatar de 64 e
o de 72 (que hoje não passam `fontSize`) passariam a ter inicial legível em vez de gigante.

Se os 40% forem decisão de desenho e não conveniência, quero a frase — e aí eu declaro a divergência do
meu lado, porque com os dois tamanhos em 15 eu não tenho como fingir que 16 e 17,6 são a mesma coisa.

## 2 · E o avatar deste produto é VIDRO

O `BoldAvatar` do app nasce com `glass = true`, e é o material padrão dele: o avatar aparece na barra de
topo, na linha de contato e no comprovante — **sempre sobre a arte**. O seu desenha
`solid ? s.primary : s.surface`.

É a **quinta** peça da mesma classe em dois dias, e as quatro anteriores viraram declaração:
`cardDeVidro` (lista, estado vazio, acesso rápido), o cartão de destaque, e o `brilhoDoEsqueleto…` do
feixe. A pergunta que fecha esta é sua, do veredito do brilho: **quais valores desta construção são do
produto?**

Aqui eu não sei a resposta, e é por isso que não peço um campo novo de cara. As duas leituras possíveis:

- **o avatar é card** — e aí ele deveria montar pelo `DilettaCardSurface` como os outros três, e o
  `cardDeVidro` que eu já declaro resolve sem campo novo;
- **o avatar não é card** — é uma peça de identidade com superfície própria, e aí precisa do seu próprio
  valor, no molde dos outros.

**A primeira me parece a certa** (o círculo é uma superfície de conteúdo, como o card), mas a fronteira é
sua e eu já errei nela hoje — o `FeatureDetailCard` eu li como card e você mostrou que era gradiente de
marca.

## O que trava, e o tamanho disso

Sem uma das duas, os 10 avatares que hoje entram por `LeftAccessory.custom` **não podem migrar pro
`.avatar(...)`**: eles perderiam o vidro sobre a arte. E com eles fica parado o `AppList` — **186 usos**,
o maior componente do app, que fora isso casa 1:1 (as 10 fábricas do middle são idênticas).

## O que eu já fiz do meu lado

- subi pra `v0.36.0` e o `image:` está medido: `ImageProvider?` é o tipo certo, e as iniciais não ficarem
  por baixo da foto é a decisão que eu não teria tomado e concordo — **círculo vazio é sinal**;
- a classificação da B2 inteira está no `tasks.md` do app, e o `AppList` é a única linha dela que muda de
  status com este pedido.

---

## Veredito · os dois ENTRAM. A sua leitura do número está errada, e o defeito que ela achou é maior
**pai**: `ds-diletta` v0.37.0 · **data**: 2026-08-03 · **critério que pesou**: aplicação

O `AppList` destrava. As duas coisas que faltavam chegam nesta tag, e nenhuma delas é prop nova.

### 1 · A inicial vira degrau. Mas ela não é constante — e o 17,6 é que era o defeito

**A sua leitura não se sustenta, e é uma armadilha de amostra:** 40 e 44 são vizinhos, e **qualquer escada dá
o mesmo degrau pros dois**. Dois tamanhos a 4px de distância caindo no mesmo valor é o que se espera de uma
escada, não prova de constante — e constante de verdade faria um avatar de 96 carregar a letra de um de 24, o
que não é o que você quer nem no seu próprio pedido (você reclama justamente do 64 e do 72).

O que a sua medição prova é mais estreito e mais útil: **40 e 44 são o MESMO degrau.** E provou também o que
você achou de passagem, que é o defeito de verdade e é meu:

> **`size * 0.4` num avatar de 44 dá 17,6.** Um DS que proíbe cor crua e CALCULA tamanho de fonte está sendo
> incoerente com a própria regra. Tipografia é degrau, não fração.

Então saiu a fração e entrou a escada, cinco degraus escolhidos pelo diâmetro, todos `w600` — o círculo muda
de tamanho, a inicial não muda de voz:

| diâmetro | degrau | tamanho |
|---|---|---|
| < 28 | `label` | 12 |
| 28–39 | `subheading` | 14 |
| **40–55** | **`heading`** | **16** |
| 56–79 | `title` | 22 |
| ≥ 80 | `headlineMd` | 28 |

**Uma correção na sua premissa:** *"15 é o degrau `labelMd` da tipografia"* — é da SUA. Aqui `labelMd` é **12**,
e 15 é `button`, que é papel de botão e não de identidade. E 16 **é** degrau desta escala (`heading`); off-scale
era só o 17,6. Então os seus 8 sítios somem sem prop nenhuma, e o que eles ganham é **16 no lugar de 15** — um
pixel, e ele é a diferença entre a sua escala antiga e a que você adotou. Se um dia 15 for degrau daqui, uma
linha de teste cai e o degrau muda junto.

O que muda de verdade é o que você reclamou e não mediu: **64 e 72 vão de 25,6/28,8 pra 22.**

O gate não pergunta "qual é o tamanho". Ele varre de 16 a 128 e pergunta **se o tamanho existe na escala**, com
a escala lida do arquivo de tokens — é o que impede isto de voltar como `* 0.35`.

### 2 · O avatar É card, e o `cardDeVidro` que você já declara resolve

Você acertou a leitura, e a razão que fecha é a sua própria frase de dois dias atrás: **dois materiais na mesma
dobra é pior que os dois errados iguais.** Card de vidro com avatar de branco opaco sobre a mesma arte é
exatamente isso — e o que decide não é o avatar ser um retângulo ou um círculo, é ele ser **superfície de
conteúdo**. Raio igual à metade do diâmetro numa caixa quadrada é o círculo, então nem forma nova existe aqui:
o avatar de contorno monta pelo `DilettaCardSurface` como os outros três.

**Nenhum campo novo na paleta.** É a quinta peça da família e a primeira que a pergunta do veredito do brilho
resolve sozinha: *quais valores desta construção são do produto?* Aqui, nenhum novo — o material já estava
declarado, faltava a peça lê-lo.

Duas fronteiras que eu declaro, e as duas com o critério do `FeatureDetailCard`:

- **o `solid` não vira vidro** — preenchimento de marca não é material, e vidro descartaria a cor em silêncio;
- **a foto também não** — vidro sob imagem opaca não aparece e cobraria um `BackdropFilter` **por linha**, na
  linha que tem 186 usos no seu app. A foto É a superfície.

### O que fica pra você

1. os 10 avatares saem do `LeftAccessory.custom` e o `AppList` roda — sobra o 11º, o badge em `Container`, e
   ele continua sem fábrica pela sua régua (*um caso não vira fábrica*);
2. os 8 `fontSize:` saem das chamadas. Se o 16 no lugar do 15 aparecer num print e incomodar, **é medição e eu
   quero** — mas aí o pedido é sobre a escala, não sobre o avatar.

Chega pela tag **v0.37.0**.
