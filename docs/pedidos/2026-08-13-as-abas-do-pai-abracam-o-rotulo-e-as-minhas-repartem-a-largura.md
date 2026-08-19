# Pedido · as abas do pai ABRAÇAM o rótulo, e as minhas repartem a largura — 113px de diferença

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.42.0 · pai v0.87.0
- **data**: 2026-08-13

## O que falta

Uma forma de `DilettaTabs` repartir a largura em fatias IGUAIS — `larguraIgual: true`, ou o nome que
couber na sua gramática.

## Já tentei

Adotar `DilettaTabs` direto, que é o que o seu aviso sugere (*"se você desenha aba à mão em alguma
tela, ela agora tem peça"*). **Ela estoura na minha tela**, e o número é o argumento inteiro:

| rótulos | largura | resultado |
|---|---|---|
| `Pendentes` · `Histórico` · `Minhas` (a tela de Autorizações) | 353 | **estoura por 113px** |
| `Tudo` · `Entradas` · `Saídas` | 353 | cabe |
| `Ativos` · `Encerrados` | 353 | cabe |

A causa é declarada no seu código e está certa pro caso dele: `Row(mainAxisSize: MainAxisSize.min)`
com cada `_Aba` no tamanho do próprio rótulo. Três rótulos médios em português passam de 353.

Tentei também encolher o rótulo — `Pendentes` vira `Abertas`. Cabe, e é a saída errada: **o rótulo é
o produto**, e mudar o texto da tela pra caber num componente é o componente decidindo o conteúdo.

## Conferi no pai

- `DilettaTabs` recebe `abas`, `selecionada`, `onSelecionar`, `desabilitadas`, `statusForcado` —
  nenhum eixo de largura;
- o `Row` é `MainAxisSize.min` e cada `_Aba` é hug; não há `Expanded` em lugar nenhum do arquivo;
- `_Aba` é privada **de propósito**, e você escreveu por quê: *"o contrato de fora é a lista de
  rótulos e o índice"*. Concordo, e é por isso que eu não peço acesso a ela;
- e você já deixou a porta escrita na linha seguinte: *"quando um filho precisar montar uma fila de
  abas que este componente não monta, ele pede — **variante nasce no filho**"*. É o que eu estou
  fazendo.

## Derivável?

Não. Largura igual não sai da lista de rótulos nem do índice — ela é uma decisão sobre COMO a fila
ocupa o espaço, e as duas respostas são válidas na mesma linguagem:

| | abraça | reparte |
|---|---|---|
| onde serve | fila que divide um bloco de conteúdo, com espaço à direita | **barra de navegação, que ocupa a largura toda por contrato** |
| o que custa | estoura quando os rótulos crescem | a aba de rótulo comprido corta enquanto a curta sobra |

A minha razão está escrita na peça desde que ela nasceu, e ela é sobre o dedo e não sobre o texto:
**fatia desigual faz o alvo de toque mudar de tamanho a cada troca de tela.** Numa barra que é
navegação, isso é a mesma coisa que o botão andar de lugar.

## Se você disser não

`BoldAbas` continua viva, e o custo não é ela existir — é o que ela vira: **a única peça deste
produto que tem par na linguagem e não adota**, depois de eu ter fechado as oito últimas lacunas. Ela
passa a ser a exceção que o meu próprio inventário de adoção vai contar como dívida, e a razão dela
some do número.

## Não estou pedindo

1. **trocar o padrão.** O hug está certo pro caso do primeiro filho, e trocar quebraria a fila dele;
2. **acesso à `_Aba`.** O contrato de fora é a lista e o índice, e ele é bom;
3. **truncar automático quando não couber.** Isso mascara o estouro em vez de decidir: quem escolhe é
   quem monta a tela, e a escolha é entre repartir e caber com menos abas.

## Como o pai vai saber que funcionou

`BoldAbas` deixa de existir neste pacote, e os três sítios passam a montar `DilettaTabs`. É `grep`, e
é o mesmo critério que você me cobrou no `heroTag`: **peça que fica parecida não convergiu.**

---

## Nota do filho · o pedido segue aberto, e a `BoldAbas` está declarada como exceção
**data**: 2026-08-13 · `ref: v0.88.0`

Sem veredito ainda, e sem pressa — não é bloqueante. Registro só que a exceção não está silenciosa: o
`///` da peça diz que ela é a única deste produto com par na linguagem que não adota, com os 113px
medidos e a razão do alvo de toque.

---

## Veredito · ENTRA — `larguraIgual`, e o que me convenceu não foi a simetria, foi o ESTOURO
**pai**: ds-diletta **v0.115.0** · **data**: 2026-08-19

`DilettaTabs.larguraIgual`, `bool`, default `false`.

### O que decidiu

**113px.** Eu escrevi *"variante nasce no filho"* na porta desta peça, e você usou a porta certo — mas o
seu número diz que este caso não é variante, e é isso que muda o veredito:

> `Pendentes` · `Histórico` · `Minhas` em 353 — **estoura por 113px.**

Três rótulos médios em português, numa tela de 393, na peça que eu anunciei pros dois filhos adotarem.
**Isso não é gosto de um produto, é a peça não hospedar o caso mais comum de três abas** — e uma peça que
estoura o aparelho no caso comum é defeito de aplicação e de robustez, não inventário de filho. Se fosse
variante, a régua seria *espera o segundo pedir*; como é o meu default falhando, o piso muda de lado.

O que **não** decidiu, e eu registro porque você deve ter esperado que decidisse: a sua tabela
`abraça × reparte`. Ela está certa e é a razão de o eixo existir em vez de eu trocar o default — mas duas
respostas válidas na mesma linguagem, sozinhas, teriam dado `ESPERA`. Foi o estouro que fez agora.

E a sua terceira razão é a que eu roubei pro `///` da prop, porque ela é sobre o dedo e não sobre o
texto: **fatia desigual faz o alvo de toque mudar de tamanho a cada troca de tela.** Numa fila que é
navegação isso é o botão andando de lugar.

### O que eu achei indo implementar

**1 · O `IntrinsicWidth` tinha que sair no modo que reparte, e a razão é a que já estava escrita ali.**
O comentário da peça diz que sem `IntrinsicWidth` a régua colapsa em largura zero — *"foi o RETRATO que
pegou"*. Repartindo, a largura chega **tight** pelo `Expanded`, então o intrínseco não é só inútil: é um
passo de layout medindo contra uma restrição fechada. Ficou condicional, com a razão no código.

**2 · Reticências entram, e só no modo que reparte.** Você não pediu truncamento — pediu explicitamente
que ele NÃO fosse automático, *"isso mascara o estouro em vez de decidir"*. Concordo, e é por isso que o
corte só existe onde a decisão já foi tomada: quem declara `larguraIgual` escolheu a fatia, e na fatia
estreita o corte é a leitura honesta dela. **Abraçando, nada corta**, porque a caixa é o rótulo. O que
você recusou continua recusado: a peça não corta pra fingir que caberia.

**3 · Medir isto quase me deu um gate verde por acidente.** O primeiro helper do meu teste lia *"o
primeiro `Column` acima do rótulo"* e devolvia a coluna de FORA — as três abas mediam igual nos dois
modos, e o teste passava nos dois. A leitura certa é a régua de cada aba (o último filho da coluna da
aba), que é a mesma do gate irmão desta peça. E de brinde: **`Pendentes` e `Histórico` medem exatamente
o mesmo (138,6) nesta fonte** — o par que separa hug de reparte é o 0 contra o 2. Escolher o par errado
dava verde nos dois modos.

### O que eu recusei, e a condição de reabrir

- **trocar o default.** Você já não pediu; fica escrito que o hug continua sendo o desenho que as duas
  casas declaram;
- **acesso à `_Aba`.** Continua privada, e o contrato de fora continua sendo a lista e o índice —
  concordamos os dois. Reabre se um filho precisar de aba com CONTEÚDO (ícone, contador), e aí o pedido é
  sobre slot e não sobre largura;
- **`Style: Filled`** (a pastilha cheia do terceiro filho). Continua esperando o segundo pedido, e agora
  com um caso registrado: o primeiro filho desenha à mão uma fila de **pílulas** na aba de Specs do
  catálogo dele. Se você pedir a família preenchida, ela sobe sem rediscussão de mérito.

### O que você faz

`ref: v0.115.0`

1. os três sítios passam a `DilettaTabs(..., larguraIgual: true)` e a `BoldAbas` sai;
2. o `///` que você escreveu declarando a exceção some com ela — e essa é a parte que eu quero comentada
   no seu commit: **a exceção durou seis dias e morreu com número**, que é o oposto de exceção que vira
   dívida silenciosa. Você declarou a razão e os 113px no código antes de eu responder, e é por isso que
   a linha do meu ledger tem o número;
3. se a fatia cortar rótulo em alguma das três telas, isso é conteúdo e é seu: a escolha, como você
   escreveu, é entre repartir e caber com menos abas.

## Resposta do filho · adotado na v0.53.0, e a minha peça virou casca — com o pixel que isso custou
**data**: 2026-08-19

`larguraIgual: true`, e **as `BoldAbas` deixaram de desenhar**: 122 linhas viraram 89, das quais o
corpo é uma chamada. Era pra ser assim — a peça existia porque a sua fila abraçava e a minha
repartia, e com o eixo não sobra desenho pra manter aqui.

**O que a troca custou, e eu escrevo porque um pixel que muda em silêncio é pior que um pixel feio:**
o sublinhado ativo era **2** aqui e é **3** aí. Adotei o seu — adotar é seguir o traço da linguagem, e
o inativo continua 1 dos dois lados, então a redundância que não depende de matiz não só sobreviveu,
ela aumentou. O gate que media isso continua de pé e mudou de número: ele nunca foi sobre a
estrutura (era borda de `AnimatedContainer`, virou altura de `Container`), era sobre a seleção se ler
sem cor.
