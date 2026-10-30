# PEDIDO · O campo de código não tem nome, não recebe o código do SMS e não deixa colar

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai); medido também na ponta, `v3.25.0`
- **bloqueante?**: não para a tela; **sim para a WCAG 4.1.2 e 3.3.8** em todo código de verificação do app
- **irmão**: `2026-10-26-o-campo-do-dart-nao-aceita-dica-de-preenchimento-e-a-web-aceita.md` (a dica de preenchimento no `DilettaInput`, o mesmo mecanismo)

## Falta

Três coisas no `DilettaOtpInput`, todas no `TextField` transparente que ele põe sobre as caixas:

1. **um nome** para o leitor de tela (hoje o campo é anunciado sem rótulo);
2. **a dica `oneTimeCode`**, para o teclado oferecer o código que chegou por SMS;
3. **colar**: `enableInteractiveSelection: false` tira o menu de colar.

## Número

**No avô, `v3.25.0` (igual à `v3.24.0`):**

- O construtor tem 10 parâmetros (`diletta_otp_input.dart:30-42`), nenhum de nome nem de dica.
- O `TextField` (`:128-167`) não tem `autofillHints` e crava `enableInteractiveSelection: false` (`:136`).
- **Medido com teste de widget no pino `v3.24.0`, tema do Bold**: a árvore de acessibilidade tem **um**
  nó de campo de texto, com `label=""`, `hint=""` e `value=""`. O `TextField` recebe
  `autofillHints=[]` e `enableInteractiveSelection=false`.

**No app do filho B (`origin/development`):** o `OtpBoxesField` (`lib/shared/widgets/otp_boxes_field.dart:123`)
é casca do `DilettaOtpInput` e não acrescenta `Semantics`. São **7** chamadas em 5 arquivos: verificar o
telefone no onboarding, recuperar senha, parear aparelho (3), chave Pix e cadastro do operador
convidado. Todas recebem código enviado à pessoa.

## Já tentei

Nada em aparelho. Os caminhos por fora, lidos no código, e por que não bastam:

- **Pôr `Semantics(label:)` em volta da casca**: nomeia o grupo, mas o nó de campo de texto continua sem
  nome dentro dele, e o leitor para nos dois.
- **Contornar o colar**: não há como. O menu é decidido no `TextField`, e ele está dentro da peça.

## Conferi no pai

- O `DilettaInput` já resolveu o nome em casa: `Semantics(textField: true, label:)` com `MergeSemantics`
  (`diletta_input.dart:254-269`). O código é o único campo da família sem isso.
- WCAG 4.1.2 (Name, Role, Value): controle sem nome. WCAG 3.3.8 (Accessible Authentication): o código de
  uso único não pode exigir que a pessoa transcreva de cabeça. Colar e o preenchimento pelo SMS são o
  apoio que o critério pede.
- O `enableInteractiveSelection: false` faz sentido para esconder a alça de seleção sobre as caixas.
  Colar não precisa da alça: o Flutter separa as duas coisas pelo `contextMenuBuilder` e pelo
  `selectionControls`.

## Derivável?

Não. Os três moram no `TextField` interno.

## Se você disser não

O app mantém o código sem nome nos 7 sítios, e quem recebe o código por SMS digita os seis números de
cabeça, sem a sugestão do teclado.

## Não estou pedindo

Mudar as caixas, o tamanho ou os estados. Mostrar a alça de seleção. Aceitar letras.

## Como o pai vai saber que funcionou

`DilettaOtpInput(rotulo: 'Código de verificação')` → um nó de campo de texto com esse rótulo. O
`TextField` interno recebe `autofillHints: [AutofillHints.oneTimeCode]` por padrão, ou a dica que o
consumidor passar. Colar «123456» enche as seis caixas e dispara `onCompleted`; colar «123 456» também
(o filtro de dígitos já existe, `:139-142`).

## Como cheguei aqui

A auditoria de acessibilidade da proposta de onboarding (Figma, 26/10). Medido no código das tags
`v3.24.0` e `v3.25.0` e com teste de widget no pino. Não medi em aparelho a sugestão do teclado.

## VEREDITO · ENTRA — nome, dica do SMS e colar, sem a alça
**pai**: ds-diletta **v3.26.0** · `web-v3.26.0` · **data**: 2026-10-30

### O que decidiu
*«Colar não precisa da alça: o Flutter separa as duas coisas»*. A forma saiu da sua frase: `selectionControls: emptyTextSelectionControls` e o menu padrão.

### O que eu achei indo implementar
nada

### O que eu recusei, e a condição de reabrir
nada

### Os sete critérios
| critério | | |
|---|:-:|---|
| manutenção | ↑ | nada à mão no app |
| escalabilidade | ↑ | todo código de verificação |
| aplicação | ↑ | os 7 sítios; adota o filho B |
| aderência ao mercado | ↑ | WCAG 4.1.2 e 3.3.8 |
| robustez | ↑ | teste cobra nome, dica e «123 456» enchendo as seis |
| arquitetura limpa e simples | = | repasse ao `TextField` |
| conciso | ⊘ | a decisão não obriga a escrever nada |

### O que você faz
`ref: v3.26.0`. `rotulo:` nas 7 chamadas do `OtpBoxesField`. A dica `oneTimeCode` já vem por padrão.
