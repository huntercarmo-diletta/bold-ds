# Pedido · o descritor de CTA não sabe dizer CARREGANDO, e é ele que tranca a casca de baixo inteira

- **filho**: conta-bold-ds v0.16.0 · app-newbold `feat/adota-conta-bold-ds` (commit `080e208`)
- **pai**: ds-diletta v0.40.0 (`DilettaNavigationAction`, `DilettaButton`, `DilettaBottomApp`)
- **é bloqueante?**: **sim pra adoção da casca de baixo.** Não bloqueia build — o app tem a dele. Mas
  são **55 telas** que não têm como entrar no seu `DilettaBottomApp`, e o motivo é um campo

## A forma do bloqueio é diferente da do topo, e é isso que vale ler primeiro

No topo eu conseguia adotar a casca porque a `DilettaTopAppBar.app` recebe um **`navBar`** que já era
seu: `DilettaNavigationTopBar`. A casca aceitava a peça que eu já tinha.

Embaixo é o contrário. As sete factories do `DilettaBottomApp` são **tipadas nas suas moléculas**:

```dart
DilettaBottomApp.button({required DilettaNavigationButton button})
//                                ↑ que exige DilettaNavigationAction
```

Então adotar a casca de baixo exige adotar o descritor de CTA. E o descritor não tem como dizer uma
coisa que 13 CTAs deste app dizem.

## A medição — 82 usos, campo por campo

Parseei os 82 `BoldNavAction(...)` do app com parênteses balanceados (não por linha: a lição do
`grep -A4` que eu já te contei duas vezes):

| campo meu | usos | o seu equivalente |
|---|---|---|
| `label` | 81 | `label` |
| `onPressed` | 79 | `onPressed` |
| **`loading`** | **13** | **não existe** |
| `glyph` | 5 | `leadIcon` |
| `variant` | 2 | `type` |
| **`onPressedAsync`** | **2** | **não existe** |
| `trailingGlyph` | **0** | — |
| `filled` | **0** | — |

**Dois campos meus deram zero, e eu ia te pedir os dois.** Eles morreram no meu lado antes deste
arquivo existir. É a terceira vez nesta adoção que contar antes de pedir apaga o pedido, e agora eu
conto antes por reflexo — não por disciplina.

Sobraram dois de verdade, e eles não são do mesmo tamanho.

## 1 · `loading` — 13 usos, e o seu `DilettaButton` também não tem

Isto é o pedido. O seu botão declara `state`, e o enum é:

```dart
enum DilettaButtonState { normal, error }
```

Normal e erro. **Não existe o estado do meio** — aquele em que a ação já foi disparada e a resposta não
voltou. E o rodapé é exatamente onde isso mora: 13 dos meus 82 CTAs são "Continuar" de uma chamada de
rede, e o que eles mostram enquanto ela corre é uma rodela no lugar do rótulo.

**Não estou pedindo um campo no `NavigationAction`. Estou pedindo o estado no `DilettaButton`**, porque
é lá que ele é linguagem: qualquer botão que dispara rede precisa dizer isso, não só os do rodapé. O
`NavigationAction` herda de graça se o estado nascer no botão.

A forma que me parece caber na sua matriz sem inflar: `DilettaButtonState.loading` como terceiro degrau
do enum que você já tem. Um enum de dois que vira três não é campo novo em API nenhuma.

E o argumento de por que isto é linguagem e não gosto meu: **estado de espera não é decoração, é a
diferença entre "o app travou" e "o app está fazendo".** Um DS que sabe dizer erro e não sabe dizer
espera cobre a falha e não cobre o caminho normal dela.

## 2 · `onPressedAsync` — 2 usos, e eu NÃO estou pedindo

Fica registrado porque é o outro campo que meu descritor tem e o seu não, e eu não quero que ele
apareça como surpresa se um dia você olhar meu código.

É uma trava de toque duplo: `Future<void> Function()` em vez de `VoidCallback`, e o botão segura o
segundo toque até o primeiro terminar. A razão está escrita no meu código: *"dois toques num CTA de
rodapé viram duas requisições"*.

**Dois usos.** Pela sua régua isso é caso isolado, e eu concordo. Se o `loading` entrar, os dois sítios
resolvem com `loading` declarado pelo estado da tela e o `onPressed` desabilitado — mais verboso do meu
lado, e sem componente novo do seu. **Não peça o que dois sítios resolvem.**

## O que eu já fiz do meu lado, e o que fica esperando

- os dois campos mortos saíram;
- o **traço de home** do app morreu, e a razão é a sua: era cópia da sua geometria (34, pill 134×5,
  respiro 8) **sem as duas regras de aparelho** — recolher com teclado aberto, e não desenhar pill fake
  onde o SO já desenha o de verdade. É o mesmo defeito que você achou na sua `_NavHomeIndicator` privada
  e consertou por deleção na v0.31.0. Medi antes de trocar pela sua: `homeIndicator: true` tinha **zero
  usos**. Cópia com defeito de aparelho que nenhuma tela instanciava — e a sua frase serve inteira aqui:
  *defeito em variante que ninguém instancia é defeito que ninguém mede*. Deleção, não adoção;
- a casca de baixo continua sendo minha, e o `///` dela agora diz por quê, com os dois números.

## E uma coisa que NÃO é pedido: a minha nav é outro desenho

Registro pra não parecer que eu escondi a maior cópia do rodapé.

| | a sua `DilettaNav` | a minha |
|---|---|---|
| forma | barra **ancorada** full-width | **pílula flutuante**, margem 16 |
| raio | 40, só os cantos de cima | 26, os quatro |
| itens | `Expanded` (fill) | hug, gap 24 |
| ativo | círculo **estourando** a borda de cima (headroom 16) | spot por dentro |
| traço de home | por dentro da barra | não tem |

**Isso não é a sua peça copiada com defeito — é outra peça.** Adotar a sua não seria integração, seria
redesenhar a navegação da home, e essa decisão não é minha nem sua: é do dono do produto. Enquanto ele
não pedir, a pílula fica, e eu não vou chamar de dívida uma coisa que é escolha de desenho.

O que eu **não** vou fazer é o que fiz no topo por dois meses: manter cópia da sua gramática dizendo que
é desenho meu. A diferença entre os dois casos é medível e está na tabela — no topo os números eram os
seus com 8px a mais; aqui a forma é outra.
