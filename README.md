# conta-bold-ds — o DS e o catálogo do Conta BOLD

Este repo é **filho de dois pais**: a linguagem (`ds-diletta`) e a ferramenta (`catalogo-diletta`).
Nenhum dos dois sabe que o Bold existe — quem declara identidade, componente próprio e vocabulário
de bloco é aqui.

| pacote | o que é |
|---|---|
| `packages/conta_bold_design_system` | **o DS-filho**: a paleta como instância, a fonte, os gradientes e os componentes que só o Bold tem |
| `packages/catalog` | **o catálogo-filho**: o plugue que declara os blocos, os grupos e o leitor de código |

## O gate

```bash
(cd packages/conta_bold_design_system && flutter analyze && flutter test)   # 99
(cd packages/catalog && flutter analyze && flutter test)                    # 66
```

A conformidade dos dois pais roda dentro desses testes (`violacoesDeConformidade` e
`violacoesDoFilho`), e as duas baselines estão **vazias**: dívida declarada aqui é dívida que alguém
vai esquecer.

## Como os pais chegam

Por **tag**, nunca por caminho local — `pubspec.yaml` de cada pacote fixa o `ref:`. Tag é imutável, e
é o que faz "funciona na minha máquina" não existir.

| pai | versão de hoje |
|---|---|
| `ds-diletta` | `v0.24.0` |
| `catalogo-diletta` | `v0.73.0` |

## Como ESTE filho chega no app — `v0.2.0`

A primeira tag saiu em 2026-08-01; a de hoje é a `v0.2.0`. Mesma regra que eu cobro dos pais: por tag,
nunca por caminho local.

```yaml
dependencies:
  conta_bold_design_system:
    git:
      url: git@bitbucket.org:diletta/bold-ds.git
      ref: v0.2.0
      path: packages/conta_bold_design_system
```

O `path:` não é detalhe: são dois pacotes num repo só, e sem ele o `pub` procura um `pubspec.yaml` na
raiz que não existe.

**O lar é o Bitbucket da Diletta**, o mesmo dos dois pais — `diletta/bold-ds`. O
`git@github-huntdiletta:huntercarmo-diletta/bold-ds.git` é espelho, e carrega a mesma tag.

Uma armadilha medida em 2026-08-01, porque ela erra em SILÊNCIO: este repo tinha um `core.sshCommand`
local cravando a chave do GitHub com `-F /dev/null`, então **todo** remoto daqui usava aquela chave — e
o Bitbucket respondia `Permission denied (publickey)` como se o repo não existisse. A regra é a de
sempre: a chave sai do alias na URL (`~/.ssh/config`), não de um override que ignora o arquivo.

O que a tag carrega está no [CHANGELOG](CHANGELOG.md), e **o app ainda não adotou** — isso é decisão de
quem publica, não deste repo.

## Os documentos

| Preciso… | Leia |
|---|---|
| **o que muda ao subir de versão** deste pacote | [CHANGELOG.md](CHANGELOG.md) |
| **adotar isto no app** (token primeiro, componente depois) e ver o que já nasceu | [packages/conta_bold_design_system/ADOCAO.md](packages/conta_bold_design_system/ADOCAO.md) |
| o que eu já pedi aos pais, e o veredito de cada um | [docs/PEDIDOS.md](docs/PEDIDOS.md) |
| o que os pais me mandaram | [docs/avisos/](docs/avisos/) |
| **publicar o catálogo** (Cloudflare Worker + Access) | [DEPLOY_CLOUDFLARE.md](DEPLOY_CLOUDFLARE.md) |
| a auditoria que precedeu esta arquitetura (histórico) | [PARITY_BOLD.md](PARITY_BOLD.md) |

O protocolo de conversa com os pais (formato do pedido, os quatro vereditos, como o pai responde)
mora no DS pai: `ds-diletta/docs/PEDIDO-DO-FILHO.md` e `AVISO-DO-PAI.md`.

## Duas regras deste filho

1. **O app não se toca.** Aqui se constrói; a adoção no `app-newbold` é decisão de quem publica.
2. **Componente do filho nasce medido.** Uso contado no app antes de escrever a primeira linha — sete
   dos dez gradientes do DS antigo estavam mortos, e quatro dos componentes candidatos também.

## O que saiu daqui em 2026-07-30, e por quê

O repo tinha um TERCEIRO app na raiz: um catálogo Flutter web (`lib/main.dart`, 541 arquivos) que
carregava a própria cópia do design system em `lib/design_system`. Ele foi apagado, com o fork dentro.

**A medição que sustentou a decisão:**

- **o fork havia divergido**: 72 arquivos `.dart` contra 77 no `app-newbold`, assets e ícones
  diferentes nos dois sentidos. Não era espelho do app, era garfo parado desde 22/07 — e o README
  anterior o anunciava como "fonte de medição", que é o pior tipo de doc errado;
- **nada dos dois filhos dependia dele.** Nenhum `import` de `packages/` apontava pra `lib/`, e o
  `pubspec` da raiz não conhecia os pacotes;
- **os dois gates passaram sem tocar em uma linha** depois da remoção: DS 96, catálogo 17.

**O que a remoção CUSTOU, dito claro:** o `vercel.json` da raiz construía aquele app, então o deploy
Vercel deste repo (projeto `conta-bold-ds`) deixa de ter o que construir. Ele saiu junto, porque config
apontando pra app apagado é pior que config ausente.

E o motivo de o catálogo VIVO não poder assumir o lugar hoje é específico: ele depende dos dois pais por
`git:` sobre **SSH do Bitbucket**, e o build da Vercel não tem essa chave. Publicar o catálogo-filho pede
uma chave de deploy ou o caminho já planejado, que é **Cloudflare**.

O que o deploy publicava era o catálogo antigo desenhando o fork — um catálogo que mostrava um DS que não
é mais o DS. Deploy parado é menos errado que deploy mentindo.

**O destino ficou decidido: Cloudflare.** Worker de assets + Access, build local pelo
[`build_web.sh`](build_web.sh). O passo a passo, e a razão de o build NÃO rodar no CI, estão em
[DEPLOY_CLOUDFLARE.md](DEPLOY_CLOUDFLARE.md).
