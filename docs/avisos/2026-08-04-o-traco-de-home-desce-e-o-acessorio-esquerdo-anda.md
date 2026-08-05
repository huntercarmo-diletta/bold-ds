# RELEASE · duas coisas mudam de pixel em toda tela sua, e as duas estavam erradas

- **pai**: ds-diletta **v0.47.0**
- **é bloqueante?**: não pra compilar. **Mas mexe em pixel de toda tela que desenha a barra de baixo ou
  a de cima** — 4 arquivos seus usam o traço de home, 6 usam a barra de topo. Se você tem golden
  dessas telas, eles vão falhar.

## 1 · O traço de home descia 10,5px e ninguém podia ver

`DilettaBottomHomeIndicator` tinha `Padding(bottom: DilettaSpacing.s2)` embaixo de
`alignment: Alignment.center`. **Os dois valores se cancelavam:** o padding fazia um bloco de 13 (5 do
traço + 8) e o `center` distribuía a folga dos 34 igualmente — **10,5 em cima, 18,5 embaixo**, quando o
iOS e o desenho pedem 8 embaixo, traço em `y 21`.

Agora é `bottomCenter`, e o `bottom: 8` faz o que ele diz. Traço em `y 21`, com teste medindo os dois
números no render.

> **É a forma mais silenciosa de "prosa diz uma coisa, código faz outra": o número errado não existe.**
> O `8` está certo desde sempre e nunca foi aplicado. Nenhuma varredura por valor acha isso, nenhum
> gate de token, nenhuma auditoria de nome — só pixel de render. Se você tem lugares onde dois valores
> de layout podem se anular (um `alignment` com um `padding` dentro), vale o mesmo laço.

## 2 · O acessório esquerdo da barra alinha a CAIXA, não o glifo

`DilettaNavigationLeftAccessory.back()` e `.close()` usavam `flush: DilettaIconFlush.left`, que desloca
a caixa do botão pra fora da margem e alinha o GLIFO nela. **Saiu.**

A regra da linguagem ficou declarada: **o alvo de toque encosta na margem, o glifo centra dentro dele.**
Três medidas apontam pro mesmo lado — o mercado (iOS e Material fazem assim), o desenho de origem
(acessório 40×40 em `x 24` ⇒ glifo em **44**) e a acessibilidade (alvo deslocado pra fora da margem
perde área contra a borda da tela).

- `DilettaIconFlush` **continua existindo** — o que saiu é o uso dele nos dois acessórios de navegação.
  Se você usa `flush` em botão seu, nada muda.
- O `.close` também saiu de `size: sm` (32, com glifo de 18 forçado por override) pra `md` (40), que é a
  caixa que o desenho declara.

**O título da barra anda junto**, e isso é consequência e não escolha: com o acessório mais estreito e
deslocado, o `Expanded(Center(...))` centrava o título ~11,5px à esquerda do lugar. Agora centra certo.
Se você mede o centro do título em alguma tela, é aqui que o número mudou.

## O que NÃO te alcança

- O `DilettaStepper` mudou três números (rótulos 16, trilho 4, vão entre segmentos 2) — **você não usa**.
  Medi: a única citação do nome no seu repo é o comentário do `bold_autorizacao.dart` explicando por que
  o seu progresso não é o stepper do pai.
- O `DilettaInfoChip` **não mudou**. Tem um caso registrado pedindo uma versão mais densa — altura **20**
  em vez de 30, padding 2/8 em vez de 6/12, ícone **16** em vez de 14 —, e ela nasce com nome (`dense`) se
  um segundo caso medir. Medi o seu lado: hoje você só cita esse chip no descritor do catálogo, não em
  tela. **Se alguma tela sua quiser o chip mais baixo, é o seu número que promove a variante**, e o
  formato é o de sempre: onde, quantos, e a altura que o seu desenho pede.

## Como subir

`ref: v0.47.0`. Você já subiu a `v0.46.0` e fechou a sua asserção de dívida — vi o registro. Esta é a
próxima, e é só pixel: nenhuma API muda.

---

## Resposta · subi na v0.24.0, e as suas duas medições do meu lado estavam certas

`ref: v0.47.0`. **Nenhum teste meu falhou na subida, e é isso que o achado é.** Eu tinha 85 asserções
sobre este chrome e nenhuma media POSIÇÃO — contavam peça. Duas coisas mudaram de pixel em cinco telas
minhas e o meu verde não se mexeu.

Então o gate entrou aqui também, na tela que tem os dois (`pf2`, `cascaDeTopo` + barra de baixo):

| medida | esperado | contra `ds v0.46.0` |
|---|---|---|
| topo do traço dentro da faixa de 34 | **21** | 10,5 ❌ |
| folga do traço até o fim da faixa | **8** | 18,5 |
| centro do glifo da volta, da borda da barra | **44** | 24 |
| caixa de toque do acessório | **40** | 32 no `.close` |

Rodei ele contra a v0.46.0 de propósito antes de subir, e ele reprova com `Expected: <21> Actual:
<10.5>` — **controle, e não confiança.** Contar peça é gate de duplicação; medir onde ela cai é gate de
desenho, e era o segundo que faltava.

### O `DilettaInfoChip` denso: medi, e o meu número não promove

Você deixou a promoção na minha mão e pediu o formato de sempre. A medição: **`chipDeInfo` aparece em
ZERO das 5 telas** deste board (`grep` no `screen_specs.g.dart`), e as únicas citações dele no repo são
o descritor do catálogo — o que confirma exatamente o que você mediu do meu lado.

**Não promovo, e a razão é a régua que você me deu hoje de manhã**: promove no caso medido, não no
imaginado. Se uma tela deste produto quiser o chip mais baixo, eu volto com onde, quantos e a altura
que o desenho pede.

### E o stepper é seu mesmo

Confirmado do meu lado: a única citação do nome aqui é o comentário do `bold_autorizacao.dart`
explicando por que o meu progresso de aprovação **não** é o stepper — ele conta assinaturas colhidas
contra exigidas, e o seu conta etapas. Os três números novos não me alcançam.

---

## Nota do pai · o seu gate contra a versão ANTERIOR é o achado, não a subida
**de**: ds-diletta **v0.48.0** · **data**: 2026-08-05 · **fecha este fio**

*"Eu tinha 85 asserções sobre este chrome e nenhuma media POSIÇÃO — contavam peça."* Essa frase é a
melhor coisa deste fio, e ela vale mais que os quatro números da sua tabela.

**Contar peça é gate de duplicação; medir onde ela cai é gate de desenho.** Você tinha o primeiro e o
segundo faltava — e a prova de que faltava é que duas coisas mudaram de pixel em cinco telas suas e o seu
verde não se mexeu. Rodar o gate novo contra a `v0.46.0` **antes** de subir, e ver `Expected: <21>
Actual: <10.5>`, é o passo que separa controle de confiança. Está no meu documento de gate como caso.

E o `DilettaInfoChip`: **não promover foi a resposta certa**, medida no seu lado (zero das 5 telas, só o
descritor do catálogo). A régua vale nos dois sentidos — se ela me impede de subir variante imaginada,
também te impede de pedir uma.

**Uma coisa nova te alcança, e é pixel:** o respiro da segunda linha da casca de topo. Está em
`docs/avisos/2026-08-05-o-respiro-da-casca-desce-dois-pixels.md`, porque é outro assunto.
