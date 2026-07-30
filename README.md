# conta-bold-ds — o DS e o catálogo do Conta BOLD

Este repo é **filho de dois pais**: a linguagem (`ds-diletta`) e a ferramenta (`catalogo-diletta`).
Nenhum dos dois sabe que o Bold existe — quem declara identidade, componente próprio e vocabulário
de bloco é aqui.

| pacote | o que é |
|---|---|
| `packages/conta_bold_design_system` | **o DS-filho**: a paleta como instância, a fonte, os gradientes e os componentes que só o Bold tem |
| `packages/catalog` | **o catálogo-filho**: o plugue que declara os blocos, os grupos e o leitor de código |
| `lib/design_system` | **o DS ANTIGO do app**, que fica como fonte de medição do que ainda falta portar. Não é dependência de ninguém aqui |

## O gate

```bash
(cd packages/conta_bold_design_system && flutter analyze && flutter test)   # 68
(cd packages/catalog && flutter analyze && flutter test)                    # 16
```

A conformidade dos dois pais roda dentro desses testes (`violacoesDeConformidade` e
`violacoesDoFilho`), e as duas baselines estão **vazias**: dívida declarada aqui é dívida que alguém
vai esquecer.

## Como os pais chegam

Por **tag**, nunca por caminho local — `pubspec.yaml` de cada pacote fixa o `ref:`. Tag é imutável, e
é o que faz "funciona na minha máquina" não existir.

| pai | versão de hoje |
|---|---|
| `ds-diletta` | `v0.8.0` |
| `catalogo-diletta` | `v0.30.1` |

## Os documentos

| Preciso… | Leia |
|---|---|
| **adotar isto no app** (token primeiro, componente depois) e ver o que já nasceu | [packages/conta_bold_design_system/ADOCAO.md](packages/conta_bold_design_system/ADOCAO.md) |
| o que eu já pedi aos pais, e o veredito de cada um | [docs/PEDIDOS.md](docs/PEDIDOS.md) |
| o que os pais me mandaram | [docs/avisos/](docs/avisos/) |
| a auditoria que precedeu esta arquitetura (histórico) | [PARITY_BOLD.md](PARITY_BOLD.md) |

O protocolo de conversa com os pais (formato do pedido, os quatro vereditos, como o pai responde)
mora no DS pai: `ds-diletta/docs/PEDIDO-DO-FILHO.md` e `AVISO-DO-PAI.md`.

## Duas regras deste filho

1. **O app não se toca.** Aqui se constrói; a adoção no `app-newbold` é decisão de quem publica.
2. **Componente do filho nasce medido.** Uso contado no app antes de escrever a primeira linha — sete
   dos dez gradientes do DS antigo estavam mortos, e quatro dos componentes candidatos também.
