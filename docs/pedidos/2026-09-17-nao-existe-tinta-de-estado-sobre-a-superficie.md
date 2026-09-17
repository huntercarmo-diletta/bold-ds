# PEDIDO · Não existe tinta de estado sobre a superfície — e é a terceira vez que a sua lição se aplica

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não** — está declarado como dívida no consumidor, com as 25 regras listadas,
  travadas por catraca nos dois sentidos. Não conserta nada; impede de piorar.

## O caso, achado medindo o modo claro

Quinze lugares do Internet Banking põem `warning` ou `success` **direto sobre a página** — texto e
glifo, sem pastilha atrás. Medido contra `--cps-surface`:

| papel | claro | escuro | onde |
|---|---|---|---|
| `warning` | **2,08:1** | 10,18 ✓ | 9 regras — 5 ícones, 4 textos |
| `success` | **4,04:1** | 9,18 ✓ | 6 regras — 1 ícone, 5 textos |

O piso é 4,5:1 para texto e 3:1 para gráfico. **O âmbar não alcança nem o de gráfico.**

E só falha no claro, nos dois casos. É o mesmo padrão que este consumidor vem encontrando a semana
inteira: o escuro foi desenhado e revisado, o claro não.

## Fomos procurar o papel certo e descobrimos que ele não existe

A primeira proposta interna foi trocar por `onWarningSubtle` e `onSuccessSubtle`, que passam
(**6,54** e **5,38** no claro). **A designer recusou, e ela estava certa** — o seu `///` diz por quê:

> *Conteúdo sobre o preenchimento SUTIL de cada role. (…) o TEXTO sobre o tinte sutil precisa de
> 4.5:1 **contra o tinte**.*

A tinta foi medida **contra a pastilha**. Usá-la sobre a página é tirar o papel do par para o qual
ele foi construído — exatamente o erro que os seus `onSubtle` existem para acabar.

Fomos então olhar a família inteira do âmbar, e **cada papel foi medido contra um fundo diferente**:

| papel | medido contra | para quê |
|---|---|---|
| `warning` | a tinta que vai sobre ele | **fundo** de tag |
| `warningSubtle` | — | a pastilha |
| `onWarningSubtle` | **a pastilha** | texto dentro da tag |
| `warningGrafico` | **o trilho do medidor** | a barra |

`warningGrafico` dá o mesmo valor que `warning` no nosso esquema porque ele é
`_primeiroQueAlcanca(3.0, trilho, [...])` — contra o trilho o âmbar base já alcança. Contra a página,
não.

**Nenhum dos quatro foi medido contra `surface`.** Não é falta de sorte na escolha: é a lacuna.

## O pedido

Um par novo: **tinta de estado sobre a superfície**, para `warning` e `success` — e para `error` se a
sua medição disser que ele precisa.

O precedente são os seus dois, e o argumento é a sua frase, escrita duas vezes:

> *«um token não serve duas exigências de contraste ao mesmo tempo»*
> *«não é igual a nenhum papel existente em AMBOS os modos, e é por isso que ele precisa de nome
> próprio em vez de reaproveitar um»*

Foi assim que nasceram o `onSubtle` (porque tag de `warning` dava 2,16:1) e o `Grafico` (porque a
barra dava 2,55 na Aurora). O nosso caso é o terceiro da mesma família, e chega com o mesmo tipo de
número.

E a sua régua de fechamento se aplica inteira: *«papel especulativo é o que este repo recusa»*. Este
não é — são 15 sítios medidos, num produto em produção, num modo que já mandamos para revisão.

Como nos dois anteriores, **papel novo não cobra filho nenhum**: ele deriva da paleta que já existe.
No claro o degrau provável é o mesmo que o `onWarningSubtle` já usa (`warning02`, 6,54 contra a
página); no escuro o `warning` de tela já dá 10,18.

## O que fizemos enquanto isso

Nada — de propósito. A dívida está declarada no gate do consumidor, com as 25 regras nomeadas, o
número de cada uma e o modo em que falha. A catraca fecha nos dois sentidos: uso novo de qualquer um
dos três papéis reprova, e **consertar** uma das 25 também reprova, obrigando a podar a lista.

Escolher um papel errado para tapar o número seria pior que a dívida: trocaria um problema visível
por um invisível, que é o que o `onSubtle` ensinou a não fazer.
