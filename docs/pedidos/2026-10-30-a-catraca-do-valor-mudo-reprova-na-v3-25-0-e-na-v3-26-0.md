# PEDIDO · A catraca do valor mudo reprova na v3.25.0 e na v3.26.0 — o cartão de KPI respondeu o eixo, e não os valores

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai); medido nas tags `v3.24.3`, `v3.25.0` e `v3.26.0`
- **bloqueante?**: não. É um gate do pai, e o filho B não roda essa catraca. O custo está em «Se você disser não»

## Falta

O `tool/o_valor_mudo_so_diminui.py` sai com 1 nas duas últimas releases. A ferramenta está na cadeia do gate do `CLAUDE.md` (linha 84 na `v3.26.0`).

## Número

Como reproduzir, numa cópia limpa de cada tag:

```bash
python3 tool/o_valor_mudo_so_diminui.py
```

| tag | valores de eixo | mudos | saída |
|---|--:|--:|---|
| `v3.24.3` | 334 | 44 | ✓ o mudo não subiu |
| `v3.25.0` | 337 | 47 | ✗ o mudo SUBIU: 47 > 44 |
| `v3.26.0` | 338 | 47 | ✗ o mudo SUBIU: 47 > 44 |

Os três a mais são `design-system-kpi-card: tendencia.alta`, `tendencia.baixa` e `tendencia.neutra`. Eles nasceram com o cartão de KPI no `94130c09`, colhido do flash em 20/10. Da `v3.25.0` para a `v3.26.0` a lista não muda. O valor novo da `v3.26.0` nasceu respondido: são 338 valores, 291 deles respondidos.

## Já tentei

Nada do nosso lado, porque filho não conserta o pai. Para achar os três, listei os mudos inteiros pelo `mede()` da própria ferramenta, nas três tags, e comparei as listas. A saída dela não mostra os três: ela imprime só os 10 primeiros (`mudos[:10]`), e na ordem dos arquivos os 10 primeiros são do `amount-field`, do `breadcrumb`, do `glass-surface` e do `journey-step`, que já eram mudos antes.

## Conferi no pai

- A spec do cartão tem `### Escolha`, e nela está a frase do eixo: *«`tendencia` diz o sentido do número para o negócio, não o sinal: custo que sobe é `baixa`.»* A linha cita o eixo, e não os valores.
- A ferramenta lê só a forma `- ``Eixo.valor`` — frase.`, e diz por quê: é contrato com o `tool/gera_specs_dart.py`, que monta o `kDilettaEscolhas`. A spec do toast tem essa forma, por exemplo `` - `State.normal` — o aviso que só informa, e some sozinho. ``

## Derivável?

Em parte. O sentido de cada valor já está na frase do eixo. O que falta é ela escrita valor por valor.

## Se você disser não

Para nós nada muda. O custo é do pai: enquanto a catraca está vermelha, ela não segura o próximo valor mudo. Um quarto valor sem escolha passa pelo mesmo vermelho, e ninguém vê.

## Não estou pedindo

1. subir o teto para 47: a ferramenta diz que o teto só desce;
2. escolher as frases de `alta`, `baixa` e `neutra`: a escolha é do pai, ou do flash, de onde o cartão veio;
3. mudar a forma que a ferramenta lê: ela tem razão escrita.

## Como o pai vai saber que funcionou

O `python3 tool/o_valor_mudo_so_diminui.py` sai com 0 na próxima tag. Se o lote responder mais do que os três, o teto desce junto, como a própria ferramenta cobra.

## Como cheguei aqui

Achado de passagem na revisão da PR #11 do bold-ds (o seletor), em 29/10, contra a `7f988b4`. A proposta do André também registra o «47 > 44» no fim. Refeito em 30/10, tag por tag.
