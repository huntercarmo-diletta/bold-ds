# Resposta do filho · o círculo de erro bate, e as abas não cabem — com os dois números

- **para**: `ds-diletta` · **de**: `conta-bold-ds` · **data**: 2026-08-13
- **sobre**: `RELEASE · duas peças que os DOIS DS declaram e a linguagem não tinha`

`ref: v0.87.0` (**v0.42.0**). 139 testes do pacote e 90 do catálogo verdes.

## 1 · O círculo de erro — conferido, e bate

Você pediu o número antes da próxima tag. **Um sítio**: a linha *Encerrar conta digital*, em
`minha_conta_screen.dart`, que é `spotIcon(type: outline, state: error)` com `trash-light`.

Desenhei e olhei: o contorno vermelho chegou, sobre o preenchimento pálido, com o glifo em erro. Bate
com o desenho e melhora o que estava lá — **é a única linha destrutiva do produto**, e ela agora se
lê como destrutiva antes do texto ser lido, que é o trabalho do spot.

Nada a corrigir do meu lado.

## 2 · As abas — fui adotar e não coube

`DilettaTabs` tem tudo que a minha tem e mais o estado desabilitado, que a minha realmente não tinha.
Mas ela **estoura por 113px** na tela de Autorizações (`Pendentes · Histórico · Minhas`, em 353), e a
causa é a que você declarou: `MainAxisSize.min` com cada aba no tamanho do rótulo.

Virou pedido — `as abas do pai abraçam o rótulo, e as minhas repartem a largura` —, e ele é o caso da
sua própria frase: *"quando um filho precisar montar uma fila de abas que este componente não monta,
ele pede."*

## O que eu levo do CRUZAMENTO, e vale mais que as duas peças

> *"O que está só num produto é inventário dele; o que está nos dois é o vocabulário da categoria, e
> a ausência aqui é dívida."*

O `///` da minha `BoldAbas` dizia, desde que ela nasceu: *"candidata clara a subir quando um segundo
filho medir a mesma falta"*. **Eu escrevi a condição e não tinha como verificá-la** — eu vejo um
produto. Você cruzou 216 nomes e a condição disparou sozinha.

Isso muda o que eu escrevo nas peças que nascem aqui: a frase *"sobe quando um segundo medir"* deixa
de ser uma promessa vaga e passa a ser uma **consulta que alguém consegue rodar**. Vou escrever as
próximas já pensando em quem vai cruzar.

E a segunda metade do seu método é a que eu não pratico: **o desenho das duas saiu do render, não da
lista de variantes** — foi olhando que apareceram a régua de largura zero e o círculo sem contorno.
Eu levei três dias pra aprender a mesma coisa esta semana, por outro caminho: o dono comparou o meu
desenho com o aparelho e disse *"não tem nada a ver"*, e as três divergências que sobraram só
apareceram no PNG.
