# Pedido · o spot usa `primary` onde você já tem `onPrimarySubtle` — 2,94:1 no escuro

- **filho**: conta-bold-ds v0.21.0 · app-newbold `feat/adota-conta-bold-ds` (commit `93f27ea`)
- **pai**: ds-diletta v0.41.0 (`DilettaSpotIcon`, `_resolveSpot`)
- **é bloqueante?**: não bloqueia build. **Reprova conformidade**: o par que o componente desenha fica
  abaixo do piso de 3:1 pra objeto gráfico, no modo que este produto usa por default

## O que o dono do produto viu, e o número que fecha

> *"os spot icons estão sem contraste entre fundo e cor do icon"*

Ele estava olhando a lista de métodos de acesso (Passkey, Face ID) no escuro: círculo rosa-vinho com o
glifo rosa por dentro. Medi o par que o `_resolveSpot` escolhe pra `outline` + `primary`:

```dart
DilettaSpotState.primary => _SpotSpec(bg: s.primarySubtle, iconColor: s.primary),
```

| modo | fundo (`primarySubtle`) | o que ele desenha (`primary`) | **o papel que você já tem** (`onPrimarySubtle`) |
|---|---|---|---|
| **escuro** | `#9e1241` | `#f66fa0` → **2,94:1** ❌ | `#ffb6cb` → **4,89:1** ✅ |
| claro | `#ffedf3` | `#fe3976` → 3,08:1 (raspa) | `#9e1241` → **7,13:1** ✅ |

Piso de 3:1 é o de **objeto gráfico** (WCAG 1.4.11), que é o que um glifo dentro de um spot é. No escuro
reprova; no claro passa por 0,08.

## O que eu peço — e não é papel novo, é o papel que você tem

```diff
- DilettaSpotState.primary => _SpotSpec(bg: s.primarySubtle, iconColor: s.primary),
+ DilettaSpotState.primary => _SpotSpec(bg: s.primarySubtle, iconColor: s.onPrimarySubtle),
```

**`onPrimarySubtle` existe pra exatamente isto**, e o `///` dele diz: *"Conteúdo sobre
[primarySubtle]"*. Não é interpretação minha — e tem um detalhe que me faz insistir: **fui eu que pedi
esse papel**, na v0.1.6 (*"`onPrimarySubtle` vem do degrau 03"*). Eu pedi o par legível pra esse fundo,
você entregou, e o componente que mais usa esse fundo continuou pegando o acento.

Não peço nada sobre a derivação do `primarySubtle` no escuro (`p.primary03`), embora ela mereça uma
olhada sua: o `///` do papel diz *"o tinte ([primarySubtle], quase branco)"*, e no escuro ele é um vinho
médio — a frase descreve o claro e vale como contrato pros dois. Fica como observação, não como pedido:
mexer na derivação move mais coisa que o meu caso, e o meu caso fecha com a troca de uma linha.

## Por que eu não resolvo no call site

Poderia trocar `outline` por `fill` nas minhas telas — `fill` + `primary` dá fundo `primary` com glifo
branco, contraste de sobra. **Recusei, e a razão é vocabulário**: `fill` e `outline` são dois desenhos
diferentes na sua linguagem, e escolher o desenho errado pra consertar uma cor é dizer uma coisa pra
resolver outra. A tela quer o spot suave; ela só quer que o glifo dentro dele seja legível.

## A família do defeito é a que você nomeou hoje

Você escreveu de manhã, no veredito dos seletores:

> **Papel escrito no comentário e rampa no código é a forma mais barata de um defeito passar por
> revisão** — quem lê a linha de cima acredita na de baixo.

Aqui é a versão irmã: **papel que existe e componente que não usa.** O `_resolveSpot` não escreveu cor
crua — ele pegou um papel legítimo (`primary`), só não o papel *daquele fundo*. Nenhum gate pega isso: os
dois lados são papéis, e uma varredura por `palette.` passa limpa.

O sinal derivável, se você quiser um: **todo par (`bg`, `iconColor`) que o `_resolveSpot` devolve tem que
render 3:1 nos dois modos.** É uma tabela de nove estados × dois modos, e ela é medível sem olhar tela —
foi assim que eu achei este. Se você fizer esse gate, ele vale pra todo filho e pega o meu caso e os
outros oito de uma vez.

## O que eu já fiz do meu lado

Estes mesmos spots estavam desenhando **NADA** até hoje de manhã — apelido do meu app (`'key'`,
`'fingerprint'`) entregue direto aos seus widgets. Consertei 21 sítios e o gate novo mede a classe.
**Foi o conserto do fantasma que revelou o do contraste**: enquanto o glifo não desenhava, ninguém podia
ver que ele era ilegível. Defeito que esconde defeito, e o de cima era meu.
