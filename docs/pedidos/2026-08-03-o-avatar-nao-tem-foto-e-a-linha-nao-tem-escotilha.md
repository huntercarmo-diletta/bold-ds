# Pedido · o avatar não tem FOTO, e a linha da lista não tem escotilha

- **filho**: conta-bold-ds v0.11.0
- **pai**: ds-diletta v0.35.1 (`DilettaAvatar`, `DilettaLeftAccessory`, `DilettaRightAccessory`)
- **é bloqueante?**: **para a adoção, sim** — e é o maior bloqueio que sobrou: o `AppList` é **186 usos**
  no app, e o que segura os 186 são **duas peças** que somam 12 chamadas

## O que falta, medido

Comparei as três famílias de acessório da linha, fábrica por fábrica:

| família | app | pai | diferença |
|---|---|---|---|
| **Middle** | 10 fábricas | 10 fábricas | **idênticas** |
| **Right** | `action` `amount` `amountChip` `checkbox` `custom` `icon` `radio` `status` `time` `timeStatus` `toggle` **`valueAction`** | as mesmas + `iconAccessory` | falta `valueAction` (1 uso) |
| **Left** | `avatar` `iconAccessory` `spotIcon` **`custom`** | as mesmas + `progressRing` + `systemWallet` | falta `custom` (**11 usos**) |

**A adoção do componente mais usado do app depende de duas fábricas, e uma delas é uma escotilha.**

## O que entra pela escotilha, e é aí que está o pedido de verdade

Os 11 usos de `LeftAccessory.custom`, medidos um a um:

| o que vai dentro | usos |
|---|---|
| `BoldGlassAvatar` | **8** |
| `BoldAvatar` | 2 |
| `Container` (um badge) | 1 |

**Dez dos onze são avatar.** E eles usam a escotilha por uma razão só: **o `DilettaAvatar` não aceita
FOTO.** Ele tem `initials`, `variant`, `size` e `borderColor`; o do app tem `image` (`ImageProvider?`) e
`fontSize`. Medido: **9 dos 12 usos de avatar no app passam `image` ou `fontSize`**.

Ou seja: a escotilha não é preguiça de quem escreveu a tela. Ela é o buraco do avatar aparecendo uma
camada acima.

## O que eu peço

**1 · `DilettaAvatar` aceita imagem.** `ImageProvider?` (não caminho de asset — a foto do usuário vem de
rede, e o app já resolve o cache). Nulo ⇒ iniciais, que é o comportamento de hoje. Com isso, 10 dos 11
`custom` deixam de existir, e o `LeftAccessory.avatar` passa a cobrir o caso.

**2 · Se a escotilha for legítima na linguagem, ela precisa existir dos DOIS lados.** O `Right` tem
`custom` e o `Left` não — e nada na doc diz que é decisão. Se for, quero a frase; se for esquecimento, é
uma fábrica de três linhas, igual à do outro lado.

O item 1 sozinho resolve o meu caso. O 2 é sobre a linguagem ter simetria onde ela não declarou
assimetria — e é o tipo de coisa que o próximo filho descobre do mesmo jeito que eu: batendo.

**Não peço o `valueAction`** (1 uso): eu meço de novo quando tiver dois. Um caso não vira fábrica, e essa
régua é sua.

## Por que eu não resolvo sozinho

Avatar com foto no filho seria a **quarta** cópia de componente do pai que a adoção matou hoje
(`BoldSkeleton`, `BoldIconButton`, `BoldCheckbox`, o card de lista). E a escotilha eu não tenho como
declarar: `DilettaLeftAccessory` é `sealed` — o `sealed` é o que faz a lista de acessórios ser fechada e
legível, e eu concordo com ele. É justamente por ser fechada que a falta de uma fábrica vira bloqueio de
adoção em vez de contorno local.

## O que eu já fiz do meu lado

- as três famílias estão medidas fábrica a fábrica (a tabela acima), então a adoção do `AppList` está
  pronta pra rodar **no dia em que o avatar aceitar foto** — o resto casa 1:1;
- a classificação inteira da fase B2 está no `tasks.md` do change no app, com o motivo de cada bloqueio.
