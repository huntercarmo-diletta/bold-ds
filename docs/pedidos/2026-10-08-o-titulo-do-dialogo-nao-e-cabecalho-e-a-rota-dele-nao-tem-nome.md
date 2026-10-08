# PEDIDO · o título do diálogo não é cabeçalho, e a rota dele não tem nome — a web do mesmo diálogo tem os dois

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.3.1` (`5a0acb7`), pelo pino do `packages/coreflow/pubspec.yaml:23`. O app
  vendoriza `bold-ds v0.122.1` com esse mesmo avô em `origin/development` e `origin/release/homologation`
  (recibo `packages/ds_vendor.json` do `app-newbold`). **Medido também na ponta, `v3.9.0` (`171037d`)**:
  `diletta_dialog.dart` é o mesmo byte a byte entre as duas tags (`git diff v3.3.1 v3.9.0` vazio)
- **bloqueante?**: **não** — o diálogo abre, trava a tela e decide. O que falta é o leitor de tela saber
  o que abriu
- **é DEFEITO, não variante**: não pede eixo, slot nem peça nova. Pede no Dart o que o
  `<diletta-dialog>` já faz na web
- **achado por**: auditoria de acessibilidade do app (06/10), na confirmação que a câmera abre antes de
  aprovar Pix e Internet Banking pelo QR (`lib/core/ui/confirmar.dart:73-105`, branch
  `feat/terminator-scan-aprovacao-legivel`). WCAG 1.3.1 (o título é cabeçalho e não diz que é) e 4.1.3
  (a mudança de contexto não se anuncia pelo nome)

## Falta

No `DilettaDialog`, duas marcas de semântica que o desenho já tem e a árvore não:

1. o **título** como cabeçalho (`Semantics(header: true)`), porque é o que o desenho diz que ele é;
2. a **rota nomeada pelo título** (`Semantics(namesRoute: true, scopesRoute: true, explicitChildNodes:
   true, label: title)` em volta da caixa), que é como o Android anuncia «Remover cartão?» ao abrir em
   vez de cair no primeiro texto que o foco encontrar.

## Número

**O que a peça monta**, `diletta_dialog.dart` na `v3.3.1` e na `v3.9.0`:

| | o que tem | linha |
|---|---|---|
| a caixa | `Center` → `Padding` → `ConstrainedBox(360)` → `DilettaBox`, sem `Semantics` | `:115-125` |
| o título | `DilettaText(title, style: DilettaType.titleMd)`, sem `header` | `:137` |
| o atalho | `showDialog` com `builder: (_) => DilettaDialog(…)` | `:98-108` |
| no pacote inteiro | `header: true` só na barra de topo; `namesRoute`, **zero** | `diletta_navigation_top_bar.dart:379` |

**Medido com teste de widget** no pacote do filho, contra o pino `v3.3.1`, abrindo
`DilettaDialog.show(title: 'Remover cartão?', message: …)` sob o tema claro do Bold:

| o que se perguntou à árvore | resposta |
|---|---|
| o nó do título tem `isHeader`? | **não** (`label: Remover cartão?`, sem a marca) |
| algum nó da árvore tem `namesRoute`? | **zero** |
| algum nó tem `scopesRoute`? | **um**, o da rota do `showDialog` (o Flutter põe, a peça não) |

O `AlertDialog` do Material, que é o que esta peça substitui, põe `namesRoute` com o rótulo do diálogo
fora do iOS. A peça saiu do `AlertDialog` (é `Center` da camada `widgets`, como o seu `///` declara) e
**a semântica não veio junto**.

**A web do mesmo diálogo já faz os dois**, na `web-v3.9.0`:

```
src/diletta-dialog.js:121   <dialog part="caixa" aria-labelledby="t">
src/diletta-dialog.js:125     <h2 class="titulo" id="t" part="titulo">${escapa(titulo)}</h2>
```

O mesmo vocabulário, declarado `ambos` desde o veredito de 21/09 (*o diálogo e a folha existem no Dart
e não atravessam*): a web nomeia a caixa pelo título e marca o título como cabeçalho; o Dart, nenhum
dos dois.

**Quanto isso alcança no app** (`app-newbold`, branch `feat/terminator-scan-aprovacao-legivel`,
`7dd677d4`): o `DilettaDialog` é montado em **2** arquivos, e um deles é a função `confirmar()` de
`lib/core/ui/confirmar.dart`, chamada **41 vezes em 28 arquivos** (toda ação que não volta atrás). O
outro é `onboarding_conta_existente.dart:32`. **Neste repo** (`bold-ds`): zero usos de produção, um no
catálogo (`packages/catalog/lib/ds_do_bold.dart:2452`).

## Já tentei

- **Embrulhar na tela.** Daria: um `Semantics(namesRoute: …)` por fora do `DilettaDialog` em
  `confirmar.dart`. Não fizemos, por dois motivos: o `header` do título fica **dentro** da peça e não se
  alcança de fora sem reescrever o nó (o que esconderia a semântica que você puser depois, sem nada
  acusar), e a mesma cobertura teria que ser repetida em cada filho que abrir um diálogo.
- **Usar `AlertDialog`** de volta: é a cópia divergente do desenho que a peça existe pra evitar.

## Conferi no pai

- `DilettaManifesto.busca('diálogo')` e `busca('dialogo')` na `v3.9.0` devolvem
  `[design-system-dialog]`: a peça é esta e já existe. Não é peça nova.
- A spec `specs/design-system-dialog/spec.md` (`v3.9.0`) não tem requisito de semântica: zero
  ocorrências de `leitor`, `semant`, `header`, `rota`. Então não é a peça desobedecendo a spec, é a spec
  sem a linha.
- Ledger (`docs/PEDIDOS.md` de `origin/main`): três linhas sobre o diálogo (o slot `content`, 08/08; a
  travessia para a web, 21/09; o `Esc` cancelável na web, 25/09). **Nenhuma sobre semântica.** Nenhum
  «não» anterior a reler.

## Derivável?

**Não do lado de cá.** O título é um `DilettaText` dentro da caixa da peça; só ela decide o nó dele.

## Se você disser não

O app embrulha a função `confirmar()` num `Semantics(namesRoute: true, label: title)` por fora, e o
título continua sem `header`. Fica registrado no app como dívida conhecida, com a data deste pedido.

## Não estou pedindo

- mudança de desenho, de tipo ou de ordem (mensagem explica, conteúdo recebe, ação decide continua);
- foco automático no primeiro botão nem foco preso: o `showDialog` já prende, e isso não foi medido
  como falha;
- nada na web: ela já faz;
- nada no Coreflow: o pai não tem diálogo próprio, usa o seu.

## Como o pai vai saber que funcionou

Um teste de widget, nos moldes do da barra de topo (`header: true` cobrado):

1. `DilettaDialog.show(title: 'X?')`: o nó do título tem `isHeader`;
2. existe exatamente um nó com `namesRoute` e o rótulo dele é `X?`;
3. com `content` e `actions`, os filhos continuam alcançáveis um a um (`explicitChildNodes`), sem o
   rótulo da caixa engolir o texto da mensagem.

Do lado de cá, quando a tag sair: subimos o `ref:` do pai, vendorizamos no app, e a auditoria mede a
confirmação da câmera de novo.

## Como cheguei aqui

O auditor de acessibilidade do app marcou o título sem cabeçalho na confirmação da câmera, em 06/10. O
chat do Terminator passou o achado ao entregador em 08/10. Tudo acima foi medido no código das duas
tags do avô (`v3.3.1` e `v3.9.0`, Dart e web), no app (`7dd677d4`) e neste repo (`1e380de`); a árvore de
semântica, com teste de widget descartável rodado no pacote do filho contra o pino `v3.3.1`.

## VEREDITO · ENTRA — o diálogo se anuncia pelo título, como a web já fazia
**pai**: ds-diletta **v3.10.0** · **data**: 2026-10-08

### O que decidiu

A sua frase: *«A peça saiu do `AlertDialog` e a semântica não veio junto»*. Paridade da mesma peça, isenta do consumidor nomeado. O título é `header`, a caixa é `namesRoute` + `scopesRoute` + `explicitChildNodes` com o rótulo do título.

### O que eu achei indo implementar

a spec não tinha requisito de semântica, como você viu. Ganhou «o diálogo se anuncia pelo título».

### O que eu recusei, e a condição de reabrir

nada recusado.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma marca na peça, não 41 embrulhos no `confirmar()` |
| escalabilidade | ↑ | todo filho que abre um diálogo recebe |
| aplicação | = | paridade de instância, isenta |
| aderência ao mercado | ↑ | é o que o `AlertDialog` do M3 e o `<dialog aria-labelledby>` fazem |
| robustez | ↑ | gate com os três critérios do pedido |
| arquitetura limpa e simples | = | a árvore ganha dois nós de semântica, nenhum de layout |
| conciso | = | um requisito novo na spec |

### O que você faz

`ref: v3.10.0`. Nada a mudar no `confirmar()`.
