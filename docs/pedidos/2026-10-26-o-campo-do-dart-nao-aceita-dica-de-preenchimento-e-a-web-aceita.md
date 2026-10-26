# PEDIDO · O campo do Dart não aceita dica de preenchimento automático — e a web aceita desde a v3.18.0

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai, `packages/coreflow/pubspec.yaml:23`); medido também na ponta, `v3.25.0`
- **bloqueante?**: não para a tela; **sim para a WCAG 1.3.5 e 3.3.8** no login, na criação de senha e no código por SMS
- **irmão**: `2026-10-26-o-campo-de-codigo-nao-tem-nome-nao-recebe-o-sms-e-nao-deixa-colar.md` (o mesmo mecanismo no `DilettaOtpInput`) e `2026-10-15-os-atributos-nativos-do-input-nao-atravessam-para-o-campo.md` (o lado web disto, **ENTRA DIFERENTE** na `v3.18.0`)

## Falta

Um parâmetro de dica de preenchimento automático no `DilettaInput` (e no `DilettaField`, que ele
compõe), repassado ao `autofillHints` do `TextField`. Hoje ele não existe nos dois, e o app não tem como
dizer à plataforma que um campo é «usuário», «senha atual», «senha nova» ou «CPF».

## Número

**No avô, `v3.24.0` e `v3.25.0` (iguais nesta parte):**

- `DilettaField` não declara `autofillHints` (`diletta_field.dart:53-107`, a lista de campos), e monta o
  `TextField` em `:159` sem ele. O `TextField` do Flutter usa então o padrão `const <String>[]`
  (`material/text_field.dart:314`): o campo entra no autofill sem dica nenhuma
  (`widgets/editable_text.dart:5246-5253`), e a plataforma adivinha.
- `DilettaInput` repassa ao `DilettaField` treze parâmetros (`diletta_input.dart:450-469`) e nenhum
  deles é dica de preenchimento.
- **A web já tem, e o próprio avô escreveu a dívida**: `diletta-input.js:80-81` (`web-v3.25.0`):
  *«paridade: autocomplete, name, min, max — SÓ NA WEB desde a v3.18.0»*. A peça é `ambos` e só um lado
  sabe dizer o que o campo é.
- A spec do `DilettaField` promete o contrário: *«Autofill de senha … funciona sem código extra»*
  (`diletta_specs.g.dart:6189-6191`). Para a senha atual, no iOS, a heurística da plataforma às vezes
  acerta. Para **senha nova** (que pede a sugestão de senha forte) e para **código de uso único**, sem
  dica não há como acertar.

**No app do filho B (`app-newbold`, `origin/development`, 26/10):**

| o quê | sítios |
|---|--:|
| campos de senha (`obscureText:`) | **12** em 9 arquivos: login, folha de senha, criar senha (2), recuperar senha (2), alterar senha, segurança, convite de operador (2), token de convite (2) |
| desses, os que pedem **senha nova** | 8 (criar, recuperar, alterar, convite) |
| `autofillHints` ou `AutofillGroup` no app inteiro | **0** |
| campos de texto do app que passam pelo `DilettaInput` | 139 (`CoreflowCampoDeTexto`, que embrulha o `DilettaInput` em `coreflow_campo_de_texto.dart:181`) |

## Já tentei

Nada em aparelho. Os caminhos por fora, lidos no código, e por que não bastam:

- **Envolver o campo num `AutofillGroup` por fora**: o grupo é do app e o app vai pôr, mas grupo sem
  dica em cada campo não diz nada à plataforma. A dica mora no `TextField`, e ele está dentro da peça.
- **Trocar o `DilettaInput` por `TextField` cru nas telas de senha**: é o remendo que o DS existe para
  apagar, e perde a moldura, o olho e o anúncio do erro (`v3.24.2`).

## Conferi no pai

- O veredito de 15/10 decidiu que atributo nativo **é repasse, não eixo** (lista nomeada `REPASSA`). Este
  pedido é o mesmo repasse do lado Dart.
- WCAG 1.3.5 (Identify Input Purpose): campo que coleta dado da própria pessoa precisa ter o propósito
  determinável por programa. WCAG 3.3.8 (Accessible Authentication): o login não pode exigir que a pessoa
  lembre ou transcreva a senha sem apoio, e o preenchimento automático é o apoio.

## Derivável?

Não: o `TextField` é construído dentro do `DilettaField`, sem porta.

## Se você disser não

O app fica sem preenchimento automático confiável nos 12 campos de senha e no CPF do login, e a auditoria
de acessibilidade do onboarding segue reprovando 1.3.5 e 3.3.8.

## Não estou pedindo

O `AutofillGroup` (é do app). Mudar o desenho do campo. `name`, `min` ou `max` no Dart (sem medida aqui).
Nada no `<diletta-input>`, que já tem.

## Como o pai vai saber que funcionou

`DilettaInput(type: password, autofillHints: [AutofillHints.newPassword])` → o `TextField` interno
recebe a lista. Sem o parâmetro → o comportamento de hoje, sem mudar um pixel. O mesmo no `DilettaField`.

## Como cheguei aqui

A auditoria de acessibilidade da proposta de onboarding (Figma, 26/10) apontou os dois critérios. Medido
no código do avô nas tags `v3.24.0` e `v3.25.0`, no Flutter instalado e no app em `origin/development`.
Não medi em aparelho o que o iOS sugere hoje sem dica.
