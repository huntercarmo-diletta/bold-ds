# Pedido · a barra de progresso não muda de TOM — e num medidor de limite o tom é a informação

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.30.0 · pai v0.61.0
- **data**: 2026-08-09

## O que falta

Um `tone` na `DilettaProgressBar` — ou, no molde que você já usa, um `state` do mesmo vocabulário do
`DilettaSpotIcon` (`normal` · `warning` · `error`).

## A medição, e ela é o oposto do pedido do spot

Na auditoria de hoje, `LinearProgressIndicator` do Material caiu de 3 pra **2**. O que saiu foi a
barra de passo do formulário — progresso puro, sem significado de cor —, e a sua
`DilettaProgressBar.value` cobriu inteira, sem eu pedir nada.

Os 2 que ficaram são o **medidor de limite** (o quanto o operador já gastou da alçada dele), e ali a
cor não é enfeite:

| faixa | tom | o que a pessoa entende |
|---|---|---|
| até 80% | `primary` | tem espaço |
| 80–100% | `warning` | está no fim |
| estourou | `danger` | passou do limite |

**A sua barra pinta sempre com a tinta de atividade** (`primary-04` no trilho `neutral-07`). Trocar
por ela apagaria a única coisa que o medidor diz sem texto — e o texto ao lado só mostra o valor, não
a proximidade do teto.

## Por que isso é pedido e não gosto

Porque a linguagem **já tem essa distinção em outra peça**. O `DilettaSpotIcon` muda de tinta por
`state`, e o `DilettaStatusTag` muda por `tone` — os dois pela mesma razão: *o estado é informação*.
A barra é a única das três que não muda, e não achei nada escrito dizendo que isso é decisão.

São **2 sítios**, o mesmo medidor duas vezes, e é exatamente o segundo caso da régua deste repo — por
isso ele vem com número em vez de ficar como exceção permanente no meu gate.

## Onde eu ACHO que mora

No molde que você já usa nas irmãs:

```dart
DilettaProgressBar.value(
  value: usado / limite,
  state: DilettaSpotState.warning,   // o mesmo enum das outras duas
)
```

Duas coisas que eu **não** estou pedindo:

1. **o LIMIAR.** 80% é regra deste produto, não da linguagem. Quem decide quando vira aviso é quem
   conhece a alçada — a peça só precisa saber pintar;
2. **variante nova.** O `.value` já existe e já é a certa; o que falta é uma tinta por estado, que é
   o mesmo `switch` que o spot faz.

## Como o pai vai saber que funcionou

`LinearProgressIndicator` some do app (3 → 0), e a exceção nomeada no gate
`a_tela_nao_desenha_sozinha_test` deixa de existir — hoje ela está lá com dono e com este pedido no
nome.

---

## Veredito · ENTRA, mas não pelo número que você trouxe — e a medição derrubou o desenho que eu ia fazer
**pai**: `ds-diletta` **v0.63.0** · **data**: 2026-08-10

### Por que entra, e o seu próprio argumento é melhor que a sua contagem

Você trouxe **2 sítios** e chamou de *"exatamente o segundo caso da régua deste repo"*. Não é: são **o
mesmo medidor duas vezes**, e isso é um caso, não dois. Se dependesse da contagem, este pedido esperava.

O que fez entrar foi a frase que você escreveu depois: **"a barra é a única das três que não muda, e não
achei nada escrito dizendo que isso é decisão."** Ali você mediu a CLASSE, não o seu caso —
`DilettaSpotIcon` muda por `state`, `DilettaStatusTag` muda por `tone`, e a barra pintava sempre igual
sem razão nenhuma escrita. *Buraco de simetria não espera promoção*, e a régua já estava aqui.

### O enum é novo e estreito, e não o que você pediu — porque a medição não deixou

Você propôs *"o mesmo enum das outras duas"*. **As outras duas não usam o mesmo enum**, e medir isso foi
o primeiro achado do seu pedido: `DilettaSpotState` tem 8 valores com `error` e `normal`;
`DilettaStatusTone` tem 7 com `danger` e `neutral`. **Esta linguagem tem SEIS vocabulários de estado e
eles discordam entre si.** Está aberto no ledger; unificar é major.

Eu ia reusar o `DilettaStatusTone` — reuso em vez de vocabulário novo, que é o critério certo. **Fui
medir antes e a escolha caiu**: o `switch` exaustivo nos sete me obrigaria a pintar `neutral` e
`pending`, e no modo escuro os dois dão **1,00** de contraste contra o trilho. Ou seja: **barra
invisível**. Enum largo forçaria a linguagem a responder por estados que um medidor não tem.

Então: `DilettaProgressTone { normal, warning, error }`. Os nomes saíram de **contagem**, não de gosto —
`normal` aparece em 4 vocabulários e `error` em 4, contra `danger` em 2.

```dart
DilettaProgressBar.value(value: usado / limite, tone: DilettaProgressTone.warning)
```

Suas duas exclusões ficaram as duas: **o limiar é seu** (*"80% é regra deste produto"* — a peça só sabe
pintar) e **nenhuma variante nova** (`.value` já era a certa).

### O número que você precisa saber antes de trocar as duas telas

Elemento gráfico pede **3:1** (WCAG 1.4.11). Contra o trilho `neutral07`:

| tom | claro | escuro |
|---|---|---|
| `normal` (o que já embarcava) | 2,68 | 1,66 |
| `warning` | **1,82** | **1,17** |
| `error` | 3,40 | 2,21 |

**Nenhum alcança 3:1, e o `warning` — que é o que o seu medidor mais precisa que se veja — é o pior dos
três.** Isso não é dívida que o `tone` criou: o default já era 2,68/1,66 antes dele. **A causa é o
trilho**, que está perto demais em luminância das cores semânticas, e no escuro piora. Consertar é
trocar o trilho, o que move toda barra que já existe — é outro pedido, e o número acima é o ponto de
partida. Aberto no ledger.

E a ressalva que o seu pedido não faz e eu faço: **cor sozinha não é informação** (WCAG 1.4.1). Você
escreveu que *"o texto ao lado só mostra o valor, não a proximidade do teto"* — então o seu medidor
depende de matiz pra dizer a coisa mais importante. O `tone` entrega a tinta; quem tem dificuldade de
cor continua sem o aviso **até o texto dizer**.

### O que você faz

`ref: v0.63.0`. Troque os 2 sítios, escolha o limiar, e **acrescente o texto** — sem ele o medidor
continua dizendo por cor uma coisa que só a cor diz. Se o `warning` não ler na sua tela, o número acima
é o argumento pronto pro pedido do trilho.

---

## Resposta do filho · os dois trocaram, e o TEXTO entrou porque você mediu o que eu não medi

`ref: v0.63.0` (**v0.32.0**). Os 2 sítios usam `DilettaProgressBar.value(tone:)`, o limiar de 80% ficou
aqui numa função só (`_tomDoLimite`), e **`LinearProgressIndicator` fechou em zero** — a única exceção
nomeada no meu gate deixou de existir.

### A minha contagem estava errada, e do jeito que importa

Eu escrevi *"2 sítios, exatamente o segundo caso da régua"*. Você respondeu: **o mesmo medidor duas
vezes é um caso, não dois.** Isso me pega numa coisa que eu já tinha feito certo em outro pedido — no do
spot herói eu contei **discordância** (quatro diâmetros, três formas) e não sítios. Aqui eu contei
cópia e chamei de classe.

Regra que eu passo a aplicar: **antes de escrever o número, perguntar se ele mede coisas diferentes ou
a mesma coisa repetida.** Sítio repetido é alcance; caso é forma.

### O contraste mudou a entrega, não só a nota

Você devolveu com o número: `warning` dá **1,82 no claro e 1,17 no escuro** contra o trilho, e o piso é
3:1. Eu tinha escrito no pedido que *"o texto ao lado só mostra o valor, não a proximidade do teto"* — e
usei isso como argumento PRO tom, sem ver que era a descrição de um defeito meu.

**Então o texto entrou junto**, nos dois medidores: `perto do teto` acima de 80%, e o `teto consumido`
que já existia no estouro. O segundo medidor só falava no estouro; a faixa de aviso era **cor pura**.
Sem o seu número eu teria trocado a tinta e considerado o item fechado — com a barra menos visível do
que antes em modo escuro, e o aviso mais importante dito só por matiz.

### O que eu NÃO faço, e é a sua deixa

Não abro o pedido do trilho hoje. O número é seu e está escrito, mas quem tem que medir se o `warning`
lê nesta tela é este produto — e eu não tenho a medição na tela real (não consigo entrar no app agora).
Quando tiver, o pedido vai com a leitura daqui e o seu número como ponto de partida.
