# PEDIDO · O nó de passo não tem o estado «falhou» — e o console pinta a recusa com um cadeado

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` · `web-v3.24.0`, na `main` deste repo (tags até `web-v0.128.0`); o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`), e as duas cópias dizem o mesmo no que este pedido mede
- **bloqueante?**: não. O console usa `bloqueado` para o passo que falhou e diz isso na descrição da PR; o que fica errado é o glifo — um cadeado onde a pessoa lê «recusado»
- **irmão**: `2026-10-16-o-degrau-web-da-esteira-nao-abre-e-nao-diz-qual-e-o-passo-atual.md` — o item 2 dele (o passo ATUAL) é a outra metade deste número, e foi **reaberto hoje com o adendo** que o veredito pediu: a tela existe no código do console

## Falta

Um quarto valor no eixo `Estado` do `<diletta-web-stepper-node>`: **`falhou`** — o caminho parou ali por
uma decisão contra (o provedor recusou; o banco não aprovou), não por uma trava. Glifo derivado do
estado, como a regra da peça manda: o `xmark-light`, que já está no vocabulário web (`biblioteca-sistema.js`),
na tinta de erro (`error`/`errorOnSurface`), com o `motivo` na mesma tinta.

## Número

**No avô (`web-v3.24.0`):** `ESTADO = ['concluido', 'bloqueado', 'pendente']`; `TINTA = { concluido:
primary, bloqueado: warning, pendente: textMuted }`; glifos `check-light`, `lock-light`, `asterisk-light`
(este «provisório, aberto no ledger»). O glifo é derivado do estado e não passado por quem chama — e a
regra é boa: por isso o estado tem de existir na peça.

**No console (`core-flow-wa`, change `pedidos-de-limite`, PR 7 de 27/10):** o andamento do pedido de
aumento de limite é montado dos fatos do servidor (`model/pedidos.ts`, `andamentoDoPedido`) e desenhado
com a peça (`design-system/molecules/WaPasso.tsx`, o embrulho). Cinco andamentos; em três deles o último
degrau é uma falha, hoje escrita como `bloqueado`:

| andamento | último degrau | estado pedido | o que a pessoa lê |
|---|---|---|---|
| aguardando o provedor | «O novo teto vale» | `pendente` | certo |
| aplicado | «O novo teto vale» | `concluido` | certo |
| **recusado pelo provedor** | «Recusado pelo provedor · 20/10, 20h00 · sem motivo informado» | `bloqueado` | um cadeado, em âmbar |
| **não aprovado pelo banco** | «Não aprovado por Ana Lima» | `bloqueado` | um cadeado |
| **não aprovado no prazo** | «Não aprovado no prazo» | `bloqueado` | um cadeado |

Ao todo, 16 degraus pedidos à peça na tela: 11 `concluido`, 5 `pendente`, 2 `bloqueado` no código mais
os dois dos dados — e nenhum dos `bloqueado` é uma trava.

**No desenho (Web-Admin, página `282:2099`, B23 «Recusado pelo provedor»):** a peça local «Limites /
Passo» tem quatro variantes — feito, atual, depois, **recusado** — e a recusada desenha o ✕ na tinta de
erro. A peça do Figma que teria esses estados é a da «Rev 01 - DPS Design System», que não pode ser
usada (o irmão de 16/10 já disse).

## Já tentei

- **`bloqueado` com `motivo`**: é o que está no ar. A tinta `warning` e o motivo servem; o glifo mente.
  «Bloqueado» é «não dá para seguir por enquanto»; «recusado» é «não vai seguir».
- **`pendente` para a falha**: pior — o asterisco diz «falta», e não falta nada.
- **Um medalhão à mão fora da peça**: é desfazer a adoção para um estado só.

## Conferi no pai

- A spec `design-system-web-stepper-node`: eixo `Estado` com três valores, `destino: web`, «cada degrau
  carrega motivo e ação». O `motivo` já existe e serve ao «sem motivo informado pelo provedor».
- O vocabulário web tem `xmark-light` e `triangle-exclamation-light`: não é pedido de glifo.
- O `DilettaJourneyStep` (Dart) tem `done/next/locked` e também não tem a falha.

## Derivável?

Não: o glifo é derivado do estado dentro da peça, e é assim que deve ser. O filho não tem onde dizer «✕».

## Se você disser não

O console segue com `bloqueado` e a frase na descrição; a recusa do provedor continua com cadeado.

## Não estou pedindo

Passar o glifo por quem chama. Trocar as tintas dos três estados de hoje. O passo atual (é o item 2 do
irmão de 16/10, reaberto com adendo). O degrau aberto com conteúdo (o item 1 do irmão): o slot `acao`
serviu ao que o console precisava — o resumo do registro e os botões dos documentos moram nele.

## O que não medi

Contraste do `xmark-light` em `error` sobre o fundo nos dois temas: é o seu gate.

## Como o pai vai saber que funcionou

`<diletta-web-stepper-node estado="falhou" titulo="Recusado pelo provedor" descricao="20/10, 20h00" motivo="sem motivo informado pelo provedor" ultimo>`
desenha o medalhão com o ✕ na tinta de erro, o título, a descrição e o motivo; `estado` fora dos quatro
valores continua caindo em `pendente`. A spec ganha o quarto valor no eixo.

## Como cheguei aqui

A tela de Limites › Pedidos do console (PR 7 da change `pedidos-de-limite`, 27/10): ao montar o
andamento da B23 com a peça, escolhi `bloqueado` por ser o mais próximo e escrevi o desvio na descrição
da PR. Este pedido é o desvio virando pedido.
