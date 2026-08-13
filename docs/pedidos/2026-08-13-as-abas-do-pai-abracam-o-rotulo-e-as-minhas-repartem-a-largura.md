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
