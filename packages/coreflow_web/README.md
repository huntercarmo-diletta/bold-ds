# O PAI na web — `coreflow-web`

Não é um design system paralelo, e não reimplementa componente nenhum. É o **`coreflow` do lado
web**: o degrau entre o avô (`diletta-design-system-web`, a linguagem) e os filhos (o Bold, a Norte
Benk, a Confia Capital — cada um com a sua tinta).

No Flutter a casa sempre teve três degraus: avô → pai → filho, e o pai é onde mora o que é de
PRODUTO sem ser de UM produto — saldo, etiqueta, comprovante, campo de valor, 60+ peças. Na web,
até 16/10/2026, eram dois: o `index.js` de cada filho fazia `export * from '#avo'` e acabava aí.
Todo veredito do avô que dizia «nasce no filho» não tinha onde nascer, e o console da Conta BOLD
montou à mão a gaveta, a ficha, a linha do tempo, o total, a barra fixa e os gráficos. A medição e
a decisão estão em `docs/propostas/2026-10-16-a-camada-web-do-coreflow.md`, aprovada pela Agatha
em 16/10. Este pacote é o passo 1 dela.

## O que ele faz

- **Importa o avô e reexporta tudo.** Quem pina o Coreflow continua recebendo cada custom element
  dele, com o mesmo nome e a mesma spec: `import 'coreflow-web'` registra o que `import
  'diletta-design-system-web'` registrava.
- **Abre o ponto de extensão `coreflow/`.** É onde as peças `<coreflow-*>` vão morar, uma por
  módulo, com o nome do elemento listado em `pecasDoCoreflow`. Hoje a lista está **vazia** de
  propósito — a regra de entrada está abaixo e dentro de `coreflow/index.js`.

## O que ele NÃO é

- **Não pinta.** Nenhuma folha sai daqui — não há `tokens/`, não há um hex. As peças do pai leem
  papéis da linguagem (`--diletta-*`), e a tinta continua vindo da folha do filho, como hoje. É o
  contrato do `coreflow` em Dart (`docs/2026-09-04-adr-o-coreflow-e-o-pai.md`): sem cor, sem
  degrau, sem asset, sem família.
- **Não é fork do avô.** Nada dele é reescrito; peça que ele aceitar depois sai daqui quando ele a
  publicar. O pai encolhe quando o avô cresce.
- **Não é o lugar de receita de uma tela só.** O campo de pergunta do Perguntar e a faixa de
  passos de Cadastros ficam no console.
- **Não mexe nos tokens.** `bold-tokens.css` e as irmãs continuam sendo o que são.

## Como um filho adota

Uma linha. Hoje o `package.json` de todo filho declara

```json
"imports": { "#avo": "diletta-design-system-web" }
```

e passa a declarar

```json
"imports": { "#avo": "coreflow-web" }
```

com `coreflow-web` nas `dependencies` no lugar do avô — que já vem dentro. O `index.js` do filho
**não muda**: continua `export * from '#avo'`, e agora recebe o avô e o pai de uma vez.

**Em 16/10 nenhum filho aponta para cá ainda.** A troca é o passo 3 da proposta, junto com a tag
`coreflow-web-v0.1.0`, e mexe no gate `todo_filho_web_usa_o_apelido_do_avo_test.dart` (que hoje
cobra o apelido apontando para o avô) e no molde `novo_filho.dart`.

Os subcaminhos do avô — `tokens.css`, `papeis.css`, `grade`, `breakpoints`, `spec`, `icones` —
continuam sendo dele: no monorepo se importam do pacote dele, e na tag publicada chegam como
`coreflow-web/avo/<subcaminho>`, derivados pela emissão do `package.json` dele. Este pacote não os
duplica, porque `exports` não pode apontar para dentro de `node_modules/` e cópia sem recibo é a
versão de ninguém.

## A ordem das folhas

O pai não tem folha; a ordem é a de sempre, e continua sendo a única pegadinha:

```html
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/diletta-tokens.css">
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/diletta-papeis.css">
<link rel="stylesheet" href=".../coreflow-design-system-web/tokens/bold-tokens.css">   <!-- a do filho -->
```

As do avô primeiro, a do filho depois. As peças do pai leem os mesmos papéis que as do avô, então
fora de ordem elas saem na tinta de referência — sem um erro no console, como o README do Bold
conta.

## A regra de entrada de peça

Três condições, **juntas**:

1. o avô **recusou** ou declarou «do produto» — pedido em `docs/pedidos/`, veredito escrito. Peça
   que ele ainda está julgando espera;
2. **mais de um produto** da casa usa ou vai usar;
3. peça que o avô aceitar depois **sai daqui** quando ele a publicar.

E nenhuma pinta: papéis, nunca um hex. Cada peça nasce da versão já revisada no console
(`core-flow-wa/src/design-system/`), com teste de contrato — atributos, eventos `mudou`, nenhum hex
— e a troca correspondente no console no mesmo dia da tag.

A primeira fila, pela medição de 16/10: `coreflow-ficha` (rótulo sobre valor), `coreflow-linha-do-tempo`,
`coreflow-total` (número grande + rótulo + detalhe), `coreflow-chip` com tom neutro (o veredito de
29/09) e a receita do item do trilho ativo. A gaveta, a barra fixa, a data com hora e os gráficos
esperam o veredito do avô (pedidos de 16/10).

## Os gates

- `packages/coreflow/test/o_pai_na_web_recebe_o_mesmo_avo_test.dart`: o pino do avô é o mesmo do
  Bold e os dois locks resolvem o mesmo commit; o pai em Dart (`ref: vX.Y.Z`) e o pai na web
  (`web-vX.Y.W`) recebem a mesma linguagem; a versão instalada é a que o pino diz (pede
  `npm install` aqui, senão pula com o motivo); e o pai não pinta.
- `uma_versao_e_uma_tag_test.dart`: o `pubspec.yaml` do `coreflow` e este `package.json` dizem o
  mesmo número — o pai em Dart é consumido por `path:` e nunca teve tag, então os dois lados andam
  juntos a partir do `0.1.0`.
- `toda_tag_web_carrega_o_pacote_test.dart`: toda `coreflow-web-vX.Y.Z` publicada entrega ESTE
  pacote na raiz, e não o repositório.

## Como ele sai daqui

Pelo mesmo espelho dos filhos:

```
sh tool/espelha_o_web.sh <tag-do-monorepo> coreflow [--seco]
```

Ele lê a versão deste `package.json`, embute o avô em `avo/` com recibo, aponta o `#avo` para a
cópia e cria a tag órfã `coreflow-web-v<versão>`. **Ainda não há tag**: a `coreflow-web-v0.1.0` é
da Agatha, no passo 3.
