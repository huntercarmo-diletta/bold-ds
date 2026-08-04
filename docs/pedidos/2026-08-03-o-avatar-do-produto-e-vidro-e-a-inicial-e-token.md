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
