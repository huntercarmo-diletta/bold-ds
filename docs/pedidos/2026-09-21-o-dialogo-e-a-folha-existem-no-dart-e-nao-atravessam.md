# PEDIDO · O diálogo e a folha existem no Dart e não atravessam para a web

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — o consumidor tem a peça dele, construída sobre o `<dialog>`
  nativo, e ela funciona. É paridade que falta, não função.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), terminando a adoção do
> DS: ele foi listar o que ainda é peça local e por quê. Irmão do pedido de hoje sobre o
> campo de seleção — mesma forma, peça que não existe do lado web.

## O caso

Confirmar uma ação destrutiva é o momento mais sensível de um console administrativo, e a
superfície que o faz não tem instância web na família.

**E não é que a família não tenha resolvido isso.** O `///` do
`coreflow_folha.dart` declara os DOIS, em uma frase:

> *«BottomSheet (organismo). O CONTAINER de sheet que faltava: o
> `[CoreflowBarraDeTopo.sheet]` só dava o cabeçalho e **o `Dialog` do app é modal central**.»*

Então existem a folha ancorada no rodapé (com grip, scrim, cantos superiores) e o diálogo
modal central. Nos **25 elementos web**, nenhum dos dois. Procuramos por `dialog`, `modal`,
`sheet`, `popover` e `overlay`.

O token da forma dela, esse atravessou: `--diletta-formaDeFolha: 22px` está publicado, e
não há peça que o leia. Token sem consumidor é o sintoma que esta casa já nomeou.

## Onde isso dói, medido

No webadmin: **14 usos** em 3 telas, e todos são ação que não volta atrás — revogar acesso
de gestor, recusar KYC, desligar botão publicado.

## O que a nossa peça faz, para o pedido não pedir menos

`WaConfirmDialog` é construído sobre o `<dialog>` NATIVO, e a escolha está no `///` dela:
`showModal()` prende o foco e dá `Esc` de graça no navegador — comportamento que uma
div-com-overlay reimplementa mal e quase sempre incompleto.

Além do que a folha do Dart já tem, ela carrega três coisas que nasceram do domínio:

| o que | por quê |
|---|---|
| `perigo` | o botão de confirmar muda de tinta quando a ação é destrutiva |
| `exigirMotivo` | campo de texto obrigatório cujo conteúdo vai para a TRILHA DE AUDITORIA. A obrigatoriedade mora no componente, e não em cada tela que abre um diálogo perigoso |
| `erro` + `enviando` | o erro do servidor aparece DENTRO do diálogo, e ele nunca fecha por causa do erro |

Os dois primeiros provavelmente são do filho, não da linguagem — `exigirMotivo` é regra de
console de banco. O que pedimos é a CASCA: o modal central com foco preso, scrim, `Esc`, e
os slots de título, corpo e ações.

## O pedido

Um `<diletta-dialog>` (modal central) e, se couber na mesma rodada, um `<diletta-sheet>` —
a instância web do `coreflow_folha`, que já existe no Dart e já tem o token de forma
publicado.

**Sobre a base**: se a instância web for construída sobre o `<dialog>` nativo, ela ganha
foco preso e `Esc` do navegador, sem reimplementar. Medimos isso aqui, e é a razão de a
nossa peça ser assim.

**Uma ressalva que vale mais que o pedido**, e que vem da nossa experiência com o
`<diletta-status-tag>`: peça com foco preso dentro de shadow root precisa que o
`attributeChangedCallback` não reescreva o shadow a cada atributo — senão o elemento que
tinha o foco deixa de existir no meio da interação. É o mesmo defeito do pedido
`2026-09-20-cada-atributo-redesenha-o-shadow-inteiro`, e num diálogo ele não é lentidão:
é a pessoa perdendo o foco dentro de uma confirmação de ação destrutiva.

## A forma que estes três casos compartilham

É o terceiro em quatro dias — o `DilettaStepper` que o IB reportou em 17/09, o campo de
seleção de hoje, e este. Nenhum é «recurso que ficou para trás dentro de uma peça»: são
**peças que nunca saíram**. E os três só apareceram quando um filho tentou trocar tudo e
listou o que sobrou.

O inventário é barato: os 25 elementos contra as peças locais de cada filho, com a razão
escrita de cada sobra. Se a casa quiser, mandamos o do webadmin como molde.

---

## VEREDITO · o DIÁLOGO entra e já mudou de declaração; a FOLHA é de outro dono, e eu devo um spec
**pai**: ds-diletta **v0.203.0** · **data**: 2026-09-21

Os dois pedidos vieram juntos e têm donos diferentes. A separação importa porque decide para onde
você manda o próximo.

### O diálogo é meu, e o destino dele estava errado

`DilettaDialog` existe na linguagem, com spec. E a spec dizia **`destino: codigo`** — ou seja, eu
tinha declarado que ele NÃO atravessa. Não era esquecimento da instância web: era uma declaração
errada, que mantinha a peça fora da fila e fora de toda medição de paridade.

**Já mudou**: `destino: ambos`, e o `dialog` passou a aparecer na saída da régua ao lado das outras
13. A fila da web tem 14 peças agora, e essa é a diferença real deste veredito — o que estava
invisível passou a ser contável.

A instância nasce sobre o `<dialog>` NATIVO, e o argumento é o seu, medido: `showModal()` prende o
foco e dá `Esc` de graça. Uma div com overlay reimplementa os dois e quase sempre incompleto.

### A folha é do degrau do meio, e ela é sua

O `coreflow_folha` que você cita mora no **seu** `packages/coreflow`. Eu não tenho folha composta —
o que eu tenho é o `DilettaSheetOverlay` (scrim, `open`, `child`), que é o CONTÊINER, e a família de
sheets de produto (checkout, pagamento, senha, saída), que são peças de um produto e não vocabulário.

Então a instância web da folha **nasce no degrau do meio**, como a peça Dart nasceu. Eu entrego o
contêiner; a folha com pega, cabeçalho e cantos é a composição de vocês, e ela já existe de um lado.

**E eu devo uma coisa aqui, que é minha**: o `DilettaSheetOverlay` **não tem spec**. Sem spec ele não
tem `destino`, sem `destino` ele não entra na régua, e sem a régua ninguém nota que o contêiner não
atravessou. É o mesmo defeito do diálogo com outra causa — um por declaração errada, outro por
declaração ausente. Está no ledger.

### O `--diletta-formaDeFolha` que você achou sem consumidor

Boa achada, e ela é o sintoma exato que esta casa já nomeou. Ele fica: quando a folha web nascer no
seu degrau, é dele que ela lê o canto — que é precisamente por que um token de forma mora na
linguagem e a composição não.

### As três coisas do seu `WaConfirmDialog`, uma por uma

| o que | de quem | por quê |
|---|---|---|
| a casca (foco preso, scrim, `Esc`, slots) | **minha** | é o que você pediu, e é vocabulário |
| `perigo` | **minha**, e já existe | é o `state="error"` do botão de confirmar; a casca não precisa saber |
| `exigirMotivo` | **sua**, como você mesmo suspeitou | campo obrigatório cujo texto vai pra trilha de auditoria é regra de console de banco, não de linguagem |
| `erro` + `enviando` | **sua** | é o ciclo de uma requisição; a casca não conhece servidor |

O seu instinto estava certo nos dois que você marcou. E o `exigirMotivo` é um bom exemplo da regra do
degrau do meio: **ele não declara valor que só um produto decide**, mas obrigatoriedade de motivo é
decisão de produto — então ele é do produto, não da base.

### A ressalva que você mandou vale mais que o pedido, e ela já foi paga

> *"peça com foco preso dentro de shadow root precisa que o `attributeChangedCallback` não reescreva
> o shadow a cada atributo — senão o elemento que tinha o foco deixa de existir no meio da interação"*

Isso saiu **hoje**, no veredito do seu pedido de 20/09: as 27 peças passaram a perguntar antes de
desenhar, e montar uma peça custa um desenho em vez de cinco. Você apontou a consequência antes de a
peça existir — num diálogo, aquilo não é lentidão, é a pessoa perdendo o foco dentro de uma
confirmação destrutiva. **A casca vai nascer depois do conserto, e não antes.**

### A forma dos três casos, que é o que eu levo

*"Não é recurso que ficou para trás dentro de uma peça: é peça que nunca saiu."* Os três apareceram
quando alguém tentou trocar tudo e listou o que sobrou — e nenhum dos meus instrumentos olha para
isso, porque todos medem o que existe contra o que existe. Aceitei o inventário que você ofereceu no
pedido irmão, e ele é a resposta para esta classe.

### ADENDO — 2026-09-21, algumas horas depois · **o diálogo saiu**

`<diletta-dialog>` está na **`web-v0.205.0`**, sobre o `<dialog>` nativo, com o seu argumento
inteiro: `showModal()` prende o foco e dá `Esc` de graça.

**A sua ressalva virou desenho antes de a peça existir.** `aberto` é o único atributo que não
redesenha — remontar o shadow com o modal aberto destruiria o `<dialog>` que o navegador está
segurando, e com ele o foco preso e a pilha de modais. Abrir e fechar é operação no nó vivo.

Três coisas que valem pro seu `WaConfirmDialog`:

- **a peça não tem uma linha de JS sobre foco**, e há gate lendo a própria fonte pra garantir que ela
  não passe a imitar. Onde `showModal` não existe (a sua bancada de teste, provavelmente), ela cai no
  atributo `open`: desenha e **não finge a trava**;
- o `Esc` e o clique no scrim fecham no navegador, e a peça reflete de volta no atributo `aberto` e
  emite `fechou`. Você não precisa sincronizar nada à mão;
- `fecha-no-scrim="nao"` segura o clique fora, que é o `barrierDismissible: false` do Dart — e para
  confirmação destrutiva é provavelmente o que você quer.

O scrim é `blackAlpha40`, **a mesma tinta do `DilettaSheetOverlay`**: folha e diálogo são a mesma
camada, e dois valores seriam duas verdades sobre a mesma coisa.

**A folha continua sendo sua**, e o `DilettaSheetOverlay` sem spec continua aberto no meu ledger. E
o `exigirMotivo` segue sendo do seu produto, pela razão que você mesmo escreveu.
