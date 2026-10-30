# PEDIDO · O olho da senha e os botões `sm` e `md` ficam abaixo do piso de 44

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai); medido também na ponta, `v3.25.0`
- **bloqueante?**: não; **sim para a WCAG 2.5.8** no olho da senha
- **irmão**: `2026-10-15-o-checkbox-e-o-interruptor-web-nao-tem-o-piso-de-44.md` (o `DilettaCheckbox` ganhou o `DilettaAlvoDeToque` na `v3.16.0`) e `2026-10-05-o-link-de-texto-tem-16-de-alvo-e-o-piso-da-casa-e-44.md` (**ENTRA** na `v3.10.0`)

## Falta

O piso de alvo da casa (44, `DilettaAlvo.piso`) em três controles que ainda não o têm:

1. **o olho da senha** do `DilettaInput`;
2. o `DilettaButton` **`sm`** (28 de altura);
3. o `DilettaButton` **`md`** (36 de altura).

## Número

**Medido com teste de widget no pino `v3.24.0`, tema do Bold:**

| controle | alvo medido | onde |
|---|---|---|
| olho da senha | **18 × 18** | `DilettaTappable` em volta de um `DilettaIcon` de 18, sem piso (`diletta_input.dart:374-392`) |
| botão `sm`, rótulo «Ok» | **40 × 28** | `DilettaPorteDeBotao(altura: 28)` (`diletta_button.dart:692`) |
| botão `md`, rótulo «Ok» | **47 × 36** | `altura: 36` (`:693`) |
| botão `lg` | 51 × 56 | passa na altura |

O `diletta_button.dart` não tem `DilettaAlvoDeToque` (zero ocorrências na `v3.25.0`). Quem já tem, na
mesma tag: `DilettaIconButton`, `DilettaCheckbox`, `DilettaTextLink`, `DilettaToggleSwitch` e
`DilettaChatInput`. **O olho do `DilettaChatInput` tem o piso, e o olho do `DilettaInput` não**: a mesma
função em duas peças, com duas respostas.

**Quem usa `sm` e `md`:**

- dentro do avô: `DilettaEmptyState` (`md`, `diletta_empty_state.dart:117`), `DilettaPromoBanner` (`md`,
  `:102`), `DilettaJourneyStep` (`sm`, `:209`) e a ação de texto da barra de topo (`sm`,
  `diletta_navigation_top_bar.dart:272`);
- no app do filho B (`origin/development`): **11** botões pelo `CoreflowBotao`, que mapeia `xs → sm` e
  `sm`/`md → md` (`coreflow_botao.dart:134-139`). Entre eles o do login (`login_screen.dart:288`) e o do
  envio de documentos do onboarding (`onboarding_documentos.dart:359`);
- campos de senha com olho no app: 12, em 9 arquivos.

## Já tentei

Nada em aparelho. Os caminhos por fora, lidos no código, e por que não bastam:

- **Envolver por fora** com `ConstrainedBox` no app: funciona no botão, não no olho (ele está dentro do
  campo). E é a correção que o `DilettaAlvoDeToque` existe para fazer uma vez.

## Conferi no pai

- `DilettaAlvoDeToque` declara o contrato: *«cresce a área tocável sem crescer o desenho»* e *«muda layout
  de propósito … foi a consequência aceita quando o dono do produto escolheu o piso»*
  (`diletta_alvo_de_toque.dart:4-20`).
- WCAG 2.5.8 (Target Size, Minimum, AA) pede 24 × 24 ou espaçamento; o olho tem 18 × 18 e fica colado ao
  texto do campo. O 44 é o piso da casa (iOS HIG, WCAG 2.5.5).

## Derivável?

O botão, em parte (embrulho por fora em cada chamada). O olho, não.

## Se você disser não

O olho segue com 18 × 18 em 12 campos de senha. Os 11 botões pequenos do app ganham embrulho local, um
por um.

## Não estou pedindo

Mudar a altura **desenhada** dos portes (28, 36 e 56 são decisão de 21/08). Mudar o glifo do olho.

## Como o pai vai saber que funcionou

Olho da senha: alvo ≥ 44 × 44 com o glifo de 18 no mesmo lugar. `DilettaButton` `sm` e `md`: alvo ≥ 44 na
altura, com a caixa pintada em 28 e 36.

## Como cheguei aqui

As críticas de composição e de acessibilidade da proposta de onboarding (Figma, 26/10) pediram para
confirmar o piso do `Sm` e mediram o olho em 18 × 18 no desenho. Os dois se confirmaram no código, e o
`md` apareceu na mesma medição.

## VEREDITO · ENTRA — a web já tinha o piso nos dois, e o Dart estava atrás
**pai**: ds-diletta **v3.26.0** · `web-v3.26.0` · **data**: 2026-10-30

### O que decidiu
*«O olho do `DilettaChatInput` tem o piso, e o olho do `DilettaInput` não»*: a mesma função em duas peças, com duas respostas. E a web respondia certo nas duas.

### O que eu achei indo implementar
A web já tinha `min-height: 44px` no `<diletta-button>` e o olho de 44 no `<diletta-input>`. Era paridade, não peça nova. E o olho web tinha o mesmo comentário escrito duas vezes; uma saiu.

### O que eu recusei, e a condição de reabrir
nada

### Os sete critérios
| critério | | |
|---|:-:|---|
| manutenção | ↑ | 11 embrulhos locais não nascem |
| escalabilidade | ↑ | todo filho, as duas instâncias |
| aplicação | ↑ | 11 botões e 12 olhos do app; adota o filho B |
| aderência ao mercado | ↑ | WCAG 2.5.8 e o HIG |
| robustez | ↑ | teste cobra alvo, caixa pintada e toque na borda |
| arquitetura limpa e simples | = | peça que já existe |
| conciso | ⊘ | a decisão não obriga a escrever nada |

### O que você faz
`ref: v3.26.0`. Nada a mudar no `CoreflowBotao`. **Muda layout**: `sm` e `md` passam a ocupar 44, com a caixa em 28 e 36; confira a barra de topo e o passo da jornada. O olho fica centrado no alvo, como na web: o glifo anda 13 px para dentro.
