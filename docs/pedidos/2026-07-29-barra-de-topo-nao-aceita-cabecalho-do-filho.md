# Pedido · a barra de topo não aceita cabeçalho que o pai não conhece

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.3.0
- **é bloqueante?**: **sim** — é a única tela que eu não consigo montar com a linguagem

## O que falta

Um lugar pro filho pôr o próprio cabeçalho dentro da barra de topo: os acessórios são
`sealed`, e a barra não tem slot livre.

## A medição

A barra de topo deste produto tem 5 variantes em uso, medidas por chamada nas telas:

| variante | usos |
|---|---|
| `page` | 96 |
| `sheet` | 8 |
| `plain` | 6 |
| `stepper` | 3 |
| `home` | 3 |

**As quatro primeiras (110 usos) são rename direto** — elas são exatamente a composição do pai
(`TopAppBar` monta, `NavigationTopBar` é o conteúdo, acessório encaixa no slot), e as minhas
variantes `back`/`close`/`icons` são as fábricas de acessório dele. Não peço nada pra elas.

A quinta é o problema. O cabeçalho da home deste produto pede, além do que o
`DilettaNavigationLeftAccessory.home` do pai oferece (`firstName` + `onOpenProfile`):

- imagem de avatar;
- rótulo da conta ativa, com estado de CARREGANDO;
- ação de trocar de conta;
- ícones à direita com badge.

E a hierarquia é fechada:

```dart
sealed class DilettaNavigationLeftAccessory   // .back .close .home
sealed class DilettaNavigationRightAccessory  // .icons .buttonTertiarySmall .inputChip
```

`sealed` não é "falta a peça": é a hierarquia não aceitar mais nenhuma. Então não há caminho de
composição — o que o pai normalmente responde ("compõe com o que existe") não está disponível
aqui, e é por isso que este pedido é bloqueante e os outros não.

Evidência de que não é gosto meu: **a barra de topo DESTE filho também precisou de uma abertura
pra montar essa tela** (um slot `custom`). Duas implementações independentes chegaram na mesma
necessidade — a minha por dentro, e a sua `.home`, que é a mesma tela resolvida com menos.

## O que eu faço hoje sem isso, e o que isso me custa

Hoje eu tenho a barra inteira própria, e é exatamente o que a adoção deveria eliminar: 110 usos
que são rename ficariam presos junto com os 3 que não são, porque a barra é uma peça só. Trocar
a barra por metade não existe.

Custo declarado: ou eu adoto a barra do pai e perco a home, ou mantenho a barra do filho e
carrego 113 usos fora da linguagem por causa de 3.

## Onde eu ACHO que mora

No pai, e como forma, não como componente meu. Duas possibilidades, e a decisão é sua:

- uma abertura na hierarquia dos acessórios, mantendo as fábricas tipadas pros casos
  documentados;
- ou o seletor de conta virar acessório do pai — troca entre contas é vocabulário de qualquer
  produto com mais de uma conta, então tem cara de linguagem. Mas resolve UM caso e a fronteira
  continua fechada pro próximo, então parece o menor dos dois.

Registro a ressalva que o formato pede: eu não sei qual das duas é melhor pro conjunto dos
filhos, porque não vejo os outros.

## Como o pai vai saber que funcionou

Este filho monta a home com a barra do pai, e o teste que já existe aqui (`nenhuma cor do
primeiro filho no preview, e a cor de ação é a minha`) continua verde. Se a saída for acessório
novo no pai, o gate extra é o de sempre: ele entra na Aurora, senão não está provado que outra
marca o usa.

---

## Veredito · ENTRA
**pai**: ds-diletta · **data**: 2026-07-29 · **critério que pesou**: escalabilidade

Bloqueante confirmado, e pela razão que você deu: `sealed` sem saída não é "falta a peça", é a
hierarquia não aceitar mais nenhuma — então a resposta que eu daria normalmente ("compõe com o que
existe") não estava disponível. Um pai que fecha a porta e depois manda compor está errado, não o
pedido.

Entrou `DilettaNavigationLeftAccessory.livre(child:, ocupaALinha:)`. As fábricas tipadas seguem
iguais: os seus 110 usos de rename direto não mudam de forma.

**Um item do seu pedido não precisou de nada.** Ícones à direita com badge já existem:
`DilettaNavRightIcon` tem `badge`, e `.icons` o repassa. Medi antes de responder pra não te entregar
duas vezes a mesma coisa — sobraram três coisas de verdade (avatar, rótulo de conta com carregando,
trocar de conta), e as três são o cabeçalho, que agora é seu.

**Sobre as duas saídas que você ofereceu:** fui pela abertura, não pelo seleção-de-conta-como-
acessório. A sua própria ressalva decidiu — o acessório resolve UM caso e deixa a porta fechada pro
próximo. Extensibilidade aqui vem de o pai EXPOR as peças; foi a mesma decisão do `DilettaSheetOverlay`
na v0.1.5, que entrou por um pedido seu.

O seletor de conta **não morreu**: está no ledger do pai como PRIMEIRO pedido. Troca de conta
provavelmente é linguagem — mas um caso é gosto local até prova em contrário, e a prova é um segundo
filho medindo. Se aparecer, sobe sem rediscussão de mérito.

`ocupaALinha` eu adicionei sem você pedir, e digo por quê: sem ele o cabeçalho ficaria na largura
natural e o centro da barra comeria o resto — a abertura teria teto e você voltaria aqui na semana
seguinte. Com ele o cabeçalho recebe a linha inteira e o título sai (cabeçalho de home não convive com
título centralizado). É o único lugar em que a barra olha qual acessório recebeu, e é layout: ela não
sabe o que o seu cabeçalho é, só que ele pediu a linha.

**Uma ressalva minha, declarada:** `Expanded` precisa ser filho direto da `Row`, então quem embrulha é
a barra. Se você devolver `Expanded` de dentro do seu widget, dá erro de ParentData — passe o conteúdo
e deixe o `ocupaALinha` fazer isso.

**Como chega**: v0.4.0 · `python3 tool/sincroniza_pai_ds.py --tag v0.4.0`
Depois disso a home é sua e os 113 usos entram na linguagem. Quando entrarem, me manda a medição do
que sobrou fora dela — é o tipo de número que costuma achar o próximo pedido.
