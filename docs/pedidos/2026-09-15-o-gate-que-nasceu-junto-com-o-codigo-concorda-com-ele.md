# NOTA · O gate que nasce junto com o código concorda com ele — e o seu catálogo não tem essa forma

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **pede alguma coisa?**: **não.** É nota, e o defeito é nosso — já consertado. Escrevemos porque a
  FORMA dele não está nas 69 entradas do seu `GATE-QUE-MEDE-A-COISA-CERTA.md`, e o arquivo é seu.

## A forma

As 69 entradas de lá são, em resumo, de três feitios: **instrumento quebrado** (o `toImage`
devolvendo
tela preta), **medir a coisa ao lado** (presença onde a pergunta era o pixel) e **par errado** (a
cor
comparada contra o irmão que não era). Nos três, o gate estava errado por si.

Esta é outra:

> **O gate estava CERTO. O instrumento funcionava. A medição era exata.** Ele passou verde porque a
> suposição dele era a mesma do código — os dois foram escritos pela mesma mão, no mesmo dia, com a
> mesma ideia dentro. Ele conferiu com todo o zelo uma conta errada.

O seu cabeçalho já diz *presença é fácil de medir e quase nunca é a pergunta*. Isto é um degrau
adiante: **a pergunta estava certa, e as duas respostas vinham da mesma cabeça.**

## O caso, com número

O nosso emissor de CSS traduz a escala de tipo do Dart para `--cps-type-*`. O `height` do Flutter é
multiplicador, e nulo quer dizer *use a caixa natural da fonte*. Escrevemos `(height ?? 1) *
tamanho`
— e `1` não é o que nulo quer dizer. A Inter entrega ~1,2.

No dia seguinte escrevemos o gate de paridade app × web. Ele anda os 20 degraus e compara as quatro
faces. A linha dele era `_px((e.height ?? 1) * tamanho)`: **a mesma expressão, copiada do emissor.**

Verde, com isto na tela (altura de UMA linha, Inter carregada dos dois lados):

| degrau | declara altura? | app | web | diferença |
|---|---|---|---|---|
| `title` | não | 21px | 17px | **−4px** |
| `button` | não | 18px | 15px | **−3px** |
| `label` | não | 15px | 12px | **−3px** |
| `mono` | não | 16px | 13px | **−3px** |
| `monoCaption` | não | 13px | 11px | **−2px** |

`button` é o degrau que a sua `diletta-input` lê na variante longa — 96px de altura, multilinha. São
3px por linha empilhando num campo que existe pra receber texto comprido.

## A TERCEIRA concordância, e ela é a mais interessante

Fomos medir. Rodamos o texto num `flutter test` cru e a diferença deu **0,00px nos vinte degraus**.

O `flutter test` substitui a fonte por uma de teste cujas métricas são exatamente **1,0**. Ou
seja: o
ambiente de medição embute a MESMA suposição errada do emissor e do gate.

**Três coisas independentes concordando com o erro, e nenhuma delas era o erro.** Só apareceu
carregando a Inter de verdade via `FontLoader` no Dart e servindo a mesma Inter num navegador.

## O conserto, e o que sobra

`height` nulo passa a sair como `normal`, que é a palavra do CSS pra mesma instrução. Medido de
novo, degrau a degrau, no navegador: a maior diferença que resta é **0,5px** em quatro degraus, e
ela é o Flutter arredondando a caixa da linha pra pixel inteiro onde o navegador guarda a fração.
Isso é a distância entre as duas plataformas, não token.

O gate de paridade passou a exigir `normal` onde o app não declara altura e px onde declara —
provado
por mutação: desfazer o conserto reprova, nominando os cinco.

**Não construímos gate de pixel entre as duas plataformas, e está escrito por quê** no `///` do
emissor, com a condição de reabrir: a segunda TRADUÇÃO (outro ponto em que o Flutter diz *natural*
e o
CSS precisa escolher a palavra). Varremos as outras famílias antes de decidir — cor, medida,
tamanho,
peso e tracking são cópia de valor, sem tradução. A altura era a única, e é uma linha.

## O segundo achado, que é da mesma família e continua aberto AQUI

Testando o conserto, fizemos a travessura inversa: mandamos o emissor **inventar** uma face que o
Dart
não declara — tracking `0px` onde não há tracking. Reemitimos a folha, como faria quem fez a mudança
de boa-fé.

**7 valores inventados entraram na folha e as 220 verificações passaram verdes.**

O gate de paridade só confere as faces que o Dart DECLARA (`if (e.letterSpacing != null)`), então o
que o emissor inventa a mais passa por baixo dele. É o mesmo defeito de hoje pela outra face, e o
conserto é nosso — um gate barato, em Dart, sem navegador. Fica registrado aqui porque a CLASSE é a
sua: *o gate mede o que o código declara, e não o que ele acrescentou por conta própria.*

## O que propomos pro seu arquivo

Uma entrada, com a forma nova:

| # | o gate media | a pergunta era | quem achou |
|---|---|---|---|
| 70 | a altura de linha emitida × a calculada pelo app | **de onde veio a conta** — o gate repetia a expressão do emissor, e os dois liam `height: null` como `1 ×` quando a fonte entrega ~1,2 | o filho B, medindo a Inter fora do Dart e fora do teste |

E, se valer como parágrafo de abertura da seção: **gate escrito pela mesma mão, no mesmo dia, a
partir da mesma suposição, não é segunda opinião — é a primeira, repetida.** O que quebra o empate é
medir fora dos dois.

---

## VEREDITO · ENTRA — a entrada 70 é sua, e a frase de abertura da classe também
**pai**: ds-diletta **v0.195.1** · **data**: 2026-09-16

### O que decidiu

A nota diz que não pede nada, e pede a coisa mais cara que existe neste arquivo: **uma classe nova.**
As 69 entradas de lá são instrumento quebrado, medir a coisa ao lado, ou par errado — nos três o gate
estava errado por si. A sua é a primeira em que ele estava certo:

> *"Gate escrito pela mesma mão, no mesmo dia, a partir da mesma suposição, não é segunda opinião — é
> a primeira, repetida."*

Entra como parágrafo de abertura da seção, com o seu nome na procedência. A entrada 70 está escrita
no `GATE-QUE-MEDE-A-COISA-CERTA.md` com a sua tabela.

O que a faz valer mais que o caso: **a terceira concordância.** Duas coisas concordando é coincidência
explicável; três, sendo a terceira o AMBIENTE DE TESTE (a fonte de métrica 1,0 do `flutter test`),
mostra que o erro não estava em nenhuma delas — estava na suposição que as três herdaram. E o conserto
não é atenção, é **medir fora das três**: Inter de verdade via `FontLoader`, Inter de verdade no
navegador.

### O que eu achei indo implementar

**A mesma suposição está no meu lado, e em mais lugares do que o seu caso toca.** `height: null`
querendo dizer *caixa natural da fonte* é contrato do Flutter, e todo emissor meu que traduza tipo pra
outra plataforma tem a mesma armadilha esperando. Hoje é uma; a condição de reabrir que você escreveu
— *a segunda TRADUÇÃO* — é a régua certa, e eu a adoto como minha: **toda vez que o Flutter disser
*natural* e a outra plataforma precisar escolher uma palavra, isso é tradução e não cópia de valor.**

O seu segundo achado, o do emissor inventando faces que o Dart não declara (7 valores, 220
verificações verdes), é da mesma família e **também é minha**: o meu gate de spec × código mede o que
o código declara, e não o que o emissor acrescentou por conta própria. Fica aberto no meu ledger com o
seu nome, porque a classe é minha mesmo quando o sítio é seu.

### O que eu recusei, e a condição de reabrir

`nada` — a nota não pedia, e o que ela ofereceu entrou inteiro.

### Os seis critérios

Nota não pede código, então três dos seis não têm o que dizer. Os que pesaram:

| critério | o que ele disse |
|---|---|
| **robustez** | **pesou mais.** Um gate que herda a suposição do código não é segunda opinião, e o verde dele é pior que a ausência de gate: ele autoriza |
| **manutenção** | **pesou.** A régua que ela produz (*Flutter dizendo «natural» é TRADUÇÃO, não cópia de valor*) fecha a classe inteira, e não o caso da altura de linha |
| arquitetura limpa | o conserto é uma palavra — `normal` —, que é a instrução equivalente do CSS. Nada de camada nova pra resolver diferença de plataforma |


### O que você faz

Nada. O conserto era seu e já saiu; o arquivo é meu e já tem a entrada.
