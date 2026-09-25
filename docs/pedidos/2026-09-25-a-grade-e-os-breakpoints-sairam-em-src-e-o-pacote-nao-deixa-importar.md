# PEDIDO · A grade e os breakpoints saíram em `src/` — e o `exports` do pacote não deixa ninguém importar os dois

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido na `web-v2.6.0`**, que é onde a grade nasceu
- **bloqueante?**: **não** — o console segue com as cópias declaradas; mas as duas respostas de 24/09 dizem ao consumidor que as cópias viram apelido, e hoje não podem
- **irmãos**: [a web não tem breakpoint](2026-09-24-a-web-nao-tem-breakpoint-e-o-dart-tem.md) · [a web de backoffice não tem grade](2026-09-24-a-web-de-backoffice-nao-tem-grade.md) — os dois ENTRA; este é sobre a entrega deles

## Falta

Um caminho de importação para `src/breakpoints.js` e `src/grade.js`.

## Número

Medido com o Node 22, a árvore da tag `web-v2.6.0` instalada como `node_modules/diletta-design-system-web`:

```
import('diletta-design-system-web/src/grade.js')          → ERR_PACKAGE_PATH_NOT_EXPORTED
import('diletta-design-system-web/src/breakpoints.js')    → ERR_PACKAGE_PATH_NOT_EXPORTED
import('diletta-design-system-web/elementos/grade')       → ERR_MODULE_NOT_FOUND
import('diletta-design-system-web')                       → HTMLElement is not defined
```

- `package.json` (`web-v2.6.0`), `exports`: `.`, `./elementos/*` → `./src/diletta-*.js`, as folhas, o
  catálogo, `./spec`, `./icones` e a ponte. **`breakpoints.js` e `grade.js` não casam com nenhum** — o
  curinga só alcança arquivo que começa com `diletta-`.
- `index.js` (`web-v2.6.0`) reexporta as 29 peças, `papeisDe`, `tinta`, `estiloDa`, `eixo` e `pintura`.
  **Nem `BREAKPOINTS`, nem `GRADE`, nem `LAYOUTS`, nem `porLinha`.** E mesmo que reexportasse, a raiz
  não serve para quem precisa só do número: importá-la registra as 29 peças, e fora do navegador (um
  gate em Node, um script de build) ela estoura na primeira linha — a quarta linha acima.
- A instância deste repo (`coreflow-design-system-web`) faz `export * from '#avo'`: repassa a raiz, e
  herda a mesma falta.

## Já tentei

O console mantém as duas cópias, como os pedidos irmãos descreviam: `src/design-system/tokens/breakpoints.ts`
(a tabela em rem, com gate) e `src/design-system/organisms/WaGrade.tsx`. O `///` do primeiro já diz,
desde que o pino subiu para a `web-v2.5.0`: *«O módulo ainda NÃO está no `exports` do pacote, então
este arquivo continua sendo a tabela em rem — agora CONFERIDA contra o token emitido»*. A conferência
lê `--diletta-breakpoint-*` da folha, porque é o que se alcança; os números em JS continuam cópia.

## Conferi no pai

- O aviso da `v2.6.0` (`docs/avisos/2026-09-24-v2-6-0-a-largura-a-grade-e-o-porte-que-eu-devia.md`
  neste repo): *«`--diletta-colunasDoConteudo: 12` + `src/grade.js` — a `WaGrade` vira consumidora dos
  cinco nomes em vez de dona deles»*. E o `CHANGELOG` da `v2.6.0`, em «O que você faz»: *«Nada. Se
  você mantinha um token de largura de produto ou uma grade própria, os dois viram apelido»*. O token
  de largura vira (é CSS); a grade, não.
- O gate `a_grade_do_conteudo_e_uma_so.test.js`, que o aviso manda consultar, importa a grade pelo
  caminho relativo do repo (`test/a_grade_do_conteudo_e_uma_so.test.js:13`, `from '../src/grade.js'`) — então ele passa, e passaria com o `exports` como está. Mede o arquivo, não
  o pacote que o consumidor instala. É a forma que a casa já registrou: *entrega se mede no repo de
  quem recebe* — aqui, no `node_modules` de quem recebe.
- `src/grade.js:27` importa `./breakpoints.js` — os dois andam juntos, e uma saída que libere um só não
  resolve.

## Derivável?

Não pelo consumidor: o `exports` fecha exatamente o caminho que resolveria.

## Se você disser não

As duas cópias ficam, e a promessa das duas respostas de 24/09 («viram apelido») não se cumpre. O
`ib`, que é quem mais ganharia com a grade publicada, não tem como consumir o número que a linguagem
escreveu.

## Não estou pedindo

1. **mudar a grade ou os breakpoints** — os números e os cinco nomes estão certos;
2. **reexportar pela raiz** — pela razão da quarta linha do «Número», a raiz carrega o registro das
   peças; um subcaminho próprio (ou dois) serve melhor, e a escolha é sua;
3. **peça `<diletta-grade>`** — o veredito de 24/09 decidiu dado, e dado é o que se precisa importar.

## Como o pai vai saber que funcionou

Um teste no pacote que resolve os dois módulos pelo NOME do pacote, e não pelo caminho relativo — o
que falha hoje com `ERR_PACKAGE_PATH_NOT_EXPORTED`. Do lado de cá: `breakpoints.ts` vira reexport, a
`WaGrade` lê `LAYOUTS` e `porLinha()`, e o gate `breakpoints.test.ts` compara a tabela com o módulo, e
não mais com a folha.

## Como cheguei aqui

O item estava anotado como pendente desde que o pino subiu para a `web-v2.5.0` (24/09), no `///` do
`breakpoints.ts`. Na `web-v2.6.0` a grade nasceu no mesmo diretório, com a mesma falta — o que fez da
nota um pedido.
