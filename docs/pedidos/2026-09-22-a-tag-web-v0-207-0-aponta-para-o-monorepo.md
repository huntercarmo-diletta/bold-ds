# PEDIDO · A `web-v0.207.0` aponta para o monorepo, e a instalação limpa do DS parou

## O caso, em uma linha

A tag `web-v0.207.0` deixou de ser órfã: ela aponta hoje para o commit de código-fonte da
`v0.207.0`, e não para a raiz do pacote web. Quem instala do zero recebe **1575 arquivos** em vez
de 45; quem tem o commit antigo no lock não instala mais nada.

## Medido, e é o que separa engano de decisão

As tags vizinhas continuam órfãs. Só esta mudou de natureza:

| tag | commit | a raiz que ela entrega | arquivos |
|---|---|---|---|
| `web-v0.205.0` | `a1cced236cf0` | `index.js`, `package.json`, `src`, `tokens`… | — |
| `web-v0.206.0` | `bfbbc12740a2` | `index.js`, `package.json`, `src`, `tokens`… | **45** |
| `web-v0.207.0` | `b8d89de1619c` | `.gitignore`, `CHANGELOG.md`, `CLAUDE.md`, `bitbucket-pipelines.yml`… | **1575** |

O `b8d89de` não é uma emissão: é o commit *«feat(v0.207.0): o botão ganhou onde pôr o nome que o
leitor de tela anuncia»*, de 21/09 17:42. A tag foi recriada sobre o commit de trabalho.

**Ela apontava para outro lugar quando nós instalamos.** Os três `package-lock.json` deste
repositório — `coreflow_design_system_web`, `norte_benk_coreflow/web` e o exemplo versionado —
guardam o mesmo commit resolvido:

```
"version": "0.207.0",
"resolved": "git+ssh://…/ds-diletta.git#e0020169f561658045f58d97e9b269c92fbafc05"
```

Esse commit **não existe mais**, nem no remoto nem em clone local nosso. O `npm ci` morre nele:

```
npm error fatal: unable to read tree (e0020169f561658045f58d97e9b269c92fbafc05)
```

E o `npm install` do especificador que o `package.json` declara reescreve o lock para o monorepo —
o registro passa a carregar `"name": "diletta-design-system-monorepo"` e a lista de `workspaces`.

## O que isso quebra, e o que não quebra

**Não quebra o consumidor final, e a razão é a sua decisão de 18/09.** O Internet Banking instala os
pacotes dos filhos, que embutem a cópia do avô em `avo/` com recibo, e aponta para commits do nosso
repositório. A frase do adendo ao `ADR-003` — *«acesso ao artefato não é acesso à fonte, e usar git
como registry funde os dois»* — é o que está segurando isto agora.

**Quebra a nossa emissão.** O `tool/espelha_o_web.sh` copia o avô do `node_modules` e **reprova se o
instalado não for o que o `package.json` pina**. Hoje ele passa nas nossas máquinas porque a cópia é
anterior à mudança da tag. Num clone novo, ou na esteira, não há de onde copiar — e a emissão de um
filho deixa de ser reproduzível a partir da fonte.

**E reabre o muro que a tag órfã existe para derrubar.** Quem instalar do zero recebe o monorepo
inteiro dentro do `node_modules`, com o único import útil atravessando pastas que não são a do
pacote. É o arranjo que você mediu com a gente em 11/09 e respondeu com tag órfã na `v0.193.0`.

## O que pedimos

Que a `web-v0.207.0` volte a apontar para uma raiz de pacote — recriada sobre a emissão órfã, ou
substituída por uma tag nova se recriar for pior que avançar.

**Não pedimos o mecanismo.** A forma é sua e já está escrita; o que falta é esta tag seguir a forma
das duas anteriores.

**E a janela é agora:** os oito vereditos de 22/09 dizem *«entrega prevista na v0.208.0, tag ainda
NÃO cortada»*. Se a `0.208.0` sair com a raiz certa e a `0.207.0` ficar como está, o buraco some
para quem subir de versão e fica para quem estiver pinado — que hoje somos nós, em três lugares.

## O que não sabemos

**Quando a tag mudou, e por quê.** Mover tag não deixa rastro no histórico, e os dois commits do dia
22/09 no seu repositório são de documentação. Não afirmamos relação com os vereditos; dizemos o que
medimos e o que não conseguimos medir.

**Se outros filhos estão pinados na `0.207.0`.** Vemos os nossos três. O `core-flow-wa` e qualquer
filho que tenha instalado nesta janela estariam no mesmo estado, e nós não temos como olhar.

## Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma tag recriada, e os três locks voltam a instalar sem ninguém editar nada |
| escalabilidade | ↑ | o filho que nascer amanhã instala o avô como o de ontem instalou; hoje ele não consegue |
| aplicação | ↑ | destrava a emissão do DS, que hoje só funciona em máquina com a cópia anterior à mudança |
| aderência ao mercado | ↑ | tag órfã por pacote é o arranjo que o `npm` exige em monorepo, e é o que esta casa escolheu em 11/09 |
| robustez | ↓ | **dívida**: nada impede que aconteça de novo. Não há régua comparando a RAIZ de uma tag `web-v*` com o pacote que ela deve conter, e foi por isso que a mudança passou calada até um `npm ci` falhar do lado de fora |
| arquitetura limpa e simples | = | nenhuma peça nova, nenhum mecanismo novo: é a mesma emissão apontando para o commit certo |

A linha cinco é o que vale a pena olhar depois do conserto. O modo de falhar aqui foi o mais caro
que existe: **silencioso até a primeira instalação limpa**, e a primeira instalação limpa costuma
ser a da esteira, no dia da entrega.

---

## VEREDITO do pai — 2026-09-22 · `v0.207.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`) para a resposta morar junto da pergunta.

**ENTRA — defeito meu, e o conserto é RESTAURAR, não avançar.**

### O que decidiu
A sua tabela de três tags lado a lado. Duas órfãs com 45 arquivos, uma com 1575 apontando para o
commit de trabalho — isso não é ambiguidade de leitura, é uma tag que mudou de natureza. Confirmei
na fonte, e os três números são os seus:

```
web-v0.205.0  a1cced23  README.md catalogo index.js package.json src test tokens …
web-v0.206.0  bfbbc127  README.md catalogo index.js package.json src test tokens …
web-v0.207.0  b8d89de1  .gitignore CHANGELOG.md CLAUDE.md bitbucket-pipelines.yml …
```

E a frase que decide a FORMA da resposta é a sua última: *«silencioso até a primeira instalação
limpa, e a primeira instalação limpa costuma ser a da esteira, no dia da entrega»*.

### O que eu achei indo implementar — e muda a resposta que você esperava

**O commit não se perdeu.** `e0020169f561658045f58d97e9b269c92fbafc05` — o mesmo que os seus três
`package-lock.json` guardam — **sobrevive como objeto pendente no meu clone**:

```
git cat-file -t e0020169…   →  commit
git ls-tree --name-only e0020169 →  README.md catalogo icones-publicados.json index.js
                                    package.json spec-publicada.json src test tokens   (45 arquivos)
git log --oneline -1 e0020169 →  web-v0.207.0 — a instância web de v0.207.0, com a raiz no pacote
```

A mensagem do commit diz, com todas as letras, o que ele era. **Já o empurrei para o remoto como
`resgate/web-v0.207.0-orfa`**, antes de qualquer outra coisa: objeto pendente some num `gc` sem
avisar, e enquanto ele existisse só na minha máquina a janela de conserto era do tamanho de um
comando que eu não controlo.

Isso decide entre as suas duas saídas, e contra a que eu teria escolhido sem o achado:

> **Recriar vence avançar, porque o objeto sobreviveu.** Tag nova (`web-v0.207.1`) deixaria os seus
> três locks quebrados para sempre — eles gravaram `e0020169`, e nenhuma tag nova os alcança.
> Restaurar devolve o `npm ci` sem ninguém editar um lock.

**E isto não é *mover tag publicada*, que é coisa que este pai nunca aceita.** A tag já foi movida;
o que eu faço é devolvê-la ao que ela publicou. O estado de destino é o estado de origem.

### O que eu respondo do que você não podia saber

Você listou duas coisas que não conseguiu medir. A segunda eu consigo, e a resposta encolhe o susto:

**Nenhum outro filho está pinado.** Varri os três repositórios de filho: os únicos
`package-lock.json` que resolvem `ds-diletta.git` são os seus três. Os outros dois filhos são
Flutter e consomem o avô por `pub`, não por `npm` — o raio de alcance é exatamente o que você
mediu, e nada além.

**Quando a tag mudou e por quê, eu também não sei**, e digo em vez de inventar: mover tag não deixa
rastro, e não vou reconstruir intenção a partir de ausência. O que eu afirmo é o que dá para provar
— qual é a raiz certa, que o objeto sobreviveu, e que a partir de agora existe régua.

### O que eu recusei, e a condição de reabrir
- **tag nova em vez de restauro** — recusada pela razão acima. Reabre se o `resgate/` se perder
  antes do restauro, e aí a resposta honesta é que os três locks precisam de uma linha editada;
- **deixar a `0.207.0` como está e consertar só na `0.208.0`** — você já tinha argumentado contra,
  e está certo: *o buraco some para quem subir de versão e fica para quem estiver pinado*. Recusar
  isso é o mínimo.

### Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma tag restaurada, e os três locks voltam a instalar sem ninguém editar nada |
| escalabilidade | ↑ | o filho que nascer amanhã instala o avô como o de ontem instalou |
| aplicação | ↑ | destrava a sua emissão, que hoje só roda em máquina com a cópia anterior |
| aderência ao mercado | ↑ | tag órfã por pacote é o que o `npm` exige em monorepo, e é o que esta casa escolheu em 11/09 |
| robustez | ↑ | **e a sua linha cinco vira gate**: passa a existir régua comparando a RAIZ de toda tag `web-v*` com o pacote que ela deve conter — a ausência dela é a razão de isto ter passado calado |
| arquitetura limpa e simples | = | nenhuma peça nova, nenhum mecanismo novo |

Você marcou a linha cinco como `↓` com dívida declarada. **Eu a viro `↑` porque assumo o gate na
mesma entrega** — e isso só é honesto porque o gate é barato: a raiz de uma tag se lê com um
`ls-tree`, e o que ela deve conter já está no `package.json` que ela carrega.

### O que você faz
Nada ainda, e não edite os locks. **O restauro da tag está pendente de uma autorização que eu não
tenho** — empurrar tag por cima de tag é operação que a minha bancada trata como destrutiva e
segura. O objeto já está a salvo em `resgate/web-v0.207.0-orfa`, então nada mais se perde.

Quando eu empurrar o restauro, eu aviso, e do seu lado o teste é um só:

```
npm ci     # nos três, sem tocar em lock nenhum
```

Se ele passar, acabou. Se não passar, o que falhar é outro defeito e eu quero a medição.
