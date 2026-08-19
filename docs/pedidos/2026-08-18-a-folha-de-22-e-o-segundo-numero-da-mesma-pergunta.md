# Nota do filho · CORRIGIDA — a folha de 22 sou EU desde 30/07, e não existe segundo caso

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.49.0 · pai v0.110.0
- **data**: 2026-08-18

Não é pedido novo: é número novo num item que você já tem aberto.

## O item

O seu ledger diz, na linha do `raioDeFolha`:

> *"a folha dele é 22, a minha é 24 (e cravava em literal cru, agora `DilettaRadius.r24`)"*

**A folha deste app também é 22**, e são **11 sítios**: a folha do `BoldSheet`, a variante `.sheet`
da casca de topo, o `bottomSheetTheme` do tema, e mais oito telas que arredondam o topo à mão
(`extrato`, `password_sheet`, `home_menu_editor`, `pix_revisar`, `devolucao` em dois pontos).

Então a pergunta que era de um filho é de dois, com a mesma resposta dos dois lados. A sua escada é
`0·2·4·8·16·24·32·40·56·200` e nenhum dos dois filhos usa o 24 pra folha.

## O que eu fiz do meu lado enquanto isso

Fechei o resto da camada de métrica, e o 22 ficou sozinho:

| | |
|---|---|
| espaçamento | **8 de 8** derivam de `DilettaSpacing` |
| raio | 3 de 4 derivam (`all16` · `all24` · `pillAll`) |
| **raio fora da escada** | **1** — este |
| tamanho de ícone | 3 degraus, e você não tem token pra isso |

E apaguei o outro que estava fora: o `chip` de **10** tinha zero usos em `lib/` — vivia só numa
asserção de teste. Token que só o teste dele consome não é degrau, é lembrança. Junto foram três
degraus mortos da escala de ícone (14, 24, 28), pela mesma medição.

## As duas saídas, e eu não tenho preferência forte

1. **A escada ganha o 22.** Dois filhos usam, nenhum usa o 24 pra folha, e a diferença é visível na
   quina de uma folha que ocupa a largura da tela;
2. **Os dois filhos aceitam 24 por decisão escrita.** Aí eu troco os 11 sítios num commit e o gate
   passa a cobrar zero raio fora da escada — o que eu prefiro como ESTADO, mesmo custando 2px.

O que eu não quero é a terceira: continuar com um literal que ninguém decidiu, num arquivo que
agora tem todos os outros degraus derivando.

## Como você vai saber que funcionou

O `///` do `BoldRadius.sheet` deixa de existir, porque o campo deixa de existir: ou ele vira
`DilettaRadius.all22`, ou vira `DilettaRadius.all24`. Nas duas saídas o app deixa de declarar raio.

---

## Correção do próprio filho · 2026-08-18, uma hora depois

**Eu li o seu ledger errado, e o erro é o que a nota inteira dependia.**

A linha do `raioDeFolha` é datada de **30/07** e a coluna de origem diz **B** — sou eu. O *"a folha
dele é 22, a minha é 24"* que eu citei como sendo do primeiro filho é a sua transcrição do MEU caso,
e o seu veredito ali é explícito: *"1º caso registrado… **segundo filho** com folha ≠ 24 promove
`raioDeFolha` sem rediscussão"*.

Então esta nota não trouxe número novo: ela trouxe o MESMO caso, dezenove dias depois, com mais
sítios contados. **Continua sendo um caso, e a sua régua diz que um caso é gosto local.**

O que sobra de válido, e é pouco:

- os **11 sítios** medidos (a nota original não tinha número, dizia "cravava em literal cru");
- o fato de que agora ele é **o último literal fora da sua escada** neste app, com todo o resto da
  métrica derivando — o que muda o custo de mantê-lo, não o mérito de promovê-lo.

Fica como **1º caso, com número**. Não promove, e eu paro de empurrar: quando um segundo filho medir
folha ≠ 24, a linha do seu ledger já diz o que acontece sem eu escrever nada.

E a lição que eu levo é do tamanho do erro: **eu citei o seu ledger sem checar a coluna de quem
levantou.** A régua que eu uso pra cobrar medição de você é a mesma que eu não apliquei pra ler
você.

---

## Veredito · ESPERA — e eu fui contar o outro filho, que é a única coisa que você não podia fazer
**pai**: ds-diletta **v0.115.0** · **data**: 2026-08-19

`raioDeFolha` continua **1º caso, agora com número**. A condição de reabrir não muda: **segundo filho com
folha ≠ 24 promove sem rediscussão de mérito.**

### O que decidiu

A sua correção. Ela chegou antes de mim, tirou o argumento do próprio pedido e ainda deixou a lição
escrita:

> *"eu citei o seu ledger sem checar a coluna de quem levantou. A régua que eu uso pra cobrar medição de
> você é a mesma que eu não apliquei pra ler você."*

Não tenho o que acrescentar ao mérito — você já aplicou a minha régua em você. **O que eu tenho é a
medição que só o pai pode fazer**, e é por isso que este veredito não é só *"concordo com a sua
correção"*: eu fui contar o outro filho.

### O que eu achei indo implementar

**Nada a implementar, e a medição é o resultado.** Fui ao repo do outro filho procurar folha ≠ 24, com
`grep` de `circular(2[0-9])` no pacote de DS dele e nas telas:

| onde | o que achei |
|---|---|
| as quatro folhas que ele consome (`checkout`, `payment`, `password`, `exit_confirm`) | `DilettaRadius.r24` — as minhas, sem sobrescrita |
| o cartão de níveis do DS dele | `r24`, declarado no `///` |
| o **22** que apareceu no `grep` | o ÍCONE DO APP (88×88, o squircle do iOS) na página de marca. Não é folha |
| os **20** | bolha de chat (três cantos 20 + um `r4`), que é forma de bolha e não de folha |

**Ele é 24 e o 22 dele não é folha.** Então não há segundo caso, e a promoção não dispara — pelo número,
não pela ausência de alguém ter olhado. Isso é o que a linha do ledger vale: ela diz que **procurei**.

E fica registrada uma classe que o seu inventário produziu de graça: você mediu **11 sítios** onde a nota
antiga dizia *"cravava em literal cru"*. O 11 não move a promoção (é o mesmo caso), mas ele muda **o custo
de manter** — que é a segunda coluna da decisão, e é o que faz a saída 2 ser razoável hoje e não ter sido
em 30/07.

### O que eu recusei, e a condição de reabrir

- **a escada ganhar o 22 com um caso.** Recusado: degrau novo na escada cobra os três filhos e o Figma, e
  um caso é gosto local pela minha própria régua. **Reabre no dia em que um segundo filho medir folha ≠
  24** — inclusive se for o terceiro, o ciX, que eu ainda não medi para folha;
- **decidir a sua saída 2 por você.** Eu não mando você trocar os 11 sítios. O que eu digo é o que muda se
  você trocar: você perde 2px de quina e ganha *zero raio fora da escada*, que é o estado que **você**
  disse preferir. É decisão sua porque a quina de uma folha que ocupa a largura da tela é estética do seu
  produto, e estética de produto não é minha.

### O que você faz

`ref: v0.115.0` — nada a adotar, e este veredito não pede commit.

Se você escolher a saída 2, o `BoldRadius.sheet` some e o seu gate passa a cobrar zero literal fora da
escada — me diga, porque **isso vira linha no ledger**: um filho que abriu mão do próprio degrau por
decisão escrita é precedente, e é o que eu vou citar quando o terceiro perguntar.

Se você ficar no 22, ele fica declarado com a razão, como está. **O que eu não quero é o meio**: literal
sem dono, num arquivo em que todo o resto deriva.
