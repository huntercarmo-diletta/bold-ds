# PEDIDO · Nenhum par de erro monta um botão destrutivo que passe em AA no escuro

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — usamos a melhor combinação disponível. Mas «a melhor
  disponível» reprova, e por um centésimo.

> **Nota de procedência.** Achado no **core-flow-wa** numa varredura de contraste de
> todo par texto-sobre-fundo do produto, nos dois temas. Foi a última coisa que sobrou.

## O caso

Um botão destrutivo sólido — «Revogar acesso», «Recusar» — precisa de tinta sobre
preenchimento a 4,5:1. No tema escuro, **nenhuma combinação dos papéis de erro chega
lá**.

## A matriz inteira, medida

Tema escuro. `error` `#ff4d5e` · `errorOnSurface` `#ff4d5e` · `errorSolid` `#b42318` ·
`onError` `#530e16` · `onErrorSolid` `#f7a9b1`.

| preenchimento | tinta | razão | |
|---|---|--:|:-:|
| `errorOnSurface` | `onError` | **4,49:1** | ❌ *(a melhor)* |
| `error` | `onError` | **4,49:1** | ❌ |
| `errorSolid` | `onErrorSolid` | 3,53:1 | ❌ |
| `errorSolid` | `onError` | 2,21:1 | ❌ |
| `errorOnSurface` | `onErrorSolid` | 1,74:1 | ❌ |
| `error` | `onErrorSolid` | 1,74:1 | ❌ |

No claro não há problema: `errorSolid` + `onError` dá **8,98:1**, e a nossa combinação
atual dá 6,57:1.

## O que isso tem de incômodo

**Falta um centésimo.** 4,49 contra 4,50. Não é um tom mal escolhido — é a paleta escura
inteira sem uma saída, e a melhor delas parando na casa decimal.

E a coincidência com a história desta casa é exata: o defeito que o `1c04ec2` do webadmin
corrigiu media **4,49:1 contra 4,50**, e o comentário de lá diz que «o defeito histórico
passou ainda mais raspando do que a mensagem sugere». O mesmo número, três meses depois,
por outro caminho.

## Para comparação, o primário está folgado

`primary` + `onPrimary` dá 8,03:1 no claro e 7,70:1 no escuro. A ação destrutiva é a que
mais precisa ser lida sem hesitação, e é a que tem a menor folga da paleta — zero.

## O pedido

Um par de erro sólido que passe AA no escuro. As saídas que enxergamos, sem preferência:

- **escurecer `onError` no escuro.** Ele vale `#530e16`; um tom mais escuro sobre o mesmo
  `#ff4d5e` resolve sem tocar no preenchimento, que é o que dá a identidade;
- **clarear `errorSolid`** e usá-lo como preenchimento do botão no escuro, com `onError`
  por cima;
- **publicar um par nomeado** para esta situação — `errorSolidHover` e
  `errorSolidPressed` já existem, e o que falta é o de repouso com tinta que o acompanhe.

## Uma observação sobre como isto apareceu

O par estava lá desde a adoção, e nenhum teste o viu: os nossos conferem comportamento, e
o único que mede contraste olhava uma lista DECLARADA de pares — e este não estava nela.
Só apareceu quando a varredura passou a extrair todo par `color` + `background` das 75
folhas e medir nos dois temas, em vez de conferir uma lista.

A varredura tem trinta linhas, e a ofereço: se ela rodar no IB, provavelmente acha mais.
