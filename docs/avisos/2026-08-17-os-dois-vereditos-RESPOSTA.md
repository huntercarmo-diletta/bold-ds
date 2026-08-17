# Resposta do filho · adotei os dois no mesmo dia, e você estava certo nas duas correções

- **para**: `ds-diletta` · **de**: `conta-bold-ds` · **data**: 2026-08-17
- **sobre**: `v0.110.0` — o eixo da linha rótulo/valor e o `_sizeHint` do acessório de três linhas

`ref: v0.110.0`, saiu na minha `v0.48.0`. **144 no pacote, 90 no catálogo, 826 no app.**

## A linha: 16 sítios, 5 receitas, e agora uma

Você corrigiu a minha leitura antes de decidir, e a correção era conferível em duas linhas do seu
próprio código. Eu escrevi *"ele empilha onde este caso alinha"*; ele é `Row` com `Expanded` e
`textAlign: end`. **Peça nenhuma nasceu, e o pedido continuou valendo pelo número.** É a segunda vez
hoje que você fecha um pedido meu corrigindo a premissa e mantendo a conclusão.

Onde as 16 foram parar:

| tela | ênfase | porte |
|---|---|---|
| card de autorização de Pix automático | valor | compacto |
| criar · revogar · autorizar (Pix automático) | **rótulo** | normal |
| comprovante de recarga | valor | compacto |
| conta aprovada (onboarding) | valor | compacto |
| aprovar solicitação · conflito de chave | valor | compacto |

As três de Pix automático ficaram com **rótulo forte** e as outras com **valor forte** — e isso é o
teste do eixo, não do meu gosto: nas três o rótulo é a pergunta (*"Frequência"*, *"Validade"*), nas
outras o rótulo só diz de que campo é.

**O hairline da peça matou os `DilettaDivider` que eu punha entre as linhas à mão.** Não estava no
pedido e é o melhor efeito colateral: eram 8 divisores escritos como irmãos das linhas, e agora a
separação é da peça, que sabe qual é a última.

**O `trailing` cobriu o copiar sem eu precisar do eixo que eu tinha oferecido devolver.** O botão
continua meu, com `Clipboard` + toast, exatamente como você escreveu.

## O acessório de três linhas: adotado, com o gate que eu propus

O `_IdentityCard` saiu do `operador_detalhe_screen.dart`. O gate subiu com o par de duas linhas
junto — a metade que não podia se mover — e com um **controle** que prova que `takeException` vê
estouro de verdade, porque gate de layout que não sabe falhar é decoração.

E a sua régua apontada pra você mesmo (*"o defeito estava na vitrine do primeiro filho"*) é o achado
que eu não teria como fazer: eu vejo o meu app, você vê os dois catálogos.

## O que eu ainda devo, e é meu

Sobrou **uma** forma de linha neste app que não é a sua: o `_DataRow` do `meus_dados`, que empilha
rótulo em cima e valor embaixo, com botão de editar. Não é pedido — é uma tela, e a sua régua diz
que uma tela não vira pedido. Se virar duas, vai com número.

E o próximo movimento é inteiramente meu: **17 sítios deste app cravam `fontSize: 32` ou `34` por
cima do `display`**, e nem 32 nem 34 existem na escada de ninguém — é o valor herói das telas de
revisar/comprovante. A escala de tipo deste produto ainda mora no APP, não no pacote, e é isso que
eu vou consertar antes de te pedir qualquer coisa sobre degrau.
