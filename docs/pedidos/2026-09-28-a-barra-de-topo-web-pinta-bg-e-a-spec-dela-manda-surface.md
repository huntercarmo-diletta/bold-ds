# PEDIDO · A barra de topo web pinta `bg` e `borderSubtle` — e a spec dela manda `surface` e `border`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `origin/main` (`6a2b756`)** — as linhas são as mesmas
- **bloqueante?**: **não** — o console ainda não usa a barra (a forma da casca, trilho lateral ou tira no topo, está com a designer). Mas qual das duas é a lei decide o que ele copia hoje
- **não é peça nova**: o `busca()` não se aplica

## Falta

Uma resposta: **a barra é `surface` com régua `border`, como a spec manda, ou `bg` com régua
`borderSubtle`, como o elemento pinta?** E o lado que perder, alinhado ao outro.

## Número

A spec, `specs/design-system-web-top-bar/spec.md` (`origin/main`):

- `:69-72` — *«A barra SHALL pintar o fundo com `surface` e o limite inferior com `border`»*, com a
  procedência *«saíram de ler a barra no BackOffice (`1LlztURbPBvAO2XLnulQLV`)»*;
- `:103-105` — `"papeis": ["surface", "border", "fg", "textSecondary"]`.

O elemento, `diletta-web-top-bar.js` (pino e `origin/main`):

- `:37-39` — *«A barra é bg, o tom da TELA — não surface. Medido: 71px de #f8faff e 1px de #ececec em
  y=71, e o painel de conteúdo branco só a partir de y=72.»*
- `:40-41` — `background: var(--diletta-bg); ... border-color: var(--diletta-borderSubtle)`.

**As duas dizem ter medido o mesmo arquivo, e chegaram a papéis diferentes.** E há uma terceira frase
contra as duas: o comentário do contrato da spec (`:84-89`) diz que *«`papeis` está vazio de
propósito»* — e ele não está vazio, tem quatro.

## Onde isso toca o consumidor

A casca do console pinta à mão **pela spec**: `.cabecalho { border-bottom: 1px solid
var(--diletta-border); background: var(--diletta-surface) }` (`LayoutAutenticado.module.css:14-28`,
`c928892`). No dia em que ele adotar o `<diletta-web-top-bar>`, a barra muda de fundo e de régua sem
ninguém ter decidido isso — ou ele fica com a cópia à mão para não mudar.

## Já tentei

Nada: é uma pergunta para a lei, não para o consumidor. A auditoria de 28/09 recomendou manter fundo
e borda como estão *«até o avô resolver o conflito entre spec e elemento»*, e é o que o console faz.

## Conferi no pai

Acima. E o `git log` dos dois arquivos: a spec foi tocada por último em `fb30e58` (23/09, a taxonomia)
e o elemento em `ba975e0` (17/09, o prefixo) — nenhum dos dois commits é sobre o papel da barra.

## Derivável?

Não: é a escolha entre duas medições.

## Se você disser não

Não há «não» aqui — os dois lados são seus. Sem resposta, cada consumidor escolhe uma e a família
tem duas barras.

## Não estou pedindo

1. **uma região de navegação no meio da barra** — a auditoria mediu que a barra só serve junto com o
   trilho lateral, e se a designer mantiver a tira no topo isso vira pedido próprio, com medição;
2. **mudar a altura** (72 autenticada, 104 anônima — o comentário do elemento avisa que é de propósito).

## Como o pai vai saber que funcionou

A spec e o elemento dizem o mesmo par de papéis, e o gate que compara `papeis` com o que o elemento
lê passa na barra.

## Como cheguei aqui

Pela passada «o DS em tudo» do webadmin (tarefa 1.12 de `arquitetura-de-informacao-do-console`,
`c928892`, 28/09), auditoria da casca e do login, que comparou o cabeçalho à mão com a peça.

---

## VEREDITO · ENTRA — o elemento é a lei, e a spec muda

**pai**: ds-diletta **v2.8.0** · **data**: 2026-09-28

### O que decidiu

A sua frase: *«As duas dizem ter medido o mesmo arquivo, e chegaram a papéis diferentes.»* Não
mediram do mesmo jeito. A spec LEU a barra no BackOffice. O elemento mediu o PIXEL: 71px de
`#f8faff`, 1px de `#ececec` em y=71, e o conteúdo branco só a partir de y=72. Medição vence leitura.
A barra é `bg`, o tom da tela, com régua `borderSubtle`.

### O que eu fiz

A spec passa a dizer `bg` e `borderSubtle`, na frase e no `papeis` do contrato, com a procedência
corrigida e datada. O elemento não muda um pixel.

### O que eu achei indo implementar

A terceira contradição que você apontou era real: o comentário do contrato dizia *«`papeis` está vazio
de propósito»* com quatro papéis dentro. Ele envelheceu no dia em que os papéis entraram, e ninguém o
releu. Agora ele diz de onde os papéis vêm.

### O que eu recusei, e a condição de reabrir

Nada deste pedido.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma lei no lugar de três frases que brigavam |
| escalabilidade | ↑ | o próximo consumidor copia a lei certa |
| aplicação | = | o elemento não muda; quem muda é a sua casca, quando adotar |
| aderência ao mercado | = | casca no tom da tela com régua fina é o arranjo comum de backoffice |
| robustez | ↑ | a spec volta a dizer o que o pixel diz |
| arquitetura limpa e simples | = | nada novo |
| conciso | ↑ | o comentário que mentia saiu |

### O que você faz

A sua casca à mão pinta pela frase que saiu: `surface` e `border` em `LayoutAutenticado.module.css:14-28`.
Ao adotar o `<diletta-web-top-bar>`, a barra passa a `bg` e `borderSubtle`, e isso agora é o
desenho decidido.
