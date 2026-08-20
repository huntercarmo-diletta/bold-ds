# PEDIDO · o espelho do claro veio em duas partes, e a terceira é a SUPERFÍCIE

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.115.0 · catalogo-diletta v0.108.0 · DS filho v0.55.0
- **bloqueante?**: não pro Bold. **Bloqueante pro NETO** — e é essa a diferença que este pedido carrega.

## Falta

Os campos de override das superfícies do CLARO na paleta: **`bgClaro`** e **`surfaceMutedClara`**.

## Número

**2 de 42.** Eu acabei de parametrizar o meu esquema pela paleta — ele recebe `DilettaPalette` em vez
de cravar a minha — e montei um NETO de teste com a sua `DilettaPalette.referencia`. Resultado
medido, e está num gate (`o_neto_troca_a_paleta_e_pronto`):

| | |
|---|---|
| papéis que acompanham a paleta do neto | **32** |
| iguais por REGRA (alpha sobre branco/preto absoluto — a resposta certa é a mesma) | 7 |
| iguais por CONSEQUÊNCIA de um preso | 1 |
| **presos por dívida** | **2** — `background` e `field`, só no claro |

Os dois valores: página `#F4F3F6` e campo `#F1F0F4`. A sua derivação do claro dá **branco puro** pro
`bg` e `neutral09` pro `surfaceMuted`.

## Já tentei

**1 · `papeisExtras`.** Foi a primeira coisa que eu fui fazer, e ela mentiria. O `///` do
`DilettaPapelExtra` é explícito: extra é vocabulário que você não tem (*"ele não sabe o que é
`acentoLaranja`"*). `background` e `field` são vocabulário SEU — `bg` e `surfaceMuted`. Declarar como
extra criaria dois papéis com o mesmo significado, que é exatamente a duplicata que eu passei o dia
matando (o vidro declarado duas vezes, o `onGradient` branco em dois lugares).

**2 · Derivar da rampa neutra.** `neutral10` (`#F6F6F6`) está a 2 unidades de canal do meu valor. Não
serve, e a razão não é o pixel: **a sua derivação do claro é branco puro, e a minha página não é
branca de propósito.** O card deste produto é branco, e a página tingida é o que faz ele ler como
ELEVADO — 1,105 de contraste entre os dois. Com a página branca, card branco sobre fundo branco só
existe pela borda, e aí a elevação vira traço em vez de superfície.

**3 · Deixar como está.** É o que está no ar agora: os dois moram como constante nomeada na minha
paleta (`BoldColors.fundoClaroDaPagina`, `BoldColors.campoClaro`), com o motivo escrito e um gate
contando. **Funciona pro Bold e não funciona pro neto** — e é só por isso que eu estou pedindo.

## Conferi no pai

Este é o **terceiro pedaço do mesmo espelho**, e os dois primeiros são seus:

1. `bgEscuro`, `surfaceEscura`, `surfaceMutedEscura` entraram na **v0.1.9**, por pedido de filho. As
   superfícies do escuro deixaram de ser cravadas por você e passaram a ser declaráveis;
2. `textoClaro`, `textoSecundarioClaro`, `textoMudoClaro`, `bordaClara` entraram na **v0.111.0**, por
   pedido meu de 17/08 — o espelho do claro pro TEXTO e pra BORDA.

Falta a superfície do claro. E eu conferi a assimetria antes de chamar de assimetria: o escuro tem
override de superfície e não tinha de texto até a v0.109.0; o claro tem override de texto desde a
v0.111.0 e não tem de superfície. **Cada metade da matriz foi preenchida por um pedido diferente, e
esta é a última célula vazia.**

## Derivável?

Não, e é o oposto de derivável: a sua derivação do claro está CERTA pra quem não declara — branco puro
é a resposta neutra. O que falta é o lugar de dizer outra coisa. Mesmo formato dos quatro que você
acabou de abrir: campo opcional, nulo cai na derivação, quem declara assume.

## Se você disser não

Os dois ficam como estão e o gate continua contando 2. O preço não é meu: **um neto deste DS herda a
página e o campo do Bold no modo claro**, e não tem onde declarar os dele — teria que editar o meu
esquema, que é a coisa que eu acabei de tornar desnecessária pros outros 32 papéis.

E fica escrito que a resposta pra *"trocar os tokens troca o app?"* é **42 de 44** por escolha sua, e
não por limite da arquitetura. Isso é uma resposta aceitável; ela só não pode ser silenciosa.

## Não estou pedindo

1. **mudar a sua derivação do claro** — branco puro serve quem não declara, e é o default certo;
2. **campo por papel** — dois bastam, e são exatamente os dois que eu tenho. Se um terceiro aparecer,
   ele vira pedido com o número dele;
3. **que você adivinhe o meu valor** — eu declaro. O que eu preciso é do campo.

## Como o pai vai saber que funcionou

O meu gate. `o_neto_troca_a_paleta_e_pronto` tem uma lista fechada chamada `naoViajam`, hoje com dois
nomes. Com os campos, ela fica **vazia** e a contagem vai de 32 pra 34 de 34. É a asserção que
responde a pergunta do dono do produto sem prosa: **um neto troca a paleta e recebe o esquema dele.**
