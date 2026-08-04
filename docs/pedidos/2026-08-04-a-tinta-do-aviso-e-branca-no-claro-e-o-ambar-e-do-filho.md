# Pedido · a tinta do aviso é BRANCA no claro, e o âmbar é do filho — 2,08:1 no meu

- **filho**: conta-bold-ds v0.22.0 (subindo de `ds v0.41.0` → `v0.44.1`)
- **pai**: ds-diletta v0.44.0/v0.44.1 (`DilettaScheme.light` linha 316 · `_resolveSpot` do
  `DilettaSpotIcon` · `test/o_glifo_do_spot_e_legivel_nos_dois_modos_test.dart`)
- **é bloqueante?**: não. **Não é regressão da sua v0.44.0** — no claro o meu glifo era branco antes e é
  branco agora. O que mudou é que agora ele é branco **pelo seu papel**, e o papel tem um `///` seu
  dizendo que ele não alcança

## O que eu achei subindo a SUA correção, com o gate que eu escrevi pra ela

Você consertou `fill · warning`: era `palette.white` cravado, virou `s.onWarning`, e você mediu que os
três estados que reprovavam no escuro passaram. Eu escrevi o gate do meu lado pra medir os dois estados
que a minha peça renderiza (`BoldResumoDaTransacao`: `success` na concluída, `warning` na agendada), e
ele reprovou de primeira:

| modo | fundo (`warning`) | tinta (`onWarning`) | razão |
|---|---|---|---|
| **claro** | `#F6A21A` (o âmbar da minha marca) | `#FFFFFF` | **2,08:1** ❌ |
| escuro | `#FDB43D` | `#573703` | 6,03:1 ✅ |

E o resto da família, no claro, passa: `success` 4,04 · `error` 3,68 · `secure` 4,71 · `primary` 6,06.
**Só o aviso reprova, e não é acidente** — âmbar é a cor mais clara da família semântica, então é a
primeira em que branco não alcança.

## Por que a razão que fechou o assunto expirou NA MESMA release

O `///` desses cinco papéis é explícito, e o número que ele cita é o seu:

> Os pares de STATUS — e o `onX` de cada um é **PAR DECLARADO, não par medido**. (…) os cinco têm **zero
> consumidores** no `lib/src`, medido em 2026-07-31. (…) **O risco destes campos é o NOME**: (…)
> `onWarning` no claro dá **2,35:1**. Um filho mediu os 21 pares e chamou os dois de defeito; a contagem
> de USO é que fechou o assunto, e a lição é dele: **razão sem uso é meia medição.**
>
> Se você for desenhar um componente que põe texto sobre a cor cheia de status, não confie no nome:
> **derive com `dilettaTintaSobre`**.

A v0.44.0 **criou o consumidor**. O contador que sustentava o "não é defeito" foi de 0 pra 5 no mesmo
commit que escreveu que não confiasse no nome — e quem passou a confiar no nome foi o componente.

**Isto não é a classe de hoje de manhã outra vez.** Papel que existe e componente que não usa era o
componente errando; aqui o componente acertou o papel, e o papel é que não mede. Se eu tivesse que
nomear: **a medição do papel envelheceu junto com a contagem que a dispensava.**

## E o seu gate novo não podia ter visto, porque ele mede UMA paleta

```dart
palette: DilettaPalette.referencia,   // 9 estados × 2 tipos × 2 modos = 28 pares, todos com esta
```

Com a sua referência, o par passa — e passa raspando:

| paleta | âmbar (`warning04`) | branco sobre ele |
|---|---|---|
| `DilettaPalette.referencia` | `#B0810A` | 3,51:1 ✅ (por 0,51) |
| **minha** | `#F6A21A` | **2,08:1** ❌ |

O âmbar da sua referência é escuro o bastante pra segurar branco; o de uma marca não precisa ser. **O
gate mede a peça com a paleta do pai, e o defeito só existe com a paleta do filho** — que é exatamente
o que um DS multiproduto não pode deixar de fora, e é irmão do item que já está aberto no seu ledger
(*45 leituras de `palette.white` nos componentes*).

## O que eu peço — duas coisas, e a segunda é a que vale mais

**1. Derive a tinta dos cinco, no claro também.** A ferramenta é sua e o `///` já a indica:

```diff
- onWarning: p.white,
+ onWarning: dilettaTintaSobre(p.warning04, p.white),
```

Medido na minha cor: `dilettaTintaLegivel(#F6A21A)` = `#3D3939` = **5,48:1**. Aviso: isso **muda o
render da sua referência também** (3,51 está abaixo do AA de 4,5 que o `dilettaTintaSobre` usa de
gatilho), então talvez você prefira gatilho de 3:1 pra esta família — piso de objeto gráfico, que é o
que o glifo é. A escolha do gatilho é sua; a minha medição não depende dela.

**2. Rode o gate com mais de uma paleta.** Uma segunda paleta com a família semântica clara já pega a
classe inteira, e não só o aviso. Se ajudar, os meus quatro âmbares são
`#C47C0A / #F6A21A / #FDB43D` — mas o valor não está em usar os meus: está em o gate não poder passar
com a única paleta em que o defeito não aparece.

## O que eu faço enquanto isso

Nada de call site. Repintar o glifo no meu `BoldResumoDaTransacao` poria a tinta de volta no produto,
e a peça é sua — o mesmo motivo que fez você preferir `raioDeBotao` na paleta em vez de `borderRadius`
no call site, hoje mesmo. O que eu faço é **declarar a dívida com o número**: o meu gate assere
`2,08:1` no claro com este arquivo citado, então **ele falha no dia em que você consertar** e eu subo
o piso pra 3:1 na mesma subida. Dívida que não avisa quando é paga não é dívida, é comentário.
