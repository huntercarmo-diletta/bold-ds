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
