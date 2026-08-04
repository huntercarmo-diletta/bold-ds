# Pedido · o brilho não é um FEIXE, e ele não tem par claro/escuro

- **filho**: conta-bold-ds v0.10.2
- **pai**: ds-diletta v0.34.0 (`DilettaShimmer`, `DilettaPalette.brilhoDoEsqueleto`)
- **é bloqueante?**: **não** — a `v0.34.0` fez o que eu pedi e a cor chegou. Isto é a metade que o pedido
  anterior não viu: **eu pedi a cor e não pedi a FORMA**, e a forma é o que faz "brilho" parecer brilho

## O que falta, medido em pixel

A varredura de hoje tem **dois stops**: `[cor@50%, cor@10%]` em `[t, t+0.9]`. Com 0.9 de largura sobre um
alvo de largura 1, a banda cobre **a peça inteira** — o que desliza é uma rampa, não um feixe.

Amostrei oito pixels na linha do meio de um esqueleto de 300px, no meio do ciclo:

| modo | pixels de 36% a 64% da largura |
|---|---|
| claro | `236,199,210` · `236,199,210` · `236,199,210` · `236,199,210` · `233,202,211` · `230,204,212` · `227,207,213` · `224,210,214` |
| escuro | `169,132,142` · `169,132,142` · `169,132,142` · `169,132,142` · `157,125,134` · `143,117,125` · `129,109,115` · `115,101,105` |

**Quatro pixels idênticos seguidos, e depois uma queda suave.** Isso é um banho que escorre, não uma luz
que passa. O dono do produto descreveu o que ele espera, e a descrição é a especificação:

> *"o shimmer pode ser como se fosse um feixe de luz rosa passando"*

A forma que o produto tinha antes da adoção, e que o `BoldSkeleton` implementava:

```dart
colors: [cor.withValues(alpha: 0),  cor.withValues(alpha: 0.72),  cor.withValues(alpha: 0)],
stops:  [0.25,                      0.5,                          0.75],
```

**Três stops, transparente nas pontas.** É isso que faz o olho ler "uma luz atravessou" em vez de "o cinza
ficou rosa".

## E a segunda metade: o brilho não tem par de modo

`brilhoDoEsqueleto` é **uma cor**. Todo o resto da receita de material que você abriu vem em par:

| campo | par? |
|---|---|
| `tinteDeVidroClaro` / `tinteDeVidroEscuro` | **sim** |
| `tracoDeVidroClaro` / `tracoDeVidroEscuro` | **sim** |
| `brilhoDoEsqueleto` | **não** |

E a medição acima mostra por que isso importa aqui: a mesma cor sobre `surfaceLoading` **claro** (217) e
**escuro** (82) dá dois resultados distantes — no escuro o pico chega a `169,132,142`, que é um rosa
acinzentado, e a banda "morre" pro fim do sweep (`115,101,105`). No claro ela abre em `236,199,210`.

Não é preferência: **é a mesma razão pela qual o vidro tem par.** O que se vê é a cor MISTURADA com o que
está atrás, e o que está atrás muda com o modo.

## O que eu peço

**1 · A varredura vira FEIXE**, com a forma que o produto já usava: três stops, transparente → cor →
transparente, e a largura da banda menor que a peça. O alpha do centro é forma (é seu); a cor continua
sendo declaração (é minha).

**2 · `brilhoDoEsqueletoClaro` / `brilhoDoEsqueletoEscuro`**, no molde exato do `tinteDeVidro`. Nulo em um
deles cai no outro, e nulo nos dois mantém o neutro de hoje — quem não pediu continua não pagando.

Se a forma do feixe for controversa, a 2 sozinha já vale: com o par eu compenso escolhendo dois rosas
diferentes. Mas aí eu estaria **compensando forma com cor**, e isso é o tipo de contorno que envelhece.

## Por que eu não resolvo sozinho

O gradiente mora dentro do `ShaderMask` do seu widget. Envolver por fora não alcança o shader, e
reconstruir o shimmer aqui seria cópia de componente do pai — foi exatamente o que a adoção **desfez**
neste caso: o `BoldSkeleton` era essa cópia, e ela morreu com razão.

## O que eu já fiz do meu lado

- os 35 esqueletos do app e os **4 que moram no meu pacote** (três no card de saldo, um no cabeçalho da
  home) estão embrulhados no seu `DilettaShimmer` — os 4 daqui eram o que o dono do produto estava vendo,
  porque a home abre no saldo;
- gate de pixel dos dois lados, com **controle**: sem shimmer o esqueleto sai `217,217,217` (R−G = 0), com
  shimmer `236,199,210` (R−G = 37). É esse controle que me deixa afirmar que a cor CHEGA — e é por isso
  que este pedido é sobre forma, e não sobre a cor de novo.

---

## Veredito · ENTRAM os dois, e os dois eram defeito meu de ontem
**pai**: `ds-diletta` v0.35.0 (registrado na v0.35.1) · **data**: 2026-08-03 · **critério**: aplicação

### 1 · A varredura virou FEIXE, e a sua medição é a prova que eu não tinha

Você mediu em pixel o que eu tinha shippado sem olhar: **dois stops, 0,9 de largura sobre alvo de largura
1** — a banda cobria a peça inteira. Quatro pixels idênticos seguidos e depois uma queda suave é exatamente
o que a matemática dizia que ia acontecer, e eu não fiz a conta.

> *"Um banho que escorre, não uma luz que passa."*

Agora: **três stops, pontas em alpha 0, banda de 0,36 da peça**, e o feixe entra e sai (o `t` corre de −0,18
a 1,18, então nos extremos não há luz sobre a peça). O alpha do centro é **0,72** — o que o seu produto já
usava, e o teto do que "luz" suporta antes de virar faixa sólida.

**A divisão que você propôs está escrita no código agora**, porque ela vale além deste caso: *o alpha do
centro é forma (é seu), a cor continua sendo declaração (é minha)* — invertendo os donos, é o que o `///` do
método diz. E a sua ressalva sobre aceitar só o item 2 estava certa em recusar: **compensar forma com cor é o
contorno que envelhece.**

### 2 · O par claro/escuro, e a razão dele era minha

Você não precisou argumentar muito, porque o argumento já estava no meu repo: `tinteDeVidroClaro`/`Escuro` e
`tracoDeVidroClaro`/`Escuro` existem **por esta razão exata**, e eu shippei o brilho com um campo só na
v0.34.0. A sua medição fecha: a mesma cor sobre `surfaceLoading` 217 e 82 dá resultados distantes, porque
**o que se vê é a cor misturada com o que está atrás, e o que está atrás muda com o modo.**

`brilhoDoEsqueletoClaro` + `brilhoDoEsqueletoEscuro`, resolvidos **por modo dentro do scheme** — o componente
recebe a cor certa e não escolhe, igual ao vidro. Nulo em um cai no outro; nulo nos dois mantém o neutro.

### Uma peça pública que eu não queria e a medição pediu

`feixeDoEsqueleto(scheme, t)` é **público**. Forma que só existe dentro de um `shaderCallback` não tem como
ser medida: o callback devolve `Shader`, e `Shader` não conta quantos stops tem. A alternativa era medir
pixel — e **medir pixel aqui é o caminho que já deu imagem vazia nesta família**, no teste de vidro em que o
`toImage` do ambiente quase "provou" um desfoque que não existia. Você mediu pixel no seu lado com asserção
de CONTROLE, que é o que torna a sua medição confiável; eu não tenho controle equivalente aqui, então medi a
forma onde ela é declarada.

### Dois gates meus me pegaram nesta rodada, e vale dizer quais

1. **`6b · MATERIAL SEM LINHA NA DOC`** — campo novo, tabela velha. Um dia depois de eu escrever o gate;
2. **classe 7 da limpa (`versão que mente`)** — eu taggeei a **v0.35.0 sem entrada no CHANGELOG**, porque
   encadeei a escrita do registro com a publicação no mesmo `&&` e a primeira metade morreu num erro de
   encoding. Tag é imutável, então **o registro da v0.35.0 mora na v0.35.1**. A regra 4 é minha e eu a furei;
   o que ficou escrito é que **`&&` não é gate**.

### O que você faz

`brilhoDoEsqueletoClaro` e `brilhoDoEsqueletoEscuro` na paleta (dois rosas ou o mesmo duas vezes), e sobe pra
**v0.35.1**. O seu gate de pixel com controle vale mais que antes: agora ele mede um feixe, e feixe tem
pontas — se a ponta deixar de ser transparente, o R−G do pixel da borda muda e você vê.
