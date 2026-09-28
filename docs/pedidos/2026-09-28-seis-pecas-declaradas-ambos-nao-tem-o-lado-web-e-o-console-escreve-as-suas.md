# PEDIDO · Seis peças declaradas `ambos` não têm o lado web — e o console escreve as suas

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0` (`82c8e63`) e na `origin/main` (`6a2b756`)**
- **bloqueante?**: **não** — o console tem as suas cópias, e elas funcionam. É o quadrado aberto que cada consumidor fecha à mão
- **não é peça nova**: as seis specs existem e declaram `"destino": "ambos"`. O `busca()` não se aplica. O `menu-button`, que a auditoria também listou, **não é o que ela precisa** — ver a seção dele no fim

## Falta

O custom element de seis peças que a própria spec promete nas duas plataformas:
`empty-state`, `loading-spinner`, `skeleton`, `section-header`, `detail-row` e `amount-display`.

## O que a spec já diz, e é o argumento

Quatro das seis carregam o mesmo comentário, datado de 06/09 (`specs/design-system-empty-state/spec.md:56-60`,
e igual em `loading-spinner`, `skeleton`, `detail-row`):

> *«`destino: ambos` acrescentado em 2026-09-06, e ele NÃO é opinião: esta peça aparece no Figma do
> BackOffice com uso medido (docs/O-QUE-A-WEB-USA.md) e já tem widget Dart aqui. [...] o quadrado
> passa a cobrar `codigo` E `codigoWeb`, e o lado web abre até o custom element existir.»*

`section-header` e `amount-display` declaram `ambos` sem o comentário. O lado Dart das seis existe
(`packages/diletta_design_system/lib/src/widgets/diletta_{empty_state,loading_spinner,skeleton,section_header,detail_row,amount_display}.dart`,
`origin/main`); o lado web não existe em versão nenhuma: `packages/diletta_design_system_web/src/`
(34 arquivos na `origin/main`, 34 em `src/` da `web-v2.6.0`) não tem nenhum dos seis.

**Não peço o que a spec não pede. Peço o lado que ela declarou aberto.**

## Número — onde o console escreve a sua (`core-flow-wa`, `c928892`)

| peça | o que o console usa no lugar | sítios |
|---|---|---|
| `empty-state` (*«vazio ou de erro: ilustração + texto que orienta + ação»*) | `shared/ui/EstadoVazio.tsx` (título + descrição + ação, **sem ilustração**), `SemPermissao.tsx`, `PermissaoInexistente.tsx`, `EstadoErro.tsx`, `relatorios/ui/SemSubstrato.tsx` | `EstadoVazio` 21 chamadas em 20 arquivos · `EstadoErro` 29 em 18 · `SemPermissao` 12 em 11 · `SemSubstrato` 4 · `PermissaoInexistente` 1 |
| `loading-spinner` | `shared/ui/EstadoCarregando.tsx` — um `<span>` girando pintado à mão, `role="status"` | 32 chamadas em 20 arquivos |
| `detail-row` (rótulo/valor) | `<dl>` à mão: `DescidaAConversa.tsx:116`, `ParadosNoPasso.tsx:88`, `FichaDaPessoa.tsx:66`, `PorTipoDeAtendimento.tsx:74`, `PainelDeSuporte.tsx:170`, `DetalheDoGestor.tsx:239`, `CarimboDeFrescor.tsx:47`, `ConsultaResolvida.tsx:92`; e o `Campo` de `TelaCliente.tsx:87` | 9, em **duas gramáticas**: rótulo 11 + valor 14 empilhados (Cadastros) e rótulo 14/600 ao lado (Acessos) |
| `section-header` (rótulo em caixa-alta acima de uma lista) | `UsoPorFuncionalidade.tsx:137` («Por superfície») e `:166` («Quem mais usou»), `.subtitulo` = `labelSm` + `uppercase` + tracking de overline (`UsoPorFuncionalidade.module.css:118-124`) | 2 contados um a um. Há **32** `text-transform: uppercase` em 24 folhas; nem todos são cabeçalho de seção, e eu não separei |
| `amount-display` (valor em destaque) | `Totais.tsx:50` (custodiado), `MovimentacaoDiaria.tsx:165` (líquido do período), `TelaTransacoes.tsx:412` («Total do período»), `WidgetDeConsulta.tsx:687` («Total da consulta») | 4 — **com a ressalva abaixo** |
| `skeleton` | **nada** | **0 no console**. A demanda medida é a sua: `Skeleton`, **56** instâncias, 2º lugar na fila da fase 4 (`figma/fila-da-web.json`; `docs/O-QUE-A-WEB-USA.md:294`) |

Medido por `grep` das chamadas no `src/` (sem teste nem story) e lido o JSX de cada `<dl>`.

## Duas ressalvas, porque são as que mais cedo voltariam como «não»

1. **`amount-display` pode não ser a mesma peça.** A spec diz *«valor em destaque num detalhe de
   transação/saldo, entre hairlines»* e *«não um valor de linha»*. Os quatro do console são **totais
   de um período** num painel — destaque, sim, mas não detalhe de uma transação. Se KPI de painel for
   outro papel, é isso que eu quero saber, e os quatro ficam como estão.
2. **`skeleton` não tem sítio nosso.** Entra na lista porque a auditoria o pediu e porque a sua fila o
   põe em segundo; se a regra da fase 4 for *«demanda do consumidor, uma a uma»*, ele não tem a nossa.

## Já tentei

Ter a peça do console. É o que existe, e é o que o ADR-007 rev.3 chama de *«coisas diferentes em dois
lugares»*: o `EstadoVazio` não tem ilustração porque a web não tem de onde tirar a do DS; o
`EstadoCarregando` gira um `<span>` com a cor que alguém escolheu; os rótulo/valor divergiram em duas
gramáticas porque não há contrato para seguir.

## Conferi no pai

- As seis specs, `"destino": "ambos"` na `origin/main`.
- `tool/fecha_o_quadrado.py:368` — *«`codigoWeb` · conta — o sétimo lado; abre até existir implementação web»*.
- `docs/ADR-007-o-ds-na-web.md:206-209`: `ambos` cobra `codigo` **e** `codigoWeb`.
- A escala de ilustração ganhou `ms` e a spec do estado vazio passou a recomendá-la (`a866265`,
  `fd7e77a`, 25/09, **sem tag**) — o `empty-state` web nasceria já com a escala certa.

## Derivável?

Em parte, e é o que o console fez. Não é derivável o que a peça decide: a ilustração do estado vazio,
o giro com a curva do DS, a hairline e o eixo de ênfase do `detail-row`.

## Se você disser não

Os embrulhos do console viram o contrato de fato para a web do Bold, e o próximo console (ou o IB)
recomeça do zero.

## Não estou pedindo

1. **ordem** — a ordem é sua. Se servir a nossa: `empty-state` e `loading-spinner` primeiro (67 e 32
   chamadas), `detail-row` depois (duas gramáticas vivas), `section-header`, e os dois da ressalva por
   último;
2. **decidir a ênfase do rótulo/valor por nós** — o `detail-row` já tem o eixo; qual valor o console
   usa é decisão de cá;
3. **o `menu-button`** — ver abaixo.

## E o `menu-button` não é o menu que o console tem

A auditoria listou `menu-button` para o menu do gestor (`app/MenuDoGestor.tsx:80-119`: gatilho com
nome e papel, `aria-expanded`, lista suspensa com `role="menuitem"`). **A spec diz outra coisa:**
*«o item de menu/atalho do DS. Um único word com três `variant`s (rail vertical, menu horizontal, card
de atalho tile)»* (`specs/design-system-menu-button/spec.md:3-5`). É o item de um trilho, não um menu
que abre.

Procurei a peça certa com `DilettaManifesto.busca`, na `v2.5.0` que este repo prende (28/09):

```
busca('menu suspenso') → []
busca('menu')          → [menu-button, app-list, file-card, rail-item, web-top-bar]
busca('popover')       → []
```

E no `manifesto.json` da `origin/main`, por texto, *«suspens»* só acha o `dropdown` — que é o campo
de seleção. Pedir `menu-button` na web seria pedir a peça
errada, então **não peço**. Fica registrado que o menu suspenso de ações não tem nome na linguagem, e
que o consumidor tem um sítio (`MenuDoGestor`) — a sua fila tem `Menu`, 26 instâncias, marcado como
local do arquivo de produto. Quando houver o segundo sítio medido, vira pedido de peça nova.

## Como o pai vai saber que funcionou

O quadrado fecha `codigoWeb` nas seis. Do lado de cá, `EstadoVazio` e `EstadoCarregando` viram
embrulho da peça, e os nove rótulo/valor passam a uma gramática.

## Como cheguei aqui

Pela passada «o DS em tudo» do webadmin (tarefa 1.12 de `arquitetura-de-informacao-do-console`,
`c928892`, 28/09). Três auditorias, cada uma, listou parte destas peças (casca e login: `empty-state`,
`loading-spinner`, `skeleton`, `menu-button`; Painel e Relatórios: `amount-display`, `detail-row`,
`empty-state`, `section-header`; Cadastros: `detail-row`, `section-header`). Este arquivo funde as
três listas e refaz as contagens no código.

---

## VEREDITO · ENTRAM QUATRO, UMA É OUTRA PEÇA, UMA ESPERA — e nenhuma nesta tag

**pai**: ds-diletta **v2.8.0** · **data**: 2026-09-28

| peça | veredito |
|---|---|
| `empty-state` | **ENTRA**, primeiro: 67 chamadas suas |
| `loading-spinner` | **ENTRA**, junto: 32 chamadas |
| `detail-row` | **ENTRA**: duas gramáticas vivas, e o eixo de ênfase já existe |
| `section-header` | **ENTRA**: 2 sítios contados um a um |
| `amount-display` | **É OUTRA PEÇA**: os seus quatro são totais de período, e a spec diz *«não um valor de linha»*, é o detalhe de uma transação |
| `skeleton` | **ESPERA**: zero sítios no consumidor |

### O que decidiu

A sua frase: *«Não peço o que a spec não pede. Peço o lado que ela declarou aberto.»* O `ambos` é
meu, de 06/09, e ele cobra `codigoWeb`. Seis peças com a web prometida e zero entregues é a mesma
dívida que o ledger já declarou em outros três lugares.

### Por que não sai hoje

As seis têm **zero** linhas na tabela de pintura da web (`pintura.g.js`). A condição, por peça:

- a peça entra na tabela de resolução medida no render do Dart;
- o custom element resolve do seu `node_modules`, e o `empty-state` já com a escala de ilustração
  que tem `ms`;
- o quadrado fecha `codigoWeb` da peça.

A ordem é a sua: `empty-state` e `loading-spinner` no primeiro lote, `detail-row` e `section-header`
no segundo.

### O que eu achei indo implementar

A régua de paridade do pai lista **12** peças `ambos` sem instância web, e não 6: `app-list`,
`icon-accessory`, `list-tile`, `search-input`, `stepper` e `upload` também. O aviso que fica é a 13ª.
A fila é minha, e ela é maior do que o seu pedido.

### O que eu recusei, e a condição de reabrir

- **`amount-display` para KPI de painel.** Reabre com o segundo filho medindo total de período em
  painel. Aí é peça nova, com nome próprio, e não o `amount-display` esticado;
- **`skeleton` agora.** Reabre no primeiro sítio contado de consumidor web. A fila do Figma (56) é
  desenho, não adoção;
- **o menu suspenso de ações**: fica registrado como 1º caso, com o seu `MenuDoGestor`. O segundo sítio
  medido vira pedido de peça nova.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | embrulhos que divergem viram peça com contrato |
| escalabilidade | ↑ | o próximo consumidor web não recomeça do zero |
| aplicação | ↓ | **dívida declarada**: 67 + 32 + 9 + 2 chamadas seguem nos embrulhos até a condição |
| aderência ao mercado | = | estado vazio, carregando e rótulo/valor são peças comuns de DS web |
| robustez | ↑ | a peça sai da tabela medida, não de uma leitura minha |
| arquitetura limpa e simples | = | é o outro lado de peças que já existem |
| conciso | = | nada novo além das chamadas |

### O que você faz

Nada até a condição. Os seus embrulhos seguem. Os quatro totais de período ficam como estão.

---

## Nota do pai · 28/09 — a condição bateu para três, e as três saíram

**pai**: ds-diletta **v2.9.0** · **data**: 2026-09-28

A condição do veredito era a peça entrar na tabela medida no render do Dart. Pus as três primeiras no
teste de resolução, o gerador as aceitou limpas, e as peças web pintam de lá. O quadrado fecha
`codigoWeb` nas três.

- `<diletta-empty-state titulo legenda icone acao>`: cartão `surface` com borda `divider` e raio 24,
  título `subheading` em `fg`, legenda `caption` em `textTertiary`, a ação como botão `md` que emite
  `acao`, e a ilustração pelo slot `ilustracao`;
- `<diletta-loading-spinner size="sm|md|lg" trilho rotulo>`: 22/40/60, traço 2/3/4, arco de 90% em
  degradê de `primary`, uma volta a cada `--diletta-duration-spinner`, e `role="status"`;
- `<diletta-detail-row titulo descricao enfase porte chevron sem-regua>`: os dois portes e as duas
  ênfases do Dart, régua `divider`, e os slots `inicio` (o spot) e `fim` (o acessório). Das suas duas
  gramáticas, a peça é a «ao lado». A empilhada, rótulo 11 sobre valor 14, não é a anatomia dela.

**As três escrevem o seu texto por `textContent`**, e não no template: nascem fora da dívida do escape.

Uma diferença declarada: o spot do Dart lê o degrau cru (`neutral10` / `neutral02`), e a web pinta
`surfaceSubtle`. No claro são o mesmo cinza; no escuro o papel fica meio passo acima.

**O `section-header` continua fora, e o motivo é meu:** a tabela dele chaveia por `Tone`, que o Dart
tem e o contrato não declara. O gerador recusa com razão. A condição passa a ser declarar o eixo.

**O que você faz:** `web-v2.9.0`. `EstadoCarregando`, `EstadoVazio` e os nove rótulo/valor viram
chamada da peça. O glifo padrão do vazio vem da biblioteca de ícones que você registra, como o de
qualquer `<diletta-icon>`.
