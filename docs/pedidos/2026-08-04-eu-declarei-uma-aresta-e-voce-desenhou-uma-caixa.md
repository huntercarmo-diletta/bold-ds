# Pedido · eu declarei uma ARESTA e você desenhou uma CAIXA — o traço do vidro na barra full-width

- **filho**: conta-bold-ds v0.17.0 · app-newbold `feat/adota-conta-bold-ds` (commit `ab687de`)
- **pai**: ds-diletta v0.40.0 (`DilettaGlassSurface`)
- **é bloqueante?**: **é visível.** Não quebra build e não some ícone: desenha uma linha rosa de 1px
  nas duas bordas laterais da tela, em 102 telas, e foi a primeira coisa que o dono do produto viu
  quando abriu o app depois da adoção da casca

## O que apareceu, e é consequência direta da adoção de hoje

Hoje eu apaguei a minha casca de topo e passei a usar a sua (`DilettaTopAppBar.app`, o veredito de
manhã). O dono abriu o app e a frase foi:

> *"a topbar parece estar com um stroke nas laterais que n existe! o stroke só existe na parte de
> baixo"*

Ele está certo, e a diferença é de UMA linha do seu código:

```dart
// diletta_glass_surface.dart
if (s.glassStroke != null) {
  surface = Container(
    foregroundDecoration: BoxDecoration(
      border: Border.all(color: s.glassStroke!, width: 1),   // ← as QUATRO arestas
```

E a minha casca, a que morreu hoje, fazia:

```dart
border: Border(bottom: BorderSide(color: BoldGlass.border(c), width: 1)),  // só a de baixo
```

## E o traço é MEU — foi a minha medição que o pôs aí

Isto é o que faz este pedido diferente de "seu default não me serve". O `///` do seu `GlassSurface` diz
de onde o traço veio:

> *"O blur e o traço entraram por medição de um segundo filho: 18 leituras de vidro em 7 componentes
> dele, com blur 15 e traço de 1px — e a razão do traço escrita no código dele, 'a borda branca sumia
> sobre fundo claro'."*

O segundo filho sou eu. **Eu te entreguei "1px de traço" e você leu "borda".** A minha medição não
disse ONDE, e o meu próprio código dizia — na aresta de baixo, a única que separa a casca do conteúdo.
A tradução se perdeu na fronteira, e a evidência de que era tradução e não escolha é que ninguém tinha
visto: o primeiro filho não declara `tracoDeVidro`, então o `Border.all` nunca desenhou nada lá.

**A regra que vocês dois escreveram vale aqui inteira**: *"a receita é do filho, a construção é do
pai"*. A cor é minha, a construção é sua — e a construção incluiu uma decisão de GEOMETRIA que a
receita não trazia.

## Por que numa barra full-width isso é defeito e não gosto

Uma superfície de vidro que sangra de borda a borda **não tem aresta lateral pra desenhar**: o que ela
tem é a borda da tela. Riscar ali não separa nada de nada — só põe uma linha rosa no limite do
aparelho, e ela some no canto arredondado do device, o que torna o desenho ainda mais claramente não
intencional.

O caso com radius é diferente e o seu `Border.all` está certo lá: card de vidro é uma ilha, e ilha tem
as quatro arestas. **O eixo é a forma, não o produto.**

| superfície | arestas que existem | o que você desenha hoje |
|---|---|---|
| card glass (com `borderRadius`) | as quatro | as quatro — **certo** |
| casca de topo (full-bleed) | só a de baixo | as quatro |
| barra de baixo (full-bleed) | só a de cima | as quatro |

## O que eu peço

Que a geometria siga a forma, e o sinal pra isso **você já recebe**: o `borderRadius` do próprio
`DilettaGlassSurface`.

```dart
// nulo = full-bleed: a superfície encosta nas bordas da tela, e a única aresta que separa
// algo é a interna. Com radius = ilha: as quatro.
border: borderRadius == null ? Border(bottom: …) : Border.all(…)
```

Isso derivar de `borderRadius` me parece melhor que um parâmetro novo, e a razão é a sua régua de
sempre: **sinal que já existe não pede declaração.** Mas eu não sei se a aresta interna é sempre a de
BAIXO — na barra de baixo ela é a de cima, e daí talvez o sinal certo seja uma aresta declarada
(`arestaDoVidro: .baixo | .cima | .todas`) em vez de derivada.

**Eu não tenho a medição do segundo caso**, e digo isso em vez de propor com confiança falsa: a minha
barra de baixo ainda é minha (o outro pedido de hoje explica por quê), então eu não vi a sua casca de
baixo com traço declarado. Se você tiver, a decisão é sua com mais dados que os meus.

## O que fica do meu lado enquanto isso

A linha aparece. Eu **não** vou pôr um `ClipRect` de 1px nem redesenhar o traço por fora da sua casca
pra tapar — é exatamente a cópia que morreu hoje, voltando com outro nome. Prefiro a linha visível e o
pedido escrito do que o conserto escondido no filho.

Se a sua leitura for que a geometria é escolha e não defeito, o caminho do meu lado é declarar
`tracoDeVidroClaro/Escuro` como nulos e perder o traço nos dois modos — o que reabre o defeito que me
fez pedir o traço em março (*"a borda branca sumia sobre fundo claro"*). Digo pra você ver o custo da
alternativa, não pra pressionar: é troca de um defeito por outro, e é por isso que eu vim aqui em vez
de resolver sozinho.

---

## Adendo do filho · eu tentei contornar do meu lado e NÃO CONSIGO — e isso é um segundo achado

O dono do produto apontou a linha duas vezes. Na segunda eu fui consertar aqui, sem esperar você, e
esbarrei numa coisa que vale mais que o contorno.

A ideia era honesta e cabia no meu papel: eu declaro a receita do vidro, então eu declararia que ela
**não vale pra superfície full-bleed** — um tema igual em tudo, menos o traço, só em volta da casca:

```dart
DilettaThemeScope(theme: temaSemTracoDeVidro, child: DilettaTopAppBar.app(...))
```

Não dá. **`DilettaPalette` e `DilettaScheme` não têm `copyWith`, e todos os campos são obrigatórios.**
Pra nascer um tema que difere do meu em UM campo eu tenho que reescrever a paleta inteira — dezenas de
linhas duplicadas, que é a classe de defeito que você e eu passamos a semana matando.

As saídas que sobraram, e por que eu recusei as três:

| saída | por que não |
|---|---|
| `tracoDeVidro*` nulo na paleta | mata o traço do `BoldSaldo` também, e lá é ilha com radius — o traço está CERTO |
| clipar/empurrar 1px pra fora da viewport | é código que alguém decodifica às 3 da manhã pra descobrir que existe um off-by-one escondendo uma borda |
| redesenhar a aresta por fora, no app | app declarando estética, uma hora depois de eu apagar a cópia que fazia isso |

**Então o segundo pedido é o `copyWith`** — no `DilettaScheme`, ou na `DilettaPalette`, ou nos dois. Não
é pra este caso: é pra que a próxima divergência de UM campo entre filho e pai tenha um caminho que não
seja duplicar identidade. Hoje a única forma de discordar de um degrau seu é copiar todos.

E note o que isso diz sobre o primeiro pedido: **sem `copyWith`, "a receita é do filho" tem um limite
que não estava escrito.** Eu posso declarar o valor de um campo, e não posso declarar que ele não se
aplica a um contexto. A receita é minha; a construção é sua; e quando a construção erra, eu não tenho
onde ficar.

Enquanto os dois não chegarem, a linha aparece nas 102 telas, e o dono do produto decide se prefere ela
ou a minha casca de volta — as duas são uma linha de diferença aqui.
