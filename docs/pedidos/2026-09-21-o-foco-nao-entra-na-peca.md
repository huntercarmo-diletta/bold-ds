# PEDIDO · `host.focus()` não leva o foco a lugar nenhum — o shadow não delega

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **sim para duas peças, não para a adoção.** Subimos a troca do botão hoje com
  **175 das 177 chamadas** no `<diletta-button>`; as duas que sobraram voltaram ao `<button>`
  nativo, com exceção declarada e gate que não deixa virar três. Esta é uma delas.
- **não é uma peça**: são **15**, e a conta está abaixo.
- **não é peça nova**, então a regra de 21/09 não se aplica — não há o que a `busca` responda aqui.
  O defeito é da peça que já existe.

## Falta

O shadow root nasce `attachShadow({ mode: 'open' })`, sem `delegatesFocus`. Quem chama
`host.focus()` não move o foco: o hospedeiro não é focável e não repassa.

E `host.focus()` é **o único cabo que o consumidor tem**. O `<button>` de verdade mora no shadow, e
alcançá-lo de fora seria atravessar a borda que a peça existe para fechar.

## Número

Medido em `jsdom`, com o pacote instalado pela tag:

```
el.focus()
  document.activeElement          →  BODY          ← o foco não foi para lugar nenhum
  el.shadowRoot.activeElement     →  null

dentro.focus()                                     ← alcançando o <button> por dentro
  el.shadowRoot.activeElement     →  BUTTON
  document.activeElement          →  DILETTA-BUTTON  ← o normal do shadow: o hospedeiro representa
```

E a fonte diz a mesma coisa, que é a segunda confirmação:

```
peças com `attachShadow`:                         29
peças que passam `delegatesFocus`:                 0
peças que desenham algo FOCÁVEL dentro do shadow: 15
```

`base · button · data-column-header · dropdown · file-card · input-chip · input · pagination ·
rail-item · segmented-control · status-banner-button · tab-item · tabs · text-link · web-top-bar`

**O que eu não consegui medir**, e digo em vez de afirmar: não rodou num navegador de verdade — o
servidor de teste não subiu nesta máquina. As duas confirmações que tenho são o `jsdom` e a fonte, e
as duas dizem a mesma coisa. Se no seu lado o número der diferente, o meu está errado.

## O que isso fez numa tela

`BoldDrawer` — a gaveta de detalhe do lançamento. Ela abre e manda o foco para o botão Fechar:

```js
painel.current?.querySelector('[data-fechar]')?.focus()
```

`[data-fechar]` é o hospedeiro. **A gaveta abre e o foco fica fora dela.** Quem navega por teclado
abre o detalhe e continua com o foco na página de trás; quem usa leitor de tela não é levado para o
diálogo que acabou de aparecer.

Isto é WCAG 2.2 §2.4.3 (Focus Order) e é o comportamento que todo diálogo modal precisa ter.

## O que eu proponho

`attachShadow({ mode: 'open', delegatesFocus: true })` nas peças que têm conteúdo focável.

Com ele, `host.focus()` foca o primeiro focável de dentro, e o consumidor volta a ter um cabo que
funciona sem conhecer o shadow. É uma linha, e mora na `base.js` se o `attachShadow` for de lá —
a mesma forma do `mudouAtributo`.

**A armadilha que eu vejo e não sei medir daqui**: `delegatesFocus` muda também para onde o CLIQUE
manda o foco, e muda o alvo do `:focus` no hospedeiro. Você tem 106 gates de foco; eu tenho dois
casos. Se o degrau custar algum deles, o desenho é seu.

## O que eu NÃO estou pedindo

Não peço que o hospedeiro vire focável por `tabindex`. Isso poria o foco na casca, e o leitor de tela
leria a casca — que é o irmão exato do defeito do `aria-label` que você consertou hoje na `v0.207.0`.

## Critérios que eu acho que decidem

**acessibilidade · manutenção.** Acessibilidade porque diálogo sem foco dentro é diálogo que o
teclado não alcança. Manutenção porque são 15 peças com a mesma linha, e o conserto é de uma.
