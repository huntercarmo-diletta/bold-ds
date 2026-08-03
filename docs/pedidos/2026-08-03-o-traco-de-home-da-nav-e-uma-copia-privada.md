# Pedido · o traço de home da `DilettaNav` é uma CÓPIA privada, e ela perdeu as três regras do original

- **filho**: conta-bold-ds v0.8.0
- **pai**: ds-diletta v0.26.0 (`DilettaNav`, `DilettaBottomHomeIndicator`)
- **é bloqueante?**: **não** — mas é defeito de APARELHO, não de catálogo: no iPhone a barra de navegação
  do produto desenha um traço FALSO por cima do traço do sistema, e com o teclado aberto o falso flutua
  sobre ele

## O que eu achei, e como

Declarando as cinco variantes do `DilettaBottomApp` (a sua cobrança de hoje, motor v0.77.0), o meu gate de
chrome quebrou na variante `nav`: ele conta `DilettaBottomHomeIndicator` na árvore e exige **um**. Na `.nav`
não achou **nenhum** — e o traço está desenhado na tela.

A razão está no seu código:

| quem desenha | o quê |
|---|---|
| `DilettaBottomApp.button/.keyboard/.chatInput/...` | `DilettaBottomHomeIndicator` (público) |
| `DilettaNav` (usada pela `.nav`) | **`_NavHomeIndicator`** — classe privada dentro de `diletta_nav.dart` |

O desenho das duas é o mesmo, linha por linha: altura 34, `padding bottom: s2`, pill 134×5, `pillAll`, cor
`s.fg`.

## As três regras que a cópia não tem — e duas são comportamento de aparelho

O público faz três coisas antes de desenhar o pill:

```dart
if (mq.viewInsets.bottom > 0) return const SizedBox.shrink();   // 1 · teclado aberto → recolhe
final realInset = mq.viewPadding.bottom;
if (realInset > 0) return Container(height: realInset, ...);    // 2 · device real → NÃO desenha pill fake
// 3 · e o resto vem embrulhado em DilettaDevInfo (o dev mode publica o token)
```

Os seus próprios comentários explicam por que as duas primeiras existem:

> *"Teclado aberto → o gesture bar do iOS fica coberto: recolhe (evita a barrinha flutuando sobre o
> teclado). **Robusto p/ toda variante do BottomApp.**"*

> *"Device real: o SO já desenha o gesture bar de verdade. Reserva só o inset real e **NÃO desenha pill
> fake (senão duplica)**. O pill fake abaixo é fidelidade de catálogo."*

**"Robusto p/ toda variante do BottomApp" é a frase que a cópia desmente.** A `.nav` é uma das sete
variantes, e nela as duas regras não valem: em iPhone com gesture bar, o pill fake é pintado junto do
verdadeiro; com o teclado aberto, ele flutua.

E a terceira: sem o `DilettaDevInfo`, o modo dev não publica o token do traço na `.nav` — a mesma peça
aparece instrumentada numa variante e muda na outra.

## Por que eu não resolvo sozinho, e por que não é "só" um gate meu

Eu **contornei do meu lado**: o gate passou a contar `DilettaBottomHomeIndicator` + `DilettaNav`, porque de
fora não há como referenciar uma classe privada sua. O contorno é honesto e continua valendo se você
consertar — mas ele mede *"alguém desenhou"*, e não *"desenhou com as regras"*. **A parte que importa é a do
aparelho, e ela não é minha:** o app do Conta BOLD tem a nav na home, e é o produto que pinta traço duplo.

Nenhum caminho daqui alcança: a classe é privada, a `DilettaNav` não aceita o slot do indicador por
parâmetro, e envolver a nav por fora não apaga o que ela desenha por dentro.

## O que eu peço

**Trocar `_NavHomeIndicator` por `DilettaBottomHomeIndicator`** dentro da `DilettaNav`. É deleção, não
desenho novo: a geometria já é idêntica, então o diff é uma classe privada que sai e um import que entra.

O que muda pra quem usa:

- no aparelho, a nav passa a respeitar o inset real e o teclado — que é o comportamento que os seus dois
  comentários já prometem "pra toda variante";
- no catálogo, nada muda (sem inset do SO, o público desenha o mesmo pill fake — é a "fidelidade de
  catálogo" que você escreveu);
- e o dev mode passa a publicar o token na `.nav` como já publica nas outras seis.

**Não pedi parâmetro nenhum.** Se você quiser o `background` do público exposto na nav depois, isso é outra
conversa — aqui a peça faltando é só a peça certa no lugar da cópia.

## O que fica do meu lado de qualquer jeito

- o gate que conta os dois (`as_telas_nao_duplicam_o_chrome_test`), porque contar quem desenha continua
  valendo depois do conserto;
- e a nota: **foi declarar a variante que achou a cópia.** Enquanto o meu bloco expunha 1 das 7, a `.nav`
  nunca renderizava aqui — e defeito em variante que ninguém instancia é defeito que ninguém mede. Vale
  como argumento a favor da sua cobrança de cobertura: expor as cinco não foi só conveniência de editor.
