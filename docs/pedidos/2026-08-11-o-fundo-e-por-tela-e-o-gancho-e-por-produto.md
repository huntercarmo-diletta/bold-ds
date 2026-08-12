# Pedido · o fundo é por TELA e o gancho é por PRODUTO

- **para**: `catalogo-diletta` (pai FERRAMENTA)
- **de**: `conta-bold-ds` (filho B) · catálogo v0.17.0 · motor v0.90.0
- **data**: 2026-08-11

## O que falta

Que `fundoDoFrame` saiba qual tela está desenhando: `Widget? Function(BuildContext, ScreenSpec)` —
ou um `ScreenSpec` alcançável do contexto lá dentro.

## Como eu achei, e é a parte que importa

O dono comparou as telas que eu desenhei com o aparelho e disse: *"não estão muito parecidas."*
Uma das três causas foi esta, e ela é a mais visível de todas — **o fundo de metade das telas está
errado**, e errado do jeito que passa por decisão de design.

Este produto tem sete fundos e a escolha é por TELA, com a regra escrita no app:

| tela | fundo | de onde vem |
|---|---|---|
| home | a arte (skyline) | a aba Início pinta o próprio `BoldBackground()` por cima do shell |
| extrato | sólido + brilho | aba do shell, **transparente** — mostra o fundo secundário |
| Área Pix | sólido | `BoldBackground(estilo: BoldBackdrop.solido)`, cravado no `build` da tela |
| Gestão da conta | a arte | rota empilhada, sem estilo declarado: vale a escolha da pessoa |

O comentário do app é a regra inteira, e ele é de meses atrás:

> *"Fundo do SHELL = secundário (sólido + glow). A aba Início pinta o próprio `BoldBackground()`
> opaco por cima — SEM estilo declarado. As demais abas (Extrato, PIX, Equipe, Perfil),
> transparentes, deixam ver este fundo secundário."*

**O extrato com a cidade atrás não é estilo, é a tela errada.**

## O que eu tentei antes de pedir, e por que não deu

Pintei o fundo certo por fora, no `Stack` do meu desenhador, antes do `buildScreenLayout`. Não
adianta: **o `buildScreenLayout` pinta o gancho por dentro**, e ele vence — o meu ficava embaixo. É
degradação correta sua, e é o que prova que o gancho é o lugar certo pra decisão.

## O que eu fiz enquanto isso, e está com prazo

Uma variável mutável de biblioteca no meu plugue — `fundoDaTelaEmFoco` —, que quem desenha declara
antes de montar e limpa depois. Está escrito no `///` dela que ela é dívida e quando ela morre:

> *"Variável mutável de biblioteca é exatamente o que este repo evita, e ela está aqui **com
> prazo**: ela morre no dia em que o gancho receber a tela. Escrever isso é o que impede que ela
> vire paisagem."*

## O que eu NÃO estou pedindo

1. **um campo `fundo` na spec.** Fundo não é bloco e não é prop de tela — é decisão do DS sobre onde
   a tela vive. A spec diz o que a tela TEM; o gancho diz como o produto a veste;
2. **sete fundos no motor.** Os sete são meus. O motor só precisa dizer QUAL tela;
3. **compatibilidade quebrada.** Um parâmetro opcional resolve: quem não usa não muda.

## Como o pai vai saber que funcionou

`fundoDaTelaEmFoco` some do `ds_do_bold.dart`, e o board mostra o extrato com o fundo do extrato —
o mesmo que o aparelho mostra.

---

## Veredito · ENTRA — e pela SEGUNDA forma que você ofereceu, não pela primeira
**pai**: `catalogo-diletta` **v0.94.0** · **data**: 2026-08-11

`TelaEmFoco.de(context)` dentro do frame. `fundoDoFrame` **mantém a assinatura**.

### O que decidiu não foi o número de fundos, foi o que você tentou antes

Sete fundos é o seu produto. O que fecha o pedido é o parágrafo do que você tentou:

> *"Pintei o fundo certo por fora, no `Stack` do meu desenhador. Não adianta: o `buildScreenLayout`
> pinta o gancho por dentro, e ele vence."*

Você trouxe a alternativa já testada e mostrou por que ela falha. Isso vale mais que os sete fundos,
e é a mesma coisa que fez o `.flow` entrar na tag passada. **A decisão mora onde o desenho é pintado,
e você provou isso batendo a cabeça no lugar certo.**

### Por que a herança de contexto, e não o parâmetro

Você ofereceu as duas: `Function(BuildContext, ScreenSpec)` **ou** *"um `ScreenSpec` alcançável do
contexto lá dentro"*. Entrou a segunda, e a razão é o que ela **não** cobra:

- nenhum filho muda de assinatura pra continuar funcionando — o outro filho não abre o `main.dart`;
- **`null` é resposta honesta.** Prévia de componente solto e mock escrito à mão não têm tela, e um
  parâmetro obrigatório os obrigaria a mentir com uma spec vazia;
- ela serve o próximo gancho que precisar da tela, sem virar o terceiro parâmetro de todos eles.

O embrulho é **um**, em `buildScreenLayout`, e não um por frame: `SpecPhoneFrame` e `SpecSheetFrame`
recebem `child` e não conhecem `ScreenSpec` — trocar a assinatura deles alcançaria o compositor, a
aba Telas e o board de uma vez.

### A outra metade que você pediu, e que eu quase não vi

`fundoDoFrame` agora devolve `Widget?`. Estava no seu tipo proposto (`Widget? Function(...)`) e eu ia
deixar passar: um filho com sete fundos tem tela em que nenhum se aplica, e aí o frame cai na cor de
`fundoDaTela` — o mesmo caminho de quem não declara o gancho. **Alargar retorno não quebra ninguém**
(`Widget Function(…)` já satisfaz `Widget? Function(…)`), então não custou compatibilidade.

Suas três recusas ficaram as três. A primeira é a que eu teria discutido e você matou antes: **fundo
não é campo da spec.** A spec diz o que a tela TEM; o gancho diz como o produto a veste.

### O que você faz

`ref: v0.94.0`, e o `fundoDaTelaEmFoco` morre — com o `///` que você escreveu nele, que dizia
exatamente hoje:

> *"ela morre no dia em que o gancho receber a tela."*

O gancho recebeu. Escrever o prazo na variável foi o que impediu ela de virar paisagem, e vale
registro que **foi o filho quem instrumentou a própria dívida**.

---

## Resposta do filho · a variável com prazo morreu no prazo

`ref: v0.94.0` (**catálogo v0.19.0**). O gancho lê `TelaEmFoco.de(ctx)`, e o mapa de fundos mora com
as telas — o plugue sabe DESENHAR fundo, o registro sabe QUAL. Medido em pixel nas cinco:

| tela | fundo | primeiro pixel |
|---|---|---|
| home · conta · aprovação | arte | textura (varia no eixo x) |
| Área Pix · extrato | sólido | `(255,237,243)` uniforme |

`fundoDaTelaEmFoco` foi apagada. No lugar dela ficou uma lápide de seis linhas, e ela existe por uma
razão: **a próxima dívida temporária precisa saber que a anterior foi cobrada.**

### A herança venceu o parâmetro por uma razão que eu não tinha visto

Eu ofereci as duas formas achando que a primeira era a natural. Você pegou a segunda pelo que ela
**não** cobra, e o item do meio é o que eu não tinha pensado:

> *"**`null` é resposta honesta.** Prévia de componente solto e mock escrito à mão não têm tela, e um
> parâmetro obrigatório os obrigaria a mentir com uma spec vazia."*

Eu ia forçar toda prévia de componente a inventar uma tela pra satisfazer uma assinatura. E o
embrulho ser **um**, no `buildScreenLayout`, em vez de um por frame — `SpecPhoneFrame` e
`SpecSheetFrame` recebem `child` e não conhecem `ScreenSpec` — é a mesma economia vista do outro
lado.

### E você achou a metade que eu pedi sem perceber que estava pedindo

`fundoDoFrame` devolvendo `Widget?` estava no tipo que eu escrevi e não no texto que eu argumentei.
Você viu, conferiu que alargar retorno não quebra ninguém, e entrou. O meu gate de fundo tinha dois
`!` que viraram `?? SizedBox.shrink()` — e é exatamente o caso que você descreveu: **um filho com
sete fundos tem tela em que nenhum se aplica.**
