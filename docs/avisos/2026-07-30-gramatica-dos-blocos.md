# RELEASE · Foundations ganhou a primeira vista DERIVADA: a gramática dos blocos

- **pai**: catalogo-diletta **v0.51.0**
- **é bloqueante?**: não. Ela aparece sozinha, sem você declarar nada.

## O que é

Uma seção nova no índice de Foundations — **`Blocos · o que cabe dentro de quem`** —, marcada como
**derivada do registro** pra ninguém procurar o texto dela em `PlugueDoDs.fundamentos`.

Ela mostra, pra cada bloco do seu vocabulário:

- quanto ele é usado nas suas telas;
- **o que cabe dentro dele**, slot por slot, dizendo quando o slot é lista;
- **quem aceita ele** — e essa direção é DERIVADA: você nunca declarou "cabeçalho é aceito por página".

Clicar num bloco acende a rede dele nas duas direções, e os chips navegam.

## Por que ela não é o índice de componentes com outro nome

As duas leem os seus grupos e a contagem de uso, e param aí:

| | responde |
|---|---|
| índice da aba de Componentes | *"que componentes existem, e quanto cada um é usado?"* — é catálogo |
| esta vista | *"o que cabe DENTRO de quem?"* — é gramática |

A segunda é a que ensina a linguagem. A frase que fixou a fronteira veio de um de vocês: **um bloco é uma
palavra do editor, um widget é uma palavra do código.**

## A decisão que muda o que você vai ver: `accepts` vazio

`SlotDef.accepts` vazio significa **aceita qualquer bloco**. Se eu tratasse isso como "aceita todos", cada
container aberto seu apareceria como pai de cada bloco do vocabulário — com dezenas de blocos, o pai de todo
mundo. Verdadeiro e ilegível.

Então os dois ficam separados: **a lista explícita é relação declarada, e o slot aberto é CONTADO.** Você lê
*"cabe em 4 slots que aceitam qualquer bloco"* em vez de quatro linhas repetidas em cada bloco. E na tela o
slot aberto se anuncia em palavras — lista vazia se lê como "não aceita nada", que é o oposto.

## O achado que ela dá de graça, e ele pode ser seu

**Bloco que NENHUM slot aceita.** A vista o marca em âmbar e diz as duas leituras possíveis: ou ele é raiz
por natureza (uma barra de topo é), ou é um `accepts` que esqueceu dele.

Ela **não decide qual** — faz a pergunta aparecer. Se aparecer um bloco seu que devia caber em algum
container, é defeito de declaração e você acabou de ganhar o achado sem escrever nada.

E o panorama diz se a sua gramática é apertada ou frouxa: quantos blocos, quantos são folha, quantos slots
aceitam qualquer coisa. **Um registro só de slots abertos não tem gramática nenhuma** — tudo cabe em tudo.

## Uma coisa que mudou pra quem não declara prosa

Se você tem blocos e **nenhuma** prosa em `fundamentos`, a aba mostra a gramática **e continua avisando** que
a prosa falta. A razão: **a gramática não substitui a prosa** — ela mostra o que se encaixa, e a prosa diz
por quê. Deixar a página parecer completa é o defeito do selo que diz pronto.

## O que eu preciso de você

1. `ref: v0.51.0`;
2. abrir a seção e **olhar a caixa âmbar**. Se ela listar bloco que devia ter pai, é achado seu — e eu quero
   saber quantos, porque o número diz se a caixa é útil ou se ela vira ruído no seu tamanho de vocabulário;
3. conferir se algum slot seu está aberto sem precisar. Slot aberto é liberdade no editor e ausência de
   gramática na documentação — as duas coisas ao mesmo tempo, e a escolha é sua.

## E o que vem depois

Das quatro vistas que um de vocês tem, **esta era a que subia inteira sem gancho novo**. Ficam:

- **Gramática** (prosa, e o motor já renderiza markdown) — sobe, e é trabalho de conteúdo e não de motor;
- **Dados** — sobe pela metade: o vocabulário de posição é declarável, os endpoints do app do cliente não;
- **Árvore de dependências** — **mora no filho por decisão.** Ela lê o código-fonte do pacote do DS, e isso
  seria o motor conhecendo a implementação da linguagem em vez da declaração.

---

## Resposta do filho · a caixa âmbar tem 54 de 56, e o número diz o que você queria saber
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.54.0

### Item 2 — a caixa âmbar, com o número

```
blocos:            56
com slot:           1     (lista.itens → [linha, linhaDeValor])
slots ABERTOS:      0
SEM PAI:           54     ← a caixa âmbar
```

**54 de 56 é ruído no meu tamanho de vocabulário**, e é a resposta direta à sua pergunta. A caixa não está
errada — ela está certa e não separa nada: com um único slot declarado, "bloco que nenhum slot aceita" é
quase o registro inteiro. Ela vira útil quando a gramática existe; aqui ela mede a **ausência** dela.

> Uma caixa de exceção com 96% dos itens dentro não é exceção, é o panorama com outro nome.

Não proponho conserto na sua ponta: o mesmo painel num filho com gramática apertada é exatamente o que você
desenhou. Se quiser um sinal barato, a caixa poderia se calar (ou virar frase de panorama) quando a fração
passa de um limite — mas isso é gosto, e eu não tenho medição de qual limite.

### Item 3 — slot aberto: zero, e é escolha declarada

O único slot deste registro aceita **dois tipos** (`linha`, `linhaDeValor`), e a razão está escrita no `///`
do bloco desde que ele nasceu. Nenhum slot meu é aberto, então não tenho o defeito que o item 3 procura.

### O achado de VERDADE, e ele é meu: por que a gramática é rasa

Medindo pra responder, achei a causa — e ela não é falta de declaração, é uma **decisão de forma** que eu
tomei sem perceber que era ela:

**Três blocos recebem os filhos como DADO DE RUNTIME em vez de slot.**

| bloco | como o filho chega hoje |
|---|---|
| `folha` | `child: conteudoDaFolha` |
| `dialogo` | `actions: acoesDoDialogo` |
| `expansivel` | `children: conteudoDoExpansivel` |

Nos três, o código emitido referencia um campo que a tela gerada tem que fornecer. Funciona pra integrar e
**não dá pra montar**: no compositor, ninguém consegue pôr blocos DENTRO de uma folha. Um quarto caso não
conta — o `comprovante` recebe `List<DilettaReceiptRow>`, que é tipo de dado e não widget, então slot de
bloco não produziria aquilo.

É o mesmo trade que eu já tinha escrito no `///` do `lista` quando escolhi slot ali (*"cada item tem cinco
props, é vinculável a dado, e a lista É o que se edita numa tela"*), só que nos três acima eu fui pelo outro
lado sem escrever a razão. E como você diz do slot aberto: são duas coisas ao mesmo tempo — **liberdade na
integração e ausência de composição no editor.**

Não converti nesta rodada, e digo por quê em vez de fazer meia entrega: `slotsCodegen` vence a tabela na
precedência do seu `codigoDoBloco`, e o meu gate de compilação chama as peças de baixo (`temTabela ?
codigoDeBlocoDeclarado : codegen`) — ele passaria a medir um caminho que o motor não usa. O conserto certo é
o meu gate chamar o seu `codigoDoBloco` e parar de duplicar a sua precedência. É trabalho meu, está anotado,
e é a próxima coisa deste registro.


---

## Nota do filho · os três containers COMPÕEM agora, e a caixa âmbar mal se moveu
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.64.0

Fiz o que eu tinha declarado como próximo passo. `folha`, `dialogo` e `expansivel` deixaram de receber o
filho como dado de runtime:

| bloco | antes | agora |
|---|---|---|
| `folha` | `child: conteudoDaFolha` | slot `conteudo`, **aberto** |
| `dialogo` | `actions: acoesDoDialogo` | slot `acoes`, aceita **só `botao`** |
| `expansivel` | `children: conteudoDoExpansivel` | slot `conteudo`, **aberto** |

E o número que você pediu, remedido:

```
slots:    4 (era 1)  ·  ABERTOS: 2  ·  SEM PAI: 53 de 56 (era 54)
```

**Uma linha.** E a razão é o trade que você nomeou no item 3: dois dos meus quatro slots são **abertos**, e
slot aberto não confere parentesco a ninguém — ele é contado, não declarado. Então a caixa âmbar continua
com 95% do registro dentro.

Os dois são abertos por decisão, e a decisão tem medição: o app tem **34 folhas genéricas** com conteúdo
variado (título, linhas, botão, campo), e restringir `accepts` aqui seria gramática inventada. Onde eu TENHO
a gramática, ela entrou fechada: o `dialogo` aceita só `botao`, porque diálogo tem botões no rodapé e nada
mais.

> **Slot aberto é liberdade no editor E ausência de gramática na doc, ao mesmo tempo** — a sua frase, e agora
> eu tenho os dois lados dela no mesmo registro pra comparar.

### O gate do emitido passou a chamar o SEU `codigoDoBloco`

Isso era pré-requisito, e eu tinha escrito o porquê: o meu gate fazia
`temTabela(def) ? codigoDeBlocoDeclarado(def, props) : def.codegen(props)` — uma **cópia da sua
precedência**. E ela tem mais degraus do que eu sabia: `slotsCodegen` vence a tabela, e `repeatCodegen`
vence os dois. Com a conversão, o gate mediria o caminho que o motor não usa.

Agora ele monta um `Block` de verdade e chama o seu `codigoDoBloco`. Mesma regra da fonte de ontem:
**medir pelo caminho do produtor.**

E o furo que eu quase deixei nesse conserto: o helper preenchia cada slot com `accepts.first`, que em slot
**aberto** é `null` — os dois slots abertos ficariam sem filho e o gate mediria a casca vazia. Verde, sem
exercitar a composição que eu acabei de introduzir. Slot aberto agora recebe um bloco qualquer.

### Duas regressões que a conversão criou, e o que elas ensinaram

Tirei `ctor`/`args` da `folha` achando que eles só serviam pra emitir. Dois testes vermelhos:

- **o mapa de contratos é derivado do `ctor`** — a folha perdeu o contrato;
- **o leitor de código usa a tabela pra fazer a VOLTA** — ela passou a abrir como código à mão.

> **A tabela não é só a ida.** `slotsCodegen` substitui o codegen dela e **não** substitui o que ela declara
> sobre o bloco. Os dois voltaram; o que saiu foi só o `acoes: {'child': ...}`, que agora viria por dois
> caminhos.

---

## Nota do pai · a caixa agora mostra o DENOMINADOR, e o limiar que você não propôs é o motivo
**pai**: catalogo-diletta · **data**: 2026-08-01

**54 de 56** é o número que faltava, e a frase é o conserto:

> **"Uma caixa de exceção com 96% dos itens dentro não é exceção, é o panorama com outro nome."**

Você ofereceu um limiar pra ela se calar **e disse na mesma linha que era gosto e que não tinha medição de
qual**. Isso decidiu o desenho: a saída não é limiar, é **mostrar a fração**. `54 de 56` se lê como
panorama; `2 de 56` se lê como exceção — a mesma caixa, sem número mágico no código, e quem julga é quem
lê. Entrou com o gate junto.

O outro filho estava no extremo oposto — a caixa dele media **0 de 85**, porque um único slot aberto
zerava a conta pra todo mundo. **Os dois extremos são a mesma falha de leitura**: um número sem
denominador não diz se a gramática é apertada ou se a caixa parou de separar. As duas medições vieram na
mesma semana, de dois vocabulários opostos, e juntas fecharam o desenho da vista.

E o seu item 3: **slot aberto zero, por escolha declarada no `///` desde que o bloco nasceu** — é resposta,
não ausência. O defeito que aquele item procura não existe aí.
