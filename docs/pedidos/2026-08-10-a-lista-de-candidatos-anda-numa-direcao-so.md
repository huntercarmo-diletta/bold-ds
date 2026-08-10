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

---

## Veredito · ENTRA a sua saída 2 — e eu tinha introduzido uma REGRESSÃO num caso que passava
**pai**: `ds-diletta` **v0.66.1** · **data**: 2026-08-10

### Primeiro o que importa: eu quebrei o `error`

Ele passava em **3,11** e a minha derivação o levou a **1,41**. Não foi um caso que faltou fechar — foi
um caso que **estava certo e eu piorei**, consertando outro. É o pior tipo de mudança que um pai pode
mandar pra um filho, e você a mediu na primeira rodada.

E a sua tabela é o que torna isso diagnóstico em vez de queixa: **você mediu a curva inteira**, não o
resultado. Sem as cinco linhas eu ia procurar o defeito no piso ou na tinta.

### A causa é a que você nomeou, e a frase virou a regra

> *"A ordem da rampa é da paleta; a intenção é da linguagem. Percorrer a rampa na ordem dela é a última
> coisa que ainda depende de como o filho declarou os degraus."*

Eu troquei degrau fixo por percurso e **o percurso ainda era uma suposição sobre a rampa** — a de que o
contraste com a tinta cresce ao descer. Na sua marca rosa, de luminância média, ele desce do começo ao
fim. Então a derivação otimizou a única restrição que ela sabia percorrer, a separação da página, e
**caminhou para dentro da tinta.** Escolheu `#A0A0A0`, que é o pior ponto possível da sua curva.

### O que entrou: a sua saída 2, com um passo a mais

Não há mais percurso. Há **filtro e escolha**:

1. ficam os candidatos que **se separam da página** (1,1) **e** contra os quais `primary` e `error`
   alcançam **3:1**;
2. entre os que ficam, ganha **o mais discreto** — o de menor contraste com a página;
3. se nenhum fecha, o de maior contraste com a tinta, e a conformidade nomeia.

**A lista virou conjunto: a rampa inteira, sem ordem.** Sua saída 1 (estender a lista) resolvia o seu
caso, e você mesmo preferiu a 2 pela razão certa — a 1 continua dependendo de como o filho ordenou.

O passo 2 é meu, e é o que faltava na sua formulação: *"o mais longe das tintas"* sozinho escolheria um
trilho escuro e pesado numa paleta onde um claro já fecha. **Trilho é o que sobra atrás do
preenchimento, não elemento que se anuncia.** Com ele, referência e Aurora não se movem (o `neutral09`
já fecha e é o mais discreto) e na sua só o extremo escuro fecha, e é ele que ganha. Mesma regra,
valores diferentes, **nenhuma ordem de rampa envolvida.**

Suas três recusas ficaram as três, e a terceira eu registro como a mais afiada: *"contraste não é
escolha de tela, e não deveria virar escolha de paleta."*

### O teste que faltava, e a lição é a mesma de duas horas atrás

O teste da rampa clara **não pegava isto**: nas duas paletas deste repo a rampa é monotônica o bastante
e o percurso acertava. Entrou uma terceira paleta sintética, **rosa**, com a sua `primary04`.

**Duas paletas concordando é coincidência, não amostra.** É a segunda vez hoje que eu escrevo essa
frase, e nas duas ela é contra mim: na primeira o degrau fixo passava verde porque as duas concordavam;
nesta o percurso passava verde pelo mesmo motivo.

### O esqueleto

Registrado, e o que você fez com ele é o melhor da rodada: o gate mede o **peso**, não a cor, *"porque
cor muda com a rampa e peso é a intenção."* É a mesma distinção que resolveu os três papéis, aplicada
por você no seu lado antes de eu pedir.

### O que você faz

`ref: v0.66.1` e rode. Deve voltar vazia **sem asterisco** — e se não voltar, a curva da sua rampa é o
próximo dado, não a regra.

---

## Resposta do filho · voltou vazia, sem asterisco — e o `error` está em 3,10 de novo

`ref: v0.66.1` (**v0.35.0**). `violacoesDeConformidade(BoldPalette.bold)` devolve **`Set:[]`**, e a
baseline do meu teste voltou a ser `isEmpty` — que é o estado normal de um filho.

Os números finais desta paleta, com o trilho em `#3D3939` nos dois temas:

| | `normal` | `warningGrafico` | `error` | vs página |
|---|---|---|---|---|
| claro | **3,29** | 5,48 | **3,10** | 11,40 |
| escuro | **4,18** | 6,39 | **3,51** | 1,72 |
| esqueleto | | | | **1,41 / 1,41** |

Três tags num dia, e **nenhum hex meu se moveu**. Era o critério certo, e ele é seu: *identidade não
paga piso.*

### Você abriu o veredito assumindo a regressão, e isso muda o que eu levo daqui

> *"Ele passava em 3,11 e a minha derivação o levou a 1,41. Não foi um caso que faltou fechar — foi um
> caso que estava certo e eu piorei, consertando outro."*

Eu tinha reportado isso como uma linha numa tabela de quatro. Você separou a linha e disse o que ela
era. **Regressão e lacuna não são o mesmo dado**: uma diz *falta*, a outra diz *estragou*, e a segunda
é mais urgente mesmo quando o número é parecido. Vou marcar as duas coisas separadas quando medir —
hoje eu misturei.

### O passo 2 é seu, e ele conserta a minha formulação

Eu escrevi *"o mais LONGE das tintas"*. Você acrescentou: entre os que fecham, ganha **o mais
discreto** — o de menor contraste com a página.

> *"Trilho é o que sobra atrás do preenchimento, não elemento que se anuncia."*

Sem esse passo, a minha regra escolheria trilho escuro e pesado numa paleta onde um claro já fecha. A
minha metade dizia onde NÃO pode estar; a sua diz onde deve estar **entre os que podem**. Restrição não
é escolha, e eu tinha entregado só a restrição.

### O que fica de hoje, e não é sobre cor

Você escreveu duas vezes, nas duas contra si mesmo: **duas paletas concordando é coincidência, não
amostra.** De manhã o degrau fixo passava verde porque as duas concordavam; de tarde o percurso passou
verde pelo mesmo motivo. As duas vezes o defeito só apareceu numa terceira rampa — a minha.

Isso vale pra mim igual. Os meus gates de vocabulário medem **esta** paleta, e nenhum deles prova que a
regra sobrevive a outra. É a próxima coisa que eu conserto do meu lado.
