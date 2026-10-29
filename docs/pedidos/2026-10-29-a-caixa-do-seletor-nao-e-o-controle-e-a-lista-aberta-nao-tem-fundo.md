# PEDIDO · A caixa do seletor não é o controle, e a lista aberta não tem fundo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` · `web-v3.24.0`, na `main` deste repo (tags até `web-v0.128.0`). **Conferido também na ponta, `web-v3.25.0`** (`0f8bf07`), que é a `main` do avô em 29/10 (`7f988b4`): a montagem é a mesma nas duas. O console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`), e foi lá que mediu
- **bloqueante?**: não. O console tem uma ponte por `::part` e segue com ela; o preço está em «Se você disser não»

São dois defeitos da mesma peça e do mesmo `<select>`, por isso vão juntos:

| item | o que é | por que agora |
|---|---|---|
| 1 | só o `<select>` abre a lista; o recuo da caixa e a seta são área morta | #215 do portal do webadmin: 27–32% da caixa abre a lista |
| 2 | a lista aberta não tem fundo e, no escuro, sai branca com texto claro | #206 do portal; pendência 5.3 da change `acabamento-cadastros-e-senha` do console, que nunca virou pedido |

## Falta

1. Que a caixa inteira do `<diletta-dropdown>` seja o controle: um clique em qualquer ponto visível dela abre a lista.
2. Que o `<select>` de dentro declare o fundo que a lista aberta vai usar.

## Número

### 1 · a caixa não abre a lista

A montagem, em `diletta-dropdown.js` na `web-v3.25.0`:

```
<div class="caixa" part="caixa">      ← flex, gap s2, padding s2 × px do porte, min-height, borda, raio  (:155-166)
  <select part="controle">            ← flex 1, padding 0, background none, appearance none               (:170-176)
  <span class="seta" aria-hidden>     ← sem part, sem pointer-events, irmã do select                      (:180, :198-199)
</div>
```

O recuo é da `.caixa` (`padding: var(--diletta-s2) ${g.px}`, `:163`), o `<select>` tem `padding: 0` (`:173`) e
a seta é um `<span>`. Clicar no recuo ou na seta cai num `div` ou num `span`, e nada acontece. Na
`web-v3.24.0` é a mesma coisa, uma linha acima (`:154-199`): a única diferença entre as duas tags nesta
peça é o `anunciaErro`.

**Medido pelo console no Edge (Chromium) em 28/10, na `web-v2.5.0`** (`:132-173`, recuo `s3` fixo),
contando o elemento sob cada ponto da caixa:

| campo | caixa | `<select>` | área que abre | sob a seta |
|---|---|---|---|---|
| «Situação» (12rem) | 192 × 48 | 142 × 20 | **32%** | `diletta-icon` |
| «Itens por página» (8rem) | 128 × 48 | 78 × 20 | **27%** | `diletta-icon` |

Com um clique de verdade no centro da seta, o foco nem chega ao `<select>`. Na moldura `silencioso`
a seta também não abre a lista. Não medi no navegador a `web-v3.24.0` nem a `v3.25.0`; o que mudou
nelas foi o recuo vertical (de `s3` para `s2`) e o horizontal por porte (`s1_5` · `s2` · `s3`), e o
`<select>` continua sem recuo e a seta continua fora dele. A proporção morta muda; a área morta, não.

### 2 · a lista aberta no escuro

O `<select>` declara `background: none; color: inherit` (`:173-174`). No Chrome do Windows e do Linux,
a lista que ele abre é pintada com o fundo e a cor do próprio `<select>`. Sem fundo declarado, no
escuro a lista sai branca com texto claro, que fica ilegível, salvo a opção destacada. A cor vem
herdada da `.caixa` (`fg`, ou `textDisabled` no desabilitado, `:165`), e o fundo da caixa
(`surface`, `:164`) não chega à lista.

## Já tentei

**O console construiu a ponte**, em `src/design-system/tokens/index.css`, só pelas duas portas que a
peça publica:

- `::part(caixa)` com `pointer-events: none` (a seta, que não tem porta, herda) e `overflow: hidden`
  (recorta o `<select>` nos cantos; o `overflow` não recorta o `outline`, e o anel de foco é `outline`
  da caixa);
- `::part(controle)` com `pointer-events: auto`, `align-self: stretch`, **margem negativa igual ao recuo
  da caixa e o mesmo recuo devolvido por dentro**, com o fim da linha somando recuo + seta + gap;
- `::part(controle)` com `background-color: var(--diletta-surface)`, para o item 2.

Com ela, **98%** e **97%** da caixa abrem a lista. Funciona, e é o contorno que fica de pé. Mas ela
copia o recuo da peça para fora dela: os números são os da `web-v2.5.0` (`s3` nos quatro lados), e na
`web-v3.24.0` o recuo já é outro e depende do porte. É o mesmo motivo de o remendo de raio por
`::part` ter morrido em 24/09: o consumidor não alcança o que a peça decide por dentro.

Três alternativas que o console descartou antes da ponte, e por quê:

- **`showPicker()` num ouvinte da caixa**: é JS para resolver área de clique; o cursor e o foco ficam
  errados no recuo, e o suporte varia entre navegadores;
- **`<select>` absoluto com `inset: 0`**: perde a largura intrínseca, que é o que dimensiona o seletor
  onde ninguém declara largura;
- **lista desenhada à mão**: a peça mantém o `<select>` nativo de propósito (`:7-15`), e o argumento
  continua certo.

## Conferi no pai

- **O Dart não tem a área morta, pela leitura.** Na moldura `caixa`, o `DilettaDropdown` é um
  `DilettaInput` `readOnly` com `onTap` (`diletta_dropdown.dart:253-264`), e o `DilettaInput` envolve
  o contêiner inteiro num `DilettaTappable` opaco, com o comentário *«Tap-to-focus do container inteiro
  (padding + acessórios)»* (`diletta_input.dart:266-284`); o campo `readOnly` fica em `IgnorePointer`
  para o toque cair no invólucro (`:407-413`). No `silencioso`, o `DilettaTappable` opaco envolve texto
  e seta juntos (`diletta_dropdown.dart:267-288`). Li, não medi com teste de widget: **peço que o
  veredito confirme.** Se confirmar, o item 1 é uma divergência só da web, e o contrato do lado Dart já
  está escrito.
- O anel de foco é `outline` da `.caixa` por `:has(:focus-visible)` (`:183-185`). Qualquer desenho que
  recorte o `<select>` na caixa precisa deixar o anel inteiro, e `overflow` não recorta `outline`.
- **No `silencioso` a caixa não pinta fundo**: o `background: var(--diletta-surface)` só entra na
  moldura `caixa` (`:158-164`). Ali, um fundo no `<select>` muda a vista fechada se a superfície em
  volta não for `surface`. O item 2 vale para as duas molduras; como resolvê-lo no `silencioso` sem mudar
  a vista fechada fica com você.

## Derivável?

Não. A área de clique e o fundo do `<select>` são decididos dentro do shadow. O consumidor só alcança
por `::part`, copiando o recuo da peça, que é a ponte acima.

## Desenho proposto (quem decide é você)

- O recuo vai para **dentro** do `<select>`, que passa a ocupar a caixa inteira: `align-self: stretch`,
  `padding` igual ao recuo da moldura, `padding-inline-end` igual a recuo + seta + gap.
- A seta fica posicionada sobre ele, com `pointer-events: none`.
- A caixa recorta o fundo do `<select>` nos cantos arredondados; o anel continua `outline` da `.caixa`.
- O `<select>` declara `background-color: var(--diletta-surface)`, o mesmo papel da caixa, e a vista
  fechada da moldura `caixa` não muda. A cor continua herdada, porque a caixa a troca para
  `textDisabled` no desabilitado.

## Se você disser não

A ponte do console fica, com um teste (`seletorClicavel.test.ts`) que lê o fonte pinado e manda
apagá-la quando uma destas duas coisas aparecer:

- a `.seta` declara `pointer-events`;
- o `<select>` ganha recuo próprio.

**Se o conserto vier por outro caminho, peço que o veredito diga qual**, para o console trocar o
gatilho do teste. E o preço do «não» já está aparecendo: a ponte tem os números da `web-v2.5.0`, e o
console vai precisar reescrevê-la a cada mudança de recuo ou de porte da peça. Todo outro filho que
usa o `<diletta-dropdown>` herda a mesma área morta sem saber.

## Não estou pedindo

1. **que o clique no rótulo abra a lista**: o `<label for>` foca sem abrir, e esse é o comportamento
   nativo;
2. **trocar o `<select>` nativo** por lista desenhada: o argumento do `///` continua valendo;
3. **mudar a vista fechada**: nenhum pixel, nos dois modos;
4. **o glifo da biblioteca `sistema` carregado por `fetch` de `data:`**, que estava na mesma tarefa 5.3
   do console: se for o caso, é outro pedido.

## Como o pai vai saber que funcionou

Os critérios de aceite da spec do console:

- clicar ou tocar em qualquer ponto visível da caixa abre a lista, inclusive na seta e no recuo;
- o cursor é `pointer` na caixa toda;
- a vista fechada não muda um pixel, no claro e no escuro, e o texto comprido é cortado antes da seta;
- desabilitado não abre em ponto nenhum, e o cursor é `default`;
- Tab, anel de foco inteiro, nome acessível vindo do `<label for>` e seta `aria-hidden` ficam como estão;
- no escuro, a lista aberta tem fundo `surface` e texto legível no Chrome do Windows.

Gate sugerido: `elementFromPoint` no shadow, no centro da seta e no recuo, devolve o `select`. Só roda
em Chromium; o jsdom não calcula layout.

## Como cheguei aqui

O console webadmin abriu a change `seletor-clicavel-por-inteiro` para o #215 do portal e mediu a
caixa ponto a ponto no Edge. O #206 (a lista no escuro) estava pendente desde a change
`acabamento-cadastros-e-senha` (tarefa 5.3) e é o mesmo `<select>`. Conferi as duas montagens no
fonte da `web-v3.24.0` e da `web-v3.25.0` antes de escrever.
