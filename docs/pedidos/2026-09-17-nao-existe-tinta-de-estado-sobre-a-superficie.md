# PEDIDO · Três dos quatro pares declarados de estado não passam — e o enquadramento anterior deste pedido estava errado

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não** — declarado como dívida no consumidor, 28 regras, catraca nos dois
  sentidos e nos dois modos.

> **CORREÇÃO, escrita no mesmo dia.** A primeira versão deste pedido dizia que *quinze sítios põem
> `warning` ou `success` **direto sobre a página***. O número e o enquadramento estavam errados, e o
> erro era da nossa régua: ela media toda tinta contra `--cps-surface`, inclusive a que vive dentro
> de uma peça que pinta o próprio fundo. Consertamos a régua e remedimos. **O achado ficou mais
> forte, não mais fraco** — e mudou de assunto: não é papel faltando para um caso nosso, é par
> declarado que não passa.

## O achado, agora medido contra o fundo que está mesmo atrás

O `///` do `warning` diz que ele é *«calibrado pra ser FUNDO de tag e tinta de glifo»*. Fomos medir o
glifo sobre a tag — o par que você declara — e estendemos aos quatro:

| tinta sobre a SUA pastilha | claro | escuro |
|---|---|---|
| `warning` sobre `warningSubtle` | **1,94** ✗ | 3,67 ✓ |
| `danger` sobre `errorSubtle` | 6,05 ✓ | **2,77** ✗ |
| `primary` sobre `primarySubtle` | 7,13 ✓ | **2,94** ✗ |
| `success` sobre `successSubtle` | 3,90 ✓ | 3,42 ✓ |

Piso de glifo é 3:1. **Três dos quatro reprovam**, cada um num modo diferente — e nenhum dos três
reprova no modo em que alguém iria procurar.

Medido no navegador, no alerta e no banner do consumidor, contra o `backgroundColor` computado do
ancestral que pinta — não contra token lido de folha.

## O que o seu próprio app faz, e que nós não fizemos

O `bold_alert` do app do Conta BOLD não põe o tom base como glifo solto. Ele carrega **cinco** papéis
por intenção:

```dart
BoldIntent.warning => (warning04, warning07, warning05, warning02, warning05)
//                     spot        wash      borda     título-claro  título-escuro
```

O tom base vai no `BoldSpotIcon` — que tem **fundo próprio**, então o glifo não está sobre a wash — e
o texto no claro usa `warning02`, um degrau escuro. **Glifo do tom base sobre a wash não existe lá.**
Nós fizemos isso, e foi o nosso erro. Mas a medição mostra que o par, se alguém o usar como o `///`
descreve, não fecha.

## Os nove que estão mesmo sobre a página

Corrigindo o número da primeira versão: sobre `--cps-surface` são **nove**, não quinze — cinco de
`warning` (2,08) e quatro de `success` (4,04), no claro. Os outros vivem sobre pastilha ou vidro da
própria peça, e são os da tabela acima.

Para esses nove o pedido original continua de pé, e o argumento é o seu, escrito duas vezes:

> *«um token não serve duas exigências de contraste ao mesmo tempo»*
> *«não é igual a nenhum papel existente em AMBOS os modos, e é por isso que ele precisa de nome
> próprio em vez de reaproveitar um»*

Foi assim que nasceram o `onSubtle` e o `Grafico`. Mas depois da correção achamos que **o primeiro
pedido é o outro**: não adianta um quinto papel se três dos quatro pares já declarados não fecham.

## O pedido, em duas partes e nesta ordem

**1. Medir os quatro pares declarados nos dois modos.** `xSubtle` × tom base, que é o par que o `///`
do `warning` descreve e que as tags e os alertas usam. Se a sua medição confirmar os nossos números,
os degraus precisam se mover — como o `warningGrafico` moveu quando a Aurora reprovou.

**2. Depois disso, a tinta de estado sobre a superfície**, para os nove que sobram.

## O que fizemos enquanto isso

Nada na tinta, de propósito. Consertamos a **régua**: ela agora sobe pelo seletor procurando quem
pinta, e quando não sabe, diz que não sabe em vez de presumir a página. A dívida foi refeita a partir
da medição — 28 regras, com o fundo escrito em cada linha, porque *«reprova»* sem dizer contra o quê
foi exatamente o que produziu o erro desta primeira versão.

E ficou uma lição que talvez sirva do seu lado, porque ela não é sobre cor: **uma régua que presume o
fundo produz uma crença.** A nossa dizia «o escuro foi revisado, o claro não» — e essa frase entrou
em commit, em pedido e no nome de uma constante, antes de alguém perceber que era artefato da
medição, não do produto.
