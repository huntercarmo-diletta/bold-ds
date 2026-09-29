# PEDIDO · O placeholder e o desligado pintam diferente em cada peça de campo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` (pino do pai, `packages/coreflow/pubspec.yaml:23`); o app vendoriza a
  `v0.113.0` deste repo, com o avô em `v0.204.0`. **Medido também na ponta, `v3.0.0` (`c7c9c94`)**: as
  linhas abaixo são dela, e o fato é o mesmo na `v2.5.0` e na cópia do app
- **bloqueante?**: **não**
- **irmãos**: [o seletor e o campo de data não repassam a ajuda](2026-09-29-o-seletor-e-o-campo-de-data-nao-repassam-a-ajuda-e-o-campo-de-valor-nao-tem-erro.md)
  e [a busca e o código não leem a moldura do campo](2026-09-29-a-busca-e-o-codigo-nao-leem-a-moldura-do-campo.md),
  da mesma varredura
- **não é peça nova**: o `busca()` não se aplica

## Falta

Uma regra só para as peças de entrada, em dois estados:

1. **placeholder**: qual papel ele lê — `textPlaceholder`, que existe para isso, ou `textMuted`;
2. **desligado**: o que apaga — só o valor, ou também o rótulo e a ajuda.

Hoje cada peça responde de um jeito.

## Número

### 1 · Placeholder: dois papéis

| peça | papel do placeholder | onde |
|---|---|---|
| `DilettaInput` (e por ele o seletor, o campo de data e o nosso `CoreflowCampoDeTexto`) | **`textMuted`** | `diletta_input.dart:385-391` |
| `DilettaField` (o padrão, usado pela busca) | `textPlaceholder` | `diletta_field.dart:206` |
| `DilettaSearchInput` | `textPlaceholder` (pelo padrão do `DilettaField`) | `diletta_search_input.dart:132-140` |
| `DilettaDropdown` `silencioso` | `textPlaceholder` | `diletta_dropdown.dart:250-256` |
| `DilettaAmountField` | `textPlaceholder` | `diletta_amount_field.dart:113` |

**Os dois papéis só coincidem para quem declara o mudo.** Na derivação do claro
(`diletta_scheme.dart:517-520`), sem declaração, `textMuted` começa em `neutral04` e
`textPlaceholder` em `neutral05`: um degrau de diferença entre o placeholder do campo e o da busca
logo acima dele. **No Bold não aparece**, porque ele declara `textoMudoClaro` e `textoMudoEscuro`
(`coreflow_design_system/lib/src/bold_palette.dart:270`, `:287`, `:413`, `:428`) e os dois papéis
caem na mesma cor. Aparece em todo filho que não declara.

### 2 · Desligado: quatro respostas

| peça | o que apaga | o que fica aceso | onde |
|---|---|---|---|
| `DilettaInput` | fundo `surfaceSubtle`, borda `divider`, valor e placeholder `textDisabled`, **o contador** `textDisabled` | **rótulo** (`textTertiary`) e **ajuda** (`textMuted`): nem `_CpsInputLabel` nem `_CpsInputTooltip` recebem o estado | `:338-340`, `:306-307`, `:388`, `:446`, `:535` × `:550-571`, `:589-614` |
| `DilettaCheckbox` | rótulo e descrição `textDisabled` — **mas só pelo `disabled`**: o `statusForcado: disabled` apaga a caixa (`desligado`, `:83`) e deixa o texto aceso (`:187`, `:195` leem `disabled`) | com `statusForcado`, o texto | `:83`, `:187`, `:195` |
| `DilettaOtpInput` | nada: `enabled: false` só impede a digitação | os quadrados inteiros | `:40`, `:129`, `:192-198` |
| `DilettaAmountField` | o número vai para **`textPlaceholder`**, não `textDisabled` | — | `:93` |
| `DilettaRadioList` | não tem estado desligado | — | construtor `:58-64` |

O mais curto de ver é dentro do próprio `DilettaInput`: desligado, **o contador embaixo apaga e a
ajuda ao lado dele não**.

## Já tentei

Nada por fora: é pintura dentro da peça, e nenhuma dessas cores é passável por parâmetro.

## Conferi no pai

- As cinco peças acima na `v3.0.0` e na `v2.5.0` (a linha do placeholder do `DilettaInput` é a
  `:388` nas duas; o `neutral07` do código e o `disabled` do checkbox idem).
- O seu veredito de 17/08 (`textPlaceholder` ganha piso na derivação, *«três papéis de apoio, nos
  dois modos»*): os dois papéis passam no piso, então a pergunta não é contraste, é **qual dos dois o
  placeholder é**. O papel com o nome existe e é lido por quatro das cinco peças.
- O seu veredito de 17/08 também isenta `textDisabled` do piso *de propósito*: nada aqui pede piso
  para o desligado.

## Derivável?

Não. As cores estão cravadas dentro das peças.

## Se você disser não

- **placeholder**: o filho que não declara o mudo tem dois cinzas de placeholder no mesmo formulário
  (campo × busca, campo × campo de valor);
- **desligado**: um formulário travado (por exemplo, dados que a pessoa não pode editar depois de
  enviar) mostra o rótulo e a ajuda como se o campo estivesse ativo, e o checkbox do catálogo
  forçado em `Disable` mostra texto ativo com caixa apagada.

## Não estou pedindo

1. **cor nova ou piso novo** — os papéis existem;
2. **que o rótulo desligado desapareça** — ele continua dizendo o que o campo é; a pergunta é se ele
   esmaece junto;
3. **estado desligado no `DilettaRadioList` sem sítio** — está na tabela para a regra ficar
   completa; hoje nenhum dos 4 usos do app o desliga;
4. **que o `DilettaOtpInput` vire campo com rótulo** — o quadrado dele é outra forma, e fica.

## Como o pai vai saber que funcionou

- num esquema **sem** `textoMudoClaro`, o placeholder do `DilettaInput`, do `DilettaSearchInput` e do
  `DilettaAmountField` sai da mesma cor;
- `DilettaInput(disabled: true, label: …, helper: …)` e `DilettaCheckbox(statusForcado: disabled,
  label: …)` pintam rótulo e ajuda pela mesma regra, qualquer que seja a escolhida; e o
  `DilettaOtpInput(enabled: false)` e o `DilettaAmountField(enabled: false)` mostram que estão
  desligados.

## Como cheguei aqui

A mesma varredura das peças de formulário que a designer pediu em 29/09, a partir do formulário de
representante do onboarding (ver o [irmão da ajuda](2026-09-29-o-seletor-e-o-campo-de-data-nao-repassam-a-ajuda-e-o-campo-de-valor-nao-tem-erro.md)).

---

## VEREDITO · ENTRA — placeholder é `textPlaceholder`, e desligado apaga todo texto do campo

**pai**: ds-diletta **v3.2.0** · **data**: 2026-09-29

### O que decidiu

As duas perguntas eram minhas, e a sua medição respondeu as duas:

1. **Placeholder**: o papel com o nome existe, e quatro das cinco peças o leem. A que lia `textMuted`
   era o `DilettaInput`, e ele passa a `textPlaceholder`;
2. **Desligado**: a frase que decidiu é sua: *«desligado, o contador embaixo apaga e a ajuda ao lado
   dele não»*. A regra é **desligado apaga todo texto do campo** — rótulo, ajuda, valor e contador —, e
   o erro continua vencendo. É a regra do Material 3.

### O que eu fiz

- `DilettaInput`: placeholder em `textPlaceholder`; rótulo e ajuda em `textDisabled` quando desligado;
- `DilettaCheckbox`: o texto lê o estado efetivo, e o `statusForcado: disabled` apaga o texto junto
  com a caixa;
- `DilettaOtpInput`: desligado pinta como o campo (fundo `surfaceSubtle`, borda `divider`, dígito
  `textDisabled`);
- `DilettaAmountField`: desligado é `textDisabled`, e não `textPlaceholder`.

### O que eu achei indo implementar

nada

### O que eu recusei, e a condição de reabrir

**O `DilettaRadioList` desligado.** Zero sítios. Reabre no primeiro uso desligado.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma regra no lugar de quatro respostas |
| escalabilidade | ↑ | o filho que não declara o mudo deixa de ter dois cinzas de placeholder |
| aplicação | ↑ | o formulário travado mostra que está travado |
| aderência ao mercado | ↑ | é o desligado do Material 3 |
| robustez | ↑ | o gate mede cor por papel em cinco peças, numa paleta em que os dois cinzas se separam |
| arquitetura limpa e simples | = | papéis que já existiam |
| conciso | = | nada novo para escrever |

### O que você faz

`v3.2.0`. No Bold não muda um pixel de placeholder, porque você declara o mudo e os dois papéis caem
na mesma cor. O desligado muda: rótulo e ajuda passam a esmaecer.
