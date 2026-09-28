# PEDIDO · Treze peças web publicam GETTER sem setter com o nome do próprio atributo — e o React 19 estoura ao passar a prop

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0` e na `origin/main` (`6a2b756`)** — os arquivos citados são byte a byte os mesmos nas três
- **bloqueante?**: **não para entregar tela** — o console escreve o atributo por `ref`. Mas é o primeiro contato de qualquer consumidor React com estas peças, e ele termina em exceção
- **não é peça nova**: a regra do `busca()` não se aplica

## Falta

Que passar uma prop a uma peça web pelo JSX não estoure quando a peça tem um getter com o nome do
atributo.

## Número

**Executado, não lido**: o React 19.2 do console (`react-dom` 19.2.8) renderizando cada peça da
tag instalada em jsdom, **uma prop por vez, para cada atributo de `observedAttributes`** — 29 peças,
142 atributos. Resultado:

```
16 atributos, em 13 de 29 peças, estouram com
  «Cannot set property <nome> of #<Diletta…> which has only a getter»

diletta-data-cell           conteudo  alinhamento     (:33, :38)
diletta-data-column-header  ordenacao                 (:33)
diletta-data-header-row     colunas                   (:23)
diletta-data-list           porte                     (:27)
diletta-data-row            porte                     (:32)
diletta-file-card           estado  previa            (:39, :44)
diletta-pagination          paginas  atual            (:34, :35)
diletta-rail-item           forma                     (:46)
diletta-segmented-control   segmentos                 (:51)
diletta-tab-item            estado                    (:21)
diletta-tabs                desligadas                (:48)
diletta-web-stepper-node    estado                    (:32)
diletta-web-top-bar         sessao                    (:19)
```

Controle: `<diletta-text-link href target>` pelo mesmo caminho renderiza e o `target` chega como
atributo — ela não tem getter com esses nomes.

**O porquê**: para elemento customizado, o React 19 escreve a prop como PROPRIEDADE quando
`nome in elemento`, e como atributo só quando não. O getter no protótipo faz o `in` dar verdadeiro;
sem setter, a atribuição em módulo (modo estrito) lança. **A família inteira tem zero setters**
(`grep '^\s*set \w+('` em `src/*.js`: nenhum).

O getter em si está certo — ele valida o valor e devolve o padrão (`CONTEUDO.includes(v) ? v :
'texto'`). O defeito é só o nome: ele coincide com o atributo, e isso o torna alvo da escrita.

## Já tentei

`src/design-system/atoms/comAtributos.ts` no `core-flow-wa` (`44da813`, 28/09): um gancho
`useAtributos` que escreve os atributos por `ref`, depois de cada render. Usado em
`WaListaDeDados.tsx:97` e `WaCartaoDeArquivo.tsx:35`. Funciona, e custa o JSX: a peça passa a ser
declarada sem props (`'diletta-file-card': { ref?: …; children?: … }`), e o tipo deixa de dizer quais
atributos ela aceita.

O remendo é por peça. O consumidor só descobre que precisa dele quando a tela quebra — e as outras
nove peças da lista ainda não foram adotadas no console.

## Conferi no pai

- `origin/main`, `packages/diletta_design_system_web/src/`: os 16 getters estão onde a tabela diz;
  nenhum arquivo tem `set`.
- `src/grade.js:10` já diz que a página é montada *«com React, Astro, Lit ou…»* — o React está no
  horizonte declarado da instância web.
- Não achei, em spec nem em `README` do pacote web, regra sobre propriedade × atributo.

## Derivável?

Sim, de duas formas, e a escolha é sua:

1. **setter espelho**: `set porte(v) { this.setAttribute('porte', v); }` ao lado de cada getter —
   o atributo continua sendo o contrato, e a propriedade vira porta para ele (é o que os elementos
   nativos fazem: `input.value`, `a.href`);
2. **nome interno distinto**: `get _porte()` / `#porte()` — o `in` passa a dar falso e o React cai
   no atributo.

A 1 deixa um lugar para decidir o que `el.porte = undefined` quer dizer (provavelmente
`removeAttribute`). **Não medi** o que o React escreve quando a prop sai do JSX — digo, em vez de
afirmar.

## Se você disser não

Cada consumidor React escreve o seu `useAtributos`, peça a peça, na hora em que a tela quebra. O
`ib` vai encontrar isto na primeira lista ou na primeira paginação que adotar.

## Não estou pedindo

1. **suporte a propriedade rica** (passar objeto em vez de string) — o atributo como contrato está
   certo;
2. **mudar o que o getter devolve** — a validação dele fica;
3. **tipos TypeScript das peças** — é outro assunto.

## Como o pai vai saber que funcionou

Um caso no gate da instância web que faça o que o React faz: para cada peça, para cada nome em
`observedAttributes`, `el[nome] = 'x'` **não lança**, e depois disso `el.getAttribute(nome)` é o
que foi escrito (ou a peça declara, por nome, que aquele atributo não tem propriedade). Do lado de
cá: `comAtributos.ts` sai, e as peças voltam a ser declaradas com as props no JSX.

## Como cheguei aqui

Adotando `data-list`, `data-row`, `data-cell` e `file-card` na ficha do cadastro do console
(`feat/a-adocao-do-ds-pelo-webadmin`, `44da813`, 28/09), a tela estourou na primeira prop. O chat
remendou por `ref` e passou a lista das quatro; a varredura das 29 é deste pedido.

---

## VEREDITO · ENTRA — a forma 1, o setter espelho, e ele nasce num lugar só

**pai**: ds-diletta **v2.7.0** · **data**: 2026-09-28

### O que decidiu

A sua frase: *«O getter em si está certo […] O defeito é só o nome: ele coincide com o atributo, e
isso o torna alvo da escrita.»* Ela diz que o conserto não mexe no getter. Repeti a medição sem o
React, escrevendo `el[nome] = 'x'` em cada atributo observado das 29 peças: **16 atributos, 13
peças**, os mesmos da sua tabela. Zero setters na família, como você contou.

### O que eu fiz

`registra(nome, Classe)` na `base.js`, e as 29 peças passam por ela em vez de chamar
`customElements.define` direto. Antes de registrar, ela dá setter a todo getter que tem o nome de
um atributo observado. O setter escreve no ATRIBUTO, que continua sendo o contrato:

- string vira `setAttribute(nome, valor)`;
- `null`, `undefined` e `false` removem o atributo;
- `true` liga o atributo vazio.

Não medi o que o React 19 escreve quando a prop sai do JSX. Com `undefined` removendo o atributo, o
resultado é o mesmo nos dois caminhos.

### O que eu achei indo implementar

A classe fecha na base, não nas treze. **Getter novo com nome de atributo já nasce com a porta.** O
gate novo (`a_familia_fecha_as_tres_portas.test.js`) pergunta às 29 instaladas, não às 13 da lista.

### O que eu recusei, e a condição de reabrir

**A forma 2, o nome interno.** Ela apaga a API de propriedade que o elemento nativo tem (`a.href`,
`input.type`) só para o React cair no atributo. Reabre se aparecer um getter cujo valor lido não
possa virar atributo de volta. Hoje nenhum dos 16 é assim.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma função na base, não 16 setters escritos à mão |
| escalabilidade | ↑ | a peça 30 nasce com a porta sem ninguém lembrar |
| aplicação | ↑ | o console apaga o `useAtributos`, e o `ib` não precisa escrever o dele |
| aderência ao mercado | ↑ | propriedade que reflete atributo é o nativo e é o Lit |
| robustez | ↑ | a exceção no primeiro render some, e o gate executa em vez de ler |
| arquitetura limpa e simples | = | a base já registra ajudantes, e `registra` é mais um |
| conciso | = | o consumidor não escreve nada novo |

### O que você faz

`web-v2.7.0`. O `comAtributos.ts` sai, e as peças voltam a ser declaradas com as props no JSX.
