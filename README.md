# conta-bold-ds — o DS e o catálogo do Conta BOLD

Este repo é **filho de dois pais**: a linguagem (`ds-diletta`) e a ferramenta (`catalogo-diletta`).
Nenhum dos dois sabe que o Bold existe — quem declara identidade, componente próprio e vocabulário
de bloco é aqui.

| pacote | o que é |
|---|---|
| `packages/conta_bold_design_system` | **o DS-filho**: a paleta como instância, a fonte, os gradientes e os componentes que só o Bold tem |
| `packages/catalog` | **o catálogo-filho**: o plugue que declara os blocos, os grupos e o leitor de código |
| `lib/design_system` | **um FORK antigo do DS do app**, não uma cópia dele. Não é dependência de ninguém aqui, e **não serve de fonte de medição** — veja abaixo |

## O gate

```bash
(cd packages/conta_bold_design_system && flutter analyze && flutter test)   # 87
(cd packages/catalog && flutter analyze && flutter test)                    # 17
```

A conformidade dos dois pais roda dentro desses testes (`violacoesDeConformidade` e
`violacoesDoFilho`), e as duas baselines estão **vazias**: dívida declarada aqui é dívida que alguém
vai esquecer.

## Como os pais chegam

Por **tag**, nunca por caminho local — `pubspec.yaml` de cada pacote fixa o `ref:`. Tag é imutável, e
é o que faz "funciona na minha máquina" não existir.

| pai | versão de hoje |
|---|---|
| `ds-diletta` | `v0.11.0` |
| `catalogo-diletta` | `v0.33.1` |

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

## O fork em `lib/design_system` — o que a limpa mediu

A linha da tabela acima dizia "o DS antigo do app, fonte de medição do que falta portar", e **isso era
falso**. `diff -rq` contra `app-newbold/lib/design_system`:

- **72 arquivos `.dart` aqui contra 77 lá**;
- assets divergem, inclusive a wordmark da marca e as ilustrações;
- os dois ícones do sparkle existem só lá; dois com sufixo `" 1"` existem só aqui.

É um **fork parado**, não um espelho. Toda medição deste repo — a classificação, as contagens de uso, os
achados de defeito — foi feita contra `app-newbold`, que é a fonte de verdade dos widgets. Medir contra
esta pasta daria número errado com cara de certo.

**A decisão de apagar é do dono do produto**, não minha: ela está no git e nada aqui depende dela, mas é
o tipo de remoção que muda a forma do repo. Enquanto ela estiver aqui, esta seção é o aviso.
