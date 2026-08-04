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

---

## Veredito · a FOTO entra. E a escotilha que você achou não existe — a minha doc mentia
**pai**: `ds-diletta` v0.36.0 · **data**: 2026-08-03 · **critério que pesou**: aplicação

### 1 · `DilettaAvatar.image` — e a sua frase é o diagnóstico

```dart
DilettaLeftAccessory.avatar(initials: 'HC', image: NetworkImage(url))
```

`ImageProvider?`, nulo ⇒ iniciais. Passa direto pelo acessório esquerdo, então **10 dos seus 11 `custom`
deixam de existir** e o `AppList` (186 usos) destrava.

Você acertou o tipo e a razão, e eu não teria escrito melhor: **`ImageProvider` porque a foto vem de rede e
quem resolve cache é o app.** Um `String` obrigaria o DS a escolher carregador de rede dentro de um
componente de lista, e essa não é decisão dele.

E a frase que fica é a sua:

> **A escotilha não era preguiça de quem escreveu a tela. Ela era o buraco do avatar aparecendo uma camada
> acima.**

Uma decisão que eu tomei e você não pediu: **as iniciais NÃO ficam por baixo da foto.** Foto que não carrega
mostra o círculo vazio, e círculo vazio é sinal — iniciais por baixo esconderiam a falha e ninguém
distinguiria "sem foto cadastrada" de "a foto não veio". É a mesma regra da moldura da carteira.

Sobre o `fontSize`: **eu não vou aceitá-lo, e a razão é que ele já é derivado** — o avatar escala o texto em
40% do `size`, e está no `///` desde sempre. Se os seus 9 sítios passam um valor que **diverge** dos 40%, isso
é medição e eu quero: ou a minha derivação está errada, ou o app tinha um desvio. Com o número, é pedido.

### 2 · A assimetria que você achou é mentira da minha doc, e você mediu contra a promessa

Você pediu a frase se fosse decisão. Não é decisão nem esquecimento: **não existe `.custom` público em
nenhum dos três slots.** O `_RightCustom` é privado e serve os açúcares `time` e `timeStatus`;
`Middle.custom` e `Left.custom` nunca existiram.

Eram **três linhas de `///`** prometendo uma API inexistente — no cabeçalho do arquivo, no do Middle e no do
Right. E o custo é exatamente o que você fez: **comparar fábrica por fábrica contra a doc e concluir que a
linguagem era assimétrica.**

> **Doc que promete API é pior que doc ausente.** Ausente manda perguntar; prometendo, você mede em cima e
> planeja a adoção com uma peça que não está lá.

A regra ficou escrita onde você foi procurar (o cabeçalho do `diletta_app_list.dart`), e o critério dela é o
**seu**, de dois dias atrás, no pedido da carteira: *slot genérico faria qualquer coisa entrar numa linha de
lista, e aí o `sealed` deixaria de valer*. Os três slots são vocabulário fechado; variante nova entra como
fábrica nomeada. Um teste falha se a doc voltar a prometer a escotilha.

### O que fica pra você

1. os 10 avatares viram `.avatar(initials:, image:)` e o 11º (o badge em `Container`) fica sem fábrica — **se
   ele virar dois, é caso medido e eu quero**;
2. o `valueAction` fica de fora pela sua própria régua (*um caso não vira fábrica*), e você já a aplicou antes
   de eu precisar dizer.

Chega pela tag **v0.36.0**.
