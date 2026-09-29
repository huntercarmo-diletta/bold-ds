# PEDIDO · A caixa vazia do checkbox e do rádio não passa 3:1, e o papel que ela lê é o de card

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` (pino do pai, `packages/coreflow/pubspec.yaml:23`), e na web a
  `web-v0.118.0` deste repo. **Medido também na ponta, `v3.1.0` (`e480392`)**: as linhas abaixo são
  as mesmas nas duas
- **bloqueante?**: **não**
- **irmão**: [o checkbox é só código](2026-09-29-o-checkbox-e-so-codigo-e-o-console-desenha-o-seu-sobre-o-input-nativo.md).
  **Este vem antes**: o lado web herda o contorno que sair daqui
- **contradiz dois pedidos NOSSOS, e digo quais**: (1) em [04/08](2026-08-04-os-seletores-nao-traduzem-entre-claro-e-escuro.md)
  fomos nós que pedimos o traço vazio do rádio em `border`, e você aplicou (`neutral07` → `border`,
  *«um degrau, e é o papel que manda»*). Pedimos pela tradução entre claro e escuro, e ninguém mediu o
  contraste. (2) Hoje de manhã, [a busca e o código](2026-09-29-a-busca-e-o-codigo-nao-leem-a-moldura-do-campo.md)
  pede o quadrado vazio do `DilettaOtpInput` em `s.border`. Se este pedido entrar, o quadrado do código
  deve ler o papel novo, e não o `border`. **A tradução entre os modos continua certa nos dois. A
  escolha do papel é que estava errada**
- **não é peça nova**: `busca('contorno')` devolve vazio, e `busca('borda')` devolve `box`, `field`,
  `info-card` e `text-link`. Nenhum é papel de controle

## Falta

**Um papel de traço de CONTROLE que passe 3:1 contra a superfície** (WCAG 2.2 §1.4.11, contraste não
textual: *«a fronteira necessária para identificar o componente»*), ou a indicação de um papel
existente que já passe. Hoje os três traços vazios da família de seleção leem papel de card ou degrau
cru, e nenhum chega a 2:1.

O `border` diz o que é: *«O limite de um card, campo ou chip.»* (`diletta_significado_do_papel.dart:142`).
Um card não precisa de 3:1, porque o conteúdo o identifica. Uma caixa de seleção vazia é **só** o traço.

## Número

Contraste WCAG calculado sobre `surface`. O valor com alfa foi composto sobre o fundo antes do cálculo.

| traço vazio | onde | papel | Bold claro (`#fff`) | Bold escuro (`#14151f`) | referência claro (`#fff`) |
|---|---|---|---|---|---|
| caixa do `DilettaCheckbox` | `diletta_checkbox.dart:239` (traço de 1, `:108`) | `border` | `#00000012` → **1,17:1** | `#ffffff14` → **1,22:1** | `neutral08` `#D5DCE1` → **1,39:1** |
| rádio do `DilettaRightAccessory.radio` | `diletta_app_list.dart:1427` | `border` | **1,17:1** | **1,22:1** | **1,39:1** |
| `DilettaRadioMark` (o da `DilettaRadioList`) | `diletta_radio_list.dart:215` (traço 1,5) | **`s.palette.neutral07`, cru** | `#C6C6C6` → **1,71:1** | `#C6C6C6`, não troca de modo | `#B2BCC4` → **1,93:1** |
| trilho desligado do `DilettaToggleSwitch` | `diletta_toggle_switch.dart:166-168` | `surfaceMuted` (preenchimento, sem traço) | `#f1f0f4` → **1,13:1** | `#1e1f2d` → **1,11:1** | não medido |

Origem dos valores: Bold em `packages/coreflow_design_system_web/tokens/bold-tokens.css` (claro `:6`,
escuro `:73`) e `bold_palette.dart:288` (`bordaClara`), `:294` (`bordaEscura`), `:183` (`neutral07`);
referência em `diletta_scheme.dart:527` (`border: p.bordaClara ?? p.neutral08`), `:761` (escuro, branco
a 8%) e `diletta_palette.dart:893` (`neutral08`), com os vizinhos da rampa ao lado.

**Não é só do Bold**: a paleta de referência também reprova (1,39 e 1,93).

**E o filho A pinta escuro**: o seu `ROTEIRO-DE-AMARRACAO-cpf.md:68` e `:80` registram a caixa não
marcada do CPF Seguro desenhada em `#3d3939` (`:68`) e o traço dela no `neutral08` do filho A (`:80`).
`#3d3939` sobre branco mede 11,40:1. É o desenho de outro filho a favor da fronteira forte. Não conferi
se o `neutral08` da paleta dele resolve nesse valor.

**O que passa, entre os papéis que já existem** (Bold claro, sobre `surface` / sobre `bg #f4f3f6`):
`textMuted` 3,63 / 3,29 · `textTertiary` 4,99 / 4,51 · `textSecondary` 5,53 / 5,00 · `fg` 11,40. No
escuro: `textMuted` 3,52 · `textTertiary` 5,78. **Todos são papéis de texto.** Usar papel de texto em
traço é o atalho que o console tomou, e é por isso que peço papel próprio.

## Já tentei

O console diverge de propósito: a `WaCaixaDeSelecao.module.css` pinta a caixa vazia com
`var(--diletta-textSecondary)` (5,53:1), com a divergência escrita na folha (*«acessibilidade não cede
a "a linguagem ganha"»*). É a mesma classe do anel de foco, que você aceitou em
[21/09](2026-09-21-o-anel-de-foco-do-campo-nao-se-ve.md) pelo mesmo §1.4.11.

## Conferi no pai

- A resolução da caixa em `diletta_checkbox.dart:216-239` na `v2.5.0` e na `v3.1.0`: `border` no vazio,
  `primary` no apontado (`:238`), `fg` no `neutral` marcado (`:233`), `borderSubtle` no desligado (`:227`).
- O desligado fica fora deste pedido: a sua nota no `diletta_scheme.dart:521-523` isenta controle
  inativo, e a WCAG também.
- O apontado (`primary`) fica fora: não medi o `primary` do Bold como traço, e ele não é o repouso.
- O seu `ESTADO-DOS-SEIS-LADOS-cpf.md:57` e o roteiro acima: o traço do checkbox do filho A é
  `neutral08` dele.

## Derivável?

**Sim, e é o que peço**: um piso de 3:1 contra `surface`, derivado como os seus pisos de tinta. Nenhum
filho precisaria declarar nada. Por isso nada vai ao pai (Coreflow): o `bordaClara` do Bold continua
certo para card e campo, e o papel novo nasce da derivação.

## Se você disser não

Cada consumidor escolhe um papel de texto para o traço, como o console fez. O primeiro filho que
declarar `textSecondary` claro demais reprova de novo, e ninguém vê, porque o gate não sabe que aquele
texto virou traço.

## Não estou pedindo

1. **mudar o `border`**: ele é certo para card, campo e chip, e escurecê-lo pesaria em todo lugar;
2. **o interruptor**: medi só o trilho (1,13:1), não o polegar com as duas sombras. Pode ser que o
   polegar identifique o controle sozinho. Deixo na tabela como medida, sem pedir;
3. **o desligado**: a WCAG isenta;
4. **os valores**: o piso é a régua, e o degrau é seu.

## Como o pai vai saber que funcionou

- nas paletas de referência e do Bold, claro e escuro, o traço vazio do checkbox e dos dois rádios mede
  ≥ 3:1 contra `surface`;
- os três leem o **mesmo** papel, e o `DilettaRadioMark` deixa de ler `palette.neutral07`;
- o quadrado vazio do `DilettaOtpInput`, se entrar o pedido de hoje de manhã, lê esse papel também.

## Como cheguei aqui

Construindo a caixa do console (tela Ajustes › Botões, 29/09). Medido no demo, tema claro do Bold: a
caixa vazia saiu quase invisível. O valor do `--diletta-border` bate com o `bold-tokens.css:6`. O resto
foi medido no código das tags citadas.

---

## VEREDITO · ENTRA — o papel de contorno de controle, derivado com piso de 3:1; e NÃO nesta tag

**pai**: ds-diletta **v3.2.0** · **data**: 2026-09-29

### O que decidiu

A sua frase: *«Um card não precisa de 3:1, porque o conteúdo o identifica. Uma caixa de seleção vazia é
**só** o traço.»* Ela separa os dois papéis pela função, e não pelo gosto. E a sua tabela mostra que não
é só do Bold: a paleta de referência também reprova (1,39 e 1,93). Isto é defeito da linguagem.

Você também disse o que contradizia: o pedido de 04/08, que moveu o rádio de `neutral07` para `border`,
foi seu, e eu aceitei sem medir contraste. **A tradução entre os modos daquela troca continua certa, e o
papel escolhido estava errado. A falha de medição foi minha também.**

### A forma

Papel novo, **derivado** como as tintas de texto: o primeiro degrau da rampa que passa 3:1 contra
`surface`, no claro e no escuro. Nenhum filho declara nada, e o `border` não muda: ele continua certo
para card, campo e chip. Os três traços vazios da família de seleção (a caixa do checkbox, o rádio do
acessório e o `DilettaRadioMark`) e o quadrado vazio do código passam a ler esse papel.

### Por que não sai hoje

Papel novo é de graça para o filho, mas não para mim: ele atravessa a lista de papéis, os geradores de
CSS e de Figma, a origem dos papéis, e **a variável no Figma do pai**, que a reconciliação cobra. O
conector do Figma está fora nesta sessão. A condição:

- o papel existe no scheme, derivado com piso de 3:1 contra `surface` nos dois modos, com gate;
- a variável existe no Figma do pai, e a reconciliação passa;
- os quatro traços vazios leem o papel, e o `DilettaRadioMark` deixa de ler `palette.neutral07`.

### O que eu achei indo implementar

**Eu tinha trocado o quadrado do código para `s.border` hoje de manhã, pelo seu outro pedido, e ia sair
na tag.** O seu adendo pegou antes. A troca foi desfeita. O código continua com a dívida escrita ao lado
da linha até este papel existir.

### O que eu recusei, e a condição de reabrir

- **o trilho do interruptor**: você não pediu, e eu não meço o polegar agora. Reabre com a medida do
  controle inteiro, polegar e sombras juntos;
- **papel de texto como traço**, o atalho do console: fica como remendo seu até a condição.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | um papel com função, no lugar de quatro traços com papel de card ou degrau cru |
| escalabilidade | ↑ | derivado: todo filho passa 3:1 sem declarar nada |
| aplicação | ↓ | **dívida declarada**: a caixa vazia segue quase invisível até a condição |
| aderência ao mercado | ↑ | é o §1.4.11, contraste não textual |
| robustez | ↑ | o piso vira gate, e o próximo filho não reprova calado |
| arquitetura limpa e simples | = | um papel a mais na família de borda, com fronteira clara contra o `border` |
| conciso | = | nada para o consumidor escrever |

### O que você faz

Nada até a condição. O `textSecondary` na `WaCaixaDeSelecao` fica, com a divergência escrita, como está.

---

## Nota do pai · 29/09 — a condição bateu no mesmo dia, e o papel saiu

**pai**: ds-diletta **v3.3.0** · **data**: 2026-09-29

O conector do Figma voltou, e as três condições fecharam:

- **`contornoDeControle`** no scheme, derivado: o primeiro degrau da rampa que alcança 3:1 contra a
  superfície, nos dois modos. Na referência dá `#74818b`: **4,0:1 no claro e 3,83:1 no escuro**. O
  `border` não mudou;
- **o gate** `contorno-de-controle` na conformidade: a sua rampa passa por ele quando você subir o `ref:`;
- **a variável** `Tema/Border/Neutral/contornoDeControle` no Figma do pai, com escopo de traço.

Os quatro traços vazios leem o papel: a caixa do checkbox, o rádio do acessório, o `DilettaRadioMark`
(que deixou o `palette.neutral07`) e a célula vazia do código.

**Um ajuste ao veredito:** o piso é **3:1 fixo**, e não sobe no modo AAA. O §1.4.11 só existe no AA, e o
teste da casa diz que modo que não declara remapeamento não pede nada. A primeira versão subia, e o
teste pegou.

**O que você faz:** `v3.3.0`. O `textSecondary` da `WaCaixaDeSelecao` pode virar
`var(--diletta-contornoDeControle)`, e a divergência declarada na folha sai.
