# PEDIDO · O anel de foco do campo não se vê — `primaryTrack` reprova o piso de 3:1

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não para nós** — divergimos, com a razão escrita. Mas quem adotar o
  `<diletta-input>` como ele está entrega um campo cujo foco não se enxerga.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), alinhando o campo de
> seleção local ao `<diletta-input>`. A designer notou que os dois campos da mesma barra
> tinham anéis de cor diferente; ao medir para corrigir, o que apareceu foi isto.

## O caso

O `<diletta-input>` pinta o anel de foco em `primaryTrack`:

```js
.caixa:has(:focus-visible) { outline: 3px solid var(--diletta-primaryTrack); }
```

O `///` explica a escolha, e o argumento de DESENHO é bom:

> *«O ANEL DO CAMPO NAO E O ANEL DO BOTAO, e o Dart ja sabia disso: o `DilettaTappable`
> pinta foco em `primary` (saturado, medido contra `surface` nas oito marcas), mas o
> `DilettaInput` pinta o dele em `primaryTrack`»*

Anel saturado em volta de um campo de fato grita onde bastava indicar. O problema é que o
tom escolhido não indica nada.

## A medição

Piso: **WCAG 2.2 §1.4.11 — Non-text Contrast**, 3:1 para indicador de componente de
interface, medido contra as cores adjacentes.

| tema | anel | contra | razão | |
|---|---|---|--:|:-:|
| claro | `primaryTrack` `#ffb6cb` | `surface` `#ffffff` | **1,64:1** | ❌ |
| claro | `primaryTrack` `#ffb6cb` | `bg` `#f4f3f6` | **1,48:1** | ❌ |
| escuro | `primaryTrack` `#600627` | `surface` `#14151f` | **1,34:1** | ❌ |

Para comparação, o anel do BOTÃO passa nos dois modos — e a medição é do próprio
`DilettaFoco`, citada no `produto.css` do IB: `primary` dá **3,96:1** no claro e **4,42:1**
no escuro, contra 1,17 do `surfaceMuted` que a linguagem usava antes e que reprovava.

**A casa já rejeitou um tom por esse exato motivo, uma vez.** O `surfaceMuted` saiu do anel
porque media 1,17. O `primaryTrack` mede 1,64 — mesma família de defeito, com um número
pouco melhor.

## Por que importa mais num campo do que pareceria

Um anel de foco é a única coisa que diz, a quem navega por teclado, ONDE ele está. Num
formulário com vários campos, um anel invisível não é enfeite perdido: a pessoa deixa de
saber em qual campo vai digitar. É o caso em que o indicador é a informação inteira.

## O que fizemos aqui, e por que estamos contando

Divergimos: o webadmin usa **um anel só**, `primary` a 40%, para botão e campo — que é o
que o IB já fazia. A razão está escrita no `themes/light.css` de lá, com esta medição.

É divergência deliberada da linguagem, e queremos que ela apareça: **acessibilidade não
cede à régua de «a linguagem ganha sempre»**. Preferimos estar divergindo com o número na
mão a estar alinhados com um foco que ninguém vê.

## O pedido

Um tom de anel de campo que passe de 3:1 contra `surface` e `bg`, nos dois modos. O
argumento de desenho do `///` continua válido — o anel do campo pode ser mais discreto que
o do botão sem ser invisível; o que não dá é discrição que custa a indicação.

Se a casa preferir manter `primaryTrack` por coerência com o Dart, vale ao menos medir o
lado Flutter: se lá o anel também for esse tom, o defeito não é da instância web, é da
linguagem, e a correção rende nos dois lados.

---

## VEREDITO · ENTRA — e a sua divergência também não passa, que é a parte que eu devo te dizer
**pai**: ds-diletta **v0.203.0** · irmã **web-v0.203.0** · **data**: 2026-09-21

Você pediu para eu medir o lado Flutter se preferisse manter o tom. Medi, e a resposta é a que você
suspeitava: **o Dart pinta o mesmo tom** (`diletta_input.dart`, `_isError ? s.errorSubtle :
s.primaryTrack`). Não era a instância web divergindo — era a linguagem, nos dois lados.

E na paleta de REFERÊNCIA, que não é de ninguém, o número é pior que o seu:

| modo | anel | contra | razão | |
|---|---|---|--:|:-:|
| claro | `primaryTrack` `#a6e2d1` | `surface` `#ffffff` | **1,46:1** | ❌ |
| escuro | `primaryTrack` `#06382c` | `surface` `#20262a` | **1,17:1** | ❌ |
| claro | `errorSubtle` `#fbe4e2` | `surface` | **1,21:1** | ❌ |
| escuro | `errorSubtle` `#5e110d` | `surface` | **1,14:1** | ❌ |

E você achou o precedente sem saber o quanto ele era exato: **1,17** é o número do `surfaceMuted`
que esta casa tirou do anel do toggle. Mesmo número, outro campo, três semanas depois — está escrito
no `///` do `DilettaFoco`.

> **Conserto de caso não fecha classe.** Aquele conserto foi de uma peça, e nada mediu as outras.

### O que entrou

O anel segue a **família do estado** e o **degrau que se vê**:

- repouso → `primary` (**4,79:1** no pior dos quatro casos: dois modos × `surface`/`bg`);
- erro → `error` (**3,58:1**).

Nos DOIS lados, Dart e web, na mesma tag. O `///` de 15/09 que escolheu a família continua de pé: um
anel verde em volta de uma borda vermelha é sinal trocado, e isso não mudou. **O que mudou foi o
degrau dentro da família** — era a tinta fraca, virou a que passa.

O argumento de desenho do seu `///` citado (*«o anel do campo não é o anel do botão»*) morre como
argumento de TINTA e sobrevive como argumento de forma: o campo continua com `outline-offset: 1px`
contra os 2px do botão. Discrição que custa a indicação não é discrição, é ausência.

### O gate, e ele mede nas DUAS paletas

`o_anel_de_foco_se_ve_test.dart`, e ele tem três camadas:

1. **a decisão** — toda tinta que esta casa usa como anel, contra `surface` e `bg`, nos dois modos,
   em duas paletas: a de referência e uma nascida da porta de UMA COR, num rosa que é quase o oposto
   do verde da referência em matiz. Se o piso dependesse do tom da marca, é ali que ele cairia;
2. **a peça** — o campo focado é RENDERIZADO e o anel é lido do `BoxShadow` de verdade, porque uma
   lista declarada não prova que o widget a segue;
3. **os três tons já rejeitados** — `primaryTrack`, `errorSubtle` e `surfaceMuted` têm que
   CONTINUAR reprovando. Sem essa terceira, o gate ficaria verde no dia em que alguém trocasse a
   tinta por uma paleta clara o bastante, e ninguém saberia que a regra mudou.

Prova de mutação: voltar o widget para `primaryTrack` faz o gate acusar **1,46:1 no claro e 1,17:1 no
escuro** — os seus números, ditos pelo meu teste.

### E agora a parte que é sua: **o anel que vocês adotaram também reprova**

Você divergiu com o número na mão, e o número que você tinha era o do tom que você REJEITOU, não o do
que você adotou. Medi o seu, na sua paleta emitida:

| modo | o anel do webadmin | contra `surface` | razão | |
|---|---|---|--:|:-:|
| claro | `primary` @40% = `#ffb0c8` | `#ffffff` | **1,71:1** | ❌ |
| escuro | `primary` @40% = `#6e3953` | `#14151f` | **2,05:1** | ❌ |

**1,71 contra os 1,64 do `primaryTrack` que vocês tiraram.** A divergência custou trabalho e não
comprou acessibilidade — e ela foi feita exatamente pelo motivo certo, com a medição parando um passo
antes do fim.

O seu `primary` cheio passa: **3,46:1** no claro e **6,66:1** no escuro, na sua paleta. Tirem o alfa
e o anel de vocês passa a valer o que ele promete. E aí a divergência some sozinha, porque vira a
regra da linguagem.

> **Alfa é a armadilha desta classe**: ele muda o contraste e não muda o nome do token, então a
> medição feita no token continua verdadeira e passa a descrever outra cor.
