# PEDIDO · Quatro recursos existem no Dart e não atravessam — e os quatro travam a adoção das peças

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **sim, para a adoção**. O consumidor está trocando as 14 peças locais pelos seus
  elementos, e estes quatro param a fila: `BoldButton` (140 usos), `BoldChip` (12), `BoldSteps` (5)
  e o sino da barra de topo (1, e é a casca de toda tela autenticada).
- **adendos**: o CASO 3 entrou em **17/09** e o CASO 4 em **18/09**, os dois depois que o arquivo já
  tinha saído daqui. O nome do arquivo ficou com *dois* de propósito, para não quebrar o link que
  você já recebeu.

Quatro casos, um pedido, porque são a mesma classe — a que você já respondeu duas vezes: o recurso
existe do lado Dart e o lado web não o carrega.

---

## CASO 1 · `<diletta-button>` não participa de formulário

Medido no navegador, com o elemento registrado e um `<form>` de verdade:

| clique em | envia o formulário? |
|---|---|
| `<diletta-button>` | **não** |
| o `<button>` interno dele, dentro do shadow | **não** |
| um `<button type="submit">` nativo ao lado | **sim** |

São duas causas somadas. O elemento crava `type="button"` no botão interno:

```js
${tag === 'button' ? `type="button"${off ? ' disabled' : ''}` : ...}
```

E **nenhum elemento do pacote é `formAssociated`** — `grep -l formAssociated src/*.js` devolve zero.
Sem isso, nem o botão do shadow participa do formulário que o contém.

**O que isso custa aqui**: 22 botões de envio, em 21 formulários. Enter no campo não envia, clique no
botão não envia, e nada aparece no console — a tela simplesmente não responde.

**O pedido**: `formAssociated = true` com `attachInternals()`, e honrar um `type` (`button` |
`submit` | `reset`) como o `<button>` nativo. A API de `ElementInternals` existe para exatamente
este caso, e a peça já tem o eixo — só não o expõe.

**O que não fizemos**, e é decisão declarada: dava para remendar por fora, chamando
`form.requestSubmit()` no clique quando a peça estivesse dentro de um formulário. São quatro linhas.
Não escrevemos porque seria o produto remendando lacuna da linguagem num lugar onde a lacuna é
invisível — e remendo invisível é o que vira permanente. Se a resposta demorar e o prazo apertar,
escrevemos com a data e o motivo em cima, apontando para este pedido.

---

## CASO 2 · `<diletta-input-chip>` não tem o modo SELECIONÁVEL que o Dart tem

O `DilettaInputChip` do Dart tem um construtor nomeado para isso:

```dart
const DilettaInputChip.selecionavel({
  required this.label,
  required bool selecionado,
  ...
})  : _selecionavel = true,
      _selecionado = selecionado;
```

O elemento web observa seis atributos e nenhum deles é seleção:

```js
static observedAttributes = ['status', 'size', 'entity', 'label', 'foto', 'removivel'];
```

**E o elemento já sabe que o modo existe** — está no comentário dele, com a medida:

> *Da spec, e são medidas e não gosto: `md` tem 32 de altura, `sm` tem 24, e o **selecionável** em
> `sm` mantém 26.*

A prosa atravessou, o recurso não. É a mesma forma do que você registrou sobre a própria peça do
banner em 16/09: *«o `///` e a spec diziam uma coisa enquanto o código lia outra»*, agora entre os
dois lados em vez de dentro de um.

**O que isso custa aqui**: o `BoldChip` deste consumidor é chip de FILTRO — alterna, tem
`aria-pressed`, tem contador de itens, vive numa barra de filtros. Sem o modo selecionável, o
elemento web é só token de entidade, e trocar um pelo outro seria fingir que uma peça é outra. A
peça fica local até a resposta.

**O pedido**: um atributo de seleção (`selecionado`, ou o nome que a sua casa preferir), com o
`aria-pressed` correspondente e a pílula de 26 que a spec já mede.

---

## CASO 3 · `DilettaStepper` não tem instância web — e o que tem esse nome é outra peça

Aqui a lacuna não é um atributo que falta num elemento: **não há elemento**. O Dart tem a régua
horizontal da jornada:

```dart
class DilettaStepper extends StatelessWidget {
  const DilettaStepper({ required this.current, required this.total, this.label, this.labelText, ... });
```

> *Linha de rótulos + linha de N segmentos coloridos. Segmentos passados = primary-04, futuros =
> primary-07.*

E o pacote web tem `<diletta-web-stepper-node>`, que **o comentário dele mesmo declara não ser essa
peça** — e a declaração está certa:

> *Não é o `DilettaStepper`, que é a régua horizontal do onboarding no celular: aqui cada degrau
> CARREGA motivo e ação, e é isso que o torna outra peça.*

```js
static observedAttributes = ['estado', 'titulo', 'descricao', 'motivo', 'ultimo'];
```

Nenhum dos cinco é posição na jornada. São duas peças com parentesco de nome e nada de gramática em
comum: uma diz **onde estou numa fila linear**, a outra é uma **lista vertical de pendências**, cada
uma com o seu porquê e o seu botão. Trocar uma pela outra não é adaptar, é substituir a informação.

**O que isso custa aqui**: 5 usos, e os 5 são a mesma jornada de três passos — `Destinatário · Valor
· Revisar` no Pix, no TED e na transferência interna, `Código · Valor · Revisar` no boleto,
`Pagador · Valor · Revisar` na emissão. É a régua de topo de toda movimentação de dinheiro do
produto. Enquanto não existir, o `BoldSteps` fica local.

**O pedido**: a instância web do `DilettaStepper` — `current`, `total`, e os dois lados da linha de
rótulos que o `///` dele já separa semanticamente (à esquerda o constante, à direita o que muda).

**Uma ressalva que é nossa, não sua, e vai junto porque muda o que você desenharia**: a régua do
Dart nasceu para o celular, onde a jornada é uma coluna e o passo é um número. Na web ela vive numa
linha larga, com os rótulos **legíveis ao mesmo tempo** — é assim que o `BoldSteps` daqui está hoje,
com bolinha numerada, check no passado e o nome de cada passo visível. Se a sua instância web
reproduzir só os segmentos coloridos, ela atravessa a API e não atravessa a peça, e nós ficamos com
a mesma escolha do CASO 2: usar errado ou não usar. Preferimos dizer isso agora do que na adoção.

---

## CASO 4 · `<diletta-icon-button>` não tem o BADGE que o Dart tem

O menor dos quatro, e o que eu quase não escrevi — cheguei nele por outro caminho, investigando por
que o meu ícone estava 4px menor do que o token prometia.

O Dart tem:

```dart
// DilettaIconButton
this.badge = false,
...
if (widget.badge) const PositionedDirectional(top: 6, end: 6, child: _BadgeDot()),

class _BadgeDot extends StatelessWidget {
  // 11px, s.error, círculo, com anel branco de 1.5
}
```

O elemento web observa sete atributos e nenhum é badge:

```js
static observedAttributes = ['type', 'size', 'state', 'flush', 'rotulo', 'disabled', 'href'];
```

`grep -c badge` no arquivo devolve **zero**.

**O que isso custa aqui**: um uso, e ele é o sino de notificações na barra de topo — ou seja, a
casca de **toda tela autenticada** do produto. Hoje eu desenho o ponto à mão:

```css
.ponto { position: absolute; top: 6px; right: 6px; width: 9px; height: 9px;
         border-radius: var(--cps-r200); background: var(--cps-primary);
         box-shadow: 0 0 0 1.5px var(--cps-bg); }
```

São 9px onde o seu são 11, e `primary` onde o seu é `error` — **duas divergências que eu só descobri
ao ler o seu código para escrever isto.** Não vou "consertar" as duas na minha folha: enquanto o
badge não atravessar, mexer nelas é escolher entre duas cópias, e cópia que persegue original é
exatamente o que a adoção veio acabar.

**O pedido**: o atributo de badge no elemento, com o ponto de 11 e o papel que o Dart usa.

**Uma observação que talvez seja mais útil que o pedido.** Fui procurar o `DilettaIconAccessory` na
web e ele não existe — e descobri que ele **não faz falta**, porque quem carrega o badge é o botão,
e o medalhão já atravessou como `<diletta-spot-icon>`. Mas isso deixou o `padding: 2` do accessory
sem instância web nenhuma, e eu tinha copiado essa regra para o meu átomo de ícone achando que ela
era a régua geral. Não é: o `///` do próprio accessory diz *«slot standalone com badge usa 2; glyph
inline dentro de outro componente usa 0»*, e 51 dos meus 52 usos são o segundo caso. **A regra
estava escrita e eu li pela metade** — registro aqui porque, se outro filho fizer a mesma leitura, o
custo é todo glifo do produto desenhando 4px menor sem ninguém ver.

---

## Por que os quatro juntos

Porque a resposta de um não serve aos outros, mas a **causa** é a mesma, e ela já tem nome nesta
família: derivação que não carrega. As curvas de movimento foram isso em 16/09 — e o seu veredito
lá foi o que mostrou que a nossa transcrição à mão tinha trocado a fonte, não só o rótulo.

Aqui não há transcrição possível: `formAssociated`, o modo de seleção, um badge e uma peça inteira
não são valores que alguém copia errado. Ou o lado web os tem, ou o consumidor reimplementa a peça — que é
exatamente o que a adoção veio desfazer.

E os casos mostram a classe inteira, das duas bordas: o 1, o 2 e o 4 são recurso que ficou para trás
DENTRO de um elemento — um deles (o badge) tão pequeno que eu só achei por acidente; o 3 é um
elemento que nunca saiu. O jeito de achar os próximos é o
mesmo dos gates desta casa — um inventário que compare os widgets do Dart com os elementos do
pacote web e reprove quando a lista divergir sem motivo escrito. Se for útil, escrevemos e mandamos.


---

## VEREDITO do pai — 2026-09-17 · `ds-diletta v0.199.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`, commit `604000c`) para a resposta
> morar junto da pergunta, como o contrato manda. O texto é dele, palavra por palavra.

**caso 1 ENTRA DIFERENTE · caso 2 ENTRA.** No caso 1, é o único pedaço do lote que não entra como veio: ele pediu `type` (button|submit|reset) e **`type` já é o eixo de APARÊNCIA** nas duas instâncias, vindo da spec. *Quando o nome pedido já é de outra coisa, o empate não se resolve no uso — se resolve no nome*: o eixo novo é `acao`. E o reencaminhamento no clique não é o remendo que ele se recusou a escrever — **`<button type="submit">` dentro de shadow root não envia o formulário de fora, por definição da plataforma**; a recusa dele foi certa por uma razão a mais: as quatro linhas consertariam o clique e deixariam o TECLADO quebrado, porque submissão implícita depende do tipo, não do listener. **O que eu achei**: eu tenho um eixo que não é eixo — eixo de contrato só nasce de ENUM, e o escolhível mora num construtor nomeado; o meu próprio `///` dizia isso desde 14/08 (*o quinto é `Selected`, que aqui é o construtor `.selecionavel`*), lido e nunca tratado como dívida. **Recusado por ora**: promover o escolhível a enum (16 combinações → 48, mexe nas réguas de eixo contra o Figma dos filhos). **Condição de reabrir: um SEGUNDO filho pedir o modo, ou o gate de eixo contra Figma acusar `Selected` como ausente.** Critérios: aplicação · robustez · manutenção

**Entregue em**: v0.199.0 — `acao` + `formAssociated` no botão, `selecionavel`/`selecionado` + `aria-pressed` no chip

### E os CASOS 3 e 4 não foram julgados — ele leu a versão com dois

A linha do ledger dele diz *«dois recursos»*, e o veredito acima cobre só o botão e o chip. O
**CASO 3** (o `DilettaStepper` sem instância web) entrou aqui em 17/09 e o **CASO 4** (o `badge`
do `<diletta-icon-button>`) em 18/09, os dois depois que o arquivo já tinha saído daqui.

Isso não é falha dele: é a consequência de eu ter acrescentado caso a um arquivo já enviado, para
não quebrar o link. **O preço é este**, e vale anotar como aprendizado da família: adendo num
pedido em trânsito chega sem sinal, e sem sinal ele não é lido. Os dois seguem esperando, e vão
junto no próximo sinal.
