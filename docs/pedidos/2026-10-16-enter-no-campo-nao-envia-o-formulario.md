# PEDIDO · Enter no campo não envia o formulário — o controle de dentro não tem formulário dono

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0`, pela tag `web-v0.125.0` deste repo
- **bloqueante?**: **sim, para a troca** — 51 dos 79 usos do `BoldTextField` do IB estão dentro de um `<form>`, e em todos eles Enter envia hoje
- **irmão**: `2026-09-22-o-botao-envia-um-formulario-do-qual-os-campos-nao-fazem-parte.md` (o `formAssociated` dos campos, ENTRA e aberto sem data) e `2026-10-15-os-atributos-nativos-do-input-nao-atravessam-para-o-campo.md` (ENTRA DIFERENTE na `v3.18.0`, que destravou o resto da troca)

## Falta

Que Enter no `<diletta-input>` de uma linha (texto, senha e os `type` nativos da `v3.18.0`) e no
`<diletta-date-field>` envie o formulário que contém o hospedeiro, como o `<input>` nativo faz pelo
envio implícito do HTML. Hoje o controle mora no shadow, o `form` dele é `null`, e Enter não faz nada.

## Número

Medido em 16/10 no Chrome 155 (Playwright com o Chrome instalado), numa página nua que carrega a
`web-v0.125.0` (avô `3.19.0`). Cada formulário tem um botão `type="submit"` e um ouvinte de `submit`:

| no formulário | Enter envia? | `form` do controle que tem o foco |
|---|:-:|---|
| `<input>` nativo | **sim** | o formulário |
| `<diletta-input>` | **não** | `null` |
| `<diletta-input type="password">` | **não** | `null` |
| `<diletta-date-field>` (o controle de dentro é um `<diletta-input>`) | **não** | `null` |
| elemento com `static formAssociated = true` e `<input>` no shadow | **não** | o hospedeiro tem o formulário; o `<input>` de dentro, `null` |

A última linha é a que importa para o irmão de 22/09: **o `formAssociated` não resolve isto**. O envio
implícito parte do controle que tem o foco e do formulário dono dele, e o `<input>` de dentro continua
sem dono mesmo quando o hospedeiro tem um.

No IB, os 51 campos em formulário estão em 14 arquivos: Pix (7), TED (4), boleto (2), cobrar com Pix
(4), Pix Automático (6), boleto de cobrança (9), contato (7), chaves (4), operadores (2), perfis (2),
renomear conta, a interna, o fluxo de pagamento e a entrada. Em todos, a pessoa digita e aperta Enter para continuar.

## Já tentei

- **Esperar o `formAssociated`**: medido acima, ele dá formulário ao hospedeiro e não ao controle.
- **Ouvir `keydown` no hospedeiro e chamar `form.requestSubmit()` no embrulho do IB**: funciona, porque
  o `keydown` é composto. Mas é a regra do navegador reescrita por cada filho: qual campo dispara (o
  `long` não), o que acontece sem botão de envio, o botão padrão desligado. E é comportamento do campo,
  não da tela.

## Conferi no pai

- O pedido de 22/09 lista quatro coisas que só existem juntas (`setFormValue`, `setValidity` com a
  âncora do foco, `formResetCallback`, `name`/`autocomplete` observados). Enter não está entre elas.
- O `<diletta-button acao="submit">` é `formAssociated` e envia no clique. O campo é a outra metade do
  mesmo formulário.
- A régua de paridade do próprio campo: *«onChanged, onSubmitted, onTap — evento, não atributo»*. O
  Dart tem `onSubmitted`; a web não faz nada no Enter.

## Derivável?

Por fora, sim, e é o que este pedido quer evitar: cada filho reescrevendo o envio implícito do HTML.

## Se você disser não

O IB escreve o `requestSubmit()` no embrulho do `BoldTextField`, só para o campo de uma linha, e faz o
mesmo no campo de data.

## Não estou pedindo

O `formAssociated` inteiro, que segue no irmão de 22/09. Validação. `enterkeyhint`. O `long`, em que
Enter é quebra de linha.

## O que não medi

O campo da entrada usa `autocomplete="username webauthn"`, o preenchimento da chave de acesso. Não medi
se ele alcança o controle dentro do shadow. Esse campo fica local no IB até alguém medir.

## Como o pai vai saber que funcionou

`<form><diletta-input></diletta-input><button type="submit">` → Enter no campo dispara `submit` uma vez.
O mesmo com `type="password"`, com os `type` nativos e com `<diletta-date-field>`. Com `type="long"`,
Enter quebra a linha e não envia. Fora de formulário, Enter não faz nada e não dá erro.
