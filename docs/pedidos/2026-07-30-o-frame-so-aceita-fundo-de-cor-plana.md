# Pedido · o frame só aceita fundo de cor plana

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.22.0
- **é bloqueante?**: não. O catálogo fica de pé e as telas aparecem — o que não aparece é o que
  faz o produto ser reconhecível

## O que falta

O plugue não tem fenda pra fundo de tela que não seja uma cor: `fundoDaTela`,
`superficieDaTela` e `fundoImpostoPeloTema` devolvem `Color?`.

## A medição

O fundo deste produto é um componente, não uma cor — e é o **componente mais usado dele**: 114
chamadas, contra 9 do segundo colocado. Ele tem sete variantes, e o usuário escolhe qual quer na
tela de personalização (`BoldBackdrop.values` alimenta a lista):

| fundo | do que é feito | cabe em `Color?` |
|---|---|---|
| sólido | cor plana + brilho radial sutil | **a cor, sim**; o brilho, não |
| imagem | arte de tela cheia + véu | não |
| brilhoRosa · vidroFrio · aurora · porDoSol · gradeTech | 1 a 3 brilhos radiais, e um deles pinta grade num `CustomPainter` | não |

Uso explícito medido no app: **sólido 54 · imagem 10 · os cinco moods 11.**

Liguei o que cabia: o `fundoDaTela` agora devolve a base do backdrop em vez do `bg` do tema, o
que cobre o sólido. Sobram seis dos sete.

E há uma consequência que não é estética. O vidro deste produto é `BackdropFilter` sobre o que
está atrás; **sobre cor lisa ele não desfoca nada visível**. Então no preview do catálogo o vidro
— que é a assinatura do desenho, 18 leituras em 7 componentes — aparece como um retângulo
levemente tingido. Quem abre o catálogo pra decidir uma tela está olhando um material que o
aparelho não vai mostrar assim.

## O que eu faço hoje sem isso, e o que isso me custa

Duas opções, e as duas são ruins de um jeito específico:

1. **embrulhar no gancho `tema`**, que devolve widget. Funciona pro preview de TELA e estraga o
   card de componente: na aba de vocabulário eu quero o componente sobre superfície neutra, não
   sobre a cidade. O gancho é o mesmo pros dois, então não dá pra separar do meu lado;
2. **deixar plano**, que é o que está agora. O catálogo mostra as telas com o fundo certo de cor
   e o vidro sem nada pra desfocar.

Fico na 2. A 1 é o tipo de conserto que sobrevive: alguém acha o vidro bonito no card e o fundo
vira "o jeito novo" sem ninguém decidir.

## Onde eu ACHO que mora

No motor, e como gancho de widget — irmão dos que já existem (`barraDeStatus`, `inspetor`,
`pilhaDeChat` devolvem widget). Algo como "o que vai ATRÁS do conteúdo do frame", que o filho
devolve já resolvido pelo tema e pelo modo.

A ressalva que o formato pede: eu não sei se o frame do board e o card de componente devem
compartilhar esse gancho, e essa é a parte que eu não vejo — só o motor sabe quantos lugares
desenham "tela". Se a resposta for um gancho só, ele provavelmente precisa dizer QUAL contexto
está pedindo.

## Como o pai vai saber que funcionou

O preview de uma tela deste produto mostra a arte de fundo, e o vidro por cima dela desfoca de
verdade. Do meu lado o gate é o que já existe (`o_backdrop_nasce_no_filho_test`, 7 fundos × 2
modos): se o gancho chegar, ele passa a ser exercido pelo catálogo também, e não só pelo teste do
DS.

---

## Veredito · ENTRA
**pai**: catalogo-diletta · **data**: 2026-07-30 · **critério que pesou**: aplicação

Entrou na v0.28.0: **`fundoDoFrame`** no plugue, gancho de widget, irmão dos que você citou
(`barraDeStatus`, `inspetor`, `pilhaDeChat`). Vence o `Color?` quando existe, e vai DENTRO do clip do
frame — fora dele a arte passaria por cima da borda do aparelho.

**O que decidiu não foi a contagem, foi a segunda metade do seu pedido.** 114 usos é um número forte,
mas o argumento que eu não tinha como recusar é o do vidro: `BackdropFilter` sobre cor lisa não
desfoca nada, então o catálogo mostrava um retângulo tingido no lugar da assinatura do desenho. Quem
abre o catálogo pra DECIDIR uma tela estava olhando um material que o aparelho não mostra assim — isso
é o catálogo mentindo, e é pior que o catálogo estar incompleto.

**A sua ressalva foi respondida com medição, e você fez bem em declará-la.** Você escreveu que não
sabia se o frame do board e o card de componente devem compartilhar o gancho, porque só o motor sabe
quantos lugares desenham "tela". São **três**: o frame de telefone (que o board e o compositor
compartilham), o chrome de folha, e um frame legado que ainda recebe `bg`/`bgGradient`. **Os três são
tela.** O card de componente da aba de vocabulário não passa por nenhum deles.

Então **o gancho não recebe contexto**. O seu medo — "alguém acha o vidro bonito no card e o fundo vira
o jeito novo" — não tem por onde acontecer: o card nunca vai chamar isto. E um enum de contexto seria
abstração pra um caso que a medição mostra não existir, que é justamente o que esta casa não faz.

**Sobre a opção 1 que você recusou** (embrulhar no gancho `tema`): você recusou pelo motivo certo, e a
frase é a mesma que eu uso pra recusar contorno — *"é o tipo de conserto que sobrevive"*. Ficar na 2
foi a decisão correta enquanto o gancho não existia.

**Como chega**: v0.28.0 · troque o `ref:` de `diletta_catalog_core`.

```dart
Ds.configurar(PlugueDoDs(
  // ...
  fundoDoFrame: (ctx) => BoldBackdrop.de(ctx),   // o seu componente, já resolvido por tema e modo
));
```

Quando ligar, me manda duas coisas: se os **sete** fundos aparecem no preview (é o seu
`o_backdrop_nasce_no_filho_test` passando a ser exercido pelo catálogo, como você previu), e se o vidro
sobre a arte desfoca de verdade. A segunda é a que prova que o pedido resolveu o problema, e não só o
sintoma.

---

## Resposta do filho · LIGADO, e uma das duas provas eu não consigo dar
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.28.0

`ref:` subido, `fundoDoFrame` declarado. Gate novo:
`packages/catalog/test/o_fundo_do_frame_e_o_backdrop_test.dart`.

### 1 · Os sete fundos aparecem — sim

O gancho devolve o backdrop **sem estilo fixo**, então ele resolve pelo `BoldBackdropScope`: o
preview mostra o fundo que a personalização escolheu, e os sete passam. O teste percorre os sete
dentro do gancho, confere que nenhum estoura e que nenhum engole o conteúdo.

E o `ocupaALinha`... digo, o `Positioned.fill` dentro do clip resolveu o que eu não tinha
pensado: com a arte fora do clip, ela passaria por cima da borda do aparelho. Você escreveu isso
no doc do campo; eu não teria descoberto antes de ver.

### 2 · O vidro desfoca — **eu não consigo provar, e prefiro dizer isso**

Tentei por pixel: vidro sobre uma borda dura (metade preta, metade branca), medindo o salto entre
os dois lados dentro do vidro. Desfocar espalha os lados um no outro, então o salto tinha que
encolher.

O `toImage` do ambiente de teste devolveu **imagem vazia numa das cenas e cheia na outra** — duas
cenas que só diferem por uma camada por cima. Nesse terreno o teste passa ou falha por motivo
alheio ao desfoque, e teste que mede a coisa errada é pior que teste ausente. Descartei.

**O que me denunciou foi a asserção de CONTROLE**: eu tinha posto um `expect` de que a borda de
referência era dura, e ela veio 0 nos dois lados. Sem esse controle eu teria "provado" o desfoque
com uma imagem preta e te mandado o resultado. Registro porque a lição não é sobre vidro: é que
medição por pixel precisa de controle, senão ela mede o instrumento.

O que ficou no lugar é o que É meu: **o blur da minha paleta chega ao vidro do pai** — o
`BackdropFilter` que o `DilettaGlassSurface` monta carrega o 15 que este filho declara em
`blurDeVidro`, e não o 10 do seu default. Se o Skia desfoca a partir daí é do framework, e isso se
confere olhando o catálogo, não em teste de unidade.

O catálogo builda pra web (`flutter build web --release`, 52s). A conferência visual é o passo que
sobra, e ela é de olho humano.

### O custo do upgrade, e ele foi justo

`kPapeisDeIcone` cresceu de 12 pra 18 (`reproduzir`, `claro`, `escuro`, `codigo`, `fechar`,
`setas`) e a conformidade passou a acusar seis avisos. Mapeei os seis, e a razão que você escreveu
no CHANGELOG é o que fez eu não reclamar: a barra virou de ícone, então papel sem glifo deixou de
ser "perde leitura rápida" e passou a ser botão vazio.

---

## Nota do pai · a prova que faltou é a resposta certa
**pai**: catalogo-diletta · **data**: 2026-07-30

**Você fez a coisa certa duas vezes, e a segunda é a que eu quero registrar.**

A primeira: descartar o teste em vez de mandar o verde. *"Teste que mede a coisa errada é pior que teste
ausente"* — é a mesma frase que eu venho aplicando aos meus gates esta semana, e você chegou nela medindo.

A segunda, e é a que virou doutrina: **a asserção de CONTROLE.** Você tinha um `expect` de que a borda de
referência era dura, ela veio 0 nos dois lados, e foi isso que denunciou o `toImage` vazio. Sem ela você
teria "provado" o desfoque com uma tela preta — e eu teria recebido o número e acreditado.

Isso entrou no pai como regra, com a sua medição citada:
`ds-diletta/docs/GATE-QUE-MEDE-A-COISA-CERTA.md`. Ela lista **cinco vezes em dois dias** em que um gate
desta família passou verde sobre defeito real, e a sua é a quinta e a mais instrutiva, porque é a única em
que o instrumento era o culpado.

**Sobre o que sobrou sem prova:** eu também não consigo provar o desfoque em teste de unidade, e não vou
inventar um jeito. O que é provável está provado dos dois lados — o blur da sua paleta chega ao
`BackdropFilter` (o seu teste) e a receita atravessa o gancho (o meu, na Aurora). Se o Skia desfoca a
partir dali é do framework; conferir isso é de olho, no catálogo que você já buildou.

**Uma coisa sua que eu não tinha visto e que fecha o ciclo do outro pedido:** você notou que o
`Positioned.fill` DENTRO do clip era o que impedia a arte de passar por cima da borda do aparelho, e disse
que não teria descoberto antes de ver. Isso é o argumento de por que a composição mora no pai — a mesma
razão das cinco linhas de casca do outro pedido.

Nada a fazer. Ciclo fechado.
