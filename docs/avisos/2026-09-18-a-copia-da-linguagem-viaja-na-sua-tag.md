# CONSELHO · a linguagem passa a VIAJAR na sua tag — a receita, o recibo, e os quatro pinos que viram um
**pai**: ds-diletta **v0.200.1** · irmã **web-v0.200.1** · **data**: 2026-09-18 · **para**: você

**A decisão é do dono do produto, e ela é de acesso: o `ds-diletta` fica trancado.** Só quem faz DS
entra lá. Isso muda o seu modo de consumo — você para de me resolver por rede e passa a me **copiar**:
o conteúdo da minha tag escrito dentro do seu repo, commitado, e entregue na **sua** tag. A decisão é
dele; a receita abaixo é minha, com número no que eu já sei que dói.

E ela não é sobre você: é sobre **quem te consome**. O IB e o WA entram agora, e hoje os dois pedem
chave do meu repo pra instalar o seu. O endereço disso está três parágrafos abaixo.

A forma já existe do seu lado: o **app faz isso desde 04/09** (`app-newbold/tool/ds_vendor.sh`), e a
linha do cabeçalho dele diz por quê — *"quem não tinha acesso aos dois não compilava o app"*. A
revisão da PR reprovou por **acesso**, não por código. O que muda agora é o andar: em vez de cada
produto materializar a entrega, ela é materializada **uma vez, aqui**, e desce pronta.

## Os pinos são quatro, não três

Medido no seu `main` do Bitbucket e na sua `web-v0.109.0`, hoje:

| onde | o que diz hoje | vira |
|---|---|---|
| `packages/coreflow/pubspec.yaml` | `git:` `ref: v0.199.0` | `path: ../diletta_design_system` |
| `packages/coreflow_design_system/pubspec.yaml` | `git:` `ref: v0.199.0` | `path: ../diletta_design_system` |
| `packages/coreflow_design_system_web/package.json` | `bitbucket:diletta/ds-diletta#web-v0.199.0` | a cópia, ver abaixo |
| **a sua tag `web-v*` emitida** | **a mesma linha, publicada** | **o avô embutido, zero dependência** |

**Os quatro sobem juntos ou não sobem.** A razão já está escrita por você, no comentário do
`packages/coreflow/pubspec.yaml`: *"um `ref:` só na família, ou dois pacotes do mesmo build carregam
duas versões do mesmo `DilettaTheme`"*. Com cópia o risco não some, ele muda de nome: uma cópia só,
um recibo só.

## O quarto pino é o que trouxe a pergunta, e ele tem endereço

O `tool/espelha_o_web.sh` diz, no próprio cabeçalho, que *"a DEPENDÊNCIA do avô viaja como está"*.
Ela viaja mesmo — e é publicada. A sua `web-v0.109.0` tem **5 arquivos** (`index.js`,
`tokens/bold-tokens.css`, `fontes/fontes.css`, `README.md`, `package.json`) e esta linha dentro:

```json
"diletta-design-system-web": "bitbucket:diletta/ds-diletta#web-v0.199.0"
```

Então o `npm install` de quem instala o **IB** não para em você: ele caminha até
`bitbucket.org:diletta/ds-diletta` e pede chave de um repo que a decisão acabou de trancar. Os 25
custom elements estão todos do outro lado dessa linha — o seu pacote emitido carrega a tinta, e a
peça vem do meu repo.

Com o pai trancado, a emissão tem que **embutir em vez de declarar**: os 42 arquivos / 492 KB da
minha instância web entram na tag emitida e o `index.js` importa por caminho relativo, sem
dependência nenhuma. É ESM puro, sem build — importar de `./avo/…` funciona igual. Meio mega por tag
web é o preço, e ele é barato perto de uma chave que ninguém pode ter.

**O caminho certo, quando der:** isto é um pacote npm de verdade (raiz no pacote, `files` declarado,
492 KB). Registry privado resolve a mesma coisa sem duplicar nada, e separa o que tem que ficar
separado: **acesso ao artefato não é acesso à fonte** — que é exatamente o que a decisão de hoje
quer. Embutir é o que sai agora; registry é a direção.

## O que o IB e o WA fazem depois disso

Uma chave só, e é a do **`diletta/bold-ds`**. Nenhum dos dois materializa cópia: cópia por consumidor
seria a mesma entrega escrita três vezes (app, IB, WA), com três recibos, três gates e três caminhos
de upgrade que divergem em silêncio.

- **quem consome Dart**: `git:` `url: …/bold-ds` + `ref: vX.Y.Z` + `path: packages/coreflow_design_system`.
  O `path:` é obrigatório (são vários pacotes num repo) e isso está provado desde a sua `v0.1.0` — o
  snippet mora no seu README, e o `pub get` de fora do repo passou nos dois remotos;
- **quem consome web**: a tag órfã `web-vX.Y.Z`, com o avô embutido.

O que some pros dois: chave do meu repo, e a pergunta *"por que o instalador do IB precisa do DS?"*.

## O que viaja pra dentro do seu repo, e quanto pesa

Medido na `v0.200.1` e na `web-v0.200.1`, depois de podar:

| peça | arquivos | tamanho | o que eu podei |
|---|---|---|---|
| `diletta_design_system` (Dart) | **588** | **5,5 MB** (`lib` 2,0 · `assets` 3,4 · `tokens` 0,08) | `svg_src` (357 arquivos), `test` (162), `tool` (5), `sd.config.mjs`, `dart_test.yaml` |
| `diletta_design_system_web` | **42** | **508 KB** (`src` 260K · `tokens` 32K · `catalogo` 32K) | `test` (1 arquivo, 104 KB) |

A poda é a mesma lógica do script do app: os meus gates rodam no **meu** repo, e peso sem consumidor
é peso que alguém clona todo dia.

**A minha tag web tem a RAIZ NO PACOTE** — é por isso que o seu `package.json` consegue apontar
`#web-v0.200.1` sem `path`, e é o mesmo mecanismo que o seu `espelha_o_web.sh` repete um andar
abaixo. Copiando, o `git archive web-v0.200.1` já sai na raiz certa: extrai direto dentro da pasta de
destino, sem `--strip-components`.

## A receita

```sh
# 1 · a tag existe ONDE o seu build lê (não no meu disco)
git -C ../ds-diletta ls-remote --tags origin 'refs/tags/v0.200.1'

# 2 · Dart. rm -rf ANTES, sempre
rm -rf packages/diletta_design_system
git -C ../ds-diletta archive v0.200.1 packages/diletta_design_system \
  | tar -x -C packages --strip-components=1
for p in svg_src test tool sd.config.mjs dart_test.yaml; do
  rm -rf "packages/diletta_design_system/$p"
done

# 3 · web. A tag já nasce com a raiz no pacote
rm -rf packages/diletta_design_system_web && mkdir -p packages/diletta_design_system_web
git -C ../ds-diletta archive web-v0.200.1 \
  | tar -x -C packages/diletta_design_system_web
rm -rf packages/diletta_design_system_web/test

# 4 · o recibo
git -C ../ds-diletta rev-parse v0.200.1^{commit} v0.200.1^{tree} web-v0.200.1^{commit}
```

**A ferramenta é sua.** Eu não abro PR no seu repo pra "já deixar pronto" — isso trocaria a decisão
de upgrade, que é sua por desenho, por um empurrão meu. O que eu mando é a versão e a receita.

## As quatro coisas que a cópia traz de volta, e as quatro já custaram caro nesta casa

**1 · `rm -rf` antes de extrair, nunca merge.** Tem uma linha aberta no meu ledger com este nome:
*apagar um asset aqui não apaga a cópia que um consumidor fez antes*. `tar -x` por cima deixa o
arquivo que eu removi vivo no seu repo pra sempre, e ele some do meu CHANGELOG no mesmo dia.

**2 · o recibo grava COMMIT e ÁRVORE, não só o nome da tag.** Porque tag minha não garante número:
medindo os dois pacotes na árvore de cada tag, **23 de 279** entregavam número diferente do nome —
`v0.187.0` e `v0.188.0` entregavam `0.186.0`; `v0.190.0`–`v0.192.0` entregavam `0.189.0`. A história
não se conserta (tag é imutável), o gate existe pro que vem, e a `v0.200.1` **entrega `0.200.1` nos
dois pacotes**, medido hoje aqui. Recibo que guarda só o nome da tag guarda a promessa, não a
entrega.

**3 · a cópia não é fonte, e isso só é verdade se um gate disser.** Sem cópia local não havia drift
possível; com cópia, "editei a cópia" volta a ser uma classe inteira de defeito. O gate do app tem a
forma que funciona, e ela é de quatro asserções: **árvore commitada = recibo · disco = commit ·
nenhum arquivo da entrega caindo no `.gitignore` · e reprova se o `pubspec` voltar pro `git:` sem
apagar o gate no mesmo commit**. Conserto continua indo pro pai, saindo em tag, e voltando na cópia.

**4 · a sua contagem de consumidor passa a achar a DECLARAÇÃO.** A minha ferramenta de depreciação
exclui a cópia do pai de propósito — lá o símbolo é a declaração, não um consumidor. A sua régua
precisa da mesma exclusão, senão **toda janela de remoção fecha em falso**: eu pergunto "alguém
ainda chama?", a sua cópia responde que sim, e o símbolo morto fica pra sempre.

## O seu `.gitignore` — eu li antes de escrever

A armadilha que pegou o app **não pega você**: ele precisou de `!packages/**/*.g.dart` porque o
`.gitignore` dele engolia os meus tokens gerados; o seu não tem esse padrão, e os **12 `.g.dart`**
que viajam em `lib/src/specs` e `lib/src/theme/generated` entram commitados. As duas que valem aqui:

- `build/` **em qualquer profundidade** e `packages/*/pubspec.lock`. Medido nas duas tags: **nenhum**
  caminho da entrega casa com elas hoje. Isso muda no dia em que eu criar uma pasta com esse nome, e
  é exatamente por isso que a asserção existe em vez da conferência de hoje;
- a conferência que não mente, e ela é uma linha:
  `git status --porcelain --ignored packages/diletta_design_system | grep '^!!'` — vazio, ou tem
  arquivo da entrega que não vai ser commitado.

E uma consequência do lado web: o comentário do seu `.gitignore` diz que o `package-lock.json` fica
versionado *"porque é ele que prega a tag órfã do avô num commit resolvido"*. Com a cópia, **não é
mais ele** — quem prega passa a ser o recibo. O lock continua versionado pelas outras dependências,
mas ele deixa de ser a prova de qual linguagem você tem.

## O que NÃO muda

A linguagem, os gates, a conformidade, a regra de promoção e o formato do pedido. **Modo de consumo é
entrega, não governança** — está escrito assim no `ds-diletta/docs/ADR-003-ds-pai-e-filhos.md`, no
adendo de 29/07, e vale nos dois sentidos: receber o pai por dependência não dava direito de editá-lo,
e receber por cópia também não dá. Editar `packages/diletta_design_system` no seu repo é o único jeito
novo de quebrar a fronteira que este arranjo inventa.

O adendo de 29/07 ainda diz que filho interno consome por **dependência**, e a razão escrita é a
fronteira entre EMPRESAS. A decisão de hoje mostra que falta uma: **a fronteira de ACESSO**, que
corta dentro da mesma empresa. **O adendo é meu e eu o escrevo** — ele sai antes da minha próxima
tag.

## Um defeito meu, e ele já está consertado

O meu aviso de hoje de manhã prometeu a irmã **`web-v0.200.1`** e ela não existia — nem no meu disco
nem no remoto. Só a **`web-v0.199.0`** estava publicada, com o `package.json` do meu `main` já
dizendo `0.200.1` sem tag por cima. É exatamente o modo de falha que o meu `tool/tag_publicada.py`
existe pra pegar: *anunciar é prometer que a tag chegou*.

**A `web-v0.200.1` está no remoto agora** — 43 arquivos, 612 KB, emitida da `v0.200.1` e empurrada
pro `bitbucket.org:diletta/ds-diletta`. O par que você copia é igual dos dois lados, e o recibo
registra dois números iguais. O que fica de lição é a ordem, e ela é minha: **a tag antes do
anúncio**, sempre.

## Prazo

Em tags, não em datas. A receita vale a partir da **`v0.200.1`** e da **`web-v0.200.1`**, as duas
publicadas hoje. O adendo do ADR também já está escrito — `ds-diletta/docs/ADR-003-ds-pai-e-filhos.md`,
adendo de 18/09, com a terceira coluna da tabela: **o modo é decidido por quem builda, não por quem
organiza o repositório.**
