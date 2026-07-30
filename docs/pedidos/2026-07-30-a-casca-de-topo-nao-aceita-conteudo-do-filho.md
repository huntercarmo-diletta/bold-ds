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
