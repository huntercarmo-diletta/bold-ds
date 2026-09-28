# PEDIDO · A linha de dados não consome a grade que o cabeçalho declara — e a spec diz que consome

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0` e na `origin/main` (`6a2b756`)** — os três arquivos são byte a byte os mesmos
- **bloqueante?**: **não** — o console passa a grade à linha por `::part(linha)`. Mas sem isso a lista com cabeçalho sai desalinhada, que é o defeito que a spec diz existir para evitar
- **não é peça nova**: a regra do `busca()` não se aplica. É a peça não cumprindo a própria spec

## Falta

Que a `<diletta-data-row>` desenhe as colunas com a mesma grade que a `<diletta-data-header-row>`
declara — e com o mesmo recuo.

## Número

**O contrato, escrito três vezes:**

- `specs/design-system-data-header-row/spec.md:37-38`: *«`DilettaDataHeaderRow` SHALL ser a fonte
  da largura e do alinhamento de cada coluna, e `DilettaDataRow` SHALL consumir a mesma
  declaração.»* Cenário: *«WHEN a coluna de data mede 145 no cabeçalho THEN todas as células dela
  medem 145, sem ninguém repetir o número»*;
- `diletta-data-header-row.js:4-6`: *«É a FONTE ÚNICA da grade […] e DilettaDataRow consome a mesma
  declaração»*; e `:32` chama o getter `grade` de *«o contrato entre as duas»*;
- `docs/O-QUE-A-WEB-USA.md:56`: *«é a fonte única da grade»*.

**O que a peça faz** (leitura da fonte; jsdom não faz layout, então não medi em pixel):

- o cabeçalho: `display: grid; grid-template-columns: ${this.grade}; gap: 16px` e `padding: 0 16px`
  (`diletta-data-header-row.js:50-51`), sempre;
- a linha: `display: flex; align-items: center; gap: 16px` (`diletta-data-row.js:57`), **sem grade**.
  A palavra `grade` aparece nela uma vez, num comentário sobre borda (`:67`). Cada célula ocupa o
  que o próprio conteúdo pede, e a coluna de 145 do cabeçalho não chega em ninguém;
- a lista: monta o cabeçalho **dentro do shadow dela** (`diletta-data-list.js:110-111`) e as linhas
  chegam **por slot** (`:112`) — então a linha não tem como ler a grade do cabeçalho, nem por DOM,
  nem por herança, a menos que a lista a passe;
- **o recuo**: no porte `historico` a linha é encostada (`PORTE.historico.cartao = false`,
  `diletta-data-row.js:16`) e o padding vira **0** (`:58`); o cabeçalho continua com **16**. A primeira
  coluna do corpo começa 16px antes do rótulo dela.

## Já tentei

`src/design-system/organisms/WaListaDeDados.module.css:5-15` no `core-flow-wa` (`44da813`, 28/09):

```css
.lista diletta-data-row::part(linha) {
  display: grid; grid-template-columns: var(--lista-grade); gap: 16px;
}
.lista diletta-data-row[data-porte='historico']::part(linha) { padding: var(--diletta-s2) 16px; }
```

O embrulho monta a mesma declaração duas vezes — uma no atributo `colunas` da lista, outra na
variável `--lista-grade` — que é exatamente a repetição que a spec diz que não deveria existir. Funciona
porque o `<slot>` de dentro da `.linha` é `display: contents` e as células viram itens da grade.

## Conferi no pai

- As duas specs (`design-system-data-header-row`, `design-system-data-row`) na `origin/main`. A da
  linha diz, sobre o porte `historico`: *«O porte em que a altura é do conteúdo, e não da grade»* —
  **a altura**, não a largura das colunas; o cenário da coluna de 145 continua valendo nele.
- Não há par Dart (`class DilettaDataRow` e `class DilettaDataHeaderRow`: zero em `*.dart` na
  `origin/main`), então não há paridade a preservar — só a spec.

## Derivável?

Sim, e a forma é sua. A que eu vejo, sem mecanismo novo: a lista publica a grade como **variável
CSS no próprio `:host`** (ela já tem as colunas); variável atravessa a fronteira do shadow e o
elemento de slot herda do hospedeiro em que está. A linha usa `grid-template-columns:
var(--diletta-…, none)` e cai no `flex` de hoje quando não há grade — a linha solta, sem lista,
continua como está.

## Se você disser não

Todo consumidor que usar a lista com cabeçalho repete a grade à mão, como o console fez. Quem não
repetir entrega a tabela desalinhada, e a spec continua dizendo que isso não acontece.

## Não estou pedindo

1. **grade na linha solta, sem lista** — o `flex` está certo onde não há cabeçalho;
2. **mudar a altura dos portes** — os 52/54/64 medidos ficam;
3. **a coluna de seleção** — ela abre 28 no início da linha (`:85`) e, com grade, vira mais uma
   coluna; como encaixá-la no `grid-template-columns` do cabeçalho é desenho seu.

**De passagem, sem pedir**: a declaração `Rótulo:largura:alinhamento | …`
(`diletta-data-header-row.js:25-27`) parte por `|` e `:`, então um rótulo com dois-pontos quebra a
coluna. O console troca os dois antes de passar (`WaListaDeDados.tsx:95`, `|`→`/` e `:`→`·`).
Anoto porque a mesma função é o contrato que a linha passaria a consumir.

## Como o pai vai saber que funcionou

Um caso no gate da lista: `colunas="Nome:1fr | Data:145:fim"` com duas linhas de duas células; a
segunda célula de cada linha mede 145 de largura e começa no mesmo `x` do rótulo «Data» — nos três
portes. Do lado de cá: as duas regras de `WaListaDeDados.module.css` saem e a variável
`--lista-grade` deixa de existir.

## Como cheguei aqui

Adotando a lista de dados na ficha do cadastro do console (`feat/a-adocao-do-ds-pelo-webadmin`,
`44da813`, 28/09): endereços, representantes, achados e contas, cinco listas curtas com cabeçalho.
Os rótulos não caíam sobre as colunas.
