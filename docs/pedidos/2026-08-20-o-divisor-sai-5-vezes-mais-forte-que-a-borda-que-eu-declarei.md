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
