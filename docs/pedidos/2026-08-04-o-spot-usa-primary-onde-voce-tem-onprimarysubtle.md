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

---

## Veredito · ENTRA a troca de uma linha, e o GATE que você propôs achou CINCO casos além do seu
**pai**: `ds-diletta` v0.44.0 · **data**: 2026-08-04 · **critério que pesou**: aplicação (acessibilidade não
é ressalva)

Defeito meu, medido, e a linha é a que você escreveu:

```dart
DilettaSpotState.primary => _SpotSpec(bg: s.primarySubtle, iconColor: s.onPrimarySubtle),
```

O papel existia **porque você pediu**, na v0.1.6. Você pediu o par legível pra aquele fundo, eu entreguei, e o
componente que mais usa o fundo continuou pegando o acento. Isso não é ironia: é a forma da classe que você
nomeou, e ela merece o nome que você deu —

> **Papel que existe e componente que não usa.**

Irmã da que eu nomeei de manhã (papel na prosa, rampa no código), e **pior de medir**: nenhuma varredura por
`palette.` pega, porque os dois lados são papel legítimo. Só não o papel *daquele fundo*.

### O gate entrou, e o seu palpite estava certo sobre o alcance

Você escreveu: *"se você fizer esse gate, ele vale pra todo filho e pega o meu caso e os outros oito de uma
vez"*. Ele pegou **cinco além do seu**, e todos no `fill`:

| caso | o que desenhava | agora |
|---|---|---|
| `fill · primary` | `palette.white` | `onPrimary` |
| `fill · error` | `palette.error07` | `onError` |
| `fill · warning` | `palette.white` — **reprovava no escuro** | `onWarning` |
| `fill · success` | `palette.white` — **reprovava no escuro** | `onSuccess` |
| `fill · secure` | `palette.white` — **reprovava no escuro** | `onSecure` |

Os três do escuro caíam pela mesma razão: lá as cores semânticas **clareiam**, e branco sobre âmbar claro não
alcança 3:1. Mediu 9 estados × 2 tipos × 2 modos, do RENDER e não do resolvedor — 28 pares, e o tint
translúcido do escuro compõe com a superfície antes da conta.

### E um andar abaixo do seu pedido: o PAPEL estava errado

`onSecure` sobre `secure` dava **2,73:1 no escuro** — defeito da derivação do papel, não do componente. Virou
`neutral01` (**7,03**), que é o mesmo valor que o modo claro já usava, e a razão é da família: **secure é a
única que não inverte** — ela é clara nos dois modos, então a tinta dela é o neutro escuro nos dois.

Você não pediu isso e não tinha como: **um filho não vê o papel do pai reprovando o próprio fundo.** Só o gate
vê, e o gate é seu.

### O que ficou de fora, e é a única exceção que a norma dá

`disabled` sai do gate: a WCAG 1.4.11 isenta componente de interface **inativo**, e não é conveniência —
repintar o inerte pra alcançar 3:1 faria ele parecer ativo, trocando um defeito de acessibilidade por um de
aplicação. Medido, pra ficar no registro: 2,57 no claro, 5,59 no escuro.

### A sua observação sobre a derivação do `primarySubtle`, que eu NÃO fecho hoje

Você registrou como observação e não como pedido — *"o `///` diz 'o tinte, quase branco' e no escuro ele é um
vinho médio"* — e a distinção está certa: a frase descreve o claro e vale como contrato pros dois. **Fica
aberta no meu ledger**, porque mexer na derivação move todo consumidor de `primarySubtle` e o seu caso fechou
sem isso. Quando ela for medida, é o `///` que sai errado ou a derivação; hoje eu não sei qual.

### O que eu registro do seu lado

**Defeito que esconde defeito, e o de cima era seu**: enquanto o glifo não desenhava (apelido do app entregue
aos meus widgets, 21 sítios), ninguém podia ver que ele era ilegível. Consertar o fantasma foi o que revelou o
contraste — e é o argumento mais forte que existe contra deixar um "não desenha nada" na fila.

**Como chega**: v0.44.0 (sync com `sincroniza_pai_ds.py --tag v0.44.0`).
