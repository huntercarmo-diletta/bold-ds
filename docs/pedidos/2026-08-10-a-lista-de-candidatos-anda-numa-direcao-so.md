# Pedido · a lista de candidatos anda numa direção só — e o rosa desta marca mora no meio dela

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.34.0 · pai v0.66.0
- **data**: 2026-08-10

## O que eu fiz, que foi o que você mandou

> *"`ref: v0.66.0` e rode de novo. As três devem sumir sem você tocar num hex. Se sobrar alguma, ela
> vem com o número da sua rampa e aí a conversa é sobre a lista de candidatos, não sobre a regra."*

Rodei. **Duas sumiram, uma ficou e uma entrou** — e a conversa é exatamente sobre a lista.

| violação | antes (v0.64.0) | agora (v0.66.0) |
|---|---|---|
| `warning`/trilho (light) | 2,85 ✗ | **saiu** — a derivação achou o degrau (4,11) |
| `trilho`/bg (dark) | 1,08 ✗ | **saiu** — o trilho escuro se separou da página |
| `normal`/trilho (light) | 2,93 ✗ | **1,32 ✗** |
| `error`/trilho (light) | 3,11 ✓ | **1,41 ✗** |

**A regra funcionou nos dois casos em que a direção da busca ajudava. Nos outros dois ela piorou** — e
o `error` passava antes.

## A causa: a curva não é monotônica, e a lista assume que é

A busca do trilho no claro percorre `[neutral09, neutral08, neutral07, neutral06, neutral05]` — do
**claro pro médio**. A minha marca é rosa (`primary04` = `#FE3976`), e rosa tem **luminância média**.
Então descer o trilho o aproxima da tinta antes de afastar:

| candidato | vs página | `primary` | `error` |
|---|---|---|---|
| `neutral09` `#ECECEC` | 1,18 | 2,93 | 3,11 |
| `neutral08` `#D9D9D9` | 1,41 | 2,45 | 2,61 |
| `neutral07` `#C6C6C6` | 1,71 | 2,03 | 2,15 |
| `neutral06` `#ADADAD` | 2,24 | 1,54 | 1,64 |
| `neutral05` `#8C8C8C` | 3,36 | **1,03** | **1,09** |

**O contraste com a tinta DESCE a lista inteira.** A derivação escolheu `#A0A0A0` (entre o 06 e o 05),
que é o pior lugar possível: 1,32 e 1,41. Ela otimizou a restrição que a lista sabia percorrer — a
separação da página — e caminhou para dentro da tinta.

E do outro lado da curva ele volta a fechar:

| candidato fora da lista | vs página | `primary` | `error` |
|---|---|---|---|
| `neutral03` `#5C5C5C` | 6,69 | 1,93 | 1,82 |
| `neutral02` `#525252` | 7,81 | 2,26 | 2,12 |
| **`neutral01`** `#3D3939` | **11,40** | **3,29** | **3,10** |

**Só o `neutral01` fecha, e ele está depois do fim da lista.**

## Onde eu ACHO que mora

Duas saídas, e eu prefiro a segunda:

1. **estender a lista** até o extremo escuro: `[…, neutral04, neutral03, neutral02, neutral01]`.
   Resolve o meu caso e não muda o seu (a sua já fecha antes);
2. **ordenar os candidatos por distância de luminância das tintas**, em vez de percorrer a rampa na
   ordem dela. A regra passa a dizer o que quer — *o neutro mais LONGE das tintas que ainda se separa
   da página* — em vez de esperar que a rampa esteja ordenada a favor.

A segunda é a mesma lição das duas anteriores: **a ordem da rampa é da paleta; a intenção é da
linguagem.** Percorrer a rampa na ordem dela é a última coisa que ainda depende de como o filho
declarou os degraus.

## O que eu NÃO estou pedindo

1. **voltar ao degrau fixo.** A derivação está certa — e ela já provou nos outros dois papéis;
2. **mudar a minha rampa.** `#FE3976` é a marca, e ela não paga piso — a sua frase;
3. **um trilho declarável pelo filho.** Continua sendo o que você aceitou: contraste não é escolha de
   tela, e não deveria virar escolha de paleta.

## Uma coisa que fica registrada, e ela é boa

**O esqueleto fechou.** Era 1,41 no claro contra **2,51** no escuro; agora é **1,41 e 1,41**, sem eu
tocar num hex. O critério de sucesso que eu escrevi no pedido era *"o mesmo vulto nos dois temas"*, e
ele tem gate próprio aqui agora — medindo o **peso**, não a cor, porque cor muda com a rampa e peso é
a intenção.

## Como o pai vai saber que funcionou

`violacoesDeConformidade(BoldPalette.bold)` volta **vazia** — e desta vez sem asterisco.
