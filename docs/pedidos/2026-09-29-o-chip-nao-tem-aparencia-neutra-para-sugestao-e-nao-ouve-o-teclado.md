# PEDIDO · O chip não tem aparência neutra para SUGESTÃO — e a pílula que se anuncia botão não ouve o teclado

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo (a que o console instala,
  `core-flow-wa/package.json:26`). **Medido também na ponta, `web-v3.2.0` (`800841e`) e `v3.2.0`
  (`f4ba5c7`)**; o elemento é igual na `origin/main`
- **bloqueante?**: **não** — o console tem uma ponte (`WaSugestao`) que pinta por `::part(pilula)`
- **irmão**: [o chip selecionável não tem aparência neutra](2026-09-29-o-chip-selecionavel-nao-tem-aparencia-neutra.md),
  da mesma tela e do mesmo pedido da designer. **Os dois são o mesmo tom em dois modos**, e podem sair
  juntos. O ponto do teclado mora **aqui** e vale para os dois
- **não é peça nova, e a busca diz por quê**: `DilettaManifesto.busca('chip')` →
  `[design-system-info-chip, design-system-input-chip, design-system-chat-input, design-system-tooltip]`;
  `busca('sugestão')`, `busca('sugestao')`, `busca('neutro')` → **vazio**; `busca('pílula')` →
  `[design-system-level-pill, design-system-segmented-control]` (a lógica da `busca` reproduzida sobre as
  128 specs da `v3.2.0`). Vazio aqui é resposta: a linguagem não tem chip de sugestão
- **não reabre nada**: não achei recusa sua sobre tom de chip no seu `docs/PEDIDOS.md`

## Falta

1. **Uma aparência NEUTRA do chip**, para o chip que **sugere** (preenche um campo com um exemplo):
   texto em cor plena (`textPrimary`), borda visível, sem `aria-pressed` e sem «×»;
2. **o chip ouvir Enter e Espaço**, porque ele desenha `role="button"` com `tabindex="0"`;
3. **a borda que a pintura declara aparecer** — hoje ela é apagada pelo próprio CSS da peça (defeito, e
   independe do 1).

## Uma contradição antes do pedido — ela vale mais do que ele

A spec do chip diz, no primeiro requisito: *«`DilettaInputChip` SHALL representar um filtro ou contexto
selecionável. NÃO SHALL ser usado como CTA (isso é `DilettaButton`)»* (`specs/design-system-input-chip/spec.md:35-37`).
**Uma sugestão que preenche o campo é ação**, e o console a pôs no chip. Estou declarando isso contra
nós. O botão não serve pelo desenho: a designer pediu **pílula**, e o botão do Bold tem canto de 16
(`--diletta-formaDeBotao: 16px`, `bold-tokens.css:244`), não pílula. É por isso que o pedido é de tom
**e** de papel: o que falta pode ser uma aparência do chip ou um chip de sugestão ao lado dele — o
mecanismo é seu.

É o que o mercado chama pelo nome: o Material 3 tem quatro chips (assistência, filtro, entrada e
**sugestão**), e o de sugestão é o contornado neutro, com o rótulo em `onSurfaceVariant`.

## Número

**Um grupo, três pílulas**: os «Exemplos» da pergunta livre de Relatórios
(`src/features/relatorios/ui/WidgetDeConsulta.tsx:409-414`, três textos em `model/prompt.ts:29-33`),
no `core-flow-wa-painel`, branch `feat/painel`, **fora de commit** sobre `52e2fd9`. O pedido da designer,
nas palavras dela: *«essas pílulas tem que ser neutras»*.

O que a peça pinta hoje, lido na ponta:

| | o que a peça faz | onde |
|---|---|---|
| cor do rótulo | `primary` em `normal`, `hover` e `pressed` | `pintura.g.js:3239-3284`, `design-system-input-chip` |
| borda | a pintura escreve `border-color: var(--diletta-border)`, e **a linha seguinte** escreve `border-color: transparent` | `diletta-input-chip.js:117` (`estiloDa`) e `:129` |
| papel e foco | `role="button"`, `tabindex="0"`, foco entra (`delegatesFocus`, `:72`) | `:149` |
| teclado | **nenhum** ouvinte: `keydown`, `click` e `addEventListener` aparecem **zero** vezes no arquivo | `diletta-input-chip.js` inteiro |

Medido em jsdom, com o elemento registrado a partir da árvore da tag (nas duas, `web-v0.118.0` e
`web-v3.2.0`): a pílula recebe o foco, e **Enter e Espaço produzem zero `click`**. A ordem do CSS lida do
shadow é `border-color: var(--diletta-border)` e depois `border-color: transparent`.

**A borda é defeito da cópia web, não gosto**: o Dart desenha `s.border` no chip não escolhido
(`diletta_input_chip.dart:205-210`) e a spec declara `border` nos três estados de interação. E o
comentário da própria linha `:123-128` diz o contrário do que ela faz: *«Longhand, e NUNCA o atalho de
borda: ele vem depois da pintura e reseta a cor que ela acabou de escrever»* — o longhand também vem
depois, e também reseta. (Contraste da borda, para o registro: `border` sobre `bg` no Bold claro mede
1,17:1; o pedido não é que ela passe 3:1, porque o rótulo identifica o chip. É que ela exista, como no
Dart.)

## Já tentei

A ponte `WaSugestao` (`src/design-system/atoms/WaSugestao.tsx` + `.module.css`, fora de commit), pela
porta que a peça publica:

```css
.sugestao::part(pilula) {
  color: var(--diletta-textPrimary);
  border-color: var(--diletta-border);
}
```

e um `keydown` no hospedeiro (Enter/Espaço → `aoEscolher`), além do `mousedown` com `preventDefault`
(o `blur` do campo chega antes do clique). Funciona; é a quarta cor de chip escrita fora da linguagem, e
o teclado vira responsabilidade de cada consumidor.

## Conferi no pai

- o `filled` (`primarySubtle` + rótulo `primary`, `diletta_input_chip.dart:204` e `:187-188`) não é neutro: é
  «filtro ativo», e o rótulo continua `primary`;
- o `.selecionavel` também não: é o irmão deste pedido;
- o `InfoChip` é decorativo, e a spec o separa do input chip pelo mesmo motivo (`spec.md:3-5`);
- o comentário do `ESCOLHIDO` (`diletta-input-chip.js:43-44`) escreve uma condição para o modo
  escolhível virar eixo: *«quando um SEGUNDO filho pedir o modo»*. **Este pedido não é esse**: não peço o
  escolhível em outro filho; peço um tom que nenhum modo tem.
- **o precedente é seu, e é de tom**: [o link não tem tom neutro](2026-08-22-o-link-nao-tem-tom-neutro-e-o-ver-todos-desta-marca-e-do-titulo.md)
  entrou como `DilettaTextLinkTone.neutro` (`v0.145.0`, 22/08), e o que decidiu foi a sua frase: *«você não
  pediu "deixa eu passar uma cor". Pediu um TOM, que é papel»*. Aqui é o mesmo: não peço para passar
  `color`, peço o tom que o `::part` do console está fingindo.

## Derivável?

O **tom**, sim, de papéis que existem: `textPrimary`, `border`, `surface`/transparente, e `surfaceMuted`
no hover como hoje. Nenhum papel novo. O **teclado** é comportamento, e é o que o `role="button"` já
promete. A **borda** é trocar a ordem de duas linhas.

## Se você disser não

A ponte fica, com a divergência declarada; a borda e o teclado ficam para todo consumidor que usar o
chip na web, inclusive o `WaChipDeFiltro` do console, que é o mesmo elemento. Se a resposta for «use o
botão», a pergunta volta para a designer, porque a forma do botão do Bold não é pílula.

## Não estou pedindo

1. que o chip de filtro mude: o `primary` dele continua certo para *«este filtro está aplicado»*;
2. papel novo;
3. um evento próprio: o `click` nativo, disparado pelo teclado, basta;
4. alvo de toque: os 44 do `:host` já estão lá.

## Como o pai vai saber que funcionou

```
cria <diletta-input-chip label="Exemplo"> na aparência neutra
espera: rótulo em textPrimary; border-color computado = border (não transparent); sem aria-pressed
foca a pílula, aperta Enter, depois Espaço: dois `click` no hospedeiro   ← hoje zero
cria o chip de sempre: border-color computado = border   ← hoje transparent
```

O terceiro teste tem que ler o **estilo computado**, não o texto do CSS: é a classe que o seu comentário
de 06/09 registrou, e o texto do CSS tem as duas linhas.

## Como cheguei aqui

O chat da área de pergunta e resposta de Relatórios do console (`core-flow-wa-painel`, `feat/painel`,
29/09), a pedido da designer. Re-medi na tag que o console instala e na ponta.
