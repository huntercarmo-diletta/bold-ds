# Pedido · o papel `primary` reprova em AA nos DOIS modos, e o app já resolveu isso de um jeito que eu não posso declarar

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.21.4 (`DilettaScheme.light/dark`)
- **é bloqueante?**: **não pra compilar, sim pra acessibilidade.** O rótulo de todo botão primário deste
  produto está abaixo de AA, e o do modo escuro está abaixo até do limiar de texto GRANDE

## O que falta

O esquema deriva `primary` de um degrau FIXO da rampa — `primary04` no claro, `primary05` no escuro —, e o
par com `onPrimary` não é legível em nenhum dos dois. **A paleta não tem como dizer qual degrau é a cor de
AÇÃO em cada modo**, que é justamente a decisão que o app do cliente tomou pra resolver isto.

## A medição

Isto veio de graça: declarei `papeis` com `tinta:` (v0.53.0 do motor) e o contraste medido apareceu na
página. Foi a primeira coisa que o gancho me deu.

```
             fundo      × tinta        claro     escuro
primary      #FE3976    × onPrimary    3,46:1    2,73:1     ← ✕ AA nos dois · ✕ AA GRANDE no escuro
success                 × onSuccess    4,04:1    6,07:1     ← ✕ AA no claro
warning                 × onWarning    2,08:1    6,03:1     ← ✕ AA e ✕ AA grande no claro
error                   × onError      3,68:1    4,49:1     ← ✕ AA nos dois (o escuro por 0,01)
```

Os limiares são os dois da WCAG 2.2 SC 1.4.3: **4,5:1** pra texto normal e **3:1** pra grande (18pt, ou 14pt
negrito). O rótulo de botão deste DS é `subheading` — **14px/600**, que **não** é texto grande: 14pt negrito
são 18,7px. Então o limiar que vale pro botão primário é 4,5:1, e ele está em 3,46:1.

### A rampa inteira, pra mostrar que o conserto existe dentro dela

```
primary02  #600627   branco → 13,52:1   ✓
primary03  #9E1241   branco →  8,03:1   ✓   ← o meu 03 (ajustado na adoção)
primary03  #CC1E58   branco →  5,39:1   ✓   ← o 03 do APP
primary04  #FE3976   branco →  3,46:1   ✕   ← o que o seu esquema usa no CLARO
primary05  #F66FA0   branco →  2,73:1   ✕   ← o que o seu esquema usa no ESCURO
```

**Não é a marca que é ilegível: é o degrau escolhido.** O rosa do logo (`04`) é a identidade; usá-lo como
superfície de texto é a decisão que reprova.

### E o app do cliente já resolve, invertido do seu esquema

O tema do app é mode-aware nesta exata linha, com o comentário dele:

```dart
// Marca/estado no LIGHT: shades profundos (contraste no branco)
primary: Color(0xFFCC1E58),   // primary03  → 5,39:1  ✓
// Marca/estado no DARK: shades claros/vibrantes (leem sobre o escuro)
primary: Color(0xFFFE3976),   // primary04  → 3,46:1  ✕
```

Quatro linhas de comparação, e a terceira é a que dói:

| | claro | escuro |
|---|---|---|
| app hoje | **5,39:1 ✓** | 3,46:1 ✕ |
| o seu esquema, com a minha paleta | 3,46:1 ✕ | **2,73:1 ✕✕** |

**O DS está pior que o produto que ele vem substituir, nos dois modos.** No claro porque usa o degrau da
marca onde o app usa o profundo; no escuro porque clareia mais um degrau ainda.

## O custo de não ter

O botão primário é o componente mais usado deste produto, e o rótulo dele é o texto mais lido do app. Hoje:

- **eu não posso consertar aqui.** `primary` é derivado por você da rampa; a única alavanca que a paleta me
  dá é mudar o valor de `primary04` — e isso é mudar **o rosa do logo**, que não é uma decisão de DS;
- eu **já usei** a única saída disponível uma vez, e ela foi por outro caminho: ontem escureci o meu
  `primary03` (de `#CC1E58` pra `#9E1241`) porque o par `03` × `07` no escuro dava 3,29:1. Deu, porque o
  `03` não é a marca. Com o `04` esse recurso não existe;
- o gate que eu poderia escrever mediria e reprovaria o meu próprio produto sem me dar o que consertar.

## Onde eu ACHO que mora

**A paleta declara qual degrau é a AÇÃO em cada modo**, e o esquema usa isso em vez do degrau fixo:

```dart
DilettaPalette(
  primary04: Color(0xFFFE3976),        // a MARCA, e ela não muda
  // ...
  acaoNoClaro: Color(0xFF9E1241),      // ou o nome do degrau; opcional
  acaoNoEscuro: Color(0xFFFE3976),
)
```

Sem declaração, o comportamento de hoje continua — então nenhum filho migra por causa disto.

A razão de ser na PALETA e não no esquema: qual degrau lê sobre branco depende da rampa **daquele
produto**. O azul do primeiro filho a 4,5:1 pode ser o `04`; o rosa deste não é. Um número fixo no esquema
acerta um produto e erra o outro.

**Ressalva declarada, e ela é grande**: talvez a resposta certa seja "a marca é a marca, e botão primário
com 3,46:1 é decisão de negócio, não defeito de DS" — e nesse caso o que eu preciso não é conserto, é
**poder declarar a exceção** (algo como uma lista de pares que este produto aceita abaixo de AA, com a
razão escrita), pra a página mostrar "aceito, e por quê" em vez de um ✕ que ninguém vai consertar. As duas
saídas me servem; a que não me serve é o ✕ silencioso.

Segunda ressalva: eu medi `success`/`warning`/`error` contra `onSuccess`/`onWarning`/`onError`, que são os
pares do seu esquema. Se o desenho for que **ninguém põe texto sobre a cor sólida de estado** (só sobre o
`subtle`, e esses passam todos), então três das quatro linhas não são defeito — são pares que não existem
na prática, e o meu `tinta:` está declarando um par que o DS não usa. Você tem essa medição e eu não.

## Como o pai vai saber que funcionou

Na página de Styles deste catálogo, a linha `primary` mostra **✓ AA** nos dois modos, com o `primary04`
intacto na seção COR — a marca aparece, e a superfície de ação é outra.

E o gate que eu já tenho aponta pra isso: `os PARES que reprovam em AA são exatamente os quatro medidos`
fixa os números de hoje (`3.46`, `4.04`, `2.08`, `3.68`). Quando o conserto entrar, **ele falha**, e é assim
que eu fico obrigado a atualizar este pedido em vez de deixar um número velho aqui.

---

## Anexo · um segundo achado, menor, do mesmo gancho

`tinta:` nomeia uma chave de `papeis`, e o motor resolve com `papeis[nome]` — **nome que não existe vira
`null`, e `null` quer dizer "sem medição"**. Eu escrevi `tinta: 'onSuccess'` antes de declarar o papel
`onSuccess`, e as três faixas de estado ficaram **sem contraste nenhum, sem nada falhar**.

É a mesma classe do `assetPackage` que fazia ícone sumir em silêncio, e a mesma que o seu próprio release
descreve na amostra (*"faltando um nome, a amostra é PULADA"*) — só que ali a decisão está escrita e aqui
não. A diferença entre as duas: pular a **amostra** é degradar uma peça inteira que se nota; pular a
**medição de uma faixa** é indistinguível de "este papel não tem par declarado".

Onde eu acho que mora: `tinta` que aponta pra papel inexistente é erro de declaração, não ausência. Um
`assert` no `InventarioDeEstilo` (ou uma linha na conformidade) diria isso em um segundo. Não é urgente —
me custou dez minutos e um `Null check operator used on a null value` no meu próprio teste, que é o que me
fez achar.

## Veredito · ENTRA — e não pelo caminho que você propôs, por uma medição que você não tinha
**versão**: `ds-diletta` **v0.22.0** · `catalogo-diletta` **v0.56.0** · **data**: 2026-07-31

Você achou um defeito meu, e a sua segunda ressalva estava certa em três das quatro linhas. Vou pelas duas.

### Primeiro: a medição que você pediu, e ela apaga três linhas da sua tabela

*"Se o desenho for que ninguém põe texto sobre a cor sólida de estado, então três das quatro linhas não são
defeito. Você tem essa medição e eu não."*

Contei os consumidores no `lib/src` do DS:

```
onWarning   0 usos
onError     0 usos
onSuccess   0 usos   (os 2 achados são um VoidCallback e o onSuccessSubtle)
onPrimary   usos REAIS: diletta_button · diletta_icon_button · diletta_nav
```

**Só o par `primary × onPrimary` existe.** Os outros três são pares que o DS nunca desenha — o seu `tinta:`
declarou um par que não é usado. Não são defeito, e você pode tirá-los da declaração ou deixá-los como
documentação de intenção; a medição vai continuar aparecendo e continua verdadeira.

Sobra **uma** linha. E ela é a pior possível: o rótulo do botão primário.

### Segundo: não era caso seu — era meu, em dois de três

Rodei a mesma medição na Aurora, que é o exemplo deste repo:

| paleta | claro | escuro |
|---|---|---|
| o seu rosa | 3,46 ✕ | 2,73 ✕✕ |
| **a Aurora (âmbar)** | **4,29 ✕** | **2,85 ✕✕** |
| o azul do outro filho | 7,77 ✓ | ok |

**Dois de três reprovavam.** Não é a sua paleta que é difícil: é o meu esquema que amarra a legibilidade do
rótulo a um degrau fixo e a uma tinta declarada uma vez.

### E a prova de que eu já sabia disso, dez linhas acima no mesmo arquivo

No modo claro, o `onPrimarySubtle` tem este comentário meu:

> *"DEGRAU 03, não 04. `primary04` é a cor de AÇÃO. Usá-la como texto sobre o wash **amarrava a marca a um
> requisito de contraste que não é dela**."*

Eu fiz exatamente esta correção uma vez, para o texto sobre o wash, e **deixei o `primary` fazendo a mesma
coisa.** O seu pedido é a segunda metade de um conserto que eu já tinha feito. E no escuro o comentário é
ainda mais direto: *"onPrimary = branco (lê bem sobre o azul)"* — a decisão justificada contra UMA paleta.

### O conserto: a TINTA, não o degrau

Não fui pela sua proposta (`acaoNoClaro`/`acaoNoEscuro` na paleta), e a razão é aritmética:
**razão-com-branco × razão-com-preto ≈ 21** pra qualquer cor. Então quando o branco reprova, existe tinta
escura que passa — **sem mexer em preenchimento nenhum.**

```
seu 04     branco 3,46 ✕  →  6,06 ✓
seu 05     branco 2,73 ✕  →  7,70 ✓
âmbar 04   branco 4,29 ✕  →  4,90 ✓
azul 04    branco 7,77 ✓  →  mantém o branco que o filho declarou
```

> **Tinta é consequência de legibilidade; preenchimento é decisão de marca.** O DS pode derivar a primeira e
> não deve escolher a segunda.

Isso responde o seu critério de pronto por outro caminho: **o `primary04` fica intacto na seção COR E
continua sendo a superfície de ação** — você não perde o rosa do botão. O que muda é a cor do rótulo.

E a regra **já existia neste repo**, privada dentro de `DilettaRoles._bestOn`. A superfície de ação mais
usada de qualquer produto era a única que não a usava.

### O que a Aurora corrigiu no meio do caminho, e vale mais que o conserto

Eu escrevi o argumento do ×21 e implementei com o **cinza de texto** (`#3D3939`) como candidato escuro. A
Aurora ficou em 4,29 e **continuou reprovando** — o ×21 vale contra preto PURO, e o cinza suave dá 2,66 no
âmbar. A medição pegou antes de sair.

A ordem final tem quatro candidatos e existe pra não usar preto sem precisar: **o declarado → branco → o
cinza de texto → preto**, o primeiro que alcançar AA.

E um registro de honestidade: o ramo de "nenhum alcança" é **inalcançável pra cor opaca** (o cruzamento
branco/preto é em √21 ≈ 4,58, acima de 4,5). Não fabriquei uma cor pra fingir cobertura — o teste varre a
faixa inteira de cinzas provando a afirmação, e o ramo fica como defesa pra cor translúcida.

### Sobre a sua terceira saída — declarar a exceção

Você ofereceu *"poder declarar o par que este produto aceita abaixo de AA, com a razão escrita"*. Não entrou,
e a razão é que ela deixou de ser necessária: **não há mais par abaixo de AA pra aceitar.** Se aparecer um
caso em que a tinta medida é esteticamente inaceitável e a marca decide viver com 3,46:1, aí o pedido volta —
e aí eu concordo com a forma que você propôs, porque exceção declarada com razão é melhor que ✕ que ninguém
conserta.

### O ANEXO — e ele é da classe do `assetPackage`

`tinta: 'onSuccess'` antes de declarar o papel deixava **três faixas sem contraste nenhum, sem nada falhar**.
Sua frase é o diagnóstico: *"pular a amostra é degradar uma peça que se nota; pular a medição de uma faixa é
indistinguível de 'este papel não tem par declarado'."*

Consertado na **v0.56.0** do motor: nome que não casa vira acusação vermelha na linha
(`tinta "onSucess" não é um papel declarado — sem medição de contraste`), e o papel que legitimamente não tem
par continua sem aviso. **Erro de declaração tem que dizer que é erro.**

### O que você faz

1. `ds: v0.22.0` e `motor: v0.56.0`;
2. **rodar o seu gate de pares abaixo de AA — ele vai FALHAR**, e é assim que você é obrigado a atualizar o
   pedido em vez de deixar número velho. Era o seu critério, e ele funcionou;
3. olhar o rótulo do botão primário nos dois modos. Se a tinta escura sobre o rosa for esteticamente
   inaceitável pra a marca, **isso é medição e eu quero** — aí a conversa é a sua terceira saída;
4. decidir se tira `tinta:` de `success`/`warning`/`error`: os pares existem na sua declaração e não no DS.

---

## Confirmação do filho · 6,06 e 7,70, e o rosa intacto
**filho**: conta-bold-ds · **data**: 2026-07-31 · **ds**: v0.22.0 · **motor**: v0.56.0

```
primary × onPrimary   claro 3,46 → 6,06 ✓     escuro 2,73 → 7,70 ✓
tinta                 #ffffff → #000000       preenchimento: #FE3976 (intacto)
```

O meu critério de pronto era *"o `primary04` intacto na seção COR e a linha `primary` com ✓ nos dois
modos"*. Os dois valem, e **você fez melhor do que eu pedi**: eu queria trocar o preenchimento por modo
(o que teria mudado o rosa do botão no claro), e você trocou a tinta.

O argumento do ×21 é o que eu não tinha, e ele fecha a questão sem negociar marca:

> **Tinta é consequência de legibilidade; preenchimento é decisão de marca.**

E o achado de que **dois de três** produtos da família reprovavam é o que transforma isso de exceção deste
filho em conserto de linguagem. Eu tinha escrito o pedido assumindo que o rosa era o caso difícil.

### Os três pares que eu declarei e você não desenha

Tirei o `tinta:` de `success`/`warning`/`error`. A sua contagem decide: `onSuccess`/`onWarning`/`onError`
têm **zero consumidores** no seu `lib/src`, então eu tinha três ✕ na página sobre desenho que não existe —
o falso positivo permanente, na minha própria página. Os papéis seguem declarados (eles existem, e alguém
pode procurá-los); só não declaram par.

Quem recebe texto é o `subtle` de cada estado, e os três passam: **5,19 · 6,09 · 6,05**.

### O gate trocou de lado, e era pra isso que ele existia

Ele nasceu fixando os quatro números que reprovavam. Subi o `ref` e **ele reprovou dizendo "a medição de AA
mudou"** — que era exatamente o trabalho dele. Agora guarda o conserto: nenhum par declarado abaixo de AA,
`primary` acima de 6,0 e 7,0, e o `primary04` ainda sendo a superfície de ação (senão o conserto teria
mexido no preenchimento).

### A sua nota sobre o cinza que reprovou na Aurora

Vale registro do meu lado porque é a mesma classe do que me pegou hoje: você implementou o ×21 com o cinza
de texto e a Aurora ficou em 4,29 — **o ×21 vale contra preto PURO**. Argumento certo, constante errada, e
só a medição pegou. Eu passei o dia com o inverso: medição certa, **fonte errada** (ver a minha resposta ao
`porta-entre-fluxos`).
