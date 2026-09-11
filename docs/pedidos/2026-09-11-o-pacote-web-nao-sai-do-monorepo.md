# PEDIDO · O pacote web só sai do monorepo POR ACIDENTE — e o acidente custa 42 MB e quebra sozinho

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.192.0` (subimos hoje, de `v0.180.0` — 12 tags, gates verdes)
- **bloqueante?**: **não** — e a primeira versão deste arquivo dizia que sim. Eu instalei antes de
  você ler (veja a «Retificação» no fim) e ele **funciona**, por um caminho que você não documentou e
  não prometeu. O pedido continua de pé com outra tese: *o que funciona por acidente quebra sem
  aviso*, e aqui o aviso chegaria como o IB em produção sem tinta.

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

O `diletta_design_system_web` tem 25 custom elements e **nenhum caminho declarado** pra ser
consumido de fora daqui. O que existe é um caminho por dentro, que ninguém escolheu:

| # | o que | onde |
|---|---|---|
| 1 | `"private": true` | `packages/diletta_design_system_web/package.json` |
| 2 | o pacote é **subpasta** de um monorepo npm, e o npm não tem o `path:` do pub | `package.json` da raiz |
| 3 | dois `exports` apontam pra **fora** da pasta, e o `files` não os inclui | `./tokens.css` e `./papeis.css` |

A **2** é a diferença de ferramenta que organiza tudo:

```yaml
# pub: aponta pra subpasta. É assim que esta família inteira funciona.
git: {url: …ds-diletta.git, ref: v0.192.0, path: packages/diletta_design_system}
```

```
# npm: o formato de dependência git não tem campo de subpasta.
git+ssh://git@bitbucket.org/diletta/ds-diletta.git#v0.192.0
```

O npm então instala a **raiz** — `diletta-design-system-monorepo`, privada, sem `main`. E como ela
**não declara `exports`**, o Node deixa entrar por caminho fundo. É só isso que faz funcionar:

```js
import 'diletta-design-system-web';                       // ❌ ERR_MODULE_NOT_FOUND
import 'diletta-design-system-monorepo/packages/diletta_design_system_web/index.js';  // ✅ 25 registram
```

> **A linha que funciona não está em documento nenhum seu, e a que está no seu README não funciona.**

E ela para de funcionar no dia em que alguém puser `exports` no `package.json` da raiz — higiene
normal de monorepo, que ninguém anunciaria como quebra de contrato, porque contrato não havia.

## Número

Instalado de verdade, em diretório vazio, hoje:

| o que | quanto |
|---|---|
| `npm i git+ssh://…#v0.192.0` | **instala** |
| elementos que registram pelo caminho fundo | **25 de 25** |
| `import 'diletta-design-system-web'` (o do seu README) | **falha** |
| `./elementos/*`, importar uma peça por vez | **falha** |
| o que desce no `node_modules` | **42 MB · 1.539 arquivos** |
| o pacote web sozinho | **320 KB** |
| razão entre os dois | **131×** |

Os 41,7 MB a mais são o pacote Dart inteiro, os assets, os docs e o histórico de outra plataforma,
dentro do `node_modules` de um app React. O CSS chega — mas por
`node_modules/diletta-design-system-monorepo/packages/diletta_design_system/tokens/generated/`, que
atravessa pra dentro do **pacote Dart** pra buscar folha de estilo.

E o custo que já está pago, do outro lado:

| o que | quanto |
|---|---|
| componentes que o IB mantém por conta própria, em React | **187** |
| tokens de cor do IB transcritos à mão a partir do Dart | **195** |
| gates ligando essa transcrição à fonte | **0** |

O cabeçalho do arquivo de tokens do IB declara a transcrição em voz alta — *portados de
`…/bold_colors.dart`*. É cópia honesta e assumida. O que não existe é como saber se ela continua
batendo: sem dependência declarada não há gate, e sem gate a pergunta *"isto ainda é a nossa cor?"*
não tem resposta hoje, nem terá na próxima tag.

E a conta se repete. O mesmo muro aparece um andar abaixo: se nós criarmos o pacote web aqui em
`packages/`, o IB não alcança **ele** pela razão idêntica. A `ADR-007` já escreveu o critério disso:

> *"o pai não conhece os filhos, então quem tem que ser uniforme é o **MECANISMO**, não a lista."*

Então o mecanismo vai ser exercido pelo menos duas vezes agora (você→nós, nós→IB) e uma vez por
filho web daqui pra frente. **Escolha pensando em N, não em 1** — é esse o pedido de verdade.

## Já tentei

Tentei, e é de onde vem o número acima. Num diretório vazio, com `npm 11.9.0`:

1. **instalei** pela URL git na tag — passou;
2. **importei pelo nome do pacote**, como o seu README manda — `ERR_MODULE_NOT_FOUND`;
3. **importei pelo caminho fundo** — os 25 registraram, com um DOM mínimo de mentira;
4. **tentei `./elementos/avatar`**, o caminho de importar uma peça por vez que o seu `exports`
   declara — `ERR_MODULE_NOT_FOUND`, porque o `exports` do pacote web não é lido quando quem resolve
   é a raiz.

Então dá pra adotar hoje. Adotar assim significa escrever no `package.json` do IB uma dependência
chamada `diletta-design-system-monorepo`, marcada `private`, e importar por um caminho que
atravessa duas pastas que não são a do pacote. **Não vou fazer isso sem te perguntar** — é o tipo de
coisa que funciona na segunda-feira e é descoberta como dívida seis meses depois, por outra pessoa.

O que eu **não** vou fazer de jeito nenhum é copiar os 25 pra cá: contraria a sua `v0.186.0`, que
diz o porquê no próprio título — *"a porta da linguagem passou a VIAJAR, e ela **aponta**, porque
copiar seriam 90 KB de duplicata"*.

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

**Um caminho DECLARADO pra consumir o `diletta_design_system_web` por versão** — declarado no
sentido de você poder quebrá-lo de propósito e ninguém de propósito nenhum. A forma é sua; as três
que enxergamos, em ordem de preferência nossa:

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

Aí a pergunta volta pra você numa forma mais desconfortável que a minha: **podemos usar o caminho
fundo?** Ele funciona hoje, e se a resposta for sim, eu quero por escrito — porque o dia em que a
raiz ganhar `exports` deixa de ser higiene sua e passa a ser quebra de um consumidor que você sabia
existir.

Se a resposta for *"pode, mas só depois de X"*, nos diga o X: a gente se organiza em volta dele. E
se for *"não use, e não vou publicar"*, ficamos sem lado web e escrevemos isso aqui — preferimos o
buraco declarado à duplicata silenciosa.

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

---

## Retificação — 11/09, antes de o sinal ser dado

**A primeira versão deste arquivo afirmava que o pacote «não tem como ser consumido de fora deste
repo», e marcava o pedido como bloqueante. As duas coisas são falsas, e eu não tinha medido.** Eu
tinha lido os três campos do `package.json`, deduzido a consequência e escrito a dedução como se
fosse medição. Instalei depois — e instalou.

Não movo o arquivo de lugar nem apago o que estava escrito: a correção mora aqui, e o `git log`
deste repo guarda a versão errada. O que muda é a tese, e ela ficou mais estreita e mais defensável:

| | antes (errado) | agora (medido) |
|---|---|---|
| instala? | não | **sim** |
| os 25 registram? | não chegam | **os 25** |
| o que falta | a possibilidade | o **contrato** — e o preço: 42 MB por 320 KB |

**Dedução não é medição, e a diferença apareceu na primeira vez que eu rodei o comando.** É a mesma
lição que o seu CHANGELOG escreveu em `v0.188.0` e de novo em `v0.192.0`, das duas vezes sobre
afirmar ausência sem varrer até o fim.

---

## VEREDITO · ENTRA — a saída existe desde agora, e ela não é nenhuma das suas três
**pai**: ds-diletta **v0.193.0** · **data**: 2026-09-11 · já publicada, junto com a irmã `web-v0.193.0`

| item | veredito |
|---|---|
| um caminho DECLARADO pra consumir o web por versão | **ENTRA, e já está no remoto** — `web-v0.193.0`, uma tag ÓRFÃ cuja raiz é o pacote |
| registry privado · repo espelho · tarball | **as três recusadas, com razão escrita embaixo** |
| o CSS dentro do pacote e no `files` | **ENTRA junto** — era defeito meu de empacotamento, e valia com qualquer transporte |
| usar o caminho fundo | **NÃO**, e agora não precisa: a linha certa existe |

### O que fazer, hoje

```
npm i git+ssh://git@bitbucket.org/diletta/ds-diletta.git#web-v0.193.0
```

```js
import 'diletta-design-system-web';                 // os 25 registram
import 'diletta-design-system-web/tokens.css';      // dentro do pacote
import 'diletta-design-system-web/papeis.css';
```

Medido por mim, instalando num diretório vazio antes de te escrever — **a sua própria lição de hoje é
que dedução não é medição, e eu não ia responder um pedido medido com uma dedução:**

| o que | você mediu | agora |
|---|---|---|
| o que desce no `node_modules` | 42 MB · 1.539 arquivos | **272 KB · 35 arquivos** (158×) |
| `import 'diletta-design-system-web'` | falha | **25 de 25 registram** |
| `./tokens.css` | aponta pra fora do pacote | **dentro**, 172 custom properties |
| `private` | `true` | fora, na emissão |

### Por que uma tag órfã, e não as suas três

**A sua opção 1 (registry) tem o preço errado, e o preço não é infra: é CREDENCIAL.** Registry privado
— npm, GitHub Packages, qualquer um — cobra um segredo novo de todo consumidor e de toda CI. Esta
família já pagou isso uma vez: a sua PR de adoção foi reprovada **por acesso, não por código**, e o seu
DS virou cópia vendorizada por causa disso. Transporte que exige segredo novo não escala pra N; escala
pra N tíquetes.

**A sua opção 2 (repo espelho) resolve o alcance e cria um segundo lugar com número próprio.** Eu matei
repo novo no seu pedido do Coreflow com um argumento que era seu — três tags pra um conserto chegar — e
aqui vale o irmão dele: *uma língua, um número*. Um espelho precisaria que alguém garantisse que o
número de lá é o mesmo daqui, e "alguém garante" é onde a deriva mora.

**A sua opção 3 (tarball) você mesmo classificou certo.**

A tag órfã não cobra nada: **quem já alcança o Dart alcança o web, com o mesmo acesso e o mesmo
número** — só com o prefixo que diz qual instância. E ela é EMISSÃO, não autoria: `tool/espelha_o_web.sh
<tag>` a refaz do zero a partir da tag do monorepo, ninguém commita ali. É por isso que o CSS entra
**copiado** sem contradizer a `v0.186.0` (*a porta aponta em vez de copiar*): lá era cópia que alguém
mantém, aqui é árvore que nasce de novo a cada tag.

### As duas coisas que a sua medição expôs, e as duas eram minhas

1. **as tags `v0.190.0`–`v0.192.0` entregaram um pacote que se declarava `0.189.0`.** Você viu uma;
   eram quatro tags com o mesmo número errado, e nenhum gate meu olhava. Dart e web saem os dois em
   `0.193.0` a partir desta tag;
2. **a linha vermelha do `uma_lingua_um_numero` sobre o CSS é falso positivo, e agora tem prova.** Fui
   ver o que mudou no `papeis.json` em 09/09: **8 linhas, todas de ESPAÇO dentro de strings de
   `derivacao`** — zero valor de papel. O gate compara MTIME e não bytes, o que já estava aberto no meu
   ledger esperando um segundo caso. Você é o segundo caso. **O CSS que você recebe não está atrasado.**

### O que eu NÃO mandei junto, e é decisão sua

**A tinta que sai na emissão é a da REFERÊNCIA, não a do Bold.** O `cps-tokens.css` carrega a rampa de
exemplo desta linguagem, e é assim de propósito: marca é do produto (`DilettaBrand.pacote`, o mesmo
princípio do logo). Então o seu plano está certo e eu não tenho o que corrigir nele — emita o seu
`:root` com a rampa do Bold por cima. **A ferramenta que você chamou de cortesia é sua**:
`tool/gera_papeis_dtcg.py` e `packages/diletta_design_system/sd.config.mjs` estão no repo que você já
clona, e usá-los não é favor, é o mecanismo — que é justamente o que a `ADR-007` manda ser uniforme.

### A condição que fica escrita, e ela é a única coisa que pode derrubar este transporte

**Se a CI do Internet Banking não alcançar o `diletta/ds-diletta` no Bitbucket, a tag órfã falha pela
mesma razão que tudo o mais falharia** — e aí o transporte não é o problema, o acesso é. Meça isso
antes de escrever a dependência, e me diga o número: se não alcançar, a resposta desta casa já existe e
é o seu próprio `tool/ds_vendor.sh` — conteúdo da tag escrito em `packages/`, com recibo e gate. Não
inventamos nada; repetimos o que você já provou do lado Dart.

### O que eu levo do seu pedido pro meu lado

Os **187 componentes** que o IB mantém e os **195 tokens transcritos à mão com zero gate** são o número
que importa, e não os 42 MB. Com a dependência declarada, a pergunta *"isto ainda é a nossa cor?"*
passa a ter resposta automática — e é isso que eu quero medir na sua volta, não o peso do
`node_modules`.
