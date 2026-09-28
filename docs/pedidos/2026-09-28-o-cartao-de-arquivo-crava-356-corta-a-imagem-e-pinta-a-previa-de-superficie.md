# PEDIDO · O cartão de arquivo crava 356, corta a imagem e pinta a prévia de superfície

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0` (`src/diletta-file-card.js`) e na `origin/main` (`6a2b756`)** — as linhas citadas são as mesmas nas três
- **bloqueante?**: **não** — os logotipos da tela de Marca continuam numa miniatura feita à mão
- **irmão**: [a lista da âncora ficou no link de texto — e o cartão de arquivo abre na mesma aba](2026-09-28-a-lista-da-ancora-ficou-no-link-de-texto-e-o-cartao-de-arquivo-abre-na-mesma-aba.md) (mesma peça, outro assunto: o `target` do nome). E a nota de 28/09 no [escape](2026-09-25-o-escape-de-22-09-nao-saiu-em-dezenove-tags-web.md) cobre o `nome` interpolado cru — **não repito aqui**
- **não é peça nova**: o `busca()` não se aplica

## Falta

Três coisas na mesma folha do `<diletta-file-card>`, para ele servir a um arquivo de **imagem que
precisa ser vista inteira**:

1. **largura que não passe da coluna** — hoje é cravada;
2. **a prévia mostrar a imagem inteira** (`contain`) — hoje corta (`cover`);
3. **o fundo da prévia declarável** — hoje é sempre `surface`.

## Número

A folha, igual no pino, na `web-v2.6.0` e na `origin/main`:

```
diletta-file-card.js:77   :host { display: inline-block; }
diletta-file-card.js:79   .cartao { box-sizing: border-box; width: 356px; height: 154px | 152px; ... }
diletta-file-card.js:81             background: var(--diletta-surface); ...
diletta-file-card.js:87   .previa img { width: 100%; height: 100%; object-fit: cover; }
diletta-file-card.js:103  <div class="cartao" part="cartao">     ← o único `part`; a `.previa` não tem
```

O sítio é a tela de Marca do console (`TelaConfiguracao.tsx:456-500`, `CampoDeLogotipo`, `c928892`):
três logotipos por marca — *«sobre fundo claro»*, *«sobre a cor da marca»* e o símbolo
(`configuracao/model/documento.ts:65-78`). Com o cartão:

- **a largura**: a coluna de controles é a `lista-detalhe` da grade, 5 de 12
  (`TelaConfiguracao.module.css:220-221`), e a auditoria de 28/09 **mediu 353px** no DOM a 1440. O
  cartão tem 356 — **transborda 3px** na maior largura, e mais em qualquer menor;
- **o corte**: um logotipo é uma faixa larga e baixa; `cover` num quadro de prévia corta as pontas
  da marca. A miniatura à mão usa `object-fit: contain` (`TelaConfiguracao.module.css:313`) por isso;
- **o fundo**: o *«logotipo sobre a cor da marca»* é, quase sempre, branco. Sobre `surface` (branco no
  claro) ele **some**. A tela precisa pintar a prévia desse papel com a cor da marca que está sendo
  editada.

## Já tentei

1. **A miniatura à mão** (`.miniatura`, 80×32, `contain`, borda e `surface` —
   `TelaConfiguracao.module.css:309-318`). É o que está lá; tem o mesmo defeito de fundo, e não é a
   peça.
2. **`::part(cartao)`** — é o único `part`, e em tese deixa o consumidor mandar na largura (a regra de
   fora vence a do shadow). **Não executei**, e não quero depender disso: seria o consumidor
   desobedecendo o *«SHALL ... a mesma largura de 356»* da spec por fora. E a prévia não tem `part`,
   então `contain` e fundo não se alcançam de jeito nenhum.

## Conferi no pai

- `specs/design-system-file-card/spec.md:53-56`: *«Os dois SHALL ter a mesma anatomia [...] e a mesma
  largura de 356»* — o requisito é que **vazio e anexado tenham a mesma largura**; o 356 é a medida
  do Figma. Uma largura `min(356px, 100%)` mantém os dois iguais e para de transbordar.
- `:46`: *«`Previa.imagem` — quando dá pra ver, ver ganha de qualquer rótulo»*. Imagem cortada é ver
  pela metade.
- `:107`: os quadros de referência (`noFiles`, `errorFile`, 200×200) e o cartão 356×154 — nenhum
  mede logotipo; a spec nasceu de documento.

## Derivável?

A largura, talvez, pelo `part` (não medido). O ajuste e o fundo da prévia, não.

## Se você disser não

O console mantém a miniatura dele, e os logotipos ficam fora da peça que a casa tem para arquivo —
a tela de Marca é justamente onde o gestor sobe arquivo.

## Não estou pedindo

1. **mudar o `cover` de documento** — se `cover` for o certo para foto de documento, um eixo ou
   atributo resolve; a forma é sua;
2. **a prévia maior** — os 154 continuam;
3. **o estado `vazio` com entrada de arquivo** — o console não usa, e a zona de arrastar é outra peça
   (`Upload-input`, como a própria spec diz);
4. **o nome em nova aba** e **o escape** — são dos irmãos acima.

## Como o pai vai saber que funcionou

Num hospedeiro de 353px o cartão mede 353, e não 356. Com a imagem de um logotipo de 4:1, a prévia
mostra a imagem inteira. E a prévia aceita um fundo vindo de quem chama (o seu mecanismo: atributo,
variável ou `part`). Do lado de cá: `CampoDeLogotipo` vira `WaCartaoDeArquivo`, e a `.miniatura` sai.

## Como cheguei aqui

Pela passada «o DS em tudo» do webadmin (tarefa 1.12 de `arquitetura-de-informacao-do-console`,
`c928892`, 28/09): a auditoria de Marca e Conversas tentou pôr os logotipos no cartão e contou por que
não cabe. Os números da folha são deste pedido; o 353 é da auditoria.

---

## VEREDITO · ENTRA — os três, e o fundo entra como porta, não como atributo

**pai**: ds-diletta **v2.8.0** · **data**: 2026-09-28

### O que decidiu

A sua leitura da minha spec: *«o requisito é que vazio e anexado tenham a mesma largura; o 356 é a
medida do Figma»*. Estava certa. O teto preserva a igualdade e para de transbordar.

### O que eu fiz

- **largura**: o hospedeiro tem 356 e `max-width: 100%`, e o cartão ocupa o hospedeiro;
- **enquadramento**: eixo novo `enquadramento`, com `cortar` como default (foto de documento) e
  `inteira` (logotipo). Ele está na spec, com a sua contagem de três logotipos por marca;
- **fundo da prévia**: `part="previa"`. O fundo é a cor da marca que está sendo editada, e isso é
  conteúdo da sua tela, não valor da linguagem. A peça abre a porta, e quem chama pinta.

**Medido no Chrome:** coluna de 353 dá cartão de 353; coluna de 900 dá 356. Com `inteira` a imagem sai
em `contain`. `::part(previa) { background: … }` pinta a prévia.

### O que eu achei indo implementar

**O `foto` também entra cru, no `src` da imagem.** A nota de 28/09 no escape contou o `nome` e o
`apoio` do cartão, e não o `foto`. Ele vai para a conta da dívida do escape.

### O que eu recusei, e a condição de reabrir

**O fundo como atributo.** Reabre se aparecer um fundo de prévia que seja da linguagem, e não do
conteúdo: por exemplo, um papel que todo produto use atrás de logotipo.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | a miniatura à mão sai, e a tela de Marca usa a peça |
| escalabilidade | ↑ | toda coluna menor que 356 para de transbordar |
| aplicação | ↑ | os três logotipos entram no cartão, e o branco sobre a marca aparece |
| aderência ao mercado | ↑ | `object-fit` e `::part` são a forma nativa |
| robustez | ↑ | medido em pixel nos três casos |
| arquitetura limpa e simples | = | um eixo e uma porta, nenhum atributo de cor |
| conciso | = | nada novo além do eixo |

### O que você faz

`web-v2.8.0`. `CampoDeLogotipo` vira `WaCartaoDeArquivo` com `enquadramento="inteira"`, e o logotipo
sobre a marca pinta `::part(previa)`. A `.miniatura` sai.
