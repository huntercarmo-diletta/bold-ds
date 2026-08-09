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
