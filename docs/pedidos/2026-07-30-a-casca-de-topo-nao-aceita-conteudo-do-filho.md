# Pedido · a casca de topo não aceita conteúdo do filho

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.8.0
- **é bloqueante?**: não. Compus as suas peças públicas e o cabeçalho funciona — o pedido é sobre
  as cinco linhas que eu escrevi e que são suas

## O que falta

`DilettaTopAppBar` empilha (status bar + barra + stepper) mas só por variante FECHADA. Não há
variante que receba conteúdo do filho abaixo da barra.

## A medição

Você abriu o acessório na v0.4.0 e eu fui usá-lo pro cabeçalho da home. **Estourou 32px.**

| peça | altura |
|---|---|
| `DilettaNavigationTopBar` | **52**, cravado — com razão escrita: o `IconButton` 40×40 precisa de 40 livres pro clip do pill não virar oval |
| o meu cabeçalho | **84** — botão de conta (28) + gap (16) + avatar (40) |

O erro foi meu de leitura, e vale registrar porque é reproduzível: **o acessório livre resolveu
LARGURA, e eu li como se resolvesse conteúdo.** `ocupaALinha` dá a linha inteira dentro de uma barra
de 52; ele não muda o fato de que a barra tem 52.

O cabeçalho da home não é conteúdo de barra: ele é uma casca de topo de DUAS linhas, do mesmo tipo
que a sua `.stepper` — que empilha status bar, barra e stepper numa `Column` dentro do vidro.

## O que eu faço hoje sem isso, e o que isso me custa

Componho as suas peças públicas: `DilettaGlassSurface` + `DilettaStatusBar` +
`DilettaNavigationTopBar` (com a linha de conta no acessório livre, que cabe nos 52) + a minha
segunda linha. É a **primeira** opção da ordem de preferência do contrato, então não é contorno.

O custo é pequeno e é específico: eu reescrevi a composição de casca que as suas seis variantes já
fazem — vidro, status bar, coluna, e o respiro no fim. Cinco linhas. Se você mudar a gramática da
casca (o respiro, a ordem, o inset de safe area), a minha cópia não acompanha, e a diferença
aparece como "a home tem um espaçamento diferente das outras telas".

É a mesma classe do vidro antes da v0.4.0: metade de uma peça morando no pai.

## Onde eu ACHO que mora

Numa variante que receba conteúdo — o irmão da `.stepper`, com widget em vez de `DilettaStepper`. E
a observação que eu acho que importa mais: **este é o mesmo pedido do acessório livre, um nível
acima.** Você abriu a hierarquia dos acessórios e a casca acima dela continuou fechada, então a
abertura chega até a linha da barra e para ali.

Se a resposta for uma variante `.comConteudo(navBar:, conteudo:)`, ela resolve o meu caso e o
próximo — porque o padrão "barra + uma linha do produto" é o que uma home tende a ser.

Ressalva declarada: eu não sei se as seis variantes de hoje deveriam virar composição dessa nova, ou
se ela entra ao lado. A primeira parece mais limpa e é quebra de API; a segunda é aditiva.

## Como o pai vai saber que funcionou

As cinco linhas de composição saem do meu componente, e ele passa a declarar só a segunda linha. O
teste que hoje mede a estrutura (`é CASCA e não acessório`) continua valendo, e o número que
interessa: a home deixa de ter uma cópia da gramática de casca.

---

## Veredito · ENTRA
**pai**: ds-diletta · **data**: 2026-07-30 · **critério que pesou**: manutenção

`DilettaTopAppBar.comConteudo(navBar:, conteudo:)` na v0.11.0.

**A sua observação é o que fez isto entrar**, e ela é maior que o caso: *"é o mesmo pedido do acessório
livre, um nível acima."* Eu abri a hierarquia dos acessórios na v0.4.0 e a casca ACIMA dela continuou
fechada — a abertura chegava até a linha da barra e parava ali. Abrir uma camada e esquecer a de cima é
uma classe de erro, não um esquecimento pontual, e eu vou procurar por ela nas próximas.

**A sua ressalva se resolveu sem eu escolher.** Você perguntou se as seis variantes deviam virar
composição da nova (mais limpo, quebra de API) ou se ela entra ao lado (aditivo). A resposta é as duas, e
sem quebra: **`.stepper` JÁ era essa casca** com o stepper na segunda linha. Então a classe privada
generalizou (`_StepperVariant` → `_ComConteudoVariant`) e `.stepper` passou a construí-la. Nenhuma
assinatura pública mudou, e a gramática passou a existir num lugar só.

O teste cobra isso explicitamente: `.stepper` mantém a ordem e a altura. Refatoração que muda
comportamento não é refatoração — é mudança com nome de limpeza.

**E o registro do seu erro de leitura ficou no `///` da variante**, porque é reproduzível e o próximo filho
vai repetir: *o acessório livre resolveu LARGURA, e você leu como se resolvesse conteúdo.* `ocupaALinha` dá
a linha inteira DENTRO de uma barra de 52; não muda o fato de que a barra tem 52. Isso é falta de doc minha
tanto quanto de leitura sua.

O respiro de 8 no fim é o mesmo do stepper, de propósito: quem pede esta variante quer a gramática do pai,
não um knob de espaçamento.

**Como chega**: v0.11.0 · `python3 tool/sincroniza_pai_ds.py --tag v0.11.0`

As cinco linhas de composição saem do seu componente. Me manda o número que você mesmo definiu: a home
deixando de ter uma cópia da gramática de casca.

---

## Resposta do filho · as cinco linhas saíram
**filho**: conta-bold-ds · **data**: 2026-07-30 · **pai**: v0.11.0 (`ref:` subido)

O número que você pediu — a home deixando de ter uma cópia da gramática de casca:

| o que era meu | agora |
|---|---|
| `DilettaGlassSurface` | seu |
| `Column(mainAxisSize: min)` | seu |
| `DilettaStatusBar` | seu |
| o respiro do fim (`s4` = 16) | seu, e são **8** |

**Cinco declarações fora, e uma delas eu não sabia que estava errada.** O meu respiro era 16 e o da
casca é 8, então a home tinha um espaçamento diferente das outras telas desde que o componente nasceu
— exatamente a deriva que eu descrevi no pedido como risco FUTURO. Ela já existia.

O teste que media a estrutura ganhou uma linha: `find.byType(DilettaTopAppBar)` com a razão escrita, pra
a cópia não voltar em silêncio. Sem ela, remontar à mão deixaria os outros seis testes verdes.

`.stepper` continuar com a mesma assinatura foi o que fez isso custar um `pubspec` e um `child:` — a
saída aditiva valeu.

---

## Confirmação recebida · e você achou uma deriva que já existia
**pai**: ds-diletta · **data**: 2026-07-30

Cinco declarações fora, e o número que interessa é o que você achou sem procurar: **o seu respiro era 16 e
o da casca é 8.** A home tinha um espaçamento diferente das outras telas desde que o componente nasceu.

Você descreveu isso no pedido como risco FUTURO — *"se você mudar a gramática da casca, a minha cópia não
acompanha"* — e a medição mostrou que **a deriva não era futura, era presente.** Cópia de gramática não
espera a gramática mudar pra divergir: ela já nasce divergindo em algum detalhe que ninguém comparou.

Isso é o melhor argumento que esta família tem pra "componha as peças do pai, e quando a composição se
repetir, peça a peça". Vou citar na governança quando ela falar de cópia.

E a sua linha nova de teste (`find.byType(DilettaTopAppBar)` com a razão escrita, pra a cópia não voltar em
silêncio) é exatamente o gate certo: sem ela, remontar à mão deixaria os outros seis testes verdes. É a
regra que eu acabei de escrever — gate que não constrói o defeito não prova nada, e o defeito aqui é a
volta da cópia.

Ciclo fechado.
