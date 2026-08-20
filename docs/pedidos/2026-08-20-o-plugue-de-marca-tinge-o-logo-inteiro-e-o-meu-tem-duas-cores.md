# PEDIDO · o plugue de marca existe, e a peça TINGE o logo inteiro — o meu tem duas cores

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.115.0 (você já está na v0.118.1) · DS filho v0.56.0
- **bloqueante?**: sim pra adotar. Não pro app, que hoje desenha o logo com peça própria.

## Falta

`DilettaLogo` poder desenhar um logo que **não é monocromático** — hoje ele aplica
`ColorFilter.mode(cor, BlendMode.srcIn)` sempre, e `srcIn` não tem exceção.

## Número

O logo deste produto é o lockup CONTA BOLD, e ele tem **duas partes com regras opostas**, medidas no
arquivo:

| parte | o que é | quantos |
|---|---|---|
| as letras | tinta que VIRA com o tema — branco no escuro, preto no claro | **8** `fill` |
| o "O" do BOLD | o gradiente da marca, **8 paradas**, invariante | 1 `fill="url(#…)"` |

Com `srcIn` no arquivo inteiro, o gradiente morre junto com as letras: o "O" sai da cor da tinta, e o
lockup deixa de ser o lockup. **É a única razão de eu ainda ter `BoldLogo` como peça privada** — são 5
sítios, e o inventário dele está classificado `deliberado` com a razão *"a marca do Conta BOLD; o pai
tem `DilettaLogo`, que é a marca DELE"*. Essa razão está errada desde que o `DilettaBrand` existe: o
arquivo é meu, o desenho é seu, e o que falta é uma linha.

## Já tentei

**1 · Declarar `DilettaBrand` e usar `DilettaLogo` com `color:`.** Não existe valor de `color` que
signifique *"não tinja"*. Nulo cai em `scheme.primary`, que é pior que branco: o lockup inteiro sai
rosa.

**2 · Passar `logo` e `logoFull` como os meus dois arquivos** (`bold-wordmark-light.svg` e
`bold-wordmark-brand.svg`). Não serve, e por dois motivos: `mark` e `full` são símbolo e lockup, não
claro e escuro — eu estaria usando um eixo pelo outro; e o `srcIn` continua tingindo os dois.

**3 · Fazer o wordmark monocromático e perder o gradiente.** Funciona hoje, e é uma decisão de marca
que não é minha nem sua. Levei ao dono do produto: o "O" com o gradiente **é** a marca.

## Conferi no pai

- `DilettaBrand` tem `pacote`, `logo`, `logoFull`, `logoParceiro`, `bandeiraDoCartao`,
  `carteirasDeSistema` e `selosDeLoja`. **O plugue está pronto**, e a divisão de licença que você
  escreveu nele é a mais clara do repo: *"arte que exige aceitar termos viaja com quem aceitou"*;
- o `///` do `color` conta que ele já foi `primary04` const e que *"default const não alcança o
  tema: o logo de qualquer filho saía azul-CPF"*. **É o mesmo defeito uma camada acima**: agora ele
  alcança o tema, e ainda não alcança um logo que tem duas cores;
- a `v0.112.0` declarou que `DilettaLogo` não tem bloco no catálogo porque *"o arquivo é do FILHO e o
  default aponta um asset que este pacote não tem"* — então a peça já assume que o arquivo é meu.

## Derivável?

Não. O que falta é o pai **não fazer** uma coisa, e isso não sai de declaração minha.

## Se você disser não

`BoldLogo` continua vivo, com 5 sítios, e o inventário guarda a razão certa em vez da que está lá. E
fica escrito que o logo é a única peça de marca deste produto que não passa pelo plugue — as outras
(bandeira, carteiras, selos) passariam, quando existirem.

## Não estou pedindo

1. **um segundo par de assets** por modo. Se as letras forem tingíveis e o "O" não, **um arquivo
   basta** e os meus dois colapsam em um — o que eu quero é menos arquivo, não mais;
2. **que o `srcIn` saia**. Ele está certo pro logo monocromático, que é o caso do primeiro filho;
3. **gradiente configurável na peça.** O gradiente mora no meu arquivo, e é lá que ele deve morar.

## Como o pai vai saber que funcionou

`DilettaLogo` desenha o meu lockup com as letras na tinta do tema e o "O" com as 8 paradas intactas, a
partir de UM arquivo. E o meu inventário perde uma privada: `BoldLogo` sai de `deliberado` e vira
casca, ou desaparece.
