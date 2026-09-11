# PEDIDO · O pacote web não sai do monorepo — o `path:` que o pub tem, o npm não tem

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.192.0` (subimos hoje, de `v0.180.0` — 12 tags, gates verdes)
- **bloqueante?**: **sim, e é a única coisa bloqueante.** Todo o resto do lado web nós fazemos
  aqui. Sem isto, nenhum produto web da família alcança `diletta_design_system_web`.

## De onde vem o pedido

A decisão do produto é que o Internet Banking passe a consumir o DS do Bold: apontando pra ele, e
substituindo por peça nossa os estilos e os elementos que ele mantém hoje por conta própria.

A `ADR-007` já tinha nomeado esse produto. A rev. 1 dela nasceu do pedido *"o Internet Banking
precisa da nossa cara"*, e a escolha de custom element em vez de React foi justificada assim — *"um
custom element é consumido pelo IB em React, pelo que vier depois, e por página sem framework
nenhum"*.

O produto existe, o caminho é o que a ADR escolheu, e o pacote está pronto. O que falta é ele poder
ser instalado.

## Falta

O `diletta_design_system_web` tem 25 custom elements registrados e não tem como ser consumido de
fora deste repo. Três coisas, e as três são de arquivo seu:

| # | o que | onde |
|---|---|---|
| 1 | `"private": true` | `packages/diletta_design_system_web/package.json` |
| 2 | o pacote é uma **subpasta** de um monorepo npm (`workspaces`) | `package.json` da raiz |
| 3 | dois `exports` apontam pra **fora** da própria pasta | `./tokens.css` e `./papeis.css` → `../diletta_design_system/tokens/generated/` |

A **2** é a que trava, e ela não é escolha de ninguém — é diferença de ferramenta:

```yaml
# pub: aponta pra subpasta, e é assim que esta família inteira funciona
diletta_design_system:
  git: {url: …ds-diletta.git, ref: v0.192.0, path: packages/diletta_design_system}
```

```
# npm: o formato de dependência git não tem o campo path
git+ssh://git@bitbucket.org/diletta/ds-diletta.git#v0.192.0
```

O npm instala a **raiz** do repo, que é `diletta-design-system-monorepo` — privado, sem `main`, e
que não é o pacote web.

> **O modelo de distribuição desta casa — monorepo + `ref:` na tag, sem publicar em lugar nenhum —
> é uma capacidade do pub que o npm não tem.** Funciona para Flutter e não existe para web.

A **3** fecha a saída alternativa: mesmo empacotando à mão, o `files` do pacote é
`["index.js", "src/", "catalogo/"]` e o CSS mora fora dele. **O que sair empacotado chega sem
tinta** — e o próprio README avisa o que isso parece: *"`var(--cps-…)` sem valor não é erro, é
silêncio. Foi assim que o CSS deste repo ficou morto por semanas."*

## Número

O custo não é hipotético: ele já está pago. Medido em 10/09:

| o que | quanto |
|---|---|
| custom elements prontos no seu pacote, inalcançáveis de fora | **25** |
| componentes que o IB mantém por conta própria, em React | **187** |
| tokens de cor do IB transcritos à mão a partir do Dart | **195** |
| gates ligando essa transcrição à fonte | **0** |

O cabeçalho do arquivo de tokens do IB declara a transcrição em voz alta — *portados de
`…/bold_colors.dart`*. É cópia honesta e assumida, feita porque **não havia o que apontar**. O que
não existe é como saber se ela continua batendo: sem dependência não há gate, e sem gate a pergunta
*"isto ainda é a nossa cor?"* não tem resposta hoje, nem terá na próxima tag.

E a conta se repete. O mesmo muro aparece um andar abaixo: se nós criarmos o pacote web aqui em
`packages/`, o IB não alcança **ele** pela razão idêntica. A `ADR-007` já escreveu o critério disso:

> *"o pai não conhece os filhos, então quem tem que ser uniforme é o **MECANISMO**, não a lista."*

Então o mecanismo vai ser exercido pelo menos duas vezes agora (você→nós, nós→IB) e uma vez por
filho web daqui pra frente. **Escolha pensando em N, não em 1** — é esse o pedido de verdade.

## Já tentei

Nada, e a razão é a regra. Toda saída local que existe é copiar:

- copiar os 25 elementos pra cá contraria a `v0.186.0`, que é sua e diz o porquê no título — *"a
  porta da linguagem passou a VIAJAR, e ela **aponta**, porque copiar seriam 90 KB de duplicata"*;
- e cópia sem gate é exatamente o estado que os 195 tokens acima descrevem.

Preferimos o pedido a construir a dívida de novo com outro nome.

## Conferi no pai

- **`exports` já está declarado e bem feito** — inclusive `./elementos/*`, que é o caminho de
  importar uma peça por vez. A forma está certa; o alcance é que não sai do repo.
- **`files` existe e lista três entradas** — então o pacote já foi pensado pra ser empacotado. Só
  não fecha, porque o CSS está fora delas.
- **`uma_lingua_um_numero.py` já cobra `exports`** (*"quem adota não tem por onde entrar"*) — a
  pergunta certa já está no gate, medindo o campo e não o alcance.
- **O gate está vermelho hoje por outro motivo**, e vale saber antes de mexer: dart `0.189.0` × web
  `0.186.0`, mais `cps-papeis.css` mais velho que `papeis.json`. E as tags `v0.190.0`–`v0.192.0` não
  subiram o `version:` do `pubspec.yaml` — o nosso lock resolve `ref: v0.192.0` e recebe um pacote
  que se declara `0.189.0`.

## Derivável?

Não, e é a única coisa da nossa lista que não é. As três travas são linhas de arquivos seus, e o
`GOVERNANCA.md` fecha a porta de consertar daqui: *"um filho nunca conserta o pai localmente. Se
consertar, o conserto morre no próximo sync — ou pior, sobrevive e o pai deixa de ser o pai."*

## O que eu peço

**Que o `diletta_design_system_web` possa ser instalado de fora deste repo, por versão.** A forma é
sua; as três que enxergamos, em ordem de preferência nossa:

1. **Registry privado** — publica `@diletta/design-system-web`, e quem adota faz `npm i` normal.
   Pede infra que a casa não tem, e é a única que escala pro N acima sem criar artefato por pacote.
2. **Espelho por tag** — a cada tag, o pipeline empurra `packages/diletta_design_system_web` pra um
   repo onde ele é a **raiz** (`git subtree split`). Aí `git+ssh://…#v0.192.0` funciona sem infra
   nenhuma, e a fonte da verdade continua aqui — *uma língua, um número* fica preservado.
3. **Tarball por tag** — o mais barato de fazer, o pior de conviver: sem resolução de versão, toda
   subida é URL escrita à mão.

**Em qualquer uma das três, junto:** o CSS precisa morar **dentro** do pacote (ou ser copiado pra lá
na emissão), e o `files` precisa incluí-lo. Sem isso o pacote instala e não pinta.

## Se você disser não

Ficamos sem lado web, e dizemos isso com todas as letras: o IB continua com os 195 tokens copiados,
a deriva continua sem gate, e a `ADR-007` fica com a fase 4 permanentemente inalcançável para o
único produto web da família. Não vamos copiar os 25 elementos pra cá — preferimos o buraco
declarado à duplicata silenciosa.

Se a resposta for *"pode, mas só depois de X"*, nos diga o X: a gente se organiza em volta dele.

## Não estou pedindo

- **A marca declarável no CSS.** Pensamos em pedir e retiramos: os `--cps-*` são variáveis, e a
  derivação dos papéis mora em Dart, que nós temos no build. Emitimos o nosso `:root` com a rampa do
  Bold aqui. **O que a gente pediria emprestado é a ferramenta** (`gera_papeis_dtcg.py` + a config do
  Style Dictionary), e isso é cortesia, não arquitetura — se for mais fácil dizer não, escrevemos a
  nossa.
- **Implementação de componente.** A fase 4 é *por demanda* e a demanda ainda não está medida. Vamos
  medir o IB contra os 25 seus e os 59 do Coreflow, e o que faltar nós escrevemos aqui, pela
  `GOVERNANCA.md` — *"um COMPONENTE que só existe no meu produto: filho, compondo os átomos públicos
  do pai"*. Se dois filhos pedirem a mesma peça, aí ela sobe, com o segundo pedido escrito.
- **Que o monorepo deixe de ser a fonte.** Ele deve continuar sendo. O pedido é sobre a saída, não
  sobre onde o código mora.

## Como o pai vai saber que funcionou

Num diretório vazio, fora deste repo e sem acesso a ele por caminho relativo:

```
npm i <o que você publicar>@0.192.0
```

e uma página com três linhas — as duas folhas de CSS e um `<diletta-button>` — desenha o botão
**com tinta**. Se pintar sem cor, o pacote saiu sem o CSS e o item 3 não fechou.

O teste de aceite do nosso lado é o commit em que `packages/coreflow_web/package.json` declara você
como dependência por versão — e não existe um único arquivo `.js` seu copiado neste repo.
