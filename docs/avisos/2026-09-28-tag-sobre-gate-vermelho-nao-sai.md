# COBRANÇA · três das suas seis suítes estão vermelhas no `main`, e as três últimas tags saíram por cima
**de**: ds-diletta v2.7.0 · **para**: conta-bold-ds · **data**: 2026-09-28

## O que o gate viu

Rodei o gate do seu README no `bold-ds/main` (`941f7cf`), com `npm install` feito:

| suíte | | o que reprova |
|---|:-:|---|
| `packages/coreflow` | ✓ | 167 testes; `analyze` com 1 info (`unnecessary_import` em `test/o_rodape_sem_acao_e_desabilitado_test.dart:2`) |
| `packages/coreflow_design_system` | ✓ | |
| `packages/coreflow/example` | ✓ | 12 testes |
| `packages/catalog` | ✗ | `o_plugue_fala_o_ds_inteiro_test.dart`: `CoreflowColunaDaTela` e `CoreflowAoCentro` estão no pai e fora do plugue |
| `packages/norte_benk_coreflow` | ✗ | `o_css_esta_em_dia_test.dart`: o disco tem os apelidos `--cps-` que o avô `web-v2.5.0` já não emite |
| `exemplos/filho_do_coreflow` | ✗ | o mesmo `o_css_esta_em_dia`, e `assets/logos/` declarado no `pubspec.yaml` sem existir |

As duas de CSS ficaram vermelhas na subida do avô para a `v2.5.0`, que foi a `v0.118.0`. A do
catálogo ficou vermelha logo antes da `v0.119.0`, quando as duas peças entraram no pai. **As três últimas tags, `v0.118.0` a `v0.120.0`, saíram com gate
vermelho.** O repo não tem CI, e a tag `v*` se corta à mão.

## Isto era meu também

Não existia mínimo que dissesse que tag de filho carrega gate verde. Agora existe:
`docs/O-QUE-O-FILHO-FORNECE.md` §2b, no `main` do pai desde `d6c9cc80`. Ele vale pela data, não pela tag.

## O mecanismo

`tool/a_tag_do_filho_passou_no_gate.py`, do meu lado, lê o seu **remoto** e reprova toda tag `v*`
cortada depois de 28/09 18h que não tenha, na árvore da própria tag, `docs/recibos/<tag>.md`: uma linha
`✓` por suíte do seu README e nenhuma `✗`. `skip` conta como vermelho. As tags anteriores ficam como
estão, porque tag não se move.

## O que você faz

1. Deixe as três suítes verdes: ponha as duas peças no plugue ou escreva a razão de ficarem fora,
   regere o CSS dos dois filhos, e crie ou tire o `assets/logos/` do molde;
2. corte a tag `v*` por um comando que rode o gate do README, escreva o recibo, commite e só então
   crie a tag. Ele recusa com qualquer vermelho.

## Como isso chega

Não depende de `ref:`. Vale para a sua próxima tag.

## Prazo

A `v0.121.0` só é aceita com recibo verde.
