# PEDIDO · O seletor e o campo de data não repassam a ajuda que o campo deles já tem — e o campo de valor não tem erro

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` (pino do pai, `packages/coreflow/pubspec.yaml:23`); o app vendoriza a
  `v0.113.0` deste repo, com o avô em `v0.204.0`. **Medido também na ponta, `v3.0.0` (`c7c9c94`)**: as
  linhas abaixo são dela, e o fato é o mesmo nas três versões
- **bloqueante?**: **não** — as telas funcionam. O que fica é o texto de apoio desenhado à mão ao lado
  da peça, com medida diferente da sua
- **irmão**: [o `DilettaInput` não repassa três que o `DilettaField` dele já tem](2026-08-08-o-input-nao-repassa-tres-que-o-field-dele-ja-tem.md)
  (**ENTRARAM OS TRÊS**, 08/08: *«é repasse e não peça»*). Este é a mesma forma, uma camada acima
- **encosta** na sua linha **aberta** de 18/09 (*o `helper` e o `error` do `DilettaInput` do Dart não
  somam*): lá o par ajuda/erro do campo vai ser mexido de qualquer jeito, com a suíte de retrato
- **não é peça nova**: o `busca()` não se aplica

## Falta

1. **`helper` no `DilettaDropdown` e no `DilettaDateField`.** As duas peças **montam um
   `DilettaInput`** e repassam `label`, `placeholder`, `error` e `disabled` — mas não `helper`, que o
   `DilettaInput` tem.
2. **`error` no `DilettaAmountField`.** A peça não tem nenhum dos dois textos de baixo, e quem valida
   valor (acima do saldo, abaixo do mínimo) monta o erro por fora.

## Número

**O repasse que falta**, na `v3.0.0`:

| peça | monta | repassa | não repassa |
|---|---|---|---|
| `DilettaInput` | — | tem `helper` (`diletta_input.dart:55`, `:114`), pintado em `labelSm` · `textMuted`, vão 8, recuo 12 (16 na área de texto) (`:282-286`, `:600-611`) | — |
| `DilettaDropdown` | `DilettaInput` (`diletta_dropdown.dart:215-228` e `:750-770`) | `label` · `placeholder` · `error` · `disabled` (`:75-78`) | **`helper`** |
| `DilettaDateField` | `DilettaInput` (`diletta_date_field.dart:84-97`) | `label` · `placeholder` · `error` · `disabled` (`:31-34`) | **`helper`** |
| `DilettaAmountField` | `DilettaField` (`diletta_amount_field.dart:109-122`) | — | **`error`** (construtor `:57-68`) |

**O custo, medido no app** (`app-newbold`, branch de trabalho de 29/09):

- **seletor com ajuda à mão** — `pix_cobrar_vencimento_flow.dart:940-957`: o `DilettaDropdown`
  «Estado» e, embaixo, um `Text('Obrigatório')` em `bodySm` · `textSecondary`, vão 4 e recuo 4. A peça
  desenharia `labelSm` · `textMuted`, vão 8 e recuo 12. O campo de texto da mesma tela
  (`:1035-1055`) repete a receita à mão, porque o nosso campo de texto também não repassa a ajuda
  (isso é nosso, e está na fila);
- **erro de valor à mão** — o pai (`packages/coreflow/lib/src/coreflow_campo_de_valor.dart:126-143`)
  embrulha o `DilettaAmountField` num `FormField` e desenha o erro com o **tema do Material**:
  `Theme.of(context).textTheme.bodySmall` e `colorScheme.error`, vão 6. O erro do `DilettaInput` é
  `labelSm` · `s.error`, vão 8. São 8 chamadas do campo de valor no app.

A medida da ajuda e do erro **não muda** com este pedido: o que se pede é que as três peças usem a
que o `DilettaInput` já tem.

## Já tentei

- **Compor por fora**, que é o que o app faz: cada tela escolhe o seu vão e o seu estilo. Contando
  a ajuda à mão embaixo de campo no app inteiro, são **9 sítios e quatro receitas** — vão 4 (com e sem
  recuo 4), 8 ou 12; `labelSm` ou `bodySm`; `textSecondary` inteiro ou a 160 de alfa — e **nenhuma**
  é a sua (`labelSm` · `textMuted` · vão 8 · recuo 12).
- **No pai**, o erro do campo de valor com o tema do Material é dívida nossa, e ela não se paga sem
  a porta: se eu copiar `labelSm` · `s.error` · 8 no `CoreflowCampoDeValor`, copio um número seu que
  muda sem me avisar.

## Conferi no pai

- `DilettaInput`, `DilettaDropdown`, `DilettaDateField` e `DilettaAmountField` na `v3.0.0`, com as
  linhas acima; o mesmo na `v2.5.0` (o `this.helper` só aparece em `diletta_input.dart:55`).
- A `library` do campo de valor (`diletta_amount_field.dart:31-33`): *«campo de valor não tem borda
  nem rótulo flutuante»*. **Não peço rótulo nem borda**: peço o erro, que é outra coisa — ele diz o
  que está errado no número, e não enfeita o número.

## Derivável?

- **Ajuda**: não. O `DilettaInput` é montado dentro das duas peças; não há onde passar.
- **Erro do valor**: só compondo por fora, que é o que já está desenhado à mão hoje.

## Se você disser não

A ajuda do seletor e do campo de data continua à mão em cada tela, com o vão e o estilo da tela, e o
erro do campo de valor continua com a tipografia do Material — a única peça de formulário do app cujo
erro não é seu.

## Não estou pedindo

1. **que ajuda e erro somem** — isso é a sua linha aberta de 18/09. Se ela mudar o `DilettaInput`,
   as duas peças que o montam herdam;
2. **rótulo ou moldura no campo de valor** — a razão de ele não ter está escrita e vale;
3. **ajuda no `DilettaOtpInput`** — o código de verificação tem a frase de apoio acima dos quadrados,
   e é texto de tela, não do campo;
4. **nenhum número novo**: vão, estilo e recuo são os do `DilettaInput`.

## Como o pai vai saber que funcionou

- `DilettaDropdown(helper: 'Obrigatório', …)` e `DilettaDateField(helper: …)` desenham a ajuda com o
  mesmo vão, estilo e recuo do `DilettaInput(helper: …)`, num teste de retrato lado a lado;
- `DilettaAmountField(error: 'Acima do saldo')` pinta a mensagem em `s.error`, com o degrau e o vão
  do erro do `DilettaInput`, e centralizada como o número.

## Como cheguei aqui

A designer pediu, em 29/09, depois de o `critico-de-composicao` revisar o formulário de representante
do onboarding no Figma e achar o rótulo do campo e o do seletor com medidas diferentes: *«verificar se
não existem outras divergências também»*. **O rótulo não diverge no código** (o seletor É um
`DilettaInput`; a diferença está no componente do Figma). A varredura das peças de formulário achou
esta e mais duas, em pedidos separados:
[o placeholder e o desligado](2026-09-29-o-placeholder-e-o-desligado-pintam-diferente-em-cada-peca-de-campo.md)
e [a moldura da busca e do código](2026-09-29-a-busca-e-o-codigo-nao-leem-a-moldura-do-campo.md).

---

## VEREDITO · ENTRA — é repasse, como o de 08/08, e o erro do valor é o do campo

**pai**: ds-diletta **v3.2.0** · **data**: 2026-09-29

### O que decidiu

O irmão que você mesmo citou: *«é repasse e não peça»*. O seletor e o campo de data montam um
`DilettaInput` e deixavam uma porta dele fechada. E o seu último item: *«nenhum número novo»*. Não há
número novo em nenhum dos dois.

### O que eu fiz

- **`helper` no `DilettaDropdown`** (as duas formas, a caixa e o silencioso) e **no `DilettaDateField`**,
  repassado ao `DilettaInput`. A ajuda sai com o vão, o degrau e o recuo dele;
- **`error` no `DilettaAmountField`**: `labelSm`, `s.error`, vão 8, centralizado como o número. É o
  degrau e o papel do erro do `DilettaInput`, lidos pelo tema e não copiados.

### O que eu achei indo implementar

nada

### O que eu recusei, e a condição de reabrir

Nada deste pedido. A soma de ajuda e erro segue a linha aberta de 18/09, e as duas peças que montam o
`DilettaInput` herdam o que ela decidir.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | a ajuda e o erro saem de 9 sítios à mão para a peça |
| escalabilidade | ↑ | o próximo filho não escreve a quinta receita |
| aplicação | ↑ | o seletor «Estado» e as 8 chamadas do campo de valor passam à peça |
| aderência ao mercado | = | ajuda e erro sob o campo é o arranjo comum |
| robustez | ↑ | o erro do valor deixa de depender do tema do Material |
| arquitetura limpa e simples | ↑ | repasse de uma porta que já existe |
| conciso | = | nada novo para escrever |

### O que você faz

`v3.2.0`. O `Text('Obrigatório')` embaixo do seletor vira `helper:`, e o `FormField` do
`CoreflowCampoDeValor` passa o erro para `error:`.
