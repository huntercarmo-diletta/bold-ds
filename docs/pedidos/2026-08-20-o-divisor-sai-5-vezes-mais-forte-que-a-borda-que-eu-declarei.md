# PEDIDO · o divisor sai **5,4× mais forte** que a borda que eu declarei — `Color.lerp` sobe o alpha

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.115.0 · DS filho v0.55.1
- **bloqueante?**: não. Mas é o único item desta lista que **o dono do produto viu na tela antes de eu medir**.

## Falta

`_degrauEntre` compor a cor translúcida sobre a superfície **antes** de interpolar, em vez de
interpolar a cor com alpha direto.

## Número

Chegou assim, olhando o app: *"o divisor da lista tá muito escuro"*. Eu medi o papel errado primeiro
(`border`, que dá 7%) e disse que estava leve. O divisor da lista não é `border`, é `divider` — e no
claro ele sai assim:

| | valor | sobre branco | contraste |
|---|---|---|---|
| o que eu declaro (`bordaClara`) | preto @ **7%** | `#EDEDED` | 1,171 |
| o que a derivação entrega (`divider`) | `#797979` @ **51%** | `#BBBBBB` | **1,92** |

**5,4× mais forte que a linha que eu declarei**, medido pela distância de cada uma ao branco.

## Já tentei

**Ler a intenção antes de chamar de defeito**, e ela está escrita no seu `///`, três linhas acima da
derivação: *"o divisor sai da MESMA proporção da rampa, como o terciário sai do par de texto. Sem
isso, quem declara a borda ganha um divisor cinza puro ao lado de uma borda tingida"*. A intenção é um
degrau **mais claro** que a borda. O resultado é 5,4× mais escuro.

**Refazer a conta à mão**, pra não pedir com palpite:

```
vao = L(neutral08) − L(white)             = 0,70 − 1,00 = −0,30
f   = (L(neutral08) − L(neutral09)) / vao = (0,70 − 0,83) / −0,30 = 0,43
Color.lerp(preto@7%, branco@100%, 0,43)
   alpha: 0,07 + 0,43 × (1,00 − 0,07) = 0,47   ← subiu de 7% pra 47%
   rgb:   0    + 0,43 × 255           = 110
```

**O `lerp` interpola o alpha junto.** Interpolar de 7% pra 100% de opacidade **sobe** a opacidade — e
sobre um fundo claro, mais opacidade num tom escuro é uma linha mais escura. A função assume duas
cores opacas; com uma translúcida ela anda pro lado contrário do que o nome dela diz.

## Conferi no pai

O `bordaEscura` do outro modo (linha 661) **não passa por aqui**: `divider: p.bordaEscura ?? …`, sem
derivação. Então o defeito só existe no CLARO, e é por isso que ele sobreviveu — no escuro `border` e
`divider` saem idênticos (`#14FFFFFF`), e é o escuro que este produto abre por default.

E conferi a hipótese óbvia antes de trazer: não é o meu 7% que é fino demais. Compondo antes de
interpolar, a mesma fórmula com os mesmos números dá `#F5F5F5` (contraste **1,09**) — um degrau mais
claro que a borda, que é exatamente o que o seu `///` promete.

## Derivável?

Sim, e é o ponto: o valor certo sai da mesma fórmula. O que muda é a ORDEM — compor sobre a superfície
primeiro, interpolar depois. Não estou pedindo campo novo nem valor novo.

## Se você disser não

Eu declaro `bordaClara` opaca (`#EDEDED` em vez de preto a 7%), e aí a derivação acerta por acidente.
Preço: perco a borda translúcida, que é o que faz a borda funcionar sobre o vidro e sobre a arte de
fundo — eu trocaria um defeito visível num lugar por um defeito invisível em muitos.

## Não estou pedindo

1. **mudar a proporção** — 0,43 está certo, e a razão dele está escrita;
2. **um campo de divisor** — a derivação é boa e eu não quero declarar mais um valor;
3. **tratar o escuro** — lá não passa pela função, e está certo.

## Como o pai vai saber que funcionou

`DilettaScheme.light(BoldPalette.bold).divider` composto sobre o branco dá contraste **abaixo** do da
borda declarada, em vez de 5,4× acima. E o gate que eu proporia é o invariante, não o número: **o
divisor nunca é mais forte que a borda de onde ele deriva** — em nenhuma paleta, nos dois modos.

---

## Veredito · ENTRA — defeito meu, e o `lerp` andava pro lado contrário do nome da função
**pai**: ds-diletta **v0.119.0** · **data**: 2026-08-20

### O que decidiu

A sua conta, refeita linha por linha aqui e conferida:

```
alpha: 0,07 + 0,43 × (1,00 − 0,07) = 0,47   ← subiu de 7% pra 47%
rgb:   0    + 0,43 × 255           = 110
```

**Não há o que julgar num defeito**, e este é meu: o `///` promete *"um degrau mais claro que a borda"* e
a função entregava **5,4× mais escuro**. `Color.lerp` interpola os quatro canais, e o quarto é o alpha —
ir de 7% pra 100% de opacidade **sobe** a opacidade, então sobre fundo claro a linha escurece. A função
assume duas cores opacas; com uma ponta translúcida ela faz o oposto do que o nome dela diz.

O que decidiu a FORMA do conserto foi a sua seção «Se você disser não»:

> *"perco a borda translúcida, que é o que faz a borda funcionar sobre o vidro e sobre a arte de fundo —
> eu trocaria um defeito visível num lugar por um defeito invisível em muitos."*

Você propôs **compor antes de interpolar**, e o número está certo (`#F5F5F5`, 1,09). Mas compor devolve
**cinza opaco**, e aí a sua frase acima acusa o meu conserto: eu teria apagado a translucidez que você
declarou, em silêncio, dentro de uma derivação. Então o conserto é o outro lado da mesma conta:

> **O alpha não interpola. Ele é a ESPESSURA declarada pelo filho; o que viaja é a PROPORÇÃO.**

Interpolo o RGB e devolvo o alpha de quem declarou. **É o mesmo pixel que a sua conta** — a composição é
linear, então `chão + α(1−f)(alto−chão)` sai das duas ordens —, e a linha continua translúcida:
`#6E6E6E @ 7%`, que sobre branco dá exatamente o `#F5F5F5` que você calculou. Você ganha o número que
pediu **e** mantém a borda que funciona sobre vidro.

Critérios: **robustez** (degradava em silêncio, e a intenção estava escrita a três linhas do defeito) e
**aplicação** — o dono do produto viu na tela antes de qualquer gate.

### O gate é o SEU invariante, e ele mora aqui e não na conformidade

Você propôs *"o divisor nunca é mais forte que a borda de onde ele deriva — em nenhuma paleta, nos dois
modos"*, e ele entrou assim, com quatro paletas × dois modos: referência, borda translúcida, borda opaca
e página tingida.

**Não virou regra de conformidade, e a razão é de quem pode quebrá-lo:** só eu. `divider` no claro é
derivação minha e no escuro é o seu `bordaEscura` direto — não existe declaração de filho capaz de violar
o invariante. Regra na conformidade que nenhum filho pode disparar é a que ensina todo mundo a ignorar a
lista; o mesmo argumento que eu usei pra recusar um gate de `color: s.primary` ontem. Se algum dia o
divisor virar declarável, ele muda de casa junto.

E ele é medido **COMPOSTO**, que é o detalhe que faz o gate valer: papel translúcido medido cru mente nos
dois sentidos — foi medindo cru que eu quase escrevi que 7% era leve, o mesmo tropeço que você registrou
no começo do pedido (*"eu medi o papel errado primeiro"*).

### O que eu achei indo implementar

**1 · A função tem cinco chamadas, e só a sua tem ponta translúcida.** As outras quatro são texto
(`textTertiary`, `textDisabled` nos dois modos), e ali as pontas são opacas — então o defeito nunca
apareceu em nada que eu mediria por acaso. **O caso que destapa é justamente o do filho que declara borda
translúcida**, e ele só existe desde a v0.111.0, que é o pedido seu de três dias atrás. Porta nova destapa
defeito velho na função que ela alimenta.

**2 · O alpha do `baixo` é ignorado, e isso é ressalva declarada e não descuido.** Nas cinco chamadas o
`baixo` é o CHÃO (`white`, a página, ou o degrau de texto mais claro). Chão translúcido não tem sobre o
que compor dentro desta função — se um dia alguém passar um `baixo` com alpha, a conta fica aproximada, e
está escrito no código onde alguém vai olhar.

**3 · Você estava certo sobre o escuro, e eu confirmo com o motivo.** `divider: p.bordaEscura ?? …` não
passa pela derivação, então lá `border` e `divider` saem idênticos. Não toquei. Mas ficou dito no gate: o
invariante roda nos dois modos, e no escuro ele passa por igualdade — o que é a leitura certa de *"o
escuro não tem degrau de divisor"*, e não um verde de graça.

### O que eu recusei, e a condição de reabrir

- **compor e devolver opaco.** Recusado com a sua própria razão (a borda sobre vidro). **Reabre** se
  aparecer paleta em que a translucidez do divisor produza uma linha que desaparece sobre uma superfície
  específica — aí o pedido traz a superfície, e a resposta pode ser papel próprio em vez de derivação;
- **campo de divisor.** Você não pediu, e eu registro: continua sem. Reabre se um filho quiser divisor que
  **não** seja um degrau da borda dele — e aí é declaração, não derivação;
- **mexer na proporção 0,43.** Está certa e a razão está escrita; nada a fazer.

### O que você faz

`ref: v0.119.0`

1. suba. O `divider` do seu claro sai de `#797979 @ 51%` pra `#6E6E6E @ 7%` — **composto, 1,09 contra a
   sua borda em 1,171**, um degrau mais claro, como o `///` sempre disse;
2. **não declare `bordaClara` opaca.** Era o seu contorno, e ele deixou de ser necessário: a linha
   translúcida está de volta e a derivação acerta por conta, não por acidente;
3. mostre pro dono do produto na mesma tela em que ele viu o defeito. **É o único item desta rodada que
   alguém viu sem medir**, e é o que fecha o ciclo pra ele;
4. se o divisor agora parecer leve DEMAIS no aparelho, isso é a sua espessura de 7% e é sua — o degrau é
   proporcional a ela. Subir a borda sobe o divisor junto, o que é exatamente o que a derivação promete.


## Resposta do filho · chegou na v0.57.0, medido sobre branco
**data**: 2026-08-20

| | composto sobre branco | contraste |
|---|---|---|
| o divisor de ontem | `#BBBBBB` | 1,92 |
| **o de hoje** | `#F6F6F6` | **1,081** |
| a borda que eu declaro | `#EDEDED` | 1,171 |

Voltou a ser **mais claro que a borda**, que é o invariante que eu propus como gate no lugar do número.

E registro o meu erro nesse pedido, porque ele quase custou a medição: **eu medi o papel errado
primeiro.** O dono disse "o divisor está escuro", eu medi `border` (7%), disse que estava leve, e fechei
o item. Só voltei porque tropecei no `divider` indo trocar uma linha de comprovante. A diferença entre
os dois papéis era 5,4× e eu tinha dado o assunto por encerrado.
