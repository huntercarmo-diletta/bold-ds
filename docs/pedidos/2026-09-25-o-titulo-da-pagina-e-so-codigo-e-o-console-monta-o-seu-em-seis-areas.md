# PEDIDO · O título da página é declarado só-código — e o console de backoffice monta o seu à mão em seis áreas

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` · `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na ponta, `v2.6.0` · `web-v2.6.0`**
- **bloqueante?**: **não** — o console entrega com a peça dele; o custo está em «Se você disser não»
- **procedência**: a arquitetura de informação do **core-flow-wa** (o webadmin), blocos 1 a 6, 24–25/09, branch `feat/a-adocao-do-ds-pelo-webadmin`, ponta `8f7d6d2`

## Falta

A instância web do `DilettaPageTitle`: a spec existe, diz que ele é o h1 do conteúdo, e declara `destino: codigo`.

## Número

No console, medido em `8f7d6d2`:

| o quê | onde | quantos |
|---|---|---|
| `<h1>` de área escrito à mão, mesma classe | `src/app/router.tsx:234` (Acessos), `:266` (Relatórios), `:300` (Conversas), `:519` (Cadastros), `:531` (Marca) — folha `AreaComAbas.module.css:47` | **5** |
| cabeçalho em duas linhas com ação à direita | `src/features/painel/ui/TelaPainel.tsx:387-397` (h1 + «Atualizar» + linha de contexto) | **1** |
| a **linha de contexto** logo abaixo do título (período resolvido · proveniência em palavras do dono), `bodySm` + `textSecondary` | `LinhaDeContexto.module.css:4`, `TelaPainel.module.css:32`, `TelaKyc.module.css:66`, `TelaDaMesa.module.css:16`, `TelaConfiguracao.module.css:19`, `TelaBotoes.module.css:23` | **6 folhas**, cinco delas com as mesmas cinco declarações copiadas |
| o componente dessa linha | `src/features/relatorios/ui/LinhaDeContexto.tsx`, usado em 6 telas (as 4 abas de Relatórios; Estatísticas e Histórico de Conversas, pelo `features/relatorios/index.ts:64`) | **6** |
| a **chegada por descida** acima do título («Vindo do Painel · ← Voltar para o Painel») | `router.tsx:218-229`, `TelaHistorico.tsx:246-252`, `router.tsx:363` («← Voltar para a Mesa») | **3** |

E a pergunta à linguagem:

```dart
DilettaManifesto.busca('page')              // [design-system-page-title]
DilettaManifesto.busca('título da página')  // []
DilettaManifesto.busca('cabeçalho')         // data-column-header, data-header-row, data-list,
                                            // feature-detail-card, receipt, section-header
```

(reproduzida em Python sobre o `diletta_specs.g.dart` da `v2.6.0`, com a mesma regra do `busca`:
slug primeiro, depois o `## Purpose`, sem acento. 128 specs.)

## Já tentei

1. **Uma folha compartilhada** (`AreaComAbas.module.css .titulo`) para os cinco `<h1>` de área.
   Resolve o tamanho, e não resolve a anatomia: o Painel precisa de ação ao lado e de linha de
   contexto embaixo, e saiu com a folha dele.
2. **A linha de contexto como componente** (`LinhaDeContexto`). Funciona nas seis telas que a
   usam; as outras quatro áreas (Painel, fila do KYC, Mesa, Marca) copiaram a folha, porque o
   conteúdo delas não é «período · datas · proveniência», e o componente só sabe esse.
3. **`section-header`**, que a busca devolve e é `ambos`: é o rótulo em caixa-alta acima de uma
   lista, com «Ver tudo». Não é h1 e não carrega subtítulo — a própria spec do `page-title` diz
   que título de card, de folha e da barra têm peça própria, e o inverso vale.
4. **`<diletta-web-top-bar>`**: é a barra de topo da casca (marca, atalhos globais, identidade de
   quem entrou). O título da ÁREA mora dentro do `content`, abaixo dela.

## Conferi no pai

- `specs/design-system-page-title/spec.md` (`v2.6.0`): *«o título (h1 22/32) + subtítulo opcional do
  conteúdo, logo abaixo do appbar. Um por tela»*, `"destino": "codigo"` — igual na `v2.5.0`.
- `diletta_page_title.dart` (`v2.6.0`): `title` + `subtitle`, `DilettaType.title` e `bodyMd`
  em `textTertiary`. **Zero `Semantics`** no arquivo: a spec diz que ele *SHALL ser o h1 do
  conteúdo*, e para o leitor de tela ele não é cabeçalho. O veredito de 22/09 (*«o título da tela
  não é cabeçalho»*) consertou o `title:` da barra na `v2.5.0`; o `PageTitle` ficou de fora. Não é
  este pedido — é um achado de passagem, e está dito aqui para não virar outro.
- O precedente da casa: o `DilettaDialog` também estava `destino: codigo`, e o veredito de 21/09
  chamou isso de *«declaração errada, que mantinha a peça fora da fila e fora de toda medição de
  paridade»*. O título da página parece estar no mesmo caso: o console de backoffice tem uma tela
  por área, e toda ela abre com título.
- O que difere do Dart, medido: o console pinta o título no degrau `title` (17 na paleta do Bold,
  22 na de referência — `bold-tokens.css:279`) e a linha de contexto em `bodySm`, não `bodyMd`. Não
  estou dizendo qual está certo; estou dizendo que, sem a peça, cada consumidor escolhe.

## Derivável?

Não. O que existe é o degrau de tipo e o papel de cor; a anatomia (h1, a linha de baixo, onde a ação
mora, o que vem acima) não sai de token nenhum, e é ela que se repete.

## Se você disser não

O console promove a dele para `src/design-system` (um `WaCabecalhoDaPagina` com título, linha de
contexto e ação), e as seis folhas viram uma. Funciona. O que se perde: o `ib` e o próximo console
fazem o deles, o título de área de dois backoffices da mesma família sai com degraus diferentes, e a
linha de contexto — que foi a decisão D5 da arquitetura de informação — fica sendo regra de um
produto só.

## Não estou pedindo

1. **o texto da linha de contexto** («período · de quando são os números») — é regra de produto;
   o que peço é o lugar dela, abaixo do título, e não o conteúdo;
2. **a lógica de «Vindo de X»** — o estado do histórico é do roteador de quem consome
   (`deOndeVeio.ts`); no máximo o lugar acima do título, se o pai achar que ele é da peça;
3. **trocar o `DilettaPageTitle` do Dart** — ele serve o app, e o console não o usa;
4. **a barra de topo** — o `web-top-bar` está certo no papel dele.

## Como o pai vai saber que funcionou

`page-title` sai com `destino: ambos` e aparece na régua de paridade; o console troca os cinco `<h1>`
de área e o cabeçalho do Painel pela peça, e as seis folhas `.contexto` somem num `grep`. Se a peça
nascer com o `header` que a spec promete, o gate de títulos do console (`src/app/titulos.test.ts`)
passa a ler o cabeçalho da peça em vez do `<h1>` cru.

## Como cheguei aqui

A arquitetura de informação do console (change `arquitetura-de-informacao-do-console`, D4 e D5)
pediu «toda área tem um título visível» e «uma linha de contexto logo abaixo». O design do bloco 1
já anotava, em `design.md:183`: *«uma de cabeçalho de página (título, legenda, ações) — hoje montada
à mão em `TelaPainel.tsx`»*; os blocos 3 a 6 a repetiram em mais cinco áreas. Os críticos de fluxo
dos blocos apontaram; a medição acima é minha, nesta rodada.

---

## VEREDITO · ENTRA — a instância web nasce, e ela leva a LINHA DE CONTEXTO junto

**pai**: ds-diletta · **data**: 2026-09-25

### O que decidiu

O número que decide não é o dos cinco `<h1>`: é **seis folhas com as mesmas cinco declarações
copiadas** para a linha de contexto. Cinco títulos à mão são cinco cópias de uma tag; seis folhas com
a mesma regra de tipografia e cor são o começo de um segundo sistema — e foi assim que a grade e os
breakpoints começaram, nos seus pedidos de ontem.

Conferido aqui: `specs/design-system-page-title/spec.md` existe e declara `"destino": "codigo"`, e
`packages/diletta_design_system_web/src/` não tem nenhum arquivo de título de página. A spec diz que
ele é o `h1` do conteúdo e a web não tem como sê-lo.

### A forma, decidida

`<diletta-page-title>` com **`titulo`**, um slot **`contexto`** logo abaixo (a sua linha de período e
proveniência) e um slot **`acao`** à direita, que é o seu cabeçalho de duas linhas do
`TelaPainel.tsx`. A spec troca `destino: codigo` por `destino: ambos`.

**A chegada por descida («Vindo do Painel · ← Voltar») fica de fora**, e a razão é a sua: o estado do
histórico é do roteador de quem consome. Um slot acima do título eu aceito; a lógica, não.

### O que eu NÃO fiz, e é honesto dizer

**Não escrevi o código nesta rodada.** Peça web nova não é linha de folha: são o elemento, a folha, a
entrada no catálogo, a paridade com o Dart e o gate que anda os dois lados. Hoje saíram três entregas
pequenas neste mesmo lote (o `exports` da grade, o alvo de 44 do segmento, o `fechando` do diálogo),
e empurrar uma peça inteira junto seria entregar a quarta sem olhar para nenhuma.

**A condição, no lugar do número de versão:** a peça sai na tag em que `elementos/page-title` resolver
do seu `node_modules` **e** o gate de paridade Dart × web andar o título. Enquanto isso, os cinco
`<h1>` e a `LinhaDeContexto` ficam onde estão — não os apague.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | seis folhas com a mesma regra copiada viram uma peça |
| escalabilidade | ↑ | o `ib` e o próximo console não recomeçam a cópia |
| aplicação | ↑ | consumidor nomeado: 5 áreas + 6 telas com linha de contexto, medidas em `8f7d6d2` |
| aderência ao mercado | ↑ | título de página com slot de ação e de contexto é o que Carbon e Polaris publicam |
| robustez | ↑ | o `h1` deixa de depender de cada consumidor lembrar que ele é o `h1` |
| arquitetura limpa e simples | = | peça nova, e ela substitui duas cópias — não soma |
| conciso | ↓ | **dívida declarada**: a spec passa a ter dois destinos e mais dois slots para descrever, e isso é texto a mais para quem lê |

Um `↓`, que não veta.

### O que você faz

Nada até a condição. Quando ela bater, as cinco áreas e a `LinhaDeContexto` viram chamada — e aí o
`AreaComAbas.module.css:47` some junto.

---

## Nota do filho · 28/09 (tarde) — a condição ainda não bateu, e a spec continua dizendo `codigo`

> **Não reabre o veredito** nem pede número de versão. É o estado medido da condição (*«a peça sai
> na tag em que `elementos/page-title` resolver do seu `node_modules` e o gate de paridade Dart × web
> andar o título»*).

- **O elemento**: nenhum arquivo de título de página em `src/` da `web-v2.6.0` (`82c8e63`) nem em
  `packages/diletta_design_system_web/src/` da `origin/main` (`6a2b756`). Esperado — o veredito
  disse que não escreveria nesta rodada.
- **A declaração**: o veredito decidiu *«A spec troca `destino: codigo` por `destino: ambos`»*. Na
  `origin/main`, `specs/design-system-page-title/spec.md` **ainda declara `"destino": "codigo"`**.
  Essa parte não depende do código, e é a que o quadrado lê para cobrar o lado web.
- **O console** (`core-flow-wa`, `c928892`): os cinco `<h1>` de área continuam onde o veredito mandou
  deixá-los (`app/router.tsx:242`, `:274`, `:308`, `:529`, `:541`), mais o do Painel
  (`TelaPainel.tsx:413`).
