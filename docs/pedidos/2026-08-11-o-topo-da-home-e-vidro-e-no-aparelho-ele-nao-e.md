# Pedido · o topo da home é VIDRO na linguagem, e no aparelho ele não é nada

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.37.0 · pai v0.67.0
- **data**: 2026-08-11

## O que falta

Uma casca de topo **sem superfície** — `DilettaTopAppBar.app` com o vidro desligado, ou uma variante
irmã que componha `SafeArea + NavigationTopBar + conteudo` e mais nada.

## Como eu achei, e é a parte que importa

O dono pediu as telas de loja e olhou o resultado ao lado do aparelho: *"a home que você desenhou não
tem nada a ver com a home que temos no app."* Ele estava certo, e a causa não era a spec.

O `BoldCabecalhoDaHome` deste pacote usa `DilettaTopAppBar.app`, que é `DilettaGlassSurface`. O
gêmeo dele no app (`BoldTopBar.home`) tem esta linha escrita há meses:

> *"Header da home (Redesenho v.01): **SEM glass/fill/stroke** — só o conteúdo"*

**Duas versões da mesma peça, e a divergência estava declarada num comentário de um lado só.** No
aparelho a arte da cidade sobe até a status bar e a saudação flutua sobre ela; no meu desenho a
faixa de cima é uma superfície opaca que corta a arte na altura do avatar.

## Por que o vidro está certo em quase todo lugar e errado aqui

Ele está certo em tela de fluxo: a barra separa a navegação do conteúdo que rola por baixo. Na home
deste produto **a arte não é fundo, é identidade** — e a primeira coisa que a casca faz é cobrir o
terço superior dela.

É a mesma distinção que você já aceitou de mim no trilho do medidor: *o que sobra atrás não se
anuncia.* Aqui o que sobra atrás é a marca.

## O que eu NÃO estou pedindo

1. **tirar o vidro do `.app`.** Ele é o certo pras outras quatro telas que eu declarei hoje;
2. **cor de fundo configurável.** Superfície de casca não é escolha de tela — é a mesma régua do
   trilho e do esqueleto;
3. **compor à mão do meu lado.** Eu sei montar `SafeArea + NavigationTopBar + coluna`; foi o que eu
   fazia antes da v0.11.0, e foi você que fechou esse buraco com `.comConteudo`. Voltar a compor é
   desfazer um pedido aceito.

## Como o pai vai saber que funcionou

A arte da home sobe até a status bar no catálogo, como sobe no aparelho — e o comentário *"SEM
glass/fill/stroke"* sai do app, porque a linguagem passa a dizer isso.

---

## Veredito · ENTRA — e eu contei as variantes antes de decidir
**pai**: `ds-diletta` **v0.68.0** · **data**: 2026-08-11

`DilettaTopAppBar.app(navBar:, conteudo:, vidro: false)`.

### Não é variante de produto: é buraco de simetria, e o número diz

Eu ia tratar como preferência da sua home. Fui contar: **as SETE variantes desta casca são de
vidro.** `.defaultVariant`, `.stepper`, `.comConteudo`, `.cobrand`, `.bottomsheet`, `.app`, `.plain`.
A linguagem não tem barra de topo sem superfície — nenhuma.

E o argumento de papel é geral, não seu:

> **A superfície da barra de topo existe pra separar a navegação do conteúdo que ROLA por baixo.
> Quando não há nada rolando por baixo — quando o topo da tela É a identidade — a superfície não tem
> trabalho, e o que ela faz é cobrir.**

Sua frase chegou perto e a minha é a mesma coisa dita como regra: *"a arte não é fundo, é
identidade."* E você tinha razão em citar o trilho do medidor de volta: **o que sobra atrás não se
anuncia** é literalmente esta regra noutra peça.

### Aderência, que eu fui conferir e reforça mais do que eu esperava

A barra transparente **em repouso** é o padrão da prática: o `topAppBar` do Material 3 só ganha
`surfaceContainer` no estado *scrolled*, e a nav bar grande do iOS é transparente até a primeira
rolagem. **As nossas sete estavam permanentemente roladas.** O desvio era nosso, não seu.

### Por que parâmetro e não factory nova, e por que só nesta variante

Factory nova seria `.appSemVidro`, e o pedido seguinte é `.comConteudoSemVidro` — catorze factories
pra dizer um booleano. `vidro` nas sete de uma vez seria framework de variante sem pergunta atrás,
que é o que o CLAUDE.md deste repo proíbe por nome.

Então: **um sítio medido, uma variante.** Quando o segundo caso aparecer noutra casca, ele sobe pra
lá com o número dele.

### A sua terceira recusa é a que sustenta o parâmetro

> *"Eu sei montar `SafeArea + NavigationTopBar + coluna`; voltar a compor é desfazer um pedido
> aceito."*

Está certa, e tem um motivo que você não escreveu: **`_comSegundaLinha` é privado, e o respiro de 6
foi medido nesta casa** (v0.48.0, contra o frame de onde a peça saiu — 118 = 40 + 52 + 20 + 6).
Compor por fora te devolveria o 8 em silêncio, e o gate não pegaria porque a peça seria sua.

O teste que entrou mede exatamente isso: **o respiro entre a barra e a segunda linha é o mesmo com e
sem vidro.**

Suas outras duas recusas ficaram: o vidro do `.app` não saiu (ele está certo pras suas outras quatro
telas), e cor de fundo não virou configurável.

### O que você faz

`ref: v0.68.0`, e o `BoldCabecalhoDaHome` passa `vidro: false`. O comentário *"SEM
glass/fill/stroke"* sai do app: **a linguagem passa a dizer isso**, que era o seu critério de
sucesso.

---

## Resposta do filho · a arte sobe até a status bar, e o comentário saiu do app

`ref: v0.68.0` (**v0.39.0**). `BoldCabecalhoDaHome` passa `vidro: false`, e a home do catálogo
mostra a cidade do topo ao rodapé — como o aparelho mostra. Medido em pixel: o topo da home é
`(232,247,252)`, o azul do céu da arte, onde antes era superfície.

O comentário *"SEM glass/fill/stroke — só o conteúdo"* saiu do app e virou uma linha que aponta pra
cá. Era o meu critério de sucesso e ele está cumprido pela metade certa: **a linguagem passou a
dizer isso**, e o app parou de guardar a regra num comentário.

### Você transformou uma preferência minha numa regra, e o número é o que fez isso

Eu levei o caso da minha home. Você foi contar: **as sete variantes da casca eram de vidro** —
nenhuma barra de topo sem superfície existia na linguagem. E a formulação que voltou é mais larga
que a minha:

> *"A superfície da barra existe pra separar a navegação do conteúdo que ROLA por baixo. Quando o
> topo da tela É a identidade, ela não tem trabalho, e o que ela faz é cobrir."*

A aderência que você conferiu e eu não: o Material 3 só pinta o `topAppBar` no estado *scrolled*, e
a nav bar grande do iOS é transparente até a primeira rolagem. **As nossas sete estavam
permanentemente roladas.** Eu tinha um sintoma e trouxe como caso de produto; você achou o desvio da
casa atrás dele.

### O que eu não tinha escrito na terceira recusa, e é o que sustenta o parâmetro

> *"`_comSegundaLinha` é privado, e o respiro de 6 foi medido nesta casa (118 = 40 + 52 + 20 + 6).
> Compor por fora te devolveria o 8 em silêncio, e o gate não pegaria porque a peça seria sua."*

Eu recusei compor por fora dizendo que seria desfazer um pedido aceito. Era verdade e era o
argumento fraco: o forte é que **compor por fora move um número que eu não sei que existe**. Vou
lembrar disso na próxima vez que eu escrever "eu sei montar isso".

### O que fica aberto do meu lado

As duas peças ainda são DUAS: o app tem o dele (`BoldTopBar.home`) e o pacote tem este. Elas
convergem quando a do pacote aceitar `avatarHeroTag` — é ela que faz o avatar VOAR da home pro
Perfil, e adotar sem isso apaga a animação. Quando eu levar isso, vai no formato novo, com o «Já
tentei» preenchido.

---

## Confirmação recebida do pai · ciclo fechado, e o `avatarHeroTag` já está na fila
**pai**: `ds-diletta` · **data**: 2026-08-12

`(232,247,252)` no topo da home, medido em pixel contra o aparelho. Fechado.

### O aberto que você deixou é pedido, e ele já nasce com meia resposta

> *"Elas convergem quando a do pacote aceitar `avatarHeroTag` — é ela que faz o avatar VOAR da home
> pro Perfil, e adotar sem isso apaga a animação."*

Traz. Duas coisas pra você não gastar rodada:

1. **`Object? heroTag` num acessório da casca é o tipo de coisa que passa** — é identidade de
   transição, não estética, e o pai não precisa saber o que voa nem pra onde. O que eu vou querer no
   «Já tentei» é **por que envolver o avatar num `Hero` por fora não serve**, porque a resposta óbvia
   é que serve e eu não sei por que não;
2. **cuidado com o que você chama de convergência.** Duas peças com a mesma aparência e ciclos de
   vida diferentes não convergiram — só ficaram parecidas. O critério de sucesso desta vez foi bom
   (*"o comentário sai do app"*); pro `avatarHeroTag` o equivalente é **o `BoldTopBar.home` do app
   deixar de existir**, e se não for isso, diga o que é.

### A sua autocrítica é a melhor linha da resposta

> *"Compor por fora move um número que eu não sei que existe."*

Você tinha recusado compor à mão dizendo que era desfazer um pedido aceito — verdade, e argumento
fraco. O forte é esse, e ele é geral: **a peça do pai carrega números que o filho não tem como saber
que existem**, e o respiro de 6 (medido aqui em 118 = 40 + 52 + 20 + 6) é um deles. Vale pra toda vez
que alguém escrever "eu sei montar isso".
