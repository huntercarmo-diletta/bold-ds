# PEDIDO · O `<diletta-segmented-control>` pinta 32 e não tem o alvo de 44 que o botão, o botão de ícone e o chip já têm

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0`** (o arquivo é o mesmo nas duas)
- **bloqueante?**: **não** — o console tem a peça dele, e ela custa uma coisa que a spec da sua peça proíbe (abaixo)
- **não é peça nova**: a peça existe, e é por isso que este pedido é pequeno

## Falta

Alvo de toque de 44 no segmento, sem crescer o desenho de 32.

## Número

- `diletta-segmented-control.js:7` — `const ALTURA = 32`; o trilho é `height: 32px` com `padding: 2px`,
  então o segmento pintado mede **28**. Não há alvo fora da caixa: o `:host` é `inline-block` e mais nada.
- Na mesma tag, **três irmãs** fazem o arranjo: `diletta-button.js:28` (`const ALVO = 44`, e `:142`
  `min-height: ${ALVO}px` no hospedeiro, *«28 de botão dentro de 44 de alvo»*),
  `diletta-icon-button.js:16` e `:91` (*«32 de desenho dentro de 44 de alvo»*), e o chip, que os dois
  comentários citam como origem do arranjo.
- No console (`core-flow-wa`, `8f7d6d2`): **4 grupos** de escolha exclusiva em 3 seletores —
  `SeletorDeJanela.tsx:65`, `SeletorDeVisualizacao.tsx:70` e `:82`, `SeletorDeHoras.tsx:44` —, em
  **6 telas** (as 4 abas de Relatórios, Estatísticas e Histórico de Conversas). O ledger de adoção
  dele registra a razão, `src/design-system/adocaoDaPeca.test.ts:55`:
  *«segmented-control 4 — `aria-pressed` em grupo; a peça da linguagem não dá alvo de 44»*.

## Já tentei

**Um grupo de botões de alternância próprio**, `src/features/relatorios/ui/AtalhosExclusivos.tsx`
(um só `<button aria-pressed>` para os três seletores), com a altura no token de controle do console
(`--wa-altura-controle`, 44 — `AtalhosExclusivos.module.css:9`).

O alvo fica certo e **o anúncio fica errado**, pela régua da sua própria spec: *«Fileira de botões faz
o leitor de tela ler quatro ações independentes, e a pessoa não descobre que escolher uma desliga as
outras»* — que é exatamente o que `aria-pressed` numa fileira faz. A sua peça tem o `radiogroup`, o
`tabindex` rotativo e as quatro teclas (← → Home End); a nossa troca isso tudo por 16 pixels de alvo.
É a troca errada, e é a única que o consumidor consegue fazer de fora.

Registro um erro nosso, para não parecer que o pedido nasceu limpo: o `///` do `AtalhosExclusivos`
diz *«a linguagem não publica peça de escolha exclusiva»*. Publica, desde antes do componente existir
— a `busca('escolha')` devolve `design-system-segmented-control` em terceiro. O ledger do mesmo repo
dá a razão certa (o alvo); o comentário ficou velho.

Não tentei **crescer a peça por `::part(trilho)`** até 44: seria crescer a caixa pintada, que é o que
a `alvo-de-toque` manda evitar, e o desenho do Figma (9 instâncias, todas `247×32`, pela sua spec)
continua certo.

## Conferi no pai

- `specs/design-system-alvo-de-toque` (`v2.6.0`): *«O piso é 44 […] Em peça interativa cuja caixa
  PINTADA é menor que 44 em qualquer eixo»*, e em «Evite»: *«crescer a caixa PINTADA para resolver
  alvo»*. O segmento pintado mede 28.
- `specs/design-system-segmented-control`: `destino: web`, `labelSm` nas quatro faces, escolha única
  anunciada como grupo. Nada sobre alvo.
- `diletta-segmented-control.js` é **byte a byte o mesmo** entre `web-v2.5.0` e `web-v2.6.0` (`git
  diff --stat` vazio).

## Derivável?

Sim, e é por isso que o pedido é curto: a regra existe (`alvo-de-toque`, piso 44) e o arranjo existe
em três peças web. Falta aplicar os dois nesta.

## Se você disser não

O `AtalhosExclusivos` fica, com o anúncio de botões soltos, e o ledger do console continua com 4 crus
«decididos neste produto». O `ib`, se tiver recorte temporal, escolhe entre o alvo e o anúncio do
mesmo jeito.

## Não estou pedindo

1. **porte** (`sm`/`md`/`lg`) — a `v2.6.0` deu porte ao campo; aqui o desenho de 32 está certo e só
   falta o alvo;
2. **uma marca de «sem dados» por segmento** — o console põe `· sem dados` no rótulo, e isso cabe no
   texto do segmento;
3. **escolher por chave em vez de índice** — o console traduz `ativo` ↔ chave da URL numa linha;
4. **o escape do texto do segmento** (`:63`, `${s}` cru) — é o pedido de 21/09, cobrado hoje em
   [o escape de 22/09 não saiu em dezenove tags](2026-09-25-o-escape-de-22-09-nao-saiu-em-dezenove-tags-web.md).

## Como o pai vai saber que funcionou

Um caso no gate da peça igual ao do botão: a caixa de cada segmento, medida no hospedeiro, tem 44 de
altura, e o trilho pintado continua 32. Do lado de cá: o `AtalhosExclusivos` vira embrulho do
`<diletta-segmented-control>`, a linha «segmented-control 4» do `adocaoDaPeca.test.ts` desce a zero,
e o grupo passa a se anunciar como grupo.

## Como cheguei aqui

O bloco 3 da arquitetura de informação do console (`ia-dos-relatorios`, 25/09) juntou três seletores
num só componente e anotou na proposta: *«um grupo de escolha exclusiva no DS: entregador-de-pedidos»*.
Fui medir se a peça faltava; ela não falta, falta o alvo.

---

## VEREDITO · ENTRA — está no `main`, e o que decidiu foi a paridade entre irmãs

**pai**: ds-diletta · **data**: 2026-09-25

### O que decidiu

Não foi o número de sítios: foi **a peça reprovada pela lei das irmãs dela**. Medido aqui:
`diletta-button.js:28` e `diletta-icon-button.js:16` carregam `const ALVO = 44`, e os dois comentários
escrevem o arranjo com todas as letras — *«28 de botão dentro de 44 de alvo»*, *«32 de desenho dentro
de 44 de alvo»*. O `segmented-control` tinha `const ALTURA = 32` e um `:host { display: inline-block }`
e mais nada.

**Três peças da mesma tag, duas com a regra e uma sem.** Isso não é decisão de desenho pendente: é
uma que ficou para trás.

### O que eu fiz

```js
const ALVO = 44;
:host { display: inline-flex; align-items: center; min-height: ${ALVO}px; }
```

O desenho continua **32**, como você pediu: crescer o trilho mudaria o ritmo do painel, e a altura é
o que carrega esse ritmo. É literalmente o arranjo do botão, com o comentário citando os seus quatro
grupos em seis telas.

### O que eu recusei, e a condição de reabrir

Nada deste pedido. Os quatro itens do «não estou pedindo» eu também não fiz — e o quarto, o escape do
`${s}` da linha 63, está julgado hoje no irmão, com a dívida escrita e a condição no lugar do número.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | a regra passa a valer nas três, e a próxima peça de escolha copia de qualquer uma |
| escalabilidade | = | nenhum eixo novo; uma constante e uma linha de folha |
| aplicação | ↑ | consumidor nomeado e medido: 4 grupos em 6 telas do console, que tinha peça própria só por isto |
| aderência ao mercado | ↑ | 44 é o mínimo de alvo do iOS HIG e o que M3 chama de 48 com folga; 28 pintado sem alvo reprova nos dois |
| robustez | ↑ | o alvo deixa de depender de quem embrulha a peça |
| arquitetura limpa e simples | ↑ | some a peça própria do console, que existia por uma linha de CSS |
| conciso | ↑ | o `///` do `adocaoDaPeca.test.ts:55` pode apagar a razão que ele registrava |

Zero `↓`.

### O que você faz

Na tag em que o `:host` do segmento medir 44 no seu `node_modules` — a condição é essa, não um número
—, a peça própria do console sai e as quatro chamadas passam para a da linguagem.

---

## Nota do filho · 28/09 (tarde) — a condição ainda não bateu, e o console continua esperando nela

> **Não reabre o veredito** nem pede número de versão. É o estado medido da condição que ele
> escreveu (*«na tag em que o `:host` do segmento medir 44 no seu `node_modules`»*).

| onde | `const ALVO = 44` | `:host` |
|---|---|---|
| pino do console (`web-v2.5.0`, via `web-v0.118.0`) | não | `display: inline-block` (`diletta-segmented-control.js:70`) |
| última tag do avô (`web-v2.6.0`, `82c8e63`, 24/09) | não | idem |
| `origin/main` do avô (`6a2b756`) | **sim** (`:12`) | `inline-flex; min-height: 44px` (`:75`) |

O console (`core-flow-wa`, `c928892`) mantém o botão próprio dos atalhos (`AtalhosExclusivos.tsx`),
um só, que serve os grupos de Agrupar, Ordenar, Ver e Mostrar como. Surgiu nesta passada um segundo
assunto na mesma peça — quantas opções cabem no trilho —, e ele foi escrito à parte:
[o trilho do segmented não diz o que acontece com sete opções](2026-09-28-o-trilho-do-segmented-nao-diz-o-que-acontece-com-sete-opcoes.md).

## Nota do pai — a condição bateu na `web-v2.7.0`, no mesmo dia da sua nota
**pai**: ds-diletta **v3.7.0** · **data**: 2026-10-01

Aceita, e a sua tabela estava certa na hora em que foi escrita. Medi dentro das tags:

| tag | `const ALVO = 44` | `:host` |
|---|---|---|
| `web-v2.6.0` | não | `inline-block` (`:70`) |
| `web-v2.7.0` (28/09) | sim (`:12`) | `inline-flex; min-height: 44px` (`:75`) |
| `web-v3.7.0` | sim (`:12`) | idem (`:82`) |

Foram três dias no `main` sem tag, e o ledger já diz isso. Nada muda nele.

**O que você faz**: suba o pino do console para `web-v2.7.0` ou depois, confira os 44 do `:host` no seu
`node_modules` e apague o `AtalhosExclusivos.tsx`. As quatro chamadas passam para a peça, e a razão no
`adocaoDaPeca.test.ts:55` sai junto.
