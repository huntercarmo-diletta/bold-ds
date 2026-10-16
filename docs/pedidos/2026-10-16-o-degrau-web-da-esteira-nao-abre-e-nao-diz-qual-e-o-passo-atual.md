# PEDIDO · O degrau web da esteira não tem onde abrir — e não diz qual é o passo em que a pessoa está

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`)
- **bloqueante?**: não. **E o número é um desenho, não código**: a tela que usa isto ainda não foi implementada no console. Se a sua régua for esperar o código, `ESPERA` com essa condição é resposta completa

## Falta

| item | o que é | por que agora |
|---|---|---|
| 1 · o degrau aberto | o degrau mostra conteúdo próprio abaixo do título, e não só uma ação | o passo que falhou leva o quadro da última tentativa dentro dele |
| 2 · o passo atual | marcar o passo em que a pessoa está, distinto dos pendentes depois dele | os três estados atuais não dizem onde a pessoa parou |

O 2 não depende do 1.

## Número

| medida | valor |
|---|---|
| consumidor | **um**: a gaveta de Cadastros › Por passo, protótipo de 08/10 no arquivo Web-Admin do Figma (página `82:2097`, gaveta B `87:2328`), revisto por composição, fluxo e texto em 08 e 13/10 |
| o que o desenho pede | indicador feito/atual/pendente (componente local `85:2130`, montado à mão); o fio de 2px de cada passo; o passo que falhou **aberto**, com o quadro da última tentativa (`85:2131`) e duas ações dentro |
| por que à mão | a peça do Figma que tem esses estados é a da «Rev 01 - DPS Design System» (`step - web`, `Step indicator - web`, `Vertical step progress line - web`), que não pode ser usada. É o mesmo nome que a sua spec cita (`specs/design-system-web-stepper-node/spec.md`: *«No Figma ela se chama `step - web`»*) |
| `DilettaManifesto.busca` sobre as specs da `v3.19.0` | `busca('stepper')` → `[stepper, web-stepper-node, journey-step, top-app-bar]` · `busca('passo')` → `[stepper, toggle-switch]` · `busca('etapa')` → `[]` |

## Conferi no pai (`web-v3.19.0`)

- `diletta-web-stepper-node.js`: `observedAttributes = ['estado', 'titulo', 'descricao', 'motivo', 'ultimo']` (`:22`); `ESTADO = ['concluido', 'bloqueado', 'pendente']` (`:6`); o único lugar de conteúdo é o slot `acao` (`:79`); o fio é `border` e não separa o caminho andado do que falta (`:60`).
- `diletta-stepper.js` (nasceu em 15/10): é a régua horizontal do celular. Não serve.
- `diletta-expansion-tile.js` (`['titulo', 'aberto']`): abre conteúdo, mas é uma linha de lista com chevron, sem medalhão nem fio.
- `journey-step` (`destino` de código): vertical, com done/next/locked e conector tracejado. É o mais próximo, e só existe no Dart.

## Já tentei

- **Pôr o quadro da tentativa no slot `acao`** (por leitura, não montado): o slot aceita, e o nome mente. O respiro muda pelo `temAcao` (`:66`), e para o leitor de tela aquilo é ação, não conteúdo do passo.
- **`bloqueado` para o passo que falhou**: a tinta `warning` e o `motivo` servem a «Falhou 3×». O que não existe é distinguir o passo em que a pessoa **está** dos pendentes que vêm depois.

## Derivável?

O item 2, talvez: se o atual for «o primeiro não concluído», ele sai da ordem. Se for isso, diga, e o 2 cai.

## Se você disser não

Quando a tela for implementada, o console monta o degrau com o `expansion-tile` e um medalhão à mão. A peça web da esteira fica sem o seu primeiro consumidor neste filho.

## Não estou pedindo

1. **passar o glifo por quem chama**: a regra de derivar o glifo do estado é boa, e fica;
2. **a faixa de passos com contagem** (`src/features/kyc/ui/DiagramaDoProcesso.tsx`): é receita nossa;
3. **a peça no Figma**: é trabalho da biblioteca, não seu.

## Como o pai vai saber que funcionou

Um degrau com conteúdo abaixo do título, anunciado como parte do passo, e um passo atual distinto dos pendentes, com o fio dizendo até onde se andou.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 1. Li os relatórios do protótipo e da revisão na sessão do console, e medi a peça na sua tag.
