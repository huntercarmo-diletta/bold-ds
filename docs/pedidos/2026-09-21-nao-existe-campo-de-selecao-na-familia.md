# PEDIDO · Não existe campo de SELEÇÃO na família — nem no Dart, nem na web

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — o consumidor tem a peça dele e ela funciona. Mas é vocabulário
  básico faltando, e enquanto faltar cada filho desenha o seu.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), terminando a adoção do
> DS. Ele foi listar o que ainda é peça local e por quê, e este é o único caso em que a
> resposta não é «trava por defeito» nem «o app não tem» — é que a peça não existe.

## O caso, em uma linha

Escolher UM valor entre muitos não tem componente na família.

## O que procuramos, e onde

Nos **25 elementos web**: nenhum `select`, `dropdown`, `combobox` ou `listbox`. O
`<diletta-input>` declara `type` com três valores — `text`, `password`, `long` — e nenhum
deles é seleção.

Nas **61 peças Dart** do `coreflow`: idem. O que existe é vizinho e resolve outra coisa:

| peça | o que ela resolve | por que não serve |
|---|---|---|
| `coreflow_campo_de_texto` | digitar texto livre | não há lista de opções |
| `coreflow_segmentos` | escolher entre POUCAS, todas visíveis | não escala: o console tem selects de 8+ opções |
| `coreflow_chip_de_filtro` | ligar/desligar filtros | é múltipla escolha, e some do fluxo de formulário |
| `coreflow_ladrilho_de_menu` | navegação | não devolve valor |

## Onde isso dói, medido

No webadmin: **4 usos** de campo de seleção em 3 telas — perfil do gestor, natureza e
confiança na fila de KYC. São formulários, não filtros: o valor escolhido é submetido.

Não é volume; é **vocabulário**. Um produto da família que precise de "escolha um entre
muitos" hoje tem três saídas, todas ruins: desenha a sua (o que fizemos), força
`segmentos` numa lista que não cabe, ou usa `<select>` cru e perde a tinta.

## O que a nossa peça faz, para o pedido não pedir menos do que já existe

`WaCampoSelect` é um `<select>` nativo com rótulo, e a razão de ser nativo está no `///`
dela: o `<select>` do sistema traz busca por digitação, rolagem com teclado e o painel do
sistema operacional no celular — coisas que um dropdown desenhado à mão perde e quase nunca
recupera.

Então o pedido **não é** «um dropdown desenhado». É a peça da linguagem em volta do
controle nativo: rótulo, estados (repouso, erro, desabilitado), mensagem de ajuda e de
erro — exatamente o que o `<diletta-input>` já faz para texto.

## O pedido

Um `type` de seleção no `<diletta-input>`, ou um `<diletta-select>` irmão dele, com o
mesmo eixo de estado e as mesmas folgas de acessório. O conteúdo (as `<option>`) vem por
slot, do consumidor, como o `<select>` nativo espera.

Se a casa preferir que a peça nasça no filho, também serve — mas aí vale declarar, porque
hoje a ausência não está escrita em lugar nenhum, e cada filho a descobre sozinho.

## Uma observação sobre a ordem

Este é o terceiro caso desta família que encontramos ao adotar: o `Dialog`/`folha` sem
instância web (pedido irmão, de hoje), o `DilettaStepper` que o IB reportou em 17/09, e
agora a seleção. Os três têm a mesma forma — **não é recurso que ficou para trás dentro de
uma peça, é peça que não existe** —, e os três só aparecem quando alguém tenta trocar tudo
e lista o que sobrou.

Se for útil, o inventário que o webadmin fez (25 elementos × as peças locais de cada
filho) é barato de repetir e acha os próximos.

---

## VEREDITO · ENTRA na fila da web — e a peça já existe, num degrau que a sua busca não varreu
**pai**: ds-diletta **v0.203.0** · **data**: 2026-09-21

O pedido está certo no que dói e errado na premissa, e a diferença entre os dois muda o que você
faz amanhã.

### A correção: `DilettaDropdown` existe, e é declarada como peça que atravessa

Na **linguagem**, não no `coreflow`. Ela tem `items`, `value`, `onChanged`, `label`, `placeholder`,
`error`, `disabled`, `moldura`, `pesquisavel`, e ainda `escolhidos`/`onChangedMulti` para múltipla
escolha. E a spec dela diz **`destino: ambos`** — ou seja, a linguagem já declarou que esta peça tem
que existir nos dois lados.

Ela está listada, com esse nome, na saída da régua que saiu na `v0.201.0`: *"SEM INSTÂNCIA WEB — 13
peças de `destino: ambos`"*, e `dropdown` é uma delas. **A ausência estava escrita**, e escrita num
lugar que nasceu de um pedido seu.

### Onde a sua busca parou, e por que isso vale mais que o caso

Você escreveu: *"nas 61 peças Dart do `coreflow`: idem"*. O `coreflow` é o **degrau do meio** — a
base de produto da sua família. A linguagem é o degrau de cima, e é lá que a peça mora.

> **Procurar vocabulário no degrau do meio e concluir que a família não tem é a mesma classe do
> «pedido do neto»**: o nível existe, a busca não o conhece, e a resposta sai confiante.

Não é reparo em você: é que o ADR-003 declara três degraus desde 08/09 e **eu nunca escrevi como se
procura neles**. Enquanto isso não existir, todo filho vai varrer o que tem à mão. Está no ledger,
com a origem neste pedido.

### O que ENTRA, e é o que você pediu de verdade

A **instância web** do `design-system-dropdown`, e ela nasce em volta do `<select>` NATIVO — o seu
argumento ganha, inteiro:

> *"o `<select>` do sistema traz busca por digitação, rolagem com teclado e o painel do sistema
> operacional no celular — coisas que um dropdown desenhado à mão perde e quase nunca recupera"*

Isso não é divergência da peça Dart: é o que «instância» quer dizer no ADR-007. A spec é uma, o
mecanismo de cada plataforma é o dela — no Flutter o painel é uma folha, no navegador é o controle
nativo. O que atravessa é o contrato: rótulo, estados, ajuda, erro, e as folgas de acessório.

**Não sai nesta tag.** Ela entra na fila da web com as outras 13, e a ordem daquela fila é medida —
peça por uso e por tela. Com o seu caso, ela passa a ter dois consumidores declarados.

### O que você faz enquanto isso

Fica com a `WaCampoSelect` e escreve no `///` dela a linha que hoje não existe em lugar nenhum: **que
ela é local até a instância web sair, e que a peça da linguagem é o `DilettaDropdown`.** Sem essa
linha, a próxima pessoa a abrir o arquivo refaz esta pesquisa.

### E o inventário que você ofereceu, eu quero

*"os 25 elementos contra as peças locais de cada filho, com a razão escrita de cada sobra"* — é o
terceiro instrumento que você me oferece nesta semana, e é o que acha os próximos três. Mande o do
webadmin como molde, sem prazo.

### ADENDO — 2026-09-21, algumas horas depois · **saiu**

O veredito dizia *"não sai nesta tag"*, e mudou de ideia por um motivo só: a peça irmã (o diálogo)
estava na mesma fila, e as duas juntas custam menos que as duas separadas — o mesmo gate, o mesmo
bloco de catálogo, a mesma rodada de medição.

`<diletta-dropdown>` está na **`web-v0.205.0`**.

**A API é a que você pediu**: as `<option>` na luz, do consumidor. A mecânica não pôde ser slot, e a
razão é do HTML: **`<option>` slotada não renderiza dentro de um `<select>` que mora no shadow** — o
controle só desenha os filhos da árvore dele. Então a peça ESPELHA a luz para dentro do controle a
cada `slotchange`, e o espelho se refaz inteiro. A luz continua sendo a fonte.

O que veio junto e você não pediu: `moldura` (`caixa` e `silencioso`, os dois valores do eixo do
Dart), o anel de foco na lei nova, e `erro` com texto implicando o estado — a mesma regra do campo,
de propósito.

O que **não** veio: a `ajuda`. Eu tinha posto, e tirei antes de publicar — o `DilettaDropdown` do
Dart não tem `helper`, e instância que declara o que a linguagem não declara é o começo de a web
virar coisa diferente. Se você precisar, é pedido com medição, e o campo nasce nos dois lados.

Dívida declarada na régua: a múltipla escolha (`escolhidos` + `onChangedMulti`) tem `<select
multiple>` do outro lado e ninguém pediu ainda.
