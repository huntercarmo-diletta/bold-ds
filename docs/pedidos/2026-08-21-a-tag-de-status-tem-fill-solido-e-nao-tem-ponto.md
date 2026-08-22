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

## VEREDITO · o PONTO entra; o FILL espera, com a condição escrita
**pai**: ds-diletta **v0.143.0** · **data**: 2026-08-21

| item | veredito | o que é |
|---|---|---|
| **o ponto** | **ENTRA** | `DilettaStatusTag(ponto: true)` — disco de 6 na tinta do tom, mesmo eixo do `icon` |
| **o fill em gradiente** | **ESPERA** | condição escrita abaixo; a razão é de TIPO, não de gosto |

### O que decidiu
No ponto, a sua frase, e ela é a melhor do lote de hoje: **"o ponto não tem glifo: ele é estado, não
coisa."** Você recusou desenhar um círculo como ícone e escreveu por quê — *inventar um glifo pra não pedir
um campo* poria no kit um símbolo que não simboliza nada. Isso não é pedido de peça, é higiene de
vocabulário, e é o tipo de coisa que eu não teria como medir daqui.

Você também leu o mecanismo certo antes de pedir: o `pending` já traz o próprio glifo vindo do tom, então o
caminho do acessório existia — só era estreito. O eixo continua sendo **UM**: passar `icon` e `ponto`
juntos é `AssertionError`, não escolha. A caixa fica em 12 nos dois casos, pela razão que você não escreveu
e eu medi: se o ponto encolhesse a caixa, o rótulo andaria 6px entre uma tag com glifo e a vizinha com
ponto — e é lado a lado que os seus cinco aparecem.

Um custo que fica dito porque é seu de pagar: **no `pending` o disco vence o relógio**, igual ao que `icon`
já fazia. Como `pending` e `neutral` pintam igual de propósito (v0.27.0: matiz pra espera competiria com o
juízo sobre o desfecho), uma fileira que troca o relógio por disco perde a distinção entre *esperando* e
*sem estado*. Na sua fileira de quatro, `Pendente` com o relógio e as outras três com disco é o que a
linguagem sabe dizer. Se isso doer no desenho, é pedido novo — e ele é sobre a espera, não sobre a tag.

### O que eu achei indo implementar
O disco existe no vocabulário do terceiro filho como peça própria: `Active dot` com `Size=4px/8px/12px`. O
seu 6 não está lá — e não vou promover degrau de disco por causa disso, porque o `Active dot` dele vive na
célula de calendário, não em tag. Registro porque muda o que a próxima medição procura: **quando o segundo
sítio de disco aparecer, a pergunta é se ele é o mesmo disco.**

### O que eu recusei, e a condição de reabrir
- **O fill em gradiente.** A razão é de tipo, e você a antecipou: `DilettaPintura.bg` é `Color`, e **seis
  peças** leem essa struct. Trocar o tipo por `Gradient` move todas por uma decisão de redesenho de um
  produto — e a sua própria seção «Derivável?» aponta a saída boa (declaração de paleta, no molde do
  `tinteDeVidro`), que é exatamente o que não se faz com um caso.
  **Reabre no segundo filho que medir fill não-liso em tag**, e aí entra como declaração de paleta, não
  como parâmetro. **1º caso registrado no ledger.**
- Não confunda com recusa de mérito: o resto da sua tag bate no meu em tudo (altura 20, padding 4/8, borda
  0.5, `labelSm` 11, e o tom já é o meu enum). Você está a um alfa de distância de fechar a casca.

### O que você faz
`ref: v0.143.0`. Os 2 sítios com ponto passam a `ponto: true`. Os outros 3 já delegavam. A casca não fecha
hoje, e o que a segura é UMA coisa com nome: o gradiente. Escreva isso no seu inventário com o número dos
dois lados — *"a tag tem N primitivos por causa de um alfa no topo"* —, que é a forma da frase que faz a
condição de reabrir ser verificável daqui a três meses.
