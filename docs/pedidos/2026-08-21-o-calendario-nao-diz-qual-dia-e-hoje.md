# PEDIDO · o calendário não diz qual dia é HOJE

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.141.0 (você já está na v0.142.0) · DS filho v0.66.0
- **bloqueante?**: sim pra a casca `bold_date_picker` delegar. É o único item dela.

## Falta

Marcador de **hoje** no `DilettaCalendar`.

## Número

No seu arquivo, `DateTime.now()` aparece **uma vez** (linha 74) e só escolhe o mês que abre. Nenhuma
outra leitura da data corrente: a célula não sabe que dia é hoje.

O meu desenha um **ponto de 4px** logo abaixo do número, e só quando o dia **não** está selecionado —
selecionado já é um círculo cheio, e dois marcadores no mesmo dia é ruído.

O resto da minha célula é IGUAL à sua, e isso é o que faz o pedido ser de uma linha:

| | você | eu |
|---|---|---|
| caixa | 40 × 40, círculo | 40 × 40, círculo |
| selecionado | `s.primary` + peso 700 | `c.primary` + peso 700 |
| **hoje** | — | ponto 4px, `primary` |

As duas outras diferenças são **minhas e não são pedido**: tipografia (`BoldType.body` 400 contra
`DilettaType.button` 500) e desabilitado (`textMuted` contra `Opacity(0.4)`). Se o marcador entrar, eu
delego a célula inteira e as duas viram adoção, não divergência.

## Já tentei

**Passar `selectedDate: hoje` ao abrir.** Mente, e o defeito é conceitual: seleção é escolha da
pessoa, hoje é fato do calendário. Com os dois no mesmo canal, quem abre a tela não distingue *"não
escolhi nada"* de *"escolhi hoje"* — e no agendamento de Pix isso é a diferença entre agendar e não
agendar.

## Conferi no pai

- `DilettaDateField` abre o calendário num bottomsheet e não acrescenta marcador nenhum;
- a lista de regras do `///` (semana no domingo, selecionado = círculo cheio, fora da faixa =
  desabilitado, mês com `Motion.medium`) não cita hoje — não é regra recusada, é regra ausente;
- nenhuma paleta declara nada sobre a célula, então isso não é escolha de produto hoje.

## Derivável?

Não da minha parte: a data corrente é do sistema, e o desenho do marcador é seu.

## Se você disser não

A casca continua desenhando a célula inteira (2 primitivos) por causa de um ponto, e eu escrevo isso
no plano com o número — 40 × 40 iguais, uma diferença de 4px.
