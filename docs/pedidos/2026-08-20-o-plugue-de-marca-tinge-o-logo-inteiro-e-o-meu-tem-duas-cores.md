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

---

## Veredito · ENTRA DIFERENTE — a tinta entra por `currentColor`, e quem decide o alcance é o arquivo
**pai**: ds-diletta **v0.120.0** · **data**: 2026-08-20

`DilettaBrand.logoTingePorCurrentColor`, `bool`, default `false`.

### O que decidiu

O seu item 1 do «Não estou pedindo», que é a especificação do conserto escrita por você:

> *"**um segundo par de assets** por modo. Se as letras forem tingíveis e o "O" não, **um arquivo basta**
> e os meus dois colapsam em um — o que eu quero é menos arquivo, não mais."*

E a sua medição do arquivo, que diz por que nenhum parâmetro de cor resolveria: **8 `fill` que viram com o
tema e 1 `fill="url(#…)"` que é invariante**, no mesmo SVG. `srcIn` não tem exceção — não existe valor de
`color` que signifique *"não tinja isto"*, como você já tinha testado. O caminho não é a peça deixar de
tingir; é **a tinta entrar por um canal que o arquivo controla**.

`currentColor` é esse canal, e ele não é invenção desta casa: é a palavra do formato (SVG) e do CSS, com o
mesmo significado nos dois. Critério que pesou junto com aplicação: **aderência ao mercado** — se um dia
esta arte for renderizada fora do Flutter, o contrato continua valendo.

O que você paga, e eu digo na cara: **as partes tingíveis do arquivo precisam dizer `currentColor`.** É
uma edição por `fill` de letra, e é a única forma de a peça saber o que pode tingir sem adivinhar por hex —
adivinhar por hex é exatamente o defeito do outro pedido seu de hoje.

E os dois caminhos **se excluem**: quando a marca declara, o `ColorFilter` não entra. Aplicar os dois faria
o filtro engolir o gradiente que o arquivo acabou de proteger, e aí a declaração seria decorativa.

### O que eu achei indo implementar

**1 · O `srcIn` fica, e você tinha razão em não pedir a saída dele** (item 2). O primeiro filho tem logo
monocromático e o filtro é o certo pra ele — o default não muda um pixel. **Uma peça de marca com dois
contratos de tinta não é inconsistência: é que existem dois tipos de arquivo**, e quem sabe qual é o dele
é quem o desenhou.

**2 · O modo dev passa a dizer QUAL caminho está em uso.** `tinta: currentColor (o arquivo decide)` ou
`tinta: srcIn`, no `DilettaDevInfo`. Sem isso, *"por que o meu logo não tingiu?"* é uma pergunta que só se
responde lendo o código do pai — e a declaração mora na marca, que é o último lugar onde alguém olha.

**3 · O `==` do `DilettaBrand` não via `selosDeLoja`.** Achado somando o campo novo: `mapEquals` estava lá
pra `carteirasDeSistema` e faltava pro selo. **O `==` é o que decide se o scope repinta**, então trocar o
selo de uma loja não repintava nada — um filho ia acabar chamando isso de *"o selo não atualiza"* e
procurando no lugar errado. Os três mapas entram agora, com gate.

**4 · A sua leitura do `///` do `color` estava certa, e ela vale como classe.** Você escreveu que era *"o
mesmo defeito uma camada acima"*: primeiro o default `const` não alcançava o tema; agora ele alcança o
tema e não alcança um arquivo de duas cores. **A cada camada que a peça sobe, a próxima coisa que ela
assume aparece** — e as duas apareceram por medição de filho, não por revisão minha.

### O que eu recusei, e a condição de reabrir

- **um `bool` que só DESLIGA a tinta.** Foi a minha primeira ideia e ela é pior que o problema: com o
  filtro desligado, as suas 8 letras ficariam com o hex do arquivo e o logo pararia de virar no escuro —
  eu teria trocado um gradiente morto por um lockup que não reage ao tema;
- **gradiente configurável na peça**, que você já não pediu (item 3). Continua morando no seu arquivo;
- **`colorMapper` do `flutter_svg`** (trocar hex por hex na hora de carregar). Recusado porque seria o pai
  conhecendo os hexes do seu arquivo — o defeito do seu OUTRO pedido de hoje, na peça vizinha. Reabre
  apenas se aparecer arte de marca cujo formato não aceite `currentColor` (arte binária, PNG), e aí a
  resposta provavelmente é asset por modo, que é o que você recusou primeiro.

### O que você faz

`ref: v0.120.0`

1. no seu SVG do lockup, os **8 `fill` das letras** viram `fill="currentColor"`. O `fill="url(#…)"` do "O"
   fica como está;
2. na sua `DilettaBrand`: `logoTingePorCurrentColor: true`, e `logoFull` aponta pro arquivo único. Os dois
   arquivos (`bold-wordmark-light.svg` e `bold-wordmark-brand.svg`) colapsam em um — **é o que você pediu, e
   é o número que fecha o pedido: menos arquivo, não mais**;
3. `BoldLogo` sai de `deliberado` no seu inventário. Se ele virar casca de uma linha, ótimo; se desaparecer,
   melhor — os 5 sítios passam a `DilettaLogo`;
4. confira o lockup **nos dois modos** antes de fechar: a letra tem que virar e o "O" tem que ficar. Se o
   gradiente sumir com `currentColor`, é defeito meu e eu quero o arquivo pra medir.

E me diga o que o dono do produto acha do lockup no escuro. Ele foi quem decidiu que *"o 'O' com o
gradiente **é** a marca"* — então é dele o veredito visual, não meu.


## Resposta do filho · adotado na v0.57.0 — dois arquivos viraram UM
**data**: 2026-08-20

`logoTingePorCurrentColor: true`, os 8 `fill` de letra editados pra `currentColor`, e os dois arquivos
colapsados num só. O `white` que sobrou no arquivo é geometria de `clipPath` e não pintura — conferi
antes de tocar, porque um `fill="white"` a mais viraria letra invisível no claro.

**O custo que você disse na cara é o custo certo**, e ele é menor que o preço de não pagar: uma edição
por `fill` contra um arquivo a mais pra sempre e uma peça privada viva.

Gate que ficou: ele afirma sobre o ARQUIVO — 8 `currentColor`, o gradiente presente, e **zero
`fill="black"`**. A razão é a regressão que ele pega: se alguém reexportar do Figma sem a edição, o
`currentColor` some e o logo fica preto no escuro **sem erro nenhum**, porque `black` é um fill válido.
Teste de render não pegaria; teste de arquivo pega.

E o seu achado 3 (o `==` não via `selosDeLoja`) é o que eu levo pra casa: **campo novo em classe de
valor pede o `==` junto**, e o sintoma teria sido "o selo não atualiza" — procurado no lugar errado por
alguém que não sabe que o scope repinta por igualdade.
