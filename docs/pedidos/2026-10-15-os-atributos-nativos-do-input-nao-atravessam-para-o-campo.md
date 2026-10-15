# PEDIDO · Os atributos nativos do `<input>` não atravessam para o campo — `type`, `autocomplete`, `name`, `autofocus`, `min`, `max`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.13.0` · `web-v3.13.0`, pela tag `web-v0.123.0` deste repo
- **bloqueante?**: **sim, para a troca** — o `BoldTextField` do IB (85 sítios) só vira embrulho do `<diletta-input>` quando o que as telas já passam ao `<input>` chegar ao controle de dentro
- **irmão**: `2026-09-17-o-campo-nao-tem-onde-por-icone-ajuda-nem-botao.md` (onde `inputmode` e `maxlength` entraram *«como atributo repassado»*) e `2026-09-21-os-aria-param-no-hospedeiro.md` (a regra da lista nomeada)

## Falta

Que uma lista nomeada de atributos nativos do `<input>` seja repassada do hospedeiro ao controle de dentro, como `inputmode` e `maxlength` já são: `type` além de `text`/`password`/`long` (`date`, `search`, `email`, `tel`, `number`, `url`), `autocomplete`, `name`, `autofocus`, `min` e `max`. Hoje o render escreve `type="text"` para tudo que não é senha nem longo, e o resto não tem porta nenhuma.

## Número

Medido em 15/10 nos 85 usos do `BoldTextField` do IB (28 arquivos), o que as telas passam hoje ao `<input>` e o elemento descartaria:

| atributo | usos | o que faz na tela |
|---|--:|---|
| `type="date"` | **12** | vencimento de boleto, período de cobranças, data de agendamento — com `min` e `max` no agendamento |
| `type="search"` | **5** | as buscas de lista: papel `searchbox` e o X nativo de limpar |
| `type="email"` | 1 | o convite de operador: teclado e validação do navegador |
| `autocomplete` | **20** | `off` em 17 campos com máscara (CPF/CNPJ, CEP, celular), onde o preenchimento automático do navegador quebra a máscara; `one-time-code` no código do app; `tel-national`; `email` |
| `autofocus` | 1 | o nome do contato novo |
| `name` | 2 | formulários que o servidor lê por nome |
| `onBlur` | 1 | validação ao sair do campo — esta atravessa por `focusout`, que é composto; não está no pedido |

O que o elemento faz com `type="date"` hoje: `type="text"`. A pessoa digita a data à mão num campo de texto, sem o seletor do navegador, e `min`/`max` somem.

## Já tentei

- **Passar os atributos no hospedeiro** (`<diletta-input type="date" autocomplete="off">`): `type` é observado e vira `text`; os outros ficam no hospedeiro, que não é o controle — o navegador não os vê.
- **Escrever no controle de dentro pelo `shadowRoot`**: é a mão que esta casa já recusou duas vezes, e o `pinta()` reescreve o nó a cada `erro` que muda.
- **Manter o `BoldTextField` local nos 42 sítios que usam esses atributos e trocar os outros 43**: duas peças para o mesmo campo, com o mesmo desenho — o que a adoção existe para apagar.

## Conferi no pai

- O veredito de 17/09 (*«TRÊS ENTRAM, DOIS ENTRAM DIFERENTE»*) já separou as duas coisas: EIXO é o que nasce de `enum` na spec; `inputmode` e `maxlength` entraram como **atributo repassado**, sem virar eixo. É a mesma classe: HTML que o controle entende e o hospedeiro só precisa deixar passar.
- O veredito dos `aria-*` (22/09) fixou a forma: **uma lista nomeada**, repassada ao elemento com papel e apagada do hospedeiro. O pedido é a mesma lista, para os atributos de formulário.
- O `///` do próprio campo: *«o valor é atributo porque não há `controller`, e (…) `pattern`), e duplicá-los como eixo seria a linguagem reescrevendo HTML»*. Concordo com a frase: não é eixo. É repasse.
- `type="date"`: o lote 2 da paridade traz o campo de data da linguagem. Se ele cobrir os 12 sítios, `date` sai desta lista; `search`, `email`, `autocomplete`, `name`, `autofocus`, `min` e `max` ficam.

## Derivável?

Não: o controle mora no shadow.

## Se você disser não

O IB mantém o `BoldTextField` local nos 85 sítios e o `<diletta-input>` não entra em tela nenhuma do produto — o campo mais usado da casa fica fora da linguagem.

## Não estou pedindo

Eixo novo nem validação: `pattern`, `required` e a mensagem de erro continuam da tela. Pedindo só o repasse, por lista, dos atributos que o `<input>` já entende.

## Como o pai vai saber que funcionou

`<diletta-input type="search" autocomplete="off" name="busca" autofocus min="…" max="…">` → o `.campo` de dentro sai com os mesmos seis atributos, e `type="date"` desenha o seletor do navegador. O gate que confere `inputmode` e `maxlength` ganha as seis linhas.
