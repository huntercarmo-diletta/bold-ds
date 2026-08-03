# Pedido · o brilho do esqueleto é neutro, e o deste produto é ROSA

- **filho**: conta-bold-ds v0.9.4
- **pai**: ds-diletta v0.33.0 (`DilettaShimmer`, `DilettaSkeleton`)
- **é bloqueante?**: **não**. O esqueleto carrega e some; o custo é de identidade, e é o terceiro caso da
  mesma classe hoje

## O que falta

`DilettaShimmer` varre com dois valores fixos:

```dart
colors: [
  s.palette.neutral10.withValues(alpha: 0.5),
  s.palette.white.withValues(alpha: 0.1),
  ...
]
```

Neutro, cravado. O deste produto era **rosa** — `primary07` a 72%, com a razão escrita no widget que a
adoção apagou:

> *"Banda de brilho no PRIMARY claro (primary-07) — combina com a marca; base branca translúcida guia o
> resto."*

## A medição

| lado | número |
|---|---|
| esqueletos no app | **35**, em 14 arquivos |
| o que o app pintava | `primary07 @72%` sobre base branca @18% |
| o que o pai pinta | `neutral10 @50%` → `white @10%` |
| onde isso aparece | toda tela que carrega: home, extrato, autorizações, usuários, notificações |

E o relato que abriu isto, do dono do produto olhando o app no simulador:

> *"o skeleton tem um shimmer rosinha, agora só é o frame cinza"*

**Ele reconheceu a marca pela ausência dela.** O esqueleto é a primeira coisa que a tela mostra, em toda
tela que espera dado — é o momento em que o produto tem menos conteúdo e mais identidade por pixel.

## Por que eu não resolvo sozinho

Mesma fronteira dos dois pedidos de ontem, e o seu veredito do vidro já nomeou a regra: *"a receita é do
filho, a construção é do pai"*. Eu não posso pintar o brilho por fora — o gradiente mora dentro do
`ShaderMask` do seu widget, e envolvê-lo daqui não alcança o shader.

Reconstruir o shimmer no filho seria cópia de componente do pai, que é o que esta família não faz — e foi
exatamente o que a adoção **desfez** neste caso: o `BoldSkeleton` era a cópia, e ela morreu com razão.

## O que eu peço

**A cor do brilho vira declaração do produto**, no mesmo lugar e com a mesma forma do `cardDeVidro`:

```dart
DilettaPalette(… brilhoDoEsqueleto: BoldColors.primary07)   // nulo ⇒ o neutro de hoje
```

Nulo mantendo o comportamento atual é o que faz isto não cobrar nada de quem não pediu — a mesma escolha
que você fez no `tinteDeVidro`, no `blurDeVidro` e no `tracoDeVidro`.

**Se a resposta for "o brilho é neutro na linguagem"**, eu aceito e quero a frase — igual à do
`NoticeBanner` e à do `FeatureDetailCard`. Aí eu registro a divergência no meu lado e paro de pedir.

## Uma observação sobre a CLASSE, que é o que me interessa aqui

Este é o **terceiro** pedido de material em dois dias: o card de conteúdo (vidro), o cartão de destaque
(vidro) e agora o brilho do esqueleto. Os três têm a mesma forma — *a construção é sua, e o valor que ela
usa é do produto* — e os três só apareceram quando um produto de fundo escuro e marca forte adotou a
linguagem.

Não é pedido, é leitura: talvez o que esteja faltando não seja o terceiro campo, e sim a **pergunta** feita
uma vez — *quais valores desta construção são do produto?* Você respondeu isso pro vidro em três campos
(tinte, blur, traço). O shimmer tem um. O `FeatureDetailCard` tem um gradiente. Se algum dia isso virar uma
regra de contrato — *"construção que pinta com cor de paleta declara de quem é a cor"* —, ela vale mais que
os três campos somados.

## O que eu já fiz do meu lado

- os 35 esqueletos foram **embrulhados em `DilettaShimmer`** (7 grupos e 10 soltos): a adoção tinha trazido
  a forma e deixado a animação, porque o `BoldSkeleton` era as duas coisas numa peça só e o seu `///` diz
  claramente *"não anima sozinha"*. Isso já está no app, e o brilho voltou — **neutro**;
- gate de fonte novo: **todo `DilettaSkeleton` tem um `DilettaShimmer` acima**. Esqueleto solto compila,
  roda e não avisa — é caixa cinza parada, e nada falha.
