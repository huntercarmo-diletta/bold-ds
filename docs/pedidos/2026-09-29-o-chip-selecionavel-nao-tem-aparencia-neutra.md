# PEDIDO · O chip selecionável não tem aparência neutra — e a escolha de visualização do console grita em `primary`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo (a que o console instala,
  `core-flow-wa/package.json:26`). **Medido também na ponta, `web-v3.2.0` (`800841e`) e `v3.2.0`
  (`f4ba5c7`)**
- **bloqueante?**: **não** — o console tem uma ponte (`WaPilulaDeEscolha`) que pinta por `::part(pilula)`
- **irmão**: [o chip não tem aparência neutra para sugestão](2026-09-29-o-chip-nao-tem-aparencia-neutra-para-sugestao-e-nao-ouve-o-teclado.md).
  Mesmo tom, outro modo. **O teclado e a borda apagada estão lá** e valem aqui: a pílula escolhível também
  é `role="button"` sem ouvinte (`diletta-input-chip.js:149`)
- **não é peça nova**: `busca('escolha')` → `[design-system-date-field, design-system-radio-list,
  design-system-segmented-control, design-system-toggle-switch]`; `busca('selecionável')` → vazio;
  `busca('filtro')` → `[design-system-info-chip, design-system-input-chip, design-system-search-input,
  design-system-segmented-control]` (a lógica da `busca` reproduzida sobre as 128 specs da `v3.2.0`). A
  peça existe: é o `.selecionavel` do chip
- **CONTRADIZ UM PEDIDO NOSSO**, e digo antes de tudo: a inversão em `primary` do escolhido fomos nós que
  pedimos, em [a família de chips não tem o selecionável](2026-08-11-a-familia-de-chips-nao-tem-o-selecionavel.md)
  (ENTRA, `v0.67.0`). Aquele argumento continua certo para o app. Este pedido **não** pede para trocá-lo:
  pede uma segunda aparência ao lado
- **toca o veredito do segmented de 28/09** ([o trilho do segmented](2026-09-28-o-trilho-do-segmented-nao-diz-o-que-acontece-com-sete-opcoes.md),
  `v2.8.0`), que termina: *«Se a designer escolher o segmented para os atalhos…»*. **Ela escolheu a
  pílula**, e é por isso que este pedido existe

## Falta

**Uma aparência NEUTRA do chip selecionável**: todas as opções em texto pleno (`textPrimary`) com a
borda da família, e a escolhida distinguida por **contorno + peso**, não por inverter a cor da marca.

## Número

**Dois grupos**, «Agrupar» e «Mostrar como», no `SeletorDeVisualizacao`
(`src/features/relatorios/ui/SeletorDeVisualizacao.tsx:71` e `:84`, pelo `AtalhosExclusivos`), montado em
**quatro telas** de Relatórios: Transações, Uso do app, Usuários e Diagnóstico. No `core-flow-wa-painel`,
branch `feat/painel`, **fora de commit** sobre `52e2fd9`. O pedido da designer, nas palavras dela:
*«esse tipo de menu deveriam ser pílulas»*, *«pílulas neutras»*.

O que a peça pinta hoje, lido na ponta (`diletta-input-chip.js` da `web-v3.2.0`):

| | o que a peça faz | onde |
|---|---|---|
| escolhida | `ESCOLHIDO = { bg: 'primary', border: 'primary', color: 'onPrimary' }`, peso 600 | `:45-46`, aplicado em `:137-140` |
| não escolhidas | fundo transparente (`:136`), rótulo `primary` herdado da pintura | `pintura.g.js:3239-3284` |
| borda das não escolhidas | apagada pelo `border-color: transparent` de `:129` (o irmão) | `:129` |

No Dart é o mesmo desenho: rótulo `primary`/`onPrimary` (`diletta_input_chip.dart:185-188`), fundo e
borda `primary` no escolhido (`:201`, `:209`). Não há outra aparência de nenhum dos lados.

Numa barra de relatório com dois grupos, isso são **duas manchas de `primary` cheio por tela**, ao lado
do botão de ação da tela, que é o único que deveria ter essa cor.

## Já tentei

1. **O `segmented-control`.** A peça entrega a escolha exclusiva com ← → Home End, e o veredito de 28/09
   diz até quantos segmentos. O console não o usa por três motivos escritos no `AtalhosExclusivos.tsx:11-16`:
   o alvo de 44 não está na tag instalada, o trilho não quebra, e **o desenho difere do aprovado pela
   designer em 25/09**. O terceiro é dela, e agora ela disse qual é: pílula;
2. **A ponte `WaPilulaDeEscolha`** (`src/design-system/atoms/WaPilulaDeEscolha.tsx` + `.module.css`, fora de
   commit), pela porta `part="pilula"`:

```css
.escolha::part(pilula) {
  color: var(--diletta-textPrimary);
  border-color: var(--diletta-border);
  background: transparent;
}
.escolha[selecionado]::part(pilula) {
  color: var(--diletta-textPrimary);
  border-color: var(--diletta-textSecondary);
  background: var(--diletta-bg);
  font-weight: var(--wa-peso-forte);
}
```

   mais o `keydown` (Enter/Espaço) que a peça não tem. Funciona, e é tom de chip escrito fora da linguagem.

## Conferi no pai

- o contorno da escolhida passa o 3:1 de componente (WCAG 1.4.11): `textSecondary` sobre `bg` mede
  **5,0:1** no Bold claro (`#6b6678` sobre `#f4f3f6`) e **10,2:1** no escuro (`#b7bbc8` sobre `#0a0b12`),
  calculado dos valores do `bold-tokens.css` da `web-v0.118.0`. A borda das outras (`border`) mede 1,17:1,
  e é de propósito: a diferença entre as duas é o sinal;
- **cor não é o único canal** (1.4.1): o peso 400 → 600 continua, como a regra que o seu veredito de 11/08
  pôs na linguagem a partir da nossa frase; o contorno é o segundo canal, e o `aria-pressed` segue dizendo
  o estado ao leitor de tela;
- papel de TEXTO usado como TRAÇO é exatamente o remendo que o seu veredito de hoje (a caixa vazia do
  checkbox, `v3.2.0`) recusou como forma e aceitou como ponte: *«papel de texto como traço, o atalho do
  console: fica como remendo seu até a condição»*. **Se o papel de contorno de controle que você decidiu lá
  existir, é ele que o contorno da escolhida lê**, e não o `textSecondary`. Este pedido, portanto, pode
  esperar aquele.

## Derivável?

Sim, de papéis que existem (`textPrimary`, `border`, `bg`) e do papel de contorno que você já decidiu
criar. Nenhum número novo: altura 26 e alvo 44 continuam.

## Se você disser não

A ponte fica, com a divergência declarada. Se o não vier como *«o escolhido é inversão por papel, e a
linguagem tem um só»*, eu entendo: foi o nosso argumento de 11/08. Aí a pergunta volta para a designer com
duas saídas escritas — a inversão em `primary`, ou o segmented, que também é da linguagem.

## Não estou pedindo

1. que o `.selecionavel` de hoje mude: o app usa a inversão, e ela continua certa lá;
2. que o modo escolhível vire eixo de enum: a sua condição (*«quando um SEGUNDO filho pedir»*,
   `diletta-input-chip.js:43-44`) não é esta, e o mecanismo é seu;
3. que o trilho do segmented quebre ou role: o seu não de 28/09 fica;
4. `role="radio"`: o console usa `aria-pressed` porque radiogroup promete setas, e a peça não as tem.

## Como o pai vai saber que funcionou

```
fila de três <diletta-input-chip selecionavel> na aparência neutra, a do meio com `selecionado`
espera: as três com rótulo textPrimary (computado)
        a do meio: border-color computado = o contorno de controle (ou textSecondary), font-weight 600
        as outras: border-color computado = border, font-weight 400
        nenhuma com background primary
        aria-pressed="true" só na do meio
```

## Como cheguei aqui

O chat da área de pergunta e resposta de Relatórios do console (`core-flow-wa-painel`, `feat/painel`,
29/09), a pedido da designer. Re-medi na tag que o console instala e na ponta, e li o nosso pedido de 11/08
e o seu veredito do segmented de 28/09 antes de escrever.
