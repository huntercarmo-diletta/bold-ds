# PEDIDO · a tag de status tem fill SÓLIDO onde o desenho pede gradiente, e não tem PONTO

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.141.0 (você já está na v0.142.0) · DS filho v0.66.0
- **bloqueante?**: sim pra a casca fechar. Os dois itens são independentes — pode entrar um só.

## Falta

**1 ·** fill em **gradiente** na `DilettaStatusTag` (hoje `color: t.bg`, sólido).
**2 ·** o **ponto** antes do rótulo, no lugar do glifo.

## Número

**5 sítios** de `BoldStatusTag` no app, e **2 deles usam o ponto** (`dot: true`) — as tags de estado
de operador: Ativa · Pendente · Rejeitada · Cancelada.

O fill do meu é o do Figma Redesenho v.01: **branco a 37–42% → wash do tom**, de cima pra baixo. O
seu é o wash sólido. Nos 5 sítios a diferença aparece: a pill do meu tem o topo levemente
translúcido, e é isso que a separa de um chip cheio na mesma linha.

O resto bate: altura **20** nos dois, `padding` start 4 / end 8 nos dois, borda **0.5** nos dois,
rótulo `labelSm` 11 nos dois. O tom já é o seu — `DilettaStatusTone`, 7 valores, e eu consumo o enum
desde que ele existe.

## Já tentei

**1 · Passar `icon:` no lugar do ponto.** Glifo de 8px onde o desenho pede um disco de 6px é outra
forma, e o ponto **não tem glifo**: ele é estado, não coisa. Um círculo desenhado como ícone seria
inventar um glifo pra não pedir um campo.

**2 · Aceitar o fill sólido.** Funciona e é o que eu faria se o gradiente fosse enfeite. Não é: nas
telas de operador a tag aparece dentro de card sólido, e sem o topo translúcido ela lê como botão.

## Conferi no pai

- o `pending` **já traz o próprio glifo** (`clockLight`) vindo do tom, e não de quem chama. Isso é
  exatamente o mecanismo que o ponto pediria: o tom decide o acessório. O caminho existe;
- o `///` diz *"opcional icon accessory 12px à esquerda"* — o eixo do acessório é UM, e ele é glifo;
- o `DilettaPintura` que resolve o tom carrega `bg` como `Color`. Gradiente ali é mudança de tipo, e é
  por isso que eu não trato os dois itens como um: o ponto é campo novo, o fill é troca de tipo.

## Derivável?

O **fill** talvez: se ele virar declaração da paleta (como `tinteDeVidro`), eu declaro o meu e ninguém
mais mexe. O **ponto** não.

## Se você disser não

Os 2 sítios do ponto ficam embrulhados aqui e a casca não fecha — e eu escrevo no inventário que a
tag tem 4 primitivos por causa de um disco de 6px e de um alfa no topo.
