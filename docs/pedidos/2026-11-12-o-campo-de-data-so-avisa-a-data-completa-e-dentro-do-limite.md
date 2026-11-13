# PEDIDO · O campo de data só avisa a data completa, com barra e dentro do limite: apagar, errar o limite e digitar no iPhone não chegam a quem usa

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.27.0` · `web-v3.27.0`, pela `web-v0.130.0` deste repo, a do Internet Banking `core-flow-ib` na homologação de 12/11 (`562bacbf`). A `main` do pai não mexeu em `diletta-date-field.js` nem em `diletta-input.js` depois da `v3.27.0`
- **bloqueante?**: não. As 13 datas do IB ficam no `<input type="date">` nativo do `BoldTextField` até o veredito
- **reabre**: o veredito de 15/10 do pedido `2026-10-15-os-atributos-nativos-do-input-nao-atravessam-para-o-campo.md`, que recusou `type="date"` no `<diletta-input>` com a condição escrita: «Reabre se o campo de data não cobrir algum dos 12». São 13 hoje, e o campo não cobre os casos abaixo
- **irmão**: `2026-11-12-o-texto-do-campo-tem-14-px-e-o-safari-do-iphone-amplia-a-pagina.md`. O campo de data mora num `<diletta-input>`, e o zoom do irmão acontece nele também

## Falta

O `<diletta-date-field>` só emite `mudou` quando a pessoa termina uma data válida, escrita com barra e dentro de `min`/`max`. Os outros desfechos não chegam a quem usa a peça, e no iPhone não dá para escrever a barra.

| item | o que é | sítios do IB |
|---|---|---|
| 1 | **apagar a data não avisa**: o campo fica vazio, e a peça continua com o `valor` de antes | os 2 opcionais («Término (opcional)», «Fim da vigência (opcional)», com «Em branco…» na dica) e o filtro de período de Recebimentos (Início e Fim) |
| 2 | **data fora do limite ou incompleta não avisa nada**: fica escrita no campo, sem `mudou`, sem erro e sem `aria-invalid` | «Data do pagamento», que tem `min`, `max` e a mensagem de erro dela; e, para a incompleta, as 13 |
| 3 | **a peça não leva o foco ao campo de dentro**: o hospedeiro não delega o foco | «Data de emissão» e «Vencimento» do cadastro de nota, num formulário que leva o foco ao primeiro inválido |
| 4 | **no iPhone não se escreve a data**: o teclado é numérico, sem «/», e a peça só lê `dd/mm/aaaa` | as 13; no celular, a data só entra pelo calendário |

Os quatro são independentes, e nenhum depende da ordem dos outros.

## Número

Medido em 12/11 numa página isolada que carrega o avô da `web-v0.130.0` (`avo/index.js`, as duas folhas de tokens), com um `<diletta-date-field label="Vencimento">` e um ouvinte de `mudou`. Usei o navegador do app (Chromium) e o simulador do iPhone 17 com iOS 26.5:

| ação | o campo mostra | `valor` da peça | `mudou` |
|---|---|---|---|
| digitar «12/11/2026» | 12/11/2026 | `2026-11-12` | `2026-11-12` |
| depois, apagar tudo | (vazio) | **`2026-11-12`** | **nenhum** |
| com `min="2026-11-20"`, digitar «12/11/2026» | 12/11/2026 | **nenhum** | **nenhum**; sem `erro` e sem `aria-invalid` |
| digitar «12112026» | 12112026 | **nenhum** | **nenhum** |
| `focus()` no hospedeiro | — | — | o foco não vai a lugar nenhum: `shadowRoot.delegatesFocus` é `false` |
| tocar no campo, no iPhone | teclado com 0 a 9 e apagar | — | — |

As imagens do iPhone estão na pasta deste pedido (`2026-11-12-o-campo-de-data-so-avisa-a-data-completa-e-dentro-do-limite/`): `iphone-teclado-sem-barra-e-zoom.png` e `iphone-digitado-sem-mudou.png`.

**No IB, as 13 datas:**
- **«Data do pagamento»:** é a única com `min` e `max`, e tem erro e dica.
- **Os opcionais:** 2 aceitam vazio.
- **O cadastro de nota:** 2 datas, num formulário que leva o foco ao primeiro inválido (`querySelector('[aria-invalid="true"]')`).
- **O resto:** 2 são o filtro de período de Recebimentos, e 6 são datas de cobrança e de Pix Automático.

Fora da conta, o `BoldDateRange` (3 filtros, 2 datas nativas cada) iria para a mesma peça.

## Já tentei

- **Ficar com o `<input type="date">` nativo do `BoldTextField`.** É o que está no ar. Funciona nos quatro casos, e é o que o veredito de 15/10 recusou: o seletor nativo desenha diferente em cada navegador. Fica de pé até aqui.
- **Ouvir o `input` do `<diletta-input>` de dentro**, para saber do vazio e do texto incompleto. Exige atravessar o shadow da peça, que é a mão que esta casa já recusou.
- **Validar no IB o que foi digitado.** O IB não vê o texto: ele mora no shadow, e o `valor` não muda.
- **Dar a barra ao teclado com `inputmode="text"`.** O campo de data escreve `inputmode="numeric"` no `<diletta-input>` dele, e o hospedeiro não repassa o atributo. Trocar por fora seria redesenhar a peça.
- **Levar o foco ao campo de dentro com `shadowRoot.querySelector(...).focus()`.** É o mesmo problema: o IB entra no shadow do pai.

## Conferi no pai

- **`diletta-date-field.js` da `web-v3.27.0`:**
  - **A conversão do texto:** `daTela` aceita só `^(\d{2})\/(\d{2})\/(\d{4})$`.
  - **Quem emite `mudou`:** o ouvinte de `mudou` do campo de dentro só chama `#aceita` quando a data é válida (`if (d)`), e `#aceita` retorna sem emitir quando a data passa de `min`/`max`.
  - **O foco:** `attachShadow({ mode: 'open' })`, sem `delegatesFocus`.
  - **O que o campo de dentro recebe:** `inputmode="numeric"` e `maxlength` 10 (16 com `hora`).
- **`diletta-input.js`, da mesma tag, faz o contrário em dois pontos:** delega o foco (`ENTRA DIFERENTE` de 22/09) e emite `mudou` a cada tecla. O campo de data embrulha esse campo e perde as duas coisas.
- **A régua dos dois lados do campo de data** declara `onChanged` como «o evento `mudou`, com a data ISO no `detail`». O vazio e o inválido ficam sem lugar nela.
- **Na `main` do pai** não houve mudança nesses arquivos depois da `v3.27.0`.

## Derivável?

Não do que declaro. O texto digitado mora no shadow, e o `valor` só muda quando a peça aceita a data.

## Se você disser não

As 13 datas do IB ficam no `<input type="date">` nativo, com o desenho de cada navegador, ao lado dos campos de texto da linguagem. A tarefa que tira os campos locais do IB fica aberta, e o `BoldDateRange` também fica nativo.

## Não estou pedindo

1. **Uma forma específica.** Pode ser:
   - para a barra: máscara que a escreve sozinha, ou aceitar só os dígitos;
   - para o inválido: um `valor` vazio, ou um evento próprio.

   A escolha é da linguagem.
2. **Trocar o calendário.** Ele funciona, e é por ele que a data entra hoje no celular.
3. **A hora.** Ela entrou na `v3.25.0`, e os itens valem do mesmo jeito com `hora`.

## Como o pai vai saber que funcionou

No teste do pai, um `<diletta-date-field>` com `min` e `max`:
1. escrever e depois apagar avisa o vazio, e o `valor` fica vazio;
2. uma data fora do limite, ou incompleta, chega a quem usa, ou a peça mostra o erro;
3. `focus()` no hospedeiro põe o foco no campo de dentro;
4. só com dígitos, «12112026» vira `2026-11-12`, ou a barra existe no teclado do celular. A medida no iPhone fica como prova.

Do lado do IB, as 13 datas trocam pela peça, e o formulário do cadastro de nota leva o foco à data inválida.

## Como cheguei aqui

No levantamento para trocar o campo de texto e as datas do IB pelas peças da linguagem, em 12/11. A troca estava parada desde 19/10, à espera do pedido do erro anunciado, que entrou em 20/10. A leitura do código apontou os itens 1 a 3, e a medida confirmou os quatro.

## VEREDITO · ENTRA — o campo esvazia, avisa, diz o erro e delega o foco
**pai**: ds-diletta **v3.28.0** · `web-v3.28.0` · **data**: 2026-11-13

### O que decidiu
Os quatro itens, na peça web:
1. **apagar**: `valor` some e `mudou` avisa `''`;
2. **incompleta, inexistente ou fora do limite**: o mesmo `''`, uma vez. Ao sair do campo, a peça mostra o erro
   dela: «Digite a data completa: dd/mm/aaaa.» ou «Escolha uma data entre … e ….». O texto é do Hunter. O seu
   `erro` vence o da peça;
3. **foco**: o hospedeiro delega, e entrou na régua das peças de uma entrada;
4. **iPhone**: a barra é opcional. `12112026` vira `2026-11-12`, e o campo reescreve `12/11/2026`.

### O que eu achei indo implementar
O teste antigo afirmava «fora do limite não avisa». Ele mudou: avisar `''` é o contrato novo, e a spec diz isso.
Com `hora`, vale o mesmo. O Dart não muda: lá o campo é `readOnly` e só o calendário escreve.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o IB não entra no shadow para saber do texto |
| escalabilidade | ↑ | o `BoldDateRange` vem pela mesma peça |
| aplicação | ↑ | 13 datas do IB; adota o filho B |
| aderência ao mercado | ↑ | campo que diz o erro ao sair é o padrão |
| robustez | ↑ | o `valor` velho não fica mentindo depois de apagar |
| arquitetura limpa e simples | = | três métodos na peça, nenhum atributo novo |
| conciso | = | um requisito na spec |

### O que você faz
`ref: web-v3.28.0`. Quem trata `mudou` passa a receber `''`: o filtro de Recebimentos precisa aceitar vazio.
