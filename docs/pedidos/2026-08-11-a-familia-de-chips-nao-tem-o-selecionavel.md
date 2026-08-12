# Pedido · a família de chips não tem o SELECIONÁVEL, e o `filled` não é ele

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.36.0 · pai v0.66.1
- **data**: 2026-08-11

## O que falta

Uma variante `selecionavel` na família de chips: numa fila onde **exatamente um** está escolhido, o
escolhido INVERTE.

## Por que o `filled` do `DilettaInputChip` não serve

| estado | `DilettaInputChip` | o que este produto faz |
|---|---|---|
| não escolhido | `surface` + borda | transparente + borda neutra + tinta forte |
| escolhido | `primarySubtle` + label `primary` | **`primary` cheio + `onPrimary`** |

Os dois são chips e os papéis são opostos. O teu marca *este filtro está aplicado* numa fila de
filtros aplicados — vários podem estar, e nenhum precisa gritar. O meu marca *A escolha* numa fila
de opções mutuamente exclusivas, e a leitura tem que ser instantânea.

**O `filled` fica no mesmo tom nos dois estados**; o selecionável troca fundo e tinta de lugar. Numa
fila de três, a diferença entre "tom mais claro" e "inversão" é a diferença entre procurar e ver.

## Uma coisa que eu acrescentei e que acho que é da regra, não minha

O peso do rótulo vai de **400 a 600** junto com a cor. Não é enfeite: `bodySm` em `primary` sobre
`bg` e `bodySm` em `onPrimary` sobre `primary` são dois pares que passam AA, e mesmo assim **cor
sozinha não é informação** (1.4.1). O peso é o segundo canal.

Se isso entrar como regra da variante, ele deixa de depender de cada filho lembrar.

## O alvo de toque, que é o outro motivo de a peça existir

A pílula tem ~26 de altura e o alvo tem **44** (WCAG 2.5.5), com o respiro **fora** do desenho. É
fácil de errar na direção contrária — pôr o respiro dentro engorda a pílula e não muda o alvo —, e é
o tipo de coisa que uma variante da linguagem resolve uma vez.

## O que eu NÃO estou pedindo

1. **trocar o `filled`.** Ele está certo no papel dele, e os dois papéis convivem na mesma tela;
2. **cor configurável.** Escolhido é `primary`, e isso não é decisão de tela;
3. **seleção múltipla.** Fila com vários marcados é o `filled`, que já existe.

## Como o pai vai saber que funcionou

O `BoldChipDeFiltro` deste filho vira casca de uma linha, e os seis sítios do app passam a falar a
variante da linguagem.

---

## Veredito · ENTRA — e o desenho já tinha, há dois dias, sem ninguém ver
**pai**: `ds-diletta` **v0.67.0** · **data**: 2026-08-11

`DilettaInputChip.selecionavel(selecionado:)`.

### O argumento é de PAPEL, e é por isso que ele entra sem esperar segundo filho

*"O teu marca **este filtro está aplicado** numa fila de filtros aplicados: vários podem estar, e
nenhum precisa gritar. O meu marca **A escolha** numa fila mutuamente exclusiva, e a leitura tem que
ser instantânea."*

Isso não é variante de estilo esperando promoção: são dois papéis opostos que convivem na mesma tela.
E a medição que fecha é a sua: **o `filled` fica no mesmo tom nos dois estados**, então numa fila de
três a diferença entre tom mais claro e inversão é a diferença entre procurar e ver.

### O que eu descobri indo implementar

O `Input chips` do Figma — que eu pareei a esta classe **em 09/08** — declara
`State: Default, Hover, Pressed, Disabled, **Selected**`.

**O desenho já tinha. O código não. E o mapa que liga os dois não perguntava.** Você pediu uma coisa
que estava declarada há dois dias do outro lado da fronteira, e o gate que eu construí pra achar
exatamente esse tipo de buraco tinha a checagem prometida no doc e **não escrita**. Entrou nesta tag,
como leitura: hoje são 23 de 39 pares com vocabulário no desenho sem contraparte no código.

### O peso entra como regra, e a razão é sua

400 → 600 junto com a cor, dentro da variante. A sua frase é o motivo: *"os dois pares passam AA, e
mesmo assim cor sozinha não é informação (1.4.1) — o peso é o segundo canal."* Fica na linguagem em
vez de depender de cada filho lembrar.

### O alvo de toque — aqui eu te corrijo, e a correção muda o que a coisa É

Você citou **2.5.5** pros 44. **2.5.5 é AAA.** O mínimo AA é o **2.5.8**, que entrou na WCAG 2.2 e pede
**24×24** — e a pílula tem exatamente 24.

Isso muda o diagnóstico: o chip de hoje **não falha**. Ele está **em cima do piso, com margem zero**,
que nesta casa é a segunda pergunta do crivo e não é a mesma coisa que reprovar. Por isso eu **não**
mexi no chip existente: mover o alvo dele pra 44 cresceria a caixa de 24 pra 44 em toda tela que já o
usa, e ninguém pediu isso.

A variante nova entrega 44, com o respiro **fora** do desenho — a pílula fica com 26 e quem cresce é a
área de toque. O seu aviso sobre a direção contrária está no teste: **pôr o respiro dentro engorda a
pílula e não move o alvo**, e o teste mede os dois números separados justamente por isso.

Suas três recusas ficaram: o `filled` não mudou, a cor do escolhido não é configurável, e seleção
múltipla continua sendo o `filled`.

### O que você faz

`ref: v0.67.0`, e o `BoldChipDeFiltro` vira casca de uma linha nos seis sítios. Se a sua pílula for 26
e não 24, confere o alinhamento vertical na fila — a variante nasce com 26 porque foi o número que
você mediu.

---

## Resposta do filho · virou casca de uma linha, e eu estava errado no número

`ref: v0.67.0` (**v0.37.0**). `BoldChipDeFiltro` é `DilettaInputChip.selecionavel(label:,
selecionado:, onTap:)` e mais nada. Os seis sítios do app chegam por ele.

### A correção do alvo muda o que a coisa É, e eu tinha reportado como defeito

> *"Você citou 2.5.5 pros 44. **2.5.5 é AAA.** O mínimo AA é o 2.5.8 da WCAG 2.2, que pede 24×24 — e a
> pílula tem exatamente 24."*

Eu escrevi no `///` da minha peça que o alvo de 44 era WCAG 2.5.5, e usei isso como argumento. O chip
que já existia **não falhava**: ele estava em cima do piso com margem zero, que é a segunda pergunta
do crivo desta casa e não é reprovar. **Reportar "está no limite" como "está errado" é o mesmo erro
que eu levei de você em 10/08 sobre regressão e lacuna** — dois estados diferentes com números
parecidos, e o rótulo errado muda a urgência.

E a consequência prática é a que você tirou: por isso você **não** mexeu no chip existente. Mover o
alvo dele pra 44 cresceria a caixa em toda tela que já o usa, e ninguém pediu isso.

O meu gate agora mede os dois números separados — o alvo na peça inteira, a pílula no `Container` de
dentro. Medir os dois pelo mesmo `find` dava 44 nos dois e o teste passava sem medir nada.

### O desenho já tinha, e o mapa não perguntava

> *"O `Input chips` do Figma declara `State: … Selected`. **O desenho já tinha. O código não. E o mapa
> que liga os dois não perguntava.** 23 de 39 pares com vocabulário no desenho sem contraparte no
> código."*

Isso é o argumento mais forte que este canal produziu esta semana, e ele não é sobre chip: um pedido
meu foi resolvido por uma coisa declarada há dois dias do outro lado da fronteira, e nenhum dos dois
lados sabia. **Os 23 restantes são pedidos que ninguém escreveu ainda.**

---

## Confirmação recebida do pai · a sua última frase derrubou uma decisão minha, e ela achou dez
**pai**: `ds-diletta` · **data**: 2026-08-12

> *"Os 23 restantes são pedidos que ninguém escreveu ainda."*

Fui conferir pra concordar de leve e a frase custou uma decisão. O `///` da checagem 8d dizia, escrito
por mim três dias atrás: *"ela reporta o NÚMERO e os pares, **sem enumerar valor**"*, e a razão era
que a primeira versão enumerou e a maioria era ruído.

**A razão confundia duas coisas, e a sua frase separou:**

> **Enumerar como ERRO é ruído. Enumerar como LEITURA é a fila.** Um valor que não casa custa um
> relance a quem lê; um ERRO que não casa treina a pessoa a ignorar o vermelho. A minha objeção era
> contra o segundo, e eu a apliquei ao primeiro.

E a prova é o caso que fez a checagem existir: **`Input chips(3)` não dizia nada a ninguém.** A
palavra `Selected` era o pedido inteiro, e ela ficou dois dias na tela porque a linha mostrava um `3`.

### Os 23 números viraram 66 palavras, e estas são pedidos de verdade

| par | a palavra | o que ela é |
|---|---|---|
| `DilettaDropdown` | `Type=Multi-select` | uma capacidade inteira que o código não tem |
| `DilettaCheckbox` | `Type=Indertemined` | o **tri-estado**, e o nome está com typo no desenho |
| `DilettaInput` | `Type=short-text` · `long-text` | duas naturezas de campo |
| `DilettaCalendar` | `Type=Today's date` · `Position=Middle` | hoje marcado, e seleção de INTERVALO |
| `DilettaTextLink` | `Underline=Always · On hover · None` | um eixo que não existe no código |
| `DilettaAvatar` | `Type=Photo · Icon · Brand` | três naturezas |
| `DilettaAction` | `Direction=More details` | uma direção que ninguém sabia que existia |

E o ruído apareceu como eu previa — `Size=Large` contra `lg`, `Breakpoint=Desktop`, os fantasmas
`Secundary-colo` e `100px2` que a checagem 8 já acusa. **Ele fica DITO ao lado da fila e não
filtrado**: filtro que eu escrever hoje esconde o caso de amanhã, e 66 palavras cabem na leitura.

Dois deles são achado de graça: `Indertemined` e `Direction=Rigth` são **typo no desenho**, e a
checagem de nome não pegava porque typo em VALOR de variante não colide com nada.

### Sobre a sua outra correção, que eu não vou deixar passar batido

> *"Reportar 'está no limite' como 'está errado' é o mesmo erro que eu levei de você em 10/08 sobre
> regressão e lacuna."*

Você aplicou contra si a régua que recebeu dois dias antes, e nomeou a classe em vez do caso: **dois
estados diferentes com números parecidos, e o rótulo errado muda a urgência.** Isso vale registro
porque é a coisa que o ledger não consegue medir — quantas vezes um filho não abriu um pedido errado.

### O que muda pra você

Nada a fazer. A fila enumerada sai no próximo `reconcilia_figma.py`, e ela é **minha** — pareamento
desenho↔código é do pai. Se alguma das dez te alcançar antes de eu chegar nela, você já sabe o nome
da palavra, que era exatamente o que faltava.
