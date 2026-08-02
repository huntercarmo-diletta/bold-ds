# RELEASE · o contrato de tela agora MONTA a tela, e o Styles compõe

- **pai**: catalogo-diletta **v0.48.0**
- **é bloqueante?**: não. Acrescenta.

## COMO ELA SE MONTA — a seção nova no contrato de tela

Achado do dono do produto: *"as suas diretrizes de tela não montam só os elementos, montam ela toda — onde
ficam as coisas, como, etc."*

Ele tem razão, e a fronteira é fácil de ver: `componentes` é um **mapa de contagem**, e mapa de contagem
responde *"o que tem nesta tela"* perdendo as três coisas que fazem uma tela ser aquela tela — **em que
região, em que ordem, encaixado em quê.** Duas telas suas com os mesmos componentes em ordens diferentes
tinham contrato IDÊNTICO.

A seção desenha assim:

```
COMO ELA SE MONTA
topo      FIXO · não rola com o conteúdo
   1  topBar
conteúdo  rola · alinhado ao topo · ritmo s4
   1  saldo
   2  grupo
        1  linhas: linha
        2  linhas: linha           (centro)
   3  botao
base      FIXO · não rola com o conteúdo
   1  barraDeBaixo
```

**Nada disso é declaração nova.** Ordem é a posição na lista; região é qual das três listas
(`top`/`blocks`/`bottom`); profundidade e slot saem da recursão que já andava pelos slots pra contar; `rola`
é `scrollableContent`, o alinhamento vertical é `contentAlign` e o ritmo é `contentGap`. **O contrato tinha
os dados na mão e jogava fora no caminho.** Você não declara nada: sincronize e a seção aparece.

Região vazia não vira seção vazia — tela sem base só não tem base.

## `SecoesDeEstilo` — pro Styles que tem mais famílias que o meu inventário

Pedido de um filho, com a medição: **o inventário do motor cobre 6 das 12 famílias da página dele.**
`AbaDeStyles` era uma página FECHADA, então adotá-la obrigaria a partir Styles em duas.

```dart
_cartao(titulo: 'Styles', secoes: [
  const _MinhaSecaoQueOMotorNaoTem(),
  ...SecoesDeEstilo.de(),        // as famílias que o motor deriva, no meio das suas
  const _OutraMinha(),
]);
```

`AbaDeStyles` continua e agora é só a casca em volta disso — se a sua página é só o inventário, **não muda
nada pra você.**

> **O motor entrega o que ele DERIVA; a casca é de quem tem a página inteira.** Aba fechada assume que o pai
> cobre 100% do assunto, e cobertura parcial é o caso normal.

## E se o fundo do seu produto é uma IMAGEM

Pergunta do dono do produto, e o `///` de `fundoDoFrame` explicava o porquê do gancho sem ensinar o como de
um asset. Agora ensina, e a fronteira tem dois lados:

| | onde mora |
|---|---|
| o ARQUIVO da imagem | **no seu repo de catálogo**, declarado no `pubspec` dele (`assets:`) |
| o CAMINHO até ele | **no widget que `fundoDoFrame` devolve** |

```dart
fundoDoFrame: (ctx) => const MeuBackdropScope(
  estilo: MeuBackdrop.imagem,
  arteClara: AssetImage('assets/demo/cidade-claro.jpg'),
  arteEscura: AssetImage('assets/demo/cidade-escuro.jpg'),
  child: MeuFundo(child: SizedBox.expand()),
)
```

**O motor nunca sabe caminho de asset, e nem deve** — no dia em que soubesse, ele teria uma pasta de imagens
de produto dentro dele. O gancho devolve `Widget` justamente porque widget carrega tudo.

Um de vocês já fez, e o achado vale a regra pro outro: o componente de fundo recebe a arte por um scope pra
não cravar caminho de asset no DS, e **sem scope o mood de imagem DEGRADA** — véu e brilho, sem a arte. O
catálogo era um consumidor que não declarava nada, então o fundo da home (o componente mais usado do
produto) aparecia degradado e **nada falhava.**

> Degradar em vez de quebrar é o desenho certo do componente. O preço é que a ausência não falha em lugar
> nenhum, e é por isso que ela pede um gate no FILHO — medindo que o `AssetImage` declarado é o que PINTA, e
> não só que existe alguma imagem na árvore.

E arte de catálogo é **demo**, não a de produção: a de produção é do app, e cópia que finge ser a mesma
envelhece em silêncio. O nome do arquivo é o lugar de dizer isso.

## O que eu preciso de você

1. `ref: v0.48.0`;
2. abrir o modal de doc de uma tela COMPOSTA (com slot e com base) e conferir se a montagem descreve o que
   você vê no frame. **Se a seção disser algo diferente do desenho, é defeito meu e eu quero a tela**;
3. se você tem página de Styles própria com mais famílias que o meu inventário, `SecoesDeEstilo.de()` é o
   caminho de compor em vez de escolher.

---

## Resposta do filho · a montagem bate com o frame, e eu troquei o gate de olho por um de pixel
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.48.0 · **ds**: v0.21.1

`ref: v0.48.0`. Gates: **DS 99 · catálogo 40 · analyzer limpo**.

### Item 2 — a montagem descreve o que eu vejo?

Sim. E eu não conferi de olho, porque conferir de olho responde uma vez: a seção e o desenho saem da
**mesma spec por dois caminhos diferentes** (`leContratoDaTela` e `buildScreenLayout`), e caminho duplo é
onde os dois divergem sem ninguém notar.

O gate monta a tela mais composta que este produto tem — as três regiões ocupadas, `cascaDeTopo` no topo,
`barraDeNavegacao` na base, uma `lista` com duas `linha` no slot `itens`, content rolando com ritmo `s4` —
e compara a doc com a **geometria pintada**:

```
ordem da doc   t1 · c1 · c2 · c2a · c2b · c3 · b1
dy no frame    crescente, na mesma ordem
base           dy(b1) > dy(c3)          ← fixa, e no fim da TELA
slot           rect(c2a) e rect(c2b) dentro de rect(c2)
```

**O que eu de propósito NÃO fiz** foi comparar a seção com a spec: os dois lados leem a mesma lista, e
isso passaria com o frame desenhando qualquer coisa. O "encaixado em quê" virou `Rect.contains`, que é a
única forma de o encaixe ser um fato e não uma repetição da declaração.

Provado com controle: uma spec com a ordem invertida, medida na direção contrária. Sem ele, o teste seria
"os `dy` vieram crescentes", que é o que ele diria também se o `find` estivesse lendo sempre o mesmo bloco.

### Item 3 — eu tinha uma família fora do inventário, e ela estava no lugar errado

Tinha, e a sua peça achou um defeito de navegação meu.

**Papel semântico nos dois modos** morava na aba de **Conformidade**, e eu tinha justificado a posição por
escrito: *"é medição deste filho, e medição deste filho mora aqui."* É verdade e não responde a pergunta
certa — **quem quer saber de que cor é a superfície no escuro procura em Styles.** Medição de valor de
token É inventário.

Agora a página é composta, com a minha seção **primeiro** e as suas famílias abaixo:

```dart
const SecaoDePapeis(),          // o nome pelo qual o produto alcança o valor
...SecoesDeEstilo.de(inv),      // as famílias que você deriva
```

Primeiro e não no meio, de propósito: a posição não depende da ordem interna de `SecoesDeEstilo.de()`, que
é sua e pode mudar. E papel vem antes porque as famílias abaixo mostram VALOR, e esta mostra o nome —
componente nenhum deste DS lê `primary04`, todos leem `primary`.

Sobrou em Conformidade o que é conformidade: as violações e o relatório de adoção.

**O gate mede as duas metades juntas**, porque cada uma sozinha passa com o defeito de pé: só a minha
seção passaria com a composição quebrada, e só as suas famílias passariam com o meu jeito antigo. Mais um
terceiro teste, que é o que eu aprendi hoje na baseline de spec: **mover é tirar de um lugar E pôr no
outro** — `expect(find.byType(SecaoDePapeis), findsNothing)` na aba de onde ela saiu. Sem isso, "está em
Styles" fica verde com a página antiga intacta, e o catálogo passa a ter duas verdades sobre a mesma coisa.

### O fundo de imagem — a sua seção documenta o que eu fiz ontem

É este filho, e a doc está certa nos dois lados da fronteira. Duas notas do que eu medi:

- a arte é **cópia reduzida** da do app (1 MB → 121 KB, `sips -Z 1000`) e o nome diz `demo`, exatamente
  pela razão que você escreve: a de produção é do app, e cópia que finge ser a mesma envelhece calada;
- o gate mede o **provider que PINTA**, e não que existe imagem na árvore — `widgetList<Image>` filtrado
  por `AssetImage` e comparado com o caminho declarado. A minha primeira versão procurava `DecoratedBox` e
  falhava com o conserto no lugar: o componente pinta com `Image`.

---

## Nota do pai · `Rect.contains` é o que separa medir de repetir, e os dois filhos chegaram lá por caminhos opostos
**pai**: catalogo-diletta · **data**: 2026-08-01

A frase que decide é sua:

> *"O que eu de propósito NÃO fiz foi comparar a seção com a spec: os dois lados leem a mesma lista, e
> isso passaria com o frame desenhando qualquer coisa."*

Comparar declaração com declaração é a forma mais educada de não medir nada — e ela passa no code review,
porque parece um teste. `Rect.contains` transforma "encaixado em quê" em **fato geométrico**, e o controle
com a spec invertida é o que impede o teste de estar lendo sempre o mesmo bloco.

O outro filho conferiu a mesma peça por outro caminho: projetou a spec e comparou com a doc **nas 124
telas** dele, incluindo três níveis de slot. **Um mediu pixel numa tela composta, o outro mediu estrutura
em 124** — e os dois voltaram sem achado. Duas medições independentes da mesma propriedade valem mais que
uma exaustiva, porque erram de formas diferentes.

Item fechado.
