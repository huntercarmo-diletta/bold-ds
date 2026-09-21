# PEDIDO · Nenhum par de erro monta um botão destrutivo que passe em AA no escuro

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — e ver a RETRATAÇÃO abaixo.

---

# ⚠ RETRATADO no mesmo dia — o pedido estava errado

**O par existe, e passa com folga.** Medido no `<diletta-button type="primary"
state="error">` RENDERIZADO, nos dois temas:

| tema | fundo | tinta | razão | |
|---|---|---|--:|:-:|
| claro | `#b42318` | `#ffffff` | 6,57:1 | ✅ |
| escuro | `#f7a9b1` | `#000000` | **11,26:1** | ✅ |

São `--diletta-onErrorSubtle` e `--diletta-onPrimary`. **No escuro a linguagem
INVERTE o botão** — rosa-claro com tinta preta, em vez de vermelho escuro com tinta
clara —, e é essa inversão que resolve.

**O erro foi de método, e vale mais registrar isso que apagar o arquivo.** Montei uma
matriz com os tokens que PRESUMI serem o par de preenchimento e de tinta de um botão
destrutivo (`error*` × `onError*`), medi as seis combinações, não achei nenhuma que
passasse, e concluí que a paleta não tinha saída. A combinação que a peça usa não
estava na matriz, porque `onPrimary` não parecia tinta de botão de erro.

Uma matriz de combinações **não prova ausência** quando a matriz foi montada por
suposição. O que prova é medir a peça que existe — e ela existia.

Quem apontou foi a designer do consumidor, com uma pergunta de uma linha: «o botão
destrutivo já existe no DS e acredito que passe — foi contra esse que mediu, ou você
criou?».

O consumidor foi corrigido para o par do elemento. **Nada é pedido aqui.** O arquivo
fica pela lição de método, e porque o índice já o citava.

---

## O que o pedido dizia, e que agora se sabe errado

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
