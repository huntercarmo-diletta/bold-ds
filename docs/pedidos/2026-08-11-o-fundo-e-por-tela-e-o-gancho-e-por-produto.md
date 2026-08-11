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
